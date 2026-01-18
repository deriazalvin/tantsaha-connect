import { AlertTriangle, Info } from 'lucide-react';

interface Props {
    alerts: any[];
    advices: any[];
    todayForecast: any | null;
}

function getSeverityStyle(level: 'danger' | 'warning' | 'info') {
    switch (level) {
        case 'danger':
            return { container: 'bg-red-100 text-red-900 border border-red-300', icon: 'text-red-700' };
        case 'warning':
            return { container: 'bg-yellow-100 text-yellow-900 border border-yellow-300', icon: 'text-yellow-700' };
        default:
            return { container: 'bg-blue-100 text-blue-900 border border-blue-300', icon: 'text-blue-700' };
    }
}

function detectAlert(alerts: any[], forecast: any) {
    if (alerts.length > 0) {
        return {
            level: alerts[0].severity || 'warning',
            message: alerts[0].message_mg || alerts[0].message,
        };
    }

    if (!forecast) return null;

    if (forecast.temp_max >= 35) return { level: 'danger', message: 'Hafanana mampidi-doza — arovy ny voly sy ny olona' };
    if (forecast.condition === 'Windy') return { level: 'warning', message: 'Rivotra mahery — mitandrema amin’ny fitaovana' };
    if (forecast.condition === 'Rainy') return { level: 'info', message: 'Orana andrasana — mety hanemotra asa eny an-tsaha' };

    return null;
}

function getContextAdvice(forecast: any) {
    if (!forecast) return null;
    if (forecast.condition === 'Rainy') return 'Tsy ilaina ny manondraka anio';
    if (forecast.temp_max >= 35) return 'Ataovy maraina na hariva ny asa eny an-tsaha';
    return null;
}

export default function WeatherAlertStrip({ alerts, advices, todayForecast }: Props) {
    const autoAlert = detectAlert(alerts, todayForecast);
    const autoAdvice = getContextAdvice(todayForecast);

    if (autoAlert) {
        const styles = getSeverityStyle(autoAlert.level);
        return (
            <div className={`flex items-center gap-3 px-4 py-2 rounded-lg ${styles.container}`}>
                <AlertTriangle className={`w-5 h-5 ${styles.icon}`} />
                <div className="text-sm font-medium">{autoAlert.message}</div>
            </div>
        );
    }

    if (autoAdvice || advices.length > 0) {
        return (
            <div className="flex items-center gap-3 bg-white/10 px-4 py-2 rounded-lg">
                <Info className="w-5 h-5 text-white" />
                <div className="text-sm">{autoAdvice || advices[0]?.title || advices[0]?.notes_mg}</div>
            </div>
        );
    }

    return <div className="text-sm text-green-100">Tsy misy fampitandremana na torohevitra amin’izao fotoana izao</div>;
}
