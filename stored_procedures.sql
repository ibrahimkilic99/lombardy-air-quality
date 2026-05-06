-- LOMBARDY AIR QUALITY - STORED PROCEDURES
-- Reusable functions for common analysis tasks

USE lombardy_air_quality;

DELIMITER //

-- ============================================================
-- 1. Get pollution data for specific province and date range
-- ============================================================

DROP PROCEDURE IF EXISTS get_province_pollution//

CREATE PROCEDURE get_province_pollution(
    IN province_name VARCHAR(50),
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        Data,
        NomeStazione,
        Pollutant,
        Valore,
        Season
    FROM air_quality
    WHERE Provincia = province_name
      AND DATE(Data) BETWEEN start_date AND end_date
    ORDER BY Data;
END//

-- ============================================================
-- 2. Get top N most polluted stations
-- ============================================================

DROP PROCEDURE IF EXISTS get_top_polluted_stations//

CREATE PROCEDURE get_top_polluted_stations(
    IN top_n INT,
    IN min_measurements INT
)
BEGIN
    SELECT 
        NomeStazione,
        Provincia,
        Comune,
        COUNT(*) AS measurements,
        ROUND(AVG(Valore), 2) AS avg_pollution,
        ROUND(MAX(Valore), 2) AS max_pollution
    FROM air_quality
    GROUP BY NomeStazione, Provincia, Comune
    HAVING measurements >= min_measurements
    ORDER BY avg_pollution DESC
    LIMIT top_n;
END//

-- ============================================================
-- 3. Get pollution statistics for specific pollutant
-- ============================================================

DROP PROCEDURE IF EXISTS get_pollutant_stats//

CREATE PROCEDURE get_pollutant_stats(
    IN pollutant_name VARCHAR(100)
)
BEGIN
    SELECT 
        Provincia,
        Year,
        COUNT(*) AS measurements,
        ROUND(AVG(Valore), 2) AS avg_value,
        ROUND(MIN(Valore), 2) AS min_value,
        ROUND(MAX(Valore), 2) AS max_value
    FROM air_quality
    WHERE Pollutant = pollutant_name
    GROUP BY Provincia, Year
    ORDER BY Provincia, Year;
END//

-- ============================================================
-- 4. Compare two provinces
-- ============================================================

DROP PROCEDURE IF EXISTS compare_provinces//

CREATE PROCEDURE compare_provinces(
    IN province1 VARCHAR(50),
    IN province2 VARCHAR(50)
)
BEGIN
    SELECT 
        Provincia,
        COUNT(*) AS measurements,
        ROUND(AVG(Valore), 2) AS avg_pollution,
        ROUND(AVG(CASE WHEN Pollutant = 'BIOSSIDO DI AZOTO' THEN Valore END), 2) AS avg_no2,
        ROUND(AVG(CASE WHEN Pollutant = 'OZONO' THEN Valore END), 2) AS avg_o3,
        ROUND(AVG(CASE WHEN Pollutant = 'PM10 (SM2005)' THEN Valore END), 2) AS avg_pm10
    FROM air_quality
    WHERE Provincia IN (province1, province2)
    GROUP BY Provincia;
END//

-- ============================================================
-- 5. Get seasonal comparison for specific year
-- ============================================================

DROP PROCEDURE IF EXISTS get_seasonal_comparison//

CREATE PROCEDURE get_seasonal_comparison(
    IN target_year INT
)
BEGIN
    SELECT 
        Season,
        COUNT(*) AS measurements,
        ROUND(AVG(Valore), 2) AS avg_pollution,
        ROUND(AVG(CASE WHEN Pollutant = 'BIOSSIDO DI AZOTO' THEN Valore END), 2) AS avg_no2,
        ROUND(AVG(CASE WHEN Pollutant = 'OZONO' THEN Valore END), 2) AS avg_o3
    FROM air_quality
    WHERE Year = target_year
    GROUP BY Season
    ORDER BY FIELD(Season, 'Spring', 'Summer', 'Fall', 'Winter');
END//

DELIMITER ;

-- ============================================================
-- USAGE EXAMPLES
-- ============================================================

-- Example 1: Get Milano pollution data for January 2024
-- CALL get_province_pollution('MI', '2024-01-01', '2024-01-31');

-- Example 2: Get top 5 most polluted stations (min 10000 measurements)
-- CALL get_top_polluted_stations(5, 10000);

-- Example 3: Get NO2 statistics by province and year
-- CALL get_pollutant_stats('BIOSSIDO DI AZOTO');

-- Example 4: Compare Milano vs Bergamo
-- CALL compare_provinces('MI', 'BG');

-- Example 5: Get seasonal comparison for 2024
-- CALL get_seasonal_comparison(2024);