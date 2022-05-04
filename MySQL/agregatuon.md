 ## Agregation sum
 
 ```sql
 SELECT 
        MAX(category_id) AS `id`,
	      MAX(category)    AS `title`,
        SUM(price)       AS `totalsum`,
        SUM(weight)      AS `weight`,
        SUM(qty)         AS `qty`,
        COUNT(0)         AS `cnt`
    FROM
         products
    GROUP BY category_id
 ```
 
 ## Agregation with link tables
 
 ```sql
   SELECT 
        COUNT(0) AS `cnt`,
        SUM(`i`.`qty`) AS `qty`,
        SUM(`i`.`weight`) AS `weight`,
        `c`.`title` AS `category`,
        `i`.`category_id` AS `category_id`,
        MAX(`i`.`product_id`) AS `product_id`,
        MAX(`i`.`product`) AS `product`
    FROM
        (`order_items` `i`
        LEFT JOIN `categories` `c` ON ((`i`.`category_id` = `c`.`id`)))
    GROUP BY `i`.`category_id` , `i`.`product_id`
    ```
