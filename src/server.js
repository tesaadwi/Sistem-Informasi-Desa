const express = require('express');
const cors = require('cors');
require('dotenv').config();

const kegiatanRoutes = require('./routes/kegiatanRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.json({
        message: 'REST API Sistem Informasi Kegiatan Desa',
        status: 'API berjalan'
    });
});

app.use('/api/kegiatan', kegiatanRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server berjalan pada http://localhost:${PORT}`);
});