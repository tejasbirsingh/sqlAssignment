-- Connect to Adventure Works Database
USE AdventureWorks2008R2;

/*
Ex 6 :- 
Write a trigger for the Product table to ensure the 
list price can never be raised more than 15 Percent in a 
single change. Modify the above trigger to execute its check 
code only if the ListPrice column is updated 
*/

-- if trigger is already created than we will have to drop it first
/*
DROP TRIGGER IF EXISTS Production.trcheckListPriceRise;
*/

GO
CREATE TRIGGER Production.trcheckListPriceRise
ON Production.Product
FOR UPDATE 
AS 
	 IF UPDATE(ListPrice)		-- if the table is recently updated then only activate the trigger
	 BEGIN
		 IF EXISTS 
		 (
			 SELECT * 
				 FROM inserted i     -- inserted table stores the new values
				 INNER JOIN deleted d		 -- deleted table stores the deleted values
				 ON i.ProductID = d.ProductID
			 WHERE i.ListPrice > (d.ListPrice * 1.15)       -- if the updated price is greater than 15% of original price
		 )
		 BEGIN
			 RAISERROR('Setting price 15% more than original is not possible. 
				 Transaction Failed.',10,2)    -- This message will be printed on user console as an error
			 ROLLBACK TRAN					   -- Whole Transaction will be rolled back to original values
		 END
	 END
GO


/*
UPDATE Production.Product 
	SET ListPrice = 1500
	WHERE ProductID = 971


SELECT ProductID, ListPrice
	FROM Production.Product 
WHERE ProductID=971;
*/
