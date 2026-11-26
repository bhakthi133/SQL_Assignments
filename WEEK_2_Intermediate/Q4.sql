/*
Topic: ACID Transactions & Isolation Levels 

Bank transfer (accounts: id, balance; transactions: id, from_account, to_account, amount, created_at): 
(a) Transaction: deduct 5000 from account 101, credit 5000 to account 202, insert a transactions record. Rollback if balance < 0. 
(b) Add a check so insufficient funds triggers rollback and error message. 
(c) Explain 'dirty read', 'non-repeatable read', and 'phantom read'. Which isolation level prevents each? 
(d) Explain optimistic vs pessimistic locking. Give a real-world scenario where each is appropriate. 
(e) Predict the result: -- accounts: (1,5000),(2,5000) BEGIN; UPDATE accounts SET balance=balance-1000 WHERE id=1; UPDATE accounts SET balance=balance+1000 WHERE id=2; COMMIT; SELECT balance FROM accounts ORDER BY id; 

*/

--a
DELIMITER //
Create procedure transfer()
BEGIN
START TRANSACTION;

UPDATE Accounts
SET balance = balance - 5000
WHERE account_id = 101;

UPDATE Accounts
SET balance = balance + 5000
WHERE account_id = 202;

IF (SELECT balance FROM accounts WHERE id = 101) < 0 THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;
END //
DELIMITER ;

--b
DELIMITER //
Create procedure transfer(IN insufficent_fund INT)
BEGIN
START TRANSACTION;

UPDATE Accounts
SET balance = balance - 5000
WHERE account_id = 101;

UPDATE Accounts
SET balance = balance + 5000
WHERE account_id = 202;

IF (SELECT balance FROM accounts WHERE id = 101) < insufficent_fund THEN
    ROLLBACK;
ELSE
    INSERT INTO AccountTransactions
    (id,from_account, to_account, amount,created_at)
    VALUES (1,101, 202, 5000, NOW());
    COMMIT;
END IF;
END //
DELIMITER ;


--c
/*
Dirty read - The value will be updated by the one transaction but the other transaction read that value even before it is commited by the first transaction.
NON-repeatable read - The same value is read by the same transaction twice but each time it gives 
diffrent value because in between it will be updated by other different transactions.
Phantom read - The transaction executes same condition based query more than once and gets the different result each time.

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;   -prevents dirty read
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;     -prevents dirty read and non repeatable
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;    - prevents dirty read, non repeatable read and phantom read

*/

--d
/*
(d) Explain optimistic vs pessimistic locking. Give a real-world scenario where each is appropriate. 
They r two locking mechanisms used to prevent the concurency-conflicts problem in transactions.

optimistic locking :- Assumes that conflict due to concurrency is rare 
Instead of locking a record immediately, it allows multiple users to read and work with the same data
Read first → Modify → Check for conflicts → Update

pessimistic locking :- Assumes that conflict due to concurrency is likely to occur
It locks the record before modifying it so that other transactions cannot simultaneously modify the same record.
Lock first → Read → Modify → Commit → Release lock

*/

--e
/*(e) Predict the result: 
-- accounts: (1,5000),(2,5000) 
BEGIN; 
UPDATE accounts SET balance=balance-1000 WHERE id=1; 
UPDATE accounts SET balance=balance+1000 WHERE id=2; 
COMMIT; 
SELECT balance FROM accounts ORDER BY id; 

(1,4000),(2,6000)