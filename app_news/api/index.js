const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// SQLite database file for news
const dbPath = path.join(__dirname, 'noticias.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Erro ao abrir banco de notícias:', err);
  } else {
    console.log('Banco de notícias aberto em:', dbPath);
    setup();
  }
});

function setup() {
  db.serialize(() => {
    db.run(`
      CREATE TABLE IF NOT EXISTS noticias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        resumo TEXT,
        conteudo TEXT,
        autor TEXT,
        categoria TEXT,
        notificacao INTEGER DEFAULT 0,
        created_at TEXT
      )
    `);

    // seed if empty
    db.get('SELECT COUNT(*) AS count FROM noticias', (err, row) => {
      if (err) {
        console.error('Erro ao contar noticias:', err);
        return;
      }
      if ((row?.count ?? 0) === 0) {
        const now = new Date().toISOString();
        const stmt = db.prepare(
          'INSERT INTO noticias (titulo, resumo, conteudo, autor, categoria, notificacao, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
        );

        const seed = [
          ['Lançamento do App X', 'App X chega com novas funcionalidades', 'Descrição detalhada do lançamento e funcionalidades do App X.', 'Equipe Produto', 'Lançamentos', 1, now],
          ['Manutenção programada', 'Interrupção breve nos serviços', 'Teremos uma manutenção programada no fim de semana.', 'Infra', 'Avisos', 1, now],
          ['Dica de produtividade', 'Melhore sua rotina com 3 passos', 'Conteúdo completo com dicas práticas para rotina.', 'Blog', 'Dicas', 0, now],
        ];

        seed.forEach(item => stmt.run(item));
        stmt.finalize();
        console.log('Seed de notícias inserido em noticias.db');
      }
    });
  });
}

app.get('/noticias', (req, res) => {
  db.all('SELECT * FROM noticias ORDER BY created_at DESC', (err, rows) => {
    if (err) {
      console.error('Erro ao buscar noticias:', err);
      return res.status(500).json({ success: false, message: 'Erro interno do servidor' });
    }
    res.json({ success: true, data: rows, message: 'Notícias carregadas com sucesso' });
  });
});

app.get('/', (req, res) => {
  res.json({ message: 'API de Notícias funcionando!', version: '1.1.0', endpoints: ['GET /noticias - Lista todas as notícias'] });
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});

module.exports = app;
