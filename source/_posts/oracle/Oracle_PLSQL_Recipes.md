---
title: Oracle PLSQL Recipes
categories: 
- oracle
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/199011812-44a2e355-c72a-4252-bac9-37ecded0cb54.jpg
metaAlignment: center
coverMeta: out
---
摘要: 其实这个讲PLSQL有点基础

<!-- more -->
<!-- toc -->


# 1 PL/SQL Fundamentals

## 1.1 创建plsql代码块

如和创建一个可以执行的plsql代码块？

```sql
-- demo 1
begin
  -- 中间写代码
end;

-- demo 2


declare

-- 定义变量

begin 
 -- 业务逻辑
end;
```

在实际的开发当中，这些代码块会进行嵌套，第一层代码块定义的变量，内层的代码块也可以直接使用

## 1.2 在plsql种执行plsql代码块

如何在sqlplus中执行plsql代码?

登录sqlplus就可以直接输入自己的代码，然后`end;`结束代码块，并且接着输入`/`,这时候sqlplus解释器就可以执行代码了。
但是有一点需要明确，如果你的代码块是以`declare`开头的，那么就会直接输出到屏幕

```sql
sql> begin
DBMS_OUTPUT.put_line("hello world")
end;
/
```

但是如果你想创建package,function,procedure,可以使用如下语句，方便后面的调用

```sql
SQL> CREATE OR REPLACE PROCEDURE hello_world AS 
 BEGIN 
 DBMS_OUTPUT.PUT_LINE('Hello World'); 
 END; 
 / 
```

## 1.3 store code in script

如果你想通过sql脚本执行代码，该如何运行？

```sql
SET SERVEROUTPUT ON;
DECLARE 
 counter NUMBER;
BEGIN 
  FOR counter IN REVERSE 0..10 LOOP 
  DBMS_OUTPUT.PUT_LINE (counter); 
  END LOOP; 
END;
/
```
你可以保存你的plsql代码在脚本里,重要一步是要保证你的文件扩展名是`.sql`
SQL Developer supports a number of additionalextensions for more specific types of PL/SQL. 

## 1.4 执行你的脚本

登录sqlplus，然后跳(Traverse)到你的脚本目录

```sql
@绝对路径
@相对路径
sqlplus username/password@database my_stored_script.sql 
```

## 1.5 接受用户的输入从键盘中

sqlplus使用&符号来接受来自键盘的输入

```sql
DECLARE
 emp_count NUMBER; 
BEGIN 
 SELECT count(*) 
 INTO emp_count 
 FROM employees 
 WHERE department_id = &department_id; 
END; 
```

但是如果你想从键盘接受一个输入，但是后面又想继续使用，则可以使用如下方法

```sql
DECLARE
 emp_count NUMBER; 
BEGIN 
  SELECT count(*) 
  INTO emp_count 
  FROM employees 
  WHERE department_id = &&department_id; 
  DBMS_OUTPUT.PUT_LINE('The employee count is: ' || emp_count || 
  ' for the department with an ID of: ' || &department_id); 
END;

```

另外还有一种方法就是定义变量来承接从键盘来的输入,但是要注意这个变量定义的类型,如果是numeric类型的，如果是varchar2类型则需要用`单引号`,见如下代码

```sql
DECLARE 
    first varchar2(20); 
    last varchar2(25); 
    emp_last VARCHAR2(25) := '&last_name'; 
    emp_count NUMBER; 
BEGIN 
    SELECT count(*) 
    INTO emp_count 
    FROM employees 
    WHERE last_name = emp_last; 
 IF emp_count > 1 THEN 
    DBMS_OUTPUT.PUT_LINE('More than 1 employee exists with that name.'); 
 ELSE 
    SELECT first_name, last_name 
    INTO first, last 
    FROM employees 
    WHERE last_name = emp_last; 
    DBMS_OUTPUT.PUT_LINE('The matching employee is: ' || 
    first || ' ' || last); 
 END IF; 
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Please enter a different last name.'); 
END; 
```

## 1.6 Displaying Results in SQL*Plus

`SET SERVEROUTPUT ON` is issued, then the default buffer size is 20,000 bytes.
Any content that surpasses that size will be cut off. To increase the buffer, simply set the size of buffer 
you’d like to use when turning the SERVEROUTPUT on: 

## 1.7 Commenting Your Code


## 1.8 Referencing a Block of Code

如何引用一个代码块?

给一个代码块添加label标签,比如下面的代码

```sql

<<dept_block>>
DECLARE 
  dept_name varchar2(30); 
BEGIN 
  SELECT department_name 
  INTO dept_name 
  FROM departments 
  WHERE department_id = 230;
  DBMS_OUTPUT.PUT_LINE(dept_name);
END dept_block;

```

## 1.9. Referring to Variables from Nested Blocks

如果code block是嵌套关系那么该如何使用具有相同名字的变量,可以使用label来区分不同的变量名字

```sql
<<outer_block>>
DECLARE
  mgr_id NUMBER(6) := '&current_manager_id';
  dept_count number := 0;
BEGIN

SELECT count(*)
    INTO dept_count 
    FROM departments 
    WHERE manager_id = outer_block.mgr_id;

 IF dept_count > 0 THEN 
    <<inner_block>> 
    DECLARE 
      dept_name VARCHAR2(30); 
      mgr_id NUMBER(6):= '&new_manager_id'; 
    BEGIN 
    SELECT department_name 
    INTO dept_name 
    FROM departments 
    WHERE manager_id = outer_block.mgr_id; 

    UPDATE departments 
    SET manager_id = inner_block.mgr_id 
    WHERE manager_id = outer_block.mgr_id; 
    DBMS_OUTPUT.PUT_LINE 
    ('Department manager ID has been changed for ' || dept_name); 
    END inner_block; 
 ELSE 
    DBMS_OUTPUT.PUT_LINE('There are no departments listed for the manager'); 
 END IF; 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('There are no departments listed for the manager'); 
END outer_block; 
```

但是inner block创建的变量，outside block是不会读取到的,外部块变量在内部块中是可见的，而不需要完全限定名称，并且不需要块标签

## 1.10. Ignoring Substitution Variables

转义那些sqlplus使用的特殊字符

```sql
SQL> SET ESCAPE '\' 
SQL> INSERT INTO DEPARTMENTS VALUES( 
  departments_seq.nextval, 
  'Shipping \& Receiving', 
  null, 
 null);
```

还有另外一种

```sql
SQL> SET DEFINE OFF
INSERT INTO DEPARTMENTS VALUES( 
departments_seq.nextval, 
'Importing & Exporting', 
null, 
null); 

```

## 1.11. Changing the Substitution Variable Character 

如果你对改变替换变量符号(&)为其他的符号

可以使用`set define ^`, 你也可以使用任意其他的符号来替换

```sql
SQL> SET DEFINE ^
SQL> SELECT department_name 
     FROM departments 
     WHERE department_id = ^dept_id;
```

## 1.12. Creating a Variable to Match a Database Column Type

如果向查数据库中某一个表的数据，该如何将查询结果赋值给变量呢？
可以使用`%type`关键字,会将一列的数据赋值给变量,而`%rowtype`则是返回一列的数据给变量

```sql

DECLARE
 dept_name departments.department_name%TYPE; 
 dept_id NUMBER(6) := &department_id; 
BEGIN 
 SELECT department_name 
 INTO dept_name 
 FROM departments 
 WHERE department_id = dept_id; 
 DBMS_OUTPUT.PUT_LINE('The department with the given ID is: ' || dept_name); 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('No department for the given ID'); 
END;
```

# 2.基础sql

![图文无关,在写文章时听张学友的歌](https://user-images.githubusercontent.com/46363359/199057521-a7d91465-6cdc-4eba-9b15-6ed482995d71.png)

## 2.1 Retrieving a Single Row from the Database

**problem**

You are interested in returning one row from a database table via a query that searches for an exact
match.

**solution 1**  
你可以使用`select ... into ...`语法
```sql
DECLARE
    first VARCHAR2(20);  -- varchar2(20)一定是要兼容的数据库表字段的
    last VARCHAR2(25); 
    email VARCHAR2(25); 
BEGIN 
    SELECT first_name, last_name, email 
    INTO first, last, email 
    FROM employees 
    WHERE employee_id = 100; 
    DBMS_OUTPUT.PUT_LINE( 
    'Employee Information for ID: ' || first || ' ' || last || ' - ' || email); 
EXCEPTION 
WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('No employee matches the given ID'); 
WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('More than one employee matches the given ID'); 
END; 
 ```

**solution 2**

```sql
DECLARE
 CURSOR emp_cursor IS 
 SELECT first_name, last_name, email 
 FROM employees 
 WHERE employee_id = &emp_id; 
 first VARCHAR2(20); 
 last VARCHAR2(25); 
 email VARCHAR2(25); 
BEGIN 
 OPEN emp_cursor; 
 FETCH emp_cursor INTO first, last, email; 
 IF emp_cursor%NOTFOUND THEN 
      RAISE NO_DATA_FOUND; 
 ELSE 
 -- Perform second fetch to see if more than one row is returned 
    FETCH emp_cursor INTO first, last, email; 
    IF emp_cursor%FOUND THEN 
      RAISE TOO_MANY_ROWS; 
    ELSE 
      DBMS_OUTPUT.PUT_LINE( 
      'Employee Information for ID: ' || first || ' ' || last || ' - ' || email); 
      END IF;
 END IF; 
CLOSE emp_cursor; 

```

**how it works**

solution 1: One is to issue a SELECT…INTO statement,which is a statement designed to return just one row.
The other approach is to open a cursor, fetch the  one row, and close the cursor  
solution 2: We keep an open mind on that point. Consider that if youare expecting exactly one row to be 
returned, getting multiple rows back represents an exception case that you must somehow deal with. 
The cursor-based solution makes it easy to simply ignore that exception case, but ignoring a condition 
that you do not expect to occur does not change the fact that it has occurred. Although a cursor is used, 
the cases where no data is returned or where too many rows are returnedgiven the user-supplied EMPLOYEE_ID
still remain a reality. However, since cursors are specifically designed to deal with zero rows or more
than one row coming back from a query, no exceptions will be raised if these situations occur. For this reason,
Solution #2 contains some conditional logic that is used to manually raise the desired exceptions.In the event that the user supplies the block with an invalid EMPLOYEE_ID, the cursor will not fetch any data. The %NOTFOUND attribute of the cursor will be checked to see whether the cursor successfully fetched data. If not, then the NO_DATA_FOUND exception is raised. If the cursor is successful in retrieving data, then a second FETCH statement is issued to see whether more than 
one row will be returned. If more than one row is returned, then the TOO_MANY_ROWS exception is raised; 
otherwise, the expected output is displayed. In any event, the output that is displayed using either of the 
solutions will be the same whether successful or not.

## 2.2. Qualifying Column and Variable Names（变量和表列名相同)

**Problem**
You have a variable and a column sharing the same name. You want to refer to both in the same SQL
statement. 
For example, you decide that you’d like to search for records where LAST_NAME is not equal to a last
name that is provided by a user via an argument to a procedure call. Suppose you have declared a 
variable LAST_NAME, and you want to alter the query to read as follows: 

```sql
SELECT first_name, last_name, email
 INTO first, last, email 
 FROM employees 
WHERE last_name = last_name; 
```
How does PL/SQL know which LAST_NAME you are referring to since both the table column name and 
the variable name are the same? You need a way to differentiate your references. 

**Solution**
You can use the dot notation to fully qualify the local variable name with the procedure name so that
PL/SQL can differentiate between the two. The altered query, including the fully qualified 
procedure_name.variable solution, would read as follows: 
```sql
CREATE OR REPLACE PROCEDURE retrieve_emp_info(last_name IN VARCHAR2) AS 
 first VARCHAR2(20); 
 last VARCHAR2(25); 
 email VARCHAR2(25); 
BEGIN 
 SELECT first_name, last_name, email 
 INTO first, last, email 
 FROM employees 
 WHERE last_name = retrieve_emp_info.last_name; 
 DBMS_OUTPUT.PUT_LINE( 
 'Employee Information for ID: ' || first || ' ' || last_name || ' - ' || email); 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('No employee matches the last name ' || last_name); 
END; 
```

**How It Works**

PL/SQL name resolution(方法) becomes very important in circumstances such as these, and by fully qualifying 
the names, you can be sure that your code will work as expected. The solution used dot notation to fully 
qualify the variable name. 

The column name could have been qualified with the table name, as in EMPLOYEES.LAST_NAME. 
However, there’s no need to qualify the column name in this case. Because the reference occurs within a 
SELECT, the closest resolution for LAST_NAME becomes the table column of that name. So, in this particular 
case, it is necessary only to qualify references to variable names in the enclosing PL/SQL block. 

If you are executing a simple BEGIN…END block, then you also have the option of fully qualifying the 
variable using the dot notation along with the block label. For the purposes of this demonstration, let’s 
say that the code block shown in the solution was labeled <<emp_info>>. You could then fully qualify a 
variable named description as follows: 

```text
side note:

```

```sql
<<emp_info>>
DECLARE 
 last_name VARCHAR2(25) := 'Fay'; 
 first VARCHAR2(20); 
 last VARCHAR2(25); 
 email VARCHAR2(25); 
BEGIN 
 SELECT first_name, last_name, email 
 INTO first, last, email 
 FROM employees 
 WHERE last_name = emp_info.last_name; 
END; 
```

In this example, the LAST_NAME that is declared in the code block is used within the SELECT..INTO
query, and it is fully qualified with the code block label.

<text style="font-family:Courier New;color:red">

summary: </br>
1. while code block contain same variable name as parameter, we could use "procedure"(including package name i though) name qualify parameter name at where clause statement.
2. actualy you could use table name qualify parameter name in code block, but no more works on it,due to in your select statement,
it had been qualified by table name.
3. and so on , if you use label on your code block, as case shown above

</text>

## 2.3. Declaring Variable Types That Match Column Types

**Problem**
You want to declare some variables in your code block that match the same datatypes as some columns
in a particular table. If the datatype on one of those columns changes, you’d like the code block to
automatically update the variable type to match that of the updated column

**Note** 
Sharp-eyed readers will notice that we cover this problem redundantly in Chapter 1. We cover this
problem here as well, because the solution is fundamental to working in PL/SQL, especially to working with SQL in
PL/SQL. We don’t want you to miss what we discuss in this recipe. It is that important.

**Solution**
Use the `%TYPE` attribute(n.属性) on table columns to identify(v.确定) the types of data that will be returned into your local variables. Instead of providing a hard-coded datatype for a variable, append %TYPE to the database column name. Doing so will apply the datatype from the specified column to the variable you are declaring.

In the following example, the same `SELECT INTO` query is issued, as in the previous problem, to retrieve an employee record from the database. However, in this case, the variables are declared using the `%TYPE` attribute rather than designating a specified datatype for each.

```sql
DECLARE 
  first   employees.first_name%TYPE;
  last    employees.last_name%TYPE;
  email   employees.email%TYPE;
BEGIN 
SELECT 
  first_name, 
  last_name, 
  email INTO first, last, email 
FROM 
  employees 
WHERE 
  employee_id = & emp_id;
  DBMS_OUTPUT.PUT_LINE('Employee Information for ID: ' || first || ' ' || last || ' - ' || email);
EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No matching employee was found, please try again.');
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An unknown error has occured, please try again.');
END;
```

As you can see from the solution, the code block looks essentially the same as the one in the previous recipe. The only difference is that here the `%TYPE` attribute of each database column is being used in order to declare your local variable types.

**How It Works**
The `%TYPE` attribute can become a significant time-saver and savior for declaring variable types, especially if the underlying database column types are subject(会发生变化) to change. This attribute enables the local variable to assume the same datatype of its corresponding database column type at runtime. Retrieving several columns into local application variables can become tedious(`沉闷的`) if you need to continually verify that the datatypes of each variable are the same as those of the columns whose data they will consume.The`%TYPE` attribute can be used when defining variables, constants, fields, and parameters. Using `%TYPE` assures(`保证`) that the variables you declare will always remain synchronized with the datatypes of their corresponding columns.

<text style="font-family:Courier New;color:red">
summary: </br>
at all above explained that we could use `%TYPE` attribute to define variable which the same as table datatype
</text>

## 2.4. Returning Queried Data into a PL/SQL Record

**Problem** 
Instead of retrieving only a select few columns via a database query, you’d rather return the entire 
matching row. It can be a time-consuming task to replicate each of the table's columns in your 
application by creating a local variable for each along with selecting the correct datatypes. Although you 
can certainly make use of the `%TYPE` attribute while declaring the variables, you’d rather retrieve the 
entire row into a single object. Furthermore, you’d like the object that the data is going to be stored into 
to have the ability to assume the same datatypes for each of the columns being returned just as you 
would by using the `%TYPE` attribute. 
**Solution**
Make use of the `%ROWTYPE` attribute for the particular database table that you are querying. The `%ROWTYPE`
attribute returns a record type that represents a database row from the specified table. For instance, the 
following example demonstrates how the %ROWTYPE attribute can store an entire employee table row for a 
cursor: 
```sql
DECLARE 
 CURSOR emp_cur IS 
 SELECT * 
 FROM employees 
 WHERE employee_id = &emp_id; 
 -- Declaring a local variable using the ROWTYPE attribute 
 -- of the employees table 
 emp_rec employees%ROWTYPE; 
BEGIN 
 OPEN emp_cur; 
 FETCH emp_cur INTO emp_rec; 
 IF emp_cur%FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('Employee Information for ID: ' || emp_rec.first_name || ' ' || 
 emp_rec.last_name || ' - ' || emp_rec.email); 
 ELSE 
  DBMS_OUTPUT.PUT_LINE('No matching employee for the given ID');
 END IF; 
 CLOSE emp_cur; 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('No employee matches the given emp ID’); 
END; 

```

**How It Works**
The `%ROWTYPE` attribute represents an entire database table row as a record type. Each of the 
corresponding table columns is represented within the record as a variable, and each variable in the 
record inherits its type from the respective table column. 
Using the `%ROWTYPE` attribute offers several advantages to declaring each variable individually. For 
starters, declaring a single record type is much more productive than declaring several local variables to 
correspond to each of the columns of a table. Also, if any of the table columns’ datatypes is ever 
adjusted, then your code will not break because the `%ROWTYPE` attribute works in much the same manner 
as the `%TYPE` attribute of a column in that it will automatically maintain the same datatypes as the 
corresponding table columns. Therefore, if a column with a type of `VARCHAR2(10)` is changed to 
`VARCHAR2(100)`, that change will ripple(vt.在…上形成波痕) through into your record definition. 
Using `%ROWTYPE` also makes your code much easier to read because you are not littering(n.乱丢废物) local 
variables throughout. Instead, you can use the dot notation to reference each of the different columns 
that the record type returned by `%ROWTYPE` consists of. For instance, in the solution, the `first_name`, 
`last_name`, and `email` columns are referenced from the `emp_rec` record type. 


## 2.5. Creating Your Own Records to Receive Query Results

**Problem**
You want to query the database, return several columns from one or more tables, and store them into 
local variables of a code block for processing. Rather than placing the values of the columns into 
separate variables, you want to create a single variable that contains all the values. 
<text style="font-family:Courier New;color:red">
summary: </br>
return several columns from one or more tables.
</text>

**Solution**
Create a database RECORD containing variables to hold the data you want to retrieve from the database. 
Since a RECORD can hold multiple variables of different datatypes, they work nicely for grouping data that 
has been retrieved as a result of a query. 
In the following example, the database is queried for the name and position of a player. The data 
that is returned is used to populate(vt.居住于；构成人口) a PL/SQL RECORD containing three separate variables: first name, last 
name, and position. 

```sql
DECLARE
  TYPE emp_info IS RECORD(first employees.first_name%TYPE, 
                         last employees.last_name%TYPE, 
                         email employees.email%TYPE); 
  emp_info_rec emp_info;  -- 用emp_info 类型定义了emp_info_rec变量

BEGIN 
 SELECT first_name, last_name, email 
 INTO emp_info_rec 
 FROM employees 
 WHERE last_name = 'Vargas'; 
 DBMS_OUTPUT.PUT_LINE('The queried employee''s email address is ' || emp_info_rec.email); 
 EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('No employee matches the last name provided'); 
END; 
```

**How It Works**
Records are useful for passing similar data around within an application, but they are also quite useful 
for simply retrieving data and organizing it nicely as is the case with the solution to this recipe. To create 
a record, you first declare a record TYPE. This declaration can consist of one or more different datatypes 
that represent columns of one or more database tables. Once the record type is declared, you create a 
variable and define it as an instance of the record type. This variable is then used to populate and work with the data stored in the record. 

`Cursor` work very well with records of data. When declaring a cursor, you can select particular
columns of data to return into your record. The record variable then takes on the type of cursor%ROWTYPE. 
In the following example, a cursor is used to determine which fields you want to return from EMPLOYEES. 
That cursor’s %ROWTYPE attribute is then used to define a record variable that is used for holding the 
queried data. 
```sql
DECLARE
 CURSOR emp_cur IS 
 SELECT first_name, last_name, email 
 FROM employees 
 WHERE employee_id = 100; 
 emp_rec emp_cur%ROWTYPE; 
BEGIN 
 OPEN emp_cur; 
 FETCH emp_cur INTO emp_rec; 
 IF emp_cur %FOUND THEN 
CLOSE emp_cur; 
 DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || 
 '''s email is ' || emp_rec.email); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE('No employee matches the provided ID number'); 
 END IF; 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('No employee matches the last name provided'); 
END; 
```
As you can see in this example, the cursor `%ROWTYPE` attribute creates a record type using the 
columns that are queried by the cursor. The result is easy-to-read code that gains all the positive effects 
of declaring record types via the `%ROWTYPE` attribute. 

## 2.6. Looping Through Rows from a Query

**Problem**
A query that you are issuing to the database will return many rows. You want to loop through those rows 
and process them accordingly. 

**Solution #1**
There are a couple of different solutions for looping through rows from a query. One is to work directly 
with a SELECT statement and use a FOR loop along with it. In the following example, you will see this 
technique in action:
```sql
SET SERVEROUTPUT ON; 
BEGIN 
 FOR emp IN 
 ( 
 SELECT first_name, last_name, email 
 FROM employees 
 WHERE commission_pct is not NULL 
 ) 
 LOOP 
 DBMS_OUTPUT.PUT_LINE(emp.first_name || ' ' || emp.last_name || ' - ' || emp.email); 
 END LOOP; 
END; 
```

**Solution #2**
Similarly, you can choose to use a FOR loop along with a cursor. Here’s an example: 
```sql
SET SERVEROUTPUT ON; 
DECLARE 
 CURSOR emp_cur IS 
 SELECT first_name, last_name, email 
 FROM employees 
WHERE commission_pct is not NULL; 
      emp_rec emp_cur%ROWTYPE;
BEGIN 
 FOR emp_rec IN emp_cur LOOP 
 DBMS_OUTPUT.PUT_LINE( 
 emp_rec.first_name || ' ' || emp_rec.last_name || ' - ' || emp_rec.email); 
 END LOOP; 
END; 
```

**How It Works**
The `loop` that is used in the first solution is also known as an implicit(adj.含蓄的,暗示的) cursor FOR loop. No variables need to be explicitly defined in that solution, because the FOR loop will automatically create a record using the results of the query. That record will take the name provided in the FOR variable_name IN clause. That 
record variable can then be used to reference the different columns that are returned by the query. As demonstrated in the second solution to this recipe, a cursor is also a very useful way to loop through the results of a query. This technique is also known as an explicit cursor FOR loop. This technique is very similar to looping through the results of an explicitly listed query. Neither solution requires you to explicitly open and close a cursor. In both cases, the opening and 
closing is done on your behalf by the FOR loop processing. As you can see, the `FOR loop` with the `SELECT query` in the first example is a bit more concise(adj.简明的,简洁的), and there are fewer lines of code. The first example also contains no declarations. In the second example, with the cursor, there are two declarations that account for more lines of code. However, using the cursor is a standard technique that provides for more reusable code. For instance, you can elect to use the cursor any number of times, and you’ll need to write the query only once when declaring the cursor. On the contrary, if you wanted to reuse the query in the first example, then you would have to rewrite it, 
and having to write the same query multiple times opens the door to errors and inconsistencies. We recommend Solution #2. 

## 2.7. Obtaining Environment and Session Information

**Problem**
You want to obtain environment and session information such as the name and IP address of the 
current user so that the values can be stored into local variables for logging purposes. 
**Solution**
Make use of the `SYS_CONTEXT()` built-in function to query the database for the user’s information. Once you
have obtained the information, then store it into a local variable. At that point, you can do whatever 
you’d like with it, such as save it in a logging table. The following code block demonstrates this 
technique: 
```sql
<<obtain_user_info>>
DECLARE 
  username varchar2(100); 
  ip_address varchar2(100); 
BEGIN
  SELECT SYS_CONTEXT('USERENV','SESSION_USER'), SYS_CONTEXT('USERENV','IP_ADDRESS') 
  INTO username, ip_address 
  FROM DUAL; 
  DBMS_OUTPUT.PUT_LINE('The connected user is: ' || username || ', and the IP address
  is ' || 
  ip_address); 
END; 
```
Once this code block has been run, then the user’s information should be stored into the local
variables that have been declared within it. 

**How It Works**
You can use the `SYS_CONTEXT` function to obtain important information regarding the current user’s 
environment, among other things. It is often times used for auditing(n.审计;查帐) purposes so that a particular code 
block can grab(vi.攫取;夺取) important information about the connected user such as you’ve seen in the solution to 
this recipe. The SYS_CONTEXT function allows you to define a namespace and then place parameters 
within it so that they can be retrieved for use at a later time. The general syntax for the use of 
`SYS_CONTEXT` is as follows: 
```sql
SYS_CONTEXT('namespace','parameter'[,length]) 
```
A namespace can be any valid SQL identifier, and it must be created using the CREATE_CONTEXT
statement. The parameter must be a string or evaluate to a string, and it must be set using the 
DBMS_SESSION.SET_CONTEXT procedure. The call to SYS_CONTEXT with a valid namespace and parameter 
will result in the return of a value that has a VARCHAR2 datatype. The default maximum length of the 
returned value is 256 bytes. However, this default maximum length can be overridden by specifying the 
length when calling SYS_CONTEXT. The length is an optional parameter. The range of values for the length 
is 1 to 4000, and if you specify an invalid value, then the default of 256 will be used. 
The USERENV namespace is automatically available for use because it is a built-in namespace 
provided by Oracle. The USERENV namespace contains session information for the current user. Table 2-1 
lists the parameters that are available to use with the USERENV namespace. 
Table 2-1. USERENV Parameter Listing 
```sql
-- Parameter          Description 
ACTION                Identifies the position in the application name.
AUDITED_CURSORID      Returns the cursor ID of the SQL that triggered the audit. 
AUTHENTICATED_DATA    Returns the data being used to authenticate the user. 
AUTHENTICATION_TYPE   Identifies how the user was authenticated. 
BG_JOB_ID             If an Oracle Database background process was used to establish the connection, then this returns the job ID of the current session. If no 
                      background process was established, then NULL is returned. 
CLIENT_IDENTIFIER     Returns identifier that is set by the application. 
CLIENT_INFO           Returns up to 64 bytes of user session information that can be stored by an application using the DBMS_APPLICATION_INFO package. 
CURRENT_SCHEMA        Returns the current session’s default schema.
CURRENT_SCHEMAID      Returns the current schema’s identifier.
CURRENT_SQL           Returns the first 4KB of the triggering SQL.
DB_DOMAIN             Returns the value specified in the DB_DOMAIN parameter. 
DB_NAME               Returns the value specified in the DB_NAME parameter. 
DB_UNIQUE_NAME        Returns the value specified in the DB_UNIQUE_NAME parameter. 
ENTRYID               Returns the current audit entry number. 
EXTERNAL_NAME         Returns the external name of the database user. 
FG_JOB_ID             If an Oracle Database foreground process was used to establish the connection, then this returns the job ID of the current session. If no 
                      foreground process was established, then NULL is returned. 
GLOBAL_CONTEXT_MEMORY Returns the number being used by the globally accessed context in the 
                      System Global Area.   
HOST                  Returns the host name of the machine from which the client has connected. 
INSTANCE              Returns the instance ID number of the current instance. 
IP_ADDRESS            Returns the IP address of the machine from which the client has connected. 
ISDBA                 Returns TRUE if the user was authenticated as a DBA. 
LANG                  Returns the ISO abbreviation of the language name. 
LANGUAGE              Returns the language and territory used by the session, along with the 
                      character set. 
MODULE                Returns the application name. This name has to be set via the
                      DBMS_APPLICATION_INFO package. 
NETWORK_PROTOCOL      Returns the network protocol being used for communication. 
NLS_CALENDAR          Returns the current calendar of the current session. 
NLS_CURRENCY          Returns the currency of the current session. 
NLS_DATE_FORMAT       Returns the date format for the session. 
NLS_DATE_LANGUAGE     Returns the language being used for expressing dates. 
NLS_SORT              Returns the BINARY or linguistic sort basis. 
NLS_TERRITORY         Returns the territory of the current session. 
OS_USER               Returns the operating system user name of the client that initiated the 
                      session. 
PROXY_USER            Returns the name of the database that opened the current session on behalf 
                      of SESSION_USER. 
PROXY_USERID          Returns the identifier of the database user who opened the current session on behalf of the SESSION_USER. 
SERVICE_NAME          Returns the name of the service to which a given session is connected. 
SESSION_USER          Returns the database user name through which the current user is authenticated. 
SESSION_USERID        Returns the identifier of the database user name by which the current user is authenticated. 
SESSIONID             Returns the auditing session identifier. 
STATEMENTID           Returns the auditing statement identifier. 
TERMINAL              Returns the operating system identifier for the client of the current session. 
```
When `SYS_CONTEXT` is used within any query, it is most commonly issued against the `DUAL` table. The 
`DUAL` table is installed along with the data dictionary when the Oracle Database is created. This table is 
really a dummy(adj.虚拟的,假的) table that contains one column that is appropriately named `DUMMY`. This column contains 
the value `X`.
```sql
SQL> desc dual;
 Name Null? Type 
 ----------------------------------------- -------- ---------------------------- 
DUMMY VARCHAR2(1) 
```
Among other things, `DUAL` is useful for obtaining values from the database when no actual table is
needed. Our solution case is such a situation.

## 2.8. Formatting Query Results 

**Problem**
Your boss asks you to print the results from a couple of queries in a nicely formatted manner. 
**Solution** 
Use a combination of different built-in formatting functions along with the concatenation operator (||) 
to create a nice-looking basic report. The RPAD and LPAD functions along with the concatenation operator 
are used together in the following example that displays a list of employees from a company: 
```sql
DECLARE 
 CURSOR emp_cur IS 
 SELECT first_name, last_name, phone_number 
 FROM employees; 
 emp_rec employees%ROWTYPE; 
BEGIN 
 FOR emp_rec IN emp_cur LOOP 
 IF emp_rec.phone_number IS NOT NULL THEN 
 DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.first_name || ' ' || emp_rec.last_name, 35,'.') || 
 emp_rec.phone_number); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || 
 ' does not have a phone number.'); 
 END IF; 
 END LOOP; 
END; 
The following is another variant of the same report, but this time dashes are used instead of using 
dots to space out the report: 
DECLARE 
 CURSOR emp_cur IS 
 SELECT first_name, last_name, phone_number 
 FROM employees; 
 emp_rec employees%ROWTYPE; 
BEGIN 
 FOR emp_rec IN emp_cur LOOP 
  IF emp_rec.phone_number IS NOT NULL THEN
  --CHECK FOR INTERNATIONAL PHONE NUMBERS
        IF length(emp_rec.phone_number) > 12 THEN
          DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.first_name || ' ' || emp_rec.last_name, 20)||'-'|| LPAD(emp_rec.phone_number,18));
        ELSE
          DBMS_OUTPUT.PUT_LINE(RPAD(emp_rec.first_name || ' ' || emp_rec.last_name, 20)||'-'|| LPAD(emp_rec.phone_number,12));
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name ||'does not have a phone number.');
    END IF;
  END LOOP;
END;
 ```

**How It Works**
The `RPAD` and `LPAD` functions are used to return the data in a formatted manner. The `RPAD` function takes a
string of text and pads it on the right by the number of spaces provided by the second parameter. The
syntax for the `RPAD` function is as follows:
```sql
RPAD(input_text, n, character) -- append n piece characters on the right
```

In this syntax, `n` is the number of spaces used to pad. Similarly, the `LPAD` function pads on the left of
the provided string. The syntax is exactly the same as `RPAD`; the only difference is the direction of the
padding. The combination of these two functions, along with the concatenation operator (`||`), provides
for some excellent formatting options.  

It is important to look at the data being returned before you try to format it, especially to consider
what formatting options will look best when generating output for presentation. In the case of the
examples in this recipe, the latter example would be the most reasonable choice of formatting for the
data being returned, since the phone number includes dots in it. The first example uses dots to space out
the report, so too many dots may make the output difficult to read. Know your data, and then choose the
appropriate PL/SQL built-ins to format accordingly.  

Note When using `DBMS_OUTPUT` to display data, please be sure to pay attention to the size of the buffer. You can
set the buffer size from 2,000 to 1,000,000 bytes by passing the size you desire to the `DBMS_OUTPUT.ENABLE` procedure.
If you attempt to display content over this size limit, then Oracle will raise an exception.

Oracle provides a number of built-in functions to use when formatting strings. Two others that are
especially useful are `LTRIM(<string>)` and `RTRIM(<string>)`. These remove leading and trailing spaces,
respectively. See your Oracle SQL Reference manual for a complete list of available string functions.

## 2.9. Updating Rows Returned by a Query

**Problem** 
  You’ve queried the database and retrieved a row into a variable. You want to update some values 
contained in the row and commit them to the database. 
**Solution** 
  First, retrieve the database row that you want to update. Second, update the values in the row that need 
to be changed, and then issue an UPDATE statement to modify the database with the updated values. In 
the following example, a procedure is created that queries a table of employees for a particular 
employee. The resulting employee’s department ID is then updated with the new one unless the 
employee is already a member of the given department.
```sql
CREATE OR REPLACE PROCEDURE change_emp_dept(emp_id IN NUMBER, 
 dept_id IN NUMBER) AS 
 emp_row employees%ROWTYPE; 
 dept departments.department_name%TYPE; 
 rec_count number := 0; 
BEGIN 
 SELECT count(*) 
 INTO rec_count 
 FROM employees 
 WHERE employee_id = emp_id; 
 IF rec_count = 1 THEN 
 SELECT * 
 INTO emp_row 
 FROM employees 
 WHERE employee_id = emp_id; 
 IF emp_row.department_id != dept_id THEN 
 emp_row.department_id := dept_id; 
 UPDATE employees SET ROW = emp_row 
 WHERE employee_id = emp_id; 
 SELECT department_name 
 INTO dept 
 from departments 
 WHERE department_id = dept_id; 
 DBMS_OUTPUT.PUT_LINE('The employee ' || emp_row.first_name || ' ' || 
 emp_row.last_name || ' is now in department: ' || dept); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE('The employee is already in that department...no change'); 
 END IF; 
ELSIF rec_count > 1 THEN 
 DBMS_OUTPUT.PUT_LINE('The employee ID you entered is not unique'); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE('No employee records match the given employee ID'); 
 END IF; 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('Invalid employee or department ID, try again'); 
 WHEN OTHERS THEN 
 DBMS_OUTPUT.PUT_LINE('Unsuccessful change, please check ID numbers and try again'); 
END; 
```
As you can see, the example queries the database into a record declared using the `%ROWTYPE`
attribute. The value that needs to be updated is then modified using the data contained in the record. 
Lastly, using the SET ROW clause updates the table with the modified record.
**How It Works**
As you’ve seen in the solution to the recipe, it is possible to update the values of a row returned by a
query using the `UPDATE...SET` ROW syntax. In many cases, using a single `UPDATE` statement can solve this
type of transaction. However, in some scenarios where you need to evaluate the current value of a
particular column, then this solution is the correct choice.

Using the `UPDATE` ROW statement, you can update entire database rows with a single variable of either
the `%ROWTYPE` or `RECORD` type. The `UPDATE` statement also allows you to return values after the update by
adding the `RETURNING` clause to the end of the statement followed(v.跟着,听从) by the column names to return and the
variables that will receive their values. Take a look at this next example:

```sql
DECLARE
 first        employees.first_name%TYPE; 
 last         employees.last_name%TYPE; 
 new_salary   employees.salary%TYPE; 
BEGIN 
 UPDATE employees 
 SET salary = salary + (salary * .03) 
 WHERE employee_id = 100  RETURNING first_name, last_name,salary INTO first, last, new_salary; 
 DBMS_OUTPUT.PUT_LINE('The employee ' || first || ' ' || last || ' now has a salary of: ' || new_salary); 
END; 
```
As you can see, the example outputs the new values that are the result of the update statement.
Using the RETURNING clause saves a step in that you are not required to requery the table after the update 
in order to display the updated results.

## 2.10. Updating Rows Returned by a Cursor

**Problem** 
You’ve created a cursor to use for querying your data. You want to loop through the results using a cursor for loop and update the data as needed. 
**Solution**
Use the `WHERE_CURRENT_OF` clause within your loop to update the current data row in the iteration. In the 
following example, the EMPLOYEES table is queried for all employees in a particular department. The 
results of the query are then iterated using a FOR loop, and the salary is increased for each employee 
record that is returned.
```sql

DECLARE 
 CURSOR emp_sal_cur IS 
 SELECT * 
 FROM employees 
 WHERE department_id = 60 
 FOR UPDATE;        --cursor should use `FOR UPDATE` clause statement

 emp_sal_rec emp_sal_cur%ROWTYPE; -- cursor also would define varable using ROWTYPE keyword

 BEGIN 
 FOR emp_sal_rec IN emp_sal_cur LOOP 
    DBMS_OUTPUT.PUT_LINE('Old Salary: ' || emp_sal_rec.last_name || ' - ' || emp_sal_rec.salary); 
    UPDATE employees 
    SET salary = salary + (salary * .025) 
    WHERE CURRENT OF emp_sal_cur;  -- current of your_cursor
 END LOOP; 

 -- Display the updated salaries 
 FOR emp_sal_rec IN emp_sal_cur LOOP 
    DBMS_OUTPUT.PUT_LINE('New Salary: ' || emp_sal_rec.last_name || ' - ' || emp_sal_rec.salary); 
 END LOOP; 
END;

```
An update on the `EMPLOYEES` table occurs with each iteration of the loop. The second loop in this 
example simply displays the new salary result for each employee that was returned by the cursor query. 
**How It Works**
Updating values when iterating a cursor can be handy(adj.便利的,手边的), especially when working with a number of(大量) rows.
There is one main difference between a cursor that allows updating and one(cursor) that does not. That
difference is the addition of the `FOR UPDATE` clause in the cursor declaration. By using the `FOR UPDATE`
clause of the `SELECT` statement, you are causing the database to lock the rows that have been read by the
query. This lock is to ensure that nobody else can modify the rows while you are working with them. The
lock creates a read-only block on the table rows so that if someone else attempts to modify them while
you have them locked, then they will have to wait until you have performed either a `COMMIT` or a `ROLLBACK`.
The `FOR UPDATE` clause has an optional `NOWAIT` keyword. By including this keyword, you will ensure
that your query does not block your transaction if someone else already has the rows that you are
querying blocked. The `NOWAIT` keyword tells Oracle not to wait if the requested rows are already locked,
and control is immediately passed back to your program so that it can continue to run. If the `NOWAIT`
keyword is omitted and the rows are already locked, then your program will stop and wait until the lock
has been released.

You can use the cursor with any style of loop, as you’ve seen in previous recipes. No matter which
type of loop you choose, the `UPDATE` must be coded using the `WHERE CURRENT OF your_cursor` clause to update the
current row in the cursor iteration. You will need to be sure to commit the changes after this block has
been run, and in many circumstances the `COMMIT` statement can be coded into this block once it has been
tested and verified to work correctly. As with any `UPDATE` statement, if you fail to `COMMIT` your changes,
then the UPDATE will not save any changes to the database, and the updated data will be visible to your
schema only until you disconnect. Issuing a `COMMIT` after your `UPDATE` statements have been issued is also
a good practice in this case because it will release the lock on the rows you had queried via the cursor so
that someone else can update them if needed. If you determine the data that was updated by the code
block is incorrect, then a `ROLLBACK` will also release the lock.

<text style="font-family:Courier New;color:red">

summary:</br>
1. if you wanna update data of cursor that returned by select, you can use `WHERE CURRENT OF emp_sal_cur` and `for update`
2. By using the `FOR UPDATE` clause of the `SELECT` statement,data lock is data level
3. wether `FOR UPDATE` clause update table data or cursor only?(it should be commit changes for table)
4. if you fail to `COMMIT` your changes,then the UPDATE will not save any changes to the database, and the updated data will be visible to your
schema only until you disconnec
5. `COMMIT` and `ROLLBACK` either release lock

</text> 

## 2.11. Deleting Rows Returned by a Cursor

**Problem**
There are a series of database rows that you’d like to delete. You’ve created a cursor `FOR LOOP`, and you want to delete some or all rows that have been queried with the cursor.
**Solution**
Use a `DELETE` statement within a `FOR LOOP` to delete the rows that are retrieved by the `cursor`. If you create a cursor using the `FOR UPDATE` clause, then you will be able to use the `WHERE CURRENT OF` clause along with the `DELETE` statement to eliminate the current row within each iteration of the cursor. The following example shows how this can be done to remove all job history for a given department ID:

```sql
CREATE OR REPLACE PROCEDURE remove_job_history(dept_id IN NUMBER) AS 

 CURSOR job_history_cur IS 
 SELECT * 
 FROM job_history 
 WHERE department_id = dept_id 
 FOR UPDATE; 
    job_history_rec job_history_cur%ROWTYPE; 
 BEGIN 
  FOR job_history_rec IN job_history_cur LOOP 
    DELETE FROM job_history WHERE CURRENT OF job_history_cur; 
    DBMS_OUTPUT.PUT_LINE('Job history removed for department ' || dept_id); 
  END LOOP; 
END; 
```
Using this technique, the job history for the department with the given ID will be removed from the `JOB_HISTORY` table.

**How It Works**
Much like updating rows using a cursor, the deletion of rows uses the `WHERE CURRENT OF` clause within the `DELETE` statement to remove each row. The cursor query must contain the `FOR UPDATE` clause in order to lock the rows that you are reading until a `COMMIT` or `ROLLBACK` has been issued. As mentioned in the previous recipe, the `NOWAIT` keyword is optional, and it can be used to allow control to be immediately returned to your program if someone else already has locks on the rows that you are interested in updating. In each iteration of the loop, the DELETE statement is used along with the `WHERE CURRENT OF` clause to remove the current cursor record from the database. Once the loop has been completed, then all the rows that had been queried via the cursor should have been deleted. This technique is especially useful if you are going to be performing some further processing on each of the records and then deleting them. One such case would be if you wanted to write each of the records to a history table prior to deleting them. In any case, the cursor `FOR loop` deletion technique is a great way to remove rows from the database and work with the data along the way.

## 2.12. Performing a Transaction

**Problem**
You need to complete a series of `INSERT` or `UPDATE` statements in order to process a complete transaction. In doing so, you need to ensure that if one of the statements fails, that all of the statements are canceled so that the transaction is not partially processed.
**Solution**
Use the transaction control mechanisms that are part of PL/SQL, as well as SQL itself, in order to control your transactions. When all your statements have been completed successfully, issue a `COMMIT` to make them final. On the other hand, if one of the statements does not complete successfully, then perform a `ROLLBACK` to undo all the other changes that have been made and bring the database back to the state that it was in prior(美['praɪɚ],adj.优先的,在先的,在前的) to the transaction occurring.In the following example, the code block entails the body of a script that is to be executed in order to create a new department and add some employees to it. The department change involves an INSERT and UPDATE statement to complete.
```sql
DECLARE
 -- Query all programmers who make more than 4000 
 -- as they will be moved to the new 'Web Development' department 
 CURSOR new_dept_cur IS 
    SELECT * 
    FROM employees 
    WHERE job_id = 'IT_PROG'
    AND salary > 4000 
    FOR UPDATE; 
 new_dept_rec         new_dept_cur%ROWTYPE; 
 current_department   departments.department_id%TYPE; 
BEGIN 
 -- Create a new department 
 INSERT INTO departments values( 
                                DEPARTMENTS_SEQ.nextval, -- Department ID (sequence value) 
                                'Web Development', -- Department Title 
                                103 -- Manager ID 
                                1700); -- Location ID 
 -- Obtain the current department ID…the new department ID 
 SELECT DEPARTMENTS_SEQ.currval 
 INTO current_department 
 FROM DUAL; 

 -- Assign all employees to the new department 
 FOR new_dept_rec IN new_dept_cur LOOP 
      UPDATE employees 
      SET department_id = current_department 
      WHERE CURRENT OF new_dept_cur; 
 END LOOP;

 COMMIT;
      DBMS_OUTPUT.PUT_LINE('The transaction has been successfully completed.'); 
END;
 ```
As you can see, a transaction was performed in this block of code. It is important to roll back changes if errors occur along the way so that the transaction is not partially completed.

**How It Works**
Transaction control is built into the Oracle Database. Any database changes that are made within a code block are visible to the current session only until a COMMIT has been made. The changes that have been made by the statements can be rolled back via the ROLLBACK command up until the point that a COMMIT is issued. Oracle uses table and row locks to ensure that data that has been updated in one session cannot be seen in another session until a COMMIT occurs. A transaction is started when the first statement after the last COMMIT or ROLLBACK is processed or when a session is created. It ends when a COMMIT or ROLLBACK occurs. A transaction is not bound to a single code block, and any code block may contain one or more transactions. Oracle provides a SAVEPOINT command, which places a marker at the current database state so as to allow you to roll back to that point in time in a transaction. Oracle Database automatically issues a SAVEPOINT prior to processing the first statement in any transaction.

As a rule of thumb, it is always a good idea to have exception handling in place in case an exceptionoccurs. However, if an unhandled exception occurs, then the database will roll back the statement that caused the exception, not the entire transaction. Therefore, it is up to the program to handle exceptions and issue the ROLLBACK command if the entire transaction should be undone. If a database crashes and goes down during a transaction, then when the database is restarted, all uncommitted statements are rolled back. All transactions are completed when a COMMIT or ROLLBACK is issued.


## 2.13. Ensuring That Multiple Queries "See" the Same Data

**Problem** 
You are issuing a set of queries against the database, and you need to ensure that none of the table rows change throughout the course of the queries being made. 
**Solution**
Set up a read-only transaction in which the current transaction will see the data only as an unchanged snapshot in time. To do so, use the SET TRANSACTION statement to begin a read-only transaction and establish a snapshot of the data so it will be consistent and unchanged from all other updates being made. For instance, the following example displays a block that sets up read-only queries against the database for dollar values from a bank account:
```sql
DECLARE 
 daily_atm_total NUMBER(12,2); 
 weekly_atm_total NUMBER(12,2); 
BEGIN 
 COMMIT; -- ends previous transaction 
 SET TRANSACTION READ ONLY NAME 'ATM Weekly Summary'; 
 SELECT SUM (wd_amt) INTO daily_atm_total FROM atm_withdrawals 
 WHERE to_char(wd_date, 'MM-DD-YYYY') = to_char(SYSDATE, 'MM-DD-YYYY'); 
 SELECT SUM (weekly_total) INTO weekly_atm_total FROM atm_withdrawals 
 WHERE to_char(wd_date, 'MM-DD-YYYY') = to_char(SYSDATE - 7, 'MM-DD-YYYY'); 
 DBMS_OUTPUT.PUT_LINE(daily_atm_total || ' - ' || weekly_atm_total); 
 COMMIT; -- ends read-only transaction 
END; 
```
Querying the database using read-only transactions will ensure that someone will see the correct values in a situation such as the one depicted(vt.描述,描画) in this example.

**How It Works**
often times there are situations when you need to ensure that the data being queried throughout a transaction’s life cycle is unchanged by other users’ updates. The classic case is when someone goes to withdraw money from the bank and their spouse(n.配偶) is at an ATM machine depositing into the account at the same time. If read consistency were not in place, the individual may view their account balance and see that there was plenty of money to withdraw, and then they’d go to take the money out and receive an error because the spouse had canceled the deposit(美 [dɪ'pɑzɪt]n.存款,押金) instead. A read-only transaction allows for read consistency until a `COMMIT` has been issued. If the spouse had confirmed the deposit, then the next query on the account would reflect the additional funds (assuming that the bank were to release them to the account in real time).
Situations such as these require that you provide an environment that is essentially isolated from the outside world. You can use the SET TRANSACTION command to start a read-only transaction, set an isolation level, and assign the current transaction to a `rollback` segment. The SET TRANSACTION statement must be the first statement in a read-only transaction, and it can appear only once in the transaction. Note that there are some statement restrictions when using a read-only transaction. Only `SELECT INTO`, `OPEN`, `FETCH`, `CLOSE`, `LOCK TABLE`, `COMMIT`, and `ROLLBACK` statements can be used; other statements are not allowed.

## 2.14. Executing One Transaction from Within Another
(nested tracsaction)
**Problem**
You are executing a transaction, and you are faced with the need to suspend your current work, issue a completely separate transaction, and then pick up your current work. For example, say you want to log entries into a log table. The log entries should be persisted separately from the current transaction such that if the transaction fails or is rolled back, the log entries will still be completed.
**Solution**
Start an autonomous transaction to make the log entry. This will ensure that the log entry is performed separately from the current transaction. In the following example, an employee is deleted from the EMPLOYEES table. Hence, a job is ended, and the job history must be recorded into the `JOB_HISTORY` table. In the case that something fails within the transaction, the log entry into the `JOB_HISTORY` table must be intact(adj.完整的,原封不动的). This log entry cannot be rolled back because it is performed using an autonomous transaction.The code to encapsulate(美 [ɪn'kæpsjə'let],vt.压缩,将…装入胶囊) the autonomous transaction needs to be placed into a named block that can be called when the logging needs to be performed. The following piece of code creates a PL/SQL procedure that performs the log entry using an autonomous transaction. (You will learn more about procedures in Chapter 4.) Specifically notice(n.通知,布告) the declaration of `PRAGMA AUTONOMOUS_TRANSACTION`. That pragma specifies that the procedure executes as a separate transaction, independent of any calling transaction.
```sql
CREATE OR REPLACE PROCEDURE log_job_history ( emp_id IN 
                                              employees.employee_id%TYPE, 
                                              Job_id IN jobs.job_id%TYPE, 
                                              Department_id IN employees.department_id%TYPE, 
                                              employee_start IN DATE) AS 
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
 INSERT INTO job_history 
 VALUES (emp_id, 
 employee_start, 
 sysdate, 
 job_id, 
 department_id); 
 COMMIT; 
END;

```
The `LOG_JOB_HISTORY` procedure inserts an entry into the log table separately from the transaction that is taking place in the calling code block. The following code performs the job termination, and it calls the `log_substitution` procedure to record the history:
```sql
DECLARE
 CURSOR dept_removal_cur IS 
    SELECT * 
    FROM employees 
    WHERE department_id = 10 
    FOR UPDATE; 
 dept_removal_rec dept_removal_cur%ROWTYPE; 
BEGIN 
 -- Delete all employees from the database who reside in department 10 
 FOR dept_removal_rec IN dept_removal_cur LOOP 
    DBMS_OUTPUT.PUT_LINE('DELETING RECORD NOW'); 
    DELETE FROM employees WHERE CURRENT OF dept_removal_cur; 
    -- Log the termination 
    log_job_history(dept_removal_rec.employee_id, 
                      dept_removal_rec.job_id, 
                      dept_removal_rec.department_id, 
                      dept_removal_rec.hire_date);
 END LOOP; 
    DBMS_OUTPUT.PUT_LINE('The transaction has been successfully completed.'); 
EXCEPTION 
 -- Handles all errors 
 WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('The transaction has been rolled back due to errors, please try again.'); 
    ROLLBACK; 
END;
```
If this code block is executed and then rolled back, the entry into the job history table remains,because it is performed as a separate, autonomous transaction.
**How It Works**
An autonomous transaction is a transaction that is called by another transaction and that runs separately from the calling transaction. Autonomous transactions commit or roll back without affecting the calling transaction. They also have the full functionality of regular transactions; they merely(adv.仅仅,只不过,只是) run separately from the main transaction. They allow parallel activity to occur. Even if the main transaction fails or is rolled back, the autonomous transaction can be committed or rolled back independently of any other transactions in progress.

An autonomous transaction must be created with a top-level code block, trigger, procedure,function, or stand-alone named piece of code. In the solution, you saw that a procedure was created to run as an autonomous transaction. That is because it is not possible to create an autonomous transaction within a nested code block. To name a transaction as autonomous, you must place the statement PRAGMA AUTONOMOUS_TRANSACTION within the declaration section of a block encompassing(adj.包含的,包容的,环绕) the transaction. To end the transaction, perform a COMMIT or ROLLBACK.

<text style="font-family:Courier New;color:red">

summary: </br>
1. They allow parallel activity to occur. Even if the main transaction fails or is rolled back, the autonomous transaction can be committed or rolled back independently of any other transactions in progress.

</text>

## 2.15. Finding and Removing Duplicate Table Rows

**Problem**
You have found that for some reason your database contains a table that has duplicate records. You areworking with a database that unfortunately does not use primary key values, so you must manually enforce data integrity. You need a way to remove the duplicate records. However, any query you write to remove one record will also remove its duplicate.
**Solution**
The solution to this issue involves two steps. First you need to query the database to find all duplicaterows, and then you need to run a statement to delete one of each duplicate record that is found.The following code block queries the EMPLOYEES table for duplicate rows. When a duplicate is found,it is returned along with a count of duplicates found.
```sql
<<duplicate_emp_qry>>
DECLARE
CURSOR emp_cur IS
  SELECT *
  FROM employees
  ORDER BY employee_id;
  emp_count
  number := 0;
  total_count
  number := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('You will see each duplicated employee listed more ');
  DBMS_OUTPUT.PUT_LINE('than once in the list below. This will allow you to ');
  DBMS_OUTPUT.PUT_LINE('review the list and ensure that indeed...there are more ');
  DBMS_OUTPUT.PUT_LINE('than one of these employee records in the table.');
  DBMS_OUTPUT.PUT_LINE('Duplicated Employees: ');
-- Loop through each player in the table
FOR emp_rec IN emp_cur LOOP
-- Select the number of records in the table that have the same ID as the current record
SELECT count(*)
INTO emp_count
FROM employees
WHERE employee_id = emp_rec.employee_id;
-- If the count is greater than one then a duplicate has been found, so print it out.
IF emp_count > 1 THEN 
 DBMS_OUTPUT.PUT_LINE(emp_rec.employee_id || ' - ' || emp_rec.first_name || ' ' || emp_rec.last_name || ' - ' || emp_count); 
 total_count := total_count + 1; 
 END IF; 
 END LOOP; 
END;
```
If the table includes a duplicate, then it is printed out as follows:
You will see each duplicated employee listed more than once in the list below. This will allow you to review the list and ensure that indeed...there are more 
than one of these employees in the table.
Duplicated Employees:
100 - Steven King - 2
100 – Steven King - 2
PL/SQL procedure successfully completed.  

Next, you need to delete the duplicated rows that have been found. The following DELETE statement
will ensure that one of the duplicates is removed:
DELETE FROM employees A WHERE ROWID > (
SELECT min(rowid) FROM employees B
WHERE A.employee_id = B.employee_id);

**How It Works**
Usually using primary keys prohibits the entry of duplicate rows into a database table. However, many legacy databases still in use today do not include such constraints. In rare situations, a duplicate key and values are entered into the database that can cause issues when querying data or assigning values. The method shown in the solution for finding duplicate rows is very basic. The solution loops through each record in the table, and during each pass, it queries the table for the number of records found that match the current record’s EMPLOYEE_ID. If the number found is greater than one, then you know that you have found a duplicate. The solution presented here for finding duplicates will work on any table provided that you have a column of data that should contain logically unique values. In the example, each record should contain a different EMPLOYEE_ID, so if there is more than one record with the same EMPLOYEE_ID value, then a duplicate is found. If the table you are working with does not contain any unique columns, then you can concatenate a number of columns in order to obtain a unique combination. For instance, if EMPLOYEES did not contain an EMPLOYEE_ID column, then you could concatenate the FIRST_NAME, LAST_NAME, and EMAIL columns to obtain a unique combination. More likely than not, there will not be two employees in the table with the same name and e-mail address. The second part of the solution involves removing one or more duplicate records from the set. To do so, you have to look at a pseudocolumn known as the ROWID. The ROWID is a pseudocolumn (invisible column) that is found in each table in an Oracle Database that uniquely identifies each row. By comparing these unique ROWID values, you can delete just one of the records, not both. The DELETE statement actually finds the rows that contain the same uniquely identified column(s) and then removes the row with the larger ROWID value.

# 3. Looping and Logic

## 3.1. Choosing When to Execute Code

**Problem**
Your code contains a condition, and you are interested in executing code to perform specific actions if the condition evaluates to `TRUE`, `FALSE`, or `NULL`. 
**Solution** 
Use an `IF-THEN` statement to evaluate an expression (or condition) and determine which code to execute 
as a result. The following example depicts a very simple `IF-THEN` statement that evaluates one variable to see whether it contains a larger value than another variable. If so, then the statements contained within the `IF-THEN` statement are executed; otherwise, they are ignored. 
```sql
DECLARE 
 value_one NUMBER := &value_one; 
 value_two NUMBER := &value_two; 
BEGIN 
 IF value_one > value_two THEN 
 DBMS_OUTPUT.PUT_LINE('value_one is greater than value_two'); 
 END IF; 
END; 
```
As you can see from the example, if value_one is greater than value_two, a line of output will be printed stating so. Otherwise, the IF statement is bypassed, and processing continues. 
**How It Works** 
As shown in the solution, the general format for the IF-THEN statement is as follows:
```sql
IF condition THEN
 Statements to be executed 
 …
END IF; 
```
The `IF-THEN` statement is one of the most frequently used conditional statements. If a given condition evaluates to `TRUE`, then the code contained within the IF-THEN statement is executed. If the condition evaluates to FALSE or NULL, then the statement is exited. However, it is possible to incorporate(vt.包含,吸收) a different set of statements if the condition is not satisfied. Please see Recipe 3-2 for an example. Any number of `IF-THEN` statements can be nested within one another. The statements within the `IF-THEN` will be executed if the condition that is specified evaluates to `TRUE`.

## 3-2. Choosing Between Two Mutually Exclusive Conditions
**Problem** 
You have two conditions that are mutually(美 ['mjutʃuəli]adv.互相地,互助) exclusive. You want to execute one set of statements if the 
first condition evaluates to TRUE. Otherwise, if the first condition is FALSE or NULL, then execute a different 
set of statements. 
**Solution** 
Use an IF-ELSE statement to evaluate the condition and execute the statements that correspond to it if 
the condition evaluates to TRUE. In the following example, a given employee ID is used to query the 
EMPLOYEES table. If that employee exists, then the employee record will be retrieved. If not found, then a 
message will be displayed stating that no match was found. 
```sql
DECLARE 
 employee employees%ROWTYPE; 
 emp_count number := 0; 
BEGIN 
 SELECT count(*) 
 INTO emp_count 
 FROM employees 
 WHERE employee_id = 100; 
 IF emp_count > 0 THEN 
 SELECT * 
 INTO employee 
 FROM employees 
 WHERE employee_id = 100; 
 IF employee.manager_id IS NOT NULL THEN 
 DBMS_OUTPUT.PUT_LINE(employee.first_name || ' ' || employee.last_name || 
 ' has an assigned manager.'); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE(employee.first_name || ' ' || employee.last_name || 
 ' does not have an assigned manager.'); 
END IF; 
 ELSE 
 DBMS_OUTPUT.PUT_LINE('The given employee ID does not match any records, '|| 
 ' please try again'); 
 END IF; 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE('Try another employee ID.'); 
END; 
```
In the real world, the employee ID would not be hard-coded into the example. However, this example provides a good scenario for evaluating mutually exclusive conditions and also nesting IF statements. 
**How It Works**
The `IF-ELSE` statement syntax is basically the same as the `IF-THEN` syntax, except that a different set of 
statements is executed in the ELSE clause when the condition evaluates to FALSE or NULL. Therefore, if the 
first condition is FALSE or NULL, then the control automatically drops down into the statements contained 
within the ELSE clause and executes them.

## 3.3. Evaluating Multiple Mutually Exclusive Conditions

**Problem**
Your application has multiple conditions to evaluate, and each of them is mutually exclusive. If one of 
the conditions evaluates to FALSE, you’d like to evaluate the next one. You want that process to continue 
until there are no more conditions. 
Two solutions are possible: one using IF and the other using `CASE`.

**Solution #1**
Use an `IF-ELSIF-ELSE` statement to perform an evaluation of all mutually exclusive conditions. The following example is a SQL*Plus script that queries how many countries are in a specified region.

If the region that is typed as input when the following example executes matches any of the regions specified by the conditions in the IF statement, then subsequent statements are executed. However, a default message is displayed if the input does not match any region.

```sql
DECLARE
 Region regions.region_name%TYPE := '&region'; 
 country_count number := 0; 
BEGIN 
 IF upper(region) = 'EUROPE' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 1; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 'the Europe region.'); 
 ELSIF upper(region) = 'AMERICAS' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 2; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Americas region.'); 
 ELSIF upper(region) = 'ASIA' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 3; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Asia region.'); 
 ELSIF upper(region) = 'MIDDLE EAST AND AFRICA' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 4; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Middle East and Africa region.'); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE('You have entered an invaid region, please try again'); 
 END IF; 
END; 
```
**Solution #2**
You can use the searched `CASE` statement to evaluate a boolean expression to determine which statements to execute among multiple, mutually exclusive conditions. The next example is a SQL*Plus script that performs the same tasks as **Solution #1** but this time using a searched `CASE` statement:
```sql
DECLARE
 region regions.region_name%TYPE := '&region'; 
 country_count number := 0; 
BEGIN 
 CASE 
 WHEN upper(region) = 'EUROPE' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 1; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Europe region.'); 
 WHEN upper(region) = 'AMERICAS' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 2; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Americas region.'); 
 WHEN upper(region) = 'ASIA' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 3; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Asia region.'); 
 WHEN upper(region) = 'MIDDLE EAST AND AFRICA' THEN 
 SELECT count(*) 
 INTO country_count 
 FROM countries 
 WHERE region_id = 4; 
 DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 
 'the Middle East and Africa region.'); 
 ELSE 
 DBMS_OUTPUT.PUT_LINE('You have entered an invaid region, please try again'); 
 END CASE; 
END; 

```
**How It Works**
IF-ELSIF-ELSE can be used to evaluate any number of conditions. It functions such that if the first 
condition in the IF-ELSIF-ELSE statement evaluates to TRUE, then the statements within its block are 
executed, and all others are bypassed. Similarly, if the first condition evaluates to FALSE and the second 
condition evaluates to TRUE, then the second condition’s statements will be executed, others will be 
ignored, and so on.
```sql
CASE
 WHEN <<boolean_expression>> THEN <<statements>> 
[ELSE statements]; 
```


## 3.4 Driving from an Expression Having Multiple Outcomes

**Problem**
You have a single expression that yields multiple outcomes. You are interested in evaluating the expression and performing a different set of statements depending upon the outcome. 
**Solution** 
Use a CASE statement to evaluate your expression, and decide which set of statements to execute depending upon the outcome. In the following example, a SQL*Plus script accepts a region entry, which is being evaluated to determine the set of statements to be executed. Based upon the value of the region, the corresponding set of statements is executed, and once those statements have been executed, then the control is passed to the statement immediately following the CASE statement. 
```sql
DECLARE 
 region regions.region_name%TYPE := '&region'; 
 country_count number := 0; 
BEGIN 
 CASE upper(region) 
 WHEN 'EUROPE' THEN 
    SELECT count(*) 
    INTO country_count 
    FROM countries 
    WHERE region_id = 1; 
    DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 'the Europe region.'); 
 WHEN 'AMERICAS' THEN 
    SELECT count(*) 
    INTO country_count 
    FROM countries 
    WHERE region_id = 2; 
    DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' ||'the Americas region.'); 
 WHEN 'ASIA' THEN 
    SELECT count(*) 
    INTO country_count 
    FROM countries 
    WHERE region_id = 3; 
    DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 'the Asia region.'); 
 WHEN 'MIDDLE EAST AND AFRICA' THEN 
    SELECT count(*) 
    INTO country_count 
    FROM countries 
    WHERE region_id = 4; 
    DBMS_OUTPUT.PUT_LINE('There are ' || country_count || ' countries in ' || 'the Middle East and Africa region.'); 
 ELSE 
    DBMS_OUTPUT.PUT_LINE('You have entered an invaid region, please try again'); 
 END CASE; 
END; 

```

**How It Works**
There are two different types of CASE statements that can be used—those being the searched CASE and the simple CASE statement. The solution to this recipe demonstrates the simple CASE. For an example of a searched CASE statement, please see Recipe 3-3.

The simple CASE statement begins with the keyword CASE followed by a single expression called a selector. The selector is evaluated one time, and it can evaluate to any PL/SQL type other than BLOB, BFILE, an object type, a record, or a collection type. The selector is followed by a series of WHEN clauses. The WHEN clauses are evaluated sequentially to determine whether the value of the selector equals the result from any of the WHEN clause expressions. If a match is found, then the corresponding WHEN clause is executed.

The CASE statement can include any number of WHEN clauses, and much like an IF statement, it can be followed with a trailing ELSE clause that will be executed if none of the WHEN expressions matches. If the ELSE clause is omitted, a predefined exception will be raised if the CASE statement does not match any of the WHEN clauses. The END CASE keywords end the statement.

## 3.5. Looping Until a Specified Condition Is Met

**Problem**
You want to loop through a set of statements until a specified condition evaluates to true. 
**Solution**
Use a simple `LOOP` statement along with an `EXIT` clause to define a condition that will end the iteration.
The following example shows a simple LOOP that will print out each employee with a department_id equal
to 90:
```sql
DECLARE
CURSOR emp_cur IS
SELECT *
FROM employees
WHERE department_id = 90;
emp_rec employees%ROWTYPE;

BEGIN
OPEN emp_cur;
LOOP
  FETCH emp_cur into emp_rec;
  IF emp_cur%FOUND THEN
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name ||'-'|| emp_rec.email);
  ELSE
    EXIT;
  END IF;
END LOOP;
CLOSE emp_cur;
END;

```

As you can see from the example, the cursor is opened prior to the start of the loop. Inside the loop,
the cursor is fetched into emp_rec, and emp_rec is evaluated to see whether it contains anything using the
cursor %FOUND attribute. If emp_cur%FOUND is FALSE, then the loop is exited using the EXIT keyword.
**How It Works**
The simple LOOP structure is very easy to use for generating a loop in your code. The LOOP keyword is used
to start the loop, and the END LOOP keywords are used to terminate it. Every simple loop must contain an
EXIT or GOTO statement; otherwise, the loop will become infinite and run indefinitely.
You can use a couple of different styles for the EXIT. When used alone, the EXIT keyword causes a
loop to be terminated immediately, and control is passed to the first statement following the loop. You
can use the EXIT-WHEN statement to terminate the loop based upon the evaluation of a condition after the
WHEN statement. If the condition evaluates to TRUE, then the loop is terminated; otherwise, it will
continue.
The following example shows the same LOOP as the example in the solution, but instead of using an
IF statement to evaluate the content of emp_rec, the `EXIT-WHEN` statement is used:
```sql
DECLARE
CURSOR emp_cur IS
SELECT *
FROM employees
WHERE department_id = 90;
emp_rec employees%ROWTYPE;
BEGIN
OPEN emp_cur;
 LOOP 
 FETCH emp_cur into emp_rec; 
 EXIT WHEN emp_cur%NOTFOUND; 
      DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || '-' || emp_rec.email); 
 END LOOP; 
 CLOSE emp_cur; 
END; 
```
You can use a loop to iterate over any number of things including cursors or collections of data. As
you will see in some of the coming recipes, different forms of loops work better in different 
circumstances. 

## 3.6. Iterating Cursor Results Until All Rows Have Been Returned
**Problem**
You have created a cursor and retrieved a number of rows from the database. As a result, you want to 
loop through the results and do some processing on them. 
**Solution** 
Use a standard FOR loop to iterate through the records. Within each iteration of the loop, process the 
current record. The following code shows the use of a FOR loop to iterate through the records retrieved 
from the cursor and display each employee name and e-mail. Each iteration of the loop returns an 
employee with the job_id of 'ST_MAN', and the loop will continue to execute until the cursor has been 
exhausted.
```sql
DECLARE 
 CURSOR emp_cur IS 
 SELECT * 
 FROM employees 
 WHERE job_id = 'ST_MAN'; 
 emp_rec employees%ROWTYPE; 
BEGIN 
 FOR emp_rec IN emp_cur LOOP 
 DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || 
 ' - ' || emp_rec.email); 
 END LOOP; 
END; 
```

Here are the results:
Matthew Weiss - MWEISS
Adam Fripp - AFRIPP
Payam Kaufling - PKAUFLIN
Shanta Vollman - SVOLLMAN
Kevin Mourgos - KMOURGOS
PL/SQL procedure successfully completed

As you can see, the employee records that meet the specified criteria are displayed.

## 3.7. Iterating Until a Condition Evaluates to FALSE

**Problem**
You want to iterate over a series of statements until a specified condition no longer evaluates to TRUE. 
**Solution** 
Use a WHILE statement to test the condition, and execute the series of statements if the condition 
evaluates to TRUE; otherwise, skip the statements completely. The following example shows a WHILE
statement evaluating the current value of a variable and looping through until the value of the variable 
reaches ten. Within the loop, this variable is being multiplied by two and printing out its current value.
```sql
DECLARE 
 myValue NUMBER := 1; 
BEGIN 
WHILE myValue < 10 LOOP 
 DBMS_OUTPUT.PUT_LINE('The current value is: ' || myValue); 
 myValue := myValue * 2; 
 END LOOP;
END;
```

Here are the results: 
The current value is: 1 
The current value is: 2 
The current value is: 4 
The current value is: 8 
PL/SQL procedure successfully completed. 
The important thing to note in this example is that the value of myValue is increased with each 
iteration of the loop as to eventually meet the condition specified in the `WHILE` loop.

**How It Works**
The WHILE loop tests a condition at the top of the loop, and if it evaluates to TRUE, then the statements within the loop are executed, and control is returned to the start of the loop where the condition is tested again. If the condition does not evaluate to TRUE, the loop is bypassed, and control goes to the next statement after the END LOOP. If the condition never fails, then an infinite loop is formed, so it is important to ensure that the condition will eventually evaluate to FALSE. It is important to note that the statements in the loop will never be executed if the condition evaluates to FALSE during the first pass. This situation is different from the simple loop that always 
iterates at least once because the EXIT condition is usually evaluated elsewhere in the loop. To ensure that a WHILE loop is always executed at least one time, you must ensure that the condition evaluates to TRUE at least once. One way to do this is to use a flag variable that is evaluated with each iteration of the loop. Set the flag equal to FALSE prior to starting the loop, and then set it to TRUE when a certain condition is met inside the loop. The following pseudocode depicts such a solution:
```
BEGIN 
 flag = FALSE; 
 WHILE flag = TRUE LOOP 
Perform statements 
 flag = Boolean expression; 
 END LOOP; 
END; 
```
As mentioned previously, the boolean expression that is assigned to the flag in this case must 
eventually evaluate to FALSE; otherwise, an infinite loop will occur.

## 3.8.Bypassing the Current Loop Iteration
**Problem**
If a specified conditional statement evaluates to TRUE, you want to terminate the current loop iteration of 
the loop early and start the next iteration immediately.
**Solution** 
Use a CONTINUE statement along with a condition to end the current iteration. In the following example, a loop is used to iterate through the records in the employees table. The primary reason for the loop is to print out a list of employees who receive a salary greater than 15,000. If an employee does not receive more than 15,000, then nothing is printed out, and the loop continues to the next iteration.

```sql
DECLARE 
    CURSOR emp_cur is 
    SELECT * 
    FROM employees; 
    emp_rec emp_cur%ROWTYPE; 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Employees with salary > 15000: '); 
OPEN emp_cur;
 LOOP 
 FETCH emp_cur INTO emp_rec; 
 EXIT WHEN emp_cur%NOTFOUND; 
 IF emp_rec.salary < 15000 THEN 
 CONTINUE;
 ELSE 
    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_rec.first_name || ' ' || emp_rec.last_name); 
 END IF; 
 END LOOP; 
 CLOSE emp_cur; 
END; 
 ```

Here are some sample results:
Employees with salary > 15000:
Employee: Steven King
Employee: Neena Kochhar
Employee: Lex De Haan
PL/SQL procedure successfully completed.
**How It Works**
You can use the CONTINUE statement in any loop to unconditionally halt execution of the current iteration 
of the loop and move to the next. As shown in the solution, the CONTINUE statement is usually 
encompassed within some conditional statement so that it is invoked only when that certain condition 
is met. 

You can use the CONTINUE statement along with a label in order to jump to a specified point in the 
program. Rather than merely using CONTINUE to bypass the current loop iteration, specifying a label will 
allow you to resume programming in an outer loop. For more information regarding the use of the 
CONTINUE statement along with labels in nested loops, please see Recipe 3-13. 
As an alternative to specifying CONTINUE from within an IF statement, you can choose to write a 
CONTINUE WHEN statement. For example, the following two approaches yield identical results: 

```sql
 IF team_rec.total_points < 10 THEN 
 CONTINUE; 
or 
 CONTINUE WHEN rec.total_points < 10; 
```

Using the `CONTINUE WHEN` format, the loop will stop its current iteration if the condition in the WHEN
clause is met. Otherwise, the iteration will ignore the statement altogether.

## 3.9. Iterating a Fixed Number of Times

**Problem**
You are interested in executing the contents of a loop a specified number of times. For example, you are
interested in executing a loop ten times, and you need to number each line of output in the range by the
current loop index.
**Solution**
Write a FOR loop. Use a variable to store the current index of the loop while looping through a range of
numbers from one to ten in ascending order. The following lines of code will iterate ten times through a
loop and print out the current index in each pass:

```sql
BEGIN 
 FOR idx IN 1..10 LOOP 
 DBMS_OUTPUT.PUT_LINE('The current index is: ' || idx); 
 END LOOP; 
END;
```
```
Here is the result: 
The current index is: 1 
The current index is: 2 
The current index is: 3 
The current index is: 4 
The current index is: 5 
The current index is: 6 
The current index is: 7 
The current index is: 8 
The current index is: 9
The current index is: 10
```
PL/SQL procedure successfully completed.
**How It Works**
The FOR loop will increment by one through the given range for each iteration until it reaches the end. 
The loop is opened using the keyword FOR, followed by a variable that will be used as the index for the 
loop. Following the index variable is the IN keyword, which is used to signify that the index variable 
should increment one by one through the given range, which is listed after the IN keyword. The loop is 
terminated using the END LOOP keywords. 
Each statement contained within the loop is executed once for each iteration of the loop. The index 
variable can be used within the loop, but it cannot be changed. As shown in the solution, you may use 
the index for printing purposes, and it is oftentimes used in calculations as well.
The REVERSE keyword should be placed directly after the IN keyword and before the range that you
specify. The REVERSE keyword has no effect when working with cursors. If you need to iterate through 
cursor results in a specific order, then specify an ORDER BY clause in your SELECT statement. 

## Iterating in Increments Other Than One

3-11. Iterating in Increments Other Than One
**Problem**
Rather than iterating through a range of numbers one at a time, you want to increment by some other 
value. For example, you might want to increment through even values such as 2, 4, 6, and so forth. 
**Solution** 
Multiply the loop index by two (or by whatever other multiplier you need) to achieve the effect of 
incrementing through all even numbers. As you can see in the following example, an even number is 
always generated when the index is multiplied by two: 
```
BEGIN 
 FOR idx IN 1..5 LOOP 
 DBMS_OUTPUT.PUT_LINE('The current index is: ' || idx*2); 
 END LOOP; 
END;
``` 
Here is the result: 
The current index is: 2 
The current index is: 4 
The current index is: 6 
The current index is: 8 
The current index is: 10 
PL/SQL procedure successfully completed. 
**How It Works**
Unlike some other languages, PL/SQL does not include a STEP clause that can be used while looping. To 
work around that limitation, you will need to write your own stepping algorithm. In the solution to this 
recipe, you can see that the algorithm was quite easy; you simply multiply the index by two to achieve 
the desired result. In this solution, assigning the range of 1..5 as the index produces the effect of iterating 
through all even numbers from 2..10 when the current index is multiplied by two. 
Using similar techniques, you can increment through ranges of numbers in various intervals. 
However, sometimes this can become troublesome if you are attempting to step by anything other than 
even numbers. You can see an example of this in the next recipe.

## 3.12. Stepping Through a Loop Based on Odd-Numbered Increments

**Problem**
Rather than iterating through a range of numbers by even increments, you prefer to loop through the 
range using odd increments. 
**Solution**
Use the built-in MOD function to determine whether the current index is odd. If it is odd, then print out 
the value; otherwise, continue to the next iteration. The following example shows how to implement this 
solution:

```sql
BEGIN 
 FOR idx IN 1..10 LOOP 
 IF MOD(idx,2) != 0 THEN 
 DBMS_OUTPUT.PUT_LINE('The current index is: ' || idx); 
 END IF; 
 END LOOP; 
END; 
```

Results: 
The current index is: 1
The current index is: 3
The current index is: 5
The current index is: 7
The current index is: 9
PL/SQL procedure successfully completed.
**How It Works**
The solution depicts one possible workaround for a STEP replacement. Using the MOD function to 
determine whether a number is odd works quite well. The MOD function, otherwise known as the modulus 
function, is used to return the remainder from the division of the two numbers that are passed into the 
function. Therefore, this function is useful for determining even or odd numbers. In this case, if any 
value is returned from MOD, then the number is assumed to be odd, and the statements within the IF
statement will be executed.
Such a technique may be useful in the case of iterating through a collection of data such as a table. If 
you want to grab every other record from the collection, then performing a stepping solution such as this 
or the solution from Recipe 3-11 will allow you to achieve the desired result. You could easily use the 
resulting index from this technique as the index for a collection.

## 3.13. Exiting an Outer Loop Prematurely
**Problem** 
Your code contains a nested loop, and you want the inner loop to have the ability to exit from both loops 
and stop iteration completely. 
**Solution**
Use loop labels for both loops and then reference either loop within an EXIT statement by following the 
EXIT keyword with a loop label. The following example prints out a series of numbers. During each 
iteration, the inner loop will increment until it reaches an odd number. At that point, it will pass control 
to the outer loop again. The outer loop will be exited when the index for the inner loop is greater than or 
equal to the number ten. 
```sql
BEGIN 
 <<outer>> for idx1 in 1 .. 10 loop 
 <<inner>> for idx2 in 1 .. 10 loop 
 dbms_output.put(idx2); 
 exit inner when idx2 > idx1 * 2; 
 exit outer when idx2 = 10; 
 END LOOP; 
 DBMS_OUTPUT.NEW_LINE; 
 END LOOP; 
 DBMS_OUTPUT.NEW_LINE; 
END;
```
Results: 
123 
12345 
1234567 
123456789 
12345678910 
PL/SQL procedure successfully completed. 
**How It Works** 
Any loop in PL/SQL can be labeled using a similar style to labels for code blocks. The label can be any 
valid identifier surrounded by angle brackets before the loop, and optionally the identifier can be placed 
at the end after the END LOOP clause. The result of such a labeling mechanism is that you will have a 
distinct start and end to the loops and more control over loop execution. 
In the solution to this recipe, the label helps identify the outer loop so that it can be terminated with 
the EXIT clause. Without a label, the EXIT will terminate the innermost FOR loop. However, the label can 
also be used to help identify the loop’s index. In the solution, this is not necessary because the outer loop 
index was named differently than the inner loop index. If both indexes were named the same, then you 
could use the loop label along with the index name to fully qualify the index. The following example 
demonstrates this technique:

```sql
BEGIN
<<outer>> FOR idx IN 1 .. 10 LOOP
<<inner>> FOR idx IN 1 .. 10 LOOP
  DBMS_OUTPUT.PUT(inner.idx);
EXIT inner WHEN inner.idx > outer.idx * 2;
EXIT outer WHEN inner.idx = 10;
END LOOP;
  DBMS_OUTPUT.NEW_LINE;
END LOOP;
  DBMS_OUTPUT.NEW_LINE;
END;
```

This code will display the same results as the example given in the solution to this recipe. The only
difference is that in this example the index name is the same in both the inner and outer loops. An
alternative technique to end the current iteration of an inner loop is to use the CONTINUE statement. A
CONTINUE statement can reference the label of a loop that is within the same scope. Therefore, an inner
loop can exit its current iteration and proceed to an outer loop, as the following example demonstrates:
```sql

BEGIN
<<outer>> for idx1 in 1 .. 10 loop
<<inner>> for idx2 in 1 .. 10 loop
dbms_output.put(idx2);
exit inner when idx2 > idx1 * 2;
exit outer when idx2 = 10;
END LOOP;
CONTINUE outer;
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;
```
In this example, the same code that is used in the solution to this recipe is rewritten to incorporate a
CONTINUE statement. This statement is used to move control of execution back to the outer loop. When
the CONTINUE statement is reached, execution of the current loop is immediately halted, and processing
continues to the loop designated by the label.

## 3.14. Jumping to a Designated Location in Code

**Problem**
You want your code to stop executing and jump to a different, designated location.
**Solution**
Use a GOTO statement along with a label name to cause code execution to jump into the position where
the label is located.
The following example shows the GOTO statement in action. The user is prompted to enter a numeric
value, and that value is then evaluated to determine whether it is greater than ten. In either case, a
message is printed, and then the code jumps to the end_msg label. If the number entered is a negative
number, then the code jumps to the bad_input label where an error message is printed.

```sql
DECLARE
 in_number number := 0; 
BEGIN 
 in_number := '&input_number'; 
 IF in_number > 10 THEN 
 DBMS_OUTPUT.PUT_LINE('The number you entered is greater than ten'); 
 GOTO end_msg; 
 ELSIF in_number <= 10 and in_number > 0 THEN 
 DBMS_OUTPUT.PUT_LINE('The number you entered is less than or equal to ten'); 
 GOTO end_msg; 
 ELSE 
 -- Entered a negative number 
 GOTO bad_input; 
 END IF; 
 << bad_input >> 
 DBMS_OUTPUT.PUT_LINE('Invalid input. No negatives allowed.'); 
 << end_msg >> 
 DBMS_OUTPUT.PUT_LINE('Thank you for playing..'); 
END; 
```
**How It Works**
The GOTO statement is used to branch code unconditionally. Code can be branched to any label within 
the same scope as the GOTO. In the solution, the GOTO statement causes the code to branch to a parent 
code block. You could just as easily branch to a loop within the current or outer block. However, you 
cannot branch to a label within a subblock, IF statement, or LOOP. 

You should use this statement sparingly because arbitrary branching makes code difficult to read. Use 
conditional statements to branch whenever possible, because that’s why they were put into the 
language. As you can see from the solution, the same code could have been written printing the “Invalid 
number” message within the ELSE clause. There are usually better alternatives to using GOTO. 