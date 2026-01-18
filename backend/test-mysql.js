const pool = require('./src/db');
(async () => {
    try {
        const [rows] = await pool.query('SHOW TABLES');
        console.log('DB connection OK. Tables:');
        console.log(rows);
        process.exit(0);
    } catch (err) {
        console.error('DB test error:');
        console.error(err.message || err);
        process.exit(1);
    }
})();
