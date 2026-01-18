const express = require("express");
const router = express.Router();
const upload = require("../middlewares/upload");
const verifyJWT = require("../middlewares/verifyJWT");
const pool = require("../db");

router.post(
  "/profile/photo",
  verifyJWT,
  // wrap multer usage in a small handler to capture multer errors
  (req, res, next) => {
    upload.single("photo")(req, res, (err) => {
      if (err) {
        console.error("Multer error during profile photo upload:", err.stack || err);
        return res.status(400).json({ error: err.message || "Upload error" });
      }
      next();
    });
  },
  async (req, res) => {
    try {
      console.log("Profile photo upload attempt:", {
        userId: req.user?.id,
        file: req.file ? { filename: req.file.filename, path: req.file.path, size: req.file.size } : null,
      });

      if (!req.file) {
        return res.status(400).json({ error: "Aucune image envoyée" });
      }

      const photoUrl = `/uploads/profile/${req.file.filename}`;

      await pool.query(
        "UPDATE users SET profile_photo_url = ? WHERE id = ?",
        [photoUrl, req.user.id]
      );

      res.json({ profile_photo_url: photoUrl });
    } catch (err) {
      console.error("Profile photo handler error:", err.stack || err);
      res.status(500).json({ error: "Erreur serveur" });
    }
  }
);

module.exports = router;