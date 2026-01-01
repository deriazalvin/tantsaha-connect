import { useEffect, useMemo, useState } from "react";
import { ArrowLeft, Droplet, MapPin, RefreshCw, Star, Wind, X } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

import { getWeatherImage } from "../utils/weatherImage";
import WeatherMap from "./WeatherMap";

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

  /* ⏰ HORLOGE */
  useEffect(() => {
    const t = setInterval(() => setClock(new Date()), 1000);
    return () => clearInterval(t);
  }, []);

  /* 🌦️ IMAGE */
  const bgImage = useMemo(() => {
    if (!current) return "";
    return getWeatherImage(current.condition, clock);
  }, [current, clock]);

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
    const res = await fetch("/api/weather/refresh", {
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

    // ✅ Recherche ville (prioritaire)
    if ((!lat || !lon) && cityName && cityName.trim().length >= 2) {
      const geo = await geocodeCity(cityName);
      if (!geo) throw new Error("Ville introuvable");

      const label = `${geo.name}${geo.admin1 ? ", " + geo.admin1 : ""}${geo.country ? ", " + geo.country : ""}`;
      await fetchWeatherRefresh(geo.latitude, geo.longitude, label);
      return;
    }

    // ✅ GPS (si pas de ville)
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

    // ✅ lat/lon déjà fournis
    await fetchWeatherRefresh(lat, lon, cityName || "Ville recherchée");
  }





   

  /* =====================
     MAIN LOAD (depends on locationId)
  ===================== */
  useEffect(() => {
    if (!locationId) {
      // 1er démarrage sans id: si online on déclenche un refresh pour créer locationId
      if (isOnline()) refreshWeather();
      else setLoading(false);
      return;
    }

    let cancelled = false;

    const load = async () => {
      setLoading(true);

      // Offline => cache
      if (!isOnline()) {
        hydrateFromCache(locationId);
        if (!cancelled) setLoading(false);
        return;
      }

      // Online => API then cache
      try {
        const [cur, hour, day] = await Promise.all([
          fetch(`/api/weather/current/${locationId}`).then((r) => r.json()),
          fetch(`/api/weather/hourly/${locationId}`).then((r) => r.json()),
          fetch(`/api/weather/daily/${locationId}`).then((r) => r.json()),
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
        // fallback cache if API fails
        if (!cancelled) hydrateFromCache(locationId);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };

    load();

    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [locationId]);

  /* =====================
     UI
  ===================== */
  if (loading) return <div className="min-h-screen flex items-center justify-center">⏳ Mahandrasa...</div>;
  if (!current)
    return (
      <div className="min-h-screen flex items-center justify-center">
        Tsy misy angon-drakitra momba ny toetr’andro
      </div>
    );

  return (
    <div className="min-h-screen bg-black text-white">
      <header className="p-4 flex flex-col gap-4">
        <div className="flex justify-between items-center">
          <div className="flex items-center gap-2">
            <button
              onClick={() => onNavigate("dashboard")}
              className="p-2 hover:bg-green-600 rounded-lg transition-colors"
            >
              <ArrowLeft className="w-6 h-6" />
            </button>

            <MapPin />

            <div>
              <div className="font-bold">{current.place_name}</div>
              <div className="text-sm opacity-70">
                {clock.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" })}
              </div>
            </div>
          </div>

          <div className="flex gap-2">
            <button onClick={() => refreshWeather()}>
              <RefreshCw />
            </button>
            <button onClick={addFavorite}>
              <Star />
            </button>
          </div>
        </div>

        <div className="flex gap-2 overflow-x-auto mt-2">
          {favorites.map((f) => (
            <div
              key={f.locationId}
              className="bg-white/10 rounded-xl p-2 flex items-center gap-1 cursor-pointer"
              onClick={() => setActiveLocation(f.locationId, { lat: f.lat, lon: f.lon })}
            >
              <span>{f.place_name}</span>
              <X
                className="w-4 h-4"
                onClick={(e) => {
                  e.stopPropagation();
                  removeFavorite(f.locationId);
                }}
              />
            </div>
          ))}
        </div>

        <div className="mt-2 flex gap-2">
          <input
            type="text"
            placeholder="Rechercher une ville..."
            value={searchCity}
            onChange={(e) => setSearchCity(e.target.value)}
            className="flex-1 p-2 rounded bg-white/10 placeholder-white text-white"
          />
          <button
            className="p-2 bg-blue-600 rounded"
            onClick={() => {
              if (!searchCity.trim()) return;
              refreshWeather(undefined, undefined, searchCity).catch(console.error);
            }}
          >
            Rechercher
          </button>

        </div>
      </header>

      <section className="h-[70vh] flex flex-col justify-end px-6 pb-10 relative">
        <AnimatePresence mode="wait">
          <motion.div
            key={current.condition + Math.floor(clock.getHours() / 6)}
            className="absolute inset-0 bg-cover bg-center"
            style={{ backgroundImage: `url(${bgImage})` }}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 1.2 }}
          />
        </AnimatePresence>

        <div className="absolute inset-0 bg-black/40" />
        <div className="relative z-10 text-center">
          <motion.div
            key={current.temperature}
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 0.8 }}
            className="text-6xl font-bold"
          >
            {current.temperature}°
          </motion.div>

          <motion.div
            key={current.condition}
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="text-lg opacity-80"
          >
            {conditionMG[current.condition] || current.condition}
          </motion.div>
        </div>
      </section>

      {coords && (
        <section className="px-6 py-6">
          <h2 className="font-bold mb-3">Carte météo</h2>
          <WeatherMap
            coords={coords}
            favorites={favorites.map((fav) => ({
              lat: fav.lat,
              lon: fav.lon,
              name: fav.place_name,
            }))}
          />
        </section>
      )}

      <section className="px-6 py-4 overflow-x-auto">
        <h2 className="font-bold mb-3">Isan’ora</h2>
        <div className="flex gap-4 min-w-max">
          {hourly.map((h, i) => {
            const date = new Date(h.forecast_time);
            return (
              <motion.div
                key={i}
                className="bg-white/10 rounded-xl p-3 min-w-[120px]"
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ duration: 0.6, delay: i * 0.05 }}
              >
                <div className="text-sm opacity-70">{date.getHours()}:00</div>
                <div className="text-xl font-bold">{h.temp}°</div>
                <div className="mt-2 text-xs flex items-center gap-1">
                  <Wind className="w-3 h-3" /> {h.wind} km/h
                </div>
                <div className="text-xs flex items-center gap-1">
                  <Droplet className="w-3 h-3" /> {h.humidity}%
                </div>
              </motion.div>
            );
          })}
        </div>
      </section>

      <section className="bg-white text-gray-900 rounded-t-3xl px-6 pt-6 mt-8">
        <h2 className="font-bold mb-4">Andro manaraka</h2>
        {daily.map((d, i) => (
          <div key={i} className="flex justify-between py-3 border-b">
            <div>
              {new Date(d.forecast_date).toLocaleDateString("mg-MG", {
                weekday: "short",
                day: "numeric",
                month: "short",
              })}
            </div>
            <div className="font-semibold">
              {d.temp_min}° / {d.temp_max}°
            </div>
          </div>
        ))}
      </section>
    </div>
  );
}
