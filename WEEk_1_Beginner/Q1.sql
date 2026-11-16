
/*Topic: SELECT, WHERE, ORDER BY, LIMIT, Aliases & NULL Handling 

Using a products table (id, name, category, price, stock_qty, supplier_id -- supplier_id may be NULL): 

(a) List all 'Electronics' products costing more than 500, ordered by price descending. Alias name as product_name, price as unit_price. 
(b) Find the 5 most expensive products overall. 
(c) Use COALESCE to show supplier_id if available, otherwise 'No Supplier'. Use NULLIF to return NULL if stock_qty = 0. 
(d) Find products where supplier_id IS NULL and where IS NOT NULL. Show counts using COUNT(). 
(e) Predict the result set: -- products: (1,'Phone',999,NULL),(2,'Laptop',1500,10),(3,'Tablet',500,NULL) SELECT name, COALESCE(supplier_id::text,'No Supplier') AS supplier, NULLIF(price,500) AS price FROM products ORDER BY price DESC NULLS LAST; 
*/
--(a)
select name as product_name , price as unit_price from products 
where category="Electronics"  and price>500 Order by DESC;

--(b)
select name as product_name,price as unit_price from products ORDER by DESC LIMIT 5;

--(c)
select name as product_name , COALESCE(CAST(supplier_id AS CHAR),"No supplier"),NULLIF(stock_qty,0) as stock_quantity 
from products;

--(d)
select * from products where supplier_id is NULL;
select * from products where supplier_id is NOT NULL;
select count(*) from products where supplier_id is NULL;
select count(*) from products where supplier_id is NOT NULL;

/*(e) Predict the result set: 
-- products: (1,'Phone',999,NULL),(2,'Laptop',1500,10),(3,'Tablet',500,NULL) 
SELECT name, COALESCE(supplier_id::text,'No Supplier') AS supplier, NULLIF(price,500) AS price 
FROM products ORDER BY price DESC NULLS LAST; 

name    supplier     price 
laptop  10           1500
Phone   No Supplier  999
Tablet  No supplier  NULL
*/