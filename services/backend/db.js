const { Pool } = require('pg');

// Ganti dengan konfigurasi database PostgreSQL kamu
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'testdb',
  password: 'yourpassword',
  port: 5432,
});

module.exports = pool;
