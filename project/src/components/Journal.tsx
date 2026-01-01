import { useEffect, useMemo, useState } from "react";
import {
  ArrowLeft,
  Plus,
  Calendar,
  X,
  Edit,
  Trash,
  CloudRain,
  Bug,
  Sprout,
  Leaf,
  ChevronLeft,
  ChevronRight,
} from "lucide-react";
import dayjs from "dayjs";
import { useAuth } from "../contexts/AuthContext";
import type { Database } from "../lib/database.types";

type CropJournal = Database["public"]["Tables"]["crop_journal"]["Row"];

interface JournalProps {
  onNavigate: (screen: string) => void;
}

const TOKEN_KEY = "tantsaha_token";

function formatDateMG(dateString: string) {
  // Simple format lisible (tu peux localiser plus tard)
  return dayjs(dateString).format("DD MMM YYYY");
}

function excerpt(text?: string | null, max = 140) {
  const t = (text || "").replace(/\s+/g, " ").trim();
  return t.length <= max ? t : t.slice(0, max - 1) + "…";
}

export default function Journal({ onNavigate }: JournalProps) {
  const { user } = useAuth();

  const [entries, setEntries] = useState<CropJournal[]>([]);
  const [loading, setLoading] = useState(true);

  const [showForm, setShowForm] = useState(false);
  const [editingEntry, setEditingEntry] = useState<CropJournal | null>(null);

  const [saving, setSaving] = useState(false);

  const [selectedDate, setSelectedDate] = useState(dayjs().format("YYYY-MM-DD"));
  const [monthCursor, setMonthCursor] = useState(dayjs().startOf("month")); // <-- permet de voir mois précédent

  const [formData, setFormData] = useState({
    observation_date: dayjs().format("YYYY-MM-DD"),
    observation_type: "",
    crop_type: "",
    notes_mg: "",
  });

  useEffect(() => {
    if (user) loadEntries();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user]);

  async function loadEntries() {
    if (!user) return;

    setLoading(true);
    try {
      const token = localStorage.getItem(TOKEN_KEY);
      const res = await fetch(`/api/journal`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data: CropJournal[] = await res.json();
        setEntries(data || []);
      } else {
        setEntries([]);
      }
    } catch (err) {
      console.error("Load journal error", err);
      setEntries([]);
    } finally {
      setLoading(false);
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    setSaving(true);
    const token = localStorage.getItem(TOKEN_KEY);

    try {
      const url = editingEntry ? `/api/journal/${editingEntry.id}` : "/api/journal";
      const method = editingEntry ? "PUT" : "POST";

      const res = await fetch(url, {
        method,
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(formData),
      });

      if (res.ok) {
        setShowForm(false);
        setEditingEntry(null);
        setFormData({
          observation_date: dayjs().format("YYYY-MM-DD"),
          observation_type: "",
          crop_type: "",
          notes_mg: "",
        });
        await loadEntries();
      }
    } catch (err) {
      console.error("Save journal error", err);
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (entry: CropJournal) => {
    setEditingEntry(entry);
    setFormData({
      observation_date: dayjs(entry.observation_date).format("YYYY-MM-DD"),
      observation_type: entry.observation_type,
      crop_type: entry.crop_type || "",
      notes_mg: entry.notes_mg || "",
    });
    setShowForm(true);

    // UX: positionner le calendrier sur le mois de l'entrée
    const m = dayjs(entry.observation_date).startOf("month");
    setMonthCursor(m);
    setSelectedDate(dayjs(entry.observation_date).format("YYYY-MM-DD"));
  };

  const handleDelete = async (entry: CropJournal) => {
    if (!confirm("Hanana antoka ve fa hamafa ity fandraisana an-tsoratra ity?")) return;

    const token = localStorage.getItem(TOKEN_KEY);
    try {
      const res = await fetch(`/api/journal/${entry.id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      });
      if (res.ok) await loadEntries();
    } catch (err) {
      console.error("Delete error", err);
    }
  };

  const getObservationIcon = (type: string) => {
    switch (type) {
      case "rain":
        return <CloudRain className="w-5 h-5 text-sky-600" />;
      case "pest":
        return <Bug className="w-5 h-5 text-rose-600" />;
      case "planting":
        return <Sprout className="w-5 h-5 text-emerald-600" />;
      case "harvest":
        return <Leaf className="w-5 h-5 text-amber-600" />;
      case "treatment":
        return <Leaf className="w-5 h-5 text-violet-600" />;
      default:
        return <Calendar className="w-5 h-5 text-slate-500" />;
    }
  };

  const getObservationLabel = (type: string) => {
    switch (type) {
      case "rain":
        return "Orana";
      case "pest":
        return "Bibikely";
      case "planting":
        return "Famboly";
      case "harvest":
        return "Fijinjana";
      case "treatment":
        return "Fitsaboana";
      default:
        return type || "Hafa";
    }
  };

  const entriesByDate = useMemo(() => {
    const map = new Map<string, CropJournal[]>();
    for (const e of entries) {
      const key = dayjs(e.observation_date).format("YYYY-MM-DD");
      const arr = map.get(key) || [];
      arr.push(e);
      map.set(key, arr);
    }
    return map;
  }, [entries]);

  const filteredEntries = useMemo(() => {
    return entries.filter(
      (e) => dayjs(e.observation_date).format("YYYY-MM-DD") === selectedDate
    );
  }, [entries, selectedDate]);

  const monthDays = useMemo(() => {
    const start = monthCursor.startOf("month");
    const daysInMonth = start.daysInMonth();
    return Array.from({ length: daysInMonth }, (_, i) => start.add(i, "day"));
  }, [monthCursor]);

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
              <h1 className="text-2xl font-bold text-slate-900">Boky fitantarana</h1>
              <p className="text-sm text-slate-600">Ny tantarako momba ny fambolena</p>
            </div>
          </div>

          <button
            onClick={() => {
              setEditingEntry(null);
              setFormData({
                observation_date: selectedDate,
                observation_type: "",
                crop_type: "",
                notes_mg: "",
              });
              setShowForm(true);
            }}
            className="px-4 py-2 rounded-xl bg-sky-600 text-white hover:bg-sky-700 transition inline-flex items-center gap-2"
          >
            <Plus className="w-4 h-4" />
            Hanampy
          </button>
        </div>

        {/* Grid layout: Calendar + Day entries */}
        <div className="grid lg:grid-cols-3 gap-6">
          {/* Calendar card */}
          <div className="bg-white/85 rounded-3xl border border-white/70 shadow-sm p-5">
            <div className="flex items-center justify-between mb-4">
              <div className="font-semibold text-slate-900 inline-flex items-center gap-2">
                <Calendar className="w-5 h-5 text-slate-700" />
                {monthCursor.format("MMMM YYYY")}
              </div>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => setMonthCursor((m) => m.subtract(1, "month"))}
                  className="p-2 rounded-xl bg-slate-50 border border-slate-200 hover:bg-slate-100"
                  title="Mois précédent"
                >
                  <ChevronLeft className="w-4 h-4 text-slate-700" />
                </button>
                <button
                  onClick={() => setMonthCursor((m) => m.add(1, "month"))}
                  className="p-2 rounded-xl bg-slate-50 border border-slate-200 hover:bg-slate-100"
                  title="Mois suivant"
                >
                  <ChevronRight className="w-4 h-4 text-slate-700" />
                </button>
              </div>
            </div>

            <div className="grid grid-cols-7 gap-2">
              {monthDays.map((d) => {
                const key = d.format("YYYY-MM-DD");
                const isSelected = key === selectedDate;
                const hasEntry = entriesByDate.has(key);

                return (
                  <button
                    key={key}
                    onClick={() => setSelectedDate(key)}
                    className={[
                      "h-10 rounded-xl text-sm border transition",
                      isSelected
                        ? "bg-slate-900 text-white border-slate-900"
                        : hasEntry
                          ? "bg-sky-50 text-sky-800 border-sky-100 hover:bg-sky-100"
                          : "bg-white text-slate-700 border-slate-200 hover:bg-slate-50",
                    ].join(" ")}
                    title={formatDateMG(key)}
                  >
                    {d.date()}
                  </button>
                );
              })}
            </div>

            <div className="mt-4 text-xs text-slate-500">
              Astuce: les jours en bleu ont au moins un journal.
            </div>
          </div>

          {/* Entries for selected day */}
          <div className="lg:col-span-2 bg-white/85 rounded-3xl border border-white/70 shadow-sm p-6">
            <div className="flex items-center justify-between mb-4">
              <div>
                <div className="text-sm text-slate-500">Daty voafidy</div>
                <div className="text-lg font-bold text-slate-900">{formatDateMG(selectedDate)}</div>
              </div>
              <button
                onClick={() => {
                  setEditingEntry(null);
                  setFormData({
                    observation_date: selectedDate,
                    observation_type: "",
                    crop_type: "",
                    notes_mg: "",
                  });
                  setShowForm(true);
                }}
                className="px-3 py-2 rounded-xl bg-white border border-slate-200 hover:bg-slate-50 transition text-slate-900 inline-flex items-center gap-2"
              >
                <Plus className="w-4 h-4" />
                Journal ho an’ity daty ity
              </button>
            </div>

            {filteredEntries.length === 0 ? (
              <div className="text-slate-600">Tsy misy fandraisana an-tsoratra amin’ity daty ity.</div>
            ) : (
              <div className="space-y-3">
                {filteredEntries.map((entry) => (
                  <div
                    key={entry.id}
                    className="rounded-2xl border border-slate-200 bg-white p-4 flex items-start justify-between gap-4"
                  >
                    <div className="flex items-start gap-3 min-w-0">
                      <div className="mt-0.5">{getObservationIcon(entry.observation_type)}</div>
                      <div className="min-w-0">
                        <div className="text-sm text-slate-500">
                          {getObservationLabel(entry.observation_type)}
                          {entry.crop_type ? ` • ${entry.crop_type}` : ""}
                        </div>
                        {entry.notes_mg ? (
                          <div className="text-slate-800 mt-1">{entry.notes_mg}</div>
                        ) : (
                          <div className="text-slate-500 mt-1 italic">Tsy misy fanamarihana.</div>
                        )}
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleEdit(entry)}
                        className="px-3 py-2 rounded-xl bg-amber-50 border border-amber-100 text-amber-800 hover:bg-amber-100 transition inline-flex items-center gap-2"
                      >
                        <Edit className="w-4 h-4" />
                        Hanova
                      </button>
                      <button
                        onClick={() => handleDelete(entry)}
                        className="px-3 py-2 rounded-xl bg-rose-50 border border-rose-100 text-rose-700 hover:bg-rose-100 transition inline-flex items-center gap-2"
                      >
                        <Trash className="w-4 h-4" />
                        Hamafa
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* History: show all entries (solves “yesterday not visible”) */}
        <div className="bg-white/85 rounded-3xl border border-white/70 shadow-sm p-6">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-lg font-bold text-slate-900">Tantaran’ny journaux</h2>
              <p className="text-sm text-slate-600">
                Ity lisitra ity dia mampiseho ny journaux rehetra na inona na inona volana.
              </p>
            </div>
          </div>

          {entries.length === 0 ? (
            <div className="text-slate-600">Tsy mbola misy journal voatahiry.</div>
          ) : (
            <div className="divide-y divide-slate-200">
              {entries.slice(0, 20).map((e) => (
                <div key={e.id} className="py-4 flex items-start justify-between gap-4">
                  <div className="flex items-start gap-3 min-w-0">
                    <div className="mt-0.5">{getObservationIcon(e.observation_type)}</div>
                    <div className="min-w-0">
                      <div className="text-sm text-slate-500">
                        {formatDateMG(e.observation_date)} • {getObservationLabel(e.observation_type)}
                        {e.crop_type ? ` • ${e.crop_type}` : ""}
                      </div>
                      <div className="text-slate-800 mt-1">{excerpt(e.notes_mg, 160)}</div>
                    </div>
                  </div>

                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => handleEdit(e)}
                      className="p-2 rounded-xl bg-slate-50 border border-slate-200 hover:bg-slate-100"
                      title="Hanova"
                    >
                      <Edit className="w-4 h-4 text-slate-700" />
                    </button>
                    <button
                      onClick={() => handleDelete(e)}
                      className="p-2 rounded-xl bg-slate-50 border border-slate-200 hover:bg-slate-100"
                      title="Hamafa"
                    >
                      <Trash className="w-4 h-4 text-slate-700" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}

          {entries.length > 20 ? (
            <div className="mt-4 text-sm text-slate-500">
              Affichage limité aux 20 derniers. (On peut ajouter pagination/recherche.)
            </div>
          ) : null}
        </div>
      </div>

      {/* Modal form */}
      {showForm ? (
        <div className="fixed inset-0 bg-black/30 backdrop-blur-sm flex items-end md:items-center justify-center p-4 z-50">
          <div className="w-full max-w-xl bg-white rounded-3xl border border-slate-200 shadow-xl p-6">
            <div className="flex items-start justify-between gap-3 mb-4">
              <div>
                <div className="text-lg font-bold text-slate-900">
                  {editingEntry ? "Hanova fandraisana an-tsoratra" : "Fandraisana an-tsoratra vaovao"}
                </div>
                <div className="text-sm text-slate-600">Fenoy tsikelikely, dia tehirizo.</div>
              </div>
              <button
                onClick={() => setShowForm(false)}
                className="p-2 rounded-xl bg-slate-50 border border-slate-200 hover:bg-slate-100"
              >
                <X className="w-5 h-5 text-slate-700" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Daty</label>
                <input
                  type="date"
                  value={formData.observation_date}
                  onChange={(e) => setFormData({ ...formData, observation_date: e.target.value })}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-sky-500 focus:border-transparent"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  Karazana fandraisana an-tsoratra
                </label>
                <select
                  value={formData.observation_type}
                  onChange={(e) => setFormData({ ...formData, observation_type: e.target.value })}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-sky-500 focus:border-transparent"
                  required
                >
                  <option value="">Mifidiana...</option>
                  <option value="rain">Orana</option>
                  <option value="pest">Bibikely</option>
                  <option value="planting">Famboly</option>
                  <option value="treatment">Fitsaboana</option>
                  <option value="harvest">Fijinjana</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  Karazan-javamaniry (tsy tsy maintsy)
                </label>
                <input
                  value={formData.crop_type}
                  onChange={(e) => setFormData({ ...formData, crop_type: e.target.value })}
                  placeholder="Vary, mangahazo, katsaka..."
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-sky-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Fanamarihana</label>
                <textarea
                  value={formData.notes_mg}
                  onChange={(e) => setFormData({ ...formData, notes_mg: e.target.value })}
                  rows={4}
                  className="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-sky-500 focus:border-transparent resize-none"
                  placeholder="Soraty eto ny fandraisana an-tsoratra..."
                />
              </div>

              <button
                disabled={saving}
                className="w-full px-4 py-3 rounded-xl bg-sky-600 text-white hover:bg-sky-700 transition disabled:opacity-60"
              >
                {saving ? "Mahandrasa..." : "Hitahiry"}
              </button>
            </form>
          </div>
        </div>
      ) : null}
    </div>
  );
}
