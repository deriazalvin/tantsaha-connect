import { Cloud } from 'lucide-react';

export default function WeatherLoading() {
    return (
        <div className="min-h-screen flex items-center justify-center gap-4 bg-gradient-to-br from-green-50 to-blue-50">
            <Cloud className="w-16 h-16 text-green-500 animate-pulse" />
            <Cloud className="w-16 h-16 text-green-400 animate-pulse delay-150" />
        </div>
    );
}
