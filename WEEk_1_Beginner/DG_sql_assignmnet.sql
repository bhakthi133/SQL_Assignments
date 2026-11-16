--1
SELECT m.name
FROM employee e
JOIN employee m ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;

--2
SELECT DISTINCT salary FROM Employee ORDER BY salary DESC
LIMIT 1 OFFSET 1;

--3

