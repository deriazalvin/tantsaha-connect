-- Diagnostic and optional repair for regions -> weather mapping
-- Run these queries on your MySQL database (make a backup first).

-- 1) Overview counts
SELECT COUNT(*) AS total_forecasts FROM weather_forecasts;
SELECT COUNT(*) AS forecasts_with_region FROM weather_forecasts WHERE region_id IS NOT NULL;
SELECT COUNT(*) AS forecasts_without_region FROM weather_forecasts WHERE region_id IS NULL;

-- 2) Show counts per region name (join may show NULL for regionless rows)
SELECT COALESCE(r.name, 'NULL') AS region_name, COUNT(w.id) AS cnt
FROM weather_forecasts w
LEFT JOIN regions r ON w.region_id = r.id
GROUP BY r.name
ORDER BY cnt DESC;

-- 3) Sample rows without region_id
SELECT * FROM weather_forecasts WHERE region_id IS NULL LIMIT 50;

-- If you confirm you want to remap forecasts without region to a canonical region
-- (e.g. 'Antananarivo'), first create a backup table then run the update.

-- Backup (recommended)
CREATE TABLE IF NOT EXISTS backup_weather_forecasts AS SELECT * FROM weather_forecasts;

-- Map NULL region_id forecasts to Antananarivo (UNCOMMENT to run)
-- UPDATE weather_forecasts wf
-- JOIN regions r ON r.name = 'Antananarivo'
-- SET wf.region_id = r.id
-- WHERE wf.region_id IS NULL;

-- Alternatively map by old region names: if you still have old region rows, adapt the mapping below
-- UPDATE weather_forecasts wf
-- JOIN regions r_old ON wf.region_id = r_old.id
-- JOIN regions r_new ON r_new.name = 'Antananarivo'
-- SET wf.region_id = r_new.id
-- WHERE r_old.name IN ('Analamanga','Vakinankaratra');

-- After changes, re-run the per-region counts (query 2) to verify.
