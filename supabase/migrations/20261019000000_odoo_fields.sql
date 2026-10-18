-- The rest of Rentory's own fields, so a row maps to Odoo one-to-one
-- (parts and accounting aside). App 1.2.0 writes these; run this before
-- installing it. Older app versions keep working: they never send these
-- columns, and an upsert leaves columns it does not send alone.

-- Assets: manual status, acquisition, and kit rented in from a supplier.
alter table public.assets
  add column state_manual text
    check (state_manual in ('maintenance', 'retired')),
  add column source_id uuid references public.customers (id),
  add column evaluation_url text,
  add column acquisition_date timestamptz,
  add column unit_cost double precision not null default 0,
  add column ownership text not null default 'owned'
    check (ownership in ('owned', 'rented_in')),
  add column supplier_name text,
  add column supplier_phone text,
  add column supplier_reference text,
  add column rented_in_date_start timestamptz,
  add column rented_in_date_end timestamptz,
  add column rented_in_cost_day double precision not null default 0,
  add column rented_in_deposit double precision not null default 0,
  add column rented_in_returned_at timestamptz,
  add column rented_in_returned_by text,
  add column rented_in_condition_in text not null default 'good'
    check (rented_in_condition_in in ('good', 'minor', 'damaged', 'lost')),
  add column rented_in_condition_out text
    check (rented_in_condition_out in ('good', 'minor', 'damaged', 'lost')),
  add column rented_in_note text;

-- Units: their own acquisition (two bodies bought years apart differ).
alter table public.serials
  add column source_id uuid references public.customers (id),
  add column evaluation_url text,
  add column acquisition_date timestamptz,
  add column unit_cost double precision not null default 0;

-- Orders: line dates outside the window, signature target, capture.
alter table public.orders
  add column allow_line_dates_outside boolean not null default false,
  add column signature_target text
    check (signature_target in
      ('rental_contract', 'pickup_return_receipt', 'loan_contract')),
  add column capture_method text check (capture_method in ('phone', 'macro')),
  add column photos_url text;

-- Return checks keep the serial number as it was at check-in.
alter table public.return_checks add column serial_name text;

alter table public.document_types add column note text;

alter table public.customer_discounts
  add column sequence integer not null default 10,
  add column customer_name text;

alter table public.photos add column sequence integer not null default 10;
