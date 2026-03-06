const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors());
app.use(express.json());

const authRoutes = require("./routes/auth.routes");
app.use("/api/auth", authRoutes);

app.get("/", (req, res) => {
  res.send("Servidor funcionando correctamente");
});

app.listen(3000, '0.0.0.0', () => {
  console.log("Server running on http://0.0.0.0:3000");
});