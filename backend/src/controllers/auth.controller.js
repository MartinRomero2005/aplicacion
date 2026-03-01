const db = require("../config/database");
const bcrypt = require("bcrypt");

// =========================
// REGISTER
// =========================
const register = async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    db.run(
      `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`,
      [name, email, hashedPassword],
      function (err) {
        if (err) {
          return res.status(400).json({ message: "User already exists" });
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
    return res.status(500).json({ message: "Server error" });
  }
};

// =========================
// LOGIN
// =========================
const login = (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  db.get(
    `SELECT * FROM users WHERE email = ?`,
    [email],
    async (err, user) => {
      if (err || !user) {
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

module.exports = { register, login };