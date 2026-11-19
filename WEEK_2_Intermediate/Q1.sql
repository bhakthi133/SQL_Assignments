"""

Topic: Window Functions: ROW_NUMBER, RANK, LAG, LEAD & Frame Clauses 

Using orders (id, customer_id, order_date, total_amount): 
(a) ROW_NUMBER() to assign a sequential number to each customer's orders by order_date (row 1 = first order ever). 
(b) RANK() and DENSE_RANK() together to rank all orders by total_amount descending. Show a row where they differ. 
(c) LAG() for prev_order_amount and LEAD() for next_order_amount per customer. Show NULL where no previous/next. 
(d) 3-order rolling average of total_amount per customer using AVG() OVER() with ROWS BETWEEN 2 PRECEDING AND CURRENT ROW. 
(e) Predict the result set: -- orders: (1,1,'2024-01-01',100),(2,1,'2024-02-01',300),(3,2,'2024-01-01',400) SELECT customer_id, total_amount,   RANK() OVER(ORDER BY total_amount DESC) AS rnk,   LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev FROM orders; 

"""

--a
select id,customer_id,order_date,total_amount, ROW_NUMBER() OVER(order by order_date) as order_number from orders;

--b
with ranking as (select order_id,customer_id,total_amount,order_date,
RANK() OVER(order by total_amount desc) as rank_no, 
DENSE_RANK() OVER(order by total_amount desc) as dense_rank_no
from orders)
select order_id,customer_id,total_amount,order_date, rank_no,dense_rank_no,
 (rank_no-dense_rank_no) as differ from ranking;

--c
select order_id,customer_id,order_date,total_amount, 
LAG(total_amount,1,NULL) OVER(PARTITION BY customer_id order by order_date) as  prev_order_amount,
LEAD(total_amount,1,NULL) OVER(PARTITION BY customer_id order by order_date) as next_order_amount from orders;

--d
select order_id,customer_id,order_date,total_amount,
AVG(total_amount) OVER(PARTITION BY customer_id order by order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
as roll_up from orders;

--e
/*
(e) Predict the result set: 
-- orders: (1,1,'2024-01-01',100),(2,1,'2024-02-01',300),(3,2,'2024-01-01',400) 
SELECT customer_id, total_amount,   
RANK() OVER(ORDER BY total_amount DESC) AS rnk,   
LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev FROM orders; 

customer_id    total_amount   rnk     prev
3                 400          1      NULL
2                 300          2      NULL
1                 100          3      NULL
*/