---
title: Oracle PLSQL Recipes 08-Dynamic SQL
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


 
# 8. Dynamic SQL 
Oracle provides dynamic SQL as a means for generating DML or DDL at runtime. It can be useful when 
the full text of a SQL statement or query is not known until application runtime. Dynamic SQL can help 
overcome some of the limitations of static SQL, such as generating a full SQL query based upon some 
user-provided information or inserting into a specific table depending upon a user action within your 
application. Simply put, the ability to use dynamic SQL within PL/SQL applications provides a level of 
flexibility that is not attainable with the use of static SQL alone. 
Oracle allows dynamic SQL to be generated in two different ways: native dynamic SQL and through 
the use of the DBMS_SQL package. Each strategy has its own benefits as well as drawbacks. In comparison, 
native dynamic SQL is easier to use, it supports user-defined types, and it performs better than DBMS_SQL. 
On the other hand, DBMS_SQL supports some features that are not currently supported in native dynamic 
SQL such as the use of the SQL*Plus DESCRIBE command and the reuse of SQL statements. Each of these 
methodologies will be compared under various use cases within this chapter. By the end of the chapter, 
you should know what advantages each approach has to offer and which should be used in certain 
circumstances. 

## 8-1. Executing a Single Row Query That Is Unknown at Compile Time 

****Problem**** 
You need to query the database for a single row of data matched by the primary key value. However, you 
are unsure of what columns will need to be returned at runtime. 

****Solution** #1** 
Use a native dynamic query to retrieve the columns of data that are determined by your application at 
runtime. After you determine what columns need to be returned, create a string that contains the SQL 
that is needed to query the database. The following example demonstrates the concept of creating a 
dynamic SQL query and then using native dynamic SQL to retrieve the single row that is returned. 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_info IN VARCHAR2) IS 
  emp_qry                VARCHAR2(500); 
  emp_first              employees.first_name%TYPE; 
  emp_last               employees.last_name%TYPE; 
  email                  employees.email%TYPE; 
 
  valid_id_count         NUMBER := 0; 
  valid_flag             BOOLEAN := TRUE; 
  temp_emp_info          VARCHAR2(50); 
 
BEGIN 
  emp_qry := 'SELECT FIRST_NAME, LAST_NAME, EMAIL FROM EMPLOYEES '; 
  IF emp_info LIKE '%@%' THEN 
    temp_emp_info := substr(emp_info,0,instr(emp_info,'@')-1); 
    emp_qry := emp_qry || 'WHERE EMAIL = :emp_info'; 
  ELSE 
    SELECT COUNT(*) 
    INTO valid_id_count 
    FROM employees 
    WHERE employee_id = emp_info; 
 
    IF valid_id_count > 0 THEN 
        temp_emp_info := emp_info; 
        emp_qry := emp_qry || 'WHERE EMPLOYEE_ID = :id'; 
    ELSE 
        valid_flag := FALSE; 
    END IF; 
  END IF; 
 
  IF valid_flag = TRUE THEN 
    EXECUTE IMMEDIATE emp_qry 
    INTO emp_first, emp_last, email 
    USING temp_emp_info; 
 
    DBMS_OUTPUT.PUT_LINE(emp_first || ' ' || emp_last || ' - ' || email); 
  ELSE  
    DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE SPECIFIED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
  END IF; 
END; 
``` 
At runtime, the procedure creates a SQL query based upon the criteria that are passed into the 
procedure by the invoking program. That query is then executed using the EXECUTE IMMEDIATE statement 
along with the argument that will be substituted into the query WHERE clause. 
****Solution** #2**
Use the DBMS_SQL package to create a query based upon criteria that are specified at runtime. The 
example in this **Solution** will query the employee table and retrieve data based upon the parameter that 
has been passed into the procedure. The procedure will accept either a primary key ID or an employee e-
mail address. The SQL statement that will be used to query the database will be determined at runtime 
based upon what type of argument is used. 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_info IN VARCHAR2) IS 
  emp_qry                  VARCHAR2(500); 
  emp_first                employees.first_name%TYPE := NULL; 
  emp_last                 employees.last_name%TYPE := NULL; 
  email                    employees.email%TYPE := NULL; 
 
  valid_id_count           NUMBER := 0; 
  valid_flag               BOOLEAN := TRUE; 
  temp_emp_info          VARCHAR2(50); 
 
  cursor_name            INTEGER; 
  row_ct                 INTEGER; 
 
BEGIN 
   
  emp_qry := 'SELECT FIRST_NAME, LAST_NAME, EMAIL FROM EMPLOYEES '; 
  IF emp_info LIKE '%@%' THEN 
    temp_emp_info := substr(emp_info,0,instr(emp_info,'@')-1); 
    emp_qry := emp_qry || 'WHERE EMAIL = :emp_info'; 
  ELSE 
    SELECT COUNT(*) 
    INTO valid_id_count 
    FROM employees 
    WHERE employee_id = emp_info; 
 
    IF valid_id_count > 0 THEN 
        temp_emp_info := emp_info; 
        emp_qry := emp_qry || 'WHERE EMPLOYEE_ID = :emp_info'; 
    ELSE 
        valid_flag := FALSE; 
    END IF; 
  END IF; 
 
  IF valid_flag = TRUE THEN 
    cursor_name := DBMS_SQL.OPEN_CURSOR; 
    DBMS_SQL.PARSE(cursor_name, emp_qry, DBMS_SQL.NATIVE); 
    DBMS_SQL.BIND_VARIABLE(cursor_name, ':emp_info', temp_emp_info); 
    DBMS_SQL.DEFINE_COLUMN(cursor_name, 1, emp_first, 20); 
    DBMS_SQL.DEFINE_COLUMN(cursor_name, 2, emp_last, 25); 
    DBMS_SQL.DEFINE_COLUMN(cursor_name, 3, email, 25); 
    row_ct := DBMS_SQL.EXECUTE(cursor_name); 
  IF DBMS_SQL.FETCH_ROWS(cursor_name) > 0 THEN 
      DBMS_SQL.COLUMN_VALUE (cursor_name, 1, emp_first); 
      DBMS_SQL.COLUMN_VALUE (cursor_name, 2, emp_last); 
      DBMS_SQL.COLUMN_VALUE (cursor_name, 3, email); 
      DBMS_OUTPUT.PUT_LINE(emp_first || ' ' || emp_last || ' - ' || email); 
      
  END IF; 
     
  ELSE  
    DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE SPECIFIED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
  END IF; 
  DBMS_SQL.CLOSE_CURSOR(cursor_name); 
  EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE SPECIFIED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
 
END; 
```

****How It Works** #1** 
Native dynamic SQL allows you to form a string of SQL text and then execute it via the EXECUTE 
IMMEDIATE statement. This is very useful when the columns, table names, or WHERE clause text is not 
known at runtime. The program can build the SQL string as it needs to, and then the EXECUTE IMMEDIATE 
statement will execute it. The format for the EXECUTE IMMEDIATE statement is as follows: 
```sql
EXECUTE IMMEDIATE sql_string 
[INTO variable_name1[, variable_name2, . . .] 
USING variable_name1[, variable_name2, . . .]]; 
```
The EXECUTE IMMEDIATE statement requires only one parameter, which is a SQL string to execute. 
The remainder of the statement is optional. The INTO clause lists all the variables that a SQL query would 
return values into. The variables should be listed in the same order within the SQL string as they are 
listed within the INTO clause. The USING clause lists all the variables that will be bound to the SQL string 
at runtime. Bind variables are arguably one of the most valuable features of the PL/SQL language. Each 
variable listed in the USING clause is bound to a bind variable within the SQL string. The order in which 
the variables are listed in the USING clause is the same order in which they will be bound within the 
string. Take a look at the following example that uses two bind variables: 
```sql
EXECUTE IMMEDIATE 'select email from employees ' || 
                                       'where last_name =:last ' || 
                                       'and first_name = :first' 
INTO v_email 
USING v_last, v_first; 
```
In the example query, the variables contained within the USING clause are bound in order to the bind 
variables within the SQL string. Bind variables are the cornerstone to developing robust, secure, and 
well-performing software. 
****How It Works** #2**
The DBMS_SQL package can also be used to perform the same task. Each of the different techniques, native 
dynamic SQL and DBMS_SQL, have their advantages and disadvantages. The major difference between the 
use of DBMS_SQL and native dynamic SQL is how the dynamic SQL string is executed. In this example, 
DBMS_SQL package functions are used to process the SQL rather than EXECUTE IMMEDIATE. As you can see, 
the code is quite a bit lengthier than using EXECUTE IMMEDIATE, and it essentially returns the same 
information. In this case, DBMS_SQL is certainly not the best choice. DBMS_SQL can become useful in 
situations where you do not know the SELECT list until runtime or when you are unsure of which 
variables must be bound to a SELECT or DML statement. On the other hand, you must use native 
dynamic SQL if you intend to use the cursor variable attributes %FOUND, %NOTFOUND, %ISOPEN, or %ROWCOUNT 
when working with your cursor. 
■ Note Native dynamic SQL was introduced in Oracle 9i, because DBMS_SQL was overly complex for many of the 
routine tasks that programmers perform. We consider use of native dynamic SQL as the technique of choice for 
working with dynamic SQL. Use DBMS_SQL only when you have a specific need to do so. 

## 8-2. Executing a Multiple Row Query That Is Unknown at Compile 

****Problem**** 
Your application requires a database table to be queried, but the filters for the WHERE clause are not 
known until runtime. You have no idea how many rows will be returned by the query. 
****Solution** #1** 
Create a native dynamic query using a SQL string that will be built at application runtime. Declare the 
query using REF CURSOR, execute it by issuing an OPEN statement, and loop through the records using a 
standard loop, fetching the fields within each iteration of the loop. This technique is illustrated via the 
code in the following example: 
```sql
DECLARE 
  emp_qry                 VARCHAR2(500); 
  TYPE                    cur_type IS REF CURSOR; 
  cur                     cur_type; 
  emp_first               employees.first_name%TYPE; 
  emp_last                employees.last_name%TYPE; 
  email                   employees.email%TYPE; 
 
  dept_id                 employees.department_id%TYPE := &department_id; 
 
BEGIN 
  -- DEPARTMENT_ID WILL NOT UNIQUELY DEFINE ANY ONE EMPLOYEE 
 
  emp_qry := 'SELECT FIRST_NAME, LAST_NAME, EMAIL FROM EMPLOYEES ' || 
             ' WHERE DEPARTMENT_ID = :id'; 
 
  OPEN cur FOR emp_qry USING dept_id; 
  LOOP 
    FETCH cur INTO emp_first, emp_last, email; 
   EXIT WHEN cur%NOTFOUND; 
    DBMS_OUTPUT.PUT_LINE(emp_first || ' ' || emp_last || ' - ' || email); 
  END LOOP; 
  CLOSE cur; 
END; 
```
This example accepts a DEPARTMENT_ID as input, and it uses a bind variable to substitute the value 
within the SQL string. Although the actual SQL string in this example does not require the use of a 
dynamic query, it is a useful example to demonstrate the technique. 
****Solution** #2**
This same procedure can also be performed using the DBMS_SQL package. Although the native dynamic 
SQL **Solution** is easier to understand and implement, the DBMS_SQL alternative offers some different 
options that are not available when using the native method. The following example is a sample of a 
procedure that performs the same functionality as **Solution** #1 of this recipe. However, the procedure in
the following example uses the DBMS_SQL package to parse and execute the dynamic query rather than
native dynamic SQL. 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_detail(dept_id IN NUMBER) IS 
  emp_qry                 VARCHAR2(500); 
  emp_first               employees.first_name%TYPE := NULL; 
  emp_last                employees.last_name%TYPE := NULL; 
  email                   employees.email%TYPE := NULL; 
  cursor_name             INTEGER; 
  row_ct                  INTEGER; 
BEGIN 
   
 emp_qry := 'SELECT FIRST_NAME, LAST_NAME, EMAIL FROM EMPLOYEES ' || 
             ' WHERE DEPARTMENT_ID = :id'; 
    cursor_name := DBMS_SQL.OPEN_CURSOR; 
    DBMS_SQL.PARSE(cursor_name, emp_qry, DBMS_SQL.NATIVE); 
    DBMS_SQL.BIND_VARIABLE(cursor_name, ':id', dept_id); 
    DBMS_SQL.DEFINE_COLUMN(cursor_name, 1, emp_first, 20); 
    DBMS_SQL.DEFINE_COLUMN(cursor_name, 2, emp_last, 25); 
    DBMS_SQL.DEFINE_COLUMN(cursor_name, 3, email, 25); 
    row_ct := DBMS_SQL.EXECUTE(cursor_name); 
    LOOP 
    IF DBMS_SQL.FETCH_ROWS(cursor_name) > 0 THEN 
      DBMS_SQL.COLUMN_VALUE (cursor_name, 1, emp_first); 
      DBMS_SQL.COLUMN_VALUE (cursor_name, 2, emp_last); 
      DBMS_SQL.COLUMN_VALUE (cursor_name, 3, email); 
     DBMS_OUTPUT.PUT_LINE(emp_first || ' ' || emp_last || ' - ' || email); 
    ELSE 
      EXIT; 
    END IF; 
    END LOOP; 
    
DBMS_SQL.CLOSE_CURSOR(cursor_name);
EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD');
END;
```

****How It Works**** 
The use of native dynamic SQL in this **Solution** is more or less equivalent to that which was performed in
the previous recipe. The largest difference lies in the use of the REF CURSOR as opposed to the EXECUTE
IMMEDIATE statement. The REF CURSOR is used to create a cursor using a dynamic SQL string.  
Cursor variables can be either weakly typed or strongly typed. The cursor variable demonstrated in
the **Solution** to this example of a weakly typed REF CURSOR, since the SQL string is not known until 
runtime. A strongly typed cursor variable must be known at runtime. In this sense, a strongly typed 
cursor variable is very similar to a regular cursor. 
The REF CURSOR type must be declared first, and then the actual cursor variable that will be used in 
your code should be declared using the REF CURSOR as its type. Next you have the OPEN statement. To tell 
Oracle what SQL to use for the cursor, the OPEN statement should include a FOR clause indicating the SQL 
string that the cursor should use. If there are any variables to bind into the query, the optional USING 
clause should follow at the end of the OPEN statement.  
The subsequent cursor loop should work with the REF CURSOR in the same manner that you would 
use with regular cursor variables. Always FETCH the current record or its contents into a local record or 
separate local variables. Next, perform the tasks that need to be completed. Lastly, ensure that you 
include an EXIT statement to indicate that the loop should be terminated after the last record has been 
processed. The final step in the process is to close the cursor. After the cursor has been closed, it can be 
assigned a new SQL string since you are working with weakly typed REF CURSORs. 
As you can see, the example of using DBMS_SQL in **Solution** #2 of this recipe as opposed to the 
example in Recipe 8-1 differs only because of the addition of a LOOP construct. Instead of displaying only 
one value, this example will loop through all the records that are returned from the query, and the loop 
will exit when there are no remaining rows in the result. The example in Recipe 8-1 could entail the same 
loop construct as the one shown in **Solution** #2 of this recipe, but it is only expected to return one row 
since the query is based upon a primary and unique key value. 
The choice for using DBMS_SQL as opposed to native dynamic SQL (NDS) depends on what you are 
trying to achieve. DBMS_SQL will allow you to use a SQL string that is greater than 32KB in size, whereas 
native dynamic SQL will not. However, there are other options for creating large SQL text strings and 
parsing them with native dynamic SQL. Please see Recipe 8-11 for more details. 
## 8-3. Writing a Dynamic INSERT Statement 

****Problem**** 
Your application must insert data into a table, but you don’t know until runtime which columns you will 
insert. For example, you are writing a procedure that will be used for saving records into the EMPLOYEES 
table. However, the exact content to be saved is not known until runtime because the person who is 
calling the procedure can decide whether they are including a DEPARTMENT_ID. If a DEPARTMENT_ID is 
included, then the department will be included in the INSERT. 
****Solution****
Create a string at runtime that will contain the INSERT statement text to be executed. Use bind variables 
to substitute the values that are to be inserted into the database table. The following procedure accepts 
user input for entry of a new employee record. Bind variables are used to substitute those values into the 
SQL. 
```sql
CREATE OR REPLACE PROCEDURE new_employee (   first     IN VARCHAR2, 
                                             last      IN VARCHAR2, 
                                             email     IN VARCHAR2, 
                                             phone     IN VARCHAR2, 
                                             hired     IN DATE, 
                                             job       IN VARCHAR2, 
                                             dept      IN NUMBER DEFAULT 0) AS 
                                             v_sql     VARCHAR2(1000); 
BEGIN 
  IF dept != 0 THEN 
    v_sql := 'INSERT INTO EMPLOYEES ( ' || 
                   'employee_id, first_name, last_name, email, ' || 
                   'phone_number, hire_date, job_id, department_id) ' || 
                   'VALUES( ' || 
                   ':id, :first, :last, :email, :phone, :hired, ' || 
                   ':job_id, :dept)'; 
 
    EXECUTE IMMEDIATE v_sql 
    USING employees_seq.nextval, first, last, email, phone, hired, job, dept; 
 
  ELSE 
    v_sql := 'INSERT INTO EMPLOYEES ( ' || 
                   'employee_id, first_name, last_name, email, ' || 
                   'phone_number, hire_date, job_id) ' || 
                   'VALUES( ' || 
                   ':id, :first, :last, :email, :phone, :hired, ' || 
                   ':job_id)'; 
 
    EXECUTE IMMEDIATE v_sql 
    USING employees_seq.nextval, first, last, email, phone, hired, job; 
 
  END IF; 
 
  DBMS_OUTPUT.PUT_LINE('The employee has been successfully entered'); 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('YOU MUST SUPPLY A VALUE FOR DEPARTMENT'); 
  WHEN TOO_MANY_ROWS THEN 
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE_ID ALREADY EXISTS'); 
END; 
```
If the data entry clerk includes a department ID number for the employee when executing the 
NEW_EMPLOYEE procedure, then the INSERT statement will differ slightly than it would if no department ID 
were provided. The basic native dynamic SQL in this example does not differ much from those examples 
demonstrated in Recipe 8-1 or Recipe 8-2 of this chapter. 
****Solution** #2**
The DBMS_SQL API can also be used to execute dynamic INSERT statements. Although dynamic DML is not 
usually performed with DBMS_SQL very often, it can still be useful in some circumstances. The following 
example performs the same task as **Solution** #1 to this recipe. However, it has been rewritten to use 
DBMS_SQL instead of native dynamic SQL. 
```sql
CREATE OR REPLACE PROCEDURE new_employee(first      IN VARCHAR2, 
                                         last       IN VARCHAR2, 
                                         email      IN VARCHAR2, 
                                         phone      IN VARCHAR2, 
                                         hired      IN DATE, 
                                         job        IN VARCHAR2, 
                                         dept       IN NUMBER DEFAULT 0)  
AS 
  v_sql    VARCHAR2(1000); 
 
  cursor_var            NUMBER := DBMS_SQL.OPEN_CURSOR; 
  rows_compelete NUMBER := 0; 
  next_emp              NUMBER := employee_seq.nextval; 
BEGIN 
   
 
  IF dept != 0 THEN 
    v_sql := 'INSERT INTO EMPLOYEES ( ' || 
                   'employee_id, first_name, last_name, email, ' || 
                   'phone_number, hire_date, job_id, department_id) ' || 
                   'VALUES( ' || 
                   ':id, :first, :last, :email, :phone, :hired, ' || 
                   ':job_id, :dept)'; 
 
     
  ELSE 
    v_sql := 'INSERT INTO EMPLOYEES ( ' || 
                   'employee_id, first_name, last_name, email, ' || 
                   'phone_number, hire_date, job_id) ' || 
                   'VALUES( ' || 
                   ':id, :first, :last, :email, :phone, :hired, ' || 
                   ':job_id)'; 
  END IF; 
  DBMS_SQL.PARSE(cursor_var, v_sql, DBMS_SQL.NATIVE); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 1, ':id', next_emp); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 2, ':first', first); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 3, ':last', last); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 4, ':email', email); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 5, ':phone', phone); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 6, ':hired'); 
  DBMS_SQL.BIND_VARIABLE(cursor_var, 7, ':job', job); 
  IF dept != 0 then 
    DBMS_SQL.BIND_VARIABLE(cursor_var, 8, ':dept', dept); 
  END IF; 
  rows_complete := DBMS_SQL.EXECUTE(cursor_var); 
  DBMS_SQL.CLOSE_CURSOR(cursor_var); 
  DBMS_OUTPUT.PUT_LINE('The employee has been successfully entered'); 
END;
```

****How It Works**** 
Using native dynamic SQL, creating an INSERT statement is almost identical to working with a query 
string. As a matter of fact, the only difference is that you will not be making use of the INTO clause within 
the EXECUTE IMMEDIATE statement. Standard PL/SQL can be used to create the SQL statement string in 
order to process an INSERT statement that contains column names, table names, or WHERE clause values 
that are not known until runtime.  
■ Note If your SQL string contains any SQL that requires the use of single quotes, double up on the quotes. 
Placing a single quote immediately after another signals the parser to place a single quote into the string that you 
are creating. Similarly to SQL queries using dynamic SQL, you should use bind variables to substitute values into 
the SQL statement string where needed. As a refresher, bind variables are used within SQL queries or 
statements to act as placeholders for values that are to be substituted at runtime. A bind variable begins 
with a colon and is then followed by the variable name. The EXECUTE IMMEDIATE statement implements 
the USING clause to list variables that contain values that will be substituted into the bind variables at 
runtime. The order in which the variables are listed in the USING clause must concur with the positioning 
of the bind variables within the SQL. The following is an example of an EXECUTE IMMEDIATE statement to 
be used with a SQL statement such as an INSERT: 
```sql
EXECUTE IMMEDIATE sql_statement_string 
[USING variable1, variable2, etc]; 
```
It is usually a good idea to include an EXCEPTION block at the end of any code block. This is especially 
true when working with dynamic queries or statements. An Oracle error will be raised if the INSERT 
statement within the SQL string is invalid. If an EXCEPTION block were added to catch OTHERS, then you 
could provide a well-written error message that describes the exact issue at hand. In most cases, users of 
your application would prefer to see such a nice summary message rather than a cryptic Oracle error 
message. 
It is a good rule of thumb to maintain consistency throughout your application code. If you prefer to 
use native dynamic SQL, then try to use it in all cases where dynamic SQL is a requirement. Likewise, 
DBMS_SQL should be used throughout if you plan to make use of it instead. There are certain situations 
when you may want to mix the two techniques in order to obtain information or use features that are not 
available with one or the other. In Recipe 8-13, you will learn more about using both techniques within 
the same block of PL/SQL code. 

## 8-4. Writing a Dynamic Update Statement 
****Problem**** 
Your application needs to execute an update statement, and you are not sure of the columns to be 
updated until runtime. For example, your application will modify employee records. You would like to 
construct an update statement that contains only the columns that have updated values. 
****Solution****
Use native dynamic SQL to execute a SQL statement string that you prepare at application runtime. The 
procedure in this example accepts employee record values as input. In this scenario, an application form 
allows user entry for many of the fields that are contained within the EMPLOYEES table so that a particular 
employee record can be updated. The values that are changed on the form should be included in the 
UPDATE statement. The procedure queries the employee record and checks to see which values have been 
updated. Only the updated values are included in the text of the SQL string that is used for the update. 
```sql 
CREATE OR REPLACE PROCEDURE update_employees(id   IN employees.employee_id%TYPE, 
                                            first IN employees.first_name%TYPE, 
                                            last  IN employees.last_name%TYPE, 
                                            email IN employees.email%TYPE, 
                                            phone IN employees.phone_number%TYPE, 
                                            job   IN employees.job_id%TYPE, 
                                            salary IN employees.salary%TYPE, 
                                            commission_pct IN employees.commission_pct%TYPE, 
                                            manager_id IN employees.manager_id%TYPE, 
                                            department_id IN employees.department_id%TYPE) 
 AS
  emp_upd_rec   employees%ROWTYPE; 
  sql_string    VARCHAR2(1000); 
  set_count     NUMBER := 0; 
BEGIN 
  SELECT * 
  INTO emp_upd_rec 
  FROM employees 
  WHERE employee_id = id; 
  sql_string := 'UPDATE EMPLOYEES SET '; 
   
  IF first != emp_upd_rec.first_name THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', FIRST_NAME =' || first || ''''; 
    ELSE 
      sql_string := sql_string || ' FIRST_NAME =' || first || ''''; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF last != emp_upd_rec.last_name THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', LAST_NAME =''' || last || ''''; 
    ELSE 
      sql_string := sql_string ||' LAST_NAME =''' ||  last || ''''; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF upper(email) != emp_upd_rec.email THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', EMAIL =''' || upper(email) || ''''; 
    ELSE 
      sql_string := sql_string ||' EMAIL =''' || upper(email) || ''''; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF upper(phone) != emp_upd_rec.phone_number THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', PHONE_NUMBER =''' || 
        upper(phone) || ''''; 
    ELSE 
      sql_string := sql_string ||' PHONE_NUMBER =''' || 
        upper(phone) || ''''; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF job != emp_upd_rec.job_id THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', JOB_ID =''' || job || ''''; 
    ELSE 
      sql_string := sql_string ||' JOB_ID =''' || job || ''''; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF salary != emp_upd_rec.salary THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', SALARY =' || salary; 
    ELSE 
      sql_string := sql_string ||' SALARY =' || salary; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF commission_pct != emp_upd_rec.commission_pct THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', COMMISSION_PCT =' || 
               commission_pct; 
    ELSE 
      sql_string := sql_string ||' COMMISSION_PCT =' || 
               commission_pct; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  IF manager_id != emp_upd_rec.manager_id THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', MANAGER_ID =' || 
        manager_id; 
    ELSE 
      sql_string := sql_string ||' MANAGER_ID =' || 
        manager_id; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
   IF department_id != emp_upd_rec.department_id THEN 
    IF set_count > 0 THEN 
      sql_string := sql_string ||', DEPARTMENT_ID =' || 
        department_id; 
    ELSE 
      sql_string := sql_string ||' DEPARTMENT_ID =' || 
        department_id; 
      set_count := set_count + 1; 
    END IF; 
  END IF; 
   
  sql_string := sql_string || ' WHERE employee_id = ' || id; 
      
  IF set_count > 0 THEN 
    EXECUTE IMMEDIATE sql_string; 
  ELSE 
    DBMS_OUTPUT.PUT_LINE('No update needed, ' || 
        'all fields match original values'); 
  END IF; 
 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('No matching employee found'); 
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Data entry error has occurred, ' || 
                'please check values and try again' || sql_string); 
END; 
``` 
Execution and Results: 
```sql
SQL> exec update_employees(187, 
'Anthony', 
'Cabrio', 
'ACABRIO', 
'650.509.4876', 
 'SH_CLERK' 
,6501, 
.08, 
121, 
50); 
```
No update needed, all fields match original values 
As mentioned previously, this procedure accepts input from a user data entry form. The input 
pertains to an existing employee’s database record. The values accepted as input are compared against 
those that already exist in the database, and if they are different, then they are added into the SQL UPDATE 
statement that is dynamically created. This code could be simplified by creating a separate function to 
take care of comparing values and building the SQL string, but this procedure gives you a good idea of 
how dynamic SQL can be used to EXECUTE an UPDATE statement. 

****How It Works**** 
Dynamic SQL statement execution is straightforward when using native dynamic SQL. The procedure in 
the **Solution** to this recipe creates a SQL string based upon certain criteria, after which it is executed with 
the use of the EXECUTE IMMEDIATE statement.  
The EXECUTE IMMEDIATE statement works the same way for most DML statements. If you read Recipe 
8-3 on creating and running a dynamic INSERT statement, then you can see that executing an UPDATE 
statement works in the same manner.  
Any values that need to be substituted into the SQL string should be coded as bind variables. For 
more information regarding bind variables, please refer to Recipe 8-3. The format for executing an 
UPDATE statement with the EXECUTE IMMEDIATE statement is as follows: 
```sql
EXECUTE IMMEDIATE update_statement_string 
[USING variable1, variable2, etc]; 
```
Just as with the execution of the INSERT statement in Recipe 8-3, the EXECUTE IMMEDIATE statement 
requires the use of the USING clause only if there are variables that need to be substituted into the SQL 
statement at runtime.  
■ Note If you are able to write a static SQL UPDATE statement for your application, then do so. Use of dynamic SQL 
will incur a small performance penalty. 
The DBMS_SQL package can also be used to work with dynamic SQL updates. However, this technique 
is not used very much since the introduction of native dynamic SQL in Oracle 9i. For an example of using 
the DBMS_SQL package with DML statements, please refer to Recipe 8-3. Although the example in Recipe 
8-3 demonstrates an INSERT statement, an UPDATE statement is processed the same way; only the SQL 
string needs to be changed. 

## 8-5. Writing a Dynamic Delete Statement 

****Problem**** 
You need to create a procedure that will delete rows from a table. However, the exact SQL for deleting 
the rows is not known until runtime. For instance, you need create a procedure to delete an employee 
from the EMPLOYEES table, but rather than limit the procedure to accepting only employee ID numbers 
for employee identification, you also want to accept an e-mail address. The procedure will determine 
whether an e-mail address or an ID has been passed and will construct the appropriate DELETE 
statement. 
****Solution**** 
Use native dynamic SQL to process a string that is dynamically created based upon values that are 
passed into the procedure. In the following example, a procedure is created that will build a dynamic 
SQL string to delete an employee record. The DELETE statement syntax may vary depending upon what 
type of value is passed into the procedure. Valid entries include EMPLOYEE_ID values or EMAIL values. 
```sql 
CREATE OR REPLACE PROCEDURE delete_employee(emp_value IN VARCHAR2) AS 
 
  is_number         NUMBER := 0; 
  valid_flag        BOOLEAN := FALSE; 
  sql_stmt          VARCHAR2(1000); 
  emp_count         NUMBER := 0; 
BEGIN 
  sql_stmt := 'DELETE FROM EMPLOYEES '; 
 
  -- DETERMINE IF emp_value IS NUMERIC, IF SO THEN QUERY 
  -- DATABASE TO FIND OCCURRENCES OF MATCHING EMPLOYEE_ID 
  IF LENGTH(TRIM(TRANSLATE(emp_value, ' +-.0123456789', ' '))) IS NULL THEN 
    SELECT COUNT(*) 
    INTO emp_count 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = emp_value; 
 
    IF emp_count > 0 THEN 
      sql_stmt := sql_stmt || 'WHERE EMPLOYEE_ID = :emp_val'; 
      valid_flag := TRUE; 
    END IF; 
  ELSE 
    SELECT COUNT(*) 
    INTO emp_count 
    FROM EMPLOYEES 
    WHERE EMAIL = upper(emp_value); 
 
    IF emp_count > 0 THEN 
      sql_stmt := sql_stmt || 'WHERE EMAIL = :emp_val'; 
      valid_flag := TRUE; 
    ELSE  
      valid_flag := FALSE; 
    END IF; 
  END IF; 
 
  IF valid_flag = TRUE THEN 
 
    EXECUTE IMMEDIATE sql_stmt 
    USING emp_value; 
 
    DBMS_OUTPUT.PUT_LINE('Employee has been deleted'); 
  ELSE 
    DBMS_OUTPUT.PUT_LINE('No matching employee found, please try again'); 
  END IF; 
 
END; 
```
The procedure can be called by passing in either an EMPLOYEE_ID value or an EMAIL value. If a 
matching employee record is found, then it will be deleted from the database table. 
****How It Works**** 
Dynamic SQL can be used to execute DELETE statements as well. In the **Solution** to this recipe, a dynamic
SQL string is built that will remove an employee entry that contains a matching EMPLOYEE_ID or EMAIL
value that is passed into the procedure as a parameter. The parameter is checked to find out whether it is
a numeric or alphanumeric value by using a combination of the LENGTH, TRIM, and TRANSLATE functions. If
it is numeric, then it is assumed to be an EMPLOYEE_ID value, and the database is queried to see whether
there are any matches. If the parameter is found to be alphanumeric, then it is assumed to be an EMAIL
value, and the database is queried to see whether there are any matches. If matches are found in either
case, then a dynamic SQL string is built to DELETE the matching record from the database. 
In this example, native dynamic SQL is used to perform the database operation. The DBMS_SQL
package can also be used to perform this task using the same techniques that were demonstrated in
Recipe 8-3. 

## 8-6. Returning Data from a Dynamic Query into a Record 

****Problem**** 
You are writing a block of code that will need to use dynamic SQL to execute a query because the exact
SQL string is not known until runtime. The query needs to return the entire contents of the table row so
that all columns of data can be used. You want to return the columns into a record variable. 
****Solution****
Create a native dynamic SQL query to accommodate the SQL string that is unknown until runtime. FETCH
the data using BULK COLLECT into a table of records. Our **Solution** example shows rows from the jobs table
being fetched into records, after which the individual record columns of data can be worked with. The
following code block demonstrates this technique: 
```sql
CREATE OR REPLACE PROCEDURE obtain_job_info(min_sal  NUMBER DEFAULT 0, 
max_sal  NUMBER DEFAULT 0)
AS 
  sql_text      VARCHAR2(1000); 
  TYPE job_tab IS TABLE OF jobs%ROWTYPE; 
  job_list      job_tab; 
  job_elem      jobs%ROWTYPE; 
  max_sal_temp  NUMBER; 
  filter_flag   BOOLEAN := FALSE; 
  cursor_var    NUMBER; 
  TYPE          cur_type IS REF CURSOR; 
  cur           cur_type;
BEGIN 
  sql_text := 'SELECT * ' || 
              'FROM JOBS WHERE ' || 
              'min_salary >= :min_sal ' || 
              'and max_salary <= :max_sal'; 
   
  IF max_sal = 0 THEN 
    SELECT max(max_salary) 
    INTO max_sal_temp 
    FROM JOBS; 
  ELSE 
    max_sal_temp := max_sal; 
  END IF; 
 
  OPEN cur FOR sql_text USING min_sal, max_sal_temp; 
  FETCH cur BULK COLLECT INTO job_list; 
  CLOSE cur; 
 
  FOR i IN job_list.FIRST .. job_list.LAST LOOP 
    DBMS_OUTPUT.PUT_LINE(job_list(i).job_id || ' - ' || job_list(i).job_title); 
  END LOOP; 
 
END; 
```
As the salaries are obtained from the user input, they are used to determine how the bind variables 
will be populated within the query. The SQL is then executed, and the results are traversed. Each record 
is fetched and returned into a PL/SQL table of job records using BULK_COLLECT, and then in turn, each 
record is used to process the results. In this example, the data is simply printed out using 
DBMS_OUTPUT.PUT_LINE, but any number of tasks could be completed with the data.  
****How It Works**** 
Dynamic SQL can be processed in a number of ways. In this **Solution**, a record type is created by using 
the %ROWTYPE attribute of the table that is being queried. In this case, the %ROWTYPE attribute of the JOBS 
table is being used as a record. The data that is returned from performing a SELECT * on the JOBS table 
will be stored within that record, and then it will be processed accordingly. The record is created using 
the following syntax: 
```sql
record_name     table_name%ROWTYPE; 
```
Using this format, the record_name is any name of your choice that complies with PL/SQL’s naming 
conventions. The table_name is the name of the table from which you will be gathering the data for each 
column, and the %ROWTYPE attribute is a special table attribute that creates a record type.  
To process each record, create a REF CURSOR using the dynamic SQL string and perform a BULK 
COLLECT to fetch each row of data into a record in the table of JOBS records. The BULK COLLECT will load all 
of the resulting records at once into a PL/SQL collection object. Once all the data has been retrieved into 
an object, it can be processed accordingly. The BULK COLLECT is much more efficient than fetching each 
row from the table one-by-one using a LOOP construct. 

## 8-7. Executing a Dynamic Block of PL/SQL 
****Problem**** 
You want to execute a specific stored procedure based upon events that occur within your application. 
Therefore, you need to provide the ability for your application to execute procedures that are unknown 
until runtime. In short, you want to execute PL/SQL in the same dynamic manner as SQL. 

****Solution** #1** 
Native dynamic SQL can be used to create and execute a block of code at runtime. This strategy can be 
used to create a dynamic block of code that executes a given procedure when an event occurs. In this 
example, a procedure is created that accepts an event identifier. An event handler within the application 
can call upon this procedure passing an event identifier, and subsequently a procedure that can be 
determined via the identifier will be invoked. 
```sql
-- Create first Procedure 
CREATE OR REPLACE PROCEDURE TEST_PROCEDURE1 AS 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('YOU HAVE EXECUTED PROCEDURE 1…'); 
END; 
 
-- Create Second Procedure 
CREATE OR REPLACE PROCEDURE TEST_PROCEDURE2 AS 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('YOU HAVE EXECUTED PROCEDURE 2…'); 
END; 
 
-- Create Event Handling Procedure 
CREATE OR REPLACE PROCEDURE run_test(test_id  IN NUMBER DEFAULT 1) AS 
  sql_text  VARCHAR2(200); 
BEGIN 
  sql_text := 'BEGIN ' || 
              '  TEST_PROCEDURE' || test_id || '; ' || 
              'END;'; 
 
  EXECUTE IMMEDIATE sql_text; 
 
END; 
```
When an event handler passes a given event number to this procedure, it dynamically creates a code 
block that is used to execute that procedure, passing the parameters the procedure needs. This **Solution** 
provides the ultimate flexibility for creating an event handler within your applications. 

****Solution** #2** 
DBMS_SQL can also be used to execute the same dynamic code. The following example demonstrates how 
this is done. 
```sql
CREATE OR REPLACE PROCEDURE run_test(test_id  IN NUMBER DEFAULT 1) AS 
  sql_text  VARCHAR2(200); 
  cursor_var   NUMBER := DBMS_SQL.OPEN_CURSOR; 
  rows       NUMBER; 
BEGIN 
  sql_text := 'BEGIN ' || 
              '  TEST_PROCEDURE' || test_id || '; ' || 
              'END;'; 
 
  DBMS_SQL.PARSE(cursor_var, sql_text, DBMS_SQL.NATIVE); 
  rows := DBMS_SQL.EXECUTE(cursor_var); 
  DBMS_SQL.CLOSE_CURSOR(cursor_var); 
 
END;
```

****How It Works**** 
Native dynamic SQL allows processing of a SQL statement via the EXECUTE IMMEDIATE statement. This 
can be used to the advantage of the application and provide the ability to create dynamic blocks of 
executable code. By doing so, you can create an application that allows more flexibility, which can help 
ensure that your code is more easily manageable. 
In the **Solution** to this recipe, an unknown procedure name along with its parameters is 
concatenated into a SQL string that forms a code block. This code block is then executed using the 
EXECUTE IMMEDIATE statement.  
Using native dynamic SQL, the array of parameters has to be manually processed to create the SQL 
string and assign each of the array values to the USING clause of the EXECUTE IMMEDIATE statement. This 
technique works quite well, but there is a different way to implement the same procedure.  
As far as comparing native dynamic SQL and DBMS_SQL for dynamic code block execution, which 
code is better? That is up to you to decide. If you are using native dynamic SQL for all other dynamic SQL 
processing within your application, then it is probably a good idea to stick with it instead of mixing both 
techniques. However, if you are working with some legacy code that perhaps includes a mixture of both 
DBMS_SQL and native dynamic SQL, then you may prefer to write a dynamic code block using DBMS_SQL 
just to save some time and processing. 

## 8-8. Creating a Table at Runtime 

****Problem**** 
Your application needs to have the ability to create tables based upon user input. The user has the ability 
to add additional attributes to some of your application forms, and when this is done, a new attribute 
table needs to be created to hold the information. 
****Solution****
Create a table at runtime using native dynamic SQL. Write a procedure that accepts a table name as an 
argument and then creates a SQL string including the DDL that is required for creating that table. The 
table structure will be hard-coded since the structure for an attribute table will always be the same 
within your application. The code that follows demonstrates this technique by creating a procedure 
named CREATE_ATTR_TABLE that dynamically creates attribute tables. 
```sql
CREATE OR REPLACE PROCEDURE create_attr_table(table_name      VARCHAR2) AS 
  BEGIN 
    EXECUTE IMMEDIATE 'CREATE TABLE ' || table_name || 
                                           '(ATTRIBUTE_ID     NUMBER PRIMARY KEY, 
                                             ATTRIBUTE_NAME   VARCHAR2(150) NOT NULL, 
                                             ATTRIBUTE_VALUE  VARCHAR2(150))'; 
  END create_attr_table; 
``` 
This procedure is invoked by the application whenever a user determines that additional attributes 
are required for a particular application form. That form will then have its own attribute table created, 
and the user can then provide additional fields/attributes to customize the form as needed. 
****How It Works****
Dynamic SQL can be used to create database objects at runtime. In this recipe, it is used to create tables. 
Native dynamic SQL is used in this example, and the EXECUTE IMMEDIATE statement performs the work. 
When creating a table at runtime, generate a string that contains the necessary SQL to create the object. 
Once that task has been completed, issue the EXECUTE IMMEDIATE statement passing the generated SQL 
string. The format to use along with the EXECUTE IMMEDIATE statement to create objects is as follows: 
```sql
 EXECUTE IMMEDIATE SQL_string; 
```
The SQL_string in this example is a dynamically created string that will create an object. In the case 
of creating objects, the USING clause is not used because you cannot use bind variables for substituting 
object names or attributes such as column names. 
■ Please use care when concatenating user input variables with SQL text because the technique poses a security 
concern. Specifically, you open the door to the much-dreaded SQL injection attack. Refer to Recipe 8-14 for more 
details and for information on protecting yourself. 

## 8-9. Altering a Table at Runtime 
****Problem****
Your application provides the ability to add attributes to forms in order to store additional information. 
You need to provide users with the ability to make those attribute fields larger or smaller based upon 
their needs. 

****Solution****
Create a procedure that will provide the ability to alter tables at runtime using native dynamic SQL. The 
procedure in this **Solution** will accept two parameters, those being the table name to be altered and the 
column name along with new type declaration. The procedure assembles a SQL string using the 
arguments provided by the user and then executes it using native dynamic SQL. The following code 
demonstrates this **Solution**: 
```sql
CREATE OR REPLACE PROCEDURE modify_table(tab_name    VARCHAR2, 
                                         tab_info    VARCHAR2) AS 
                                         sql_text    VARCHAR2(1000); 
BEGIN 
  sql_text := 'ALTER TABLE ' || tab_name ||  
              ' MODIFY ' || tab_info; 
  DBMS_OUTPUT.PUT_LINE(sql_text); 
  CHAPTER 8  DYNAMIC SQL 
175 
  EXECUTE IMMEDIATE sql_text; 
  DBMS_OUTPUT.PUT_LINE('Table successfully altered…'); 
EXCEPTION 
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE(‘An error has occurred, table not modified’); 
END; 
```
The procedure determines whether the user-defined data is valid. If so, then the EXECUTE IMMEDIATE 
statement executes the SQL string that was formed. Otherwise, the user will see an alert displayed. 
****How It Works****
Similar to creating objects at runtime, Oracle provides the ability to alter objects using dynamic SQL. 
The same technique is used for constructing the SQL string as when creating an object, and that string is 
eventually executed via the EXECUTE IMMEDIATE statement. The EXECUTE IMMEDIATE statement for altering 
a table at runtime uses no clause, because it is not possible to use bind variables with an ALTER TABLE 
statement. If you try to pass in bind variable values, then you will receive an Oracle error.  
The following format should be used when issuing the EXECUTE IMMEDIATE statement for SQL text 
containing an ALTER TABLE statement: 
```sql
EXECUTE IMMEDIATE alter_table_sql_string; 
```
The most important thing to remember when issuing a DDL statement using dynamic SQL is that 
you will need to concatenate all the strings and variables in order to formulate the final SQL string that 
will be executed. Bind variables will not work for substituting table names or column names/attributes.  

## 8-10. Finding All Tables That Include a Specific Column Value 

****Problem**** 
You are required to update all instances of a particular data column value across multiple tables within 
your database.  
****Solution****
Search all user tables for the particular column you are interested in finding. Create a cursor that will be 
used to loop through all the results and execute a subsequent UPDATE statement in each iteration of the 
loop. The UPDATE statement will update all matching column values for the table that is current for that 
iteration of the cursor. 
The following example shows how this technique can be performed. The procedure will be used to 
change a manager ID when a department or job position changes management.  
```sql
CREATE OR REPLACE PROCEDURE change_manager(current_manager_id NUMBER, 
 
new_manager_id  NUMBER) 
AS 
 
cursor manager_tab_cur is 
select table_name 
from user_tab_columns 
where column_name = 'MANAGER_ID' 
and table_name not in (select view_name from user_views); 
 
rec_count            number := 0; 
ref_count            number := 0; 
 
BEGIN 
 
   -- Print out the tables which will be updated 
 
   DBMS_OUTPUT.PUT_LINE('Tables referencing the selected MANAGER ID#:' || 
 current_manager_id); 
 
   FOR manager_rec IN manager_tab_cur LOOP 
      EXECUTE IMMEDIATE 'select count(*) total ' || 
                        'from ' || manager_rec.table_name || 
                        ' where manager_id = :manager_id_num' 
      INTO rec_count 
      USING current_manager_id; 
 
      if rec_count > 0 then 
                   DBMS_OUTPUT.PUT_LINE(manager_rec.table_name || ': ' || rec_count); 
                   ref_count := ref_count + 1; 
      end if; 
 
      rec_count := 0; 
 
   END LOOP; 
 
   if ref_count > 0 then 
      DBMS_OUTPUT.PUT_LINE('Manager is referenced in ' || ref_count || ' tables.'); 
      DBMS_OUTPUT.PUT_LINE('...Now Changing the Manager Identifier...'); 
   end if; 
 
   -- Perform the actual table updates 
 
   FOR manager_rec IN manager_tab_cur LOOP 
      EXECUTE IMMEDIATE 'select count(*) total ' || 
                                                  'from ' || manager_rec.table_name || 
                                                  ' where manager_id = :manager_id_num' 
      INTO rec_count 
      USING current_manager_id; 
 
      if rec_count > 0 then 
 
         EXECUTE IMMEDIATE 'update ' || manager_rec.table_name || ' ' || 
                                                     'set manager_id = :new_manager_id ' || 
                                                     'where manager_id = :old_manager_id' 
         USING new_manager_id, current_manager_id; 
 
      end if; 
 
      rec_count := 0; 
 
   END LOOP; 
 
   -- Print out the tables which still reference the manager number. 
 
   FOR manager_rec IN manager_tab_cur LOOP 
      EXECUTE IMMEDIATE 'select count(*) total ' || 
                        'from ' || manager_rec.table_name || 
                        ' where manager_id = :manager_id' 
      INTO rec_count 
      USING current_manager_id; 
 
      if rec_count > 0 then 
                   DBMS_OUTPUT.PUT_LINE(manager_rec.table_name || ': ' || rec_count); 
                   ref_count := ref_count + 1; 
      end if; 
 
      rec_count := 0; 
 
   END LOOP; 
 
   if ref_count > 0 then 
      DBMS_OUTPUT.PUT_LINE('Manager #: ' || current_manager_id  
                           || ' is now referenced in ' || 
                       ref_count || ' tables.'); 
      DBMS_OUTPUT.PUT_LINE('...There should be no tables listed above...'); 
   end if; 
 
end; 
```
Since MANAGER_ID depends upon a corresponding MANAGER_ID within the DEPARTMENTS table, you must 
first ensure that the MANAGER_ID that you want to change to is designated to a department within that 
table. In the following scenario, a manager is added to a department that does not have a manager. 
Afterward, the manager with ID of 205 is swapped for the newly populated manager. 
```sql
SQL> update departments 
  2  set manager_id = 241 
  3  where department_id = 270; 
 
1 row updated. 

SQL> exec change_manager(205, 241); 
Tables referencing the selected MANAGER ID#:205 
DEPARTMENTS: 1 
EMP: 1 
EMPLOYEES: 1 
Manager is referenced in 3 tables. 
...Now Changing the Manager Identifier... 
Manager #: 205 is now referenced in 3 tables. 
...There should be no tables listed above... 
PL/SQL procedure successfully completed. 
```
■ Note If you attempt to swap a manager with one that is not associated with a department, then you will receive 
a foreign key error. This same concept holds true in the real world—ensure that constraints are reviewed before 
applying this technique. 
If management decides to change a manager for a particular department, then this procedure will 
be called. The caller will pass in the old manager’s ID number and the new manager’s ID number. This 
procedure will then query all tables within the current schema for a matching current manager ID and 
update it to reflect the new ID number. 

****How It Works****
To determine all instances of a specific column or database field, you must search all database tables for 
that column name. Of course, this assumes that the database was created using the same name for the 
same column in each different table. If columns containing the same data are named differently across 
tables, then this recipe’s technique will not work.  
■ Note Although most relational databases are set up with efficiency in mind and only populate data for a specific 
field value into one database table column, there are some legacy databases that still use the same fields across 
more than one table. 
As the **Solution** to this recipe entails, assume that a column name is coded into the procedure, and 
all tables will then be searched to find out whether that column exists. You can perform the search using 
the built-in USER_TAB_COLUMNS data dictionary view. This view is comprised of column information for all 
the tables within a particular schema. Querying any Oracle view that is prefixed with USER_ indicates that 
the view pertains to data contained within the current user’s schema only. Querying the 
USER_TAB_COLUMNS view allows a table name and column name to be specified. In this case, since you 
need to find all tables that contain a specific column, query the USER_TAB_COLUMNS view to return all 
instances of TABLE_NAME where COLUMN_NAME is equal to the name that is passed into the procedure. This 
query should be defined as a cursor variable so that it can be parsed via a FOR loop in the code block. 
■ Warning Be sure to exclude views from this process, or you may receive an error from attempting to update a 
value that is contained within a view if it is not an updatable view. 
Now that the cursor is ready to parse all table names that contain a matching column, it is time to 
loop through the cursor and query each table that contains that column for a matching value. A user 
passes two values into the procedure: current manager ID and new manager ID. In the Solution to this 
recipe, each table that contains a matching column is queried so that you can see how many matches 
were found prior to the updates taking place. A counter is used to tally the number of matches found 
throughout the tables. Next, looping through the cursor again performs the actual updates. This time, 
the tables are each queried to find matches again, but when a match is found, then that table will be 
updated so that the value is changed from the old value to the new value. 
Lastly, the cursor is parsed again, and each table is queried to find existing matches once again. This 
last loop is done for consistency and to ensure that all matches have been found and updated to the 
current value. If any matches are found during this last loop, then all changes should be rolled back, and 
the changes should be manually processed instead. 
This procedure can be updated to work with any column value change that may be needed. The 
code can also be shortened significantly if you do not want to perform verifications prior to and after 
performing an update.  

## 8-11 Storing Dynamic SQL in Large Objects 

****Problem**** 
The SQL code that you need to assemble at runtime is likely to exceed the 32KB limit that is bound to 
VARCHAR2 types. You need to be able to store dynamic SQL text in a type that will allow more for a large 
amount of text. 
****Solution** #1**
Declare a CLOB variable, and store your SQL string within it. After the CLOB has been created, execute the 
SQL. This can be done using either native dynamic SQL or the DBMS_SQL package. For the example, 
assume that a block of text is being read from an external file, and it will be passed to a procedure to be 
processed. That text will be the SQL string that will be dynamically processed within the procedure. 
Since the external text file can be virtually any size, this text must be read into a CLOB data type and then 
passed to the procedure in this example for processing. The following procedure processes the CLOB as 
dynamic SQL. 
The first example demonstrates the parsing and execution of a dynamic SQL statement that has 
been stored in a CLOB using the DBMS_SQL package. Note that this procedure does not return any value, so 
it is not meant for issuing queries but rather for executing code. 
```sql
CREATE OR REPLACE PROCEDURE execute_clob(sql_text CLOB) AS 
  sql_string    CLOB; 
  cur_var       BINARY_INTEGER; 
  ret_var       INTEGER; 
  return_value  VARCHAR2(100); 
BEGIN 
  sql_string := sql_text; 
  cur_var := DBMS_SQL.OPEN_CURSOR; 
  DBMS_SQL.PARSE(cur_var, sql_string, DBMS_SQL.NATIVE); 
  ret_var := DBMS_SQL.EXECUTE(cur_var); 
  DBMS_SQL.CLOSE_CURSOR(cur_var); 
END; 
```
****Solution** #2** 
The second example is the same procedure written to use native dynamic SQL. You will notice that the
code is a bit shorter, and there is less work that needs to be done in order to complete the same
transaction.
```sql
CREATE OR REPLACE PROCEDURE execute_clob_nds(sql_text    IN CLOB) AS 
  sql_string    CLOB; 
BEGIN 
  sql_string := sql_text; 
  EXECUTE IMMEDIATE sql_string;
END;
```
As noted previously, the native dynamic SQL is easier to follow and takes less code to implement.
For the sake of maintaining a current code base, use of native dynamic SQL would be encouraged.
However, DBMS_SQL is still available and offers different options as mentioned in the first recipes in this
chapter. 
****How It Works****
Oracle added some new features for working with dynamic SQL into the Oracle Database 11g release.
Providing the ability to store dynamic SQL into a CLOB is certainly a useful addition. Prior to Oracle
Database 11g, the only way to dynamically process a string that was larger than 32KB was to concatenate
two VARCHAR types that were at or near 32KB in size. The largest string that could be processed by native
dynamic SQL was 64KB. With the release of Oracle Database 11g, the CLOB (character large object) can be
used in such cases, mitigating the need to concatenate two different variables to form the complete SQL. 
Using DBMS_SQL and its PARSE function, SQL that is stored within a CLOB can be easily processed. The
following lines of code are the lines from the first **Solution** that read and process the CLOB: 
```sql
cur_var := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(cur_var, v_sql, DBMS_SQL.NATIVE);
ret_var := DBMS_SQL.EXECUTE(cur_var);
DBMS_SQL.CLOSE_CURSOR(cur_var); 
```
The first line opens a new cursor using DBMS_SQL.OPEN_CURSOR. It assigns an integer to the cur_var
variable, which is then passed to the DBMS_SQL.PARSE procedure. DBMS_SQL.PARSE also accepts the SQL
CLOB and a constant DBMS_SQL.NATIVE that helps discern the dialect that should be used to process the
SQL. The dialect is also referred to as the language_flag, and it is used to determine how Oracle will
process the SQL statement. Possible values include V6 for version 6 behavior, V7 for Oracle database 7
behavior, and NATIVE to specify normal behavior for the database to which the program is connected.
After the SQL has been parsed, it can be executed using the DBMS_SQL.EXECUTE function. This function
will accept the cursor variable as input and execute the SQL. A code of 0 is returned if the SQL is
executed successfully. Lastly, remember to close the cursor using DBMS_SQL.CLOSE_CURSOR and passing
the cursor variable to it. 
The example in **Solution** #2 of this recipe demonstrates the use of native dynamic SQL for execution
of dynamic SQL text that is stored within a CLOB. Essentially no differences exist between the execution of
SQL text stored in a VARCHAR data type as opposed to SQL text stored within a CLOB for native dynamic
SQL. The code is short and precise, and it is easy to read. 

## 8-12. Passing NULL Values to Dynamic SQL  
****Problem****
You want to pass a NULL value to a dynamic query that you are using. For example, you want to query the 
EMPLOYEES table for all records that have a NULL MANAGER_ID value. 

****Solution****
Create an uninitialized variable, and place it into the USING clause. In this example, a dynamic query is 
written and executed using native dynamic SQL. The dynamic query will retrieve all employees who do 
not currently have a manager assigned to their record. To retrieve the records that are required, the 
WHERE clause needs to filter the selection so that only records containing a NULL MANAGER_ID value are 
returned. 
```sql
DECLARE 
  TYPE cur_type IS REF CURSOR; 
  cur                cur_type; 
  null_value         CHAR(1); 
  sql_string         VARCHAR2(150); 
  emp_rec            employees%ROWTYPE; 
BEGIN 
  sql_string := 'SELECT * ' || 
                    'FROM EMPLOYEES ' || 
                    'WHERE MANAGER_ID IS :null_val'; 
 
  OPEN cur FOR sql_string USING null_value; 
  LOOP 
    FETCH cur INTO emp_rec; 
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name ||  
                                                        ' - ' || emp_rec.email); 
    EXIT WHEN cur%NOTFOUND; 
  END LOOP; 
  CLOSE cur; 
 END; 
```
In this **Solution**, the bind variable :null_val has an uninitialized variable value substituted in its 
place. This will cause the query to evaluate the bind variable as a NULL value. All records that reside 
within the EMPLOYEES table and do not have a MANAGER_ID assigned to them should be printed by the 
DBMS_OUTPUT package. 

****How It Works****
It is not possible to simply pass a NULL value using native dynamic SQL. At least, you cannot pass a NULL 
as a literal. However, oftentimes it is useful to initialize a bind variable to null.  
An uninitialized variable in PL/SQL inherently has the value of NULL. Hence, if you do not initialize a 
variable, then it will contain a NULL value. Passing an uninitialized variable via the EXECUTE IMMEDIATE 
statement will have the same effect as substituting a NULL value for a bind variable. 

## 8-13. Switching Between DBMS_SQL and Native Dynamic SQL 

****Problem**** 
Your consulting company is currently migrating all its applications from using DBMS_SQL to native 
dynamic SQL. To help ensure that the migration can be done piecemeal, you want to provide the ability 
to switch between the two different techniques so that legacy code can coexist with the newer native 
dynamic SQL. 

****Solution****
When you need both the DBMS_SQL package and native dynamic SQL, you can switch between them using 
the DBMS_SQL.TO_REFCURSOR and DBMS_SQL.TO_CURSOR_NUMBER APIs. The DBMS_SQL.TO_REFCURSOR API 
provides the ability to execute dynamic SQL using the DBMS_SQL package and then convert the DBMS_SQL 
cursor to a REF CURSOR. The DBMS_SQL.TO_CURSOR_NUMBER API allows for executing dynamic SQL via a REF 
CURSOR and then converting to DBMS_SQL for data retrieval. 
The following example illustrates the usage of DBMS_SQL.TO_REFCURSOR. In the example, a simple 
dynamic query is being executed using DBMS_SQL, and the cursor is then being converted to a REF CURSOR. 
```sql
DECLARE 
  sql_string           CLOB; 
  cur_var              BINARY_INTEGER := DBMS_SQL.OPEN_CURSOR; 
  ref_cur              SYS_REFCURSOR; 
  return_value         BINARY_INTEGER; 
  cur_rec              jobs%ROWTYPE; 
  salary               NUMBER := &salary; 
BEGIN 
  -- Formulate query 
  sql_string := 'SELECT * FROM JOBS ' || 
                      'WHERE MAX_SALARY >= :sal'; 
  -- Parse SQL 
  DBMS_SQL.PARSE(cur_var, sql_string, DBMS_SQL.NATIVE); 
 
  -- Bind variable(s) 
  DBMS_SQL.BIND_VARIABLE(cur_var, 'sal', salary); 
   
  -- Execute query and convert to REF CURSOR 
 
  return_value := DBMS_SQL.EXECUTE(cur_var); 
  ref_cur := DBMS_SQL.TO_REFCURSOR(cur_var); 
  DBMS_OUTPUT.PUT_LINE('Jobs that have a maximum salary over ' || salary); 
  LOOP 
    FETCH ref_cur INTO cur_rec; 
    DBMS_OUTPUT.PUT_LINE(cur_rec.job_id || ' - ' || cur_rec.job_title); 
    EXIT WHEN ref_cur%NOTFOUND; 
  END LOOP; 
 
  CLOSE ref_cur; 
 
END; 
```
The example prompts for the entry of a maximum salary via the :sal bind variable and the SQL*Plus 
&salary substitution variable. The DBMS_SQL API then binds the maximum salary that was entered to the 
dynamic SQL string and executes the query to find all jobs that have a maximum salary greater than the 
amount that was entered. Once the query is executed, the cursor is converted to a REF CURSOR using the 
DBMS_SQL.TO_REFCURSOR API. Native dynamic SQL is then used to process the results of the query. As you 
can see, the native dynamic SQL is much easier to read and process. The advantage of converting to a 
REF CURSOR is to have the ability to easily process code using native dynamic SQL but still have some of 
the advantages of using DBMS_SQL for querying the data. For instance, if the number of bind variables was 
unknown until runtime, then DBMS_SQL would be required. 
A similar technique can be used if DBMS_SQL is required to process the results of a query. The 
DBMS_SQL.TO_CURSOR_NUMBER API provides the ability to convert a cursor from a REF CURSOR to DBMS_SQL. 
The following example shows the same query on the JOBS table, but this time native dynamic SQL is used 
to set up the query and execute it, and DBMS_SQL is used to describe the table structure. One of the nice 
features of the DBMS_SQL API is that it is possible to describe the columns of a query that will be returned. 
```sql
DECLARE 
  sql_string         CLOB; 
  ref_cur            SYS_REFCURSOR; 
  cursor_var         BINARY_INTEGER; 
  cols_var           BINARY_INTEGER; 
  desc_var           DBMS_SQL.DESC_TAB; 
  v_job_id           NUMBER; 
  v_job_title        VARCHAR2(25); 
  salary             NUMBER(6) := &salary; 
  return_val         NUMBER; 
 
BEGIN 
  -- Formulate query 
  sql_string := 'SELECT * FROM JOBS ' || 
                          'WHERE MAX_SALARY >= :sal'; 
  -- Open REF CURSOR 
  OPEN ref_cur FOR sql_string USING salary; 
   
  cursor_var := DBMS_SQL.TO_CURSOR_NUMBER(ref_cur); 
  DBMS_SQL.DESCRIBE_COLUMNS(cursor_var, cols_var, desc_var); 
  DBMS_SQL.CLOSE_CURSOR(cursor_var); 
   
  FOR x IN 1 .. cols_var LOOP 
    DBMS_OUTPUT.PUT_LINE(desc_var(x).col_name || ' - ' || 
                           CASE desc_var(x).col_type 
                                      WHEN 1 THEN 'VARCHAR2' 
                                      WHEN 2 THEN 'NUMBER' 
                           ELSE 'OTHER' 
                           END); 
  END LOOP; 
END; 
```
Each of these techniques has their place within the world of PL/SQL programming. Using this type 
of conversion is especially useful for enabling your application to use the features DBMS_SQL has to offer 
without compromising the ease and structure of native dynamic SQL. 

****How It Works**** 
Oracle Database 11g added some new capabilities to dynamic SQL. One of those new features is the 
ability to convert between native dynamic SQL and DBMS_SQL. DBMS_SQL provides some functionality that 
is not offered by the newer and easier native dynamic SQL API. Now that Oracle Database 11g provides 
the ability to make use of native dynamic SQL but still gain the advantages of using DBMS_SQL, Oracle 
dynamic SQL is much more complete. 
The DBMS_SQL.TO_REFCURSOR API is used to convert SQL that is using DBMS_SQL into a REF CURSOR, 
which allows you to work with the resulting records using native dynamic SQL. To convert SQL to a REF 
CURSOR, you will use DBMS_SQL to parse the SQL, bind any variables, and finally to execute it. Afterward, 
you call DBMS_SQL.TO_REFCURSOR and pass the original DBMS_SQL cursor as an argument. This will return a 
REF CURSOR that can be used to work with the results from the query. The statement that performs the 
conversion contains DBMS_SQL.EXECUTE. The EXECUTE function accepts a DBMS_SQL cursor as an argument. 
As a result, a REF CURSOR is returned, and it can be used to work with the results from the dynamic query. 
Conversely, DBMS_SQL.TO_CURSOR_NUMBER can be used to convert a REF CURSOR into a DBMS_SQL cursor. 
You may choose to do this in order to use some additional functionality that DBMS_SQL has to offer such 
as the ability to DESCRIBE an object (DESCRIBE is a SQL*Plus feature). As you can see in the second 
example, native dynamic SQL is used to open the REF CURSOR and bind the variable to the SQL. Once this 
has been completed, the cursor is converted to DBMS_SQL using DBMS_SQL.TO_CURSOR_NUMBER and passing 
the REF CURSOR. After this conversion is complete, you can utilize the DBMS_SQL API to work with the 
resulting cursor.

## 8-14. Guarding Against SQL Injection Attacks  

****Problem**** 
To provide the best security for your application, you want to ensure that your dynamic SQL statements 
are unable to be altered as a result of data entered from an application form. 

****Solution****
Take care to provide security against SQL injection attacks by validating user input prior and using it in 
your dynamic SQL statements or queries. The easiest way to ensure that there are no malicious 
injections into your SQL is to make use of bind variables.  
The following code is an example of a PL/SQL procedure that is vulnerable to SQL injection because 
it concatenates a variable that is populated with user input and does not properly validate the input 
prior: 
```sql
CREATE OR REPLACE PROCEDURE check_password(username IN VARCHAR2) AS 
  sql_stmt    VARCHAR2(1000); 
  password    VARCHAR2(30); 
BEGIN 
 sql_stmt := 'SELECT password ' || 
                       'FROM user_records ' || 
                       'WHERE username = ''' || username || '''; 
  EXECUTE sql_stmt 
  INTO password; 
 
  -- PROCESS PASSWORD 
END; 
  CHAPTER 8  DYNAMIC SQL 
185 
 
To properly code this example to guard against SQL injection, use bind variables. The following is 
the same procedure that has been rewritten to make it invulnerable to SQL injection: 
 
CREATE OR REPLACE PROCEDURE check_password(username IN VARCHAR2) AS 
  sql_stmt    VARCHAR2(1000); 
  password    VARCHAR2(30); 
BEGIN 
  sql_stmt := 'SELECT password ' || 
              'FROM user_records ' || 
              'WHERE username = :username'; 
 
  EXECUTE sql_stmt 
  INTO password 
  USING username; 
 
  -- PROCESS PASSWORD 
END; 
```
Making just a couple of minor changes can significantly increase the security against SQL injection 
attacks.  
** **How It Works****
SQL injection attacks can occur when data that is accepted as input from an application form is 
concatenated into dynamic SQL queries or statements without proper validation. SQL injection is a form 
of malicious database attack that is caused by a user placing some code or escape characters into a form 
field so that the underlying application SQL query or statement becomes affected in an undesirable 
manner. In the **Solution** to this recipe, all passwords stored in the USER_RECORDS table could be 
compromised if a malicious user were to place a line of text similar to the following into the form field 
for the USERNAME: 
 
'WHATEVER '' OR username is NOT NULL--' 
 
The strange-looking text that you see here can cause major issues because it essentially changes the 
query to read as follows: 
```sql
SELECT password 
FROM user_records 
WHERE username = 'WHATEVER ' OR username is NOT NULL; 
```
Bind variables can be used to guard against SQL injection attacks, because their contents are not 
interpreted at all by Oracle. The value of a bind variable is never parsed as part of the string containing 
the SQL query or statement to be executed. Thus, the use of bind variables provides absolute protection 
against SQL injection attacks.  
Another way to safeguard your code against SQL injection attacks is to validate user input to ensure 
that it is not malicious. Only valid input should be used within a statement or query. 
There are ways to validate user input depending upon the type of input you are receiving. For 
instance, to verify the integrity of user input, you can use regular expressions. If you are expecting to 
receive an e-mail address from a user input field, then the value that is passed into your code should be 
verified to ensure that it is in proper format of an e-mail address. Here’s an example: 
```sql
IF owa_pattern.match(email_variable,'^\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}' || 
           '[.,0-9,a-z,A-Z,_]\w{1,}'|| 
           '@\w{1,}[.,0-9,a-z,A-Z,_]\' || 
           'w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}$') then 
  -- Perform valid transaction 
ELSE 
  -- Raise an error message 
```
It is imperative that you do not allow users of your applications to see the Oracle error codes that are 
returned by an error. Use proper exception handling (covered in Chapter 9) to ensure that you are 
catching any possible exceptions and returning a vaguely descriptive error message to the user. It is not 
wise to allow Oracle errors or detailed error messages to be displayed because they will most likely 
provide a malicious user with valuable information for attacking your database. 
Using bind variables, validating user input, and displaying user-friendly and appropriate error 
messages can help ensure that your database is not attacked. It is never an enjoyable experience to 
explain to your users that all usernames and passwords were compromised. Time is much better spent 
securing your code than going back to clean up after a malicious attack. 
