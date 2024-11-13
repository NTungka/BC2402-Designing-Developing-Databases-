```sql
SELECT DISTINCT category
FROM customer_support; #Checks unique categories to see if cleaning is needed SELECT * FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$';

SET SQL_SAFE_UPDATES = 0; #Disables safe mode DELETE FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$'; #Deletes problematic rows SET SQL_SAFE_UPDATES = 1; #Re-enable safe mode

SELECT COUNT(DISTINCT category) AS count FROM customer_support;
```
