-- Export each query result as CSV using BigQuery Save results > CSV.
-- These queries recreate the five independent aggregate Tableau sources.
-- 01_resumen_usuarios.csv
SELECT member_casual, COUNT(*) AS total_viajes,
 ROUND(AVG(ride_length_minutes),2) AS duracion_promedio,
 ROUND(APPROX_QUANTILES(ride_length_minutes,100)[OFFSET(50)],2) AS mediana_minutos
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY member_casual ORDER BY member_casual;

-- 02_analisis_mensual.csv
SELECT month,member_casual,COUNT(*) AS total_viajes,
 ROUND(AVG(ride_length_minutes),2) AS duracion_promedio
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY month,member_casual ORDER BY month,member_casual;

-- 03_analisis_semanal.csv
SELECT day_of_week,day_name,member_casual,COUNT(*) AS total_viajes,
 ROUND(AVG(ride_length_minutes),2) AS duracion_promedio
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY day_of_week,day_name,member_casual ORDER BY day_of_week,member_casual;

-- 04_analisis_horario.csv
SELECT member_casual,day_type,ride_hour,COUNT(*) AS total_viajes,
 ROUND(AVG(ride_length_minutes),2) AS duracion_promedio
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY member_casual,day_type,ride_hour ORDER BY member_casual,day_type,ride_hour;

-- 05_tipos_bicicleta.csv
SELECT member_casual,rideable_type,COUNT(*) AS total_viajes,
 ROUND(AVG(ride_length_minutes),2) AS duracion_promedio
FROM `cyclistic_2025.trips_portfolio_clean`
GROUP BY member_casual,rideable_type ORDER BY member_casual,rideable_type;
