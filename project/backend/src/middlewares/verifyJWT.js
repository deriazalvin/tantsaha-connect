const jwt = require("jsonwebtoken");
const JWT_SECRET = process.env.JWT_SECRET || "change_me";

function verifyJWT(req, res, next) {
    const auth = req.headers.authorization;
    if (!auth || !auth.startsWith("Bearer ")) {
        return res.status(401).json({ error: "Unauthorized" });
    }

    try {
        req.user = jwt.verify(auth.slice(7), JWT_SECRET);
        next();
    } catch {
        return res.status(401).json({ error: "Invalid token" });
    }
}

module.exports = verifyJWT;
