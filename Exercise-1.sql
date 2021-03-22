+-- Connect to Adventure Works database
USE AdventureWorks2008R2;


/*
Display the number of records in the SalesPerson table. 
*/
SELECT COUNT(*) AS 'No. of Sales records' 
	FROM Sales.SalesPerson;


/*
Select both the FirstName and LastName of records from the Person table
where the FirstName begins with the letter ‘B’. 
*/
SELECT FirstName AS 'First Name',
	   LastName AS 'Last Name'
	FROM Person.Person
WHERE FirstName LIKE 'B%';    


/*
Select a list of FirstName and LastName for employees where 
Title is one of Design Engineer, Tool Designer or Marketing Assistant. 
*/

--SELECT TOP 3 * FROM HumanResources.Employee;
--SELECT TOP 3 * FROM Person.Person;

SELECT p.FirstName AS 'First Name',
	   p.LastName AS 'Last Name'
	FROM Person.Person AS p,
		 HumanResources.Employee AS e 
WHERE e.BusinessEntityID = p.BusinessEntityID
	AND e.JobTitle 
	IN ('Design Engineer', 'Tool Designer', 'Marketing Assistant');


/*
Display the Name and Color of the Product with the maximum weight. 
*/
SELECT Name,
	   Color
	FROM Production.Product
WHERE Weight = (SELECT MAX(Weight) 
					FROM Production.Product);


/*
Display Description and MaxQty fields from the SpecialOffer table. 
Some of the MaxQty values are NULL, in this case display the value 0.00 instead. 
*/
SELECT Description, 
	   COALESCE(MaxQty , 0.0)
	FROM Sales.SpecialOffer;


/*
Display the overall Average of the [CurrencyRate].[AverageRate] values for the exchange
rate ‘USD’ to ‘GBP’ for the year 2005 i.e. FromCurrencyCode = ‘USD’ and ToCurrencyCode = ‘GBP’. 
Note: The field [CurrencyRate].[AverageRate] is defined as 'Average exchange rate for the day.' 
*/

--SELECT * FROM Sales.CurrencyRate;

SELECT AVG(AverageRate) 
	FROM Sales.CurrencyRate
WHERE FromCurrencyCode = 'USD'
	AND ToCurrencyCode = 'GBP'
	AND YEAR(CurrencyRateDate) = 2005;  -- Year function extracts the year out of datetime input


/*
Display the FirstName and LastName of records from the Person table 
where FirstName contains the letters ‘ss’. 
Display an additional column with sequential numbers for each row returned
beginning at integer 1. 
*/

SELECT ROW_NUMBER() OVER(ORDER BY FirstName) AS 'Index',
		FirstName AS 'First Name',
		LastName AS 'Last Name'
	FROM Person.Person 
	WHERE FirstName LIKE '%ss%';


/*
Sales people receive various commission rates that belong to 1 of 4 bands. 
Display the [SalesPersonID] with an additional column entitled ‘Commission Band’ indicating the appropriate band as above.
*/

--SELECT * FROM Sales.SalesPerson;

SELECT BusinessEntityID AS 'Sales Person ID',
	CASE
		WHEN CommissionPct = 0.0 THEN 'Band 0'
		WHEN CommissionPct > 0.0 AND CommissionPct <= 0.01 THEN 'Band 1'
		WHEN CommissionPct > 0.01 AND CommissionPct <= 0.015 THEN 'Band 2'
		WHEN CommissionPct > 0.015 THEN 'Band 3'
	END AS 'Commission Band'
	FROM Sales.SalesPerson;


/*
Display the managerial hierarchy from Ruth Ellerbrock (person type – EM) up to CEO Ken Sanchez. 
Hint: use [uspGetEmployeeManagers] 
*/

--SELECT * FROM Person.Person;

DECLARE @PERSON_ID AS INT;
SELECT @PERSON_ID = BusinessEntityID
	FROM Person.Person
	WHERE FirstName = 'Ruth'
		  AND LastName = 'Ellerbrock'
		  AND PersonType = 'EM';

EXEC dbo.uspGetEmployeeManagers @PERSON_ID;


/*
Display the ProductId of the product with the largest stock level. 
Hint: Use the Scalar-valued function [dbo]. [UfnGetStock]. 
*/

SELECT MAX(dbo.ufnGetStock(ProductID)) FROM Production.Product;