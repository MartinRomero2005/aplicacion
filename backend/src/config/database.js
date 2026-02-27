const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Ruta del archivo database.sqlite (en la raíz del backend)
const dbPath = path.resolve(__dirname, '../../database.sqlite');

// Crear o conectar base de datos
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error("❌ Error conectando a SQLite:", err.message);
    } else {
        console.log("✅ Conectado a SQLite correctamente");
    }
});

// Crear tabla users si no existe
db.run(`
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
`);

module.exports = db;