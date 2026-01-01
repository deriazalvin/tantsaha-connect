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

import { useAuth } from "../contexts/AuthContext";

type CurrentWeather = {
  temperature: number;
  condition: string;
  icon: string | number;
  place_name: string;
  time: string;
};

type HourlyWeather = {
  forecast_time: string;
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
        const [curRes, hourRes, adviceRes, alertsRes] = await Promise.all([
          fetch(`/api/weather/current/${id}`),
          fetch(`/api/weather/hourly/${id}`),
          fetch(`/api/advice/by-weather/${id}?limit=1`),
          fetch(`/api/alerts/by-weather/${id}?limit=1`),
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

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50 flex items-center justify-center">
        <div className="text-slate-600">Mahandrasa...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50">
      {/* Header: clair + accents */}
      <header className="border-b border-white/60 bg-white/70 backdrop-blur">
        <div className="max-w-6xl mx-auto px-4 py-5 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-2xl bg-slate-900 text-white flex items-center justify-center overflow-hidden shadow-sm">
              {profile?.profile_photo_url ? (
                <img
                  src={profile.profile_photo_url}
                  alt={profile.full_name || "Profile"}
                  className="w-12 h-12 object-cover"
                />
              ) : (
                <User className="w-6 h-6" />
              )}
            </div>

            <div>
              <div className="text-lg font-bold text-slate-900 leading-tight">
                {profile?.full_name || "Utilisateur"}
              </div>
              <div className="text-sm text-slate-600">
                {region?.name || "Faritra"}
                {current?.place_name ? ` • ${current.place_name}` : ""}
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
                {current ? current.place_name : "Mandehana any amin’ny Toetrandro hisafidy tanàna."}
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
                  <div className="text-sm text-slate-600">{current.place_name}</div>
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
    </div>
  );
}
