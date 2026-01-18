export function getWeatherImage(
    condition: string,
    date: Date = new Date()
): string {
    const folderMap: Record<string, string> = {
        Sunny: "sunny",
        Clear: "sunny",
        Rain: "rainy",
        Rainy: "rainy",
        Thunderstorm: "storm",
        Storm: "storm",
        Cloudy: "cloudy",
        Overcast: "overcast",
    };

    const folder = folderMap[condition] || "cloudy";

    const h = date.getHours();
    let slot = "day";

    if (h >= 5 && h < 11) slot = "morning";
    else if (h >= 11 && h < 17) slot = "day";
    else if (h >= 17 && h < 21) slot = "evening";
    else slot = "night";

    try {
        return new URL(
            `../assets/weather/${folder}/${slot}.jpg`,
            import.meta.url
        ).href;
    } catch {
        // sécurité ultime → jamais page blanche
        return new URL(
            `../assets/weather/cloudy/day.jpg`,
            import.meta.url
        ).href;
    }
}
