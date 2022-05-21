## Task 

Update table Order from sum from items.    
Tables relation between by field **Order.Id=Order_items.Order_id**  

Dession :

```sql
-- Обновление итиговых сведенией по ордеру 
UPDATE orders o
INNER JOIN (
  SELECT max(order_id) as order_id, sum(summ) as account, sum(qty) as qty, sum(weight) as weight
  FROM  order_items
  GROUP BY order_id
) x 
ON o.id = x.order_id
SET o.account = x.account,
    o.qty     = x.qty,
    o.weight  = x.weight
 WHERE o.id = 2;
 ```
