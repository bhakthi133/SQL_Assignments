/*
Using the same e-commerce tables: 

(a) Scalar subquery in SELECT: each order alongside the overall average order amount. 

(b) Use EXISTS to find customers who placed an order in the last 30 days. Rewrite using IN. Explain which is more performant on large tables and why. 

(c) Use NOT EXISTS to find customers who have NEVER placed an order. Compare with NOT IN -- explain the NULL trap. 

(d) Use a derived table (subquery in FROM) to calculate per-customer totals, then select customers above the overall average. 

(e) Predict the result set: -- orders: (1,100),(2,200),(3,300),(4,400),(5,500) SELECT id, total_amount,   (SELECT AVG(total_amount) FROM orders) AS avg FROM orders WHERE total_amount > (SELECT AVG(total_amount) FROM orders); 

*/

--a
select *,(select avg(total_amount) from orders) from orders;

--b
select * from customer where exists(select 1 from orders 
where customer.id= orders.customer_id and datediff(NOW(),order_date)<=30);

select * from customer where id in (select customer_id from orders where datediff(NOW(),order_date)<=30);

--c
select * from customer where NOT exists(select 1 from orders where customer.id=orders.customer_id);
select * from customer where id not in (select customer_id from orders);

--d
select customer_id,total_amount from 
(select customer_id,total_amount from orders where total_amount>(select avg(total_amount)from orders)) 
as cust_reve;

/*(e) Predict the result set: 
-- orders: (1,100),(2,200),(3,300),(4,400),(5,500) 
SELECT id, total_amount, (SELECT AVG(total_amount) FROM orders) AS avg FROM orders 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders); 

id total_amount avg 
4  400          300
5  500          300
*/