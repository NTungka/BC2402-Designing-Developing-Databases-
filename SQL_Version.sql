use bc2402_gp

#Q1
SELECT DISTINCT category FROM customer_support
SELECT * FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$';
SELECT * FROM customer_support WHERE category REGEXP '^[A-Z]+$';
SELECT count(DISTINCT category) FROM customer_support