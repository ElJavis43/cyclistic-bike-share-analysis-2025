-- BigQuery Standard SQL | Cyclistic/Divvy 2025
-- Prerequisite: cyclistic_2025.trips_raw loaded from 12 monthly CSVs.
-- Chicago local timestamps have no UTC offset; DST fall-back ambiguity remains.
CREATE OR REPLACE TABLE `cyclistic_2025.trips_portfolio_clean` AS
WITH fechas AS (
  SELECT *,
    TIMESTAMP(SAFE_CAST(started_at AS DATETIME), 'America/Chicago') AS started_at_ts,
    TIMESTAMP(SAFE_CAST(ended_at AS DATETIME), 'America/Chicago') AS ended_at_ts
  FROM `cyclistic_2025.trips_raw`
), duraciones AS (
  SELECT *, TIMESTAMP_DIFF(ended_at_ts, started_at_ts, MICROSECOND) / 60000000.0 AS ride_length_minutes
  FROM fechas
), variables AS (
  SELECT *,
    EXTRACT(HOUR FROM DATETIME(started_at_ts, 'America/Chicago')) AS ride_hour,
    EXTRACT(DAYOFWEEK FROM DATETIME(started_at_ts, 'America/Chicago')) AS day_of_week,
    FORMAT_TIMESTAMP('%A', started_at_ts, 'America/Chicago') AS day_name,
    EXTRACT(MONTH FROM DATETIME(started_at_ts, 'America/Chicago')) AS month,
    EXTRACT(YEAR FROM DATETIME(started_at_ts, 'America/Chicago')) AS year,
    CASE WHEN EXTRACT(DAYOFWEEK FROM DATETIME(started_at_ts, 'America/Chicago')) IN (1,7)
      THEN 'weekend' ELSE 'weekday' END AS day_type
  FROM duraciones
)
SELECT * FROM variables
WHERE ride_length_minutes >= 1.0 / 60
  AND ride_length_minutes <= 1440
  AND DATETIME(started_at_ts, 'America/Chicago') >= DATETIME '2025-01-01'
  AND DATETIME(started_at_ts, 'America/Chicago') < DATETIME '2026-01-01';
