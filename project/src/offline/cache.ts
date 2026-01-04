import { dbPromise, type AdvicePayload, type AlertsPayload } from "./db";

const TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 jours

function isFresh(savedAt: number) {
    return Date.now() - savedAt < TTL_MS;
}

// ---------- Advice ----------
export async function readAdviceCache(key: string): Promise<AdvicePayload | null> {
    const db = await dbPromise;
    const row = await db.get("advice_cache", key);
    if (!row) return null;
    // même expiré -> renvoyer (utile offline)
    if (!isFresh(row.savedAt)) return row.payload;
    return row.payload;
}

export async function writeAdviceCache(key: string, payload: AdvicePayload): Promise<void> {
    const db = await dbPromise;
    await db.put("advice_cache", { savedAt: Date.now(), payload }, key);
}

// ---------- Alerts ----------
export async function readAlertsCache(key: string): Promise<AlertsPayload | null> {
    const db = await dbPromise;
    const row = await db.get("alerts_cache", key);
    if (!row) return null;
    return row.payload;
}

export async function writeAlertsCache(key: string, payload: AlertsPayload): Promise<void> {
    const db = await dbPromise;
    await db.put("alerts_cache", { savedAt: Date.now(), payload }, key);
}
