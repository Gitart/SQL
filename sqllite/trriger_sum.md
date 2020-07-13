## Trigger 

**Триггер после обновления**

Обратите внимание на SUM(NEW.summ) - если не применить NEW. будет устанвливаться старыми значениями  
т.е. предыдущими после обновления

```sql
CREATE TRIGGER summitems UPDATE OF summ ON items 
BEGIN 
UPDATE accounts SET summ = (SELECT SUM(NEW.summ) FROM items WHERE idacc = NEW.idacc) 
               WHERE num = (SELECT idacc FROM items WHERE idacc = OLD.idacc); 

INSERT INTO logs (dat, operation) VALUES (DATETIME('now'), "Обновление выполненно успешно"); 

END
```
