const axios = require("axios");
const pool = require("./db");
const { v4: uuidv4 } = require("uuid");

async function fetchWeatherForLocation({
    latitude,
    longitude,
    place_name,
    region,
    country
}) {
    console.log("➡️ fetchWeatherForLocation called", {
        latitude,
        longitude,
        place_name
    });

    // 0️⃣ Vérifier si la localisation existe déjà
    const [[existing]] = await pool.query(
        `SELECT id FROM weather_locations WHERE latitude = ? AND longitude = ?`,
        [latitude, longitude]
    );

    let locationId;

    if (existing) {
        console.log("📍 Existing location found:", existing.id);
        locationId = existing.id;

        // 🔄 (OPTIONNEL) Effacer l'ancien weather pour éviter doublons
        await pool.query(`DELETE FROM weather_hourly WHERE location_id = ?`, [locationId]);
        await pool.query(`DELETE FROM weather_daily WHERE location_id = ?`, [locationId]);

    } else {
        console.log("🆕 Creating new location...");
        locationId = uuidv4();
        await pool.query(
            `INSERT INTO weather_locations
            (id, latitude, longitude, place_name, region, country)
            VALUES (?, ?, ?, ?, ?, ?)`,
            [locationId, latitude, longitude, place_name, region || null, country || null]
        );
    }

    // 1️⃣ Open-Meteo fetch
    const url = "https://api.open-meteo.com/v1/forecast";
    const params = {
        latitude,
        longitude,
        hourly: "temperature_2m,relativehumidity_2m,windspeed_10m,weathercode",
        daily: "temperature_2m_min,temperature_2m_max,weathercode",
        timezone: "auto"
    };

    const { data } = await axios.get(url, { params, timeout: 15000 });

    // 2️⃣ Hourly
    for (let i = 0; i < data.hourly.time.length; i++) {
        await pool.query(
            `INSERT INTO weather_hourly
            (id, location_id, forecast_time, temperature, humidity, wind_speed, weather_code)
            VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [
                uuidv4(),
                locationId,
                data.hourly.time[i],
                Math.round(data.hourly.temperature_2m[i]),
                data.hourly.relativehumidity_2m[i],
                Math.round(data.hourly.windspeed_10m[i]),
                data.hourly.weathercode[i]
            ]
        );
    }

    // 3️⃣ Daily
    for (let i = 0; i < data.daily.time.length; i++) {
        await pool.query(
            `INSERT INTO weather_daily
            (id, location_id, forecast_date, temp_min, temp_max, weather_code)
            VALUES (?, ?, ?, ?, ?, ?)`,
            [
                uuidv4(),
                locationId,
                data.daily.time[i],
                Math.round(data.daily.temperature_2m_min[i]),
                Math.round(data.daily.temperature_2m_max[i]),
                data.daily.weathercode[i]
            ]
        );
    }

    console.log("✅ Weather stored for:", locationId);
    return { ok: true, locationId };
}

module.exports = { fetchWeatherForLocation };