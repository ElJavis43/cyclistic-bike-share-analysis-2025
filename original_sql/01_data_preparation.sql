CREATE OR REPLACE TABLE `cyclistic_2025.trips_clean` AS

SELECT
  *,
  SAFE_CAST(started_at AS TIMESTAMP) AS started_at_ts,
  SAFE_CAST(ended_at AS TIMESTAMP) AS ended_at_ts
FROM `cyclistic_2025.trips_clean`;




