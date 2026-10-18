-- Rentory no longer tracks parts: no part lines and no accessories on units.
-- App 1.0.0 and later never read or write any of this.

-- Any part line becomes a deleted service line, so the new line_type check
-- holds and devices drop it from their cache.
update public.order_lines
   set line_type = 'service', deleted = true, updated_at = now()
 where line_type = 'part';

-- Check-in records that were about a part, not a unit or a line.
update public.return_checks
   set deleted = true, updated_at = now()
 where part_id is not null and serial_id is null;

alter table public.order_lines drop constraint order_lines_line_type_check;
alter table public.order_lines add constraint order_lines_line_type_check
  check (line_type in ('asset', 'service', 'section'));

alter table public.order_lines drop column part_id;
alter table public.return_checks drop column part_id;

-- Triggers, indexes and policies go with the tables.
drop table public.order_line_parts;
drop table public.parts;
