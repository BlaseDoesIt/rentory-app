-- App 1.4.0: lines are booked on their own (a line added to an order already
-- under way, or a booked line changed and booked again), and orders can be
-- archived. Run this before installing 1.4.0: that version sends
-- orders.active and calls book_lines.

alter table public.orders
  add column active boolean not null default true;

-- Books p_line_ids, or every line of the order not booked yet. Same referee
-- as book_order: each unit gets a claim over its dates and the exclusion
-- constraint refuses two overlapping claims on one unit.
create or replace function public.book_lines(
  p_order_id uuid,
  p_line_ids uuid[] default null
)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  o public.orders;
  l record;
  s record;
  v_ids uuid[];
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

  -- Lines already booked are skipped, so a retry after a lost reply just
  -- answers the number again.
  select coalesce(array_agg(ol.id), '{}') into v_ids
    from public.order_lines ol
   where ol.order_id = p_order_id and not ol.deleted
     and ol.line_type <> 'section'
     and ol.rental_state = 'none'
     and (p_line_ids is null or ol.id = any (p_line_ids));
  if coalesce(array_length(v_ids, 1), 0) = 0 then
    if o.number is not null then
      return o.number;
    end if;
    raise exception 'Nothing to book.' using errcode = 'P0001';
  end if;

  for l in
    select ol.*, a.tracking, a.qty_manual, a.name as asset_name
      from public.order_lines ol
      left join public.assets a on a.id = ol.asset_id
     where ol.id = any (v_ids) and ol.line_type = 'asset'
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
          values (s.id, l.id, p_order_id, tstzrange(v_start, v_end, '[)'))
          on conflict (serial_id, line_id)
            do update set period = excluded.period;
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
     set state = case when o.state in ('draft', 'cancelled')
                      then 'booked' else o.state end,
         number = v_number, updated_at = now()
   where id = p_order_id;
  update public.order_lines
     set rental_state = 'booked', updated_at = now()
   where id = any (v_ids);
  -- Never stamp 'reserved' over a unit that is physically out.
  update public.serials se
     set state = 'reserved', current_order_id = p_order_id,
         current_line_id = ols.line_id, updated_at = now()
    from public.order_line_serials ols
   where ols.serial_id = se.id and not ols.deleted
     and ols.line_id = any (v_ids) and se.state = 'available';

  return v_number;
end;
$$;

revoke all on function public.book_lines(uuid, uuid[]) from public, anon;
grant execute on function public.book_lines(uuid, uuid[]) to authenticated;

-- Older app versions book the whole order through book_order.
create or replace function public.book_order(p_order_id uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  return public.book_lines(p_order_id, null);
end;
$$;
