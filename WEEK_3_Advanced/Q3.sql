/*
Q3 Topic: Table Partitioning: Range, List & Hash 

You have an orders table with 500 million rows. Implement partitioning: 
(a) CREATE TABLE for a partitioned orders table using RANGE partitioning on order_date. Create partitions for 2023, 2024, 2025. 
(b) CREATE TABLE for customers partitioned by LIST on region ('North','South','East','West'). Add a DEFAULT partition for unknown regions. 
(c) CREATE TABLE for order_items partitioned by HASH on order_id into 4 buckets. Explain when hash partitioning is better than range or list. 
(d) Show how partitioning 
 performance: write a query with WHERE order_date>'2024-01-01' and explain 'partition pruning' and why it reduces I/O. 
(e) Predict which partition each row goes to: CREATE TABLE orders(id INT, order_date DATE) PARTITION BY RANGE(order_date); CREATE TABLE orders_2023 PARTITION OF orders FOR VALUES FROM('2023-01-01') TO ('2024-01-01'); CREATE TABLE orders_2024 PARTITION OF orders FOR VALUES FROM('2024-01-01') TO ('2025-01-01'); INSERT INTO orders VALUES(1,'2023-06-15'),(2,'2024-03-20'); SELECT tableoid::regclass, id FROM orders ORDER BY id; 

*/

--a
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    PRIMARY KEY (order_id, order_date)
)
PARTITION BY RANGE (order_date);

CREATE TABLE orders_2023
PARTITION OF orders
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE orders_2024
PARTITION OF orders
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_2025
PARTITION OF orders
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

--b
CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(40),
    email VARCHAR(50),
    city VARCHAR(40),
    region VARCHAR(10) NOT NULL,
    PRIMARY KEY (customer_id, region)
)
PARTITION BY LIST (region);

CREATE TABLE customers_north
PARTITION OF customers
FOR VALUES IN ('North');

CREATE TABLE customers_south
PARTITION OF customers
FOR VALUES IN ('South');

CREATE TABLE customers_east
PARTITION OF customers
FOR VALUES IN ('East');

CREATE TABLE customers_west
PARTITION OF customers
FOR VALUES IN ('West');

CREATE TABLE customers_default
PARTITION OF customers DEFAULT;

--c
CREATE TABLE order_items (
    order_item_id INT,
    order_id INT,
    product_id INT,
    unit_price DECIMAL(10,2),
    quantity INT,
    PRIMARY KEY (order_id, order_item_id)
)
PARTITION BY HASH (order_id);

CREATE TABLE order_items_p0
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE order_items_p1
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE order_items_p2
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE order_items_p3
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 3);

--d
SELECT *
FROM orders
WHERE order_date > '2024-01-01';

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE order_date > '2024-01-01';
/*
Partition pruning is the process by which the database identifies 
which partitions can contain matching rows and skips the others.
*/


--e
/*(e) Predict which partition each row goes to: 
CREATE TABLE orders(id INT, order_date DATE) PARTITION BY RANGE(order_date); 
CREATE TABLE orders_2023 PARTITION OF orders FOR VALUES FROM('2023-01-01') TO ('2024-01-01'); 
CREATE TABLE orders_2024 PARTITION OF orders FOR VALUES FROM('2024-01-01') TO ('2025-01-01'); 
INSERT INTO orders VALUES(1,'2023-06-15'),(2,'2024-03-20'); 
SELECT tableoid::regclass, id FROM orders ORDER BY id; 

tableoid::regclass	id
orders_2023	         1
orders_2024	         2

*/
