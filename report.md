<img style="display: block; margin-left: auto; margin-right: auto; width: 50%"> 
<p style="text-align: center;">
![NTU logo](https://github.com/user-attachments/assets/a1167d91-00c5-49f5-9dce-430fa0d8045f)
</p>
```sql
SELECT DISTINCT category
FROM customer_support; #Checks unique categories to see if cleaning is needed SELECT * FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$';

SET SQL_SAFE_UPDATES = 0; #Disables safe mode DELETE FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$'; #Deletes problematic rows SET SQL_SAFE_UPDATES = 1; #Re-enable safe mode

SELECT COUNT(DISTINCT category) AS count FROM customer_support;
```
