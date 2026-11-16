/*
Topic: Aggregates: COUNT, SUM, AVG + GROUP BY & HAVING 

Using orders (id, customer_id, order_date, total_amount) and customers (id, name, city): 

(a) Show city, number of customers, and total revenue. Only include cities with revenue > 10000. Sort by revenue descending. 
(b) Find the month with the highest total order amount. Group by month using DATE_TRUNC or EXTRACT. 
(c) Average order amount per customer. Only show customers with 3+ orders AND average > 500. 
(d) Count distinct customers who placed an order each month of 2024. 
(e) Predict the result set: -- orders: (1,'Mumbai',500),(2,'Mumbai',300),(3,'Delhi',800),(4,'Delhi',400),(5,'Mumbai',700) SELECT city, COUNT(*) cnt, SUM(total_amount) rev FROM orders GROUP BY city HAVING SUM(total_amount)>1000 ORDER BY rev DESC; 

*/
USE Company_db;
CREATE TABLE customer (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE orderss (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

INSERT INTO customer (id, name, city)
VALUES
(1, 'Bhakthi', 'Bangalore'),
(2, 'Bhanu', 'Mumbai'),
(3, 'Rahul', 'Delhi'),
(4, 'Priya', 'Mumbai'),
(5, 'Ananya', 'Bangalore'),
(6, 'Kiran', 'Chennai'),
(7, 'Arjun', 'Delhi'),
(8, 'Sneha', 'Chennai');

INSERT INTO orderss (id, customer_id, order_date, total_amount)
VALUES
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

select c.city,count(Distinct c.id) , sum(o.total_amount) as total_revenue from customer c join orderss o on o.customer_id=c.id
group by c.city having sum(o.total_amount)>10000 Order by total_revenue DESC;

SELECT MONTHNAME(order_date) AS month_name, SUM(total_amount) AS total_revenue FROM orderss
GROUP BY MONTH(order_date), MONTHNAME(order_date) ORDER BY total_revenue DESC
LIMIT 1;

select avg(total_amount),customer_id,count(*) from orderss
group by customer_id having avg(total_amount)>500 and count(*)>3;

select MONTH(order_date),count(distinct customer_id) from orderss where YEAR(order_date)=2024 group by MONTH(order_date);
