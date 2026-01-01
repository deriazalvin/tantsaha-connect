import { useEffect, useState, useMemo } from "react";
import { MapPin, Wind, Droplet, RefreshCw, Star, X } from "lucide-react";
import { getWeatherImage } from "../utils/weatherImage";
import WeatherMap from "./WeatherMap";
import { motion, AnimatePresence } from "framer-motion";

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
   COMPONENT
===================== */
export default function Weather() {
  const [locationId, setLocationId] = useState<string | null>(null);
  const [current, setCurrent] = useState<CurrentWeather | null>(null);
  const [hourly, setHourly] = useState<HourlyWeather[]>([]);
  const [daily, setDaily] = useState<DailyWeather[]>([]);
  const [loading, setLoading] = useState(true);
  const [clock, setClock] = useState(new Date());
  const [coords, setCoords] = useState<{ lat: number; lon: number } | null>(null);

  const [searchCity, setSearchCity] = useState("");
  const [favorites, setFavorites] = useState<Favorite[]>(() => {
    const saved = localStorage.getItem("weather_favorites");
    return saved ? JSON.parse(saved) : [];
  });

  /* ⏰ HORLOGE */
  useEffect(() => {
    const t = setInterval(() => setClock(new Date()), 1000);
    return () => clearInterval(t);
  }, []);

  /* 🌦️ IMAGE DYNAMIQUE */
  const bgImage = useMemo(() => {
    if (!current) return "";
    return getWeatherImage(current.condition, clock);
  }, [current, clock]);

  /* =====================
     FAVORITES HANDLERS
  ===================== */
  function addFavorite() {
    if (!current || !coords) return;
    const exists = favorites.some(f => f.locationId === locationId);
    if (!exists) {
      const newFav: Favorite = {
        place_name: current.place_name,
        locationId: locationId!,
        lat: coords.lat,
        lon: coords.lon,
      };
      const updated = [...favorites, newFav];
      setFavorites(updated);
      localStorage.setItem("weather_favorites", JSON.stringify(updated));
    }
  }

  function removeFavorite(id: string) {
    const updated = favorites.filter(f => f.locationId !== id);
    setFavorites(updated);
    localStorage.setItem("weather_favorites", JSON.stringify(updated));
  }

  /* =====================
     REFRESH METEO
  ===================== */
  async function refreshWeather(lat?: number, lon?: number, cityName?: string) {
    setLoading(true);

    if (!lat || !lon) {
      if (!navigator.geolocation) {
        console.warn("Geolocation not supported");
        setLoading(false);
        return;
      }

      navigator.geolocation.getCurrentPosition(
        async pos => {
          await fetchWeather(pos.coords.latitude, pos.coords.longitude, "Position actuelle");
        },
        async err => {
          console.error("GPS error", err);
          await fetchWeather(-18.8792, 47.5079, "Antananarivo");
          setLoading(false);
        }
      );
    } else {
      await fetchWeather(lat, lon, cityName || "Ville recherchée");
    }
  }

  /* =====================
     FETCH WEATHER
     ➤ FIX : setCoords ajouté
     ➤ FIX : setLocationId déjà présent
  ===================== */
  async function fetchWeather(lat: number, lon: number, city: string) {
    const res = await fetch("/api/weather/refresh", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        latitude: lat,
        longitude: lon,
        place_name: city,
      }),
    });

    const data = await res.json();

    console.log("📍 locationId reçu:", data.locationId);

    if (data.locationId) {
      setLocationId(data.locationId);
      setCoords({ lat, lon }); // ➤ CORRECTION ICI
    } else {
      console.warn("Aucun locationId reçu");
    }
  }

  /* =====================
     LOAD WEATHER DATA
  ===================== */
  useEffect(() => {
    if (!locationId) return;

    setLoading(true);
    Promise.all([
      fetch(`/api/weather/current/${locationId}`).then(r => r.json()),
      fetch(`/api/weather/hourly/${locationId}`).then(r => r.json()),
      fetch(`/api/weather/daily/${locationId}`).then(r => r.json()),
    ])
      .then(([c, h, d]) => {
        setCurrent(c);
        setHourly(h || []);
        setDaily(d || []);
      })
      .finally(() => setLoading(false));
  }, [locationId]);

  /* =====================
     AUTO LOAD
  ===================== */
  useEffect(() => {
    refreshWeather();
  }, []);

  /* =====================
     RENDER STATES
  ===================== */
  if (loading) return <div className="min-h-screen flex items-center justify-center">⏳ Mahandrasa...</div>;
  if (!current) return <div className="min-h-screen flex items-center justify-center">Tsy misy angon-drakitra momba ny toetr’andro</div>;

  return (
    <div className="min-h-screen bg-black text-white">

      {/* HEADER + FAVORITES */}
      <header className="p-4 flex flex-col gap-4">
        <div className="flex justify-between items-center">
          <div className="flex items-center gap-2">
            <MapPin />
            <div>
              <div className="font-bold">{current.place_name}</div>
              <div className="text-sm opacity-70">
                {clock.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" })}
              </div>
            </div>
          </div>
          <div className="flex gap-2">
            <button onClick={() => refreshWeather()}><RefreshCw /></button>
            <button onClick={addFavorite}><Star /></button>
          </div>
        </div>

        {/* FAVORITES LIST */}
        <div className="flex gap-2 overflow-x-auto mt-2">
          {favorites.map(f => (
            <div key={f.locationId} className="bg-white/10 rounded-xl p-2 flex items-center gap-1 cursor-pointer"
              onClick={() => setLocationId(f.locationId)}
            >
              <span>{f.place_name}</span>
              <X className="w-4 h-4" onClick={(e) => { e.stopPropagation(); removeFavorite(f.locationId); }} />
            </div>
          ))}
        </div>

        {/* RECHERCHE */}
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
            onClick={() => { if (!searchCity) return; refreshWeather(undefined, undefined, searchCity); }}
          >
            Rechercher
          </button>
        </div>
      </header>

      {/* IMAGE CE JOUR */}
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
          <motion.div key={current.temperature} initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ duration: 0.8 }} className="text-6xl font-bold">
            {current.temperature}°
          </motion.div>
          <motion.div key={current.condition} initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ duration: 0.8, delay: 0.2 }} className="text-lg opacity-80">
            {conditionMG[current.condition] || current.condition}
          </motion.div>
        </div>
      </section>

      {/* CARTE */}
      {coords && (
        <section className="px-6 py-6">
          <h2 className="font-bold mb-3">Carte météo</h2>
          <WeatherMap
            coords={coords}
            favorites={favorites.map(fav => ({
              lat: fav.lat,
              lon: fav.lon,
              name: fav.place_name,
            }))}
          />
        </section>
      )}

      {/* HEURE PAR HEURE */}
      <section className="px-6 py-4 overflow-x-auto">
        <h2 className="font-bold mb-3">Isan’ora</h2>
        <div className="flex gap-4 min-w-max">
          {hourly.map((h, i) => {
            const date = new Date(h.forecast_time);
            return (
              <motion.div key={i} className="bg-white/10 rounded-xl p-3 min-w-[120px]" initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ duration: 0.6, delay: i * 0.05 }}>
                <div className="text-sm opacity-70">{date.getHours()}:00</div>
                <div className="text-xl font-bold">{h.temp}°</div>
                <div className="mt-2 text-xs flex items-center gap-1"><Wind className="w-3 h-3" /> {h.wind} km/h</div>
                <div className="text-xs flex items-center gap-1"><Droplet className="w-3 h-3" /> {h.humidity}%</div>
              </motion.div>
            );
          })}
        </div>
      </section>

      {/* 7 JOURS */}
      <section className="bg-white text-gray-900 rounded-t-3xl px-6 pt-6 mt-8">
        <h2 className="font-bold mb-4">Andro manaraka</h2>
        {daily.map((d, i) => (
          <div key={i} className="flex justify-between py-3 border-b">
            <div>{new Date(d.forecast_date).toLocaleDateString("mg-MG", { weekday: "short", day: "numeric", month: "short" })}</div>
            <div className="font-semibold">{d.temp_min}° / {d.temp_max}°</div>
          </div>
        ))}
      </section>
    </div>
  );
}