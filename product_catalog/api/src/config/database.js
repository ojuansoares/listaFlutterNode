const sqlite3 = require('sqlite3').verbose();
const path = require('path');

class Database {
  constructor() {
    this.db = null;
    this.init();
  }

  init() {
    const dbPath = path.join(__dirname, '..', '..', 'produtos.db');
    
    this.db = new sqlite3.Database(dbPath, (err) => {
      if (err) {
        console.error('Erro ao abrir o banco SQLite:', err);
      } else {
        console.log('SQLite aberto em:', dbPath);
        this.setupTables();
      }
    });
  }

  setupTables() {
    this.db.serialize(() => {
      // Criar tabela de produtos
      this.db.run(`
        CREATE TABLE IF NOT EXISTS produtos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            preco REAL NOT NULL,
            descricao TEXT,
            categoria TEXT DEFAULT 'Geral',
            estoque INTEGER DEFAULT 0,
            sku TEXT,
            updated_at TEXT
        )
      `, (err) => {
        if (err) {
          console.error('Erro CREATE TABLE:', err);
        }
      });

      // Verificar e aplicar migração para coluna updated_at
      this.applyMigrations();
    });
  }

  applyMigrations() {
    this.db.all(`PRAGMA table_info(produtos)`, (err, cols) => {
      if (err) {
        console.error('Erro ao obter schema:', err);
        return;
      }

      const existing = Array.isArray(cols) ? cols.map(c => c.name) : [];

      const migrations = [];

      if (!existing.includes('categoria')) {
        migrations.push({ sql: `ALTER TABLE produtos ADD COLUMN categoria TEXT DEFAULT 'Geral'` , name: 'categoria' });
      }
      if (!existing.includes('estoque')) {
        migrations.push({ sql: `ALTER TABLE produtos ADD COLUMN estoque INTEGER DEFAULT 0`, name: 'estoque' });
      }
      if (!existing.includes('sku')) {
        migrations.push({ sql: `ALTER TABLE produtos ADD COLUMN sku TEXT`, name: 'sku' });
      }
      if (!existing.includes('updated_at')) {
        migrations.push({ sql: `ALTER TABLE produtos ADD COLUMN updated_at TEXT`, name: 'updated_at' });
      }

      if (migrations.length === 0) {
        this.seedInitialData();
        return;
      }

      console.log('Aplicando migrações:', migrations.map(m => m.name).join(', '));

      const runNext = (i = 0) => {
        if (i >= migrations.length) {
          // depois de aplicar todas, atualiza registros e semente
          this.updateExistingRecords();
          return;
        }
        const mig = migrations[i];
        this.db.run(mig.sql, (err) => {
          if (err) console.error(`Erro ao aplicar migração ${mig.name}:`, err.message);
          runNext(i + 1);
        });
      };

      runNext();
    });
  }

  updateExistingRecords() {
    const now = new Date().toISOString();
    this.db.run(
      `UPDATE produtos SET updated_at = ? WHERE updated_at IS NULL OR updated_at = ''`,
      [now],
      (err) => {
        if (err) {
          console.error('Erro ao popular updated_at:', err);
        } else {
          console.log('Migração concluída: updated_at criada e populada.');
        }
        this.seedInitialData();
      }
    );
  }

  seedInitialData() {
    this.db.get('SELECT COUNT(*) AS count FROM produtos', (err, row) => {
      if (err) {
        console.error('Erro ao contar produtos:', err);
        return;
      }
      
      if ((row?.count ?? 0) === 0) {
        const now = new Date().toISOString();
        const stmt = this.db.prepare(
          'INSERT INTO produtos (nome, preco, descricao, categoria, estoque, sku, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
        );

        const initialProducts = [
          ['Fone Bluetooth Pro', 249.9, 'Fone Bluetooth com cancelamento de ruído ativo', 'Áudio', 30, 'FON-BT-PRO', now],
          ['Teclado Mecânico K3', 349.0, 'Teclado mecânico compacto, switches azuis', 'Periféricos', 40, 'TEC-K3-349', now],
          ['Cadeira Gamer Viper', 899.0, 'Cadeira ergonômica com ajuste lombar e de altura', 'Mobília', 15, 'CHA-VIP-899', now],
          ['Monitor 27" 144Hz', 1299.0, 'Monitor FullHD 144Hz com Freesync', 'Monitores', 25, 'MON-27-144', now],
          ['SSD 1TB NVMe', 499.0, 'Armazenamento NVMe de alta velocidade', 'Armazenamento', 80, 'SSD-1TB-NV', now],
          ['Webcam HD 1080p', 199.0, 'Webcam com microfone integrado e autofoco', 'Periféricos', 60, 'WEB-1080-199', now],
        ];

        initialProducts.forEach(product => {
          stmt.run(product[0], product[1], product[2], product[3], product[4], product[5], product[6]);
        });
        
        stmt.finalize();
        console.log('Seed inicial inserido em produtos.db');
      }
    });
  }

  getConnection() {
    return this.db;
  }

  close() {
    if (this.db) {
      this.db.close((err) => {
        if (err) {
          console.error('Erro ao fechar banco:', err);
        } else {
          console.log('Conexão com banco fechada.');
        }
      });
    }
  }
}

module.exports = new Database();