-- Last write wins, enforced by the server.
--
-- A device that was offline pushes its edits when it reconnects. If someone
-- else edited the same row later, the late arrival must not overwrite the
-- newer version just because it reached the server second. An update whose
-- updated_at is older than the stored one is skipped; the device then pulls
-- the newer row on its next sync.

create or replace function public.rentory_touch()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'UPDATE' and new.updated_at < old.updated_at then
    return null; -- older than what we have: keep ours
  end if;
  new.server_seq := nextval('public.sync_seq');
  new.updated_by := coalesce(auth.uid(), new.updated_by);
  return new;
end;
$$;
