# Tantsaha Connect Backend (Minimal)

This is a minimal Node + Express backend that connects to a MySQL database and exposes simple REST endpoints for the Tantsaha Connect frontend.

It optionally verifies Supabase access tokens (so you can keep Supabase Auth while moving data to MySQL).

Quick start

1. Copy `.env.example` to `.env` and edit the values:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=tantsaha_connect
PORT=4000
# optional for Supabase token verification
VITE_SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

2. Install dependencies and run the server:

```bash
cd backend
npm install
npm run dev
```

3. The server will run on `http://localhost:4000` by default. Example endpoints:
- `GET /api/regions`
- `GET /api/weather/:region_id/:date` (date format YYYY-MM-DD)
- `GET /api/alerts/:region_id`
- `GET /api/advice/:region_id`
- `GET /api/users/me` (requires Supabase Authorization header)
- `GET /api/journal` (requires Supabase Authorization header)
- `POST /api/journal` (requires Supabase Authorization header)

Notes
- This is a minimal scaffold for development. Do not use the example `.env` values in production.
- For production, secure the SUPABASE_SERVICE_ROLE_KEY and use HTTPS.
