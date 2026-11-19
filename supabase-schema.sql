-- Run this in Supabase SQL Editor.
create table if not exists public.gacha_records (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  pool text not null check (pool in ('character','lightcone','standard','beginner')),
  item_name text not null,
  pity integer not null check (pity between 1 and 90),
  result text not null check (result in ('up','off','standard')),
  rank integer not null default 0 check (rank between 0 and 6),
  notes text,
  created_at timestamptz not null default now()
);
alter table public.gacha_records enable row level security;
create policy "Users can view own gacha records"
on public.gacha_records for select to authenticated
using (auth.uid() = user_id);
create policy "Users can insert own gacha records"
on public.gacha_records for insert to authenticated
with check (auth.uid() = user_id);
create policy "Users can update own gacha records"
on public.gacha_records for update to authenticated
using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete own gacha records"
on public.gacha_records for delete to authenticated
using (auth.uid() = user_id);
