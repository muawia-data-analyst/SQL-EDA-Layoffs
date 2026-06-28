-- ============================================
-- EXPLORATORY DATA ANALYSIS (EDA) PROJECT
-- Dataset: World Layoffs (2020 - 2023)
-- Table: layoffs_staging2 (cleaned data)
-- Goal: Understand layoff trends across companies,
--       industries, countries and time periods
-- ============================================


-- ============================================
-- SECTION 1: QUICK OVERVIEW OF THE DATA
-- ============================================

-- First thing I want to know — what's the worst single layoff event
-- and did any company lay off literally 100% of their staff?
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Checking the range of percentage_laid_off
-- MIN tells us the smallest layoff %, MAX confirms 1 = 100% laid off
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Which companies went completely under? (100% of staff laid off)
-- percentage_laid_off = 1 means the entire company was let go
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- Same companies but sorted by how much funding they had raised
-- Interesting to see well-funded companies that still shut down completely
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- ============================================
-- SECTION 2: WHICH COMPANIES LAID OFF THE MOST?
-- ============================================

-- Top 5 single largest layoff events — biggest one-time cuts
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;

-- But a company could have done multiple rounds of layoffs
-- So let's look at TOTAL layoffs per company across all rounds
-- This gives a more accurate picture of who cut the most overall
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;


-- ============================================
-- SECTION 3: LAYOFFS BY LOCATION, COUNTRY, INDUSTRY
-- ============================================

-- Which cities / locations had the most layoffs?
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- Breaking it down by country — no surprise the US dominates
-- but good to see how other countries compare
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Which industries got hit the hardest?
-- Consumer and Retail at the top makes sense post-COVID boom bust
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Layoffs by company stage — which funding stage had the most cuts?
-- Post-IPO companies laid off the most — they had the most people to cut
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- ============================================
-- SECTION 4: LAYOFF TRENDS OVER TIME
-- ============================================

-- How did layoffs change year over year?
-- We can see which year was the worst
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

-- Monthly breakdown to see exactly when things got bad
-- SUBSTRING pulls out YYYY-MM from the date column
SELECT SUBSTRING(date, 1, 7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- Rolling total of layoffs month by month
-- This shows the CUMULATIVE damage over time — really powerful visual
-- Using a CTE to first get monthly totals, then a window function to roll them up
WITH DATE_CTE AS
(
    SELECT SUBSTRING(date, 1, 7) AS dates, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY dates
    ORDER BY dates ASC
)
SELECT dates,
       SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;


-- ============================================
-- SECTION 5: TOP COMPANIES PER YEAR (ADVANCED)
-- ============================================

-- Who were the top 3 companies laying off people in EACH year?
-- This uses two CTEs chained together + DENSE_RANK window function
-- CTE 1: total layoffs per company per year
-- CTE 2: rank companies within each year by layoff count
-- Final SELECT: filter to only top 3 per year

WITH Company_Year AS
(
    SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(date)
),
Company_Year_Rank AS
(
    SELECT company,
           years,
           total_laid_off,
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
