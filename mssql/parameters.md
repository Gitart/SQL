## Exec 
exec GetHotels '1,2,3,4,5,6,7,10,20,30'
So, the above is the PT query you can/could send to sql server from Access.

So, in above, we want to return records based on above?

The T-SQL would thus become:

```sql
CREATE PROCEDURE GetHotels
    @IdList nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MySQL nvarchar(max)

    set @MySQL = 'select * from tblHotels where ID in (' + @IdList + ')'
    EXECUTE sp_executesql  @mysql

END
GO
```

Now, in Access, say you have that array of "ID" ? You code will look like this:

```vba
Sub MyListQuery(MyList() As String)

  ' above assumes a array of id
  ' take array - convert to a string list
  
  Dim strMyList As String
  strMyList = "'" & Join(MyList, ",") & "'"
  
  Dim rst     As DAO.Recordset
  
  With CurrentDb.QueryDefs("qryPassR")
     .SQL = "GetHotels " & strMyList
     Set rst = .OpenRecordset
  End With
  rst.MoveLast
  
  Debug.Print rst.RecordCount
  
End Sub
```
