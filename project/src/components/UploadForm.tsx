import { useState } from "react";
import { X, Upload } from "lucide-react";
import { useAuth } from "../contexts/AuthContext";

const API_BASE = import.meta.env.VITE_API_URL ?? "http://localhost:4000";
const TOKEN_KEY = "tantsaha_token";

interface Props {
    onClose: () => void;
}

export default function UploadForm({ onClose }: Props) {
    const { updateProfile } = useAuth();
    const [file, setFile] = useState<File | null>(null);
    const [loading, setLoading] = useState(false);

    async function handleSubmit(e: React.FormEvent) {
        e.preventDefault();
        if (!file) return;

        const token = localStorage.getItem(TOKEN_KEY);
        if (!token) {
            alert("Non authentifié");
            return;
        }

        const formData = new FormData();
        formData.append("photo", file);

        setLoading(true);

        try {
            console.log("TOKEN:", token);
            const res = await fetch(`${API_BASE}/api/profile/photo`, {
                method: "POST",
                headers: {
                    Authorization: `Bearer ${token}`,
                },
                body: formData,
            });

            const data = await res.json();

            if (!res.ok) {
                throw new Error(data.error || "Erreur upload");
            }

            // 🔥 Mise à jour du profil global
            await updateProfile({
                profile_photo_url: data.profile_photo_url,
            });

            onClose();
        } catch (err: any) {
            alert(err.message || "Erreur upload");
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center z-50">
            <div className="bg-white rounded-3xl w-full max-w-sm p-6 shadow-xl mx-4">
                <div className="flex justify-between items-center mb-4">
                    <h2 className="text-lg font-bold text-slate-900">
                        Changer la photo
                    </h2>
                    <button onClick={onClose}>
                        <X className="w-5 h-5 text-slate-500" />
                    </button>
                </div>

                <form onSubmit={handleSubmit} className="space-y-4">
                    <label className="flex flex-col items-center justify-center border-2 border-dashed border-slate-300 rounded-2xl p-6 text-slate-600 cursor-pointer hover:border-sky-500 transition">
                        <Upload className="w-8 h-8 mb-2" />
                        <span className="text-sm">
                            {file ? file.name : "Choisir une photo"}
                        </span>
                        <input
                            type="file"
                            accept="image/*"
                            hidden
                            onChange={(e) => setFile(e.target.files?.[0] || null)}
                        />
                    </label>

                    <button
                        disabled={loading || !file}
                        className="w-full py-3 rounded-xl bg-sky-600 text-white font-semibold hover:bg-sky-700 disabled:opacity-50"
                    >
                        {loading ? "Envoi..." : "Enregistrer"}
                    </button>
                </form>
            </div>
        </div>
    );
}
