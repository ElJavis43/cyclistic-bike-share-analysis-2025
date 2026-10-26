CREATE OR REPLACE TABLE
  `cyclistic_2025.trips_tableau` AS

SELECT
  ride_id,
  member_casual,
  rideable_type,

  -- Fechas locales de Chicago
  DATETIME(
    started_at_ts,
    'America/Chicago'
  ) AS started_at_local,

  DATETIME(
    ended_at_ts,
    'America/Chicago'
  ) AS ended_at_local,

  -- Duración
  ride_length_minutes,

  -- Variables temporales
  ride_hour,
  day_of_week,
  day_name,
  day_type,
  month,
  year,

  -- Estaciones
  start_station_name,
  end_station_name,

  -- Coordenadas numéricas
  SAFE_CAST(start_lat AS FLOAT64) AS start_lat,
  SAFE_CAST(start_lng AS FLOAT64) AS start_lng,
  SAFE_CAST(end_lat AS FLOAT64) AS end_lat,
  SAFE_CAST(end_lng AS FLOAT64) AS end_lng

FROM `cyclistic_2025.trips_final_corrected`;