## How to DROP Tables Based on Character Strings

MySQL does not have a built-in command to drop tables that match [a string of characters](https://phoenixnap.com/kb/mysql-string-function). Instead, use a script to help perform this task.

1\. Define the database and string of characters you want to filter:

```
set @schema = 'tableselection';
set @string = 'table%';
```

Replace **`tableselection`** with the name of your database. Replace **`table%`** with the string of characters you want to select and delete. Make sure to leave the **`%`** wildcard at the end.

2\. Create a MySQL statement that selects all of the tables that match the string of characters:

```
SELECT CONCAT ('DROP TABLE ',GROUP_CONCAT(CONCAT(@schema,'.',table_name)),';')
INTO @droptool
FROM information_schema.tables
WHERE @schema = database()
AND table_name LIKE @string;

```

This code selects all tables with the **`table%`** characters specified from the **`information_schema`** table. It then concatenates them and executes a **`DROP`** statement against the group.

3\. Create a selection from the results of this code:

```
SELECT @droptool;
```

4\. Display the contents of the command:

```
PREPARE stmt FROM @droptool;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

```

The code in the section below is presented in its entirety for ease of use:

```
set @schema = 'tableselection';
set @string = 'table%';

SELECT CONCAT ('DROP TABLE ',GROUP_CONCAT(CONCAT(@schema,'.',table_name)),';')
INTO @droptool
FROM information_schema.tables
WHERE @schema = database()
AND table_name LIKE @string;

SELECT @droptool;

PREPARE stmt FROM @droptool;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
```
