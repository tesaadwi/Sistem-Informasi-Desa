-- =====================================================
-- DATABASE SISTEM INFORMASI KEGIATAN DESA
-- PostgreSQL
-- =====================================================

-- Database sistem_desa sudah dibuat melalui PostgreSQL.
-- Jalankan script ini setelah terkoneksi ke database sistem_desa.


-- =====================================================
-- 1. TABEL USERS
-- =====================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'warga',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 2. TABEL WARGA
-- =====================================================

CREATE TABLE warga (
    id SERIAL PRIMARY KEY,
    nik VARCHAR(16) NOT NULL UNIQUE,
    nama VARCHAR(100) NOT NULL,
    jenis_kelamin VARCHAR(20) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    alamat TEXT NOT NULL,
    no_hp VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 3. TABEL PROFIL WARGA
-- RELASI ONE TO ONE DENGAN WARGA
-- =====================================================

CREATE TABLE profil_warga (
    id SERIAL PRIMARY KEY,
    warga_id INTEGER NOT NULL UNIQUE,
    pekerjaan VARCHAR(100),
    pendidikan_terakhir VARCHAR(100),
    status_pernikahan VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_profil_warga
        FOREIGN KEY (warga_id)
        REFERENCES warga(id)
        ON DELETE CASCADE
);


-- =====================================================
-- 4. TABEL KATEGORI
-- =====================================================

CREATE TABLE kategori (
    id SERIAL PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 5. TABEL LOKASI
-- =====================================================

CREATE TABLE lokasi (
    id SERIAL PRIMARY KEY,
    nama_lokasi VARCHAR(100) NOT NULL,
    alamat TEXT NOT NULL,
    kapasitas INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 6. TABEL KEGIATAN
-- RELASI ONE TO MANY DENGAN KATEGORI DAN LOKASI
-- =====================================================

CREATE TABLE kegiatan (
    id SERIAL PRIMARY KEY,
    kategori_id INTEGER NOT NULL,
    lokasi_id INTEGER NOT NULL,
    nama_kegiatan VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    penanggung_jawab VARCHAR(100) NOT NULL,
    status VARCHAR(30) DEFAULT 'direncanakan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_kegiatan_kategori
        FOREIGN KEY (kategori_id)
        REFERENCES kategori(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_kegiatan_lokasi
        FOREIGN KEY (lokasi_id)
        REFERENCES lokasi(id)
        ON DELETE RESTRICT
);


-- =====================================================
-- 7. TABEL PESERTA KEGIATAN
-- RELASI MANY TO MANY ANTARA WARGA DAN KEGIATAN
-- =====================================================

CREATE TABLE peserta_kegiatan (
    id SERIAL PRIMARY KEY,
    warga_id INTEGER NOT NULL,
    kegiatan_id INTEGER NOT NULL,
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_kehadiran VARCHAR(30) DEFAULT 'terdaftar',

    CONSTRAINT fk_peserta_warga
        FOREIGN KEY (warga_id)
        REFERENCES warga(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_peserta_kegiatan
        FOREIGN KEY (kegiatan_id)
        REFERENCES kegiatan(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_peserta
        UNIQUE (warga_id, kegiatan_id)
);


-- =====================================================
-- 8. TABEL DOKUMENTASI
-- RELASI ONE TO MANY DENGAN KEGIATAN
-- =====================================================

CREATE TABLE dokumentasi (
    id SERIAL PRIMARY KEY,
    kegiatan_id INTEGER NOT NULL,
    judul VARCHAR(150) NOT NULL,
    file_url TEXT NOT NULL,
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_dokumentasi_kegiatan
        FOREIGN KEY (kegiatan_id)
        REFERENCES kegiatan(id)
        ON DELETE CASCADE
);


-- =====================================================
-- DATA DUMMY
-- =====================================================


-- USERS

INSERT INTO users (username, password, role)
VALUES
('admin_desa', '123456', 'admin'),
('warga_andi', '123456', 'warga'),
('warga_siti', '123456', 'warga');


-- WARGA

INSERT INTO warga
(nik, nama, jenis_kelamin, tanggal_lahir, alamat, no_hp)
VALUES
('3515010101900001', 'Andi Pratama', 'Laki-laki', '1990-01-01',
 'Dusun Krajan RT 01 RW 01', '081234567890'),

('3515010202920002', 'Siti Aminah', 'Perempuan', '1992-02-02',
 'Dusun Krajan RT 02 RW 01', '081234567891'),

('3515010303880003', 'Budi Santoso', 'Laki-laki', '1988-03-03',
 'Dusun Sumber RT 01 RW 02', '081234567892'),

('3515010401950004', 'Dewi Lestari', 'Perempuan', '1995-04-04',
 'Dusun Sumber RT 02 RW 02', '081234567893'),

('3515010502850005', 'Rudi Hartono', 'Laki-laki', '1985-05-05',
 'Dusun Makmur RT 01 RW 03', '081234567894');


-- PROFIL WARGA

INSERT INTO profil_warga
(warga_id, pekerjaan, pendidikan_terakhir, status_pernikahan)
VALUES
(1, 'Petani', 'SMA', 'Menikah'),
(2, 'Guru', 'S1', 'Menikah'),
(3, 'Wiraswasta', 'SMA', 'Menikah'),
(4, 'Bidan', 'D3', 'Menikah'),
(5, 'Petani', 'SMP', 'Menikah');


-- KATEGORI

INSERT INTO kategori
(nama_kategori, deskripsi)
VALUES
('Gotong Royong',
 'Kegiatan kerja bakti dan kebersihan lingkungan desa'),

('Kesehatan',
 'Kegiatan yang berkaitan dengan kesehatan masyarakat'),

('Pendidikan',
 'Kegiatan pendidikan dan pelatihan masyarakat'),

('Sosial',
 'Kegiatan sosial dan kemasyarakatan');


-- LOKASI

INSERT INTO lokasi
(nama_lokasi, alamat, kapasitas)
VALUES
('Balai Desa',
 'Jl. Raya Desa No. 1', 100),

('Lapangan Desa',
 'Jl. Desa Makmur No. 2', 200),

('Posyandu Desa',
 'Dusun Krajan RT 02 RW 01', 50),

('Aula Desa',
 'Jl. Raya Desa No. 3', 75);


-- KEGIATAN

INSERT INTO kegiatan
(kategori_id, lokasi_id, nama_kegiatan, deskripsi, tanggal,
 waktu_mulai, waktu_selesai, penanggung_jawab, status)
VALUES
(
    1,
    2,
    'Gotong Royong Membersihkan Lingkungan',
    'Kegiatan membersihkan lingkungan sekitar desa.',
    '2026-10-25',
    '07:00',
    '10:00',
    'Budi Santoso',
    'direncanakan'
),

(
    2,
    3,
    'Posyandu Balita',
    'Pemeriksaan kesehatan dan penimbangan balita.',
    '2026-10-27',
    '08:00',
    '11:00',
    'Dewi Lestari',
    'direncanakan'
),

(
    3,
    1,
    'Pelatihan Komputer untuk Warga',
    'Pelatihan dasar komputer dan internet.',
    '2026-10-30',
    '09:00',
    '12:00',
    'Andi Pratama',
    'direncanakan'
),

(
    4,
    4,
    'Rapat Koordinasi Desa',
    'Rapat koordinasi kegiatan desa.',
    '2026-11-02',
    '19:00',
    '21:00',
    'Kepala Desa',
    'direncanakan'
);


-- PESERTA KEGIATAN

INSERT INTO peserta_kegiatan
(warga_id, kegiatan_id, status_kehadiran)
VALUES
(1, 1, 'terdaftar'),
(2, 1, 'terdaftar'),
(3, 1, 'hadir'),

(1, 2, 'terdaftar'),
(2, 2, 'terdaftar'),
(4, 2, 'hadir'),

(1, 3, 'terdaftar'),
(3, 3, 'terdaftar'),
(5, 3, 'terdaftar'),

(2, 4, 'terdaftar'),
(3, 4, 'terdaftar');


-- DOKUMENTASI

INSERT INTO dokumentasi
(kegiatan_id, judul, file_url, keterangan)
VALUES
(
    1,
    'Gotong Royong Desa',
    'https://example.com/gotong-royong-1.jpg',
    'Dokumentasi kegiatan gotong royong'
),

(
    2,
    'Kegiatan Posyandu',
    'https://example.com/posyandu-1.jpg',
    'Dokumentasi kegiatan posyandu'
);


-- =====================================================
-- CEK DATA
-- =====================================================

SELECT * FROM users;

SELECT * FROM warga;

SELECT * FROM profil_warga;

SELECT * FROM kategori;

SELECT * FROM lokasi;

SELECT * FROM kegiatan;

SELECT * FROM peserta_kegiatan;

SELECT * FROM dokumentasi;


-- =====================================================
-- QUERY UNTUK MELIHAT RELASI KEGIATAN
-- =====================================================

SELECT
    k.id,
    k.nama_kegiatan,
    kat.nama_kategori,
    l.nama_lokasi,
    k.tanggal,
    k.waktu_mulai,
    k.waktu_selesai,
    k.penanggung_jawab,
    k.status
FROM kegiatan k
JOIN kategori kat
    ON k.kategori_id = kat.id
JOIN lokasi l
    ON k.lokasi_id = l.id
ORDER BY k.tanggal;


-- =====================================================
-- QUERY MANY TO MANY
-- WARGA YANG MENGIKUTI KEGIATAN
-- =====================================================

SELECT
    w.nama AS nama_warga,
    k.nama_kegiatan,
    pk.status_kehadiran
FROM peserta_kegiatan pk
JOIN warga w
    ON pk.warga_id = w.id
JOIN kegiatan k
    ON pk.kegiatan_id = k.id
ORDER BY k.tanggal;