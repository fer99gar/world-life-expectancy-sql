-- =========================================
-- WORLD LIFE EXPECTANCY ANALYSIS
-- Author: Fernando Garcia
-- Description: Exploratory Data Analysis (EDA)
-- Dataset: world_life_expectancy
-- =========================================


-- =====================================================
-- 0. INITIAL DATA OVERVIEW
-- Objective: Understand dataset structure and contents
-- =====================================================
SELECT *
FROM world_life_expectancy;


-- =====================================================
-- 1. LIFE EXPECTANCY GROWTH BY COUNTRY
-- Objective: Measure how life expectancy has changed over time
-- =====================================================
SELECT 
    country,
    MIN(`Life expectancy`) AS min_life_expectancy,
    MAX(`Life expectancy`) AS max_life_expectancy,
    ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS life_expectancy_increase
FROM world_life_expectancy
GROUP BY country
HAVING min_life_expectancy > 0
   AND max_life_expectancy > 0
ORDER BY life_expectancy_increase ASC;


-- =====================================================
-- 2. GLOBAL LIFE EXPECTANCY TREND OVER TIME
-- Objective: Analyze average life expectancy per year
-- =====================================================
SELECT 
    year,
    ROUND(AVG(`Life expectancy`), 2) AS avg_life_expectancy
FROM world_life_expectancy
WHERE `Life expectancy` > 0
GROUP BY year
ORDER BY year;


-- =====================================================
-- 3. GDP VS LIFE EXPECTANCY
-- Objective: Explore relationship between economic wealth and longevity
-- =====================================================
SELECT 
    country,
    ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
    ROUND(AVG(GDP), 1) AS avg_gdp
FROM world_life_expectancy
GROUP BY country
HAVING avg_life_expectancy > 0
   AND avg_gdp > 0
ORDER BY avg_gdp DESC;


-- =====================================================
-- 4. HIGH VS LOW GDP COMPARISON
-- Objective: Compare life expectancy between high and low GDP groups
-- =====================================================
SELECT 
    SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS high_gdp_count,
    ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` END), 1) AS high_gdp_life_expectancy,
    
    SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) AS low_gdp_count,
    ROUND(AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` END), 1) AS low_gdp_life_expectancy
FROM world_life_expectancy;


-- =====================================================
-- 5. LIFE EXPECTANCY BY DEVELOPMENT STATUS
-- Objective: Compare developed vs developing countries
-- =====================================================
SELECT 
    status,
    COUNT(DISTINCT country) AS country_count,
    ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy
FROM world_life_expectancy
GROUP BY status;


-- =====================================================
-- 6. BMI VS LIFE EXPECTANCY
-- Objective: Analyze relationship between BMI and life expectancy
-- =====================================================
SELECT 
    country,
    ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
    ROUND(AVG(BMI), 1) AS avg_bmi
FROM world_life_expectancy
GROUP BY country
HAVING avg_life_expectancy > 0
   AND avg_bmi > 0
ORDER BY avg_bmi DESC;


-- =====================================================
-- 7. LOW BMI VS HIGH BMI (SORTED ASC)
-- Objective: Identify countries with lowest BMI values
-- =====================================================
SELECT 
    country,
    ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy,
    ROUND(AVG(BMI), 1) AS avg_bmi
FROM world_life_expectancy
GROUP BY country
HAVING avg_life_expectancy > 0
   AND avg_bmi > 0
ORDER BY avg_bmi ASC;


-- =====================================================
-- 8. ROLLING TOTAL OF ADULT MORTALITY
-- Objective: Track cumulative mortality trends over time per country
-- =====================================================
SELECT 
    country,
    year,
    `Life expectancy`,
    `Adult Mortality`,
    SUM(`Adult Mortality`) OVER (
        PARTITION BY country
        ORDER BY year
    ) AS rolling_mortality_total
FROM world_life_expectancy;