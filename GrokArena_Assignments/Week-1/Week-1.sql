
--a
with direct as (
select name,count(e1.id) as count from employee e1
join employee e2 on e1.id=e2.managerId group by (e2.managerId))
select name from direct where count>=5;

--b
SELECT(SELECT DISTINCT salary FROM Employee ORDER BY salary DESC
LIMIT 1 OFFSET 1 ) AS `getNthHighestSalary(2)`;

--c
with id_table as (
select requester_id as id from RequestAccepted
UNION ALL
select accepter_id as id from RequestAccepted)
select id,count(id) as num from id_table group 
by id order by count desc LIMIt 1;

--d
select student,
Case when id%2==0 then id-1
     else id+1
     end as id
from seat order by id;

--5
with c as (
select count(Distinct product_key) as cnt ,customer_id from customer group by customer_id
)
select customer_id from c where cnt=(select count(product_key) from product);

--6
with joined as (
select u.user_id,u.join_date,o.order_date,o.buyer_id,o.order_date
from users u join orders o on o.buyer_id=u.user_id and YEAR(o.order_date)=2019 )
select user_id as buyed _id,count(buyer_id),join_date from joined 
group by user_id;

---7
with acc as(
select user_id,min(activity_date) as first_date from traffic_table 
where activity='login'
group by user_id
)
select first_date,count(user_id) from acc where
DATEDIFF('2019-06-30',first_date)<=90 
group by first_date 
;

--8
with maxy as (
    select product_id, max(change_date) as m
    from products
    where change_date <= '2019-08-16'
    group by product_id
)
select p.product_id,
       coalesce(p2.new_price, 10) as price
from (select distinct product_id from products) p
left join maxy m on p.product_id = m.product_id
left join products p2
    on p2.product_id = m.product_id
    and p2.change_date = m.m;

--9
WITH approved AS (
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,
        country,
        COUNT(*) AS approved_count,
        SUM(amount) AS approved_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country
),
charge AS (
    SELECT
        DATE_FORMAT(c.trans_date, '%Y-%m') AS month,
        t.country,
        COUNT(*) AS chargeback_count,
        SUM(t.amount) AS chargeback_amount
    FROM Chargebacks c
    JOIN Transactions t ON c.trans_id = t.id
    GROUP BY DATE_FORMAT(c.trans_date, '%Y-%m'), t.country
),
combined AS (
    SELECT month, country FROM approved
    UNION
    SELECT month, country FROM charge
)
SELECT
    c.month,
    c.country,
    COALESCE(a.approved_count, 0) AS approved_count,
    COALESCE(a.approved_amount, 0) AS approved_amount,
    COALESCE(ch.chargeback_count, 0) AS chargeback_count,
    COALESCE(ch.chargeback_amount, 0) AS chargeback_amount
FROM combined c
LEFT JOIN approved a
    ON c.month = a.month AND c.country = a.country
LEFT JOIN charge ch
    ON c.month = ch.month AND c.country = ch.country;

S