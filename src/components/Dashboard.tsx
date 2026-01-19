import { useEffect, useMemo, useState } from "react";
import {
  Cloud,
  CloudRain,
  Sun,
  Wind,
  LogOut,
  User,
  CloudDrizzle,
  BookOpen,
  ArrowRight,
  Bell,
  Lightbulb,
} from "lucide-react";
import clsx from "clsx";
import { useAuth } from "../contexts/AuthContext";
import { API_URL } from "../config";
import { readAdviceCache, readAlertsCache } from "../offline/cache";
import UploadForm from "../components/UploadForm";


type CurrentWeather = {
  temperature: number;
  condition: string;
  icon: string | number;
  placename: string;     
  time: string;
};

type HourlyWeather = {
  forecasttime: string;  
  temp: number;
  wind: number;
  humidity: number;
  condition?: string;
};


type AdviceRow = {
  id: string;
  title_mg: string;
  content_mg: string;
  crop_type: string;
  season: string;
  icon?: string | null;
};

type AdvicePayload = {
  meta: any;
  advices: AdviceRow[];
};

type AlertRow = {
  id: string;
  alert_type: string;
  severity: string;
  title_mg: string;
  message_mg: string;
  recommendation_mg?: string | null;
  alert_time: string;
};

type AlertsPayload = {
  meta: any;
  alerts: AlertRow[];
};

const CACHE_PREFIX = "weathercache:";

type WeatherCache = {
  savedAt: number;
  locationId: string;
  coords: any | null;
  current: CurrentWeather | null;
  hourly: HourlyWeather[];
  daily: any[];
};

function safeParseJSON<T>(raw: string | null): T | null {
  try {
    return raw ? (JSON.parse(raw) as T) : null;
  } catch {
    return null;
  }
}

function readWeatherCache(locationId: string): WeatherCache | null {
  return safeParseJSON<WeatherCache>(localStorage.getItem(CACHE_PREFIX + locationId));
}


interface DashboardProps {
  onNavigate: (screen: string) => void;
}

const LAST_LOCATION_KEY = "weather_last_locationId";

const conditionMG: Record<string, string> = {
  Rain: "Orana",
  Rainy: "Orana",
  Sunny: "Masoandro",
  Clear: "Masoandro",
  Cloudy: "Rahona",
  Overcast: "Rahona mavesatra",
  Thunderstorm: "Rivo-doza",
};

function getWeatherIcon(condition?: string) {
  switch (condition) {
    case "Sunny":
    case "Clear":
    case "Masoandro":
      return <Sun className="w-10 h-10 text-amber-500" />;
    case "Rain":
    case "Rainy":
    case "Orana":
    case "Thunderstorm":
      return <CloudRain className="w-10 h-10 text-sky-600" />;
    case "Cloudy":
    case "Overcast":
    case "Rahona":
      return <Cloud className="w-10 h-10 text-slate-500" />;
    default:
      return <CloudDrizzle className="w-10 h-10 text-slate-400" />;
  }
}

function excerpt(text: string, max = 120) {
  const t = (text || "").replace(/\s+/g, " ").trim();
  return t.length <= max ? t : t.slice(0, max - 1) + "…";
}

function chipClass(kind: "sky" | "amber" | "emerald" | "slate") {
  switch (kind) {
    case "sky":
      return "bg-sky-50 text-sky-700 border-sky-100";
    case "amber":
      return "bg-amber-50 text-amber-700 border-amber-100";
    case "emerald":
      return "bg-emerald-50 text-emerald-700 border-emerald-100";
    default:
      return "bg-slate-50 text-slate-700 border-slate-200";
  }
}

export default function Dashboard({ onNavigate }: DashboardProps) {
  const { profile, region, signOut } = useAuth();

  const [locationId, setLocationId] = useState<string | null>(() =>
    localStorage.getItem(LAST_LOCATION_KEY)
  );

  const [current, setCurrent] = useState<CurrentWeather | null>(null);
  const [nextHour, setNextHour] = useState<HourlyWeather | null>(null);
  const [adviceTop, setAdviceTop] = useState<AdviceRow | null>(null);
  const [alertTop, setAlertTop] = useState<AlertRow | null>(null);

  const [loading, setLoading] = useState(true);

  const conditionLabel = useMemo(() => {
    if (!current?.condition) return "";
    return conditionMG[current.condition] || current.condition;
  }, [current]);

  const [showUpload, setShowUpload] = useState(false);


  useEffect(() => {
    const handler = () => setLocationId(localStorage.getItem(LAST_LOCATION_KEY));
    window.addEventListener("storage", handler);
    return () => window.removeEventListener("storage", handler);
  }, []);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      const id = locationId || localStorage.getItem(LAST_LOCATION_KEY);

      if (!id) {
        if (!cancelled) {
          setCurrent(null);
          setNextHour(null);
          setAdviceTop(null);
          setAlertTop(null);
          setLoading(false);
        }
        return;
      }

      if (!cancelled) setLoading(true);

      try {
        // LocalStorage toetrandro
        const wc = readWeatherCache(id);
        if (wc?.current && !cancelled) {
          setCurrent(wc.current);
          setNextHour(wc.hourly?.[0] ?? null);
        }

        // Indexdb : torohevitra , fampitandremana
        const adviceKey = `advice:${id}:${new URLSearchParams({ limit: "50" }).toString()}`;
        const alertsKey = `alerts:${id}:${new URLSearchParams({ limit: "3" }).toString()}`;

        const [adviceCached, alertsCached] = await Promise.all([
          readAdviceCache(adviceKey),
          readAlertsCache(alertsKey),
        ]);

        if (!cancelled) {
          setAdviceTop(adviceCached?.advices?.[0] ?? null);
          setAlertTop(alertsCached?.alerts?.[0] ?? null);
        }

        // Tsy actif (gardena ny cache)
        if (!navigator.onLine) return;

        // En ligne (maka données)
        const [curRes, hourRes, adviceRes, alertsRes] = await Promise.all([
          fetch(`${API_URL}/api/weather/current/${id}`),
          fetch(`${API_URL}/api/weather/hourly/${id}`),
          fetch(`${API_URL}/api/advice/by-weather/${id}?limit=1`),
          fetch(`${API_URL}/api/alerts/by-weather/${id}?limit=1`),
        ]);

        const cur: CurrentWeather | null = curRes.ok ? await curRes.json() : null;
        const hourly: HourlyWeather[] = hourRes.ok ? await hourRes.json() : [];
        const advicePayload: AdvicePayload | null = adviceRes.ok ? await adviceRes.json() : null;
        const alertsPayload: AlertsPayload | null = alertsRes.ok ? await alertsRes.json() : null;

        if (cancelled) return;

        setCurrent(cur);
        setNextHour(hourly?.[0] ?? null);
        setAdviceTop(advicePayload?.advices?.[0] ?? null);
        setAlertTop(alertsPayload?.alerts?.[0] ?? null);
      } catch (e) {
        console.error("Dashboard load error", e);

        

        if (!cancelled) {
          setCurrent(null);
          setNextHour(null);
          setAdviceTop(null);
          setAlertTop(null);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    return () => {
      cancelled = true;
    };
  }, [locationId]);

const [imageBroken, setImageBroken] = useState(false);

const avatarSrc = useMemo(() => {
  const src = profile?.profile_photo_url;
  if (!src) return null;
  if (/^https?:\/\//i.test(src)) {
    return src;
  }
  return `${API_URL.replace(/\/$/, "")}${src.startsWith("/") ? "" : "/"}${src}`;
}, [profile?.profile_photo_url]);

useEffect(() => {
  setImageBroken(false);
}, [avatarSrc]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50 flex items-center justify-center">
        <div className="text-slate-600">Mahandrasa...</div>
      </div>
    );
  }

  function getInitials(name?: string | null) {
    if (!name) return "";
    return name
      .split(" ")
      .map((p) => p[0])
      .slice(0, 2)
      .join("")
      .toUpperCase();
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50">
      {/* Header*/}
      <header className="border-b border-white/60 bg-white/70 backdrop-blur">
        <div className="max-w-6xl mx-auto px-4 py-5 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setShowUpload(true)}
              aria-label="Changer la photo de profil"
              className="relative"
            >
              <div
                className={clsx(
                  "rounded-2xl bg-slate-900 text-white flex items-center justify-center overflow-hidden shadow-sm",
                  // responsive sizes : small on mobile, larger on md+
                  "w-12 h-12 md:w-16 md:h-16 lg:w-20 lg:h-20"
                )}
              >
                {avatarSrc && !imageBroken ? (
                  <img
                    src={avatarSrc}
                    alt={profile?.full_name ? `${profile.full_name} avatar` : "Avatar"}
                    className="w-full h-full object-cover"
                    onError={(e) => {
                      // on image error, cache the fact to avoid re-attempt
                      setImageBroken(true);
                      // optionally remove src to stop browser from retrying
                      // @ts-ignore
                      e.currentTarget.onerror = null;
                      // @ts-ignore
                      e.currentTarget.src = "";
                    }}
                  />
                ) : profile?.full_name ? (
                  // initials fallback
                  <div className="w-full h-full flex items-center justify-center bg-slate-700 text-white font-semibold">
                    {getInitials(profile.full_name)}
                  </div>
                ) : (
                  // icon fallback
                  <User className="w-6 h-6 md:w-8 md:h-8 text-white" />
                )}
              </div>

              {/* Edit badge */}
              <span
                className="absolute -right-1 -bottom-1 bg-white rounded-full p-1 border border-slate-200 shadow-sm"
                title="Changer la photo"
                aria-hidden
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4 text-slate-900" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15.232 5.232l3.536 3.536M9 11l6 6L21 11l-6-6-6 6z" />
                </svg>
              </span>
            </button>



            <div>
              <div className="text-lg font-bold text-slate-900 leading-tight">
                {profile?.full_name || "Utilisateur"}
              </div>
              <div className="text-sm text-slate-600">
                {region?.name || "Faritra"}
                {current?.placename ? ` • ${current.placename}` : ""}
              </div>

              <div className="mt-2 flex flex-wrap gap-2">
                <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("slate")}`}>
                  {current ? conditionLabel : "Tsy misy toerana"}
                </span>
                <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("sky")}`}>
                  Toetrandro
                </span>
                <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("amber")}`}>
                  Torohevitra
                </span>
              </div>
            </div>
          </div>

          <button
            onClick={signOut}
            className="px-3 py-2 rounded-xl bg-slate-900 text-white hover:bg-slate-800 transition"
            title="Hivoaka"
          >
            <span className="inline-flex items-center gap-2">
              <LogOut className="w-4 h-4" />
              Hivoaka
            </span>
          </button>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-4 py-6 space-y-6">
        {/* Actions rapides */}
        <section className="bg-white/80 border border-white/70 shadow-sm rounded-3xl p-5">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
            <div>
              <div className="text-sm text-slate-500">Toe-javatra anio</div>
              <div className="text-2xl font-bold text-slate-900">
                {current ? `${conditionLabel} • ${current.temperature}°` : "Safidio toerana"}
              </div>
              <div className="text-sm text-slate-600 mt-1">
                {current ? current.placename : "Mandehana any amin’ny Toetrandro hisafidy tanàna."}
              </div>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => onNavigate("weather")}
                className="px-4 py-2 rounded-xl bg-sky-600 text-white hover:bg-sky-700 transition"
              >
                Toetrandro
              </button>
              <button
                onClick={() => onNavigate("alerts")}
                className="px-4 py-2 rounded-xl bg-amber-500 text-white hover:bg-amber-600 transition"
              >
                Alertes
              </button>
              <button
                onClick={() => onNavigate("advice")}
                className="px-4 py-2 rounded-xl bg-white border border-slate-200 hover:bg-slate-50 transition text-slate-900"
              >
                Torohevitra
              </button>
            </div>
          </div>
        </section>

        {/* KPI */}
        <section className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-4">
            <div className="text-xs text-slate-500">Mari-pana</div>
            <div className="mt-1 text-2xl font-bold text-slate-900">
              {current ? `${current.temperature}°` : "—"}
            </div>
            <div className="mt-2 text-sm text-slate-700">{current ? conditionLabel : "—"}</div>
          </div>

          <div className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-4">
            <div className="text-xs text-slate-500">Rivotra</div>
            <div className="mt-1 text-2xl font-bold text-slate-900">
              {nextHour ? `${nextHour.wind}` : "—"}
              <span className="text-sm font-medium text-slate-600"> km/h</span>
            </div>
            <div className="mt-2 text-sm text-slate-700 inline-flex items-center gap-2">
              <Wind className="w-4 h-4 text-slate-500" />
              Ora manaraka
            </div>
          </div>

          <div className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-4">
            <div className="text-xs text-slate-500">Hamandoana</div>
            <div className="mt-1 text-2xl font-bold text-slate-900">
              {nextHour ? `${nextHour.humidity}%` : "—"}
            </div>
            <div className="mt-2 text-sm text-slate-700">Ora manaraka</div>
          </div>

          <button
            onClick={() => onNavigate("alerts")}
            className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-4 text-left hover:shadow transition"
          >
            <div className="flex items-center justify-between">
              <div className="text-xs text-slate-500">Fampandrenesana</div>
              <Bell className="w-4 h-4 text-amber-600" />
            </div>
            <div className="mt-1 text-2xl font-bold text-slate-900">{alertTop ? "1" : "0"}</div>
            <div className="mt-2 text-sm text-slate-700">
              {alertTop ? excerpt(alertTop.title_mg, 42) : "Tsy misy izao"}
            </div>
          </button>
        </section>

        {/* Main content */}
        <section className="grid lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 bg-white/85 rounded-3xl border border-white/70 shadow-sm p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-bold text-slate-900">Toetrandro</h2>
              <button
                onClick={() => onNavigate("weather")}
                className="text-sky-700 text-sm font-medium inline-flex items-center gap-1 hover:underline"
              >
                Hijery daholo <ArrowRight className="w-4 h-4" />
              </button>
            </div>

            {!current ? (
              <p className="text-slate-600">Safidio aloha ny tanàna ao amin’ny “Toetrandro”.</p>
            ) : (
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 rounded-2xl bg-slate-50 border border-slate-200 flex items-center justify-center">
                  {getWeatherIcon(current.condition)}
                </div>
                <div className="flex-1">
                  <div className="text-sm text-slate-600">{current.placename}</div>
                  <div className="text-4xl font-bold text-slate-900">{current.temperature}°</div>
                  <div className="text-slate-700 mt-1">{conditionLabel}</div>

                  {nextHour && (
                    <div className="mt-3 flex flex-wrap gap-3 text-sm text-slate-600">
                      <span className={`px-3 py-1 rounded-full border ${chipClass("sky")}`}>
                        Rivotra: {nextHour.wind} km/h
                      </span>
                      <span className={`px-3 py-1 rounded-full border ${chipClass("emerald")}`}>
                        Hamandoana: {nextHour.humidity}%
                      </span>
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>

          <div className="space-y-6">
            <div className="bg-white/85 rounded-3xl border border-white/70 shadow-sm p-6">
              <div className="flex items-center justify-between mb-3">
                <h2 className="text-lg font-bold text-slate-900 inline-flex items-center gap-2">
                  <Lightbulb className="w-5 h-5 text-amber-600" />
                  Torohevitra
                </h2>
                <button
                  onClick={() => onNavigate("advice")}
                  className="text-amber-700 text-sm font-medium inline-flex items-center gap-1 hover:underline"
                >
                  Hijery <ArrowRight className="w-4 h-4" />
                </button>
              </div>

              {!adviceTop ? (
                <p className="text-slate-600">Tsy misy torohevitra amin’izao toetrandro izao.</p>
              ) : (
                <>
                  <div className="text-xs text-slate-500 mb-1">
                    {adviceTop.season} • {adviceTop.crop_type}
                  </div>
                  <div className="font-semibold text-slate-900">{adviceTop.title_mg}</div>
                  <div className="text-slate-700 mt-2">{excerpt(adviceTop.content_mg, 170)}</div>
                </>
              )}
            </div>

            <div className="bg-white/85 rounded-3xl border border-white/70 shadow-sm p-6">
              <div className="flex items-center justify-between mb-3">
                <h2 className="text-lg font-bold text-slate-900">Alerte farany</h2>
                <button
                  onClick={() => onNavigate("alerts")}
                  className="text-amber-700 text-sm font-medium inline-flex items-center gap-1 hover:underline"
                >
                  Hijery <ArrowRight className="w-4 h-4" />
                </button>
              </div>

              {!alertTop ? (
                <p className="text-slate-600">Tsy misy fampandrenesana amin’izao ora izao.</p>
              ) : (
                <>
                  <div className="text-xs text-slate-500 mb-1">
                    {alertTop.severity} • {alertTop.alert_type}
                  </div>
                  <div className="font-semibold text-slate-900">{alertTop.title_mg}</div>
                  <div className="text-slate-700 mt-2">{excerpt(alertTop.message_mg, 150)}</div>
                </>
              )}
            </div>
          </div>
        </section>

        {/* Shortcuts */}
        <section className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <button
            onClick={() => onNavigate("weather")}
            className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-5 hover:shadow transition flex flex-col items-center gap-3"
          >
            <Cloud className="w-8 h-8 text-sky-600" />
            <span className="font-semibold text-slate-800">Toetrandro</span>
          </button>

          <button
            onClick={() => onNavigate("advice")}
            className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-5 hover:shadow transition flex flex-col items-center gap-3"
          >
            <BookOpen className="w-8 h-8 text-amber-600" />
            <span className="font-semibold text-slate-800">Torohevitra</span>
          </button>

          <button
            onClick={() => onNavigate("alerts")}
            className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-5 hover:shadow transition flex flex-col items-center gap-3"
          >
            <Bell className="w-8 h-8 text-amber-600" />
            <span className="font-semibold text-slate-800">Alertes</span>
          </button>

          <button
            onClick={() => onNavigate("journal")}
            className="bg-white/85 rounded-2xl border border-white/70 shadow-sm p-5 hover:shadow transition flex flex-col items-center gap-3"
          >
            <BookOpen className="w-8 h-8 text-slate-600" />
            <span className="font-semibold text-slate-800">Boky</span>
          </button>
        </section>
      </main>
      {showUpload && (
        <UploadForm onClose={() => setShowUpload(false)} />
      )}
    </div>
  );
}
