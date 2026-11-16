/*

Topic: String & Date/Time Functions + CASE WHEN 

Using customers (id, name, email, registration_date) and orders (order_date): 

(a) Show name in UPPER CASE, email in LOWER CASE, and the domain part of the email (everything after '@'). 

(b) Format registration_date as 'DD-Month-YYYY'. Use TO_CHAR or DATE_FORMAT. 

(c) Calculate how many days ago each customer registered. Show customers registered in the last 90 days. 

(d) CASE WHEN label on products: 'Premium' (>1000), 'Standard' (200-1000), 'Budget' (<200). Only show products in at least one order. 

(e) Predict the result set: -- customer: id=1, name='john doe', email='john.doe@gmail.com' SELECT UPPER(name) AS name, LOWER(email) AS email,   SPLIT_PART(email,'@',2) AS domain FROM customers WHERE id=1; 

*/
CREATE DATABASE String_Date_Practice;
USE String_Date_Practice;
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    registration_date DATE
);
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);
CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
INSERT INTO customers VALUES
(1, 'john doe', 'john.doe@gmail.com', '2026-11-10'),
(2, 'BHANU KUMAR', 'bhanu@yahoo.com', '2026-10-15'),
(3, 'Rahul Sharma', 'rahul@gmail.com', '2026-08-01'),
(4, 'priya reddy', 'priya@outlook.com', '2026-11-01'),
(5, 'Ananya Rao', 'ananya@gmail.com', '2026-05-20'),
(6, 'KIRAN', 'kiran@yahoo.com', '2026-09-15'),
(7, 'Sneha Patil', 'sneha@outlook.com', '2026-11-14');
INSERT INTO orders VALUES
(101, 1, '2026-11-11', 2500),
(102, 2, '2026-10-20', 1500),
(103, 3, '2026-09-10', 800),
(104, 1, '2026-11-12', 1200),
(105, 4, '2026-11-05', 3000),
(106, 5, '2026-06-10', 500),
(107, 6, '2026-09-20', 1800);
INSERT INTO products VALUES
(1, 'Laptop', 55000),
(2, 'Phone', 25000),
(3, 'Headphones', 1500),
(4, 'Keyboard', 800),
(5, 'Mouse', 150),
(6, 'USB Cable', 100),
(7, 'Monitor', 1200),
(8, 'Notebook', 100);
INSERT INTO order_items VALUES
(1, 101, 1, 1),
(2, 101, 3, 2),
(3, 102, 2, 1),
(4, 103, 4, 1),
(5, 104, 3, 1),
(6, 105, 1, 1),
(7, 106, 5, 2),
(8, 107, 7, 1);

select upper(name),lower(email),SUBSTRING_INDEX(Email, '@', -1) AS Domain from customers;
select date_format(registration_date,'%d-%m-%Y') from customers;
select name, datediff(NOW(),registration_date) from customers;
select name, datediff(NOW(),registration_date) from customers where datediff(NOW(),registration_date)<=90;

select distinct p.name,
case
    when p.price>1000 then 'PREMIUM'
    when p.price>=200 and p.price<1000 then 'STandard'
    else 'Budeget'
    end as price_categoory
FROM products p INNER JOIN order_items oi ON p.id = oi.product_id;
