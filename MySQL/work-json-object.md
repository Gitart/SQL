
## Работа с таблицами 
```sql
select JSON_OBJECT('id',id, 'name', num, 'sum', sum) from orders; 
select JSON_OBJECT('id',id, 'name', num, 'sum', sum) from orders where id=7
SELECT JSON_ARRAYAGG(JSON_OBJECT('name', num, 'sum', sum)) from orders ;
```

## Выгрузка в Json file
```sql
SELECT JSON_ARRAYAGG(JSON_OBJECT('name', num, 'sum', sum)) from orders INTO OUTFILE 'c:/WORK/DATA/fff.json';
```

## json array
```sql
 SELECT JSON_ARRAY(1, "abc", NULL, TRUE, CURTIME());
 ```
 
 ## json object
 ```sql
 SELECT JSON_OBJECT('id', 87, 'name', 'carrot');
 SELECT JSON_QUOTE('[1, 2, 3]');
 ```
 

##  выборка 2 элемент 1 эелемент
```sql
 SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[2][0]');
 SELECT JSON_EXTRACT('[10, 20, [30, 40]]', '$[1]');

 INSERT INTO json_docs VALUES  (23,'[3,10,5,"x",44]'),     (24,'[3,10,5,17,[22,"y",66]]');

SELECT JSON_KEYS('{"a": 1, "b": {"c": 30}}');

SELECT JSON_KEYS(doc) from json_docs where id=2 ;

SELECT * FROM JSON_TABLE('[{"c1": "ddd"},{"c2":"ddddd"},{"c3":"ddddd"}]', '$[*]' COLUMNS( c1 INT PATH '$.c1' ERROR ON ERROR ) ) as jt;
SELECT * FROM JSON_TABLE('[{"c1": "ddd"}]', '$[*]' COLUMNS( c1 INT PATH '$.c1' ERROR ON ERROR ) ) as jt;
```


## Select from columns
```sql
SELECT *  FROM  JSON_TABLE('[{"a":"3"},{"a":"2"},{"a":"1"},{"a":"0"},{"a":[1,2]}]',
           '$[*]' COLUMNS( 
            rowid FOR ORDINALITY,
           Nam varchar(20) PATH '$.a'   DEFAULT '111' ON EMPTY DEFAULT '10' ON ERROR)
        ) as jt;
    
```    

## Select from table
```sql
select * FROM   JSON_TABLE(
         '[{"a":"3"},{"a":2},{"b":1},{"a":0},{"a":[1,2]}]',
         "$[*]"
         COLUMNS(
           rowid FOR ORDINALITY,
           ac VARCHAR(100) PATH "$.a" DEFAULT '111' ON EMPTY DEFAULT '999' ON ERROR,
           aj JSON PATH "$.a" DEFAULT '{"x": 333}' ON EMPTY,
           bx INT EXISTS PATH "$.b"
         )
       ) AS tt;
```
## object
```sql
 SELECT JSON_PRETTY('{"a":"10","b":"15","x":"25"}'); 

SELECT
       id,
		doc,
        
       JSON_STORAGE_SIZE(doc) AS Size,
        JSON_STORAGE_FREE(doc) AS Free
     FROM json_docs;
 ```
 
 
## Обновление в таблице JSON  

 -- Обновление поля JSON ddd в поле таблице doc
 -- Если такого поля нет  оно создастся !!!
```sql
UPDATE json_docs SET doc = JSON_SET(doc, "$.dddf", "New valute") where id=1;     

SET @j = '[100, "sakila", [1, 3, 5], 425.05]';
SELECT @j  as json, JSON_STORAGE_SIZE(@j) AS Size;

UPDATE json_docs SET doc = JSON_SET(doc, "$.dddf", "New valute") where id=1;   
```  

-- https://stackoverflow.com/questions/356578/how-to-output-mysql-query-results-in-csv-format

## Export table to file
```sql
SELECT *
FROM orders
INTO OUTFILE 'c:/WORK/DATA/bmw32.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Поиск занчения по полю
```sql
SELECT JSON_VALUE('{"fname": "Joe", "lname": "Palmer"}', '$.fname');
SELECT JSON_VALUE('{"fname": "Joe", "lname": "Palmer"}', '$.lname');
```

## Поиск с конвертацией
```sql
SELECT JSON_VALUE('{"item": "shoes", "price": "49.95"}', '$.price' RETURNING DECIMAL(4,2)) AS price;
SHOW WARNINGS;
```

## Поиск в массиве если есть = 1
```sql
SELECT "ab" MEMBER OF('[23, "abc", 17, "ab", 10]');
SHOW WARNINGS
SELECT JSON_VALID('{"hello":"sss"}')

SELECT
    CONCAT(
       '[',
       GROUP_CONCAT(
           CONCAT(
               '{"name":"', name, '"',
               ',"phone":"', phone, '"}'
           )
       ),
       ']'
    ) as json
FROM person
```


## Work with array
```sql
SELECT json_arrayagg(
    json_merge(
          json_object('name', name), 
          json_object('phone', phone)
    )
) FROM person;
```


If u need a nested JSON Array Object, u can join JSON_OBJECT with json_arrayagg as below:
```sql
{
    "nome": "Moon",
    "resumo": "This is a resume.",
    "dt_inicial": "2018-09-01",
    "v.dt_final": null,
    "data": [
        {
            "unidade": "unit_1",
            "id_unidade": 9310
        },
        {
            "unidade": "unit_2",
            "id_unidade": 11290
        },
        {
            "unidade": "unit_3",
            "id_unidade": 13544
        },
        {
            "unidade": "unit_4",
            "id_unidade": 13608
        }
    ]
}
```

## U cand do like this:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lst_caso`(
IN `codigo` int,
IN `cod_base` int)
BEGIN

    DECLARE json TEXT DEFAULT '';

    SELECT JSON_OBJECT(
        'nome', v.nome, 
        'dt_inicial', v.dt_inicial, 
        'v.dt_final', v.dt_final, 
        'resumo', v.resumo,
        'data', ( select json_arrayagg(json_object(
                                'id_unidade',`tb_unidades`.`id_unidade`,
                                'unidade',`tb_unidades`.`unidade`))
                            from tb_caso_unidade
                                INNER JOIN tb_unidades ON tb_caso_unidade.cod_unidade = tb_unidades.id_unidade
                            WHERE tb_caso_unidade.cod_caso = codigo)
    ) INTO json
    FROM v_caso AS v
    WHERE v.codigo = codigo and v.cod_base = cod_base;
    
    SELECT json;
    
END
```
