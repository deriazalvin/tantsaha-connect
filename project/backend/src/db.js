const mysql = require("mysql2/promise");
require("dotenv").config();
require("dotenv").config({ path: "../.env" });

console.log("DB CONFIG =>", {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
});
pool.query("SELECT DATABASE() AS db")
    .then(([r]) => console.log("SELECT DATABASE() =>", r))
    .catch(console.error);


const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    waitForConnections: true,
    connectionLimit: 10,
});

module.exports = pool;
