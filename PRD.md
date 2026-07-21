# PRD - Sistem Keuangan Santri (SIMKAS SANTRI)
**Versi**: 1.0.0  
**Tanggal**: 21 Juli 2026  
**Status**: Stabil - Siap Produksi  
**Repositori**: `Mowildz/Sunduqi`

---

## DAFTAR ISI
1. [Ringkasan Proyek](#1-ringkasan-proyek)
2. [Tujuan & Manfaat](#2-tujuan--manfaat)
3. [Peran Pengguna & Hak Akses](#3-peran-pengguna--hak-akses)
4. [Daftar Fitur Lengkap](#4-daftar-fitur-lengkap)
5. [Struktur Database (Supabase)](#5-struktur-database-supabase)
6. [Struktur Berkas Proyek](#6-struktur-berkas-proyek)
7. [Alur Kerja Utama](#7-alur-kerja-utama)
8. [Teknologi yang Digunakan](#8-teknologi-yang-digunakan)
9. [Langkah Instalasi & Deploy](#9-langkah-instalasi--deploy)
10. [Roadmap Pengembangan](#10-roadmap-pengembangan)
11. [Catatan Keamanan](#11-catatan-keamanan)

---

## 1. RINGKASAN PROYEK
**Nama Produk**: SIMKAS SANTRI  
**Tipe**: Aplikasi Web Responsif (Mobile First)  
**Sektor**: Pendidikan Pesantren / Lembaga Pendidikan Islam  
**Deskripsi Singkat**:  
Sistem manajemen keuangan santri berbasis web yang memudahkan pengurus pesantren (Admin) dan pembimbing santri (Musyrif) untuk mencatat, memantau, dan mengelola uang saku, iuran kegiatan, serta seluruh transaksi keuangan santri secara terstruktur, transparan, dan akuntabel. Menggantikan pencatatan manual berbasis buku yang rawan hilang, salah hitung, dan sulit dilacak.

---

## 2. TUJUAN & MANFAAT
### Tujuan Utama
1. Memisahkan hak akses secara tegas antara **Admin Pengurus** dan **Musyrif Pembimbing**
2. Setiap Musyrif hanya dapat mengelola data santri yang menjadi tanggung jawabnya
3. Mencatat seluruh transaksi keuangan dengan rincian kategori, waktu, dan bukti catatan
4. Menyediakan laporan keuangan yang real-time, mudah dibaca, dan bisa dicetak kapan saja
5. Mewujudkan **good governance** keuangan di lingkungan pesantren

### Manfaat Bagi Pengguna
| Pihak               | Manfaat Utama                                                                 |
|---------------------|--------------------------------------------------------------------------------|
| **Admin Pengurus**  | Memantau seluruh data, membuat akun Musyrif otomatis, melihat ringkasan umum |
| **Musyrif**         | Input data cepat, hitung saldo otomatis, laporan tinggal cetak tanpa hitung manual |
| **Santri / Orang Tua** | Data keuangan jelas, riwayat lengkap, minim kesalahan catatan                |

---

## 3. PERAN PENGGUNA & HAK AKSES
Sistem menerapkan **Role Based Access Control (RBAC)** yang diperkuat dengan **Row Level Security (RLS)** di database Supabase:

| Peran       | Hak Akses                                                                                          | Batasan Akses                                 |
|-------------|----------------------------------------------------------------------------------------------------|-----------------------------------------------|
| **Admin**   | Tambah / hapus akun Musyrif<br>Lihat semua data santri & transaksi<br>Lihat statistik keseluruhan | Tidak boleh mengubah transaksi milik Musyrif  |
| **Musyrif** | Login dengan akun dari Admin<br>Tambah / ubah / hapus data santrinya<br>Catat semua jenis transaksi<br>Lihat & cetak laporan | Tidak bisa lihat data santri milik Musyrif lain<br>Tidak bisa membuat akun pengguna baru |
| **Santri**  | *(Versi 1.1)* Login hanya melihat saldo & riwayat transaksi                                        | Tidak bisa mengubah data sama sekali          |

---

## 4. DAFTAR FITUR LENGKAP

### Modul Autentikasi & Akun
- [x] Login aman dengan **Username + Password**
- [x] **Pembuatan akun Musyrif OTOMATIS** oleh Admin: sistem generate `username` acak + `password` acak 8 karakter, hanya ditampilkan **sekali** saat pembuatan
- [x] Pemisahan jalur setelah login sesuai `peran` pengguna
- [x] Logout aman yang menghapus sesi
- [x] Proteksi RLS: data hanya bisa diakses pemilik sahnya

### Modul Admin
- [x] Dashboard ringkasan: jumlah Musyrif, total santri, estimasi total dana
- [x] Tabel daftar Musyrif lengkap (nama, username, tanggal bergabung)
- [x] Hapus akun Musyrif beserta seluruh data santri yang dibawahnya (cascade delete)
- [x] Pencarian dan penyaringan data Musyrif

### Modul Musyrif (Inti Aplikasi)
- [x] Dashboard pribadi: jumlah santri binaan, **total saldo keseluruhan**, rata-rata saldo santri
- [x] **Kartu Santri Interaktif** model kartu ATM modern dengan efek glassmorphism
- [x] Tambah data santri: nama lengkap, kelas / kamar, nomor induk santri
- [x] Edit & hapus data santri
- [x] Pencarian santri berdasarkan nama / nomor induk

### Modul Keuangan Santri (Per Santri)
Setiap santri memiliki halaman detail dengan fitur:
- [x] **Tambah Saldo (Pemasukan)** + pilihan kategori + keterangan opsional
- [x] **Tarik Saldo (Pengeluaran)** + pilihan kategori + keterangan opsional
- [x] **Catat Iuran Kegiatan** terpisah dari transaksi biasa
- [x] **Validasi Otomatis**: tidak bisa tarik saldo melebihi saldo yang tersedia
- [x] Perhitungan saldo berjalan otomatis setiap transaksi
- [x] Riwayat transaksi **lengkap & terurut waktu**: kolom waktu, jenis, kategori, jumlah, keterangan
- [x] Hapus transaksi dengan **koreksi saldo otomatis** (rollback)
- [x] Ringkasan: Total Pemasukan, Total Pengeluaran, Total Iuran
- [x] **Cetak Laporan** per santri dalam format siap print

### Modul Tampilan & Pengalaman Pengguna
- [x] Desain **Modern Aesthetic**: Gradient warna mewah, efek kaca (glassmorphism), animasi halus
- [x] Tombol interaktif dengan efek shimmer, hover, dan click feedback
- [x] **100% Responsif**: tampilan sempurna di HP, Tablet, Laptop, dan Komputer
- [x] Tipografi premium + dukungan **Font Arab** untuk identitas pesantren
- [x] Warna status intuitif: **Hijau = Pemasukan**, **Merah = Pengeluaran**, **Ungu = Iuran**

---

## 5. STRUKTUR DATABASE (SUPABASE)
Database menggunakan **PostgreSQL** dengan 3 tabel utama + 1 fungsi PL/pgSQL.

### Tabel 1: `pengguna`
Menyimpan data Admin dan Musyrif, terhubung langsung dengan sistem Auth Supabase.

| Kolom         | Tipe Data         | Constraint       | Keterangan                                      |
|---------------|-------------------|------------------|-------------------------------------------------|
| `id`          | UUID              | PK, FK `auth.users` | ID unik, sama dengan ID autentikasi            |
| `nama`        | TEXT              | NOT NULL         | Nama lengkap pengguna                           |
| `username`    | TEXT              | UNIQUE, NOT NULL | Username untuk login                            |
| `peran`       | TEXT              | CHECK IN ('admin','musyrif') | Peran pengguna di sistem              |
| `dibuat_pada` | TIMESTAMP         | DEFAULT `NOW()`  | Waktu akun dibuat                               |

### Tabel 2: `santri`
Menyimpan data identitas santri beserta saldo terkini.

| Kolom          | Tipe Data         | Constraint       | Keterangan                                      |
|----------------|-------------------|------------------|-------------------------------------------------|
| `id`           | UUID              | PK, DEFAULT `gen_random_uuid()` | ID unik santri                  |
| `musyrif_id`   | UUID              | FK `pengguna.id` ON DELETE CASCADE | Siapa pembimbing santri ini       |
| `nama`         | TEXT              | NOT NULL         | Nama lengkap santri                             |
| `kelas`        | TEXT              | -                | Kelas / kamar / kelompok belajar                |
| `nomor_induk`  | TEXT              | UNIQUE           | Nomor induk / NIS santri                        |
| `saldo`        | BIGINT            | DEFAULT 0        | Saldo uang saku (satuan Rupiah, tanpa koma)     |
| `dibuat_pada`  | TIMESTAMP         | DEFAULT `NOW()`  | Waktu santri terdaftar                          |

### Tabel 3: `transaksi`
Jurnal keuangan untuk **SELURUH** jenis transaksi (sumber kebenaran tunggal).

| Kolom          | Tipe Data         | Constraint       | Keterangan                                                                 |
|----------------|-------------------|------------------|-----------------------------------------------------------------------------|
| `id`           | UUID              | PK               | ID unik transaksi                                                           |
| `santri_id`    | UUID              | FK `santri.id` ON DELETE CASCADE | Santri mana transaksi ini                   |
| `jenis`        | TEXT              | CHECK IN ('pemasukan','pengeluaran','iuran') | Klasifikasi utama transaksi     |
| `kategori`     | TEXT              | NOT NULL         | Rincian: Uang Saku, Jajan, Iuran Kegiatan, dll.                            |
| `jumlah`       | BIGINT            | NOT NULL         | Nominal uang (Rupiah bulat)                                                 |
| `keterangan`   | TEXT              | -                | Catatan tambahan opsional                                                   |
| `dibuat_pada`  | TIMESTAMP         | DEFAULT `NOW()`  | Waktu pencatatan (otomatis server)                                          |

### Aturan Keamanan RLS
- Admin bisa baca & tulis SEMUA data
- Musyrif hanya bisa baca & tulis data **santri miliknya sendiri**
- Transaksi hanya bisa diubah oleh Musyrif pemilik santri terkait

### Fungsi Database: `tambah_musyrif_baru(nama TEXT)`
Fungsi PL/pgSQL yang dieksekusi Admin untuk:
1. Generate `username` otomatis (nama kecil + 3 digit angka acak)
2. Generate `password` acak 8 karakter
3. Mendaftarkan user ke tabel `auth.users` Supabase
4. Memasukkan data ke tabel `pengguna`
5. Mengembalikan `username` & `password` **hanya sekali** untuk diserahkan ke Musyrif

---

## 6. STRUKTUR BERKAS PROYEK
Sunduqi/
|-- index.html # File utama aplikasi (Frontend + Logika Bisnis)
|-- README.md # Panduan singkat proyek di halaman GitHub
|-- PRD_SIMKAS_SANTRI.md # Dokumen ini (Product Requirement Document)
|-- database.sql # Skema database lengkap (untuk restore)
+-- .gitignore # Berkas yang tidak perlu diunggah Git
plaintext

> **Catatan**: Aplikasi ini sengaja dibuat **Single File Application** (semua di `index.html`) supaya mudah dikelola pemula, tanpa build step rumit.

---

## 7. ALUR KERJA UTAMA
[ADMIN]
|
+-> Login sistem
+-> Tambah Musyrif -> Sistem Generate Akun -> Serahkan Username/Password ke Musyrif
+-> Pantau statistik & data keseluruhan
[MUSYRIF]
|
+-> Login pakai akun dari Admin
+-> Tambah Data Santri (nama, kelas, NIS) -> Muncul Kartu Santri di Dashboard
+-> Klik Kartu Santri -> Masuk Halaman Detail
| +-> Tambah Saldo -> Sistem Update Saldo + Catat Jurnal
| +-> Tarik Saldo -> Cek Cukup/Tidak -> Update Saldo + Jurnal
| +-> Catat Iuran -> Potong Saldo + Jurnal Khusus Iuran
| +-> Lihat Riwayat Transaksi Lengkap
| +-> Cetak Laporan
+-> Logout sistem
plaintext

---

## 8. TEKNOLOGI YANG DIGUNAKAN
| Komponen          | Teknologi / Layanan                          | Alasan Pemilihan                                 |
|-------------------|-----------------------------------------------|--------------------------------------------------|
| Frontend UI       | HTML5, CSS3, Vanilla JavaScript (ES6+)       | Ringan, tidak perlu build tool, mudah di edit    |
| Styling           | Tailwind CSS CDN + Kustom CSS Gradient       | Desain cepat, konsisten, responsive otomatis     |
| Database          | Supabase (PostgreSQL 15+)                    | Open source, fitur lengkap, RLS bawaan           |
| Autentikasi       | Supabase Auth                                 | Integrasi mulus dengan database, aman            |
| Hosting / Deploy  | Vercel                                        | Gratis, auto deploy dari GitHub, SSL otomatis    |
| Version Control   | Git + GitHub                                  | Standar industri, kolaborasi mudah               |
| Font              | Poppins + Amiri (Arab)                       | Modern + mendukung tulisan Arab dengan baik      |

---

## 9. LANGKAH INSTALASI & DEPLOY
### Langkah 1: Setup Database Supabase
1. Buat project baru di [supabase.com](https://supabase.com)
2. Buka **SQL Editor -> New Query**
3. Tempel isi file `database.sql` -> **Run**
4. Buat akun Admin pertama lewat menu **Authentication -> Add User**
5. Masukkan data Admin ke tabel `pengguna`

### Langkah 2: Kode Aplikasi
1. Edit file `index.html`
2. Isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dari menu **Settings -> API** Supabase
3. PERINGATAN: **JANGAN GUNAKAN `service_role` / SECRET KEY** di file frontend!

### Langkah 3: Upload ke GitHub
1. Buat Repository baru (contoh: `Sunduqi`)
2. Upload `index.html`, `README.md`, `PRD_SIMKAS_SANTRI.md`, `database.sql`
3. Commit perubahan

### Langkah 4: Deploy ke Vercel
1. Login [vercel.com](https://vercel.com) -> **Add New Project**
2. Import Repository `Sunduqi` dari GitHub
3. Klik **Deploy** (tanpa ubah pengaturan apapun)
4. Selesai! Dapatkan domain publik: `https://sunduqi-xxxx.vercel.app`

---

## 10. ROADMAP PENGEMBANGAN
### Versi 1.1 (Short Term)
- [ ] Fitur **Akun Orang Tua**: login lihat saldo anak & notifikasi transaksi
- [ ] Kirim bukti transaksi otomatis via **WhatsApp Gateway**
- [ ] Upload bukti foto bon / kwitansi setiap transaksi
- [ ] Filter & pencarian riwayat transaksi lanjutan

### Versi 1.2 (Mid Term)
- [ ] Ekspor laporan ke **PDF & Excel (.xlsx)**
- [ ] Fitur **Tabungan Khusus / Cicilan** terpisah dari uang saku
- [ ] Laporan bulanan otomatis per kelas / per musyrif
- [ ] Dark / Light Mode toggle

### Versi 2.0 (Long Term)
- [ ] Aplikasi Android (PWA)
- [ ] Multi Pesantren (SaaS Mode)
- [ ] Integrasi dengan sistem pembayaran digital

---

## 11. CATATAN KEAMANAN
1. **Jangan pernah** mempublikasikan `service_role key` Supabase ke repositori publik
2. Ganti password Admin secara berkala
3. Aktifkan email confirmation di Supabase Auth untuk versi mendatang
4. Lakukan backup database mingguan dari dashboard Supabase
5. Hapus akun Musyrif yang sudah tidak bertugas segera

---

**(c) 2026 SIMKAS SANTRI - Dibangun untuk kemajuan pendidikan pesantren Indonesia.**
