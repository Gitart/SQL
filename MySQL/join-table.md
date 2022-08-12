Если две таблицы одинаковы по структуре, все просто:

INSERT INTO `table_1` SELECT * FROM `table_2`

SQL

Для таблиц с разными названиями полей придется делать «подгонку». В запросе данные из `table_2` добавляются `table_1`.

```sql
INSERT INTO `table_1` (`id`, `name`, `keywords`, `text`)
SELECT
	NULL AS `id`,
	`title` AS `name`,
	`words` AS `keywords`,
	`short_text` AS `text`
FROM

	`table_2`
```

## Соединение полей

```sql
INSERT INTO `table_1` (`id`, `name`, `text`)
SELECT
	NULL AS `id`,
	`title` AS `name`,
	CONCAT(`words`, `short_text`) AS `text`
FROM

	`table_2`

```

### Соединение полей через разделитель.

```sql
INSERT INTO `table_1` (`id`, `name`, `text`)
SELECT
	NULL AS `id`,
	`title` AS `name`,
	CONCAT_WS(' ', `words`, `short_text`) AS `text`
FROM

	`table_2`
```

### Подзапросы из других таблиц

```sql
INSERT INTO `table_1` (`id`, `name`, `text`)
SELECT
	NULL AS `id`,
	`title` AS `name`,
	(SELECT `full_text` FROM `table_3` WHERE `id` = `table_2`.`item_id`) AS `text`
FROM

	`table_2`
```

### Объединение таблиц

LEFT JOIN

```SQL

INSERT INTO `table_1` (`id`, `name`, `keywords`, `text`)
SELECT
	NULL AS `id`,
	`table_2`.`title` AS `name`,
	`table_2`.`words` AS `keywords`,
	`table_3`.`full_text` AS `text
FROM
	`table_2`
LEFT JOIN
	`table_3`
ON

	`table_2`.`id` = `table_3`.`item_id`

```


## UNION
```SQL

INSERT INTO `table_1` (`id`, `name`, `text`)
(
	SELECT
		NULL AS `id`,
		`title` AS `name`,
		`short_text` AS `text`
	FROM
		`table_2`
)
UNION
(
	SELECT
		NULL AS `id`,
		`title` AS `name`,
		`short_text` AS `text`
	FROM
		`table_3`
)
```
