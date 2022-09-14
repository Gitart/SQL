## Передача параметров в процедуру в виде таблицы для условия  IN
[links](https://dba.stackexchange.com/questions/629/passing-array-parameters-to-a-stored-procedure)
---


```sql

 ---------------------------------------------------------------
 -- Передача параметров  впроцедуру
 ---------------------------------------------------------------
 CREATE TYPE id_list AS TABLE (
    id int NOT NULL PRIMARY KEY
 );

 DECLARE @customer_list id_list;
 INSERT INTO @customer_list (id) VALUES (1), (2), (3), (4), (5), (6), (7);
 SELECT * FROM @customer_list;

````

## Для процедуры на входе параметр типа Table

```sql
CREATE TYPE id_list AS TABLE (
        id int NOT NULL PRIMARY KEY
    );
    GO
    
    CREATE PROCEDURE [dbo].[tvp_test] (
          @param1           INT
        , @customer_list    id_list READONLY
    )
    AS
    BEGIN
        SELECT @param1 AS param1;
        
        -- join, filter, do whatever you want with this table 
        -- (other than modify it)
        SELECT *
        FROM @customer_list;
    END;
    GO
    
    DECLARE @customer_list id_list;
    
    INSERT INTO @customer_list (
        id
    )
    VALUES (1), (2), (3), (4), (5), (6), (7);
    
    EXECUTE [dbo].[tvp_test]
          @param1 = 5
        , @customer_list = @customer_list
    ;
    GO
    
    DROP PROCEDURE dbo.tvp_test;
    DROP TYPE id_list;
    GO
```    



# Variant #2

```sql
CREATE TYPE dbo.ProductArray 
AS TABLE
(
  ID INT,
  Product NVARCHAR(50),
  Description NVARCHAR(255)
);
Alter your procedure in SQL Server:

ALTER PROC INSERT_SP
@INFO_ARRAY AS dbo.ProductArray READONLY
AS
BEGIN
    INSERT INTO Products SELECT * FROM @INFO_ARRAY
END
```
