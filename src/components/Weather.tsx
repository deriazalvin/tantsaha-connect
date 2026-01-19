import { useEffect, useMemo, useState } from "react";
import { ArrowLeft, Droplet, MapPin, RefreshCw, Star, Wind, X } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

import { getWeatherImage } from "../utils/weatherImage";
import WeatherMap from "./WeatherMap";
import { API_URL } from "../config";

/* =====================
   TYPES
===================== */
type CurrentWeather = {
  temperature: number;
  condition: string;
  icon: string;
  place_name: string;
  time: string;
};

type HourlyWeather = {
  forecast_time: string;
  temp: number;
  wind: number;
  humidity: number;
  condition: string;
};

type DailyWeather = {
  forecast_date: string;
  temp_min: number;
  temp_max: number;
  condition: string;
};

type Favorite = {
  place_name: string;
  locationId: string;
  lat: number;
  lon: number;
};

type Coords = { lat: number; lon: number };

interface WeatherProps {
  onNavigate: (screen: string) => void;
}

/* =====================
   TRANSLATION MG
===================== */
const conditionMG: Record<string, string> = {
  Rain: "Orana",
  Rainy: "Orana",
  Sunny: "Masoandro",
  Clear: "Masoandro",
  Cloudy: "Rahona",
  Overcast: "Rahona mavesatra",
  Thunderstorm: "Rivo-doza",
};

/* =====================
   OFFLINE CACHE
===================== */
const LAST_LOCATION_KEY = "weather_last_locationId";
const LAST_COORDS_KEY = "weather_last_coords";
const CACHE_PREFIX = "weather_cache_"; // CACHE_PREFIX + locationId

type WeatherCache = {
  savedAt: number;
  locationId: string;
  coords: Coords | null;
  current: CurrentWeather | null;
  hourly: HourlyWeather[];
  daily: DailyWeather[];
};

function safeParseJSON<T>(raw: string | null): T | null {
  try {
    return raw ? (JSON.parse(raw) as T) : null;
  } catch {
    return null;
  }
}

function readCache(locationId: string): WeatherCache | null {
  return safeParseJSON<WeatherCache>(localStorage.getItem(CACHE_PREFIX + locationId));
}

function writeCache(payload: WeatherCache) {
  localStorage.setItem(CACHE_PREFIX + payload.locationId, JSON.stringify(payload));
}

function isOnline() {
  return navigator.onLine;
}

/* =====================
   UTIL
===================== */
function formatHour(iso: string) {
  try {
    const d = new Date(iso);
    return d.getHours().toString().padStart(2, "0") + ":00";
  } catch {
    return "";
  }
}

/* =====================
   COMPONENT
===================== */
export default function Weather({ onNavigate }: WeatherProps) {
  const [locationId, setLocationId] = useState<string | null>(() => localStorage.getItem(LAST_LOCATION_KEY));
  const [coords, setCoords] = useState<Coords | null>(() => safeParseJSON<Coords>(localStorage.getItem(LAST_COORDS_KEY)));

  const [current, setCurrent] = useState<CurrentWeather | null>(null);
  const [hourly, setHourly] = useState<HourlyWeather[]>([]);
  const [daily, setDaily] = useState<DailyWeather[]>([]);
  const [loading, setLoading] = useState(true);

  const [clock, setClock] = useState(new Date());
  const [searchCity, setSearchCity] = useState("");

  const [favorites, setFavorites] = useState<Favorite[]>(() => {
    const saved = localStorage.getItem("weather_favorites");
    return saved ? safeParseJSON<Favorite[]>(saved) ?? [] : [];
  });

  /* ⏰ CLOCK */
  useEffect(() => {
    const t = setInterval(() => setClock(new Date()), 1000);
    return () => clearInterval(t);
  }, []);

  /* 🌦️ BACKGROUND IMAGE */
  const bgImage = useMemo(() => {
    if (!current) return "";
    try {
      return getWeatherImage(current.condition, clock) || "";
    } catch (e) {
      console.warn("getWeatherImage error:", e);
      return "";
    }
  }, [current, clock]);

  const bgStyle = bgImage
    ? {
        backgroundImage: `linear-gradient(to bottom, rgba(0,0,0,0.25), rgba(0,0,0,0.55)), url(${bgImage})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
      }
    : { background: "linear-gradient(180deg,#021024,#04203a)" };

  /* =====================
     HELPERS "SOURCE OF TRUTH"
  ===================== */
  function setActiveLocation(nextId: string, nextCoords?: Coords | null) {
    setLocationId(nextId);
    localStorage.setItem(LAST_LOCATION_KEY, nextId);

    if (nextCoords) {
      setCoords(nextCoords);
      localStorage.setItem(LAST_COORDS_KEY, JSON.stringify(nextCoords));
    }
  }

  function hydrateFromCache(id: string): boolean {
    const cached = readCache(id);
    if (!cached?.current) return false;

    setCurrent(cached.current);
    setHourly(cached.hourly || []);
    setDaily(cached.daily || []);
    if (cached.coords) setCoords(cached.coords);
    return true;
  }

  /* =====================
     FAVORITES
  ===================== */
  function addFavorite() {
    if (!current || !coords || !locationId) return;

    const exists = favorites.some((f) => f.locationId === locationId);
    if (exists) return;

    const newFav: Favorite = {
      place_name: current.place_name,
      locationId,
      lat: coords.lat,
      lon: coords.lon,
    };

    const updated = [...favorites, newFav];
    setFavorites(updated);
    localStorage.setItem("weather_favorites", JSON.stringify(updated));
  }

  function removeFavorite(id: string) {
    const updated = favorites.filter((f) => f.locationId !== id);
    setFavorites(updated);
    localStorage.setItem("weather_favorites", JSON.stringify(updated));
  }

  /* =====================
     FETCH "refresh" => gives locationId
  ===================== */
  async function fetchWeatherRefresh(lat: number, lon: number, placeName: string) {
    const res = await fetch(`${API_URL}/api/weather/refresh`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ latitude: lat, longitude: lon, place_name: placeName }),
    });

    if (!res.ok) throw new Error("Server error: " + res.status);

    const data = await res.json();
    if (!data?.locationId) throw new Error("Aucun locationId reçu");

    setActiveLocation(data.locationId, { lat, lon });
  }

  type GeoResult = {
    id: number;
    name: string;
    latitude: number;
    longitude: number;
    country?: string;
    admin1?: string;
  };

  async function geocodeCity(name: string): Promise<GeoResult | null> {
    const q = name.trim();
    if (q.length < 2) return null;

    const url =
      "https://geocoding-api.open-meteo.com/v1/search?" +
      new URLSearchParams({
        name: q,
        count: "5",
        language: "fr",
        format: "json",
        country_code: "MG",
      });

    const res = await fetch(url);
    if (!res.ok) return null;

    const data = await res.json();
    const results: GeoResult[] = data?.results || [];
    return results[0] || null;
  }

  async function refreshWeather(lat?: number, lon?: number, cityName?: string) {
    // Offline: try cache and stop
    if (!isOnline()) {
      const id = locationId || localStorage.getItem(LAST_LOCATION_KEY);
      if (id) hydrateFromCache(id);
      return;
    }

    // Recherche ville (prioritaire)
    if ((!lat || !lon) && cityName && cityName.trim().length >= 2) {
      const geo = await geocodeCity(cityName);
      if (!geo) throw new Error("Ville introuvable");

      const label = `${geo.name}${geo.admin1 ? ", " + geo.admin1 : ""}${geo.country ? ", " + geo.country : ""}`;
      await fetchWeatherRefresh(geo.latitude, geo.longitude, label);
      return;
    }

    // GPS (si pas de ville)
    if (!lat || !lon) {
      const geoOptions: PositionOptions = {
        enableHighAccuracy: true,
        timeout: 15000,
        maximumAge: 60000,
      };

      navigator.geolocation.getCurrentPosition(
        (pos) => {
          fetchWeatherRefresh(pos.coords.latitude, pos.coords.longitude, "Position actuelle").catch((e) =>
            console.error("refresh error:", e)
          );
        },
        (err) => {
          console.error("GPS error", err.code, err.message);
          const lastId = localStorage.getItem(LAST_LOCATION_KEY);
          if (lastId && hydrateFromCache(lastId)) return;
        },
        geoOptions
      );
      return;
    }

    // lat/lon déjà fournis
    await fetchWeatherRefresh(lat, lon, cityName || "Ville recherchée");
  }

  /* =====================
     MAIN LOAD (depends on locationId)
  ===================== */
  useEffect(() => {
    if (!locationId) {
      if (isOnline()) refreshWeather();
      else setLoading(false);
      return;
    }

    let cancelled = false;

    const load = async () => {
      setLoading(true);

      if (!isOnline()) {
        hydrateFromCache(locationId);
        if (!cancelled) setLoading(false);
        return;
      }

      try {
        const [cur, hour, day] = await Promise.all([
          fetch(`${API_URL}/api/weather/current/${locationId}`).then((r) => r.json()),
          fetch(`${API_URL}/api/weather/hourly/${locationId}`).then((r) => r.json()),
          fetch(`${API_URL}/api/weather/daily/${locationId}`).then((r) => r.json()),
        ]);

        if (cancelled) return;

        setCurrent(cur);
        setHourly(hour || []);
        setDaily(day || []);

        writeCache({
          savedAt: Date.now(),
          locationId,
          coords,
          current: cur,
          hourly: hour || [],
          daily: day || [],
        });
      } catch (e) {
        if (!cancelled) hydrateFromCache(locationId);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };

    load();

    return () => {
      cancelled = true;
    };
  }, [locationId]);

  /* =====================
     UI
  ===================== */
  if (loading)
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-black via-gray-900 to-gray-800 text-white">
        <div className="animate-pulse space-y-3">
          <div className="h-8 w-64 bg-gray-700 rounded" />
          <div className="h-48 w-[90vw] max-w-4xl bg-gray-800 rounded-lg mt-6" />
          <div className="flex gap-3 mt-4">
            <div className="h-24 w-24 bg-gray-800 rounded-lg" />
            <div className="h-24 w-24 bg-gray-800 rounded-lg" />
            <div className="h-24 w-24 bg-gray-800 rounded-lg" />
          </div>
        </div>
      </div>
    );

  if (!current)
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-black via-gray-900 to-gray-800 text-white">
        Tsy misy angon-drakitra momba ny toetr’andro
      </div>
    );

  return (
    <div className="min-h-screen text-white" style={bgStyle}>
      <div className="backdrop-blur-sm bg-black/25 min-h-screen">
        {/* Header */}
        <header className="max-w-6xl mx-auto px-4 py-6 flex items-start justify-between gap-6">
          <div className="flex items-center gap-4">
            <button
              onClick={() => onNavigate("dashboard")}
              className="p-3 bg-white/10 hover:bg-white/20 rounded-xl transition"
              title="Retour"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>

            <div>
              <div className="text-sm text-white/90">Toe-javatra anio</div>
              <div className="text-2xl font-extrabold tracking-tight">{current.place_name}</div>
              <div className="text-sm text-white/80">{clock.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" })}</div>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <button
              title="Actualiser"
              onClick={() => {
                if (locationId) refreshWeather();
              }}
              className="flex items-center gap-2 px-3 py-2 bg-white/10 hover:bg-white/20 rounded-xl"
            >
              <RefreshCw className="w-4 h-4" /> Actualiser
            </button>

            <button
              title="Ajouter aux favoris"
              onClick={addFavorite}
              className="flex items-center gap-2 px-3 py-2 bg-yellow-600 text-black font-semibold rounded-xl"
            >
              <Star className="w-4 h-4" /> Favoris
            </button>
          </div>
        </header>

        {/* Hero */}
        <main className="max-w-6xl mx-auto px-4 pb-8">
          <section className="rounded-3xl overflow-hidden shadow-2xl bg-gradient-to-b from-white/6 to-white/3 border border-white/10">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 p-6">
              {/* Left: big info */}
              <div className="col-span-2 flex flex-col justify-between gap-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="bg-white/10 rounded-2xl p-4">
                      <div className="text-6xl font-extrabold leading-none">{current.temperature}°</div>
                      <div className="text-sm text-white/80 mt-1">{conditionMG[current.condition] || current.condition}</div>
                    </div>

                    <div className="hidden md:block">
                      <div className="text-xs text-white/80">Toetrandro ankehitriny</div>
                      <div className="text-lg text-white/90 font-medium mt-2">{current.place_name}</div>
                      <div className="text-sm text-white/70 mt-1">{current.time}</div>
                    </div>
                  </div>

                  <div className="flex gap-3">
                    <div className="p-3 bg-white/5 rounded-lg flex flex-col items-center">
                      <Wind className="w-5 h-5 text-white/90" />
                      <div className="mt-1 text-sm">{hourly?.[0]?.wind ?? "—"} km/h</div>
                    </div>
                    <div className="p-3 bg-white/5 rounded-lg flex flex-col items-center">
                      <Droplet className="w-5 h-5 text-white/90" />
                      <div className="mt-1 text-sm">{hourly?.[0]?.humidity ?? "—"}%</div>
                    </div>
                  </div>
                </div>

                {/* Hourly strip */}
                <div className="mt-4">
                  <div className="text-sm text-white/80 mb-3">Isan'ora (24h)</div>
                  <div className="flex gap-3 overflow-x-auto pb-2">
                    {hourly.map((h, i) => (
                      <div
                        key={i}
                        className="min-w-[110px] bg-white/6 rounded-2xl p-3 flex flex-col items-center text-center"
                      >
                        <div className="text-xs text-white/70">{formatHour(h.forecast_time)}</div>
                        <div className="text-lg font-bold my-1">{h.temp}°</div>
                        <div className="text-xs text-white/70 flex items-center gap-1">
                          <Wind className="w-3 h-3" /> {h.wind}
                        </div>
                        <div className="text-xs text-white/70 mt-1">{h.humidity}%</div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* Right: daily & map */}
              <aside className="flex flex-col gap-4">
                <div className="bg-white/5 rounded-2xl p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="text-xs text-white/80">Andro manaraka</div>
                      <div className="text-sm text-white/90 font-semibold">{daily?.length ?? 0} andro</div>
                    </div>
                    <button
                      onClick={() => onNavigate("weather")}
                      className="text-sm text-white/70 underline"
                    >
                      Hijery daholo
                    </button>
                  </div>

                  <div className="mt-3 space-y-2">
                    {daily.map((d, idx) => (
                      <div key={idx} className="flex items-center justify-between">
                        <div className="text-sm text-white/80">
                          {new Date(d.forecast_date).toLocaleDateString("fr-FR", { weekday: "short", day: "numeric" })}
                        </div>
                        <div className="text-sm text-white/90 font-semibold">{d.temp_min}° / {d.temp_max}°</div>
                      </div>
                    ))}
                  </div>
                </div>

                {coords && (
                  <div className="bg-white/5 rounded-2xl p-3 h-40">
                    <WeatherMap
                      coords={coords}
                      favorites={favorites.map((fav) => ({ lat: fav.lat, lon: fav.lon, name: fav.place_name }))}
                    />
                  </div>
                )}
              </aside>
            </div>
          </section>

          {/* Favorites / actions */}
          <section className="mt-6 max-w-6xl">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-lg font-semibold">Favorites</h3>
              <div className="text-sm text-white/70">{favorites.length} sauvegardé(s)</div>
            </div>

            <div className="flex gap-3 flex-wrap">
              {favorites.length === 0 && <div className="text-white/70">Aucun favoris</div>}
              {favorites.map((f) => (
                <button
                  key={f.locationId}
                  onClick={() => setActiveLocation(f.locationId, { lat: f.lat, lon: f.lon })}
                  className="px-4 py-2 bg-white/6 rounded-full flex items-center gap-3 hover:bg-white/10"
                >
                  <MapPin className="w-4 h-4" />
                  <span>{f.place_name}</span>
                  <X
                    className="w-3 h-3 ml-2 text-white/60"
                    onClick={(e) => {
                      e.stopPropagation();
                      removeFavorite(f.locationId);
                    }}
                  />
                </button>
              ))}
            </div>
          </section>
        </main>
      </div>
    </div>
  );
}