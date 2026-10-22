const express = require('express');
const router = express.Router();
const pool = require('../config/database');

// =====================================================
// GET - Mendapatkan semua data kegiatan
// =====================================================

router.get('/', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT
                k.id,
                k.nama_kegiatan,
                k.deskripsi,
                k.tanggal,
                k.waktu_mulai,
                k.waktu_selesai,
                k.penanggung_jawab,
                k.status,
                kat.nama_kategori,
                l.nama_lokasi,
                l.alamat AS alamat_lokasi
            FROM kegiatan k
            JOIN kategori kat
                ON k.kategori_id = kat.id
            JOIN lokasi l
                ON k.lokasi_id = l.id
            ORDER BY k.tanggal ASC
        `);

        res.status(200).json({
            success: true,
            message: 'Data kegiatan berhasil diambil',
            data: result.rows
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data kegiatan',
            error: error.message
        });
    }
});


// =====================================================
// GET - Mendapatkan kegiatan berdasarkan ID
// =====================================================

router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const result = await pool.query(`
            SELECT
                k.id,
                k.nama_kegiatan,
                k.deskripsi,
                k.tanggal,
                k.waktu_mulai,
                k.waktu_selesai,
                k.penanggung_jawab,
                k.status,
                kat.nama_kategori,
                l.nama_lokasi,
                l.alamat AS alamat_lokasi
            FROM kegiatan k
            JOIN kategori kat
                ON k.kategori_id = kat.id
            JOIN lokasi l
                ON k.lokasi_id = l.id
            WHERE k.id = $1
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Kegiatan tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Data kegiatan berhasil ditemukan',
            data: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data kegiatan',
            error: error.message
        });
    }
});


// =====================================================
// POST - Menambahkan kegiatan baru
// =====================================================

router.post('/', async (req, res) => {
    try {
        const {
            kategori_id,
            lokasi_id,
            nama_kegiatan,
            deskripsi,
            tanggal,
            waktu_mulai,
            waktu_selesai,
            penanggung_jawab,
            status
        } = req.body;

        if (
            !kategori_id ||
            !lokasi_id ||
            !nama_kegiatan ||
            !tanggal ||
            !waktu_mulai ||
            !penanggung_jawab
        ) {
            return res.status(400).json({
                success: false,
                message: 'Data wajib belum lengkap'
            });
        }

        const result = await pool.query(`
            INSERT INTO kegiatan (
                kategori_id,
                lokasi_id,
                nama_kegiatan,
                deskripsi,
                tanggal,
                waktu_mulai,
                waktu_selesai,
                penanggung_jawab,
                status
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            RETURNING *
        `, [
            kategori_id,
            lokasi_id,
            nama_kegiatan,
            deskripsi || null,
            tanggal,
            waktu_mulai,
            waktu_selesai || null,
            penanggung_jawab,
            status || 'direncanakan'
        ]);

        res.status(201).json({
            success: true,
            message: 'Kegiatan berhasil ditambahkan',
            data: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Gagal menambahkan kegiatan',
            error: error.message
        });
    }
});


// =====================================================
// PUT - Memperbarui kegiatan
// =====================================================

router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const {
            kategori_id,
            lokasi_id,
            nama_kegiatan,
            deskripsi,
            tanggal,
            waktu_mulai,
            waktu_selesai,
            penanggung_jawab,
            status
        } = req.body;

        if (
            !kategori_id ||
            !lokasi_id ||
            !nama_kegiatan ||
            !tanggal ||
            !waktu_mulai ||
            !penanggung_jawab
        ) {
            return res.status(400).json({
                success: false,
                message: 'Data wajib belum lengkap'
            });
        }

        const result = await pool.query(`
            UPDATE kegiatan
            SET
                kategori_id = $1,
                lokasi_id = $2,
                nama_kegiatan = $3,
                deskripsi = $4,
                tanggal = $5,
                waktu_mulai = $6,
                waktu_selesai = $7,
                penanggung_jawab = $8,
                status = $9
            WHERE id = $10
            RETURNING *
        `, [
            kategori_id,
            lokasi_id,
            nama_kegiatan,
            deskripsi || null,
            tanggal,
            waktu_mulai,
            waktu_selesai || null,
            penanggung_jawab,
            status || 'direncanakan',
            id
        ]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Kegiatan tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Kegiatan berhasil diperbarui',
            data: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Gagal memperbarui kegiatan',
            error: error.message
        });
    }
});


// =====================================================
// DELETE - Menghapus kegiatan
// =====================================================

router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const result = await pool.query(`
            DELETE FROM kegiatan
            WHERE id = $1
            RETURNING *
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Kegiatan tidak ditemukan'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Kegiatan berhasil dihapus',
            data: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Gagal menghapus kegiatan',
            error: error.message
        });
    }
});


module.exports = router;