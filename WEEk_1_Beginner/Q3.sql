/*

Topic: JOINs: INNER, LEFT, RIGHT & FULL OUTER 

Using customers, orders, and products tables: 

(a) INNER JOIN: customer name, order date, total amount for all 2024 orders. 

(b) LEFT JOIN: ALL customers and their order count (show 0 if no orders). Explain LEFT vs INNER in a comment. 

(c) Find products that have NEVER appeared in any order. Use LEFT JOIN + IS NULL or NOT EXISTS -- explain your choice. 

(d) Write a FULL OUTER JOIN example and explain which rows appear that would NOT appear in INNER, LEFT, or RIGHT JOINs. 

(e) Predict the result set: -- customers: (1,'Alice'),(2,'Bob'),(3,'Carol') -- orders: (101,1,500),(102,1,300) SELECT c.name, COUNT(o.id) AS order_count FROM customers c LEFT JOIN orders o ON c.id=o.customer_id GROUP BY c.name ORDER BY c.name; 

*/

CREATE DATABASE Join_practice;
USE Join_practice;
CREATE TABLE customer (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
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

INSERT INTO customer VALUES
(1, 'Bhakthi', 'Bangalore'),
(2, 'Bhanu', 'Mumbai'),
(3, 'Rahul', 'Delhi'),
(4, 'Priya', 'Mumbai'),
(5, 'Ananya', 'Bangalore'),
(6, 'Kiran', 'Chennai'),
(7, 'Arjun', 'Delhi'),
(8, 'Sneha', 'Chennai');

INSERT INTO orders VALUES
(101, 1, '2024-01-15', 1200),
(102, 2, '2024-01-20', 2500),
(103, 3, '2024-02-10', 3000),
(104, 1, '2024-02-18', 1800),
(105, 4, '2024-03-05', 1500),
(106, 2, '2024-03-15', 4000),
(107, 3, '2024-04-12', 2200),
(108, 5, '2024-04-20', 3500),
(109, 1, '2024-05-08', 2800),
(110, 2, '2024-05-22', 1800),
(111, 4, '2024-06-11', 3200),
(112, 3, '2024-06-25', 1600),
(113, 5, '2024-07-14', 4500),
(114, 1, '2024-07-28', 2100),
(115, 2, '2024-08-09', 3000),
(116, 3, '2024-08-19', 2700),
(117, 4, '2024-09-13', 1900),
(118, 1, '2024-09-25', 3800),
(119, 5, '2024-10-05', 2400),
(120, 2, '2024-10-21', 4200),
(121, 3, '2024-11-10', 3100),
(122, 4, '2024-11-22', 2600),
(123, 1, '2024-12-12', 5000),
(124, 2, '2024-12-20', 3500);

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000),
(2, 'Phone', 'Electronics', 25000),
(3, 'Headphones', 'Electronics', 2000),
(4, 'Office Chair', 'Furniture', 8000),
(5, 'Keyboard', 'Electronics', 1500),
(6, 'Printer', 'Electronics', 12000),
(7, 'Study Table', 'Furniture', 10000);

INSERT INTO order_items VALUES
(1, 101, 1, 1),
(2, 101, 3, 2),
(3, 102, 2, 1),
(4, 103, 1, 1),
(5, 104, 3, 1),
(6, 105, 4, 1),
(7, 106, 2, 2),
(8, 107, 1, 1),
(9, 108, 4, 1),
(10, 109, 2, 1),
(11, 110, 3, 2),
(12, 111, 4, 1),
(13, 112, 1, 1),
(14, 113, 2, 1),
(15, 114, 3, 1),
(16, 115, 1, 1),
(17, 116, 4, 1),
(18, 117, 2, 1),
(19, 118, 3, 1),
(20, 119, 1, 1);

select c.name , o.order_date, o.total_amount from customer c inner join orders o 
on c.id=o.customer_id where YEAR(o.order_date)=2024;

select c.name, count(o.id) from customer c left join orders o on c.id=o.customer_id group by c.id,c.name;

select p.name from products p left join order_items o on o.product_id=p.id where o.id is null;

SELECT c.id AS customer_id, c.name, o.id AS order_id, o.total_amount
FROM customer c LEFT JOIN orders o ON c.id = o.customer_id
UNION
SELECT c.id AS customer_id, c.name, o.id AS order_id, o.total_amount
FROM customer c RIGHT JOIN orders o ON c.id = o.customer_id;

/*(e) Predict the result set:
-- customers: (1,'Alice'),(2,'Bob'),(3,'Carol')
-- orders: (101,1,500),(102,1,300) 
SELECT c.name, COUNT(o.id) AS order_count FROM customers c LEFT JOIN orders o ON c.id=o.customer_id 
GROUP BY c.name ORDER BY c.name; 

c.name  order_count 
ALice   2
Bob     0
Carol   0
*/
