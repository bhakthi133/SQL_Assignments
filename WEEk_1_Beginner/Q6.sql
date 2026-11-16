/*

Topic: DDL: CREATE TABLE, ALTER TABLE & Normalization (1NF to 3NF) 

Un-normalized table: orders_flat(order_id, customer_name, customer_email, customer_city, product1_name, product1_price, product2_name, product2_price, salesperson_name, salesperson_region): 

(a) Identify every normalization violation. Label each as 1NF, 2NF, or 3NF violation. 

(b) Redesign into separate tables satisfying 3NF. Name each table and list columns with PKs and FKs. 

(c) Write CREATE TABLE SQL for your 3NF design. Include PRIMARY KEY, FOREIGN KEY, NOT NULL, and CHECK  

constraints. 

(d) Write ALTER TABLE to: add phone_number VARCHAR(15) to customers, add UNIQUE on email, add CHECK ensuring price > 0. 

(e) Predict which INSERT statements succeed or fail: CREATE TABLE emp(id INT PRIMARY KEY, name VARCHAR(50) NOT NULL, sal DECIMAL CHECK(sal>0)); INSERT INTO emp VALUES (1,'Alice',50000); -- A INSERT INTO emp VALUES (2,NULL,60000);   -- B INSERT INTO emp VALUES (3,'Bob',-100);   -- C 

*/

a)
1NF-product1_name, product1_price, product2_name and product2_price represent repeating product groups.
2NF-product_name and product_price depend only on product_id and not on otehr primay keys ie order_id
3NF-order_id → customer_name, customer_email, customer_city
    customer_email → customer_name, customer_city
    salesperson_name → salesperson_region
    transivite dependencies

b)
customers-customer_id, customer_name, email, city	[customer_id (PK)]
salespeople-salesperson_id, salesperson_name, region	[salesperson_id (PK)]
products-product_id, product_name, price	[product_id (PK)]
orders-order_id, customer_id, salesperson_id	[order_id (PK), customer_id (FK), salesperson_id (FK)]
order_items-order_id, product_id, quantity	[Composite PK: order_id + product_id,both are FKs]

c)

-- 1. Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY ,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- 2. Salespeople table
CREATE TABLE salespeople (
    salesperson_id INT PRIMARY KEY ,
    salesperson_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

-- 3. Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY ,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    CHECK (price > 0)
);

-- 4. Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (salesperson_id) REFERENCES salespeople(salesperson_id)
);

-- 5. Order items table
CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

d)
ALTER TABLE customers ADD phone_number VARCHAR(15);
ALTER TABLE customers ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE products ADD CONSTRAINT chk_product_price CHECK (price > 0);