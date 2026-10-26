-- All queries use the validated portfolio table; run each SELECT independently.
-- 1. Rider segment summary
SELECT member_casual, COUNT(*) AS total_rides,
  ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS pct_of_all_rides,
  ROUND(AVG(ride_length_minutes),2) AS avg_minutes,
  ROUND(APPROX_QUANTILES(ride_length_minutes,100)[OFFSET(50)],2) AS approximate_median_minutes,
  COUNTIF(day_type='weekend') AS weekend_rides,
  ROUND(100*SAFE_DIVIDE(COUNTIF(day_type='weekend'),COUNT(*)),2) AS pct_weekend
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY member_casual ORDER BY member_casual;

-- 2. Monthly seasonality
SELECT month, member_casual, COUNT(*) AS total_rides,
  ROUND(AVG(ride_length_minutes),2) AS avg_minutes
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY month,member_casual ORDER BY month,member_casual;

-- 3. Day-of-week patterns (BigQuery Sunday=1)
SELECT day_of_week, day_name, member_casual, COUNT(*) AS total_rides,
  ROUND(AVG(ride_length_minutes),2) AS avg_minutes
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY day_of_week,day_name,member_casual ORDER BY day_of_week,member_casual;

-- 4. Hour and weekday/weekend behavior
SELECT member_casual, day_type, ride_hour, COUNT(*) AS total_rides,
  ROUND(AVG(ride_length_minutes),2) AS avg_minutes
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY member_casual,day_type,ride_hour ORDER BY member_casual,day_type,ride_hour;

-- 5. Bicycle type preference
SELECT member_casual, rideable_type, COUNT(*) AS total_rides,
  ROUND(AVG(ride_length_minutes),2) AS avg_minutes
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY member_casual,rideable_type ORDER BY member_casual,rideable_type;
