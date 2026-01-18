const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const path = require("path");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const pool = require("./db");

dotenv.config();
const app = express();
const PORT = process.env.PORT || 4000;
const JWT_SECRET = process.env.JWT_SECRET || "change_me";

// =========================
// ALLOWED ORIGINS
// =========================
const allowedOrigins = [
    "https://tantsaha-connect.vercel.app",
    "https://tantsaha-connect-beta.vercel.app",
    "http://localhost:5173", // tests locaux
];

// =========================
// BODY PARSERS
// =========================
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// =========================
// CORS
// =========================
app.use(cors({
    origin: function(origin, callback) {
        if (!origin) return callback(null, true); // server-to-server / Postman
        if (allowedOrigins.includes(origin)) return callback(null, true);
        console.warn("CORS rejected origin:", origin);
        return callback(new Error("CORS non autorisé"));
    },
    credentials: true,
    methods: ["GET","POST","PUT","DELETE","OPTIONS"],
    allowedHeaders: ["Content-Type","Authorization"]
}));

app.options("*", cors()); 

// =========================
// UPLOADS STATICS
// =========================
app.use(
    "/uploads",
    express.static(path.join(__dirname, "uploads"))
);
console.log("Uploads folder path:", path.join(__dirname, "uploads"));

// =========================
// JWT MIDDLEWARE
// =========================
function verifyJWT(req, res, next) {
    const auth = req.headers.authorization;
    if (!auth || !auth.startsWith("Bearer ")) {
        return res.status(401).json({ error: "Unauthorized" });
    }

    try {
        req.user = jwt.verify(auth.slice(7), JWT_SECRET);
        next();
    } catch (err) {
        console.error("JWT error:", err);
        return res.status(401).json({ error: "Invalid token" });
    }
}

// =========================
// PROFILE PHOTO ROUTER
// =========================
const profilePhotoRouter = require("./routes/profilePhoto");
app.use("/api", profilePhotoRouter);


// =========================
// UTILS
// =========================
function mapWeatherCode(code) {
    if (code === 0) return "Clear";
    if ([1, 2, 3].includes(code)) return "Cloudy";
    if ([45, 48].includes(code)) return "Fog";
    if ([51, 53, 55, 61, 63, 65].includes(code)) return "Rain";
    if ([71, 73, 75].includes(code)) return "Snow";
    if ([95, 96, 99].includes(code)) return "Thunderstorm";
    return "Unknown";
}

// =======================================
// FISORATANA ANARANA SY FAMORONANA KAONTY
// =======================================
app.post("/auth/signup", async (req, res) => {
    const { email, password, full_name } = req.body;
    if (!email || !password) return res.status(400).json({ error: "Missing fields" });

    try {
        const [exists] = await pool.query("SELECT id FROM users WHERE email = ?", [email]);
        if (exists.length) return res.status(400).json({ error: "User exists" });

        const hash = await bcrypt.hash(password, 10);
        await pool.query("INSERT INTO users (id, email, password_hash) VALUES (UUID(), ?, ?)", [
            email,
            hash,
        ]);

        const [[user]] = await pool.query("SELECT id FROM users WHERE email = ?", [email]);
        await pool.query("UPDATE users SET full_name = ? WHERE id = ?", [full_name || null, user.id]);

        const token = jwt.sign({ id: user.id, email }, JWT_SECRET, { expiresIn: "7d" });
        res.json({ token, user });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: "Signup failed" });
    }
});

app.post("/auth/login", async (req, res) => {
    const { email, password } = req.body;

    try {
        const [[user]] = await pool.query("SELECT * FROM users WHERE email = ?", [email]);
        if (!user) return res.status(401).json({ error: "Invalid credentials" });

        const ok = await bcrypt.compare(password, user.password_hash);
        if (!ok) return res.status(401).json({ error: "Invalid credentials" });

        const token = jwt.sign({ id: user.id, email }, JWT_SECRET, { expiresIn: "7d" });
        res.json({ token, user: { id: user.id, email } });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: "Login failed" });
    }
});

// =========================
// TOETRANDRO
// =========================
app.post("/api/weather/refresh", async (req, res) => {
    const { latitude, longitude, place_name, placename, region, country } = req.body || {};
    const finalPlaceName = place_name || placename;
    if (typeof latitude !== "number" || typeof longitude !== "number" || !finalPlaceName) {
        return res.status(400).json({ error: "Missing location data" });
    }

    try {
        // Timeout 5s pour éviter blocage
        const controller = new AbortController();
        setTimeout(() => controller.abort(), 5000);

        const result = await fetchWeatherForLocation({
            latitude,
            longitude,
            place_name: finalPlaceName,
            region,
            country,
            signal: controller.signal
        });

        res.json(result);
    } catch (err) {
        console.error("/weather/refresh error:", err);
        res.status(500).json({ error: "Weather fetch failed" });
    }
});

app.get("/api/weather/current/:locationId", async (req, res) => {
    const { locationId } = req.params;

    const [[row]] = await pool.query(
        `SELECT w.temperature, w.weather_code, w.forecast_time AS time, l.place_name
     FROM weather_hourly w
     JOIN weather_locations l ON l.id = w.location_id
     WHERE w.location_id = ?
     ORDER BY w.forecast_time DESC
     LIMIT 1`,
        [locationId]
    );

    if (!row) return res.json(null);

    function codeToCondition(code) {
        if (code === 0) return "Clear";
        if ([1, 2].includes(code)) return "Cloudy";
        if (code === 3) return "Overcast";
        if (code >= 51 && code <= 67) return "Rain";
        if (code >= 80 && code <= 82) return "Rainy";
        if (code >= 95) return "Thunderstorm";
        return "Cloudy";
    }

    res.json({
        temperature: row.temperature,
        condition: codeToCondition(row.weather_code),
        icon: row.weather_code,
        place_name: row.place_name,
        time: row.time,
    });
});

app.get("/api/weather/hourly/:locationId", async (req, res) => {
    const { locationId } = req.params;
    try {
        const [rows] = await pool.query(
            `SELECT forecast_time, temperature AS temp, wind_speed AS wind, humidity, weather_code
       FROM weather_hourly
       WHERE location_id = ? AND forecast_time >= NOW() AND forecast_time <= DATE_ADD(NOW(), INTERVAL 24 HOUR)
       ORDER BY forecast_time`,
            [locationId]
        );
        res.json(rows);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: "Failed to load hourly forecast" });
    }
});

app.get("/api/weather/daily/:locationId", async (req, res) => {
    const { locationId } = req.params;
    try {
        const [rows] = await pool.query(
            `SELECT forecast_date, temp_min, temp_max, weather_code
       FROM weather_daily
       WHERE location_id = ?
       ORDER BY forecast_date
       LIMIT 7`,
            [locationId]
        );
        res.json(rows.map((d) => ({ ...d, condition: mapWeatherCode(d.weather_code) })));
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: "Failed to load daily forecast" });
    }
});



// =========================
// PHOTO DE PROFILE
// =========================
app.get("/api/users/me", verifyJWT, async (req, res) => {
    try {
        const [rows] = await pool.query(
            `SELECT u.id, u.email, u.full_name, u.phone, u.profile_photo_url,
                r.id AS region_id, r.name AS region_name
            FROM users u
            LEFT JOIN regions r ON r.id = u.region_id
            WHERE u.id = ?`,
            [req.user.id]
        );

        if (!rows.length) return res.status(404).json({ error: "Utilisateur introuvable" });

        const u = rows[0];
        res.json({
            id: u.id,
            email: u.email,
            full_name: u.full_name,
            phone: u.phone,
            profile_photo_url: u.profile_photo_url,
            region: u.region_id ? { id: u.region_id, name: u.region_name } : null,
        });
    } catch (err) {
        console.error("/users/me error:", err);
        res.status(500).json({ error: "Server error" });
    }
});

app.post("/api/users/profile", verifyJWT, async (req, res) => {
    console.log("POST /api/users/profile body:", req.body);
    const { full_name, phone } = req.body;

    try {
        await pool.query(
            "UPDATE users SET full_name = ?, phone = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?",
            [full_name, phone, req.user.id]
        );
        const [[user]] = await pool.query(
            "SELECT id, email, full_name, phone, profile_photo_url FROM users WHERE id = ?",
            [req.user.id]
        );
        res.json(user);
    } catch (err) {
        console.error("Update profile error:", err);
        res.status(500).json({ error: "Update failed" });
    }
});


// =========================
// NAOTY
// =========================
app.get("/api/journal", verifyJWT, async (req, res) => {
    const [rows] = await pool.query("SELECT * FROM crop_journal WHERE user_id = ? ORDER BY observation_date DESC", [
        req.user.id,
    ]);
    res.json(rows);
});

app.post("/api/journal", verifyJWT, async (req, res) => {
    const { observation_date, observation_type, crop_type, notes_mg } = req.body;
    await pool.query(
        "INSERT INTO crop_journal (id, user_id, observation_date, observation_type, crop_type, notes_mg) VALUES (UUID(), ?, ?, ?, ?, ?)",
        [req.user.id, observation_date, observation_type, crop_type, notes_mg]
    );
    res.json({ ok: true });
});

app.put("/api/journal/:id", verifyJWT, async (req, res) => {
    const { id } = req.params;
    const { observation_date, observation_type, crop_type, notes_mg } = req.body;

    if (!observation_date || !observation_type) return res.status(400).json({ error: "Missing fields" });

    try {
        const result = await pool.query(
            "UPDATE crop_journal SET observation_date = ?, observation_type = ?, crop_type = ?, notes_mg = ? WHERE id = ? AND user_id = ?",
            [observation_date, observation_type, crop_type ?? null, notes_mg ?? null, id, req.user.id]
        );
        const affected = result?.affectedRows ?? result?.[0]?.affectedRows;
        if (!affected) return res.status(404).json({ error: "Journal not found" });

        const [row] = await pool.query("SELECT * FROM crop_journal WHERE id = ? AND user_id = ?", [id, req.user.id]);
        res.json(row?.[0] ?? null);
    } catch (e) {
        console.error("Update journal error", e);
        res.status(500).json({ error: "Update failed" });
    }
});

app.delete("/api/journal/:id", verifyJWT, async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query("DELETE FROM crop_journal WHERE id = ? AND user_id = ?", [id, req.user.id]);
        const affected = result?.affectedRows ?? result?.[0]?.affectedRows;
        if (!affected) return res.status(404).json({ error: "Journal not found" });
        res.json({ ok: true });
    } catch (e) {
        console.error("Delete journal error", e);
        res.status(500).json({ error: "Delete failed" });
    }
});

// ==============================
// TOROHEVITRA SY FAMPITANDREMANA
// ==============================
app.get("/api/advice/by-weather/:locationId", async (req, res) => {
    const { locationId } = req.params;
    const limit = Math.min(parseInt(req.query.limit || "20", 10) || 20, 50);

    try {
        const [[w]] = await pool.query(
            `SELECT w.temperature, w.wind_speed, w.humidity, w.weather_code, w.forecast_time, l.place_name
       FROM weather_hourly w
       JOIN weather_locations l ON l.id = w.location_id
       WHERE w.location_id = ?
       ORDER BY w.forecast_time DESC
       LIMIT 1`,
            [locationId]
        );

        if (!w) return res.json({ meta: null, advices: [] });

        const [advices] = await pool.query(
            `SELECT id, crop_type, season, title_mg, content_mg, icon, created_at
       FROM agricultural_advices
       ORDER BY created_at DESC
       LIMIT ?`,
            [limit]
        );

        res.json({
            meta: {
                locationId,
                place_name: w.place_name,
                forecast_time: w.forecast_time,
                temperature: Number(w.temperature),
                wind: Number(w.wind_speed),
                humidity: Number(w.humidity),
            },
            advices,
        });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: "Failed to load advice" });
    }
});

app.get("/api/alerts/by-weather/:locationId", async (req, res) => {
    const { locationId } = req.params;
    const limit = Math.min(parseInt(req.query.limit || "3", 10) || 3, 3);

    try {
        const [[w]] = await pool.query(
            `SELECT w.temperature, w.humidity, w.wind_speed, w.weather_code, w.forecast_time, l.place_name
       FROM weather_hourly w
       JOIN weather_locations l ON l.id = w.location_id
       WHERE w.location_id = ?
       ORDER BY w.forecast_time DESC
       LIMIT 1`,
            [locationId]
        );
        if (!w) return res.json({ meta: null, alerts: [] });

        function codeToCondition(code) {
            if (code === 0) return "Clear";
            if ([1, 2].includes(code)) return "Cloudy";
            if (code === 3) return "Overcast";
            if (code >= 51 && code <= 67) return "Rain";
            if (code >= 80 && code <= 82) return "Rainy";
            if (code >= 95) return "Thunderstorm";
            return "Cloudy";
        }

        const condition = codeToCondition(w.weather_code);
        const temperature = Number(w.temperature);
        const wind = Number(w.wind_speed ?? 0);
        const humidity = Number(w.humidity ?? 0);
        const alertTime = w.forecast_time;

        const [templates] = await pool.query(
            `SELECT alert_type, severity, title_mg, message_mg, recommendation_mg, priority
       FROM alert_templates
       WHERE is_active = 1
         AND (weather_condition IS NULL OR weather_condition = '' OR weather_condition = ?)
         AND (min_temp IS NULL OR min_temp <= ?)
         AND (max_temp IS NULL OR max_temp >= ?)
         AND (min_wind IS NULL OR min_wind <= ?)
         AND (max_wind IS NULL OR max_wind >= ?)
         AND (min_humidity IS NULL OR min_humidity <= ?)
         AND (max_humidity IS NULL OR max_humidity >= ?)
       ORDER BY priority DESC
       LIMIT ?`,
            [condition, temperature, temperature, wind, wind, humidity, humidity, limit]
        );

        for (const t of templates) {
            try {
                await pool.query(
                    `INSERT INTO weather_alerts
           (id, location_id, alert_type, severity, title_mg, message_mg, recommendation_mg, alert_time, is_active, created_at)
           VALUES (UUID(), ?, ?, ?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP)`,
                    [locationId, t.alert_type, t.severity, t.title_mg, t.message_mg, t.recommendation_mg, alertTime]
                );
            } catch {
                // ignore duplicates
            }
        }

        const [alerts] = await pool.query(
            `SELECT id, location_id, alert_type, severity, title_mg, message_mg, recommendation_mg, alert_time, is_active, created_at
       FROM weather_alerts
       WHERE location_id = ? AND alert_time = ?
       ORDER BY created_at DESC
       LIMIT ?`,
            [locationId, alertTime, limit]
        );

        res.json({
            meta: {
                locationId,
                place_name: w.place_name,
                forecast_time: alertTime,
                condition,
                temperature,
                wind,
                humidity,
            },
            alerts,
        });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: "Failed to load alerts" });
    }
});
// =========================
// GLOBAL ERROR HANDLER
// =========================
app.use((err, req, res, next) => {
    console.error("Global error:", err.message || err);
    res.status(500).json({ error: "Server error" });
});


app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
