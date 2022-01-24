# How to Remove Duplicate Rows in MySQL

March 5, 2020

[Home](https://phoenixnap.com/kb/) » [Databases](https://phoenixnap.com/kb/category/databases) » [MySQL](https://phoenixnap.com/kb/category/databases/mysql) » How to Remove Duplicate Rows in MySQL

Contents

1.  [Setting Up Test Database](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-1)
    1.  [Create Test Database](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-2)
    2.  [Add Table and Data](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-3)
    3.  [Display the Contents of the Dates Table](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-4)
2.  [Display Duplicate Rows](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-5)
3.  [Removing Duplicate Rows](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-6)
    1.  [Option 1: Remove Duplicate Rows Using INNER JOIN](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-7)
    2.  [Option 2: Remove Duplicate Rows Using an Intermediate Table](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-8)
    3.  [Option 3: Remove Duplicate Rows Using ROW\_NUMBER()](https://phoenixnap.com/kb/mysql-remove-duplicate-rows#ftoc-heading-9)

Introduction

There are several instances in which you may encounter duplicate rows in your MySQL database. **This guide will walk you through the process of how to remove duplicate row values in MySQL.**

![Tutorial on how to remove duplicate values in MySQL.](https://phoenixnap.com/kb/wp-content/uploads/2021/04/remove-duplicate-rows-mysql.png)

![Tutorial on how to remove duplicate values in MySQL.](https://phoenixnap.com/kb/wp-content/uploads/2021/04/remove-duplicate-rows-mysql.png)

Prerequisites

*   A system with MySQL installed
*   A MySQL root user account
*   Access to a terminal window / command line (Ctrl-Alt-T, Search > Terminal)

## Setting Up Test Database

**If you already have a MySQL database to work on, skip ahead to the next section.**

Otherwise, open a terminal window and type in the following:

```
mysql –u root –p
```

When prompted, enter the **root** password for your MySQL installation. If you have a specific user account, use those credentials instead of root.

![screenshot of Logging into MySQL shell](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20290'%3E%3C/svg%3E)

![screenshot of Logging into MySQL shell](https://phoenixnap.com/kb/wp-content/uploads/2021/04/log-in-to-mysql-shell.png)

The system prompt should change to:

```
mysql>
```

**Note:** If you aren’t able to connect to the MySQL server, you may get the message that access has been denied. Refer to our article on [how to solve this MySQL error](https://phoenixnap.com/kb/access-denied-for-user-root-localhost) if you need assistance.

### Create Test Database

You can create a new table in an existing database. To do so, find the appropriate database by listing all existing instances with:

```
SHOW DATABASES;
```

![viewing list of MySQL databases](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20214'%3E%3C/svg%3E)

![viewing list of MySQL databases](https://phoenixnap.com/kb/wp-content/uploads/2021/04/show-mysql-databases.png)

Alternatively, you can create a new database by entering the following command:

```
CREATE DATABASE IF NOT EXISTS testdata;
```

![Creating a MySQL database from terminal](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%2098'%3E%3C/svg%3E)

![Creating a MySQL database from terminal](https://phoenixnap.com/kb/wp-content/uploads/2021/04/create-mysql-database.png)

To start working in your new **`testdata`** database use:

```
USE testdata;
```

### Add Table and Data

Once in the database, add a table with the data below using the following command:

```
CREATE TABLE dates (
id INT PRIMARY KEY AUTO_INCREMENT,
day VARCHAR(2) NOT NULL,
month VARCHAR(10) NOT NULL,
year VARCHAR(4) NOT NULL

);

INSERT INTO dates (day,month,year)
VALUES (’29’,’January’,’2011’),
(’30’,’January’,’2011’),
(’30’,’January’,’2011’),
(’14’,’February,’2017’),
(’14’,’February,’2018’),
(‘23’,’March’,’2018’),
(‘23’,’March’,’2018’),
(‘23’,’March’,’2019’),
(‘29’,’October’,’2019’),
(‘29’,’November’,’2019’),
(‘12’,’November’,’2017’),
(‘17’,’August’,’2018’),
(‘05’,’June’,’2016’);
```

### Display the Contents of the Dates Table

To see a display of all the dates you entered, ordered by year, type:

```
SELECT * FROM dates ORDER BY year;
```

![MySQL table sorted by date](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20399'%3E%3C/svg%3E)

![MySQL table sorted by date](https://phoenixnap.com/kb/wp-content/uploads/2021/04/display-table-custom-order.png)

The output should show a list of dates in the appropriate order.

## Display Duplicate Rows

To find out whether there are duplicate rows in the test database, use the command:

```
SELECT
     day, COUNT(day),
     month, COUNT(month),
     year, COUNT(year)
FROM
     dates
GROUP BY
     day,
     month,
     year
HAVING
     COUNT(day) > 1
     AND COUNT(month) > 1
     AND COUNT(year) > 1;
```

The system will display any values that are duplicates. In this case, you should see:

![MySQL response with duplicates in a database.](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20220'%3E%3C/svg%3E)

![MySQL response with duplicates in a database.](https://phoenixnap.com/kb/wp-content/uploads/2021/04/find-duplicates-mysql-table.png)

This format works to select multiple columns. If you have a column with a unique identifier, such as an email address on a contact list or a single date column, you can simply select from that one column.

**Note:** Learn about other ways to [find duplicate rows in MySQL](https://phoenixnap.com/kb/mysql-find-duplicates).

## Removing Duplicate Rows

Prior to using any of the below-mentioned methods, remember you need to be working in an existing database. We will be using our sample database:

```
USE testdata;
```

### Option 1: Remove Duplicate Rows Using INNER JOIN

To delete duplicate rows in our test MySQL table, use [MySQL JOINS](https://phoenixnap.com/kb/mysql-join) and enter the following:

```
delete t1 FROM dates t1
INNER  JOIN dates t2
WHERE
    t1.id < t2.id AND
    t1.day = t2.day AND
    t1.month = t2.month AND
    t1.year = t2.year;
```

![example of deleting duplicate MySQL rows](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20427'%3E%3C/svg%3E)

![example of deleting duplicate MySQL rows](https://phoenixnap.com/kb/wp-content/uploads/2021/04/delete-duplicate-rows.png)

You may also use the command from **Display Duplicate** **Rows** to verify the deletion.

**Note:** If you have a unique column identifier, you can substitute it for the **month**, **day**, and **year** column identifiers, omitting the **AND** operators. This is designed to help you delete rows with multiple identical columns.

### Option 2: Remove Duplicate Rows Using an Intermediate Table

You can create an **intermediate table** and use it to remove duplicate rows. This is done by transferring only the unique rows to the newly created table and deleting the original one (with the remaining duplicate rows).

To do so follow the instructions below.

1\. Create an intermediate table that has the same structure as the source table and transfer the unique rows found in the source:

```
CREATE TABLE [copy_of_source] SELECT DISTINCT [columns] FROM [source_table];
```

For instance, to create a copy of the structure of the sample table **`dates`** the command is:

```
CREATE TABLE copy_of_dates SELECT DISTINCT id, day, month, year FROM dates;
```

![command to Create a duplicate table in MySQL](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20188'%3E%3C/svg%3E)

![command to Create a duplicate table in MySQL](https://phoenixnap.com/kb/wp-content/uploads/2021/04/create-duplicate-table.png)

2\. With that done, you can [delete the source table with the drop command](https://phoenixnap.com/kb/mysql-drop-table) and rename the new one:

```
DROP TABLE [source_table];
```

```
ALTER TABLE [copy_of_source] RENAME TO [source_table];
```

For example:

```
DROP TABLE dates;
```

```
ALTER TABLE copy_of_dates RENAME TO dates;
```

![removal of duplicate MySQL rows by copying a table and dropping the source](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%20800%20141'%3E%3C/svg%3E)

![removal of duplicate MySQL rows by copying a table and dropping the source](https://phoenixnap.com/kb/wp-content/uploads/2021/04/drop-table-and-rename.png)

### Option 3: Remove Duplicate Rows Using ROW\_NUMBER()

**Important:** This method is only available for **MySQL version 8.02** and later. [Check MySQL version](https://phoenixnap.com/kb/how-to-check-mysql-version) before attempting this method.

Another way to delete duplicate rows is with the **`ROW_NUMBER()`** function.

```
SELECT *. ROW_NUMBER () Over (PARTITION BY [column] ORDER BY [column]) as [row_number_name];
```

Therefore, the command for our sample table would be:

```
SELECT *. ROW_NUMBER () Over (PARTITION BY id ORDER BY id) as row_number;
```

The results include a **row\_number **column. The data is partitioned by **id **and within each partition there are unique row numbers. Unique values are labeled with row number **1**, while duplicates are **2**, **3**, and so on.

Therefore, to remove duplicate rows, you need to delete everything except the ones marked with 1. This is done by running a **`DELETE`** query with the **`row_number`** as the filter.

To delete duplicate rows run:

```
DELETE FROM [table_name] WHERE row_number > 1;
```

In our example *dates* table, the command would be:

```
DELETE FROM dates WHERE row_number > 1;
```

The output will tell you how many rows have been affected, that is, how many duplicate rows have been deleted.

You can verify there are no duplicate rows by running:

```
SELECT * FROM [table_name];
```

For instance:

```
SELECT * FROM dates;
```

**Note:** Consider using [SQL query optimization tools](https://phoenixnap.com/kb/sql-query-optimization-tool) as well to find the best way to execute a query and improve performance.
