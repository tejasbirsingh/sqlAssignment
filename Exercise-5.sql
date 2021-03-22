-- Connect to Adventure works database
USE AdventureWorks2008R2;
  
/*
Ex 5:- 
Write a Procedure supplying name information from the Person.
Person table and accepting a filter for the first name. 
Alter the above Store Procedure to supply Default Values if user does not enter any value.
*/

-- SELECT Person.PersonType FROM Person.Person;

GO 
CREATE PROCEDURE Person.getNamesByType
		@PersonTypeArgument varchar(2) = 'IN'  -- default value is set to IN 
	AS 
	SELECT FirstName, 
		   LastName 
		FROM Person.Person
	WHERE PersonType = @PersonTypeArgument
GO 

		
/*
EXEC Person.getNamesByType @PersonTypeArgument ='IN'
*/