import { useEffect, useMemo, useState } from "react";
import {
  ArrowLeft,
  AlertTriangle,
  AlertCircle,
  Info,
  CloudRain,
  Sprout,
  AlertOctagon,
  Volume2,
} from "lucide-react";

import { useAuth } from "../contexts/AuthContext";
import { API_URL } from "../config";

type WeatherAlertRow = {
  id: string;
  location_id: string;
  alert_type: string;
  severity: string;
  title_mg: string;
  message_mg: string;
  recommendation_mg: string | null;
  alert_time: string;
  is_active: number | boolean;
  created_at: string;
};

type AlertsPayload = {
  meta: {
    locationId: string;
    place_name: string;
    forecast_time: string;
    condition: string;
    temperature: number;
    wind: number;
    humidity: number;
  } | null;
  alerts: WeatherAlertRow[];
};

interface AlertsProps {
  onNavigate: (screen: string) => void;
}

const LAST_LOCATION_KEY = "weather_last_locationId";

function speak(text: string, lang = "mg-MG") {
  if (typeof window === "undefined") return;
  const synth = window.speechSynthesis;
  if (!synth) return;

  try {
    synth.cancel();
  } catch (e) {
    console.error("Speech synthesis cancel error", e);
  }

  const u = new SpeechSynthesisUtterance(text);
  u.lang = lang;
  synth.speak(u);
}

export default function Alerts({ onNavigate }: AlertsProps) {
  const { region } = useAuth();

  const [locationId, setLocationId] = useState<string | null>(() =>
    localStorage.getItem(LAST_LOCATION_KEY)
  );
  const [payload, setPayload] = useState<AlertsPayload>({ meta: null, alerts: [] });
  const [loading, setLoading] = useState(true);

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
          setPayload({ meta: null, alerts: [] });
          setLoading(false);
        }
        return;
      }

      if (!cancelled) setLoading(true);

      try {
        const res = await fetch(`${API_URL}/api/alerts/by-weather/${id}?limit=3`);
        const data: AlertsPayload = res.ok ? await res.json() : { meta: null, alerts: [] };
        if (!cancelled) setPayload(data);
      } catch (e) {
        console.error("Load alerts error", e);
        if (!cancelled) setPayload({ meta: null, alerts: [] });
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    const interval = window.setInterval(load, 60_000);
    return () => {
      cancelled = true;
      window.clearInterval(interval);
    };
  }, [locationId]);

  const alerts = payload.alerts ?? [];
  const placeName = payload.meta?.place_name;

  const getSeverityConfig = (severity: string) => {
    switch (severity) {
      case "danger":
        return {
          bg: "bg-red-50",
          border: "border-red-200",
          text: "text-red-900",
          badge: "bg-red-600 text-white",
          icon: <AlertOctagon className="w-6 h-6 text-red-700" />,
          label: "Loza",
        };
      case "warning":
        return {
          bg: "bg-amber-50",
          border: "border-amber-200",
          text: "text-amber-950",
          badge: "bg-amber-600 text-white",
          icon: <AlertTriangle className="w-6 h-6 text-amber-700" />,
          label: "Fampandrenesana",
        };
      default:
        return {
          bg: "bg-sky-50",
          border: "border-sky-200",
          text: "text-sky-950",
          badge: "bg-sky-600 text-white",
          icon: <Info className="w-6 h-6 text-sky-700" />,
          label: "Fampahalalana",
        };
    }
  };

  const getAlertTypeIcon = (type: string) => {
    switch (type) {
      case "rain":
      case "storm":
      case "weather":
        return <CloudRain className="w-5 h-5 text-sky-700" />;
      case "planting":
      case "harvest":
      case "pest":
      case "work":
        return <Sprout className="w-5 h-5 text-emerald-700" />;
      default:
        return <AlertCircle className="w-5 h-5 text-slate-600" />;
    }
  };

  const formatDateTimeMG = useMemo(() => {
    return (dateString: string) => {
      const d = new Date(dateString);
      const months = [
        "Janoary",
        "Febroary",
        "Martsa",
        "Aprily",
        "Mey",
        "Jona",
        "Jolay",
        "Aogositra",
        "Septambra",
        "Oktobra",
        "Novambra",
        "Desambra",
      ];
      const day = d.getDate();
      const month = months[d.getMonth()];
      const year = d.getFullYear();
      const hh = String(d.getHours()).padStart(2, "0");
      const mm = String(d.getMinutes()).padStart(2, "0");
      return `${day} ${month} ${year} • ${hh}:${mm}`;
    };
  }, []);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50 flex items-center justify-center">
        <div className="text-slate-600">Mahandrasa...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50 pb-10">
      <div className="max-w-5xl mx-auto px-4 pt-6">
        <div className="flex items-center gap-3 mb-6">
          <button
            onClick={() => onNavigate("dashboard")}
            className="p-2 rounded-xl bg-white border border-slate-200 hover:bg-slate-50 transition"
            aria-label="Back"
            title="Hiverina"
          >
            <ArrowLeft className="w-5 h-5 text-slate-700" />
          </button>

          <div>
            <h1 className="text-2xl font-bold text-slate-900">Fampandrenesana</h1>
            <p className="text-sm text-slate-600">
              {placeName ? placeName : region?.name || "Toerana tsy misy"}
            </p>
          </div>
        </div>

        {!locationId ? (
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 text-slate-700">
            Safidio aloha ny tanàna ao amin’ny “Toetrandro”.
          </div>
        ) : alerts.length === 0 ? (
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 text-slate-700">
            Tsy misy fampandrenesana amin’izao ora izao.
          </div>
        ) : (
          <div className="space-y-4">
            {alerts.map((alert) => {
              const config = getSeverityConfig(alert.severity || "info");
              const speakText = `${alert.title_mg}. ${alert.message_mg}${alert.recommendation_mg ? `. Soso-kevitra: ${alert.recommendation_mg}` : ""
                }`;

              return (
                <div
                  key={alert.id}
                  className={`bg-white rounded-2xl border ${config.border} shadow-sm p-5`}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex items-start gap-3">
                      {config.icon}
                      <div className="min-w-0">
                        <div className="flex items-center gap-2 flex-wrap">
                          <span className={`px-3 py-1 rounded-full text-xs font-semibold ${config.badge}`}>
                            {config.label}
                          </span>
                          {getAlertTypeIcon(alert.alert_type || "")}
                          <span className="text-xs text-slate-500">
                            {formatDateTimeMG(alert.alert_time)}
                          </span>
                        </div>

                        <h2 className={`mt-2 text-lg font-bold ${config.text}`}>{alert.title_mg}</h2>
                      </div>
                    </div>

                    <button
                      onClick={() => speak(speakText, "mg-MG")}
                      className="p-2 rounded-xl bg-slate-50 hover:bg-slate-100 border border-slate-200"
                      title="Hihaino"
                    >
                      <Volume2 className="w-5 h-5 text-slate-700" />
                    </button>
                  </div>

                  <p className={`mt-3 ${config.text}`}>{alert.message_mg}</p>

                  {alert.recommendation_mg ? (
                    <div className="mt-4 rounded-xl border border-slate-200 bg-slate-50 p-4">
                      <div className="text-sm font-semibold text-slate-800">Soso-kevitra:</div>
                      <div className="text-slate-700">{alert.recommendation_mg}</div>
                    </div>
                  ) : null}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
