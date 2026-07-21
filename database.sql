-- Reset schema
DROP FUNCTION IF EXISTS tambah_musyrif_baru(text);
DROP FUNCTION IF EXISTS is_admin();
DROP TABLE IF EXISTS transaksi;
DROP TABLE IF EXISTS santri;
DROP TABLE IF EXISTS pengguna;

-- 1. Table Pengguna
CREATE TABLE pengguna (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nama TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    peran TEXT CHECK (peran IN ('admin', 'musyrif')),
    dibuat_pada TIMESTAMP DEFAULT NOW()
);

-- 2. Table Santri
CREATE TABLE santri (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    musyrif_id UUID REFERENCES pengguna(id) ON DELETE CASCADE,
    nama TEXT NOT NULL,
    kelas TEXT,
    nomor_induk TEXT UNIQUE,
    saldo BIGINT DEFAULT 0,
    dibuat_pada TIMESTAMP DEFAULT NOW()
);

-- 3. Table Transaksi
CREATE TABLE transaksi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    santri_id UUID REFERENCES santri(id) ON DELETE CASCADE,
    jenis TEXT CHECK (jenis IN ('pemasukan', 'pengeluaran', 'iuran')),
    kategori TEXT NOT NULL,
    jumlah BIGINT NOT NULL,
    keterangan TEXT,
    dibuat_pada TIMESTAMP DEFAULT NOW()
);

-- Security Definer function to check admin without recursion
CREATE OR REPLACE FUNCTION is_admin() RETURNS boolean
LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
    SELECT EXISTS (
        SELECT 1 FROM pengguna 
        WHERE id = auth.uid() AND peran = 'admin'
    );
$$;

-- Enable RLS
ALTER TABLE pengguna ENABLE ROW LEVEL SECURITY;
ALTER TABLE santri ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaksi ENABLE ROW LEVEL SECURITY;

-- RLS Pengguna
CREATE POLICY "Admin dapat melihat dan mengubah semua pengguna" 
ON pengguna FOR ALL 
USING (is_admin());

CREATE POLICY "Pengguna dapat melihat profil sendiri" 
ON pengguna FOR SELECT 
USING (id = auth.uid());

-- RLS Santri
CREATE POLICY "Admin dapat melihat dan mengubah semua santri" 
ON santri FOR ALL 
USING (is_admin());

CREATE POLICY "Musyrif dapat mengelola santrinya sendiri" 
ON santri FOR ALL 
USING (musyrif_id = auth.uid());

-- RLS Transaksi
CREATE POLICY "Admin dapat melihat dan mengubah semua transaksi" 
ON transaksi FOR ALL 
USING (is_admin());

CREATE POLICY "Musyrif dapat mengelola transaksi santrinya" 
ON transaksi FOR ALL 
USING (
    EXISTS (
        SELECT 1 FROM santri 
        WHERE santri.id = transaksi.santri_id 
        AND santri.musyrif_id = auth.uid()
    )
);

-- Fungsi Tambah Musyrif (Diperbaiki)
CREATE OR REPLACE FUNCTION tambah_musyrif_baru(nama_musyrif TEXT)
RETURNS TABLE (username TEXT, password TEXT) 
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
    new_user_id UUID := gen_random_uuid();
    gen_username TEXT;
    gen_password TEXT;
BEGIN
    -- Validasi hanya admin yang boleh mengeksekusi
    IF NOT is_admin() THEN
        RAISE EXCEPTION 'Akses ditolak: Hanya admin yang dapat membuat akun Musyrif.';
    END IF;

    -- Generate username (nama kecil + 3 digit acak)
    gen_username := LOWER(REGEXP_REPLACE(nama_musyrif, '\s+', '', 'g')) || LPAD(FLOOR(RANDOM() * 1000)::TEXT, 3, '0');
    
    -- Generate password (8 karakter acak)
    gen_password := SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 8);

    -- Insert ke auth.users (kompatibel dengan Supabase terbaru)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, 
        created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change, raw_app_meta_data, raw_user_meta_data
    )
    VALUES (
        new_user_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 
        gen_username || '@santri.app', 
        crypt(gen_password, gen_salt('bf')),
        NOW(), NOW(), NOW(), '', '', '', '', '{"provider":"email","providers":["email"]}', '{}'
    );

    -- Insert ke public.pengguna
    INSERT INTO pengguna (id, nama, username, peran)
    VALUES (new_user_id, nama_musyrif, gen_username, 'musyrif');

    RETURN QUERY SELECT gen_username, gen_password;
END;
$$;
