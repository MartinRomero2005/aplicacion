const db = require("../config/database");
const bcrypt = require("bcryptjs");

// =============================
// REGISTER
// =============================
const register = async (req, res) => {
  console.log("🔥 REGISTER ENDPOINT HIT 🔥");

  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    db.run(
      `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`,
      [name.trim(), email.trim().toLowerCase(), hashedPassword],
      function (err) {
        if (err) {
          console.error("DB ERROR:", err.message);
          return res.status(500).json({ message: err.message });
        }

        return res.status(201).json({
          message: "User registered successfully",
          user: {
            id: this.lastID,
            name,
            email,
          },
        });
      }
    );
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Server error" });
  }
};

// =============================
// LOGIN
// =============================
const login = (req, res) => {
  console.log("🔥 LOGIN ENDPOINT HIT 🔥");

  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  const cleanEmail = email.trim().toLowerCase();

  db.get(
    `SELECT * FROM users WHERE LOWER(email) = ?`,
    [cleanEmail],
    async (err, user) => {
      if (err) {
        console.error("DB ERROR:", err);
        return res.status(500).json({ message: "Server error" });
      }

      if (!user) {
        console.log("❌ USER NOT FOUND:", cleanEmail);
        return res.status(400).json({ message: "Invalid credentials" });
      }

      const isMatch = await bcrypt.compare(password, user.password);

      if (!isMatch) {
        return res.status(400).json({ message: "Invalid credentials" });
      }

      return res.status(200).json({
        message: "Login successful",
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
        },
      });
    }
  );
};

// =============================
// VERIFY EMAIL
// =============================
const verifyEmail = (req, res) => {
  const { email } = req.body;

  console.log("📩 VERIFY EMAIL REQUEST:", email);

  if (!email) {
    return res.status(400).json({ message: "Email requerido" });
  }

  const cleanEmail = email.trim().toLowerCase();

  db.get(
    `SELECT id FROM users WHERE LOWER(email) = ?`,
    [cleanEmail],
    (err, user) => {

      console.log("🔍 DB RESULT:", user);

      if (err) {
        console.error("DB ERROR:", err);
        return res.status(500).json({ message: "Error del servidor" });
      }

      if (!user) {
        console.log("❌ EMAIL NOT FOUND:", cleanEmail);
        return res.status(404).json({ message: "Correo no encontrado" });
      }

      console.log("✅ EMAIL FOUND:", cleanEmail);

      return res.status(200).json({
        message: "Correo válido",
      });
    }
  );
};

const resetPassword = async (req, res) => {
  const { email, password } = req.body;

  console.log("🔑 RESET PASSWORD REQUEST:", email);

  if (!email || !password) {
    return res.status(400).json({ message: "Datos incompletos" });
  }

  const cleanEmail = email.trim().toLowerCase();

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    db.run(
      `UPDATE users SET password = ? WHERE LOWER(email) = ?`,
      [hashedPassword, cleanEmail],
      function (err) {

        if (err) {
          console.error("DB ERROR:", err);
          return res.status(500).json({ message: "Error del servidor" });
        }

        if (this.changes === 0) {
          console.log("❌ USER NOT FOUND FOR PASSWORD RESET");
          return res.status(404).json({ message: "Usuario no encontrado" });
        }

        console.log("✅ PASSWORD UPDATED");

        return res.status(200).json({
          message: "Contraseña actualizada correctamente",
        });
      }
    );

  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Error del servidor" });
  }
};

module.exports = {
  register,
  login,
  verifyEmail,
  resetPassword,
};