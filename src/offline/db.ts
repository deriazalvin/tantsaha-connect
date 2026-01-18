import { openDB, type DBSchema } from "idb";

export type AdvicePayload = { meta: any | null; advices: any[] };
export type AlertsPayload = { meta: any | null; alerts: any[] };

interface AppDB extends DBSchema {
    advice_cache: { key: string; value: { savedAt: number; payload: AdvicePayload } };
    alerts_cache: { key: string; value: { savedAt: number; payload: AlertsPayload } };
}

export const dbPromise = openDB<AppDB>("tantsaha_offline", 1, {
    upgrade(db) {
        db.createObjectStore("advice_cache");
        db.createObjectStore("alerts_cache");
    },
});
