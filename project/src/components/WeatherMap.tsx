import { MapContainer, TileLayer, Marker, Popup, Circle } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

type WeatherMapProps = {
    coords: { lat: number; lon: number } | null;
    favorites?: { lat: number; lon: number; name: string }[];
};

const defaultIcon = L.icon({
    iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
    shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
});

export default function WeatherMap({ coords, favorites = [] }: WeatherMapProps) {
    if (!coords) return <div className="h-80 w-full">Position non disponible</div>;

    return (
        <MapContainer center={[coords.lat, coords.lon]} zoom={10} className="h-80 w-full">
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />

            {/* Position actuelle */}
            <Marker position={[coords.lat, coords.lon]} icon={defaultIcon}>
                <Popup>Vous êtes ici</Popup>
            </Marker>

            {/* Favoris */}
            {favorites.map((f, i) => (
                <Marker key={i} position={[f.lat, f.lon]} icon={defaultIcon}>
                    <Popup>{f.name}</Popup>
                </Marker>
            ))}

            {/* Radar météo simplifié (cercle) */}
            <Circle center={[coords.lat, coords.lon]} radius={20000} pathOptions={{ color: "blue", fillOpacity: 0.1 }} />
        </MapContainer>
    );
}
