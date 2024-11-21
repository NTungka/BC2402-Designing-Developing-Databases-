use bc2402_gp
#Q1
SELECT DISTINCT category, COUNT(*)
FROM customer_support
GROUP BY category

SELECT *
FROM customer_support
WHERE category = ' city'

SET SQL_SAFE_UPDATES = 0; #Disables safe mode
UPDATE customer_support
SET category = UPPER(category)
UPDATE customer_support
SET category = REPLACE(category, ' ', '')

DELETE FROM customer_support
WHERE category NOT REGEXP '^[A-Z]+$'

SELECT count(DISTINCT category) FROM customer_support;

#Q2 Dataset mentioned Q & W as colloqial and offensive
SELECT category, SUM(flags LIKE '%Q%') as Colloqial, SUM(flags LIKE '%W%') as Offensive,
SUM(flags NOT LIKE '%Q%' AND flags NOT LIKE '%W%') as Others
FROM customer_support
GROUP BY category

#Q3 
SELECT Airline, COUNT(*)
FROM flight_delay
WHERE Cancelled = 1
GROUP BY Airline

UNION

SELECT Airline, COUNT(*)
FROM flight_delay
WHERE ArrDelay > 0 OR DepDelay > 0 
GROUP BY Airline

SELECT Airline, COUNT(*)
FROM flight_delay
WHERE ArrDelay = 0 OR DepDelay = 0 
GROUP BY Airline

#Q4 Only 2019? Note its day-month-year for this table
SELECT MonthlyDelays.Year, MonthlyDelays.Month, MonthlyDelays.Origin, MonthlyDelays.Dest, MonthlyDelays.DelayCount
FROM( SELECT YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS Year,
       MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS Month,
       COUNT(*) AS DelayCount,
       Origin,
       Dest
FROM flight_delay
WHERE ArrDelay > 0 OR DepDelay > 0 
GROUP BY Year, Month, Origin, Dest) as MonthlyDelays

JOIN ( SELECT Year, Month, Max(DelayCount) as MaxDelayCount
FROM (SELECT YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS Year,
       MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS Month,
       COUNT(*) AS DelayCount,
       Origin,
       Dest
FROM flight_delay
WHERE ArrDelay > 0 OR DepDelay > 0 
GROUP BY Year, Month, Origin, Dest) as DelaysByMonth
GROUP BY Year,Month) as MaxDelays

WHERE MonthlyDelays.Year = MaxDelays.Year 
AND MonthlyDelays.Month = MaxDelays.Month
AND MonthlyDelays.DelayCount = MaxDelays.MaxDelayCount

#Q5 This uses Month-Day-Year
SELECT YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')) AS Year,
    QUARTER(STR_TO_DATE(StockDate, '%m/%d/%Y')) AS Quarter,
    Avg(Price), MAX(High), MIN(Low)
FROM sia_stock
WHERE YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')) = 2023
GROUP BY Year,Quarter

WITH QuarterlyData AS (
    SELECT 
        YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')) AS Year,
        QUARTER(STR_TO_DATE(StockDate, '%m/%d/%Y')) AS Quarter,
        AVG(Price) AS AvgPrice
    FROM 
        sia_stock
    WHERE 
        YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')) = 2023
    GROUP BY 
        Year, Quarter
)

SELECT 
    q1.Year,
    q1.Quarter,
    q1.AvgPrice,
    ((q1.AvgPrice - q2.AvgPrice) / q2.AvgPrice) * 100 AS QoQ_AvgPrice_Change
FROM 
    QuarterlyData q1
LEFT JOIN 
    QuarterlyData q2 
    ON (q1.Year = q2.Year AND q1.Quarter = q2.Quarter + 1)
ORDER BY 
    q1.Year, q1.Quarter;





#Q10
SELECT Name, reviews,
CASE
WHEN reviews LIKE '%safety%' THEN 'Safety-related'
WHEN reviews LIKE '%turbulence%' THEN 'Turbulence-related'
WHEN reviews LIKE '%injury%' THEN 'Injury-related'
END as Category
FROM airlines_reviews
WHERE reviews LIKE '%safety%' OR reviews LIKE '%turbulence%'
OR reviews LIKE '%injury%' AND Recommended = 'no'
