const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const SECRET_KEY = "clave_super_secreta";

// ==================
// BASE DE DATOS
// ==================
const db = new sqlite3.Database('./database.sqlite', (err) => {
    if (err) {
        console.error("Error conectando a SQLite", err);
    } else {
        console.log("Conectado a SQLite");
    }
});

db.serialize(() => {
    db.run(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
        )
    `);

    db.run(`
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            price REAL,
            category TEXT,
            image TEXT
        )
    `);

    db.run(`
        CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            total REAL,
            status TEXT,
            payment_method TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    `);
});

// ==================
// AUTH
// ==================
app.post('/api/auth/register', async (req, res) => {
    const { email, password } = req.body;

    const hashedPassword = await bcrypt.hash(password, 10);

    db.run(
        `INSERT INTO users (email, password) VALUES (?, ?)`,
        [email, hashedPassword],
        function (err) {
            if (err) {
                return res.status(400).json({ error: "Usuario ya existe" });
            }
            res.json({ message: "Usuario registrado correctamente" });
        }
    );
});

app.post('/api/auth/login', (req, res) => {
    const { email, password } = req.body;

    db.get(
        `SELECT * FROM users WHERE email = ?`,
        [email],
        async (err, user) => {
            if (!user) {
                return res.status(400).json({ error: "Usuario no encontrado" });
            }

            const validPassword = await bcrypt.compare(password, user.password);

            if (!validPassword) {
                return res.status(400).json({ error: "Contraseña incorrecta" });
            }

            const token = jwt.sign({ id: user.id }, SECRET_KEY);
            res.json({ token });
        }
    );
});

// ==================
// PRODUCTOS
// ==================
app.get('/api/products', (req, res) => {
    db.all(`SELECT * FROM products`, [], (err, rows) => {
        res.json(rows);
    });
});

// ==================
// SERVIDOR
// ==================
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});