-- Connect with Adventure Worrks database
USE AdventureWorks2008R2;

/* Ex 2:-
Write separate queries using a join, a subquery, a CTE,
and then an EXISTS to list all AdventureWorks customers
who have not placed an order.
*/

/*
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;
*/

-- Query using Join
SELECT c.CustomerID,
	   o.SalesOrderID
	FROM Sales.Customer c
		LEFT JOIN Sales.SalesOrderHeader o      
		ON c.CustomerID = o.CustomerID
WHERE SalesOrderID IS NULL;


-- Query using Subquery
SELECT c.CustomerID
	FROM Sales.Customer c
WHERE c.CustomerID NOT IN (SELECT CustomerID 
									FROM Sales.SalesOrderHeader);


-- Query using CTE (Command table expression)
WITH CustomersWithoutOrder (CustomerID) 
AS 
(
	SELECT c.CustomerID	 
		FROM Sales.Customer c
			LEFT JOIN Sales.SalesOrderHeader o 
			ON c.CustomerID = o.CustomerID
	WHERE SalesOrderID IS NULL
)
SELECT * FROM CustomersWithoutOrder;


-- Query using Exists
SELECT c.CustomerID
	FROM Sales.Customer c 
WHERE NOT EXISTS (SELECT o.CustomerID 
						FROM Sales.SalesOrderHeader O
				  WHERE O.CustomerID = c.CustomerID );