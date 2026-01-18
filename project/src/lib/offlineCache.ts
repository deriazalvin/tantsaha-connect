// src/lib/offlineCache.ts
export function saveWeatherOffline(data: any) {
    localStorage.setItem('weather7days', JSON.stringify(data));
    localStorage.setItem('weatherUpdated', new Date().toISOString());
}

export function loadWeatherOffline() {
    const data = localStorage.getItem('weather7days');
    return data ? JSON.parse(data) : null;
}

export function isCacheExpired(): boolean {
    const updated = localStorage.getItem('weatherUpdated');
    if (!updated) return true;
    const last = new Date(updated);
    const now = new Date();
    // plus de 7 jours → cache expiré
    return (now.getTime() - last.getTime()) > 7 * 24 * 60 * 60 * 1000;
}
