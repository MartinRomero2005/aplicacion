const express = require("express");
const router = express.Router();

const {
  register,
  login,
  verifyEmail,
  resetPassword,
} = require("../controllers/auth.controller");

router.post("/register", register);
router.post("/login", login);
router.post("/verify-email", verifyEmail);
router.post("/reset-password", resetPassword);

module.exports = router;