CREATE OR REPLACE TABLE `cyclistic_2025.trips_analysis` AS

SELECT
  ride_id,
  rideable_type,

  started_at,
  ended_at,

  started_at_ts,
  ended_at_ts,

  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id,

  start_lat,
  start_lng,
  end_lat,
  end_lng,

  member_casual,

  -- Duración exacta en minutos
  TIMESTAMP_DIFF(
    ended_at_ts,
    started_at_ts,
    MICROSECOND
  ) / 60000000.0 AS ride_length_minutes,

  -- Hora
  EXTRACT(
    HOUR FROM started_at_ts
  ) AS ride_hour,

  -- Día de la semana
  EXTRACT(
    DAYOFWEEK FROM started_at_ts
  ) AS day_of_week,

  -- Nombre del día
  FORMAT_TIMESTAMP(
    '%A',
    started_at_ts
  ) AS day_name,

  -- Mes
  EXTRACT(
    MONTH FROM started_at_ts
  ) AS month,

  -- Año
  EXTRACT(
    YEAR FROM started_at_ts
  ) AS year,

  -- Tipo de día
  CASE
    WHEN EXTRACT(DAYOFWEEK FROM started_at_ts) IN (1, 7)
      THEN 'weekend'
    ELSE 'weekday'
  END AS day_type

FROM `cyclistic_2025.trips_clean`

WHERE started_at_ts IS NOT NULL
  AND ended_at_ts IS NOT NULL

  -- Excluir duraciones de 0 o negativas
  AND ended_at_ts > started_at_ts

  -- Excluir viajes de más de 24 horas
  AND TIMESTAMP_DIFF(
        ended_at_ts,
        started_at_ts,
        MICROSECOND
      ) <= 86400000000;