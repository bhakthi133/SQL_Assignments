/*
Q3 
Topic: Query Optimization: EXPLAIN ANALYZE, Indexes & Materialized Views 

Given: SELECT * FROM orders o JOIN customers c 
       ON o.customer_id=c.id WHERE c.city='Banglore
       ' AND o.order_date>'2024-01-01' 
       ORDER BY o.total_amount DESC; 
(a) Write the EXPLAIN ANALYZE version. 
    Describe what to look for: Seq Scan vs Index Scan, actual rows, cost, buffers. 
(b) Propose and write CREATE INDEX statements.
    Explain why a composite index on (customer_id, order_date) is better than two single-column indexes. 
(c) Rewrite SELECT * to select only needed columns. Explain why SELECT * is harmful on wide tables.
(d) Create a materialized view mv_customer_revenue computing total revenue per customer. 
    Write the REFRESH MATERIALIZED VIEW command and explain when to use it vs regular views. 
(e) Predict what changes: -- Before index: EXPLAIN shows Seq Scan, cost=0.00..450.00, rows=10000
    CREATE INDEX idx_ord ON orders(customer_id, order_date); -- After index: EXPLAIN shows ______, cost=0.00..___? 

*/
--a
Explain Analyze SELECT * FROM orders o JOIN customers c 
ON o.customer_id=c.customer_id WHERE c.city='Banglore' AND o.order_date>'2024-01-01' 
ORDER BY o.total_amount DESC;

'-> Sort: o.total_amount DESC  (actual time=3.26..3.26 rows=9 loops=1)
    -> Stream results  (cost=3.15 rows=1.33) (actual time=3.12..3.16 rows=9 loops=1)
        -> Nested loop inner join  (cost=3.15 rows=1.33) (actual time=3.11..3.14 rows=9 loops=1)
            -> Filter: (c.city = ''Bangalore'')  (cost=0.75 rows=1) (actual time=0.155..0.163 rows=2 loops=1)
                -> Table scan on c  (cost=0.75 rows=5) (actual time=0.149..0.154 rows=5 loops=1)
            -> Filter: (o.order_date > DATE''2024-01-01'')  (cost=2.13 rows=1.33) (actual time=1.48..1.49 rows=4.5 loops=2)
                -> Index lookup on o using customer_id (customer_id=c.customer_id)  (cost=2.13 rows=4) (actual time=1.48..1.48 rows=4.5 loops=2)
'
/*
Sequential Scan (Seq Scan) - Reads records by scanning the table,- Checks rows to find matching records.
,can be efficient when the table is small or many rows are needed.

Index Scan - Uses an index to locate matching records, it Can avoid scanning the entire table.
,it is Particularly useful when only a small number of rows match.

Actual rows - tells the actual number of rows processed while executing the particular query
cost - It is the cost estimated by the optimizer in the DB by consdidering the resources needed for that query to excute.
buffers - hiw much data the query taken and used from the cache or storage.
*/

--b
CREATE INDEX idx_o ON customers(order_date);
CREATE INDEX idx_o_c ON customers(customer_id,order_date);
/*A composite index on (customer_id, order_date) stores entries ordered by customer_id first and order_date second
supports both conditons by using one composite index
leftmost-prefix rule: the composite index can support customer_id alone or both columns together,
but generally not order_date alone
It is better than the two-single column index because mysql wan to combine them by merge so it will be additional work.
*/

--c
SELECT o.order_id,c.customer_id,c.name,c.city,o.order_date,o.total_amount
FROM orders o JOIN customers c ON o.customer_id = c.customer_id WHERE c.city = 'Bangalore'
AND o.order_date > '2024-01-01' ORDER BY o.total_amount DESC;
/* select * on the wider table take so much time and also it gives all wanted,unwanted columns all together
slow execution , more memory usage.
*/

--d
CREATE MATERIALIZED VIEW as mv_customer_revenue (
    select c.customer_id,sum(o.total_amount) as total_revenue from customers c join orders o
    on c.customer_id=o.customer_id group by c.customer_id;
)
REFRESH MATERIALIZED VIEW view_name;
/*
regular view - Stores query definition, data is fetched when queried, updated data is fetched,
wan to use when we want the up to date data always
Materialyzed view - stores query results , reads the last time computed results itself, 
may have outdated data whe the table data is altred or updated
we prefer to use this when the complex queries querying frequently may become epxpensive and can be ok to
use outdated data for while
*/