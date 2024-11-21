(
SELECT 
    'Pre-COVID' AS Period,
    Count(Reviews) as NumOfReviews
FROM airlines_reviews
WHERE Airline = 'Singapore Airlines' AND MonthFlown < 'Mar-20'
GROUP BY Period
)
UNION ALL
(
SELECT 
    'During COVID' AS Period,
	Count(Reviews) as NumOfReviews
FROM airlines_reviews
WHERE Airline = 'Singapore Airlines' AND MonthFlown >= 'Mar-20' AND MonthFlown < 'May-23'
GROUP BY Period
)
UNION ALL
(
SELECT 
    'Post-COVID' AS Period,
    Count(Reviews) as NumOfReviews
FROM airlines_reviews
WHERE Airline = 'Singapore Airlines' AND MonthFlown >= 'May-23'
GROUP BY Period
);


