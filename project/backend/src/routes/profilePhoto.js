const express = require("express");
const router = express.Router();
const upload = require("../middlewares/upload");
const verifyJWT = require("../middlewares/verifyJWT");
const pool = require("../db");

// POST /api/profile/photo
router.post(
    "/profile/photo",
    verifyJWT,
    upload.single("photo"), // juste "photo", pas de second argument
    async (req, res) => {
        try {
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
            console.error(err);
            res.status(500).json({ error: "Erreur serveur" });
        }
    }
);

module.exports = router; // important !
