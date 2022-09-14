## Samples for MSSQL

![image](https://user-images.githubusercontent.com/3950155/190232652-ba2dfecb-6dfb-463d-8d37-b05ed2682061.png)


## Identity
```sql
USE AdventureWorks2012;  
GO  
--Display the value of LocationID in the last row in the table.  
SELECT MAX(LocationID) FROM Production.Location;  
GO  
INSERT INTO Production.Location (Name, CostRate, Availability, ModifiedDate)  
VALUES ('Damaged Goods', 5, 2.5, GETDATE());  
GO  
SELECT @@IDENTITY AS 'Identity';  
GO  
--Display the value of LocationID of the newly inserted row.  
SELECT MAX(LocationID) FROM Production.Location;  
GO  
```
