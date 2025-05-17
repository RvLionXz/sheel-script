const { Pool } = require('pg');

// Ganti dengan konfigurasi database PostgreSQL kamu
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'db_test',
  password: 'P@sW0rDKu@7!',
  port: 5432,
});

module.exports = pool;
