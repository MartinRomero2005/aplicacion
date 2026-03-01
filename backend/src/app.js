console.log("🔥 ESTE ES EL BACKEND CORRECTO 🔥");
const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors());
app.use(express.json());

const authRoutes = require("./routes/auth.routes");
app.use("/api/auth", authRoutes);

app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});