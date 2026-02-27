const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const SECRET_KEY = "super_secret_key"; // luego puedes moverlo a .env

// ===============================
// REGISTRO
// ===============================
exports.register = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: "Email y contraseña requeridos" });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);

        db.run(
            `INSERT INTO users (email, password) VALUES (?, ?)`,
            [email, hashedPassword],
            function (err) {
                if (err) {
                    return res.status(400).json({ error: "El usuario ya existe" });
                }

                res.status(201).json({
                    message: "Usuario registrado correctamente",
                    userId: this.lastID
                });
            }
        );
    } catch (error) {
        res.status(500).json({ error: "Error en el servidor" });
    }
};

// ===============================
// LOGIN
// ===============================
exports.login = (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: "Email y contraseña requeridos" });
    }

    db.get(
        `SELECT * FROM users WHERE email = ?`,
        [email],
        async (err, user) => {
            if (err) {
                return res.status(500).json({ error: "Error en el servidor" });
            }

            if (!user) {
                return res.status(400).json({ error: "Usuario no encontrado" });
            }

            const isMatch = await bcrypt.compare(password, user.password);

            if (!isMatch) {
                return res.status(400).json({ error: "Contraseña incorrecta" });
            }

            const token = jwt.sign(
                { id: user.id, email: user.email },
                SECRET_KEY,
                { expiresIn: "1h" }
            );

            res.json({
                message: "Login exitoso",
                token
            });
        }
    );
};