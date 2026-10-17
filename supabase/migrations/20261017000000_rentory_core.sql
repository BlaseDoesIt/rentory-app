-- Rentory core schema: the same tables and columns as the app's SQLite
-- database (lib/data/local/tables.dart), plus what only a server can do:
-- a sync sequence, team-only access, and booking that two devices cannot
-- race.

create extension if not exists btree_gist;

-- ------------------------------------------------------------------ sync
-- Every insert or update stamps the row with the next number from one
-- sequence. Devices pull "everything after the last number I saw".
create sequence public.sync_seq;

create or replace function public.rentory_touch()
returns trigger
language plpgsql
as $$
begin
  new.server_seq := nextval('public.sync_seq');
  new.updated_by := coalesce(auth.uid(), new.updated_by);
  return new;
end;
$$;

-- --------------------------------------------------------------- people
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  name text not null default '',
  role text not null default 'office'
    check (role in ('admin', 'office', 'warehouse')),
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.customers (
  id uuid primary key,
  name text not null,
  phone text,
  notes text,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.document_types (
  id uuid primary key,
  name text not null,
  sequence integer not null default 10,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.customer_discounts (
  id uuid primary key,
  name text not null,
  customer_id uuid references public.customers (id),
  discount_type text not null default 'percent'
    check (discount_type in ('percent', 'fixed')),
  discount_value double precision not null default 0
    check (discount_value >= 0),
  date_from timestamptz,
  date_to timestamptz,
  note text,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

-- ------------------------------------------------------------ inventory
create table public.categories (
  id uuid primary key,
  name text not null,
  parent_id uuid,
  color integer not null default 0,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.locations (
  id uuid primary key,
  name text not null,
  parent_id uuid,
  note text,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.assets (
  id uuid primary key,
  name text not null,
  code text,
  barcode text,
  category_id uuid references public.categories (id),
  tracking text not null default 'none' check (tracking in ('none', 'serial')),
  rental_ok boolean not null default true,
  qty_manual double precision not null default 1,
  rental_price_day double precision not null default 0,
  declared_value double precision not null default 0,
  location_id uuid references public.locations (id),
  image_path text,
  notes text,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.serials (
  id uuid primary key,
  asset_id uuid not null references public.assets (id),
  name text not null,
  barcode text,
  state text not null default 'available' check (state in (
    'available', 'reserved', 'out', 'mandatory_out', 'maintenance', 'lost',
    'retired')),
  location_id uuid references public.locations (id),
  current_order_id uuid,
  current_line_id uuid,
  declared_value double precision not null default 0,
  note text,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.parts (
  id uuid primary key,
  name text not null,
  code text,
  asset_id uuid not null references public.assets (id),
  serial_id uuid references public.serials (id),
  sequence integer not null default 10,
  kind text not null default 'mandatory'
    check (kind in ('mandatory', 'supply', 'none')),
  condition text not null default 'good'
    check (condition in ('good', 'damaged', 'lost')),
  state text not null default 'available'
    check (state in ('available', 'reserved', 'out')),
  rental_price_day double precision not null default 0,
  current_order_id uuid,
  current_line_id uuid,
  note text,
  active boolean not null default true,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

-- --------------------------------------------------------------- orders
create table public.orders (
  id uuid primary key,
  number text unique,
  customer_id uuid references public.customers (id),
  customer_name text,
  customer_phone text,
  date_start timestamptz,
  date_end timestamptz,
  state text not null default 'draft' check (state in (
    'draft', 'booked', 'picked_up', 'partial_return', 'returned',
    'cancelled')),
  discount_type text not null default 'percent'
    check (discount_type in ('percent', 'fixed')),
  discount_value double precision not null default 0
    check (discount_value >= 0),
  customer_discount_id uuid references public.customer_discounts (id),
  amount_deposit double precision not null default 0
    check (amount_deposit >= 0),
  amount_paid double precision not null default 0 check (amount_paid >= 0),
  late_fee_manual boolean not null default true,
  late_days_edited boolean not null default false,
  late_days_override integer not null default 0
    check (late_days_override >= 0),
  sig_rental_contract boolean not null default false,
  sig_pickup_return_receipt boolean not null default false,
  sig_loan_contract boolean not null default false,
  items_captured boolean not null default false,
  items_examined boolean not null default false,
  items_examined_at timestamptz,
  items_examined_by text,
  documents_returned_at timestamptz,
  documents_returned_by text,
  signature_path text,
  signature_name text,
  signature_date timestamptz,
  user_id text,
  note text,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid,
  check (date_end is null or date_start is null or date_end > date_start)
);

create table public.order_documents (
  id uuid primary key,
  order_id uuid not null references public.orders (id),
  document_type_id uuid not null references public.document_types (id),
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.order_lines (
  id uuid primary key,
  order_id uuid not null references public.orders (id),
  sequence integer not null default 10,
  line_type text not null default 'asset'
    check (line_type in ('asset', 'part', 'service', 'section')),
  asset_id uuid references public.assets (id),
  part_id uuid references public.parts (id),
  name text not null default '',
  quantity double precision not null default 1,
  price_day double precision not null default 0,
  discount double precision not null default 0
    check (discount >= 0 and discount <= 100),
  date_start timestamptz,
  date_end timestamptz,
  rental_state text not null default 'none'
    check (rental_state in ('none', 'booked', 'picked_up', 'returned')),
  picked_up_at timestamptz,
  picked_up_by text,
  returned_at timestamptz,
  returned_by text,
  condition_out text not null default 'good'
    check (condition_out in ('missing', 'damaged', 'minor', 'good')),
  condition_in text
    check (condition_in in ('missing', 'damaged', 'minor', 'good')),
  condition_note text,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.order_line_serials (
  id uuid primary key,
  line_id uuid not null references public.order_lines (id),
  serial_id uuid not null references public.serials (id),
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.order_line_parts (
  id uuid primary key,
  line_id uuid not null references public.order_lines (id),
  part_id uuid not null references public.parts (id),
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.return_checks (
  id uuid primary key,
  line_id uuid not null references public.order_lines (id),
  order_id uuid not null references public.orders (id),
  serial_id uuid references public.serials (id),
  part_id uuid references public.parts (id),
  condition text not null default 'good'
    check (condition in ('missing', 'damaged', 'minor', 'good')),
  note text,
  returned_at timestamptz not null,
  returned_by text,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

create table public.photos (
  id uuid primary key,
  asset_id uuid,
  serial_id uuid,
  order_id uuid,
  line_id uuid,
  storage_path text,
  local_path text,
  taken_at timestamptz not null default now(),
  note text,
  updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  odoo_id integer,
  server_seq bigint not null default 0,
  updated_by uuid
);

-- Sync stamps, pull indexes and team-only access on every synced table.
create or replace function public.rentory_is_member()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and not p.deleted
  );
$$;

create or replace function public.rentory_is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and not p.deleted and p.role = 'admin'
  );
$$;

do $$
declare
  t text;
begin
  foreach t in array array[
    'profiles', 'customers', 'document_types', 'customer_discounts',
    'categories', 'locations', 'assets', 'serials', 'parts', 'orders',
    'order_documents', 'order_lines', 'order_line_serials',
    'order_line_parts', 'return_checks', 'photos'
  ] loop
    execute format(
      'create trigger %1$s_touch before insert or update on public.%1$I
         for each row execute function public.rentory_touch()', t);
    execute format(
      'create index %1$s_server_seq on public.%1$I (server_seq)', t);
    execute format('alter table public.%I enable row level security', t);
    if t <> 'profiles' then
      -- No delete policy on purpose: rows are soft-deleted so the deletion
      -- itself syncs to every device.
      execute format(
        'create policy team_read on public.%I for select to authenticated
           using (public.rentory_is_member())', t);
      execute format(
        'create policy team_insert on public.%I for insert to authenticated
           with check (public.rentory_is_member())', t);
      execute format(
        'create policy team_update on public.%I for update to authenticated
           using (public.rentory_is_member())
           with check (public.rentory_is_member())', t);
    end if;
  end loop;
end;
$$;

-- Profiles: everyone on the team sees the team; only admins change it.
create policy team_read on public.profiles for select to authenticated
  using (public.rentory_is_member());
create policy admin_update on public.profiles for update to authenticated
  using (public.rentory_is_admin()) with check (public.rentory_is_admin());

-- A profile is made for every new login. The very first one is the admin;
-- everyone after starts as office staff.
create or replace function public.rentory_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'name', split_part(new.email, '@', 1)),
    case when exists (select 1 from public.profiles) then 'office' else 'admin' end
  );
  return new;
end;
$$;

create trigger rentory_on_auth_user
  after insert on auth.users
  for each row execute function public.rentory_new_user();

create index order_lines_order on public.order_lines (order_id);
create index order_lines_asset on public.order_lines (asset_id);
create index order_line_serials_line on public.order_line_serials (line_id);
create index serials_asset on public.serials (asset_id);
create index serials_barcode on public.serials (barcode);
create index assets_barcode on public.assets (barcode);
create index return_checks_line on public.return_checks (line_id);
