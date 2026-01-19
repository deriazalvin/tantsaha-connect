const express = require("express");
const router = express.Router();
const upload = require("../middlewares/upload");
const verifyJWT = require("../middlewares/verifyJWT");
const pool = require("../db");

const cloudinary = require("cloudinary").v2;
const streamifier = require("streamifier");

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

router.post(
  "/profile/photo",
  verifyJWT,
  upload.single("photo"),
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "Aucune image envoyée" });
      }

      console.log("Profile photo upload attempt:", {
        userId: req.user?.id,
        file: { originalname: req.file.originalname, size: req.file.size },
      });

      // uploader le buffer vers Cloudinary via un upload_stream
      const uploadStream = cloudinary.uploader.upload_stream(
        {
          folder: `profiles/${req.user.id}`,
          resource_type: "image",
          // transformations optionnelles, ex: crop, resize
          transformation: [{ width: 800, height: 800, crop: "limit" }],
        },
        async (error, result) => {
          if (error) {
            console.error("Cloudinary upload error:", error);
            return res.status(500).json({ error: "Upload failed" });
          }

          const photoUrl = result.secure_url;

          // sauvegarder l'URL retournée dans la base
          await pool.query(
            "UPDATE users SET profile_photo_url = ? WHERE id = ?",
            [photoUrl, req.user.id]
          );

          res.json({ profile_photo_url: photoUrl });
        }
      );

      streamifier.createReadStream(req.file.buffer).pipe(uploadStream);
    } catch (err) {
      console.error("Profile photo handler error:", err.stack || err);
      res.status(500).json({ error: "Erreur serveur" });
    }
  }
);

module.exports = router;