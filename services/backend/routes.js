const express = require('express');
const router = express.Router();
const db = require('./db');

// CREATE
router.post('/items', async (req, res) => {
  const { name } = req.body;
  const result = await db.query('INSERT INTO items (name) VALUES ($1) RETURNING *', [name]);
  res.json(result.rows[0]);
});

// READ
router.get('/items', async (req, res) => {
  const result = await db.query('SELECT * FROM items ORDER BY id');
  res.json(result.rows);
});

// UPDATE
router.put('/items/:id', async (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  const result = await db.query('UPDATE items SET name = $1 WHERE id = $2 RETURNING *', [name, id]);
  res.json(result.rows[0]);
});

// DELETE
router.delete('/items/:id', async (req, res) => {
  const { id } = req.params;
  await db.query('DELETE FROM items WHERE id = $1', [id]);
  res.sendStatus(204);
});

module.exports = router;
