/*
Q1   Topic: DML: INSERT, UPDATE & DELETE 

Using the e-commerce tables (customers, orders, products, order_items), write the following DML statements: 

(a) INSERT a new customer. Write an INSERT adding 3 order_items rows in a single statement. 
(b) UPDATE all Electronics products: increase price by 10%. UPDATE to set stock_qty=0 for products never ordered (use subquery). 
(c) DELETE all orders placed before 2020 where total_amount < 100. Explain why you should test with SELECT first before running DELETE. 
(d) Write a transaction: insert new order, insert 2 order_items, update customer's last_order_date -- all atomically. 
(e) Predict the result: -- products: (1,'Phone',100.00,'Electronics'),(2,'Shirt',200.00,'Clothing') UPDATE products SET price=price*1.10 WHERE category='Electronics'; SELECT id, price FROM products ORDER BY id; 

*/
--a
insert into customers(customer_id,customer_name,email,city) values(
6,"madhu","madhu123@gmail.com","Hyberabad"),
(7,"Thanmaya","thanmaya123@gmail.com","manglore"),
(8,"Shreyas","shreyas123@gmail.com","Warangal");

--b
SET SQL_SAFE_UPDATES = 0; 

Update products
set price=(price*10)/100
where category="Electronics";

Update products
set stock=0
where product_id IN (select product_id from order_items);

--c
select * from orders where order_date<'2020-01-01' and total_amount<100;
Delete from orders where order_date<'2020-01-01' and total_amount<100;
/*We should test with SELECT first before running DELETE becuase to see which rows will get affected by delete 
and can confirm once before losing the recrds 
*/

--d
ALTER TABLE customers
ADD COLUMN last_order_date DATE;

START TRANSACTION;
-- 1. Insert a new order
INSERT INTO orders
(order_id, customer_id, order_date, total_amount)
VALUES
(10, 1, '2026-07-20', 1700);
-- 2. Insert two order items
INSERT INTO order_items
(order_item_id, order_id, product_id, unit_price, quantity)
VALUES
(10, 10, 102, 500, 1),
(11,10, 103, 1200, 1);
-- 3. Update customer's last order date
UPDATE customers
SET last_order_date = '2026-07-20'
WHERE customer_id = 1;

COMMIT;

--e
/*
(e) Predict the result: 
-- products: (1,'Phone',100.00,'Electronics'),(2,'Shirt',200.00,'Clothing') 
UPDATE products SET price=price*1.10 WHERE category='Electronics'; 
SELECT id, price FROM products ORDER BY id; 
id price
2   220
1   110
*/