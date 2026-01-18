const pool = require('./db');

//Mamorona Fampitandremana mifandray @ toetrandro
function makeTextForAlert(type, regionName, date, value) {
    switch (type) {
        case 'heat':
            return {
                title_mg: `Fampitandremana hafanana ${date}`,
                message_mg: `Hafanana avo (${value}°C) andrasana ao ${regionName} amin'ny ${date}. Mitandrema amin'ny antony mafana.`,
                recommendation_mg: `Arovy ny fambolena sy ny biby, manome rano betsaka.`
            };
        case 'frost':
            return {
                title_mg: `Fampitandremana hatsiaka ${date}`,
                message_mg: `Hatsiaka ny maraina (${value}°C) andrasana ao ${regionName} amin'ny ${date}. Mety hampidi-doza ho an'ny zava-maniry.`,
                recommendation_mg: `Rarasao ny fampiharana fiarovana (cover), aleo aza manao famafazana mialoha.`
            };
        case 'rain':
            return {
                title_mg: `Fampitandremana orana ${date}`,
                message_mg: `Orana be andrasana ao ${regionName} amin'ny ${date}. Mety hampisy rano be sy hametra ny asa eny an-kampo.`,
                recommendation_mg: `Arovy ny vokatra, mitahiry fitaovana ambony.`
            };
        default:
            return {
                title_mg: `Fampitandremana ${date}`,
                message_mg: `Fampitandremana ho an'ny ${regionName} amin'ny ${date}.`,
                recommendation_mg: ``
            };
    }
}

async function generateAlertsForRegion(regionId) {

    const [[regionRow]] = await pool.query('SELECT name FROM regions WHERE id = ? LIMIT 1', [regionId]);
    const regionName = regionRow ? regionRow.name : 'Region';

    const today = new Date();
    const start = today.toISOString().slice(0, 10);
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + 6);
    const end = endDate.toISOString().slice(0, 10);

    const [forecasts] = await pool.query('SELECT forecast_date, temp_min, temp_max, `condition` FROM weather_forecasts WHERE region_id = ? AND forecast_date BETWEEN ? AND ? ORDER BY forecast_date', [regionId, start, end]);

    let created = 0;
    for (const f of forecasts) {
        const date = f.forecast_date.toISOString().slice(0, 10);
        
        const alerts = [];

        //Hafanana
        if (f.temp_max != null) {
            if (f.temp_max >= 38) alerts.push({ type: 'heat', severity: 'danger', value: f.temp_max });
            else if (f.temp_max >= 33) alerts.push({ type: 'heat', severity: 'warning', value: f.temp_max });
            else if (f.temp_max >= 30) alerts.push({ type: 'heat', severity: 'info', value: f.temp_max });
        }

        // Hatsiaka
        if (f.temp_min != null) {
            if (f.temp_min <= 0) alerts.push({ type: 'frost', severity: 'danger', value: f.temp_min });
            else if (f.temp_min <= 2) alerts.push({ type: 'frost', severity: 'warning', value: f.temp_min });
            else if (f.temp_min <= 5) alerts.push({ type: 'frost', severity: 'info', value: f.temp_min });
        }

        // Orana
        if (f.condition && /rain|Rain|Orana|orana|drizzle|Drizzle/.test(f.condition)) {

            if (/heavy|Heavy|storm|Storm|thunder|Thunder/.test(f.condition)) alerts.push({ type: 'rain', severity: 'warning', value: f.condition });
            else alerts.push({ type: 'rain', severity: 'info', value: f.condition });
        }

        if (alerts.length === 0) {
            alerts.push({ type: 'weather', severity: 'info', value: `${f.temp_min ?? '-'} / ${f.temp_max ?? '-'}` });
        }

        for (const a of alerts) {
            await pool.query('DELETE FROM weather_alerts WHERE region_id = ? AND alert_type = ? AND alert_date = ?', [regionId, a.type, date]);
            const texts = makeTextForAlert(a.type, regionName, date, a.value);
            await pool.query('INSERT INTO weather_alerts (id, region_id, alert_type, severity, title_mg, message_mg, recommendation_mg, alert_date, is_active, created_at) VALUES (UUID(), ?, ?, ?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP)', [regionId, a.type, a.severity, texts.title_mg, texts.message_mg, texts.recommendation_mg, date]);
            created++;
        }
    }

    return { regionId, created };
}

async function generateAllAlerts() {
    const [regions] = await pool.query('SELECT id FROM regions');
    const report = {};
    for (const r of regions) {
        try {
            const res = await generateAlertsForRegion(r.id);
            report[r.id] = res.created;
        } catch (e) {
            console.error('Failed generating alerts for region', r.id, e.message || e);
            report[r.id] = 0;
        }
    }
    return report;
}

module.exports = { generateAlertsForRegion, generateAllAlerts };
