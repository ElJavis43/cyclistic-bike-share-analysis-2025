-- Run after 01_data_cleaning.sql
SELECT COUNT(*) AS total_rides, COUNT(DISTINCT ride_id) AS unique_ride_ids,
  ROUND(AVG(ride_length_minutes),2) AS avg_duration_minutes,
  MIN(ride_length_minutes) AS min_duration_minutes,
  MAX(ride_length_minutes) AS max_duration_minutes,
  COUNTIF(ride_length_minutes < 1.0/60 OR ride_length_minutes > 1440) AS invalid_duration,
  COUNTIF(year != 2025) AS invalid_year
FROM `cyclistic_2025.trips_portfolio_clean`;

-- Expected: 5,545,493 rides, 5,545,493 distinct IDs, avg 14.53 min,
-- zero invalid duration/year.
-- Optional comparison, only if original final table remains:
SELECT
  COUNTIF(ABS(a.ride_length_minutes-b.ride_length_minutes)>0.000001) AS different_duration,
  COUNTIF(a.ride_hour != b.ride_hour) AS different_hour,
  COUNTIF(a.day_of_week != b.day_of_week) AS different_weekday,
  COUNTIF(a.month != b.month) AS different_month,
  COUNTIF(a.day_type != b.day_type) AS different_day_type
FROM `cyclistic_2025.trips_portfolio_clean` a
JOIN `cyclistic_2025.trips_final_corrected` b USING (ride_id);
