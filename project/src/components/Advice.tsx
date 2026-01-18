import { useEffect, useMemo, useState } from "react";
import { ArrowLeft, BookOpen, Sprout, Leaf, Wind, CloudRain, Sun, Filter } from "lucide-react";
import { useAuth } from "../contexts/AuthContext";
import { API_URL } from "../config";
import { readAdviceCache, writeAdviceCache } from "../offline/cache";

interface AdviceProps {
  onNavigate: (screen: string) => void;
}

type AdviceRow = {
  id: string;
  region_id: string | null;
  crop_type: string;
  season: string;
  title_mg: string;
  content_mg: string;
  icon?: string | null;
  created_at: string;
  weather_condition?: string | null;
  min_temp?: number | null;
  max_temp?: number | null;
  min_wind?: number | null;
  priority?: number | null;
};

type AdviceMeta = {
  locationId: string;
  place_name: string;
  forecast_time: string;
  condition: string;
  temperature: number;
  wind: number;
  humidity: number;
};

type AdvicePayload = {
  meta: AdviceMeta | null;
  advices: AdviceRow[];
};

const LAST_LOCATION_KEY = "weather_last_locationId";

function excerpt(text: string, max = 220) {
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

function getSeasonBadge(season: string) {
  const s = (season || "").toLowerCase();
  if (s.includes("fambol")) return chipClass("emerald");
  if (s.includes("fikarakar")) return chipClass("sky");
  if (s.includes("fijinj")) return chipClass("amber");
  return chipClass("slate");
}

function getCropIcon(cropType: string) {
  const c = (cropType || "").toLowerCase();
  if (c.includes("vary") || c.includes("rice")) return <Sprout className="w-5 h-5 text-emerald-600" />;
  if (c.includes("katsaka") || c.includes("maize") || c.includes("corn"))
    return <Leaf className="w-5 h-5 text-amber-600" />;
  return <BookOpen className="w-5 h-5 text-slate-600" />;
}

function getWeatherMiniIcon(condition: string) {
  const c = (condition || "").toLowerCase();
  if (c.includes("rain") || c.includes("orana") || c.includes("storm")) return <CloudRain className="w-4 h-4 text-sky-700" />;
  if (c.includes("sun") || c.includes("clear") || c.includes("masoandro")) return <Sun className="w-4 h-4 text-amber-600" />;
  return <Wind className="w-4 h-4 text-slate-600" />;
}

export default function Advice({ onNavigate }: AdviceProps) {
  const { region } = useAuth();

  const [locationId, setLocationId] = useState<string | null>(() =>
    localStorage.getItem(LAST_LOCATION_KEY)
  );

  const [meta, setMeta] = useState<AdviceMeta | null>(null);
  const [advices, setAdvices] = useState<AdviceRow[]>([]);
  const [loading, setLoading] = useState(true);

  const [selectedCrop, setSelectedCrop] = useState("all");
  const [selectedSeason, setSelectedSeason] = useState("all");

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
          setMeta(null);
          setAdvices([]);
          setLoading(false);
        }
        return;
      }

      if (!cancelled) setLoading(true);

      try {
        const qs = new URLSearchParams();
        qs.set("limit", "50");
        if (selectedCrop !== "all") qs.set("crop_type", selectedCrop);
        if (selectedSeason !== "all") qs.set("season", selectedSeason);

        const cacheKey = `advice:${id}:${qs.toString()}`;
        const url = `${API_URL}/api/advice/by-weather/${id}?${qs.toString()}`;

        // 1) Mamaky cash ny priorité
        const cached = await readAdviceCache(cacheKey);
        if (cached && !cancelled) {
          setMeta(cached.meta ?? null);
          setAdvices(cached.advices ?? []);
        }

        // 2) Raha tsy enligne dia tazomina ny cache
        if (!navigator.onLine) return;

        // 3) Raha actif dia maka donnée sady mameno cache
        const res = await fetch(url);
        const data = (res.ok ? await res.json() : { meta: null, advices: [] }) as AdvicePayload;

        await writeAdviceCache(cacheKey, data);

        if (!cancelled) {
          setMeta(data.meta ?? null);
          setAdvices(data.advices ?? []);
        }
      } catch (err) {
        console.error("Load advices error", err);
        if (!cancelled && !navigator.onLine) return;
        if (!cancelled) {
          setMeta(null);
          setAdvices([]);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();

    return () => {
      cancelled = true;
    };
  }, [locationId, selectedCrop, selectedSeason]);



  const cropTypes = useMemo(() => {
    const types = new Set(
      advices.map((a) => (a.crop_type || "").trim()).filter((t) => t && t !== "all")
    );
    return ["all", ...Array.from(types).sort((a, b) => a.localeCompare(b))];
  }, [advices]);

  const seasons = useMemo(() => {
    const types = new Set(advices.map((a) => (a.season || "").trim()).filter(Boolean));
    return ["all", ...Array.from(types).sort((a, b) => a.localeCompare(b))];
  }, [advices]);

  const filteredAdvices = useMemo(() => {
    return advices.filter((a) => {
      const okCrop = selectedCrop === "all" || a.crop_type === selectedCrop;
      const okSeason = selectedSeason === "all" || a.season === selectedSeason;
      return okCrop && okSeason;
    });
  }, [advices, selectedCrop, selectedSeason]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50 flex items-center justify-center">
        <div className="text-slate-600">Mahandrasa...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-sky-50 to-amber-50 pb-10">
      <div className="max-w-6xl mx-auto px-4 pt-6 space-y-6">
        {/* Header */}
        <div className="flex items-start justify-between gap-4">
          <div className="flex items-center gap-3">
            <button
              onClick={() => onNavigate("dashboard")}
              className="p-2 rounded-xl bg-white border border-slate-200 hover:bg-slate-50 transition"
              aria-label="Back"
            >
              <ArrowLeft className="w-5 h-5 text-slate-700" />
            </button>

            <div>
              <h1 className="text-2xl font-bold text-slate-900">Torohevitra</h1>
              <p className="text-sm text-slate-600">{region?.name || ""}</p>

              {meta ? (
                <div className="mt-2 flex flex-wrap gap-2">
                  <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("slate")}`}>
                    {meta.place_name}
                  </span>
                  <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("sky")} inline-flex items-center gap-1`}>
                    {getWeatherMiniIcon(meta.condition)} {meta.condition}
                  </span>
                  <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("amber")}`}>
                    {meta.temperature}°C • {meta.wind} km/h
                  </span>
                </div>
              ) : (
                <div className="mt-2 text-sm text-slate-600">
                  Safidio aloha ny tanàna ao amin’ny “Toetrandro”.
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Filters */}
        <div className="bg-white/85 rounded-3xl border border-white/70 shadow-sm p-5">
          <div className="flex items-center gap-2 text-slate-900 font-semibold mb-4">
            <Filter className="w-5 h-5 text-slate-700" />
            Sivana
          </div>

          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">Karazan-javamaniry</label>
              <select
                value={selectedCrop}
                onChange={(e) => setSelectedCrop(e.target.value)}
                className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-sky-500 focus:border-transparent"
              >
                {cropTypes.map((crop) => (
                  <option key={crop} value={crop}>
                    {crop === "all" ? "Daholo" : crop}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">Vanim-potoana</label>
              <select
                value={selectedSeason}
                onChange={(e) => setSelectedSeason(e.target.value)}
                className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-sky-500 focus:border-transparent"
              >
                {seasons.map((s) => (
                  <option key={s} value={s}>
                    {s === "all" ? "Daholo" : s}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="mt-4 text-sm text-slate-600">
            Torohevitra hita: <span className="font-semibold text-slate-900">{filteredAdvices.length}</span>
          </div>
        </div>

        {/* List */}
        {!locationId ? (
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 text-slate-700">
            Safidio aloha ny tanàna ao amin’ny “Toetrandro”.
          </div>
        ) : filteredAdvices.length === 0 ? (
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 text-slate-700">
            Tsy misy torohevitra mifanaraka amin’izao sivana izao.
          </div>
        ) : (
          <div className="grid lg:grid-cols-2 gap-4">
            {filteredAdvices.map((advice) => (
              <div
                key={advice.id}
                className="bg-white/85 rounded-3xl border border-white/70 shadow-sm p-5"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex items-start gap-3 min-w-0">
                    <div className="mt-0.5">{getCropIcon(advice.crop_type)}</div>
                    <div className="min-w-0">
                      <div className="flex flex-wrap gap-2 mb-2">
                        <span className={`text-xs px-2.5 py-1 rounded-full border ${getSeasonBadge(advice.season)}`}>
                          {advice.season}
                        </span>
                        {advice.crop_type ? (
                          <span className={`text-xs px-2.5 py-1 rounded-full border ${chipClass("slate")}`}>
                            {advice.crop_type}
                          </span>
                        ) : null}
                      </div>

                      <h3 className="text-lg font-bold text-slate-900">{advice.title_mg}</h3>
                    </div>
                  </div>
                </div>

                <p className="mt-3 text-slate-700">{excerpt(advice.content_mg, 260)}</p>

                {advice.icon ? (
                  <div className="mt-4 text-sm text-slate-500">
                    Icon: <span className="font-medium">{advice.icon}</span>
                  </div>
                ) : null}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
