-- Booking on the server, so two devices can never promise the same unit.
--
-- The app checks availability itself for a fast answer, then asks the
-- server to confirm. Here Postgres is the referee: every booked unit gets a
-- claim over its dates, and an exclusion constraint refuses two claims on one
-- unit that overlap. Windows are half-open ('[)'), so back-to-back rentals
-- never clash, the same rule the app uses.

create table public.serial_claims (
  serial_id uuid not null references public.serials (id),
  line_id uuid not null references public.order_lines (id),
  order_id uuid not null references public.orders (id),
  period tstzrange not null,
  primary key (serial_id, line_id),
  constraint serial_claims_no_overlap
    exclude using gist (serial_id with =, period with &&)
);

alter table public.serial_claims enable row level security;
create policy team_read on public.serial_claims for select to authenticated
  using (public.rentory_is_member());

-- RO/<year>/0001, one counter per year, never reused.
create table public.order_numbers (
  year integer primary key,
  last integer not null default 0
);
alter table public.order_numbers enable row level security;

create or replace function public.book_order(p_order_id uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  o public.orders;
  l record;
  s record;
  v_start timestamptz;
  v_end timestamptz;
  v_held double precision;
  v_stock double precision;
  v_year integer;
  v_seq integer;
  v_number text;
begin
  if not public.rentory_is_member() then
    raise exception 'Not a member of this team.' using errcode = '42501';
  end if;

  select * into o from public.orders
   where id = p_order_id and not deleted
   for update;
  if not found then
    raise exception 'Order not found. Sync it first.' using errcode = 'P0002';
  end if;
  if o.state in ('booked', 'picked_up', 'partial_return', 'returned') then
    -- Already booked (a retry after a lost reply): answer the same number.
    return o.number;
  end if;

  for l in
    select ol.*, a.tracking, a.qty_manual, a.name as asset_name
      from public.order_lines ol
      left join public.assets a on a.id = ol.asset_id
     where ol.order_id = p_order_id and not ol.deleted
       and ol.line_type = 'asset'
  loop
    v_start := coalesce(l.date_start, o.date_start);
    v_end := coalesce(l.date_end, o.date_end);
    if v_start is null or v_end is null then
      raise exception '%: no dates.', l.name using errcode = 'P0001';
    end if;

    if l.tracking = 'serial' then
      for s in
        select se.id, se.name, se.state
          from public.order_line_serials ols
          join public.serials se on se.id = ols.serial_id
         where ols.line_id = l.id and not ols.deleted
      loop
        if s.state in ('maintenance', 'lost', 'retired') then
          raise exception '%: % cannot be rented (%).', l.name, s.name, s.state
            using errcode = 'P0001';
        end if;
        begin
          insert into public.serial_claims (serial_id, line_id, order_id, period)
          values (s.id, l.id, p_order_id, tstzrange(v_start, v_end, '[)'));
        exception when exclusion_violation then
          raise exception '%: % is already booked for these dates.',
            l.name, s.name using errcode = 'P0001';
        end;
      end loop;
    else
      -- Untracked stock: lock the asset so two bookings count one at a time.
      perform 1 from public.assets where id = l.asset_id for update;
      select coalesce(sum(ol.quantity), 0) into v_held
        from public.order_lines ol
        join public.orders oo on oo.id = ol.order_id
       where ol.asset_id = l.asset_id
         and ol.id <> l.id
         and not ol.deleted and not oo.deleted
         and ol.line_type = 'asset'
         and (
           (ol.rental_state in ('booked', 'picked_up')
            and oo.state in ('booked', 'picked_up', 'partial_return',
                             'returned'))
           -- This order's own other lines compete even before booking.
           or (ol.order_id = p_order_id and ol.rental_state = 'none')
         )
         and coalesce(ol.date_start, oo.date_start) < v_end
         and coalesce(ol.date_end, oo.date_end) > v_start;
      v_stock := coalesce(l.qty_manual, 0);
      if v_held + l.quantity > v_stock then
        raise exception '%: % asked, % free for these dates.',
          l.asset_name, l.quantity, greatest(v_stock - v_held, 0)
          using errcode = 'P0001';
      end if;
    end if;
  end loop;

  -- A re-booked order keeps its number; only a first booking takes one.
  v_number := o.number;
  if v_number is null then
    v_year := extract(year from now())::integer;
    insert into public.order_numbers (year, last) values (v_year, 1)
    on conflict (year) do update set last = public.order_numbers.last + 1
    returning last into v_seq;
    v_number := format('RO/%s/%s', v_year, lpad(v_seq::text, 4, '0'));
  end if;

  update public.orders
     set state = 'booked', number = v_number, updated_at = now()
   where id = p_order_id;
  update public.order_lines
     set rental_state = 'booked', updated_at = now()
   where order_id = p_order_id and not deleted
     and rental_state = 'none' and line_type <> 'section';
  -- Never stamp 'reserved' over a unit that is physically out.
  update public.serials se
     set state = 'reserved', current_order_id = p_order_id,
         current_line_id = ols.line_id, updated_at = now()
    from public.order_line_serials ols
    join public.order_lines ol on ol.id = ols.line_id
   where ols.serial_id = se.id and not ols.deleted
     and ol.order_id = p_order_id and se.state = 'available';

  return v_number;
end;
$$;

revoke all on function public.book_order(uuid) from public, anon;
grant execute on function public.book_order(uuid) to authenticated;

-- Claims are let go by the same facts the app records, whichever device
-- records them: a unit checked in, a line returned or reset, an order
-- cancelled or sent back to draft.
create or replace function public.rentory_release_claims()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_table_name = 'return_checks' then
    if new.serial_id is not null and not new.deleted then
      delete from public.serial_claims
       where serial_id = new.serial_id and line_id = new.line_id;
    end if;
  elsif tg_table_name = 'order_lines' then
    if new.rental_state in ('none', 'returned') or new.deleted then
      delete from public.serial_claims where line_id = new.id;
    end if;
  elsif tg_table_name = 'orders' then
    if new.state in ('draft', 'cancelled') or new.deleted then
      delete from public.serial_claims where order_id = new.id;
    end if;
  elsif tg_table_name = 'order_line_serials' then
    if new.deleted then
      delete from public.serial_claims
       where serial_id = new.serial_id and line_id = new.line_id;
    end if;
  end if;
  return new;
end;
$$;

create trigger return_checks_release after insert or update
  on public.return_checks
  for each row execute function public.rentory_release_claims();
create trigger order_lines_release after update
  on public.order_lines
  for each row execute function public.rentory_release_claims();
create trigger orders_release after update
  on public.orders
  for each row execute function public.rentory_release_claims();
create trigger order_line_serials_release after update
  on public.order_line_serials
  for each row execute function public.rentory_release_claims();

-- Photos: one private bucket, team only.
insert into storage.buckets (id, name, public)
values ('photos', 'photos', false)
on conflict (id) do nothing;

create policy rentory_photos_read on storage.objects for select
  to authenticated
  using (bucket_id = 'photos' and public.rentory_is_member());
create policy rentory_photos_write on storage.objects for insert
  to authenticated
  with check (bucket_id = 'photos' and public.rentory_is_member());
