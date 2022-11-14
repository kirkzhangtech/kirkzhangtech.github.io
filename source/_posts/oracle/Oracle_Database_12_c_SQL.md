---
title: Oracle_Database_12_c_SQL
categories: 
- oracle
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/201714685-eb48eab8-93a3-4c3f-8d8c-0a0587c735c9.jpg
metaAlignment: center
coverMeta: out
---

作者寄语:This book is dedicated to my family.Even though you’re far away, you are still in my heart.
About the Author: Jason Price is a freelance consultant and former product manager of Oracle Corporation. He has contributed to many of Oracle’s products

<!-- more -->

# 12.Creating Tables, Sequences, Indexes, and Views

In this chapter, you will learn how to perform the following tasks:
- Create,modify, and drop tables
- Create and use sequences, which generate a series of numbers
- Create and use indexes,which can improve the performance of queries
- Create and use views, which are predefined(adj.[计]预先定义的) queries
- Examine flashback data archives,which store row changes made over a period of time

## Tables

In this section,you’ll learn about creating a table. You’ll see how to modify and drop a table as well as how to retrieve information about a table from the data dictionary. The data dictionary contains information about all the database items such as `tables` `sequences`, `indexes`, and so on.

### Creating a Table
You use the `CREATE TABLE` statement to create a table. The simplified syntax
for the CREATE TABLE statement is as follows:

```sql
CREATE [GLOBALTEMPORARY] TABLE table_name (
column_name     type [CONSTRAINT constraint_def DEFAULT default_exp]
[, column_name  type [CONSTRAINT constraint_def DEFAULT default_exp] ...] )

[ON COMMIT { DELETE | PRESERVE} ROWS ]
TABLESPACE tab_space;
```

- `GLOBAL TEMPORARY` specifies that the table’s rows are temporary (this type of table is known as a temporary table). The rows in a temporary table are specific to a user session, and how long the rows persist is set using the ON `COMMIT` clause.
- `table name` is the name of the table.
- `column name` is the name of a column.
- `type` is the type of a column.
- `constraint_def` is a constraint on a column.
- `ON COMMIT` controls the duration of the rows in a temporary table.DELETE specifies that the rows are deleted at the end of a transaction.PRESERVE specifies that the rows are kept until the end of a user session,at which point the rows are deleted. If you omit ON COMMIT for a temporary table, then the default of DELETE is used.
- `tab_space` is the tablespace for the table. If you omit a tablespace,then the table is stored in the user’s default tablespace.

note: For details,see the 《Oracle Database SQL Reference》 manual published by Oracle Corporation.
a example :

```sql
CONNECT store/store_password CREATE TABLE order_status2(
id INTEGER CONSTRAINT order_statue2_pk PRIMARY KEY,
status VARCHAR2(10),
last_modified DATE DEFAULT SYSDATE) ;
```

a temporary table:

```sql
CREATE GLORAL TEMPORARY TABLE order_status_temp (
id INTBGER,
status VARCHAR2(10) ,
last_modified DATE DEPAULT SYSDATE
ON COMMIT PRESERVE ROWS;
```

temporary table performs the following tasks:

- Adds a row to order status temp
- Disconnects from the database to end the session row in order_status_temp to be deleted
- Reconnects as `store` account and queries order_status_temp , which shows there are no rows in this table

### Getting Information on Tables

- Running a `DESCRIBE` command for the table(desc table_name)
- Querying the `user_tables` view, which forms part of the data dictionary

```text
# Some Columns in the `user_tables` View
Column              lype                Description
table_name          VARCHAR2 (128)      Name of the table.
tablespace_name     VARCHAR2(30)        Name of the tablespace in which the table isstored.A tablespace is an area used by thedatabase to store objects such as tables.
temporary           VARCHAR2(1)         Whether the table is temporary. This is set toY if temporary or N if not temporary.
```

`select * from user_tables`会查到相关用户的信息

Notice: the order_status_temp table is temporary, as indicated by the Y in the last column.You can retrieve information on all the tables you have access to by querying the `all_tables` view

### Getting Information on Columns in Tables

You can retrieve information about the columns in a table from the `user_tab_columns` view. Table 11-2 describes some of the columns in user_tab_columns

```text
Column              Type                Description
table_name          VARCHAR2(128)       Name of the table
column_name         VARCHAR2(128)       Name of the column
data_type           VARCHAR2 (128)      Data type of the column
data_length         NUMBER              Length of the data
data _precision     NUMBER              Precision of a numeric columnif a precision was specified
data_scale          NUMBER              Scale of a numeric column
```

The following example queries `user_tab_columns` for the `products` table:

```sql
COLUMN colunn_nane FORMAT a15
COLUMN data_type FORMAT a10
SELECT column_name, data_type, data_length,data_precision,data_s FROM uaer_tab_columns WHERE table_name = 'PRODUCTs';
COLUMN_NAME     DATA_TYPE       DATA_LENGTH     DATA_PRECISION      DATA_SCALE
PRODUcTID       NUMBER          22                                  0
PRODUCT_TYPEID  NUMBER          22                                  0
NAME            VARCHAR2        30
DESCRIPTION     VARCHAR2        50
PRICE           NUMEER          22              5                   2
```
note:You can retrieve information on all the columns in tables you have access to by querying the `all_tab_columns` view

### Altering a Table

You alter a table using the ALTER TABLE statement. You can use ALTER TABLE
to perform tasks such as the following:

- Adding, modifying, or dropping a column
- Adding or dropping a constraint
- Enabling or disabling a constraint

In the following sections, you’ll learn how to use `ALTER TABLE` to perform each of these tasks. You’ll also learn how to obtain information about constraints.
#### Adding a Column
The following example uses ALTER TABLE to add an `INTEGER` column named modified by to the order_status2 table:
```sql
alter table order_status2
add modified_by INTEGER
```
The next example adds a column named **initially_created** to `order_status2` :
```sql
alter table order_status2
add initially_created date default sysdate not null;
```
You can verify the addition of the new column by running a `DESCRIBE` command on `order_status2` :
```sql
describe order_status2;

```

#### Adding a Virtual Column
Oracle Database 11g introduced virtual columns. A virtual column is a column that refers only to other columns already in the table. For example,the following ALTER TABLE statement adds a virtual column named **average_salary** to the **salary_grades** table:

```sql
alter table salary_grades add (average_salary as ( (low_salary + high_salary)/2 ));
```

