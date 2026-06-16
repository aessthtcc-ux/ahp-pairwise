-- =====================================================================
-- SQL Setup untuk Supabase — AHP Pairwise Comparison OMG-DIVE
-- Jalankan script ini di: Supabase Dashboard > SQL Editor > New Query
-- =====================================================================

create table if not exists ahp_responses (
  id              uuid primary key default gen_random_uuid(),
  nama            text,
  jabatan         text,
  tanggal_pengisian date,
  pair_state      jsonb,      -- 21 pilihan mentah expert (degree, side, stopIdx)
  matrix          jsonb,      -- matriks perbandingan 7x7 hasil olahan
  weights         jsonb,      -- array 7 bobot prioritas (0-1)
  lambda_max      numeric,
  ci              numeric,    -- Consistency Index
  cr              numeric,    -- Consistency Ratio
  is_consistent   boolean,    -- true jika CR <= 0.10
  dims            jsonb,      -- snapshot definisi 7 dimensi saat submit
  submitted_at    timestamptz,
  created_at      timestamptz default now()
);

-- Aktifkan Row Level Security
alter table ahp_responses enable row level security;

-- Izinkan SIAPA SAJA mengirim data baru (insert) lewat anon key
-- (expert mengisi dari link publik, tanpa login)
create policy "Allow public insert"
  on ahp_responses
  for insert
  to anon
  with check (true);

-- Opsional: izinkan anon membaca data juga (misal untuk dashboard publik).
-- Hapus / lewati policy ini jika ingin hasil HANYA terlihat oleh Anda
-- lewat Supabase Dashboard (Table Editor), bukan dari halaman publik.
-- create policy "Allow public read"
--   on ahp_responses
--   for select
--   to anon
--   using (true);

-- Index bantu untuk query berdasarkan waktu submit
create index if not exists idx_ahp_responses_submitted_at
  on ahp_responses (submitted_at desc);
