<div align="center">

<img src="https://github.com/user-attachments/assets/a1167d91-00c5-49f5-9dce-430fa0d8045f" 
        alt="Picture" 
        style="display: block; margin: 0 auto" />
</div>

<div align="center">

**BC2402 Design & Dev Databases** \
**2024/25 Semester 1**

**Group Project Report**
<br />
<br />
**Team Members** \
**Nathaniel Tungka U2240162C** \
**Doo Hong Wen, Evan U2321097A** \
**Divyansh Jain, U2240118C** \
**Agarwal Dhrooooooov, U2223241C**
</div>


```sql
SELECT DISTINCT category
FROM customer_support; #Checks unique categories to see if cleaning is needed SELECT * FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$';

SET SQL_SAFE_UPDATES = 0; #Disables safe mode DELETE FROM customer_support WHERE category NOT REGEXP '^[A-Z]+$'; #Deletes problematic rows SET SQL_SAFE_UPDATES = 1; #Re-enable safe mode

SELECT COUNT(DISTINCT category) AS count FROM customer_support;
```
