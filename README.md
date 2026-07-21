# SIMKAS SANTRI (Sistem Keuangan Santri)

Sistem manajemen keuangan santri berbasis web yang memudahkan pengurus pesantren (Admin) dan pembimbing santri (Musyrif) untuk mencatat, memantau, dan mengelola uang saku, iuran kegiatan, serta seluruh transaksi keuangan santri secara terstruktur, transparan, dan akuntabel.

## Teknologi
- **Frontend**: HTML5, Vanilla JavaScript (ES6+), CSS3
- **Styling**: Tailwind CSS
- **Database & Auth**: Supabase (PostgreSQL 15+)
- **Hosting**: Vercel

## Fitur Utama
- **Role Based Access Control**: Pemisahan tegas hak akses antara Admin Pengurus dan Musyrif Pembimbing menggunakan Supabase Row Level Security (RLS).
- **Pembuatan Akun Otomatis**: Admin dapat membuat akun Musyrif dan sistem akan men-generate username dan password secara otomatis dan aman.
- **Kartu Santri Interaktif**: Tampilan modern dengan efek *glassmorphism* untuk mengelola saldo dan data tiap santri.
- **Transaksi Akurat**: Validasi finansial yang ketat, pencegahan penarikan berlebih, dan fitur penghapusan transaksi dengan koreksi saldo otomatis (*rollback*).

## Instalasi
1. Clone repositori ini.
2. Buat database baru di Supabase.
3. Jalankan isi dari `database.sql` pada SQL Editor Supabase Anda untuk membuat tabel, RLS, dan fungsi yang diperlukan.
4. Deployment dapat dilakukan langsung menggunakan Vercel dengan repositori GitHub ini. Pastikan Anda telah mengatur `SUPABASE_URL` dan `SUPABASE_ANON_KEY` pada Environment Variables di Vercel.

*(c) 2026 SIMKAS SANTRI - Dibangun untuk kemajuan pendidikan pesantren Indonesia.*
