// src/components/weather/WeatherCard.tsx
import React from 'react';
import {
    Cloud,
    CloudRain,
    Sun,
    CloudDrizzle,
    Wind,
    Zap,
} from 'lucide-react';
import type { Database } from '../../lib/database.types';

type WeatherForecast = Database['public']['Tables']['weather_forecasts']['Row'];

interface WeatherCardProps {
    forecast: WeatherForecast;
}

const conditionsMg: Record<string, string> = {
    Thunderstorm: 'Rivo-doza',
    Rainy: 'Orana',
    Sunny: 'Masoandro',
    Cloudy: 'Rahona',
    Overcast: 'Rahona',
    Windy: 'Rivotra',
    'Code 80': 'Tsy fantatra',
    'Code 96': 'Tsy fantatra',
};

const WeatherCard: React.FC<WeatherCardProps> = ({ forecast }) => {
    const date = new Date(forecast.forecast_date);
    const formattedDate = date.toLocaleDateString('mg-MG', {
        weekday: 'short',
        day: 'numeric',
        month: 'long',
        year: 'numeric',
    });

    const conditionMg = conditionsMg[forecast.condition] || forecast.condition;

    const getIcon = () => {
        switch (forecast.condition) {
            case 'Sunny':
            case 'Masoandro':
                return <Sun className="w-10 h-10 text-yellow-400" />;
            case 'Rainy':
            case 'Orana':
                return <CloudRain className="w-10 h-10 text-blue-400" />;
            case 'Cloudy':
            case 'Overcast':
            case 'Rahona':
                return <Cloud className="w-10 h-10 text-gray-400" />;
            case 'Windy':
            case 'Rivotra':
                return <Wind className="w-10 h-10 text-gray-500" />;
            case 'Thunderstorm':
            case 'Rivo-doza':
                return <Zap className="w-10 h-10 text-purple-500" />;
            default:
                return <CloudDrizzle className="w-10 h-10 text-gray-300" />;
        }
    };

    return (
        <div className="bg-white shadow-lg rounded-2xl p-4 flex flex-col items-center text-center hover:scale-105 transition-transform duration-300">
            <span className="text-sm text-gray-500">{formattedDate}</span>
            <div className="my-2">{getIcon()}</div>
            <div className="text-lg font-bold text-gray-800">
                {forecast.temp_min}° / {forecast.temp_max}°
            </div>
            <div className="text-sm text-gray-600 mt-1">
                Hamandoana: {forecast.humidity ?? 'Tsy misy'}%
            </div>
            <p className="mt-2 text-gray-700 font-medium">{conditionMg}</p>
        </div>
    );
};

export default WeatherCard;
