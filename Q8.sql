use bc2402_gp;

show tables;

SET SESSION group_concat_max_len = 100000000000;

SELECT Airline, GROUP_CONCAT(Reviews SEPARATOR ' ') as Reviews
FROM airlines_reviews
WHERE Verified = 'TRUE' and Recommended = 'no'
GROUP BY Airline;

SELECT Airline, COUNT(Reviews) as NumOfReviews
FROM airlines_reviews
WHERE Verified = 'TRUE' and Recommended = 'no'
GROUP BY Airline;

SELECT TypeofTraveller, GROUP_CONCAT(Reviews SEPARATOR ' ') as Reviews
FROM airlines_reviews
WHERE Verified = 'TRUE' and Recommended = 'no'
GROUP BY TypeofTraveller;

SELECT TypeofTraveller, COUNT(Reviews) as NumOfReviews
FROM airlines_reviews
WHERE Verified = 'TRUE' and Recommended = 'no'
GROUP BY TypeofTraveller;