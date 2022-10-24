---
title: Oracle PLSQL Recipes
categories: 
- oracle
---

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