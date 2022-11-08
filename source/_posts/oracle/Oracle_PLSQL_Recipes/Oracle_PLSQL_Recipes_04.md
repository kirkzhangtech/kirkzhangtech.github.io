---
title: Oracle PLSQL Recipes 04-Functions, Packages,and Procedures
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

# 4. Functions, Packages,and Procedures

PL/SQL applications are composed of functions, procedures, and packages. Functions are PL/SQL 
programs that accept zero or more parameters and always return a result. Procedures are similar to 
functions, but they are not required to return a result. Packages are a combination of related functions, 
procedures, types, and variables. Each of these PL/SQL components helps formulate the basis for small 
and large applications alike. They differ from anonymous blocks that have been covered in previous 
recipes because they are all named routines that are stored within the database. Together, they provide 
the advantage of reusable code that can be called from any schema in the database to which you’ve 
granted the appropriate access.  
Let’s say you have a few lines of code that perform some calculations on a number and return a 
result. Will these calculations help you anywhere else? If so, then you should probably encapsulate this 
code in a function. Maybe you have a nightly script that you use as a batch job to load and execute. 
Perhaps this script can be turned into a stored procedure and Oracle Scheduler can kick it off each night. 
What about tasks that use more than one procedure or function? Can these be combined at all? A 
PL/SQL package would probably be a good choice in this case. After reading through the recipes in this 
chapter, you should be able to answer these questions at the drop of a hat. 
■ Note We mention job scheduling in our introduction to this chapter. However, we actually address that topic in 
Chapter 11, which is an entire chapter dedicated to running PL/SQL jobs, whether for application purposes or for 
database maintenance. 
## 4-1. Creating a Stored Function 
****Problem**** 
One of your programs is using a few lines of code repeatedly for performing a calculation. Rather than 
using the same lines of code numerous times throughout your application, it makes more sense to 
encapsulate(美[ɪn'kæpsjə'let]vt.压缩;将…装入胶囊) the functionality into a common routine that can be called and reused time and time again.
****Solution****
Create a stored function to encapsulate your code, and save it into the database. Once stored in the 
database, any user with execution privileges can invoke the function. Let’s take a look at a function to 
give you an idea of how they work.
In this example, the function is used to round a given number to the nearest quarter. This function 
works well for accepting a decimal value for labor hours and rounding to the nearest quarter hour. 

```sql
-- at return part and no paramter name just a type
CREATE OR REPLACE FUNCTION CALC_QUARTER_HOUR(HOURS IN NUMBER) RETURN NUMBER AS  
  CALCULATED_HOURS NUMBER := 0; 
BEGIN 
  
   -- if HOURS is greater than one, then calculate the decimal portion 
   -- based upon quarterly hours  
 IF HOURS > 1 THEN 
  -- calculate the modulus of the HOURS variable and compare it to • 
  -- fractional values 
    IF MOD(HOURS, 1) <=.125 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1); 
    ELSIF MOD(HOURS, 1) > .125 AND MOD(HOURS,1) <= .375 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.25,1); 
    ELSIF MOD(HOURS, 1) > .375 AND MOD(HOURS,1) <= .625 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.50,1); 
    ELSIF MOD(HOURS, 1) > .63 AND MOD(HOURS,1) <= .825 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.75,1); 
    ELSE 
       CALCULATED_HOURS := ROUND(HOURS,1); 
       
    END IF; 
     
  ELSE 
    -- if HOURS is less than one, then calculate the entire value• 
    -- based upon quarterly hours 
    IF HOURS > 0 AND HOURS <=.375 THEN 
        CALCULATED_HOURS := .25; 
    ELSIF HOURS > .375 AND HOURS <= .625 THEN 
        CALCULATED_HOURS := .5; 
    ELSIF HOURS > .625 AND HOURS <= .825 THEN 
        CALCULATED_HOURS := .75; 
    ELSE 
        CALCULATED_HOURS := ROUND(HOURS,1); 
    END IF; 
     
  END IF; 
   
  RETURN CALCULATED_HOURS; 
   
END CALC_QUARTER_HOUR; 
``` 
This function accepts one value as input, a decimal value representing a number of hours worked. 
The function then checks to see whether the value is greater than one, and if so, it performs a series of 
manipulations to round the value to the nearest quarter hour. If the value is not greater than one, then 
the function rounds the given fraction to the nearest quarter.  
■ Note See Recipe 4-2 for an example showing the execution of this function. 

****How It Works**** 
A function is a named body of code that is stored within the database and returns a value. Functions are 
often used to encapsulate logic so that it can be reused. A function can accept zero or more parameters 
and always returns a value. A function is comprised of a header, an execution section containing 
statements, and an optional exception block.  
For example, the header for our **Solution** function is as follows:  
```sql 
CREATE OR REPLACE FUNCTION CALC_QUARTER_HOUR(HOURS IN NUMBER) RETURN NUMBER AS  
```
The OR REPLACE clause is optional, but in practice it is something you’ll most always want. Specifying 
OR REPLACE will replace a function that is already under the same name in the same schema. (A function 
name must be unique within its schema.)  
Functions can take zero or more parameters, which can be any datatype including collections. You 
will learn more about collections in Chapter 10. Our example function takes one parameter, a NUMBER 
representing some number of hours.  
The parameters that can be passed to a function can be declared in three different ways, namely, as 
IN, OUT, and IN OUT. The difference between these three declaration types is that parameters declared as 
IN are basically read-only, OUT parameters are write-only, and IN OUT parameters are read-write. The 
value of an OUT parameter is initially NULL but can contain a value after the function has returned. 
Similarly, the value of an IN OUT can be modified within the function, but IN parameters cannot. 
■ Note Typically you want only IN parameters for a function. If you find yourself creating a function with OUT or IN 
OUT parameters, then reconsider and think about creating a stored procedure instead. This is not a hard-and-fast 
requirement, but it is generally good practice for a function to return only one value. 
The declaration section of the function begins directly after the header, and unlike the anonymous 
block, you do not include the DECLARE keyword at the top of this section. Just like the anonymous block, 
the declaration section is where you will declare any variables, types, or cursors for your function. Our 
declaration section defines a single variable: 
 ```sql
  CALCULATED_HOURS NUMBER := 0; 
 ```
Following the declaration is the executable section, which is laid out exactly like that of an 
anonymous block. The only difference with a function is that it always includes a RETURN statement. It 
can return a value of any datatype as long as it is the same datatype specified in the RETURN clause of the 
header. 
Following the return clause can be an optional EXCEPTION block to handle any errors that were 
encountered in the function. The following example is the same function that was demonstrated in the 
**Solution** to this recipe, except that it has an added EXCEPTION block. 
```sql 
CREATE OR REPLACE FUNCTION CALC_QUARTER_HOUR(HOURS IN NUMBER) 
 RETURN NUMBER AS  
  CALCULATED_HOURS NUMBER := 0; 
BEGIN 
  
   -- if HOURS is greater than one, then calculate the decimal portion 
 
  -- based upon quarterly hours  
 IF HOURS > 1 THEN 
  -- calculate the modulus of the HOURS variable and compare it to  
 
  -- fractional values 
    IF MOD(HOURS, 1) <=.125 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1); 
    ELSIF MOD(HOURS, 1) > .125 AND MOD(HOURS,1) <= .375 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.25,1); 
    ELSIF MOD(HOURS, 1) > .375 AND MOD(HOURS,1) <= .625 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.50,1); 
    ELSIF MOD(HOURS, 1) > .63 AND MOD(HOURS,1) <= .825 THEN 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.75,1); 
    ELSE 
       CALCULATED_HOURS := ROUND(HOURS,1); 
       
    END IF; 
     
  ELSE 
    -- if HOURS is less than one, then calculate the entire value 
 
    -- based upon quarterly hours 
    IF HOURS > 0 AND HOURS <=.375 THEN 
        CALCULATED_HOURS := .25; 
    ELSIF HOURS > .375 AND HOURS <= .625 THEN 
        CALCULATED_HOURS := .5; 
    ELSIF HOURS > .625 AND HOURS <= .825 THEN 
        CALCULATED_HOURS := .75; 
    ELSE 
        CALCULATED_HOURS := ROUND(HOURS,1); 
    END IF; 
     
  END IF; 
   
  RETURN CALCULATED_HOURS; 
 
EXCEPTION 
  WHEN VALUE_ERROR THEN 
    DBMS_OUTPUT.PUT_LINE('VALUE ERROR RAISED, TRY AGAIN'); 
    RETURN -1; 
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('UNK ERROR RAISED, TRY AGAIN'); 
    RETURN -1; 
END CALC_QUARTER_HOUR; 
```
Again, don’t fret if you are unfamiliar with how to handle exceptions, because they will be discussed 
in detail later in the book. At this point, it is important to know that you have the ability to declare 
exceptions that can be caught by code so that your program can process abnormalities or errors 
accordingly. 
Functions are important not only for encapsulation but also for reuse. As a matter of fact, the 
function defined within the **Solution** uses other built-in PL/SQL functions within them. There are entire 
libraries that consist of functions that are helpful for performing various transactions. Functions are a 
fundamental part of PL/SQL programming, just as they are in any other language. It is up to you to 
ensure that your database is stocked with plenty of useful functions that can be used in your current and 
future applications. 

## 4-2. Executing a Stored Function from a Query 

****Problem**** 
You want to invoke a function from an SQL query. For example, you want to take the quarter-hour 
rounding function from Recipe 4-1 and invoke it on hourly values in a database table.  
****Solution**** 
Write a query and invoke the function on values returned by the SELECT statement. In the following lines, 
the function that was written in the previous recipe will be called. The results of calling the function from 
within a query are as follows: 
```sql 
SQL> select calc_quarter_hour(.17) from dual; 
 
CALC_QUARTER_HOUR(.17) 
---------------------- 
  .25 
 
SQL> select calc_quarter_hour(1.3) from dual; 
 
CALC_QUARTER_HOUR(1.3) 
---------------------- 
 1.25 
```
****How It Works**** 
There are a few ways in which a function can be called, one of which is via a query. A function can be 
executed inline via a SELECT statement, as was the case with the **Solution** to this recipe. A function can 
also be executed by assigning it to a variable within an anonymous block or another function/procedure. 
Since all functions return a value, this works quite well. For instance, the following QTR_HOUR variable can 
be assigned the value that is returned from the function: 

```sql 
DECLARE 
  qtr_hour          NUMBER; 
BEGIN 
  qtr_hour := calc_quarter_hour(1.3); 
  DBMS_OUTPUT.PUT_LINE(qtr_hour); 
END; 
 
You can also execute a function as part of an expression. In the following statement, you can see 
that TOTAL_HOURS is calculated by adding the bill total to the value returned from the function: 
 
DECLARE 
  total_hours           NUMBER; 
  hours                 NUMBER := 8; 
BEGIN 
  total_hours := hours + calc_quarter_hour(3.2); 
  DBMS_OUTPUT.PUT_LINE(total_hours); 
END; 
```
The way in which your program calls a function depends on its needs. If you need to simply return 
some results from the database and apply a function to each of the results, then use a query. You may 
have an application that needs to pass a value to a function and use the result at some later point, in 
which case assigning the function to a variable would be a good choice for this case. Whatever the case 
may be, functions provide convenient calling mechanisms to cover most use cases. 

## 4-3. Optimizing a Function That Will Always Return the Same Result for a Given Input 
****Problem**** 
You want to create a function that will return the same result whenever a given input, or set of inputs, is 
presented to it. You want the database to optimize based upon that deterministic nature.  
****Solution****
Specify the DETERMINISTIC keyword when creating the function to indicate that the function will always 
return the same result for a given input. For instance, you want to return a specific manager name based 
upon a given manager ID. Furthermore, you want to optimize for the fact that any given input will 
always return the same result. The following example demonstrates a function that does so by specifying 
the DETERMINISTIC keyword:  
```sql
CREATE OR REPLACE FUNCTION manager_name(mgr_id IN NUMBER) 
RETURN VARCHAR2 
DETERMINISTIC IS 
  first_name     employees.first_name%TYPE; 
  last_name      employees.last_name%TYPE; 
BEGIN 
  IF mgr_id IS NOT NULL THEN 
    SELECT first_name, last_name 
    INTO first_name, last_name 
    FROM EMPLOYEES 
    WHERE employee_id = mgr_id; 
 
    RETURN first_name || ' ' || last_name; 
  ELSE 
    RETURN 'N/A'; 
  END IF; 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    RETURN 'N/A'; 
END; 
```
This function will return the manager name for a matching EMPLOYEE_ID. If there are no matches for 
the EMPLOYEE_ID found, then N/A will be returned. 
****How It Works****
A deterministic function is one that always returns the same resulting value as long as the parameters 
that are passed in are the same. This type of function can be useful for improving performance. The 
function will be executed only once for any given set of parameters. This means that if the same 
parameters are passed to this function in subsequent calls, then the function will be bypassed and return 
the cached value from the last execution using those parameters. This can really help in cases where 
calculations are being performed and repeated calls to the function may take a toll on performance. 
The DETERMINISTIC clause is required in a couple of cases. In the event that you are calling a function 
in an expression of a function-based index, you need to write the function as DETERMINISTIC, or you will 
receive errors. Similarly, a function must be made DETERMINISTIC if it is being called in an expression of a 
materialized view query or if the view is marked as ENABLE QUERY REWRITE or REFRESH FAST. 

## 4-4. Creating a Stored Procedure 

****Problem****

There is a database task that you are performing on a regular basis. Rather than executing a script that 
contains lines of PL/SQL code each time you execute the task, you want to store the code in the database 
so that you can simply execute the task by name or so that you can schedule it to execute routinely via 
Oracle Scheduler. 

■ Note See Chapter 11 for information on scheduling PL/SQL jobs using Oracle Scheduler. 

****Solution****
Place the code that is used to perform your task within a stored procedure. The following example 
creates a procedure named INCREASE_WAGE to update the employee table by giving a designated 
employee a pay increase. Of course, you will need to execute this procedure for each eligible employee 
in your department. Storing the code in a procedure makes the task easier to perform. 
```sql 
CREATE OR REPLACE PROCEDURE INCREASE_WAGE (empno_in IN NUMBER, 
                                           pct_increase IN NUMBER, 
                                           upper_bound IN NUMBER) AS 
  emp_count    NUMBER := 0; 
  emp_sal      employees.salary%TYPE; 
   
  Results   VARCHAR2(50); 
  
BEGIN 
    SELECT salary 
    INTO emp_sal 
    FROM employees 
    WHERE employee_id = empno_in; 
     
    IF emp_sal < upper_bound 
    AND round(emp_sal + (emp_sal * pct_increase), 2) < upper_bound THEN 
     
        UPDATE employees 
        SET salary = round(salary + (salary * pct_increase),2) 
        WHERE employee_id = empno_in; 
         
        results := 'SUCCESSFUL INCREASE'; 
    ELSE 
        results := 'EMPLOYEE MAKES TOO MUCH, DECREASE RAISE PERCENTAGE'; 
    END IF; 
     
  DBMS_OUTPUT.PUT_LINE(results);
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20001, 'No employee match for the given ID');
END; 
The following are the results from executing the procedure for employee number 198. In the
example, the employee is being given a 3 percent increase and an upper bound of $5,000. 
BEGIN 
  increase_wage(198,.03,5000);
END; 
```
SUCCESSFUL INCREASE
Statement processed. 

****How It Works**** 
In the example, the procedure accepts three parameters: the employee number, the percent of increase
they will receive, and an upper salary bound. You can then invoke the procedure by name, passing in the
required parameters. 
The procedure first searches the database for the provided employee number. If a record for that
employee is found, then the employee record is queried for the current salary. If the salary is less than
the upper bound and the resulting new salary will still be less than the upper bound, then the increase 
will be applied via an UPDATE statement. If the employee is not found, then an alert message will be 
displayed. As you can see, this procedure can be called for any individual employee, and it will increase 
their wage accordingly as long as the increase stays within the bound. 
Stored procedures can be used to encapsulate functionality and store code in the database data 
dictionary. Much like a function, they can accept zero or more values as parameters, including 
collections. A stored procedure is structured in much the same way as a function in that it includes a 
header, an executable section, and an optional exception-handling block. However, a procedure cannot 
include a RETURN clause in the header, and it does not return a value. 
For example, in the **Solution** to this recipe, the procedure contains the following header: 
```sql
CREATE OR REPLACE PROCEDURE INCREASE_WAGE (empno_in IN NUMBER, 
                                           pct_increase IN NUMBER, 
                                           upper_bound IN NUMBER) AS 
```
The header uses the OR REPLACE clause to indicate that this procedure should replace any procedure 
with the same name that already exists. The procedure accepts three parameters, and although all of 
them are NUMBER type, any datatype can be accepted as a parameter. The declaration section comes after 
the header, and any cursors, variables, or exceptions that need to be declared should be taken care of in 
that section. Next, the actual work that the procedure will do takes place between the BEGIN and END 
keywords. Note that the header does not contain a RETURNS clause since procedures cannot return any 
values. 
The advantage of using procedures is that code can be encapsulated into a callable named routine 
in the data dictionary and can be called by many users. To create a procedure in your schema, you must 
have the CREATE PROCEDURE system privilege. You can create a stored procedure in another schema if you 
have the CREATE ANY PROCEDURE system privilege. 

## 4-5. Executing a Stored Procedure

****Problem****
You want to execute a stored procedure from SQL*Plus. 

****Solution**** 
Open SQL*Plus, and connect to the database schema that contains the procedure you are interested in 
executing. Execute the procedure by issuing the following command: 
 
```sql
EXEC procedure_name([param1, param2,...]); 
```

For instance, to execute the procedure that was created in Recipe 4-3, you would issue the following 
command:

```sql
EXEC increase_wage(198, .03, 5000); 
```

This would invoke the `INCREASE_WAGE` procedure, passing three parameters: EMPLOYEE_ID, a 
percentage of increase, and an upper salary bound.

You can also execute a stored procedure by creating a simple anonymous block that contains the 
procedure call, as depicted(vt.描述,描画) in the following code:

```sql
BEGIN 
  procedure_name([param1, param2,…]); 
END; 
```

Using this technique, invoking the stored procedure that was created in Recipe 4-3 would resemble 
the following: 

```sql
BEGIN 
  increase_wage(198,.03,5000); 
END; 
```

Both techniques work equally well, but the latter would be better to use if you wanted to execute 
more than one procedure or follow up with more PL/SQL statements. If you are running a single 
procedure from SQL*Plus, then using `EXEC` is certainly a good choice. 

****How It Works****

A stored procedure can be executed using the `EXEC` keyword. You can also type `EXECUTE` entirely. Both the 
long and shortened versions will work.  

It is also possible to execute a procedure that is contained within other schemas, if the current user 
has execute privileges on that procedure. In such a scenario, use dot notation to qualify the procedure 
name. Here’s an example: 

```sql
EXEC different_schema.increase_wage(emp_rec.employee_id, pct_increase, upper_bound); 
```

■ Note To learn more about privileges regarding stored programs, please take a look at Recipe 4-11.
A procedure can also be invoked from within another procedure by simply typing the name and 
placing the parameters inside parentheses, if there are any. For instance, the following lines of code 
demonstrate calling a procedure from within another procedure. The procedure in this example invokes 
the procedure that was shown in Recipe 4-3. 

```sql
CREATE OR REPLACE PROCEDURE grant_raises (pct_increase IN NUMBER, 
                                          upper_bound IN NUMBER) as 
  CURSOR emp_cur is 
  SELECT employee_id, first_name, last_name 
  FROM employees; 
BEGIN 
  -- loop through each record in the employees table 
  FOR emp_rec IN emp_cur LOOP
      DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name);
      -- inside A invoke B procedure
      increase_wage(emp_rec.employee_id, pct_increase, upper_bound); 
  END LOOP; 
END;  
```

The procedure `GRANT_RAISES` applies an increase across the board to all employees. It loops through 
all employee records, and the `INCREASE_WAGE` procedure is called with each iteration. The procedure is 
called without the use of the `EXEC` keyword since it is being invoked by another procedure rather than 
directly from the SQL*Plus command line.

**summary**
1. execute procedure by EXEC statement directly
2. using anonymous code block within procedure name
3. inside A procedure invoke B procedure

## 4-6. Creating Functions Within a Procedure or Code Block 

****Problem****

You want to create some functions within a stored procedure. You want the functions to be local to the 
procedure, available only from the procedure’s code block.

****Solution****
Create a stored procedure, and then create functions within the declaration section. The internal 
functions will accept parameters and return values just as an ordinary(adj.普通的,平凡) stored function would, except that the scope of the functions will be constrained to the outer code block or to the procedure. The procedure 
that is demonstrated in this **Solution** embodies two functions. One of the functions is used to calculate 
the federal tax for an employee paycheck, while the other calculates the state tax. 
```sql
CREATE OR REPLACE PROCEDURE calc_employee_paycheck(emp_id IN NUMBER) as 
  emp_rec          employees%ROWTYPE; 
  paycheck_total   NUMBER; 
 
-- function for state tax 
  FUNCTION calc_state (sal IN NUMBER)  
    RETURN NUMBER IS 
  BEGIN 
    RETURN sal *  .08; 
  END; 

-- function for federal tax 
 FUNCTION calc_federal (sal IN NUMBER)  
    RETURN NUMBER IS 
  BEGIN 
    RETURN sal *  .12; 
  END; 
 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Calculating paycheck with taxes'); 
  SELECT * 
  INTO emp_rec 
  FROM employees 
  WHERE employee_id = emp_id; 
 
  paycheck_total := emp_rec.salary - calc_state(emp_rec.salary) - 
                    calc_federal(emp_rec.salary); 
 
 DBMS_OUTPUT.PUT_LINE('The paycheck total for ' || emp_rec.last_name || 
    ' is ' || paycheck_total); 
CHAPTER 4  FUNCTIONS, PACKAGES, AND PROCEDURES 
74 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20001, 
    'No matching employee for the given ID'); 
END;
```

****How It Works****

Functions and procedures too can be contained within other bodies of code. Creating a function 
within a declaration section will make the function accessible to the block that contains it. The 
declaration of the function is the same as when you are creating a stored function, with the exception of 
the `CREATE OR REPLACE` keywords. Any variables that are declared inside the function will be accessible 
only to that function, not to the containing object.
Creating a function or procedure inside a PL/SQL code block can be useful when you want to make 
a function that is only to be used by the containing object. However, if you find that the body of the 
embedded function may change frequently, then coding a separate stored function may prove to be 
more efficient.

## 4-7. Passing Parameters by Name 

****Problem****

You have a procedure in your database that accepts a large number of parameters. When calling the 
procedure, you would rather not worry that the positioning of the parameters is correct. 

****Solution****

Rather than trying to pass all the parameters to the procedure in the correct order, you can pass them by 
name. The code in this **Solution** calls a procedure that accepts six parameters, and it passes the 
parameters by name rather than in order. 
Procedure Declaration: 
```sql
PROCEDURE process_emp_paycheck(EMP_ID IN NUMBER, 
   PAY_CODE IN NUMBER, 
   SICK_USED IN NUMBER, 
   VACATION_USED IN NUMBER, 
   FEDERAL_TAX IN NUMBER, 
   STATE_TAX IN NUMBER); 
Procedure Execution: 
EXEC process_emp_paycheck(EMP_ID=>10, 
   PAY_CODE=>10, 
   VACATION_USED=>8.0, 
   SICK_USED=>8.0, 
   STATE_TAX=>.06, 
   FEDERAL_TAX=>.08); 
```
As you can see, by passing the parameters by name, they do not need to follow the same positional 
ordering as they do within the declaration of the procedure.

****How It Works****
To pass a parameter by name, you list the parameter name followed by an arrow (consisting of an equal 
sign and a greater-than symbol) pointing to the value you are passing. The following pseudocode depicts 
this technique:

```sql
procedure_name(parameter=>value); 
```

Although it can be more verbose to use named parameters, passing parameters by name can be very 
handy when there are several parameters to pass because you do not need to worry about passing them 
in the correct order. It is also helpful because it increases readability.  
Both procedures and functions can accept positional and named parameters. Neither notation is 
superior to the other, so which one you choose to use is completely dependant upon the procedure or 
function that is currently being called. However, named parameters are a safe choice if trying to 
maintain consistency with procedure calls throughout your application or your organization. 
Although not recommended, you can use both positional and named notation when passing 
parameters within the same call. When doing so, you need to place the parameters that you want to pass 
using positional notation first, followed by the parameters that you want to pass using named notation. 
The following execution illustrates using both positional and named notation while passing parameters 
to the PROCESS_EMP_PAYCHECK procedure: 
```sql
EXEC process_emp_paycheck(198, 10, 0, 
   SICK_USED=>4.0, 
   STATE_TAX=>.05, 
   FEDERAL_TAX=> .04); 
```

This particular call passed both of the first parameters by position, those being EMP_ID and PAY_CODE. 
The last three parameters are passed by named notation. 

summary :  
1. if you specify parameter name , then would ignore order of you define parameter


## 4-8. Setting Default Parameter Values 

****Problem**** 
You want to create a procedure that accepts several parameters. However, some of those parameters 
should be made optional and contain default values.  

****Solution****
You can allow the procedure caller to omit the parameters if default values are declared for the variables 
within the procedure. The following example shows a procedure declaration that contains default 
values: 
```sql
PROCEDURE process_emp_paycheck(EMP_ID IN NUMBER, 
   PAY_CODE IN NUMBER, 
   SICK_USED IN NUMBER, 
   VACATION_USED IN NUMBER, 
   FEDERAL_TAX IN NUMBER DEFAULT .08,  -- could ignore value
   STATE_TAX IN NUMBER DEFAULT .035);  -- could ignore value
```

And here is an example execution: 

```sql
EXEC process_emp_paycheck(EMP_ID=>10, 
                           PAY_CODE=>10, 
                           VACATION_USED=>8.0, 
                           SICK_USED=>8.0); 
```

Since the procedure contains default values, the parameters can be omitted when the procedure is 
called. 

****How It Works**** 
The ability to provide a default value for a variable declaration is optional. To do so, you must provide 
the declaration of the variable with the keyword DEFAULT followed by the value, as shown in the **Solution** 
to this recipe. If a default value is declared, then you needn’t specify a value for the parameter when the 
function or procedure is called. If you do specify a value for a parameter that has a default value, the 
specified value overrides the default.


## 4-9. Collecting Related Routines into a Single Unit

****Problem**** 
You have a number of procedures and functions that formulate(vt.规划;用公式表示) an entire application when used 
together. Rather than defining each subprogram individually, you prefer to combine all of them into a 
single, logically related entity.  

****Solution****
Create a PL/SQL package that in turn declares(vt.宣布,声明) and defines each of the procedures together as an 
organized entity. You declare each of the subprograms in the package specification (otherwise known as 
a header) and define them in the package body. 
The following example shows the creation of a PL/SQL package containing two procedures and a 
variable.

First, you create the package specification: 

```sql 
CREATE OR REPLACE PACKAGE process_employee_time IS  
  total_employee_salary  NUMBER; -- global variable inside 
  PROCEDURE grant_raises(pct_increase IN NUMBER, 
                                              upper_bound IN NUMBER); 
  PROCEDURE increase_wage (empno_in IN NUMBER, 
                           pct_increase IN NUMBER, 
                           upper_bound IN NUMBER) ; 
END; 
```
The specification lists the procedures, functions, and variables that you want to be visible from 
outside the package. Think of the specification as the external interface to your package. 
Next, create the package body: 

```sql
CREATE OR REPLACE PACKAGE BODY process_employee_time IS 

  PROCEDURE grant_raises (pct_increase IN NUMBER, 
                          upper_bound IN NUMBER) as 
  CURSOR emp_cur is 
  SELECT employee_id, first_name, last_name 
  FROM employees; 
BEGIN
  -- loop through each record in the employees table 
  FOR emp_rec IN emp_cur LOOP 
      DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name); 
      increase_wage(emp_rec.employee_id, pct_increase, upper_bound); 
  END LOOP; 
END;  

 PROCEDURE INCREASE_WAGE (empno_in IN NUMBER, 
                          pct_increase IN NUMBER, 
                          upper_bound IN NUMBER) AS 
  emp_count    NUMBER := 0; 
  emp_sal      employees.salary%TYPE; 
   
  Results   VARCHAR2(50); 
   
BEGIN 
 
  SELECT count(*) 
  INTO emp_count 
  FROM employees 
  WHERE employee_id = empno_in; 
  
  IF emp_count > 0 THEN 
    -- IF EMPLOYEE FOUND, THEN OBTAIN RECORD 
    SELECT salary 
    INTO emp_sal 
    FROM employees 
    WHERE employee_id = empno_in; 
     
    IF emp_sal < upper_bound AND round(emp_sal + (emp_sal * pct_increase), 2) < 
 upper_bound THEN 
     
        UPDATE employees 
        SET salary = round(salary + (salary * pct_increase),2) 
        WHERE employee_id = empno_in; 
         
        results := 'SUCCESSFUL INCREASE'; 
    ELSE 
        results := 'EMPLOYEE MAKES TOO MUCH, DECREASE RAISE PERCENTAGE'; 
    END IF; 
     
  ELSE 
    Results := 'NO EMPLOYEE FOUND'; 
  END IF; 
 
  DBMS_OUTPUT.PUT_LINE(results); 
 
  END; 
END; 
```

The package in this example declares a global variable and two procedures within the package 
specification. The package body then defines both of the procedures and assigns a value to the variable 
that was declared in the specification. Procedures defined within the package body are defined in the 
same manner as they would be if they were stand-alone procedures. The difference is that now these two 
procedures are contained in a single package entity and are therefore related to each other and can 
share variables declared globally within the package. 

****How It Works****
A PL/SQL package can be useful for organizing code into a single construct. Usually the code consists of 
a grouping of variables, types, cursors, functions, and procedures that perform actions that are logically 
related to one another. Packages consist of a specification and a body, both of which are stored 
separately in the data dictionary. The specification contains the declarations for each of the variables, 
types, subprograms, and so on, that are defined in the package. The body contains the implementations 
for each of the subprograms and cursors that are included in the specification, and it can also include 
implementations for other functions and procedures that are not in the specification. You’ll learn more 
about this in other recipes.

Most packages contain both a specification and a body, and in these cases the specification acts as 
the interface to the constructs implemented within the body. The items that are included in the 
specification are available to the public and can be used outside the package. Not all packages contain a 
body. If there are only declarations of variables or constants in the package, then there is no need for a 
body to implement anything. Other PL/SQL objects outside the package can reference any variables that 
are declared in the specification. In other words, declaring a variable within a PL/SQL package 
specification essentially creates a global variable.

■ Note Global variables should be used wisely(adv.明智地;聪明地). The use of global variables can complicate matters when tracking 
down **Problem**s or debugging your code. If global variables are used, then it can be hard to determine where 
values have been set and where initialization of such variables occurs. Following the rules of encapsulation and 
using local variables where possible can make your life easier.  
Procedures and functions defined within the package body may call each other, and they can be 
defined in any order as long as they have been declared within the package specification. If any of the 
procedures or functions have not been declared in the specification, then they must be defined in the 
package body prior to being called by any of the other procedures or functions.

You can change any implementations within a package body without recompiling the specification. 
This becomes very important when you have other objects in the database that depend on a particular 
package because it is probably not a good idea to change a package specification during normal business 
hours when a package is in use by others. Doing so may result in unusable objects, and the package 
users could begin to see errors. However, if changes need to be made to the code within the package 
body, then you can change that code without affecting public-facing constructs of a package. 
Packages are one of the most important constructs that you can create in PL/SQL. You will use 
packages to combine common code objects for almost any significant application that you write. It is 
possible to create entire applications without the use of a package, but doing so can create a 
maintenance nightmare because you will begin to see a pool of procedures and functions being created 
within your database, and it will be difficult to remember which constructs are used for different tasks. 
Packages are especially handy when writing PL/SQL web applications, and you will learn all about doing 
summary:  
1. package differenates individual prodcdure is that pacakge could define global variable and shared each other
2. could including function not within specification
3. there are declarations of variables or constants, so no need to struct package body


## 4-10. Writing Initialization Code for a Package

****Problem**** 
You want to execute some code each time a particular PL/SQL package is instantiated in a session. 

****Solution****
Create an initialization block for the package in question. By doing so, you will have the ability to execute 
code each time the package is initialized. The following example shows the same package that was 
constructed in Recipe 4-7. However, this time the package contains an initialization block. 
```sql
CREATE OR REPLACE PACKAGE BODY process_employee_time IS 
 
  PROCEDURE grant_raises (pct_increase IN NUMBER, 
                          upper_bound IN NUMBER) as 
  CURSOR emp_cur is 
  SELECT employee_id, first_name, last_name 
  FROM employees; 
  BEGIN 
  -- loop through each record in the employees table 
   FOR emp_rec IN emp_cur LOOP 
      DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name); 
      increase_wage(emp_rec.employee_id, pct_increase, upper_bound); 
   END LOOP; 
  END grant_raises;  
 
 
  PROCEDURE increase_wage (empno_in IN NUMBER, 
                          pct_increase IN NUMBER, 
                          upper_bound IN NUMBER) AS 
  emp_count    NUMBER := 0; 
  emp_sal      employees.salary%TYPE; 
   
  Results   VARCHAR2(50); 
   
  BEGIN 
 
  SELECT count(*) 
  INTO emp_count 
  FROM employees 
  WHERE employee_id = empno_in; 
  
  IF emp_count > 0 THEN 
    -- IF EMPLOYEE FOUND, THEN OBTAIN RECORD 
    SELECT salary 
    INTO emp_sal 
    FROM employees 
    WHERE employee_id = empno_in; 
     
    IF emp_sal < upper_bound AND round(emp_sal + (emp_sal * pct_increase), 2) < 
 upper_bound THEN 
     
        UPDATE employees 
        SET salary = round(salary + (salary * pct_increase),2) 
        WHERE employee_id = empno_in; 
         
        results := 'SUCCESSFUL INCREASE'; 
    ELSE 
        results := 'EMPLOYEE MAKES TOO MUCH, DECREASE RAISE PERCENTAGE'; 
    END IF; 
     
  ELSE 
    Results := 'NO EMPLOYEE FOUND'; 
  END IF; 
  DBMS_OUTPUT.PUT_LINE(results); 
  END increase_wage; 

BEGIN
  DBMS_OUTPUT.PUT_LINE('EXECUTING THE INITIALIZATION BLOCK');
END;
```
The initialization block in this example is the last code block within the package body. In this case,
that block lies in the final three lines. 

****How It Works****

The initialization block for the package in the **Solution** displays a line of text to indicate that the
initialization block has been executed. The initialization block will execute once per session, the first
time the package is used in that session. If you were to create this package in your session and invoke
one of its members, you would see the message print. Although an initialization message is not very
useful, there are several good reasons to use an initialization block. One such reason is to perform a
query to obtain some data for the session. 

summary:  
1. more like java construct function and golang init() function
2. code struct for initialization
   ```sql
    create or replace package XXXX () is
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EXECUTING THE INITIALIZATION BLOCK');
    END;
   ```

## 4-11. Granting the Ability to Create and Execute Stored Programs 

****Problem****
You want to grant someone the ability to create and execute stored programs. 

****Solution**** 
To grant the ability for a user to create a procedure, function, or package, you must log in to the database 
with a privileged account and grant the CREATE PROCEDURE privilege to the user. Here’s an example: 
```sql
GRANT CREATE PROCEDURE TO user; 
```

Similarly, to grant permissions for execution of a procedure, package, or function, you must log in 
with a privileged account and grant the user EXECUTE permissions on a particular procedure, function, or 
package. Here’s an example: 

```sql
GRANT EXECUTE ON schema_name.program_name TO schema;
```

****How It Works****

Before a user can create stored code, the user must be given permission to do so. The **Solution** shows the 
straightforward approach. The database administrator logs in and grants `CREATE PROCEDURE` to the 
schema owner. The schema owner can then log in and create stored code in their schema. 
A schema owner can always execute stored code in the schema. However, application users do not 
generally log in as schema owners because of the security risks inherent in doing so. Thus, you will 
commonly be faced with the need to grant other users execute access on stored code. You do that by 
granting `EXECUTE` privileges, as shown in the second **Solution** example.  

summary :  
1. let A account access B schema objects by execute `GRANT EXECUTE ON schema_name.program_name TO schema;`

## 4-12. Executing Packaged Procedures and Functions 

****Problem****
You want to execute one of the procedures or functions contained within a package. 

****Solution**** 
Use the package_name.object_name notation to execute a particular code object within a package. For 
instance, the following block of code executes the GRANT_RAISES procedure that is contained within the 
PROCESS_EMPLOYEE_TIME package. 

```sql
BEGIN 
    process_employee_time.grant_raises(.03,4000); 
END; 
```

The previous code block executes the `GRANT_RAISES` function, passing `.03` for the percentage of 
increase and 4000 for the upper bound. 

*****How It Works**** 
Dot notation is used for accessing members of a package. Similar to other languages such as Java, dot 
notation can be used to access any publically accessible member of the package. Any variable, function, 
or procedure that is contained in the package specification can be accessed using the dot notation. 
Therefore, if your package contained a constant variable within its specification that you wanted to 
access, it would be possible to do so from outside the package. 
For a schema to access and execute package members, it must have the appropriate permissions. To 
grant EXECUTE permission on a package that you own, use the following syntax: 

```sql
GRANT EXECUTE ON package_name TO user_name; 
```

Dot notation works from within other procedures or functions. It can also be used from the 
SQL*Plus command line using the EXEC command. 
■ Note In most cases, if a package is being used by another schema, then it is a good idea to create a public 
synonym for that package within the database. This will help decrease issues while attempting to reference the 
package and its programs from the different schema because you will not need to specify the schema name in 
order to qualify the call. Please see Recipe 4-13 for more information regarding public synonyms. 
summary:  
1. a good way is to create synonyms

## 4-13. Creating a Public Name for a Stored Program

****Problem**** 
You want to allow for any schema to have the ability to reference a particular stored program that is 
contained(adj.泰然自若的;从容的;被控制的) within your schema. For instance, the CALC_EMPLOYEE_PAYCHECK procedure should be 
executable for any of the administrative users of the database. You want these users to have the ability to 
simply call the procedure rather than preceding the procedure name with the schema using the dot 
notation. 

****Solution****
Create a public synonym for the function, procedure, or package. This will allow any user that has 
EXECUTE privileges on the stored program to call it without specifying the schema name first. Instead, the 
invoker need only reference the synonym.  
In the following example, the user AdminUser does not have direct access to the 
CALC_EMPLOYEE_PAYCHECK procedure, so they must fully qualify the name of the package using the schema 
name for which the procedure resides. 

```sql
SQL> exec application_account.calc_employee_paycheck(200); 
Calculating paycheck with taxes 
The paycheck total for Whalen is 5200.8 
 
PL/SQL procedure successfully completed. 
```

Next, the database administrator will create a public synonym for the procedure:

```sql
SQL> CREATE PUBLIC SYNONYM calc_employee_paycheck 
           FOR application_user.calc_employee_paycheck; 
```

Now any user with execute privileges on the procedure can invoke it without fully qualifying the 
name since a public synonym named CALC_EMPLOYEE_PAYCHECK has been created. This is demonstrated in 
the next lines of code. Again, the user AdminUser is now logged into the system and executes the 
procedure. 

```sql
SQL> exec calc_employee_paycheck(206); 
Calculating paycheck with taxes 
The paycheck total for Gietz is 6640.8 
 
PL/SQL procedure successfully completed. 
```

As you can see, the procedure name no longer requires the schema name to fully qualify it before 
being invoked. 

****How It Works**** 
Creating public synonyms is a useful technique for allowing any user to have access to a stored piece of 
code without knowing which schema the code belongs to. Any user who has EXECUTE privileges on the 
code can invoke it without fully qualifying the name. Instead, the invoker specifies the synonym name.  
An account must be granted the CREATE PUBLIC SYNONYM privilege in order to create a public 
synonym. It’s actually common for database administrators to take care of creating such synonyms.  
To create a synonym, execute the following statement, replacing the PUB_SYNONYM_NAME identifier 
with the name of your choice and replacing SCHEMA.STORED_PROGRAM with the schema name and program 
that you want to make publically accessible: 

```sql
CREATE PUBLIC SYNONYM pub_synonym_name FOR schema.stored_program; 
```

The public synonym name does not have to be the same as the actual stored program name, but it is 
conventional to keep them the same, and it makes things consistent and the names easier to remember. 
If you begin to have synonym names that differ from the actual program names, then confusion will 
eventually set in.

■ Note Creating a synonym does not give execute access. Creating a public synonym provides only a global name 
that avoids the need for dot notation. Invokers of a procedure or function still must be granted EXECUTE access, as 
shown in Recipe 4-11. 

summary:  
1. grant read/write user access right to execute procedure without schema name
2. if you want to setup w/r account for schema account.
   1. create public synonym name for application account
   2. grant execute/select/update ... on package_name on write_user/read_user


## 4-14. Executing Package Programs in Sequence

****Problem**** 
You have created a package that contains all the necessary procedures and functions for your program. 
Although you can invoke each of these subprograms individually using the 
`package_name.subprogram_name` notation, it would be beneficial to execute all of them at the same time 
by issuing a single statement. 

****Solution****
Create a driver procedure within your PL/SQL package that will be used to initiate all the subprograms in turn, and run your entire program. In the following example, a procedure named driver is created inside 
a package, and it will invoke all the other package subprograms in turn: 
First, create the specification: 

```sql
CREATE OR REPLACE PACKAGE synchronize_data IS 
  PROCEDURE driver; 
END; 
```
Then, create the body: 

```sql
CREATE OR REPLACE PACKAGE BODY synchronize_data IS 
  PROCEDURE query_remote_data IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('QUERYING REMOTE DATA'); 
    END query_remote_data;  
 
  PROCEDURE obtain_new_record_list IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('NEW RECORD LIST'); 
    END obtain_new_record_list;  
 
  PROCEDURE obtain_updated_record_list IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('UPDATED RECORD LIST'); 
    END obtain_updated_record_list;  
 
  PROCEDURE sync_local_data IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('SYNC LOCAL DATA'); 
    END sync_local_data;  
   
  PROCEDURE driver IS 
  BEGIN 
    query_remote_data; 
    obtain_new_record_list; 
    obtain_updated_record_list; 
    sync_local_data; 
  END driver; 
END synchronize_data; 
```

The driver procedure initiates all the other procedures in the order that they should be executed. To 
initiate the packaged program, you now make a call to the driver procedure as follows: 

```sql
BEGIN 
   synchronize_data.driver; 
END;
```
 
One statement invokes the driver procedure. That procedure in turn invokes the other procedures 
in the proper sequence.  

****How It Works**** 
By creating a single procedure that can be called in order to execute all the other subprograms in turn, 
you eliminate the potential for calling subprograms in the incorrect order. This will also allow you the 
convenience of making one call as opposed to numerous calls each time you want to execute the task(s) 
involved. And, if you create the other subprograms as private procedures and functions, then you 
eliminate the risk of a developer invoking them out of order. That’s because you only make the driver 
procedure public, and you know that the driver invokes in the correct sequence.  
Oftentimes, packages are used to hold all the database constructs that make up an entire process. In 
the **Solution** to this recipe, the package entails(vt.使需要.必需) a database synchronization process, and each procedure 
within performs a separate piece of the synchronization. When executed in the correct order, the 
procedures together perform the complete synchronization task.  
One could just as easily create a script or manually invoke each package program separately just as 
the driver procedure does in this case. However, you open the door to error when you write the logic of 
invoking the sequence of procedures from multiple places. Another important factor is that the driver 
can also be used to perform any additional initialization that must be done prior to executing each 
procedure. Similarly, additional processing can be done in between each procedure call, such as 
printing out the current status of the program. The driver procedure essentially provides another layer 
of abstraction that you can take advantage of. The package can be initialized using the default package 
initialization; then additional initialization or statements can be provided within the driver procedure, 
and the program caller doesn’t need to know about them.
summary: 
1. Another important factor is that the driver can also be used to perform any additional initialization that must be done prior to executing each procedure
2. you can take advantage of. The package can be initialized using the default package initialization


## 4-15. Implementing a Failure Flag

****Problem**** 
You want to create a boolean variable to determine whether one of the subprograms in the package has 
generated an error. If an error has been generated by one of the subprograms, then the variable will be 
set to TRUE. This flag will be evaluated in the driver procedure to determine whether the updates 
performed by the package should be committed or rolled back. 

****Solution****
Declare a global variable at the package level, and it will be accessible to all objects within. You can do 
this by declaring the variable within the package body. The following package illustrates such a variable, 
where the variable has been declared within the package body so that it is available for all objects in the 
package only. 
```sql  
CREATE OR REPLACE PACKAGE synchronize_data 
PROCEDURE driver; 
END; 
 
CREATE OR REPLACE PACKAGE BODY synchronize_data IS 
  error_flag BOOLEAN := FALSE; 
 
  PROCEDURE query_remote_data is 
     Cursor remote_db_query is 
     SELECT * 
     FROM my_remote_data@remote_db; 
    
     remote_db_rec employees%ROWTYPE; 
 
  BEGIN 
    OPEN remote_db_query; 
    LOOP 
      FETCH remote_db_query INTO remote_db_rec; 
      EXIT WHEN remote_db_query%NOTFOUND; 
    IF remote_db_query%NOTFOUND THEN 
      error_flag := TRUE; 
    ELSE 
      -- PERFORM PROCESSING 
      DBMS_OUTPUT.PUT_LINE('QUERY REMOTE DATA'); 
    END IF; 
    END LOOP; 
    CLOSE remote_db_query; 
  END query_remote_data; 
 
  PROCEDURE obtain_new_record_list IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('NEW RECORD LIST'); 
    END obtain_new_record_list;  
 
  PROCEDURE obtain_updated_record_list IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('UPDATED RECORD LIST'); 
    END obtain_updated_record_list;  
 
  PROCEDURE sync_local_data IS 
    BEGIN 
      --statements go here 
      DBMS_OUTPUT.PUT_LINE('SYNC LOCAL DATA'); 
    END sync_local_data;  
 
 
  PROCEDURE driver IS 
  BEGIN 
    query_remote_data; 
    IF error_flag = TRUE THEN 
      GOTO error_check; 
    END IF; 
     
    obtain_new_record_list; 
    IF error_flag = TRUE THEN 
      GOTO error_check; 
    END IF; 
 
    obtain_updated_record_list; 
    IF error_flag = TRUE THEN 
      GOTO error_check; 
    END IF; 
 
    sync_local_data; 
 
    -- If any errors were found then roll back all updates 
    <<error_check>> 
    DBMS_OUTPUT.PUT_LINE('Checking transaction status'); 
    IF error_flag = TRUE THEN 
      ROLLBACK; 
      DBMS_OUTPUT.PUT_LINE('The transaction has been rolled back.'); 
   ELSE 
      COMMIT; 
      DBMS_OUTPUT.PUT_LINE('The transaction has been processed.'); 
    END IF; 
 
  END driver; 
END;
```
****How It Works****  
Declaring variables in the package body outside any procedures or functions allows them to become 
accessible to all subprograms within the package. If one or more of the subprograms changes such a 
variable’s value, then the changed value will be seen throughout the entire package.  
As depicted in the example, you can see that the variable is referenced several times throughout the 
package. If you had a requirement to make a variable global to all PL/SQL objects outside the package as 
well, then you can declare the variable within the package specification. As mentioned in Recipe 4-8, 
anything declared in the package specification is publically available to any PL/SQL object outside as 
well as within the package body. 

## 4-16. Forcing Data Access to Go Through Packages 

****Problem**** 
You have defined all subprograms and packages for a particular application, and you want to allow other 
users to access these constructs and execute the program but not have access to any data tables directly. 

****Solution****
Define all the packages, procedures, and functions for your program within a single schema that has 
access to all the data. All user access should be made from separate schemas, and they should be granted 
execute privileges on the PL/SQL objects but not access to the tables themselves.  
For instance, if you want to control access to a package named PROCESS_EMPLOYEE_TIME, that package 
along with all required tables, types, and sequences should be loaded into an application schema that 
has the appropriate permissions required to access the data. For the purposes of this recipe, the 
application schema name is EMP.  
Next, create a role by which to manage the privileges needed to invoke the package’s procedures 
and functions. Grant EXECUTE privileges to that role. Grant that role to application users.  
Your application users will now be able to execute the procedures and functions within the package. 
Those procedures and functions can in turn update the database tables in the package’s schema. 
However, users will not have direct access to those tables. All updates must flow through the package. 

****How It Works****
To control an application’s data, it is important to restrict access to the tables. The **Solution** in this recipe 
shows how to create a package in the same schema that contains the application tables. The package 
thus has access to those tables. Users, however, do not have table-level access. 
After creating the package, you can grant EXECUTE access on the package to application users. Users 
can then invoke packaged procedures and functions, and those procedures and functions in turn can 
modify the data in the tables. However, users have no direct access to the tables. 
By forcing users to go through packaged procedures and functions, you limit users to using a 
defined interface that remains under your control. You now have some amount of freedom to modify the 
underlying tables. So long as you do not change the package interface, you can make changes to the 
underlying tables without disrupting the application. 

summary:  
1. big, deep, comprehensive,topic to disuss
2. allow you must through package to access tables

## 4-17. Executing Stored Code Under Your Own Privilege Set 

****Problem**** 
You have loaded all of an application’s objects into a single application schema. However, you do not 
want packages, procedures, and functions to execute as the schema owner. Instead, you want stored 
code to execute with the privileges and access of the user who is invoking that code.  
****Solution****
Use invoker’s rights by providing the `AUTHID` property within the declaration of your program. If the 
AUTHID property is specified when defining a package, procedure, or function, then you have the ability 
to specify whether the program should be invoked using the `CURRENT_USER` privileges or the `DEFINER` 
privileges. In the case of this **Solution**, you would rather use the CURRENT_USER privileges to ensure that 
the user does not have the same level of access as the schema owner. The default is DEFINER. 
The following code shows how to create a procedure for changing a password, and it uses the AUTHID 
property to ensure that the procedure will be run using the CURRENT_USER’s privilege set. This particular 
procedure uses dynamic SQL to create a SQL statement. To learn more about using dynamic SQL, please 
see Chapter 8.

```sql
CREATE OR REPLACE PROCEDURE change_password(username IN VARCHAR2, 
                                                                                                                    
                                          new_password IN VARCHAR2)
AUTHID CURRENT_USER IS 
 
sql_stmt VARCHAR2(100); 

BEGIN 
    sql_stmt := 'ALTER USER ' ||  username || ' IDENTIFIED BY ' || new_password; 
    
    EXECUTE IMMEDIATE sql_stmt; 
END; 
```
When the user executes this procedure, it will be executed using their own set of permissions. This 
will prevent them from changing anyone else’s password unless they have the ability to do so under their 
allotted(v.分配;指派;拨给) permission set.  

****How It Works****
Invoker’s rights are a great way to secure your application if you are planning to limit access to the 
CURRENT_USER’s privilege set. To allow for invoker’s rights to be set into place, the AUTHID property must 
be used with the CURRENT_USER keyword in the definition of a stored PL/SQL unit. This property affects 
the name re**Solution** and privilege set for that unit. You can find the value of the AUTHID property if you 
take a look at the USER_PROCEDURES data dictionary view. 
Using the invoker’s rights methodology is a great way to protect a program as long as the users 
access the program with their own database account. If each user within the database has their own 
account, then they can be granted the required level of access via database roles. The AUTHID property 
can constrain the execution of code to the current user’s privilege set. Because of that, if a user does not 
have the privileges that are required to execute a particular program, then they will not have access. 
Simply put, invoker’s rights are a good means of securing your code as long as the approach is used 
correctly.

summary:  
1. must execute code by your access right

## 4-18. Accepting Multiple Parameter Sets in One Function 

****Problem**** 
You want to give a function the ability to accept multiple parameter types instead of being constrained 
to a particular datatype or number of parameters. For example, you want to create a single function that 
can accept either one or two parameters and that will perform a slightly(adv.些微地,轻微地) different action depending upon 
the number of parameters you pass it.  

****Solution**** 
Use overloading to create multiple functions that are named the same and perform similar functionality 
but accept a different number of parameters, different ordering of parameters, or parameters of different 
types. In this recipe, you will see a function named squared that takes a number and returns its value 
squared. Similarly, there is another function also named squared that accepts two numbers instead of 
one. This second function is the overloaded version of the original squared. Here is the code for the two 
functions: 

```sql
-- Returns the square of the number passed in 
CREATE OR REPLACE FUNCTION squared (in_num IN NUMBER) 
RETURN NUMBER AS 
  -- variables
BEGIN 
  RETURN in_num * in_num; 
END; 
```
```sql 
 -- Returns the squared sum of two numbers 
CREATE OR REPLACE FUNCTION squared (in_num IN NUMBER, 
                                    in_num_two IN NUMBER) 
    RETURN NUMBER AS 
BEGIN 
  RETURN (in_num + in_num_two) * (in_num + in_num_two);  
END; 
```

another type 

```sql
CREATE OR REPLACE FUNCTION squared (in_num IN NUMBER, 
                                    in_num_two IN NUMBER
                                    out_number_three out NUMBER) 
    RETURN NUMBER AS 
NOK   NUMBER;

BEGIN 
  out_number_three := (in_num + in_num_two) * (in_num + in_num_two);  
  RETURN NOK;  
END; 

```
You can see that each of the previous functions accepts a different number of parameters, but they 
both perform similar tasks. This is a good illustration for using function overloading because someone
using this function would expect a similar result to be returned whether calling the function with one
parameter or two. 

****How It Works****
Like many other programming languages, PL/SQL offers an overloading(重载) of functions. This makes it
possible to name more than one function by the same name but give each of them different parameter
types, different parameter ordering, or a different number of parameters. This is also known as changing
the function signature. A signature for a function consists of the object name and its parameter list. By
overloading, you have the ability to allow more flexibility to those using the function. For instance, if you
place both of the squared functions into a package named MATH_API, then someone using this package
can simply call the function passing whatever they require and still receive a usable result without
actually knowing the implementation details. 
Using overloading to create multiple functions or procedures by the same name can become
troublesome if overused. Be careful that your package is not littered with too many overloaded
procedures or functions because maintenance on such a code base can become a nightmare.
Overloading has its good use cases, but if it can be avoided by using technique that is easier to follow,
then it is a good idea to go the simpler route. 

## 4-19. Listing the Functions, Procedures, and Packages in a Schema 

****Problem**** 
Your team has defined a number of functions, procedures, and packages within a schema. You want to
generate a listing of all functions, procedures, and packages at the end of each day to evaluate
productivity. 

****Solution**** 
Use the USER_OBJECTS table to return the program list and prefix packages, procedures, and functions for
the same program with the same first word to make them easier to find. 
This first example will return a list of all procedure names that reside within the EMP schema and that
have a name that is prefixed with EMPTIME: 
```sql
SELECT OBJECT_NAME 
FROM USER_OBJECTS 
WHERE OBJECT_TYPE = 'PROCEDURE;
WHERE OBJECT_NAME like 'EMPTIME%'; 
```

The next query will return a list of all function names that reside within the schema: 

```sql
SELECT OBJECT_NAME 
FROM USER_OBJECTS 
WHERE OBJECT_TYPE = 'FUNCTION'; 
```

Lastly, the following query will return a listing of all package names that reside within the schema: 

```sql
SELECT OBJECT_NAME 
FROM USER_OBJECTS 
WHERE OBJECT_TYPE = 'PACKAGE';
```
> get_DDL() 

****How It Works****
Oracle Database contains many views that contain data useful for application development. Using the 
USER_OBJECTS table can be very handy when searching for objects within the database. By prefixing like 
objects with the same first word, it can make searching for a particular selection of objects rather easy.  
USER_OBJECTS provides the ability to find a certain object type by specifying the OBJECT_TYPE within 
the query. If no OBJECT_TYPE is specified, then all objects for the schema will be returned.




## 4-20. Viewing Source Code for Stored Programs 

****Problem**** 
You want to retrieve the code for your stored functions, procedures, triggers, and packages. 

****Solution****
Use the `DBMS_METADATA` package to assist(vi.参加) you in fetching the information. In this case, you will use the 
`DBMS_METADATA.GET_DDL` procedure to obtain the code for a stored function. In the following code, the 
DBMS_METADATA package is used to return the DDL for the CALC_QUARTER_HOUR function: 

```sql
SELECT DBMS_METADATA.GET_DDL('FUNCTION','CALC_QUARTER_HOUR') FROM DUAL; 
```

The query illustrated previously should produce results that are similar to the following as long as 
you have the `CALC_QUARTER_HOUR` function loaded in your database: 
```sql
CREATE OR REPLACE FUNCTION "MY_SCHEMA"."CALC_QUARTER_HOUR" (HOURS IN NUMBER) 
RETURN NUMBER AS 
   CALCULATED_HOURS NUMBER := 0; 
BEGIN 
   IF HOURS > 1 THEN 
        IF MOD(HOURS, 1) <=.125 THEN 
          CALCULATED_HOURS := substr(to_char(HOURS),0,1); 
        ELSIF MOD(HOURS, 1) > .125 AND MOD(HOURS,1) <= .375 THEN 
          CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.25,1); 
       ELSIF MOD(HOURS, 1) > .375 AND MOD(HOURS,1) <= .625 THEN 
          CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.50,1); 
       ELSIF MOD(HOURS, 1) > .63 AND MOD(HOURS,1) <= .825 THEN 
          CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.75,1); 
       ELSE 
          CALCULATED_HOURS := ROUND(HOURS,1); 
       END IF; 
   ELSE 
       IF HOURS > 0 AND HOURS <=.375 THEN 
         CALCULATED_HOURS := .25; 
       ELSIF HOURS > .375 AND HOURS <= .625 THEN 
         CALCULATED_HOURS := .5; 
       ELSIF HOURS > .625 AND HOURS <= .825 THEN 
         CALCULATED_HOURS := .75; 
       ELSE 
         CALCULATED_HOURS := ROUND(HOURS,1); 
       END IF; 
   END IF; 
   RETURN CALCULATED_HOURS; 
 END CALC_QUARTER_HOUR; 
``` 
The GET_DDL function returns the code that can be used to re-create the procedure or function. This 
can be a good way to debug code that you may not have authored and do not have on hand. 
■ Note The GET_DDL function will not format the code. Rather, it will be returned as a single string of text. By 
default, the buffer will not be large enough to display all of the DDL. You can change the buffer size by issuing the 
SET LONG buffersize within SQL*Plus, substituting buffersize with a large integer value. 

****How It Works****
You can use the DBMS_METADATA package to retrieve various pieces of information from the database. The 
**Solution** to this recipe demonstrated how to fetch the DDL for a function. There is an abundance of 
information that can be obtained by using the DBMS_METADATA package, and `GET_DDL` barely scratches the 
surface. 

The GET_DDL function can return the code for each different type of object. To retrieve a the code for 
an object using GET_DDL, use the following syntax: 

```sql
SELECT DBMS_METADATA.GET_DDL('object_type','object_name', 'schema') FROM DUAL; 
```
The OBJECT_TYPE can be the name of any database object type, including TABLE. For the purposes of 
PL/SQL code, the OBJECT_TYPE can be FUNCTION, PROCEDURE, PACKAGE, or TRIGGER. The SCHEMA parameter is 
optional and does not have to be specified if the object resides within the caller’s schema. 
Using DBMS_METADATA, you can obtain complete database object definitions from the database 
dictionary via the retrieval subprograms. To learn more about the DBMS_METADATA package and obtain a 
listing of available subprograms, please refer to the online Oracle documentation at 
http://download.oracle.com/docs/cd/B28359_01/appdev.111/b28419/d_metada.htm#ARPLS640, which 
goes into detail regarding each of the subprogram functionalities. 
 
summary:  

```text
It has always been a huge pain to punch the DDL for tables, indexes and stored procedures into a flat file. Oracle now has a dbms_metadata package with a get_ddl function to copy DDL syntax out of the dictionary.

With all of the new storage clauses and advanced parameters, getting table and index definitions has always been a huge **Problem**.  Hence, prior to Oracle, the DBA was generally forced to keep the DDL source code in a special library.  This makes life difficult because the DBA is now forced to maintain and manage versions of tables and index DDL separately from the data dictionary.

Oracle, the DBA will be able to keep all table and index definitions inside the data dictionary (where they belong), and use the get_ddl function to punch-out a copy whenever they need to migrate the object.

Below we see that the get_ddl function is very simple to use, only requiring the object_type and the object_name as import parameter.  Also, make sure to set linesize to a large value, because get_ddl returns a CLOB datatype, and you want SQL*Plus to be able to display the result set.

Set lines 90000

Spool sales_table_ddl.sql

Select dbms_metadata.get_ddl('TABLE','SALES','schema') from dual;

Spool off;

If you like Oracle tuning, you might enjoy my latest book "Oracle Tuning: The Definitive Reference" by Rampant TechPress.  It's only $41.95 (I don't think it is right to charge a fortune for books!) and you can buy it right now at this link:
```
