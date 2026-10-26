CREATE OR REPLACE TABLE
  `cyclistic_2025.trips_final_corrected` AS

WITH fechas_corregidas AS (
  SELECT
    * EXCEPT (
      started_at_ts,
      ended_at_ts,
      ride_length_minutes,
      ride_hour,
      day_of_week,
      day_name,
      month,
      year,
      day_type
    ),

    TIMESTAMP(
      SAFE_CAST(started_at AS DATETIME),
      'America/Chicago'
    ) AS started_at_ts,

    TIMESTAMP(
      SAFE_CAST(ended_at AS DATETIME),
      'America/Chicago'
    ) AS ended_at_ts

  FROM `cyclistic_2025.trips_final`
),

duraciones AS (
  SELECT
    *,

    TIMESTAMP_DIFF(
      ended_at_ts,
      started_at_ts,
      MICROSECOND
    ) / 60000000.0 AS ride_length_minutes,

    EXTRACT(
      HOUR FROM DATETIME(started_at_ts, 'America/Chicago')
    ) AS ride_hour,

    EXTRACT(
      DAYOFWEEK FROM DATETIME(started_at_ts, 'America/Chicago')
    ) AS day_of_week,

    FORMAT_TIMESTAMP(
      '%A',
      started_at_ts,
      'America/Chicago'
    ) AS day_name,

    EXTRACT(
      MONTH FROM DATETIME(started_at_ts, 'America/Chicago')
    ) AS month,

    EXTRACT(
      YEAR FROM DATETIME(started_at_ts, 'America/Chicago')
    ) AS year,

    CASE
      WHEN EXTRACT(
        DAYOFWEEK FROM DATETIME(started_at_ts, 'America/Chicago')
      ) IN (1, 7)
      THEN 'weekend'
      ELSE 'weekday'
    END AS day_type

  FROM fechas_corregidas
)

SELECT *
FROM duraciones

WHERE
  ride_length_minutes >= 1.0 / 60
  AND ride_length_minutes <= 1440
  AND DATETIME(started_at_ts, 'America/Chicago')
      >= DATETIME '2025-01-01 00:00:00'
  AND DATETIME(started_at_ts, 'America/Chicago')
      < DATETIME '2026-01-01 00:00:00';