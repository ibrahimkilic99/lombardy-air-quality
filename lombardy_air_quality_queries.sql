-- LOMBARDY AIR QUALITY ANALYSIS - SQL QUERIES
-- Database: lombardy_air_quality
-- Period: 2024-01-01 to 2026-05-06
-- Total Records: 5,871,737

-- ============================================================
-- 1. OVERVIEW STATISTICS
-- ============================================================

-- Total records check
SELECT COUNT(*) AS total_rows 
FROM air_quality;

-- Date range verification
SELECT 
    MIN(Data) AS start_date,
    MAX(Data) AS end_date,
    DATEDIFF(MAX(Data), MIN(Data)) AS days_covered
FROM air_quality;

-- ============================================================
-- 2. POLLUTANT ANALYSIS
-- ============================================================

-- Pollutant summary statistics
SELECT 
    Pollutant,
    COUNT(*) AS measurements,
    ROUND(AVG(Valore), 2) AS avg_value,
    ROUND(MIN(Valore), 2) AS min_value,
    ROUND(MAX(Valore), 2) AS max_value,
    ROUND(STDDEV(Valore), 2) AS std_dev
FROM air_quality
GROUP BY Pollutant
ORDER BY measurements DESC;

-- PM10 vs NO2 vs O3 year-over-year comparison
SELECT 
    Pollutant,
    Year,
    ROUND(AVG(Valore), 2) AS avg_value,
    COUNT(*) AS measurements
FROM air_quality
WHERE Pollutant IN ('PM10 (SM2005)', 'BIOSSIDO DI AZOTO', 'OZONO')
GROUP BY Pollutant, Year
ORDER BY Pollutant, Year;

-- ============================================================
-- 3. GEOGRAPHIC ANALYSIS
-- ============================================================

-- Province-level pollution ranking
SELECT 
    Provincia,
    COUNT(*) AS measurements,
    ROUND(AVG(Valore), 2) AS avg_pollution,
    ROUND(MAX(Valore), 2) AS max_pollution
FROM air_quality
GROUP BY Provincia
ORDER BY avg_pollution DESC;

-- Top 10 most polluted stations
SELECT 
    NomeStazione,
    Provincia,
    Comune,
    COUNT(*) AS measurements,
    ROUND(AVG(Valore), 2) AS avg_pollution,
    ROUND(MAX(Valore), 2) AS max_pollution
FROM air_quality
GROUP BY NomeStazione, Provincia, Comune
HAVING measurements > 1000
ORDER BY avg_pollution DESC
LIMIT 10;

-- Milano vs Other Provinces comparison
SELECT 
    CASE 
        WHEN Provincia = 'MI' THEN 'Milano'
        ELSE 'Other Provinces'
    END AS region,
    COUNT(*) AS measurements,
    ROUND(AVG(Valore), 2) AS avg_pollution,
    ROUND(AVG(CASE WHEN Pollutant = 'BIOSSIDO DI AZOTO' THEN Valore END), 2) AS avg_no2,
    ROUND(AVG(CASE WHEN Pollutant = 'PM10 (SM2005)' THEN Valore END), 2) AS avg_pm10
FROM air_quality
GROUP BY region;

-- Best and worst stations by province
WITH province_avg AS (
    SELECT 
        Provincia,
        NomeStazione,
        ROUND(AVG(Valore), 2) AS avg_pollution,
        COUNT(*) AS measurements,
        ROW_NUMBER() OVER (PARTITION BY Provincia ORDER BY AVG(Valore) DESC) AS worst_rank,
        ROW_NUMBER() OVER (PARTITION BY Provincia ORDER BY AVG(Valore) ASC) AS best_rank
    FROM air_quality
    GROUP BY Provincia, NomeStazione
    HAVING measurements > 5000
)
SELECT 
    Provincia,
    MAX(CASE WHEN worst_rank = 1 THEN NomeStazione END) AS worst_station,
    MAX(CASE WHEN worst_rank = 1 THEN avg_pollution END) AS worst_pollution,
    MAX(CASE WHEN best_rank = 1 THEN NomeStazione END) AS best_station,
    MAX(CASE WHEN best_rank = 1 THEN avg_pollution END) AS best_pollution
FROM province_avg
WHERE worst_rank = 1 OR best_rank = 1
GROUP BY Provincia
ORDER BY worst_pollution DESC;

-- ============================================================
-- 4. TEMPORAL ANALYSIS
-- ============================================================

-- Monthly pollution trends
SELECT 
    Year,
    Month,
    COUNT(*) AS measurements,
    ROUND(AVG(Valore), 2) AS avg_pollution
FROM air_quality
GROUP BY Year, Month
ORDER BY Year, Month;

-- Seasonal patterns
SELECT 
    Season,
    COUNT(*) AS measurements,
    ROUND(AVG(Valore), 2) AS avg_pollution,
    ROUND(MIN(Valore), 2) AS min_pollution,
    ROUND(MAX(Valore), 2) AS max_pollution
FROM air_quality
GROUP BY Season
ORDER BY avg_pollution DESC;

-- Hourly traffic patterns (NO2 vs O3)
SELECT 
    Hour,
    ROUND(AVG(CASE WHEN Pollutant = 'BIOSSIDO DI AZOTO' THEN Valore END), 2) AS avg_no2,
    ROUND(AVG(CASE WHEN Pollutant = 'OZONO' THEN Valore END), 2) AS avg_o3,
    COUNT(*) AS measurements
FROM air_quality
WHERE Pollutant IN ('BIOSSIDO DI AZOTO', 'OZONO')
GROUP BY Hour
ORDER BY Hour;

-- Day of week patterns
SELECT 
    DayOfWeek,
    ROUND(AVG(Valore), 2) AS avg_pollution,
    COUNT(*) AS measurements
FROM air_quality
GROUP BY DayOfWeek
ORDER BY FIELD(DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');