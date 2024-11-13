#Q1
SELECT DISTINCT category FROM customer_support

SET SQL_SAFE_UPDATES = 0; #Disables safe mode
UPDATE customer_support
SET category = UPPER(category)
UPDATE customer_support
SET category = REPLACE(category, ' ', '')
DELETE FROM customer_support
WHERE category NOT REGEXP '^[A-Z]+$'
SELECT count(DISTINCT category) FROM customer_support

#Q2 Dataset mentioned Q & W as colloqial and offensive
SELECT category, COUNT(flags LIKE '%Q%') as Colloqial, COUNT(flags LIKE '%W%') as Offensive
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
    Price, High, Low
FROM sia_stock
WHERE YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')) = 2023
ORDER BY Quarter

