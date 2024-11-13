use bc2402_gp;

show tables;

CREATE TABLE customer_support_keywords (
    id INT AUTO_INCREMENT PRIMARY KEY,
    keyword VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50),
    intent VARCHAR(50),
    flag VARCHAR(50)
);


-- ("ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION")

INSERT INTO customer_support_keywords (keyword, category)
VALUES
	("cancellation", "CANCEL"),
    ("canceling", "CANCEL"),
    ("Customer Support", "CONTACT");

UPDATE customer_support
SET response = CONCAT(flags, instruction, category, intent, response)
WHERE category NOT IN ("ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION");

UPDATE customer_support t
JOIN keywords k ON t.text_column LIKE CONCAT('%', k.keyword, '%')
SET t.value_column = k.value;

select *
from customer_support;

select CONCAT(flags, instruction, category, intent, response) as response
from customer_support
where category not in ("ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION");

select flags, instruction, category, intent, CONCAT(flags, instruction, category, intent, response) as response
from customer_support
where category not in ("ACCOUNT", "CANCEL", "CONTACT", "DELIVERY", "FEEDBACK", "INVOICE", "ORDER", "PAYMENT", "REFUND", "SHIPPING", "SUBSCRIPTION");
-- INTO OUTFILE '/Users/divyanshjain/Desktop/Year 3/BC2402/Final Project/customer_support_unstructured.csv'
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n';