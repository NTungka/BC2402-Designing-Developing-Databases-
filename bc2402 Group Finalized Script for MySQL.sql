use bc2402_gp

#Q1 Nathaniel
#Gives all data
SELECT DISTINCT category, COUNT(*)
FROM customer_support
GROUP BY category

#Gives "wrong" data 
SELECT *
FROM customer_support
WHERE category NOT REGEXP '^[A-Z]+$'

#Updates database/datacleaning
SET SQL_SAFE_UPDATES = 0; #Disables safe mode
UPDATE customer_support
SET category = REPLACE(category, ' ', '')
DELETE FROM customer_support
WHERE category NOT REGEXP '^[A-Z]+$'

#Q2 Nathaniel
#Only category
SELECT category, SUM(flags LIKE '%Q%') as Colloqial, SUM(flags LIKE '%W%') as Offensive,
SUM(flags NOT LIKE '%Q%' AND flags NOT LIKE '%W%') as Others
FROM customer_support
GROUP BY category

#Include intent
SELECT intent, category, SUM(flags LIKE '%Q%') as Colloqial, SUM(flags LIKE '%W%') as Offensive,
SUM(flags NOT LIKE '%Q%' AND flags NOT LIKE '%W%') as Others
FROM customer_support
GROUP BY intent, category

#Q3 Dhruv/Nathaniel & Evan
#We can do two ways, either union, or case
#Case Example
SELECT airline, 
       SUM(CASE WHEN Cancelled = 1 THEN 1 ELSE 0 END) AS CancellationCount,
       SUM(CASE WHEN ArrDelay >0 OR DepDelay>0 THEN 1 ELSE 0 END) AS DelayCount
FROM flight_delay
GROUP BY airline;

#Union example
SELECT Airline, COUNT(*)
FROM flight_delay
WHERE Cancelled = 1
GROUP BY Airline
UNION
SELECT Airline, COUNT(*)
FROM flight_delay
WHERE ArrDelay > 0 OR DepDelay > 0 
GROUP BY Airline

#Checks if there are flights that are ontime
SELECT Airline, COUNT(*)
FROM flight_delay
WHERE ArrDelay = 0 OR DepDelay = 0 
GROUP BY Airline

#Q4 Evan (Better concating) /Nathaniel (Date clarity)

SELECT MonthlyDelays.Year, MonthlyDelays.Month, MonthlyDelays.Route, MonthlyDelays.DelayCount
FROM( SELECT YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS Year,
       MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS Month,
       COUNT(*) AS DelayCount,
       CONCAT(Origin, '->', Dest) AS Route
FROM flight_delay
WHERE ArrDelay > 0 OR DepDelay > 0 
GROUP BY Year, Month, Origin, Dest) as MonthlyDelays

JOIN ( SELECT Year, Month, Max(DelayCount) as MaxDelayCount
FROM (SELECT YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS Year,
       MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS Month,
       COUNT(*) AS DelayCount,
       CONCAT(Origin, '->', Dest) AS Route
FROM flight_delay
WHERE ArrDelay > 0 OR DepDelay > 0 
GROUP BY Year, Month, Origin, Dest) as DelaysByMonth
GROUP BY Year,Month) as MaxDelays

WHERE MonthlyDelays.Year = MaxDelays.Year 
AND MonthlyDelays.Month = MaxDelays.Month
AND MonthlyDelays.DelayCount = MaxDelays.MaxDelayCount

#Q5 Evan
WITH QuarterlyAverages AS (
    SELECT 
        YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')) AS Year,
        QUARTER(STR_TO_DATE(StockDate, '%m/%d/%Y')) AS Quarter,
        ROUND(AVG(High), 2) AS AvgHigh,
        ROUND(AVG(Low), 2) AS AvgLow,
        ROUND(AVG(Price), 2) AS AvgPrice
    FROM sia_stock
    GROUP BY YEAR(STR_TO_DATE(StockDate, '%m/%d/%Y')), QUARTER(STR_TO_DATE(StockDate, '%m/%d/%Y'))
), QuarterlyChanges AS (
    SELECT curQ.Year, curQ.Quarter, curQ.AvgHigh, curQ.AvgLow, curQ.AvgPrice,
        ROUND(CASE WHEN preQ.AvgHigh IS NOT NULL THEN ((curQ.AvgHigh - preQ.AvgHigh) / preQ.AvgHigh) * 100 ELSE NULL END, 2) AS HighChange,
        ROUND(CASE WHEN preQ.AvgLow IS NOT NULL THEN ((curQ.AvgLow - preQ.AvgLow) / preQ.AvgLow) * 100 ELSE NULL END, 2) AS LowChange,
        ROUND(CASE WHEN preQ.AvgPrice IS NOT NULL THEN ((curQ.AvgPrice - preQ.AvgPrice) / preQ.AvgPrice) * 100 ELSE NULL END, 2) AS PriceChange
    FROM QuarterlyAverages curQ
    LEFT JOIN QuarterlyAverages preQ 
    ON (curQ.Year = preQ.Year AND curQ.Quarter = preQ.Quarter + 1) OR (curQ.Year = preQ.Year + 1 AND curQ.Quarter = 1 AND preQ.Quarter = 4)
    WHERE curQ.Year = 2023
)
SELECT Year, Quarter, AvgHigh, HighChange AS `High%Change`, AvgLow, LowChange AS `Low%Change`, AvgPrice, PriceChange AS `Price%Change`
FROM QuarterlyChanges;

#Q6 Afeef
SELECT sales_channel,
       route,
       AVG(length_of_stay) / AVG(flight_hour) AS avg_stay_flight_ratio,
       AVG(wants_extra_baggage) / AVG(flight_hour) AS avg_baggage_flight_ratio,
       AVG(wants_preferred_seat) / AVG(flight_hour) AS avg_seat_flight_ratio,
       AVG(wants_in_flight_meals) / AVG(flight_hour) AS avg_meals_flight_ratio
FROM customer_booking
GROUP BY sales_channel, route;

#Q7 Dhruv
SELECT Airline, Class,
    CASE 
        WHEN MONTH(STR_TO_DATE(ReviewDate, '%d/%m/%Y')) BETWEEN 6 AND 9 THEN 'Seasonal'
        ELSE 'Non-Seasonal'
    END AS Period,
    AVG(SeatComfort) AS Avg_SeatComfort,
    AVG(FoodnBeverages) AS Avg_FoodnBeverages,
    AVG(InflightEntertainment) AS Avg_InflightEntertainment,
    AVG(ValueForMoney) AS Avg_ValueForMoney,
    AVG(OverallRating) AS Avg_OverallRating
FROM airlines_reviews
GROUP BY Airline, Class, Period
ORDER BY Airline, Class, Period;

#Q8
(
SELECT Airline, TypeofTraveller,'SeatComfort' AS Category, AVG(SeatComfort) AS AverageRating
FROM airlines_reviews GROUP BY Airline, TypeofTraveller
)
UNION ALL
(
SELECT Airline, TypeofTraveller, 'StaffService' AS Category, AVG(StaffService) AS AverageRating
FROM airlines_reviews GROUP BY Airline, TypeofTraveller
)
UNION ALL
(
SELECT Airline, TypeofTraveller, 'FoodnBeverages' AS Category, AVG(FoodnBeverages) AS AverageRating
FROM airlines_reviews GROUP BY Airline, TypeofTraveller
)
UNION ALL
(
SELECT Airline, TypeofTraveller, 'InflightEntertainment' AS Category, AVG(InflightEntertainment) AS AverageRating
FROM airlines_reviews GROUP BY Airline, TypeofTraveller
)
UNION ALL
(
SELECT Airline, TypeofTraveller, 'ValueForMoney' AS Category, AVG(ValueForMoney) AS AverageRating
FROM airlines_reviews GROUP BY Airline, TypeofTraveller
)
ORDER BY Airline, TypeofTraveller, AverageRating;

# Only per Airline
(SELECT Airline, 'SeatComfort' AS Category, AVG(SeatComfort) AS AverageRating FROM airlines_reviews GROUP BY Airline)
UNION ALL
(SELECT Airline, 'StaffService' AS Category, AVG(StaffService) AS AverageRating FROM airlines_reviews GROUP BY Airline)
UNION ALL
(SELECT Airline, 'FoodnBeverages' AS Category, AVG(FoodnBeverages) AS AverageRating FROM airlines_reviews GROUP BY Airline)
UNION ALL
(SELECT Airline, 'InflightEntertainment' AS Category, AVG(InflightEntertainment) AS AverageRating FROM airlines_reviews GROUP BY Airline)
UNION ALL
(SELECT Airline, 'ValueForMoney' AS Category, AVG(ValueForMoney) AS AverageRating FROM airlines_reviews GROUP BY Airline)
ORDER BY Airline, AverageRating;

#Only per type of traveller
(SELECT TypeofTraveller, 'SeatComfort' AS Category, AVG(SeatComfort) AS AverageRating FROM airlines_reviews GROUP BY TypeofTraveller)
UNION ALL
(SELECT TypeofTraveller, 'StaffService' AS Category, AVG(StaffService) AS AverageRating FROM airlines_reviews GROUP BY TypeofTraveller)
UNION ALL
(SELECT TypeofTraveller, 'FoodnBeverages' AS Category, AVG(FoodnBeverages) AS AverageRating FROM airlines_reviews GROUP BY TypeofTraveller)
UNION ALL
(SELECT TypeofTraveller, 'InflightEntertainment' AS Category, AVG(InflightEntertainment) AS AverageRating FROM airlines_reviews GROUP BY TypeofTraveller)
UNION ALL
(SELECT TypeofTraveller, 'ValueForMoney' AS Category, AVG(ValueForMoney) AS AverageRating FROM airlines_reviews GROUP BY TypeofTraveller)
ORDER BY TypeofTraveller, AverageRating;

# In General
(SELECT 'SeatComfort' AS Category, AVG(SeatComfort) AS AverageRating FROM airlines_reviews)
UNION ALL
(SELECT 'StaffService' AS Category, AVG(StaffService) AS AverageRating FROM airlines_reviews)
UNION ALL
(SELECT 'FoodnBeverages' AS Category, AVG(FoodnBeverages) AS AverageRating FROM airlines_reviews)
UNION ALL
(SELECT 'InflightEntertainment' AS Category, AVG(InflightEntertainment) AS AverageRating FROM airlines_reviews)
UNION ALL
(SELECT 'ValueForMoney' AS Category, AVG(ValueForMoney) AS AverageRating FROM airlines_reviews)
ORDER BY AverageRating;

#Food vs Beverage
(
    SELECT 
        'Food' AS Category,
        COUNT(*) AS MentionCount,
        SUM(FoodnBeverages < 3) AS Complaints,
        ROUND((SUM(FoodnBeverages < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%food%' 
        OR LOWER(Reviews) LIKE '%meal%' 
        OR LOWER(Reviews) LIKE '%meals%' 
        OR LOWER(Reviews) LIKE '%chicken%'
)
UNION ALL
(
    SELECT 
        'Beverage' AS Category,
        COUNT(*) AS MentionCount,
        SUM(FoodnBeverages < 3) AS Complaints,
        ROUND((SUM(FoodnBeverages < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%drink%' 
        OR LOWER(Reviews) LIKE '%drinks%' 
        OR LOWER(Reviews) LIKE '%water%' 
        OR LOWER(Reviews) LIKE '%wine%'
)
ORDER BY ComplaintPercentage DESC;

#Breakfast vs Lunch vs Dinner vs Snacks
(
    SELECT 
        'Breakfast' AS Meal,
        COUNT(*) AS MentionCount,
        SUM(FoodnBeverages < 3) AS Complaints,
        ROUND((SUM(FoodnBeverages < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%breakfast%'
)
UNION ALL
(
    SELECT 
        'Dinner' AS Meal,
        COUNT(*) AS MentionCount,
        SUM(FoodnBeverages < 3) AS Complaints,
        ROUND((SUM(FoodnBeverages < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%dinner%'
)
UNION ALL
(
    SELECT 
        'Snacks' AS Meal,
        COUNT(*) AS MentionCount,
        SUM(FoodnBeverages < 3) AS Complaints,
        ROUND((SUM(FoodnBeverages < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%snacks%'
)
UNION ALL
(
    SELECT 
        'Lunch' AS Meal,
        COUNT(*) AS MentionCount,
        SUM(FoodnBeverages < 3) AS Complaints,
        ROUND((SUM(FoodnBeverages < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%lunch%'
)
ORDER BY ComplaintPercentage DESC;

# Crew member qualities
(
    SELECT 
        'Friendly' AS Category,
        COUNT(*) AS MentionCount,
        SUM(StaffService < 3) AS Complaints,
        ROUND((SUM(StaffService < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%friendly%'
)
UNION ALL
(
    SELECT 
        'Helpful' AS Category,
        COUNT(*) AS MentionCount,
        SUM(StaffService < 3) AS Complaints,
        ROUND((SUM(StaffService < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%helpful%'
)
UNION ALL
(
    SELECT 
        'Care' AS Category,
        COUNT(*) AS MentionCount,
        SUM(StaffService < 3) AS Complaints,
        ROUND((SUM(StaffService < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%care%'
)
UNION ALL
(
    SELECT 
        'Attentive' AS Category,
        COUNT(*) AS MentionCount,
        SUM(StaffService < 3) AS Complaints,
        ROUND((SUM(StaffService < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%attentive%'
)
UNION ALL
(
    SELECT 
        'Professional' AS Category,
        COUNT(*) AS MentionCount,
        SUM(StaffService < 3) AS Complaints,
        ROUND((SUM(StaffService < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%professional%'
)
UNION ALL
(
    SELECT 
        'Polite' AS Category,
        COUNT(*) AS MentionCount,
        SUM(StaffService < 3) AS Complaints,
        ROUND((SUM(StaffService < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%polite%'
)
ORDER BY ComplaintPercentage DESC;

#Seat vs comfort vs space vs legroom
(
    SELECT 
        'Seat' AS Keyword,
        COUNT(*) AS MentionCount,
        SUM(SeatComfort < 3) AS Complaints,
        ROUND((SUM(SeatComfort < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%seat%'
)
UNION ALL
(
    SELECT 
        'Comfort' AS Keyword,
        COUNT(*) AS MentionCount,
        SUM(SeatComfort < 3) AS Complaints,
        ROUND((SUM(SeatComfort < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%comfort%'
		OR LOWER(Reviews) LIKE '%uncomfortable%'
)
UNION ALL
(
    SELECT 
        'Space' AS Keyword,
        COUNT(*) AS MentionCount,
        SUM(SeatComfort < 3) AS Complaints,
        ROUND((SUM(SeatComfort < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%space%' 
       OR LOWER(Reviews) LIKE '%spacious%'
)
UNION ALL
(
    SELECT 
        'Legroom' AS Keyword,
        COUNT(*) AS MentionCount,
        SUM(SeatComfort < 3) AS Complaints,
        ROUND((SUM(SeatComfort < 3) * 100.0) / COUNT(*), 2) AS ComplaintPercentage
    FROM airlines_reviews
    WHERE LOWER(Reviews) LIKE '%legroom%'
)
ORDER BY ComplaintPercentage DESC;

#Q9

#Avg General Ratings
(
SELECT 
    'Pre-COVID' AS Period,
    AVG(SeatComfort) AS AvgSeatComfort, 
    AVG(StaffService) AS AvgStaffService,
    AVG(FoodnBeverages) AS AvgFoodnBeverages,
    AVG(InflightEntertainment) AS AvgInflightEntertainment,
    AVG(ValueForMoney) AS AvgValueForMoney,
    AVG(OverallRating) AS AvgOverallRating
FROM airlines_reviews
WHERE Airline = 'Singapore Airlines' AND MonthFlown < 'Mar-20'
GROUP BY Period
)
UNION ALL
(
SELECT 
    'During COVID' AS Period,
    AVG(SeatComfort) AS AvgSeatComfort, 
    AVG(StaffService) AS AvgStaffService,
    AVG(FoodnBeverages) AS AvgFoodnBeverages,
    AVG(InflightEntertainment) AS AvgInflightEntertainment,
    AVG(ValueForMoney) AS AvgValueForMoney,
    AVG(OverallRating) AS AvgOverallRating
FROM airlines_reviews
WHERE Airline = 'Singapore Airlines' AND MonthFlown >= 'Mar-20' AND MonthFlown < 'May-23'
GROUP BY Period
)
UNION ALL
(
SELECT 
    'Post-COVID' AS Period,
    AVG(SeatComfort) AS AvgSeatComfort, 
    AVG(StaffService) AS AvgStaffService,
    AVG(FoodnBeverages) AS AvgFoodnBeverages,
    AVG(InflightEntertainment) AS AvgInflightEntertainment,
    AVG(ValueForMoney) AS AvgValueForMoney,
    AVG(OverallRating) AS AvgOverallRating
FROM airlines_reviews
WHERE Airline = 'Singapore Airlines' AND MonthFlown >= 'May-23'
GROUP BY Period
);

#Seperated by Types & Period
(
    SELECT
        CASE 
            WHEN MonthFlown < 'Mar-20' THEN 'Pre-COVID'
            WHEN MonthFlown >= 'May-23' THEN 'Post-COVID'
            ELSE 'During COVID'
        END AS Period,
        TypeofTraveller,
        'SeatComfort' AS ComplaintType,
        SUM(SeatComfort < 3) AS ComplaintCount,
        AVG(CASE WHEN SeatComfort < 3 THEN SeatComfort END) AS AvgComplaintScore,
        AVG(SeatComfort) AS AvgGeneralScore
    FROM airlines_reviews
    WHERE Airline = 'Singapore Airlines'
    GROUP BY Period, TypeofTraveller
)
UNION ALL
(
    SELECT
        CASE 
            WHEN MonthFlown < 'Mar-20' THEN 'Pre-COVID'
            WHEN MonthFlown >= 'May-23' THEN 'Post-COVID'
            ELSE 'During COVID'
        END AS Period,
        TypeofTraveller,
        'StaffService' AS ComplaintType,
        SUM(StaffService < 3) AS ComplaintCount,
        AVG(CASE WHEN StaffService < 3 THEN StaffService END) AS AvgComplaintScore,
        AVG(StaffService) AS AvgGeneralScore
    FROM airlines_reviews
    WHERE Airline = 'Singapore Airlines'
    GROUP BY Period, TypeofTraveller
)
UNION ALL
(
    SELECT
        CASE 
            WHEN MonthFlown < 'Mar-20' THEN 'Pre-COVID'
            WHEN MonthFlown >= 'May-23' THEN 'Post-COVID'
            ELSE 'During COVID'
        END AS Period,
        TypeofTraveller,
        'FoodnBeverages' AS ComplaintType,
        SUM(FoodnBeverages < 3) AS ComplaintCount,
        AVG(CASE WHEN FoodnBeverages < 3 THEN FoodnBeverages END) AS AvgComplaintScore,
        AVG(FoodnBeverages) AS AvgGeneralScore
    FROM airlines_reviews
    WHERE Airline = 'Singapore Airlines'
    GROUP BY Period, TypeofTraveller
)
UNION ALL
(
    SELECT
        CASE 
            WHEN MonthFlown < 'Mar-20' THEN 'Pre-COVID'
            WHEN MonthFlown >= 'May-23' THEN 'Post-COVID'
            ELSE 'During COVID'
        END AS Period,
        TypeofTraveller,
        'InflightEntertainment' AS ComplaintType,
        SUM(InflightEntertainment < 3) AS ComplaintCount,
        AVG(CASE WHEN InflightEntertainment < 3 THEN InflightEntertainment END) AS AvgComplaintScore,
        AVG(InflightEntertainment) AS AvgGeneralScore
    FROM airlines_reviews
    WHERE Airline = 'Singapore Airlines'
    GROUP BY Period, TypeofTraveller
)
UNION ALL
(
    SELECT
        CASE 
            WHEN MonthFlown < 'Mar-20' THEN 'Pre-COVID'
            WHEN MonthFlown >= 'May-23' THEN 'Post-COVID'
            ELSE 'During COVID'
        END AS Period,
        TypeofTraveller,
        'ValueForMoney' AS ComplaintType,
        SUM(ValueForMoney < 3) AS ComplaintCount,
        AVG(CASE WHEN ValueForMoney < 3 THEN ValueForMoney END) AS AvgComplaintScore,
        AVG(ValueForMoney) AS AvgGeneralScore
    FROM airlines_reviews
    WHERE Airline = 'Singapore Airlines'
    GROUP BY Period, TypeofTraveller
)
ORDER BY Period DESC, TypeofTraveller, AvgComplaintScore;

#Q10

#Example of Database Creation
CREATE DATABASE chatbot_POC
USE chatbot_POC

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY, -- Unique customer identifier
    name VARCHAR(100)                   -- Customer's name
)
CREATE TABLE customer_support (
    interaction_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique interaction ID
    customer_id VARCHAR(50),                       -- References customers table
    flags TEXT,
    instruction TEXT,
    category TEXT,
    intent TEXT,
    response TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) -- Foreign key to customers
);

CREATE TABLE airlines_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique review ID
    customer_id VARCHAR(50),                   -- References customers table
    ReviewDate TEXT,
    Airline TEXT,
    Verified TEXT,
    Reviews TEXT,
    TypeofTraveller TEXT,
    MonthFlown TEXT,
    Route TEXT,
    Class TEXT,
    SeatComfort INT,
    StaffService INT,
    FoodnBeverages INT,
    InflightEntertainment INT,
    ValueForMoney INT,
    OverallRating INT,
    Recommended TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) -- Foreign key to customers
);

CREATE TABLE keyword_dictionary (
    keyword_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique keyword ID
    keyword VARCHAR(255),                      -- The keyword or phrase
    category VARCHAR(100)                     -- The category (e.g., turbulence, delay)
);
CREATE TABLE keyword_customer_support (
    id INT AUTO_INCREMENT PRIMARY KEY,                -- Unique junction ID
    keyword_id INT,                                   -- References keyword_dictionary table
    interaction_id INT,                               -- References customer_support table
    FOREIGN KEY (keyword_id) REFERENCES keyword_dictionary(keyword_id),
    FOREIGN KEY (interaction_id) REFERENCES customer_support(interaction_id)
);

CREATE TABLE keyword_airlines_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,                -- Unique junction ID
    keyword_id INT,                                   -- References keyword_dictionary table
    review_id INT,                                    -- References airlines_reviews table
    FOREIGN KEY (keyword_id) REFERENCES keyword_dictionary(keyword_id),
    FOREIGN KEY (review_id) REFERENCES airlines_reviews(review_id)
);

INSERT INTO customers (customer_id, name)
VALUES
    ('C001', 'Krist Ang'),
    ('C002', 'S Dawson' );
    
INSERT INTO customer_support (customer_id, flags, instruction, category, intent, response)
VALUES
 ('C001', 'Z', 'injurde', 'FEEDBACK', 'complaint', 'We are sorry to hear...'),
 ('C002', 'Z', 'shakey', 'FEEDBACK', 'complaint', 'Thank you for contacting....');

INSERT INTO keyword_dictionary (keyword, category)
VALUES
    ('injured', 'INJURY'),
    ('shaky', 'TURBULENCE');

INSERT INTO keyword_customer_support (keyword_id, interaction_id)
VALUES
    (1, 1),
    (2, 2);

#Example of Data Processing
UPDATE customer_support
SET instruction = UPPER(instruction)

UPDATE customer_support
SET category = REPLACE(category, ':', '')
SET category = REPLACE(category, ',', '')
SET category = REPLACE(category, '.', '')

#Function of Levnshien distance from online
DELIMITER $$
DROP FUNCTION IF EXISTS LEVENSHTEIN $$
CREATE FUNCTION LEVENSHTEIN(s1 VARCHAR(255) CHARACTER SET utf8, s2 VARCHAR(255) CHARACTER SET utf8)
  RETURNS INT
  DETERMINISTIC
  BEGIN
    DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT;
    DECLARE s1_char CHAR CHARACTER SET utf8;
    -- max strlen=255 for this function
    DECLARE cv0, cv1 VARBINARY(256);

    SET s1_len = CHAR_LENGTH(s1),
        s2_len = CHAR_LENGTH(s2),
        cv1 = 0x00,
        j = 1,
        i = 1,
        c = 0;

    IF (s1 = s2) THEN
      RETURN (0);
    ELSEIF (s1_len = 0) THEN
      RETURN (s2_len);
    ELSEIF (s2_len = 0) THEN
      RETURN (s1_len);
    END IF;

    WHILE (j <= s2_len) DO
      SET cv1 = CONCAT(cv1, CHAR(j)),
          j = j + 1;
    END WHILE;

    WHILE (i <= s1_len) DO
      SET s1_char = SUBSTRING(s1, i, 1),
          c = i,
          cv0 = CHAR(i),
          j = 1;

      WHILE (j <= s2_len) DO
        SET c = c + 1,
            cost = IF(s1_char = SUBSTRING(s2, j, 1), 0, 1);

        SET c_temp = ORD(SUBSTRING(cv1, j, 1)) + cost;
        IF (c > c_temp) THEN
          SET c = c_temp;
        END IF;

        SET c_temp = ORD(SUBSTRING(cv1, j+1, 1)) + 1;
        IF (c > c_temp) THEN
          SET c = c_temp;
        END IF;

        SET cv0 = CONCAT(cv0, CHAR(c)),
            j = j + 1;
      END WHILE;

      SET cv1 = cv0,
          i = i + 1;
    END WHILE;

    RETURN (c);
  END $$

DELIMITER ;

#Feature Extraction
SELECT cs.interaction_id, cs.instruction, kd.keyword,
SOUNDEX(cs.instruction) as CustomerPhnoetic, SOUNDEX(kd.keyword) KeywordPhnoetic,
LEVENSHTEIN(cs.instruction, kd.keyword) as LEVENSHTEIN_Distance, kd.category as CIRCUMSTANCE
FROM customer_support cs
JOIN keyword_dictionary kd
ON SOUNDEX(cs.instruction) = SOUNDEX(kd.keyword)
OR LEVENSHTEIN(cs.instruction, kd.keyword) <= 2;

use bc2402_gp
SELECT Name, reviews,
CASE
WHEN reviews LIKE '%safety%' THEN 'Safety-related'
WHEN reviews LIKE '%turbulence%' THEN 'Turbulence-related'
WHEN reviews LIKE '%injury%' THEN 'Injury-related'
ELSE 'Others'
END as Category
FROM airlines_reviews #Can be changes to customer_support 
WHERE Recommended = 'no'