---
title: Oracle PLSQL Recipes
categories: 
- oracle
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/198889780-c943df8e-6c61-4f43-a017-5b451d79588a.jpg
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
summary: 
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