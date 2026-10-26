CREATE OR REPLACE TABLE
  `cyclistic_2025.trips_final` AS

SELECT *
FROM `cyclistic_2025.trips_analysis`

WHERE ride_length_minutes >= 1.0 / 60
  AND ride_length_minutes <= 1440;