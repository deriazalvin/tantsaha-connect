#!/usr/bin/env node
/**
 * normalize_and_regenerate.js
 *
 * - Backup forecasts/alerts/advices
 * - Normalize region_id in weather_forecasts to canonical MIN(id) per region name
 * - Remove duplicate weather_forecasts keeping one row per (region_id, forecast_date)
 * - Delete existing weather_alerts and agricultural_advices
 * - Regenerate alerts (calls existing generator)
 * - Generate simple advices per region based on forecast heuristics
 *
 * Run from `backend` folder so dotenv loads `./.env`:
 *   node scripts/normalize_and_regenerate.js
 */

require('dotenv').config();
const pool = require('../src/db');
const generator = require('../src/generateAlerts');

async function backupTables() {
    console.log('Creating backups for forecasts, alerts and advices (if not exists)');
    await pool.query('CREATE TABLE IF NOT EXISTS backup_weather_forecasts_full AS SELECT * FROM weather_forecasts WHERE 1=0');
    await pool.query('CREATE TABLE IF NOT EXISTS backup_weather_alerts_full AS SELECT * FROM weather_alerts WHERE 1=0');
    await pool.query('CREATE TABLE IF NOT EXISTS backup_agricultural_advices_full AS SELECT * FROM agricultural_advices WHERE 1=0');
    // copy current rows
    await pool.query('INSERT INTO backup_weather_forecasts_full SELECT * FROM weather_forecasts');
    await pool.query('INSERT INTO backup_weather_alerts_full SELECT * FROM weather_alerts');
    await pool.query('INSERT INTO backup_agricultural_advices_full SELECT * FROM agricultural_advices');
}

async function normalizeRegionIds() {
    console.log('Normalizing region_id in weather_forecasts to canonical MIN(id) per region name');
    await pool.query(`UPDATE weather_forecasts wf
    JOIN regions r ON wf.region_id = r.id
    JOIN (SELECT name, MIN(id) AS canonical_id FROM regions GROUP BY name) rr ON r.name = rr.name
    SET wf.region_id = rr.canonical_id
    WHERE wf.region_id <> rr.canonical_id`);
}

async function removeForecastDuplicates() {
    console.log('Removing duplicate weather_forecasts rows (keeping one per region_id+forecast_date)');
    // Previous approach grouped by region_id; that misses duplicates where the same region name
    // has multiple region_id values. We must deduplicate by region NAME + forecast_date.
    await pool.query(`DELETE wf FROM weather_forecasts wf
        JOIN regions r ON wf.region_id = r.id
        LEFT JOIN (
            SELECT r2.name AS region_name, wf2.forecast_date AS fd, MIN(wf2.id) AS keep_id
            FROM weather_forecasts wf2
            JOIN regions r2 ON wf2.region_id = r2.id
            GROUP BY r2.name, wf2.forecast_date
        ) AS k ON k.region_name = r.name AND k.fd = wf.forecast_date
        WHERE k.keep_id IS NOT NULL AND wf.id <> k.keep_id;`);
}

async function clearAlertsAndAdvices() {
    console.log('Clearing weather_alerts and agricultural_advices (backed up above)');
    await pool.query('DELETE FROM weather_alerts');
    await pool.query('DELETE FROM agricultural_advices');
}

async function generateAdvices() {
    console.log('Generating simple advices per region from forecasts');
    const [regions] = await pool.query('SELECT id, name FROM regions');

    for (const r of regions) {
        try {
            // compute simple heuristics from next 7 days
            const [rows] = await pool.query('SELECT forecast_date, temp_min, temp_max, `condition` FROM weather_forecasts WHERE region_id = ? ORDER BY forecast_date LIMIT 7', [r.id]);
            let hot = 0, frost = 0, rain = 0;
            for (const f of rows) {
                if (f.temp_max != null && f.temp_max >= 33) hot++;
                if (f.temp_min != null && f.temp_min <= 2) frost++;
                if (f['condition'] && /rain|Rain|Orana|orana/.test(f['condition'])) rain++;
            }

            const advices = [];
            if (hot >= 1) advices.push({ crop_type: 'general', season: 'hot', title_mg: `Mitandrema amin'ny hafanana`, content_mg: `Hafanana ambony andrasana ao ${r.name}. Omeo rano ny zava-maniry ary aza atao miasa mafy ny biby.` });
            if (frost >= 1) advices.push({ crop_type: 'general', season: 'cold', title_mg: `Mitandrema amin'ny hatsiaka`, content_mg: `Misy mety ho hatsiaka maraina ao ${r.name}. Ampiasao cover amin'ny zavamaniry marefo.` });
            if (rain >= 2) advices.push({ crop_type: 'general', season: 'rainy', title_mg: `Miomàna amin'ny orana`, content_mg: `Orana be andrasana ao ${r.name}. Miomàna amin'ny fitahirizana sy ny drainage.` });
            if (advices.length === 0) advices.push({ crop_type: 'general', season: 'normal', title_mg: `Torohevitra ankapobeny`, content_mg: `Toerana mahazatra, manara-maso ny toetr'andro ary mitandrina amin'ny fiovan'ny andro.` });

            // insert advices for this region
            for (const a of advices) {
                await pool.query('INSERT INTO agricultural_advices (id, region_id, crop_type, season, title_mg, content_mg, icon, created_at) VALUES (UUID(), ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)', [r.id, a.crop_type, a.season, a.title_mg, a.content_mg, null]);
            }
        } catch (e) {
            console.error('Failed generating advices for region', r.id, r.name, e.message || e);
        }
    }
}

async function main() {
    try {
        await backupTables();
        await normalizeRegionIds();
        await removeForecastDuplicates();
        await clearAlertsAndAdvices();

        console.log('Regenerating alerts using existing generator...');
        const genReport = await generator.generateAllAlerts();
        console.log('Alerts regenerated:', genReport);

        await generateAdvices();
        console.log('Advices regenerated per region');

        // final counts
        const [[{ fc }]] = await pool.query('SELECT COUNT(*) AS fc FROM weather_forecasts');
        const [[{ ac }]] = await pool.query('SELECT COUNT(*) AS ac FROM agricultural_advices');
        const [[{ al }]] = await pool.query('SELECT COUNT(*) AS al FROM weather_alerts');
        console.log(`Final counts: forecasts=${fc}, advices=${ac}, alerts=${al}`);
        process.exit(0);
    } catch (e) {
        console.error('Script failed', e);
        process.exit(2);
    }
}

main();
