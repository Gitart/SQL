## Bakup

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `bkp`()
BEGIN
    -- Drop
    DROP TABLE IF EXISTS `bkp`.`stock_products`;
	DROP TABLE IF EXISTS `bkp`.`orders`;
	DROP TABLE IF EXISTS `bkp`.`order_items`;
	DROP TABLE IF EXISTS `bkp`.`users`;
    
    -- BackUp basic table
    CREATE TABLE `bkp`.`stock_products` AS SELECT * FROM `parts`.`stock_products`;
    CREATE TABLE `bkp`.`orders`           AS SELECT * FROM `parts`.`orders`;
    CREATE TABLE `bkp`.`order_items`      AS SELECT * FROM `parts`.`order_items`;
    CREATE TABLE `bkp`.`users`            AS SELECT * FROM `parts`.`users`;
    
    
END
```

## Add to transaction
```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddToTranzaction`(IN iditem bigint, typeorder bigint  )
BEGIN

DECLARE note nvarchar(40);
IF typeorder = 1 THEN 
   SET note = "Добавление";
ELSE
   SET note = "Удаление";
END IF;   


 INSERT INTO transactions (item_id, order_id, code, title,qt, price, price_usd, price_eur, price_uah, discount, markup, sum_eur, sum, note, flag) 
                   SELECT id, order_id, code, title,qt, price, price_usd, price_eur, price_uah, discount, markup, sum_eur, sum, note, typeorder  
                   FROM order_items 
                   WHERE id = iditem;
 
 -- VALUES (OLD.id, OLD.order_id, OLD.code, OLD.title, OLD.qt, OLD.price, OLD.price_usd, OLD.price_eur, OLD.price_uah, OLD.discount, OLD.markup, OLD.sum_eur, OLD.sum, "Удалена","D");


END
```

## Add to stock
```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_stock`()
BEGIN
SET SQL_SAFE_UPDATES = 0;
truncate stock_products ;

CALL update_after_load_stock(32.12, 28.32, 1.34, 3,1);
END
```


















