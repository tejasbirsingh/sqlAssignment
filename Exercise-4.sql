-- Connect to Adventure Works database
USE AdventureWorks2008R2;
  
/*
Create a function that takes as inputs a 
SalesOrderID, 
a Currency Code, 
and a date, 
and returns a table of all the SalesOrderDetail rows for that Sales Order including 
Quantity, ProductID, UnitPrice, and the unit price converted to the 
target currency based on the end of day rate for the date provided. 
Exchange rates can be found in the Sales.CurrencyRate table. 

*/

-- SELECT * FROM Sales.CurrencyRate AS P;
-- SELECT * FROM Sales.SalesOrderDetail;

GO
CREATE FUNCTION Sales.getProducts(@SalesOrderID int, @CurrencyCode nchar(3), @CurrencyRateDate datetime)
	RETURNS TABLE 
AS
	RETURN
	WITH Products          -- Products is a CTE
	AS (
		SELECT *
			FROM Sales.SalesOrderDetail AS o 
		WHERE o.SalesOrderID = @SalesOrderID
	)
	SELECT p.ProductID, 
		   p.OrderQty,
		   p.UnitPrice,
		   p.UnitPrice * scr.EndOfDayRate AS 'Converted Price'
		FROM Products AS p,
			 Sales.CurrencyRate AS scr
	WHERE scr.ToCurrencyCode = @CurrencyCode
	  AND scr.CurrencyRateDate = @CurrencyRateDate
GO


/*
SELECT *
	FROM Sales.getProducts(43659, 'MXN', '2005-07-01 00:00:00.000');
*/
