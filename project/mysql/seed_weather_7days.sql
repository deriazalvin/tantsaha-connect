-- Seed 7 days of sample weather forecasts for the six canonical regions
-- Run this on your MySQL server (backup recommended).

USE tantsaha_connect;

-- Insert 7-day forecasts for the canonical regions. Adjust temps/humidity/text as needed.
INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, CURDATE(), 18, 28, 70, 'Partly cloudy', 'partly-cloudy', 'Vinavina ohatra: tsy hisy orana lehibe anio.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 17, 27, 75, 'Rainy', 'rainy', 'Vinavina ohatra: mety hisy orana malemy rahampitso.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 19, 29, 65, 'Sunny', 'sunny', 'Vinavina ohatra: andro feno masoandro.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 18, 26, 68, 'Cloudy', 'cloudy', 'Vinavina ohatra: andro niovaova.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, DATE_ADD(CURDATE(), INTERVAL 4 DAY), 16, 24, 72, 'Rainy', 'rainy', 'Vinavina ohatra: mety hisy orana matetika.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 17, 25, 69, 'Partly cloudy', 'partly-cloudy', 'Vinavina ohatra: mitsingevana eo ambanin\'ny rahona.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

INSERT INTO weather_forecasts (id, region_id, forecast_date, temp_min, temp_max, humidity, `condition`, condition_icon, description_mg, created_at)
SELECT UUID(), r.id, DATE_ADD(CURDATE(), INTERVAL 6 DAY), 18, 27, 71, 'Cloudy', 'cloudy', 'Vinavina ohatra: andro somary maizina.', NOW()
FROM regions r WHERE r.name IN ('Antananarivo','Toliara','Fiananrantsoa','Diego','Mahajanga','Toamasina')
ON DUPLICATE KEY UPDATE temp_min = VALUES(temp_min), temp_max = VALUES(temp_max), humidity = VALUES(humidity), `condition` = VALUES(`condition`), condition_icon = VALUES(condition_icon), description_mg = VALUES(description_mg), created_at = VALUES(created_at);

-- Optional: insert a sample alert and advice for Antananarivo
INSERT INTO weather_alerts (id, region_id, alert_type, severity, title_mg, message_mg, recommendation_mg, alert_date, is_active, created_at)
SELECT UUID(), r.id, 'rain_flood', 'warning', 'Mety hisy orana mavesatra', 'Mety hisy rano be sy fitobiana ao amin\'ny tany ambany', 'Ataovy azo antoka ny fitaovana sy ny zava-dehibe', CURDATE(), 1, NOW()
FROM regions r WHERE r.name='Antananarivo' LIMIT 1
ON DUPLICATE KEY UPDATE is_active = VALUES(is_active), created_at = VALUES(created_at);

INSERT INTO agricultural_advices (id, region_id, crop_type, season, title_mg, content_mg, icon, created_at)
SELECT UUID(), r.id, 'Vary', 'Rains', 'Torohevitra fampitandremana', 'Raha maniry haniry aorian\'ny orana, diovy tsara ny tany', 'seedling', NOW()
FROM regions r WHERE r.name='Antananarivo' LIMIT 1
ON DUPLICATE KEY UPDATE created_at = VALUES(created_at);
