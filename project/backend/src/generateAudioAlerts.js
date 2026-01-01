// backend/src/generateAudioAlerts.js
import fs from 'fs';
import path from 'path';
import gTTS from 'gtts'; // npm i gtts

export function generateAudioAlert(forecast, regionName) {
  const dateStr = new Date(forecast.forecast_date).toLocaleDateString('mg-MG', {
    weekday: 'long', day: 'numeric', month: 'long', year: 'numeric',
  });

  let text = '';

  switch (forecast.condition) {
    case 'Thunderstorm':
    case 'Rainy':
    case 'Overcast':
      text = `Orana be ao ${regionName} amin'ny ${dateStr}. Mety hampisy rano be eny an-kampo.`;
      break;
    case 'Sunny':
      text = `Masoandro mafana ao ${regionName} amin'ny ${dateStr}. Ataovy maraina na hariva ny asa eny an-kampo.`;
      break;
    case 'Windy':
      text = `Rivotra mahery ao ${regionName} amin'ny ${dateStr}. Mitandrema amin'ny fitaovana eny an-kampo.`;
      break;
    default:
      text = `Toetr'andro tsy voafaritra ao ${regionName} amin'ny ${dateStr}.`;
  }

  const filename = path.join(process.cwd(), 'public', 'audio', 'alerts', `alert-${forecast.id}.mp3`);

  // créer dossier si non existant
  fs.mkdirSync(path.dirname(filename), { recursive: true });

  const gtts = new gTTS(text, 'mg'); // 'mg' = Malagasy
  gtts.save(filename, function(err) {
    if (err) throw err;
    console.log('Audio alert saved:', filename);
  });

  return `/audio/alerts/alert-${forecast.id}.mp3`;
}
