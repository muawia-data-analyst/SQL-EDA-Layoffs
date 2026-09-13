# Exploratory Data Analysis, Layoffs Dataset (SQL)

## Overview
An exploratory data analysis (EDA) project on global company layoffs data (2020–2023), using the cleaned dataset from my [Data Cleaning project](https://github.com/muawia-data-analyst/SQL-Data-Cleaning-Layoffs). This project digs into the data to uncover trends across companies, industries, countries, and time.

## Objective
To practice using SQL not just to clean data, but to actually explore it and pull out meaningful business insights the core job of a data analyst.

## Tools & Techniques Used
- **MySQL / MySQL Workbench**
- **Aggregate functions** — `SUM`, `MAX`, `MIN`
- **GROUP BY** across multiple dimensions
- **CTEs (Common Table Expressions)** — chained together for multi-step analysis
- **Window Functions** — `SUM() OVER()` for rolling totals, `DENSE_RANK() OVER(PARTITION BY ...)` for yearly rankings
- **Date functions** — `YEAR()`, `SUBSTRING()` for time-based grouping

## Analysis Performed

1. **Quick Overview** — found the largest single layoff event and identified companies that laid off 100% of their staff
2. **Top Companies** — ranked companies by total layoffs across all rounds, not just single events
3. **Location, Country & Industry Breakdown** — found which cities, countries, and industries were hit hardest
4. **Time Trends** — analyzed layoffs by year and month, then built a **rolling cumulative total** using a window function to show the compounding impact over time
5. **Top 3 Companies Per Year** — an advanced query using two chained CTEs and `DENSE_RANK()` to find the top 3 companies with the most layoffs in each individual year

## Key Insights
- Several well-funded companies (some having raised hundreds of millions) still laid off 100% of their staff, showing funding alone doesn't guarantee survival
- A small number of large companies account for a disproportionate share of total layoffs, rather than losses being evenly spread
- Layoffs were heavily concentrated in specific months rather than spread evenly across each year, pointing to clear "waves" of industry-wide cuts
- The Consumer and Retail industries were among the hardest hit, consistent with post-pandemic shifts in spending

## Files in This Repository
- `EDA_Project_Layoffs.sql` — full commented SQL script with 5 sections of analysis

## 🚀 How to Use
1. Run my [Data Cleaning project](https://github.com/muawia-data-analyst/SQL-Data-Cleaning-Layoffs) script first to produce the clean `layoffs_staging2` table
2. Run this script in MySQL Workbench to reproduce the full analysis

Part of my Data Analyst portfolio.
