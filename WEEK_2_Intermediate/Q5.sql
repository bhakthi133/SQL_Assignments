/*
Q5 Topic: Star Schema, Snowflake Schema & SCD Type 2 

Designing a data warehouse for the e-commerce platform: 
(a) Design a star schema: name fact table and at least 3 dimension tables. List columns with PKs and FKs. Explain your choices. 
(b) CREATE TABLE for dim_customer with SCD Type 2 columns: 
customer_key, customer_id, name, email, city, effective_from, effective_to (nullable), is_current. 
(c) SQL to handle customer changing city 'Delhi' to 'Pune': UPDATE to expire old record, INSERT new version with is_current = true. 
(d) Explain how snowflake schema differs from star schema. When would you choose snowflake? Give one concrete trade-off. 
(e) Predict the result: -- dim_customer: (key=1,cust_id=101,city='Delhi',is_current=TRUE) UPDATE dim_customer SET effective_to='2024-06-01', is_current=FALSE WHERE customer_key=1; INSERT INTO dim_customer VALUES (2,101,'Priya','p@x.com','Pune','2024-06-01',NULL,TRUE); SELECT customer_key,city,is_current FROM dim_customer WHERE customer_id=101 ORDER BY customer_key; 
*/

--(a) 
/*
star schema - one fact table with multiple dimension table 

original tables :
customers: (customer_id(pk), customer_name)
orders: (order_id(PK), customer_id(FK), total_amount, order_date)
products: (product_id(PK), product_name, order_id(FK), customer_id(FK), unit_price, quantity)
stores: (store_id(PK), order_id(FK), store_name)

Fact table :
(sales_id (PK), customer_id(FK), order_id(FK), product_id(FK), store_id(FK), unit_price, quantity, total_amount)

Dimension tables :
dim_customers: (customer_id(pk), customer_name)
dim_orders: (order_id(PK), order_date)
dim_products: (product_id(PK), product_name)
dim_stores: (store_id(PK), store_name)

Fact table grain:
One row represents one product sold in a particular
order, by a particular customer, at a particular store.

If an order contains multiple products, each product
will have a separate row in Fact_Sales.
*/

--(b)
/*(b) CREATE TABLE for dim_customer with SCD Type 2 columns: 
customer_key, customer_id, name, email, city, effective_from, effective_to (nullable), is_current.*/
Create table dim_customer (
    customer_key INT PRIMARY KEY,
    customer_key INT PRIMARY KEY ,
    customer_id INT,
    name VARCHAR(30),
    city VARCHAR(30),
    email VARCHAR(30),
    effective_from DATE NOT NULL,
    effective_to DATE,
    is_current BOOLEAN NOT NULL
);
--SCD type 2 add the extra column to hold the historical data 
*/

--(c)
/*
(c) SQL to handle customer changing city 'Delhi' to 'Pune': UPDATE to expire old record, INSERT new version with is_current = true. */
START TRANSACTION;

UPDATE dim_customer
SET
    effective_to = CURRRNT_DATE(),
    is_current = FALSE
WHERE customer_id = 101
AND is_current = TRUE;

INSERT INTO dim_customer
(customer_key, customer_id, name, email, city,
 effective_from, effective_to, is_current)
VALUES
(2, 101, 'Priya', 'p@x.com', 'Pune',
 '2024-06-01', NULL, TRUE);

COMMIT;

--(or)
INSERT INTO dim_customer
(customer_key, customer_id, name, email, city,
 effective_from, effective_to, is_current)
SELECT
    2,
    customer_id,
    name,
    email,
    'Pune',
    '2024-06-01',
    NULL,
    TRUE
FROM dim_customer
WHERE customer_id = 101
AND effective_to = CURRRNT_DATE();


--(d)
/*
(d) Explain how snowflake schema differs from star schema. When would you choose snowflake? Give one concrete trade-off.

1. Star Schema - Contains one central fact table connected directly to dimension tables,
 Dimension tables are usually denormalized (all related details are stored together),Requires fewer joins, making queries simpler.

2.Snowflake Schema - Similar to star schema, but dimension tables are further divided into smaller related tables,
Dimension tables are normalized to reduce data duplication,Requires more joins to retrieve information.

In the star schema , the dimension tables r not normalized and may cause duplicattion and all
in snowflake schema , the dimension tables r normalized which reduces the duplicated values
*/

--e
/*
(e) Predict the result: -- dim_customer: (key=1,cust_id=101,city='Delhi',is_current=TRUE) 
UPDATE dim_customer SET effective_to='2024-06-01', is_current=FALSE WHERE customer_key=1; 
INSERT INTO dim_customer VALUES (2,101,'Priya','p@x.com','Pune','2024-06-01',NULL,TRUE); 
SELECT customer_key,city,is_current FROM dim_customer WHERE customer_id=101 ORDER BY customer_key; 

customer_key	city	is_current
1	            Delhi	FALSE
2	            Pune	TRUE
*/

