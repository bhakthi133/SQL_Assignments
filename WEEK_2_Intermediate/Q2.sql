/*

Topic: CTEs, Recursive CTEs, UNION / INTERSECT / EXCEPT & ROLLUP / CUBE / GROUPING SETS 

Using the same e-commerce tables: 

(a) CTE named top_customers: top 5 customers by total spending. Join the CTE with orders to show their most recent purchase. 
(b) Recursive CTE generating numbers 1 to 10. Explain when recursive CTEs are useful (e.g., hierarchical data, org trees). 
(c) UNION ALL combining 2023 and 2024 orders with a year column. Wrap in CTE, GROUP BY year to compare totals. 
    Use INTERSECT to find customer_ids ordering in BOTH years. 
(d) ROLLUP on (category, city) showing revenue at: individual, category subtotal, and grand total. 
    Rewrite using GROUPING SETS for only 2 of the 3 levels. 
(e) Predict the result set: -- sales(category,city,amount): ('A','X',100),('A','Y',200),('B','X',300) SELECT category, city, SUM(amount) FROM sales GROUP BY ROLLUP(category,city); 
*/

--a
with top_customers as (
    select customer_id,sum(total_amount) as sum_total from orders group by customer_id order by sum_total desc limit 5
),
joined as (
select t.sum_total as sum_total,t.customer_id as customer_id,o.order_date as order_date,
row_number() OVER(partition by t.customer_id order by o.order_date) as order_rnk
from top_customers t join orders o 
on o.customer_id=t.customer_id )
select * from joined where order_rnk=1;

--b
with RECURSIVE cte(n) as ( select 1 UNION ALL
select n+1 from cte where n<10 ) select * from cte;

--c
with either as (select order_id,customer_id,order_date,total_amount,Year(order_date)as year_order from orders where YEAR(order_date)=2023
UNION ALL
select order_id,customer_id,order_date,total_amount,Year(order_date)as year_order from orders where YEAR(order_date)=2024)
select year_order,sum(total_amount) from either group by year_order ;

with yes_both as (
select order_id,customer_id,order_date,total_amount,Year(order_date)as year_order from orders where YEAR(order_date)=2023
INTERSECT
select order_id,customer_id,order_date,total_amount,Year(order_date)as year_order from orders orders where YEAR(order_date)=2024)
select year_order,sum(total_amount) from yes_both groupby year_order;

--d
(d) 
with join1 as ( 
select c.city as city,o.order_id,o.total_amount from customers c join orders o on o.customer_id=c.customer_id ),
join2 as ( select j1.order_id,oi.product_id,j1.city,j1.total_amount from join1 j1 join order_items oi on oi.order_id=j1.order_id ),
join3 as ( select p.category  as category ,j2.city,j2.total_amount as revenue from join2 j2 join products p on p.product_id=j2.product_id)
select category,city,sum(revenue) from join3 group by category,city with ROLLUP;

with join1 as ( 
select c.city as city,o.order_id,o.total_amount from customers c join orders o on o.customer_id=c.customer_id ),
join2 as ( select j1.order_id,oi.product_id,j1.city,j1.total_amount from join1 j1 join order_items oi on oi.order_id=j1.order_id ),
join3 as ( select p.category  as category ,j2.city,j2.total_amount as revenue from join2 j2 join products p on p.product_id=j2.product_id)
select category,city,sum(revenue) from join3 group by grouping_sets((category,city),(category),());

--e
/*
(e) Predict the result set: 
-- sales(category,city,amount): ('A','X',100),('A','Y',200),('B','X',300) 
SELECT category, city, SUM(amount) FROM sales GROUP BY ROLLUP(category,city); 
category   city   sales
A           X      100
A           Y      200
A          NULL    300
B           X      300
B          NULL    300
NULL       NUll    600
*/





