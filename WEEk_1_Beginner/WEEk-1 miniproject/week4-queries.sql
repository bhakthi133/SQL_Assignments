--Creating the database
CREATE DATABASE e_commerce;
USE e_commerce;

--Creating customers table
CREATE TABLE customers(
customer_id int PRIMARY KEY,
customer_name VARCHAR(40),
email VARCHAR(50),
city VARCHAR(40));


-- Creating orders table
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

-- Creating products table
CREATE TABLE products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(40),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

-- Creating order_items table
CREATE TABLE order_items(
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    unit_price DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

-- Inserting customer details
INSERT INTO customers VALUES
(1, 'Bhakthi', 'bhakthi@gmail.com', 'Bangalore'),
(2, 'Bhanu', 'bhanu@gmail.com', 'Mysore'),
(3, 'Rahul', 'rahul@gmail.com', 'Chennai'),
(4, 'Priya', NULL, 'Bangalore'),
(5, 'Arjun', 'arjun@gmail.com', NULL);

-- Inserting product details
INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 45000, 10),
(102, 'Mouse', 'Electronics', 500, 50),
(103, 'Keyboard', 'Electronics', 1200, 30),
(104, 'Chair', 'Furniture', 5000, 15),
(105, 'Desk', 'Furniture', 8000, 8),
(106, 'Bottle', 'Accessories', 300, 100),
(107, 'Headphones', 'Electronics', 2500, 20),
(108, 'Bag', 'Accessories', 1500, 25),
(109, 'Monitor', 'Electronics', 12000, 12),
(110, 'Notebook', 'Stationery', 100, 200);

-- Inserting order details
INSERT INTO orders VALUES
(201, 1, '2026-01-10', 45500),
(202, 2, '2026-01-15', 1700),
(203, 1, '2026-02-05', 5000),
(204, 3, '2026-02-12', 8000),
(205, 4, '2026-02-20', 2500),
(206, 5, '2026-03-01', 12000),
(207, 2, '2026-03-10', 1500),
(208, 3, '2026-03-15', 300),
(209, 1, '2026-04-02', 45000),
(210, 4, '2026-04-10', 500),
(211, 5, '2026-04-15', 8000),
(212, 2, '2026-05-01', 1200),
(213, 3, '2026-05-08', 2500),
(214, 1, '2026-05-15', 1500),
(215, 4, '2026-06-01', 100),
(216, 5, '2026-06-10', 5000),
(217, 2, '2026-06-15', 12000),
(218, 3, '2026-07-01', 300),
(219, 1, '2026-07-10', 1700),
(220, 4, '2026-07-15', 8000);

-- Inserting order item details
INSERT INTO order_items VALUES
(1, 201, 101, 45000, 1),
(2, 201, 102, 500, 1),
(3, 202, 103, 1200, 1),
(4, 202, 106, 300, 1),
(5, 203, 104, 5000, 1),
(6, 204, 105, 8000, 1),
(7, 205, 107, 2500, 1),
(8, 206, 109, 12000, 1),
(9, 207, 108, 1500, 1),
(10, 208, 106, 300, 1),
(11, 209, 101, 45000, 1),
(12, 210, 102, 500, 1),
(13, 211, 105, 8000, 1),
(14, 212, 103, 1200, 1),
(15, 213, 107, 2500, 1),
(16, 214, 108, 1500, 1),
(17, 215, 110, 100, 1),
(18, 216, 104, 5000, 1),
(19, 217, 109, 12000, 1),
(20, 218, 106, 300, 1);

/*Write 10 SELECT queries: aliases, WHERE filters, ORDER BY, LIMIT, and NULL handling (COALESCE, NULLIF, IS NULL). 
*/
-- Q1: Display customer names and their cities in alphabetical order.
-- Expected output: Displays customer names and their cities.
select customer_name as customer , city as Location from customers order by customer_name;


-- Q2: Display orders where the total amount is greater than 5000.
-- Expected output: Displays matching orders sorted by total amount in descending order.
select order_id,customer_id,total_amount from orders where total_amount>5000 order by total_amount desc; 


-- Q3: Display all unique cities without NULL values.
-- Expected output: Displays each city only once without NULL values.
select distinct city as unique_cities from customers WHERE city IS NOT NULL;


-- Q4: Display orders placed between February and April 2026.
-- Expected output: Displays matching orders sorted by order date in descending order.
select order_id,order_date,total_amount from orders where order_date BETWEEN '2026-02-01' and '2026-04-30' order by order_date desc;


-- Q5: Display the second-highest product price.
-- Expected output: Displays the product name and price of the second row after sorting prices in descending order.
select DISTINCT product_name,price from products order by price desc limit 1 offset 1;


-- Q6: Display customer names and their email addresses.
-- Expected output: Displays 'Email not provided' if the email is NULL.
select customer_name,coalesce(email,'Email not provided') from customers;


-- Q7: Display customers whose city is NULL.
-- Expected output: Displays customer ID and name of customers whose city is NULL.
select customer_id,customer_name from customers where city is NULL;


-- Q8: Display product names and use NULLIF to replace price 500 with NULL.
-- Expected output: Displays NULL for products with price 500 and their original price for others.
select product_name,nullif(price,500) as adjusted_price from products;


-- Q9: Display orders where the total amount is not NULL and greater than 1000.
-- Expected output: Displays matching order details sorted by total amount in ascending order.
select * from orders where total_amount IS NOT NULL and total_amount>1000 order by total_amount ;


-- Q10: Display unique cities and replace NULL values with 'UNKNOWN CITY'.
-- Expected output: Displays unique cities including 'UNKNOWN CITY' for NULL values.
select distinct coalesce(city,'UNKNOWN CITY') from customers;


/*Write 8 JOIN queries: INNER, LEFT (with 0-count), FULL OUTER example. */
-- Q11: Display customer names and their order details using INNER JOIN.
select c.customer_name,o.order_id,o.order_date,o.total_amount from customers c inner join orders o 
on o.customer_id=c.customer_id;

-- Q12: Display all customers and their order IDs using LEFT JOIN.
select c.customer_name , o.order_id from customers c left join orders o on c.customer_id=o.customer_id;

-- Q13: Display the number of orders placed by each customer, including customers with zero orders.
select c.customer_name,count(o.order_id) from customers c left join orders o on c.customer_id=o.customer_id 
group by c.customer_name;

-- Q14: Display order ID, customer name, product name, quantity and unit price using multiple INNER JOINs.
select o.order_id,c.customer_name,p.product_name,oi.quantity,oi.unit_price 
from (customers c inner join orders o on c.customer_id=o.customer_id) 
inner join (products p inner join order_items oi on oi.product_id=p.product_id) on o.order_id=oi.order_id;

-- Q15: Display customer names and order details for orders greater than 5000.
select c.customer_name,o.order_id ,o.total_amount from customers c inner join orders o
on o.customer_id=c.customer_id where o.total_amount > 5000;

-- Q16: Display each customer's total spending and show customers whose spending is greater than 10000.
select c.customer_name,c.customer_id ,sum(o.total_amount)
 from customers c inner join orders o on o.customer_id=c.customer_id 
 group by c.customer_id,c.customer_name having sum(o.total_amount)>10000;

-- Q17: Display all customers and orders, including unmatched records, using LEFT JOIN, RIGHT JOIN and UNION.
select c.customer_name , o.order_id from customers c left join orders o on c.customer_id=o.customer_id
UNION
select c.customer_name,o.order_id from customers c right join orders o on c.customer_id=o.customer_id;

-- Q18: Display each product and its total quantity sold, including products with zero orders.
select p.product_name,sum(coalesce(oi.quantity,0)) from products p left join order_items oi 
on oi.product_id=p.product_id group by p.product_name;


/*Write 8 aggregate queries: revenue by city, monthly totals, customer averages with HAVING. */
-- Q19: Display the total revenue generated by each city.
select c.city,sum(o.total_amount) from customers c left join orders o on c.customer_id=o.customer_id group by city;

-- Q20: Display the total revenue generated in each month.
select MONTH(order_date),sum(total_amount) from orders
group by MONTH(order_date);

-- Q21: Display each customer's average order amount.
select c.customer_name,avg(o.total_amount) from customers c left join 
orders o on c.customer_id=o.customer_id group by c.customer_name;

-- Q22: Display customers whose average order amount is greater than 5000.
select c.customer_name,avg(o.total_amount) from customers c left join 
orders o on c.customer_id=o.customer_id group by c.customer_name having avg(total_amount)>5000;

-- Q23: Display the total number of orders placed by each customer.
select c.customer_name,count(o.order_id) from customers c left join 
orders o on c.customer_id=o.customer_id group by c.customer_name;

-- Q24: Display the average product price for each category.
select category,avg(price) from products group by category;

-- Q25: Display the highest and lowest order amounts.
select max(total_amount),min(total_amount) from orders;

-- Q26: Display months having more than 2 orders.
select MONTH(order_date),count(order_id) from orders group by MONTH(order_date) having count(order_id)>2;

/*Write 6 subquery queries: scalar subquery, correlated, EXISTS, NOT EXISTS, and derived table.*/
-- Q27: Display products whose price is greater than the average price of all products.
select product_name,price from products where price > ( select avg(price) from products);

-- Q28: Display customers who have placed an order with the highest total amount.
SELECT c.customer_id, c.customer_name FROM customers c WHERE (
SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id
) > 4;

-- Q29: Display customers whose order count is greater than the average order amount.
select customer_id, count(total_amount) from orders group by customer_id having count(total_amount)>(select avg(total_amount) from orders);

-- Q30: Display customers who have placed at least one order using EXISTS.
select * from customers c where EXISTS(select 1 from orders o where o.customer_id=c.customer_id);

-- Q31: Display customers who have never placed an order using NOT EXISTS.
select * from customers c where NOT EXISTS(select 1 from orders o where o.customer_id=c.customer_id);

-- Q32: Display product categories whose average price is greater than 1000 using a derived table.
select * from (select category,avg(price) from products group by category having avg(price)>1000) as cate_table;


/*SQL_Assignments/WEEk_1_Beginner/WEEk-1 miniproject/question.txt*/
-- Q33: Create a payments table with a primary key and foreign key referencing orders.
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Q34 (a): Add a payment_status column to the payments table.
Alter table payments add column payment_status VARCHAR(20);

-- Q34 (b): Add a CHECK constraint to ensure the payment amount is greater than 0.
ALTER TABLE payments ADD CONSTRAINT chk_amount CHECK (amount > 0);

