IF EXISTS (SELECT name
    FROM sysobjects
    WHERE name = N'sp_SelectOrders'
    AND type = 'P')
    DROP PROCEDURE sp_SelectOrders
GO

CREATE PROC sp_SelectOrders @in_values nText AS

DECLARE @hDoc int

--Prepare input values as an XML documnet
exec sp_xml_preparedocument @hDoc OUTPUT, @in_values

--Select data from the table based on values in XML
SELECT * FROM Orders WHERE CustomerID IN (
 SELECT CustomerID FROM OPENXML (@hdoc, '/NewDataSet/Customers', 1)
 WITH (CustomerID NCHAR(5)))

EXEC sp_xml_removedocument @hDoc

GO
