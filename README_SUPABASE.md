# Panduan Setup — AHP Pairwise Comparison OMG-DIVE

Paket ini berisi:
- `index.html` — halaman survei (penjelasan tujuan + form pairwise comparison + perhitungan AHP otomatis + kirim ke Supabase)
- `supabase_setup.sql` — script SQL untuk membuat tabel database
- `README_SUPABASE.md` — file ini

## 1. Buat project Supabase (gratis)

1. Buka https://supabase.com → Sign up / Login → **New Project**.
2. Catat **Project URL** dan **anon public key**, ada di Project Settings → API.

## 2. Buat tabel database

1. Di Supabase Dashboard, buka **SQL Editor** → **New query**.
2. Salin-tempel seluruh isi `supabase_setup.sql`, lalu klik **Run**.
3. Tabel `ahp_responses` akan otomatis terbuat, lengkap dengan kolom hasil AHP (bobot, λ maks, CI, CR) dan kebijakan keamanan (RLS) yang mengizinkan publik mengirim data (insert) tanpa login.

## 3. Hubungkan index.html ke Supabase Anda

Buka `index.html`, cari bagian ini di dalam `<script>` (dekat awal):

```js
const SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';
const SUPABASE_TABLE = 'ahp_responses';
```

Ganti `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dengan nilai project Anda dari langkah 1. **anon key aman ditaruh di frontend** — itu sebabnya tabel dilindungi lewat Row Level Security (RLS) yang hanya mengizinkan insert, tidak bisa update/delete dari publik.

## 4. Deploy ke Vercel

**Opsi A — lewat web (tanpa terminal):**
1. Buka https://vercel.com → New Project → **Deploy without Git** / drag & drop folder ini (cukup `index.html`).
2. Vercel otomatis mendeteksi sebagai static site dan memberi URL publik (mis. `ahp-omgdive.vercel.app`).

**Opsi B — lewat GitHub:**
1. Push folder ini ke repo GitHub baru.
2. Di Vercel: New Project → Import dari GitHub repo tersebut → Deploy (tidak perlu konfigurasi build, karena ini static HTML).

**Opsi C — lewat Vercel CLI:**
```bash
npm i -g vercel
cd folder-ini
vercel --prod
```

## 5. Bagikan link ke expert

Setelah deploy, Anda akan mendapat URL seperti `https://nama-project-anda.vercel.app`. Bagikan link ini ke setiap expert. Setiap submission yang konsisten (CR ≤ 0,10) otomatis tersimpan sebagai 1 baris baru di tabel `ahp_responses`.

## 6. Melihat / mengekspor hasil

- Buka Supabase Dashboard → **Table Editor** → tabel `ahp_responses` untuk melihat seluruh respons.
- Bisa diekspor ke CSV langsung dari Table Editor (tombol Export), atau diquery lewat SQL Editor untuk agregasi rata-rata geometris antar-expert.

## Catatan

- Jika CR seorang expert > 0,10, sistem **tidak** mengirim data dan meminta expert meninjau ulang jawabannya — ini memastikan hanya data konsisten yang masuk database.
- Tombol "Salin Ringkasan" / "Salin Matriks (CSV)" tetap tersedia sebagai cadangan manual jika koneksi ke Supabase gagal (misal expert offline saat submit).
