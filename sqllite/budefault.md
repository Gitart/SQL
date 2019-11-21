## Cretaed table wit field by deafult current time format 

```sql
CREATE TABLE `A0` (
	`Id`	     INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Item1`	   CHAR DEFAULT (strftime('%d - %m - %Y %H:%M:%S ','now','localtime')),
	`Field3`	 TEXT DEFAULT (strftime('%s-%W','now','localtime'))
);
```

## In contrusctor db admin
```sql
=(strftime('%d - %m - %Y %H:%M:%S ','now','localtime'))
```
## Remark  
If not set 'localtime' be no cuurent time +- 2 hource!

