/*
Topic: MERGE / UPSERT 

You receive a daily file of updated customer records. Write a MERGE / UPSERT statement: 
(a) MERGE: if customer exists (matched on customer_id) -- UPDATE name, email, city; if new -- INSERT all columns. 
(b) Rewrite using PostgreSQL INSERT ... ON CONFLICT DO UPDATE (UPSERT). Explain the difference between MERGE and ON CONFLICT. 
(c) MERGE implementing SCD Type 2: expire old record (set effective_to, is_current=false) 
and INSERT new version for city changes. Insert normally for new customers. 
(d) Explain when MERGE can cause performance issues on 
large tables and what alternatives exist (staging tables + DELETE + INSERT pattern). 
(e) Predict the result: -- target customers: (1,'Alice','Delhi'),(2,'Bob','Mumbai') -- source: (1,'Alice','Pune'),(3,'Carol','Chennai') -- After MERGE (update city for match, insert for new): SELECT id,name,city FROM customers ORDER BY id; 

*/

--a
MERGE INTO customers as target
using updated_customers as source
on target.customer_id=source.customer_id 

WHEN matched then
    update set
    target.name=source.name
    target.email=source.email
    target.city=source.city

when not matched by target then 
    INSERT (id,name,city,email) values(source.id,source.name,source.city,source.email);

--b
INSERT INTO customers (customer_id, name, email, city)
VALUES (1, 'Alice', 'alice@gmail.com', 'Pune')

ON CONFLICT (customer_id)
DO UPDATE SET
    name = EXCLUDED.name,
    email = EXCLUDED.email,
    city = EXCLUDED.city;

--c
MERGE INTO customers as target
using updated_customers as source
on target.customer_id=source.customer_id 

WHEN matched and target.city<>source.city then
    update set
    target.effective_to=GETDATE()
    target.is_current=FALSE
    
when not matched by target then 
    INSERT (id,name,city,email,effective_from,effective_to,is_current) values
    (source.id,source.name,source.city,source.email,GETDATE(),NULL,TRUE);

--d
/*
MERGE can cause performance issues when working with very large tables because matching and updating millions of 
records can take more time, especially without proper indexes.

An alternative is to use a staging table. 
First, load the incoming data into the staging table, 
then delete the old matching records and 
insert the updated records from the staging table.

*/

--e
/*
(e) Predict the result: 
-- target customers: (1,'Alice','Delhi'),(2,'Bob','Mumbai') 
-- source: (1,'Alice','Pune'),(3,'Carol','Chennai') 
-- After MERGE (update city for match, insert for new): 
SELECT id,name,city FROM customers ORDER BY id; 

id name city
1,Alice,Pune
3,Bob,Mumbai

