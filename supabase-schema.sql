create table if not exists public.app_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_state owner to postgres;
alter table public.app_state enable row level security;

grant usage on schema public to service_role;
grant select, insert, update, delete on public.app_state to service_role;
grant all privileges on table public.app_state to service_role;

drop policy if exists "service role can manage app state" on public.app_state;

create policy "service role can manage app state"
on public.app_state
for all
using (auth.role() = 'service_role')
with check (auth.role() = 'service_role');

insert into public.app_state (id, data, updated_at)
values (
  'mzansi-market-hub',
  jsonb_build_object(
    'listings', jsonb_build_object(
      'pending', jsonb_build_array(),
      'approved', jsonb_build_array(),
      'rejected', jsonb_build_array(),
      'flagged', jsonb_build_array(),
      'taken', jsonb_build_array(),
      'changedMind', jsonb_build_array()
    ),
    'orders', jsonb_build_array(),
    'appointments', jsonb_build_array(),
    'activities', jsonb_build_array(),
    'analytics', jsonb_build_object('events', jsonb_build_array()),
    'settings', jsonb_build_object(
      'platformName', 'Kasi to Kasi Market Place',
      'phase', 'Phase 1 WhatsApp MVP'
    )
  ),
  now()
)
on conflict (id) do nothing;

notify pgrst, 'reload schema';

select
  has_table_privilege('service_role', 'public.app_state', 'SELECT') as can_select,
  has_table_privilege('service_role', 'public.app_state', 'INSERT') as can_insert,
  has_table_privilege('service_role', 'public.app_state', 'UPDATE') as can_update,
  has_table_privilege('service_role', 'public.app_state', 'DELETE') as can_delete;
