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
        COUNT(0)                AS `cnt`,
        SUM(`i`.`qty`)          AS `qty`,
        SUM(`i`.`weight`)       AS `weight`,
        `c`.`title`             AS `category`,
        `i`.`category_id`       AS `category_id`,
        MAX(`i`.`product_id`)   AS `product_id`,
        MAX(`i`.`product`)      AS `product`
    FROM
        (`order_items` `i`
        LEFT JOIN `categories` `c` ON ((`i`.`category_id` = `c`.`id`)))
    GROUP BY `i`.`category_id` , `i`.`product_id`
    ```


## Agregation and relation
```sql
 SELECT 
        MAX(`o`.`company_id`)  AS `company_id`,
        MAX(`o`.`create_at`)   AS `creted`,
        MAX(`o`.`company`)     AS `company`,
        MAX(`i`.`order_id`)    AS `idorder`,
        MAX(`i`.`product`)     AS `product`,
        SUM(`i`.`weight`)      AS `weight`,
        SUM(`i`.`qty`)         AS `qty`
    FROM
        (`order_items` `i`
        LEFT JOIN `orders` `o` ON ((`i`.`order_id` = `o`.`id`)))
    WHERE
        (`o`.`typeget` IN (3 , 4))
    GROUP BY `o`.`company_id` , `i`.`product_id` , `o`.`create_at`
 ```
 
 
 
