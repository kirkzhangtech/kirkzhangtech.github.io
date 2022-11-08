---
title: Oracle PLSQL Recipes 09-Exceptions
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

# 9. Exceptions 
Exceptions are a fundamental part of any well-written program. They are used to display user-friendly 
error messages when an error is raised by an application, nondefault exception handling, and 
sometimes recovery so that an application can continue. Surely you have seen your fair share of ORA-XXXXX error messages. Although these messages are extremely useful to a developer for debugging and 
correcting issues, they are certainly foreign to the average application user and can be downright frightening to see.  
Imagine that you are working with a significant number of updates via an application form, and after you submit your 150th update, an Oracle error is displayed. Your first reaction would be of panic, hoping that you haven’t just lost all of the work you had completed thus far. By adding exception handling to an application, you can ensure that exceptions are handled in an orderly fashion so that no work is lost. You can also create a nicer error message to let the user know all changes have been saved 
up to this point so that sheer panic doesn’t set in when the exception is raised. 
Exceptions can also be raised as a means to provide informative detail regarding processes that are occurring within your application. They are not merely restricted to being used when Oracle encounters an issue. You can raise your own exceptions as well when certain circumstances are encountered in your application. 
Whatever the case may be, exception handling should be present in any production-quality application code. This chapter will cover some basics of how to use exception handling in your code. Along the way, you will learn some key tips on how exception handling can make your life easier. In the end, you should be fully armed to implement exception handling for your applications. 

## 9-1. Trapping an Exception 
**Problem** 
A procedure in your application has the potential to cause an exception to be raised. Rather than let the 
program exit and return control to the host machine, you want to perform some cleanup to ensure data 
integrity, as well as display an informative error message.  
**Solution** 
Write an exception handler for your procedure so that the exception can be caught and you can perform 
tasks that need to be completed and provide a more descriptive message. The following procedure is 
used to obtain employee information based upon a primary key value or an e-mail address. Beginning 
with the EXCEPTION keyword in the following example, an exception-handling block has been added to 
the end of the procedure in order to handle any exceptions that may occur when no matching record is 
found. 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_info IN VARCHAR2) IS 
  emp_qry            VARCHAR2(500); 
  emp_first          employees.first_name%TYPE; 
  emp_last           employees.last_name%TYPE; 
  email              employees.email%TYPE; 
 
  valid_id_count     NUMBER := 0; 
  valid_flag         BOOLEAN := TRUE; 
  temp_emp_info      VARCHAR2(50); 
 
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
    DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
  END IF; 
 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
    WHEN INVALID_NUMBER THEN 
      DBMS_OUTPUT.PUT_LINE('YOU MUST ENTER AN EMAIL ADDRESS INCLUDING ' || 
                         'THE @ OR A POSITIVE INTEGER VALUE FOR THE ' || 
                         'EMPLOYEE ID.'); 
END; 
```
Here are the results of calling the procedure with various arguments: 
 
```sql
SQL> EXEC OBTAIN_EMP_DETAIL(000); 
THE INFORMATION YOU HAVE USED DOES NOT MATCH ANY EMPLOYEE RECORD 
 
PL/SQL procedure successfully completed. 

SQL> EXEC OBTAIN_EMP_DETAIL('TEST'); 
YOU MUST ENTER AN EMAIL ADDRESS INCLUDING THE @ OR A POSITIVE INTEGER VALUE FOR 
THE EMPLOYEE ID. 
 
PL/SQL procedure successfully completed. 
 
SQL> EXEC OBTAIN_EMP_DETAIL(200);   
Jennifer Whalen - JWHALEN 
 
PL/SQL procedure successfully completed. 

``` 
This procedure is essentially the same as the one demonstrated in Recipe 8-1. The difference is that 
when an exception is raised, the control will go into the exception block. At that time, the code you place 
within the exception block will determine the next step to take as opposed to simply raising an Oracle 
error and returning control to the calling procedure, calling function, or host environment. 
**How It Works** 
To perform remedial actions when an exception is raised, you should always make sure to code an 
exception handler if there is any possibility that an exception may be thrown. The sole purpose of an 
exception handler is to catch exceptions when they are raised and handle the outcome in a controlled 
fashion. There are two different types of exceptions that can be raised by a PL/SQL application: 
internally defined and user defined. Oracle Database has a defined set of internal exceptions that can be 
thrown by a PL/SQL application. Those exceptions are known as internally defined. It is also possible to 
define your own exceptions, which are known as user defined. 
An exception-handling block is structured like a CASE statement in that a series of exceptions is listed 
followed by a separate set of statements to be executed for each outcome. The standard format for an 
exception-handling block is as follows: 
```sql
EXCEPTION 
  WHEN name_of_exception THEN 
    -- One or more statements 
```
Exception blocks begin with the EXCEPTION keyword, followed by a series of WHEN..THEN clauses that 
describe different possible exceptions along with the set of statements that should be executed if the 
exception is caught. The exception name can be one of the Oracle internally defined exceptions, or it can 
be the name of an exception that has been declared within your code. To learn more about declaring 
exceptions, please see Recipe 9-3 in this chapter. In the Solution to this recipe, the internally defined 
NO_DATA_FOUND exception is raised if an unknown e-mail address is entered into the procedure because 
there will be no rows returned from the query. When the exception block encounters the WHEN clause that 
corresponds with NO_DATA_FOUND, the statements immediately following the THEN keyword are executed. 
In this case, an error message is printed using the DBMS_OUTPUT package. However, in a real-world 
application, this is where you will place any cleanup or error handling that should be done to help 
maintain the integrity of the data accessed by your application. 
An exception block can contain any number of WHEN..THEN clauses, and therefore, any number of 
exceptions can each contain their own set of handler statements. Even if a simple message was to be 
displayed, as is the case with the Solution to this recipe, a different and more descriptive error message
can be coded for each different exception that may possibly be raised. This situation is reflected in the
second exception handler contained within the Solution because it returns a different error message
than the first. 
As mentioned previously, Oracle contains a number of internally defined exceptions. Table 9-1
provides a list of the internally defined exceptions, along with a description of their usage. 
Table 9-1. Oracle Internal Exceptions 
```sql
Exception               Code Description 
ACCESS_INTO_NULL        -6530 Values are assigned to an uninitialized object. 
CASE_NOT_FOUND          -6592 No matching choice is available within CASE statement, and no ELSE clause has been defined. 
COLLECTION_IS_NULL      -6531 Program attempts to apply collection methods other than EXISTS to varray or a nested table that has not yet been initialized. 
CURSOR_ALREADY_OPEN     -6511 Program attempts to open a cursor that is already open. 
DUP_VAL_ON_INDEX        -1 Program attempts to store duplicate values in a unique index column. 
INVALID_CURSOR          -1001 Program attempts to use a cursor operation that is allowed. 
INVALID_NUMBER          -1722 Conversion of string into number is incorrect because of the string not being a number. 
LOGIN_DEINIED           -1017 Program attempts to log in to the database using an incorrect user name and/or password. 
NO_DATA_FOUND           +100 SELECT statement returns no rows. 
NOT_LOGGED_ON           -1012 Program attempts to issue a database call without being connected to the database. 
PROGRAM_ERROR           -6501 Internal Problem exists. 
ROWTYPE_MISMATCH        -6504 Cursor variables are incompatible. A host cursor variable must have a compatible return type that matches a PL/SQL cursor variable. 
SELF_IS_NULL            -30625 Instance of object type is not initialized. 
STORAGE_ERROR           -6500 PL/SQL ran out of memory or was corrupted. 
SUBSCRIPT_BEYOND_COUNT  -6533  Program references nested table or varray element using an index number that goes beyond the number of elements within the object. 
SYS_INVALID_ROWID       -1410  Conversion of character string into ROWID fails because character string does not represent a valid row ID. 
TIMEOUT_ON_RESOURCE     -51  Oracle Database is waiting for resource, and timeout occurs. 
TOO_MANY_ROWS           -1422  Attempts to select more than one row using a SELECT INTO statement. 
VALUE_ERROR             -6502  Program attempts to perform an invalid arithmetic,conversion, or truncation operation. 
ZERO_DIVIDE             -1476  Program attempts to divide a number by zero. 
```
An exception handler’s scope corresponds to its enclosing code block. They have the same scope as 
a variable would have within a code block. If your code contains a nested code block, an exception 
handler that is contained within the nested code block can only handle exceptions raised within that 
code block. The outer code block can contain an exception handler that will handle exceptions for both 
the outer code block and the nested code block. If an exception is raised within the nested code block 
and there is no corresponding handler for an exception that has been raised within the nested code 
block, then the exception is propagated to the outer code block to look for a corresponding handler 
there. If no handler is found, then runtime will be passed to the procedure or function that called it or 
the host system, which is what you do not want to have occur. The following code demonstrates an 
example of using an exception handler within a nested code block: 
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT * 
  FROM EMPLOYEES; 
 
  emp_rec emp_cur%ROWTYPE; 
BEGIN 
  FOR emp_rec IN emp_cur LOOP 
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || 
         emp_rec.last_name); 
    DECLARE 
      emp_dept  departments.department_name%TYPE; 
    BEGIN 
      SELECT department_name 
      INTO emp_dept 
      FROM departments 
      WHERE department_id = emp_rec.department_id; 
      DBMS_OUTPUT.PUT_LINE('Department: ' || emp_dept); 
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('EXCEPTION IN INNER BLOCK'); 
    END; 
  END LOOP; 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
   DBMS_OUTPUT.PUT_LINE('EXCEPTION IN OUTER BLOCK'); 
END; 
```
Multiple exceptions can be listed within the same exception handler if you want to execute the same 
set of statements when either of them is raised. You can do this within the WHEN clause by including two 
or more exception names and placing the OR keyword between them. Using this technique, if either of 
the exceptions that are contained within the clause is raised, then the set of statements that follows will 
be executed. Let’s take a look at an exception handler that contains two exceptions within the same 
handler: 
```sql
EXCEPTION 
  WHEN NO_DATA_FOUND OR INVALID_EMAIL_ADDRESS THEN 
    --  statements to execute 
  WHEN OTHERS THEN 
    --  statements to execute 
END;
```
■ Note You cannot place the AND keyword in between exceptions because no two exceptions can be raised at the 
same time. 
It is easy to include basic exception handling in your application. Code an exception-handling block 
at the end of each code block that may raise an exception. It is pertinent that you test your application 
under various conditions to try to predict which possible exceptions may be raised; each of those 
possibilities should be accounted for within the exception-handling block of your code. 

## 9-2. Catching Unknown Exceptions 

**Problem** 
Some exceptions are being raised when executing one of your procedures and you want to ensure that 
all unforeseen exceptions are handled using an exception handler. 
**Solution** 
Use an exception handler, and specify OTHERS for the exception name to catch all the exceptions that 
have not been caught by previous handlers. In the following example, the same code from Recipe 9-1 
has been modified to add an OTHERS exception handler: 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_info IN VARCHAR2) IS 
  emp_qry                   VARCHAR2(500); 
  emp_first                 employees.first_name%TYPE; 
  emp_last                  employees.last_name%TYPE; 
  email                     employees.email%TYPE; 
 
  valid_id_count            NUMBER := 0; 
  valid_flag                BOOLEAN := TRUE; 
  temp_emp_info             VARCHAR2(50); 
 
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
    DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
  END IF; 
 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                         'NOT MATCH ANY EMPLOYEE RECORD'); 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('AN UNEXPECTED ERROR HAS OCCURRED, PLEASE ' || 
                         'TRY AGAIN'); 
END; 
```
In this example, if an unexpected exception were to be raised, then the program control would 
transfer to the statements immediately following the WHEN OTHERS THEN clause.  
■ Note In a real-world application, an exception should be manually reraised within the OTHERS handler. To learn 
more about determining the exception that was raised, please see Recipe 9-4. 
**How It Works** 
You can use the OTHERS handler to catch all the exceptions that have not been previously handled by any 
named exception handler. It is a good idea to include an OTHERS handler with any exception handler so 
that any unknown exceptions can be handled reasonably by your application. However, OTHERS should 
be used only to assist developers in finding application bugs rather than as a catchall for any exception. 
The format for using the OTHERS handler is the same as it is with other named exceptions; the only 
difference is that it should be the last handler to be coded in the exception handler. The following 
pseudocode depicts a typical exception handler that includes an OTHERS handler: 
```sql
EXCEPTION 
  WHEN named_exception1 THEN 
    -- perform statements 
  WHEN named_exception2 THEN 
    -- perform statements 
  WHEN OTHERS THEN 
    -- perform statements 
  WHEN TO USE THE OTHERS HANDLER 
```
It is important to note that the OTHERS handler is not used to avoid handling expected exceptions properly. 
Each exception that may possibly be raised should be handled within its own exception-handling block. 
The OTHERS handler should be used only to catch those exceptions that are not expected. Most often, the 
OTHERS handler is used to catch application bugs in order to assist a developer in finding and resolving 
issues. 
As stated, the OTHERS handler will catch any exception that has not yet been caught by another 
handler. It is very important to code a separate handler for each type of named exception that may 
occur. However, if you have one set of statements to run for any type of exception that may occur, then it 
is reasonable to include only an OTHERS exception handler to catch exceptions that are unexpected. If no 
named exceptions are handled and an exception handler includes only an OTHERS handler, then the 
statements within that handler will be executed whenever any exception occurs within an application. 

## 9-3. Creating and Raising Named Programmer-Defined Exceptions 
**Problem** 
You want to alert the users of your application when a specific event occurs. The event does not raise an 
Oracle exception, but it is rather an application-specific exception. You want to associate this event with 
a custom exception so that it can be raised whenever the event occurs. 
  CHAPTER 9  EXCEPTIONS 
195 
**Solution** 
Declare a named user-defined exception, and associate it with the event for which you are interested in 
raising an exception. In the following example, a user-defined exception is declared and raised within a 
code block. When the exception is raised, the application control is passed to the statements contained 
within the exception handler for the named user exception. 
```sql
CREATE OR REPLACE PROCEDURE salary_increase(emp_id IN NUMBER, 
                                            pct_increase IN NUMBER) AS 
   
  salary                employees.salary%TYPE; 
  max_salary            jobs.max_salary%TYPE; 
  INVALID_INCREASE      EXCEPTION; 
   
   
BEGIN 
 
  SELECT salary, max_salary 
  INTO salary, max_salary 
  FROM employees, jobs 
  WHERE employee_id = emp_id 
  AND jobs.job_id = employees.employee_id; 
 
   
  IF (salary + (salary * pct_increase)) <= max_salary THEN 
    UPDATE employees 
    SET salary = (salary + (salary * pct_increase)) 
    WHERE employee_id = emp_id; 
     
    DBMS_OUTPUT.PUT_LINE('SUCCESSFUL SALARY INCREASE FOR EMPLOYEE #: ' || 
          emp_id || 
          '.  NEW SALARY = ' || salary + (salary * pct_increase)); 
          
  ELSE 
    RAISE INVALID_INCREASE; 
  END IF; 
   
 
   
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('UNSUCCESSFUL INCREASE, NO EMPLOYEE RECORD FOUND ' || 
                  'FOR THE GIVEN ID'); 
                   
  WHEN INVALID_INCREASE THEN 
    DBMS_OUTPUT.PUT_LINE('UNSUCCESSFUL INCREASE.  YOU CANNOT INCREASE THE ' || 
                  'EMPLOYEE SALARY BY ' || pct_increase || 
                  'PERCENT...PLEASE ENTER ' || 
                  'A SMALLER INCREASE AMOUNT TO TRY AGAIN'); 
 
 
  WHEN OTHERS THEN 
CHAPTER 9  EXCEPTIONS 
196 
    DBMS_OUTPUT.PUT_LINE('UNSUCCESSFUL INCREASE.  AN UNKNOWN ERROR HAS '|| 
                  'OCCURRED, ' || 
                  'PLEASE TRY AGAIN OR CONTACT ADMINISTRATOR' || pct_increase); 
 
END; 
```
As you can see from the code, the exception block can accept one or more handlers. The named 
user exception is declared within the declaration section of the procedure, and the exception can be 
raised anywhere within the containing block. 
■ Note In a real-world application, an exception should be manually raised within the OTHERS handler. To learn 
more about determining the exception that was raised, please see Recipe 9-4. 
**How It Works** 
A PL/SQL application can contain any number of custom exceptions. When a developer declares their 
own exception, it is known as a user-defined exception. A user-defined exception must be declared 
within the declaration section of a package, function, procedure, or anonymous code block. To declare 
an exception, use the following: 
```sql
exception_name  EXCEPTION; 
```
You can provide any name as long as it applies to the standard naming convention and is not the 
same as an internally defined exception name. It is a coding convention to code exception names using 
uppercase lettering, but lowercase would work as well since PL/SQL is not a case-sensitive language. 
To raise your exception, type the RAISE keyword followed by the name of the exception that you 
want to raise. When the code executes the RAISE statement, control is passed to the exception handler 
that best matches the exception that was named in the statement. If no handler exists for the exception 
that was raised, then control will be passed to the OTHERS handler, if it exists. In the worst-case scenario, 
if there are not any exception handlers that match the name that was provided in the RAISE statement 
and there has not been an OTHERS handler coded, then control will be passed back to the enclosing block, 
the calling code, or the host environment. 
The RAISE statement can also be used in a couple of other ways. It is possible to raise an exception 
that has been declared within another package. To do so, fully qualify the name of the exception by 
prefixing it with the package name. The RAISE statement can also be used stand-alone to reraise an 
exception.  
As seen in the **Solution** to this recipe, catching a named user exception is exactly the same as 
catching an internally defined exception. Code the WHEN..THEN clause, naming the exception that you 
want to catch. When the exception is raised, any statements contained within that particular exception 
handler will be executed. 

## 9-4. Determining Which Error Occurred Inside the OTHERS Handler 
**Problem** 
Your code is continually failing via an exception, and the OTHERS handler is being invoked. You need to 
determine the exact cause of the exception so that it can be repaired. 
**Solution** 
Code the OTHERS exception handler as indicated by Recipe 9-2, and use the SQLCODE and 
DBMS_UTILITY.FORMAT_ERROR_STACK functions to return the Oracle error code and message text for the 
exception that has been raised. The following example demonstrates the usage of these functions, along 
with the procedure that was used in Recipe 9-3, for obtaining the error code and message when the 
OTHERS handler is invoked. 
```sql
CREATE OR replace PROCEDURE salary_increase(emp_id       IN NUMBER,  
                                            pct_increase IN NUMBER)  
AS  
  salary              employees.salary%TYPE;  
  max_salary          jobs.max_salary%TYPE;  
  invalid_increase    EXCEPTION;  
  error_number        NUMBER;  
  error_message       VARCHAR2(1500);  
BEGIN  
  SELECT salary,  
         max_salary  
  INTO   salary, max_salary  
  FROM   employees,  
         jobs  
  WHERE  employee_id = emp_id  
         AND jobs.job_id = employees.employee_id;  
 
  IF ( salary + ( salary * pct_increase ) ) <= max_salary THEN  
    UPDATE employees  
    SET    salary = ( salary + ( salary * pct_increase ) )  
    WHERE  employee_id = emp_id;  
 
    dbms_output.Put_line('SUCCESSFUL SALARY INCREASE FOR EMPLOYEE #: '  
                         || emp_id  
                         || '.  NEW SALARY = '  
                         || salary + ( salary * pct_increase ));  
  ELSE  
    RAISE invalid_increase;  
  END IF;  
EXCEPTION  
  WHEN no_data_found THEN  
    dbms_output.Put_line('UNSUCCESSFUL INCREASE, NO EMPLOYEE RECORD FOUND ' 
                     || 'FOR THE '  
                     || 'GIVEN ID'); WHEN invalid_increase THEN  
    dbms_output.Put_line('UNSUCCESSFUL INCREASE.  YOU CANNOT INCREASE THE '  
                     || 'EMPLOYEE '  
                     || 'SALARY BY '  
                     || pct_increase  
                     || ' PERCENT...PLEASE ENTER '  
                     || 'A SMALLER INCREASE AMOUNT TO TRY AGAIN');  
WHEN OTHERS THEN  
           error_number := SQLCODE;  
 
           error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;  
 
    dbms_output.Put_line('UNSUCCESSFUL INCREASE.  AN UNKNOWN ERROR HAS ' 
                     || 'OCCURRED, '  
                     || 'PLEASE TRY AGAIN OR CONTACT ADMINISTRATOR'  
                     || ' Error #: '  
                     || error_number  
                     || ' - '  
                     || error_message); 
END;  
```
When this procedure is executed, the following error will be returned: 
 
UNSUCCESSFUL INCREASE.  AN UNKNOWN ERROR HAS OCCURRED, PLEASE TRY AGAIN OR CONTACT 
ADMINISTRATOR Error #: -1722 - ORA-01722: invalid number 
 
This example intentionally raises an error in order to demonstrate the functionality of these utilities. 
A reference to the line number that raised the error may also be helpful. To learn more about writing an 
exception handler that returns line numbers, please see Recipe 9-9.  
**How It Works** 
The SQLCODE and DBMS_UTILITY.FORMAT_ERROR_STACK functions provide the means to determine what 
code and message had caused the last exception that was raised. The SQLCODE function will return the 
Oracle error number for internal exceptions and +1 for a user-defined exception. The 
DBMS_UTILITY.FORMAT_ERROR_STACK function will return the Oracle error message for any internal 
exception that is raised, and it will contain the text User-Defined Exception for any named user 
exception that is raised. A user-defined exception may receive a custom error number, as you will read 
about in Recipe 9-9. In such cases, the SQLCODE function will return this custom error number if raised. 
To use these functions, you must assign them to a variable because they cannot be called outright. 
For instance, if you wanted to use the SQLCODE within a CASE statement, you would have to assign the 
function to a variable first. Once that has been done, you could use the variable that was assigned the 
SQLCODE in the statement. 
Oracle includes DBMS_UTILITY.FORMAT_ERROR_STACK, which can be used to return the error message 
associated with the current error. DBMS_UTILITY.FORMAT_ERROR_STACK can hold up to 1,899 characters, so 
there is rarely a need to truncate the message it returns. SQLERRM is a similar function that can be used to 
return the error message, but it only allows messages up to 512 bytes to be displayed. Oftentimes, 
SQLERRM messages need to be truncated for display. Oracle recommends using 
DBMS_UTILITY.FORMAT_ERROR_STACK over SQLERRM because this utility doesn’t have such a small message 
limitation.  
However, SQLERRM does have its place, because there are some benefits of using it. A handy feature of 
SQLERRM is that you can pass an error number to it and retrieve the corresponding error message. Any 
error number that is passed to SQLERRM should be negative; otherwise, you will receive the message User-
defined error. Table 9-2 displays the error number ranges and their corresponding messages using 
SQLCODE and SQLERRM. 
```text
Table 9-2. SQLCODE Return Codes and Meanings 
Code                          Description 
Negative Oracle Error Number  Internal Oracle exception 
0                             No exceptions raised 
+1                            User-defined exception 
+100                          NO_DATA_FOUND 
-20000 to -20999              User-defined error with PRAGMA EXCEPTION_INIT
```
■ Note PRAGMA EXCEPTION_INIT is used to associate an Oracle error number with an exception name. 
If you choose to use SQLERRM, the code is not much different from using 
DBMS_UTILITY.FORMAT_ERROR_STACK, but you will probably need to include some code to truncate the 
result. The next example demonstrates the same example that was used in the **Solution** to this recipe, but 
it uses SQLERRM instead of DBMS_UTILITY.FORMAT_ERROR_STACK. 
```sql
CREATE OR replace PROCEDURE salary_increase(emp_id       IN NUMBER,  
                                            pct_increase IN NUMBER)  
AS  
  salary             employees.salary%TYPE;  
  max_salary         jobs.max_salary%TYPE;  
  invalid_increase   EXCEPTION;  
  error_number       NUMBER;  
  error_message      VARCHAR2(1500);  
BEGIN  
  SELECT salary,  
         max_salary  
  INTO   salary, max_salary  
  FROM   employees,  
         jobs  
  WHERE  employee_id = emp_id  
         AND jobs.job_id = employees.employee_id;  
 
  IF ( salary + ( salary * pct_increase ) ) <= max_salary THEN  
    UPDATE employees  
    SET    salary = ( salary + ( salary * pct_increase ) )  
    WHERE  employee_id = emp_id;  
 
    dbms_output.Put_line('SUCCESSFUL SALARY INCREASE FOR EMPLOYEE #: '  
                         || emp_id  
                         || '.  NEW SALARY = '  
                         || salary + ( salary * pct_increase ));  
  ELSE  
    RAISE invalid_increase;  
  END IF; 
EXCEPTION  
  WHEN no_data_found THEN  
    dbms_output.Put_line('UNSUCCESSFUL INCREASE, NO EMPLOYEE RECORD FOUND ' 
                     || 'FOR THE '  
                     || 'GIVEN ID'); WHEN invalid_increase THEN  
    dbms_output.Put_line('UNSUCCESSFUL INCREASE.  YOU CANNOT INCREASE THE '  
                     || 'EMPLOYEE '  
                     || 'SALARY BY '  
                     || pct_increase  
                     || ' PERCENT...PLEASE ENTER '  
                     || 'A SMALLER INCREASE AMOUNT TO TRY AGAIN');
WHEN OTHERS THEN  
           error_number := SQLCODE;  
           error_message := Substr(sqlerrm, 1, 150);  
dbms_output.Put_line('UNSUCCESSFUL INCREASE.  AN UNKNOWN ERROR HAS OCCURRED, '  
                     || 'PLEASE TRY AGAIN OR CONTACT ADMINISTRATOR'  
                     || ' Error #: '  
                     || error_number  
                     || ' - '  
                     || error_message); 
END;
```
There are some other tools that can be used to further diagnose which errors are being raised and
even to see the entire stack trace. These tools are further explained within Recipe 9-9. By combining the
techniques learned in this recipe with those you will learn about in Recipe 9-9, you are sure to have a
better chance of diagnosing your application issues. 

## 9-5. Raising User-Defined Exceptions Without an Exception Handler 
**Problem** 
Your application includes some error handling that is specific to your application. For instance, you
want to ensure that the input value for a procedure is in the valid format to be an e-mail address. Rather
than writing an exception handler for each user-defined exception, you want to simply raise the
exception inline and provide an error number as well. 
**Solution** 
This scenario is perfect for using the RAISE_APPLICATION_ERROR procedure. Test the e-mail address that is
passed into the procedure to ensure that it follows certain criteria. If it does not contain a specific 
characteristic of a valid e-mail address, use the RAISE_APPLICATION_ERROR procedure to display an 
exception message to the user. Here’s an example: 
```sql 
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_email IN VARCHAR2) IS 
  emp_qry       VARCHAR2(500); 
  emp_first     employees.first_name%TYPE; 
  emp_last      employees.last_name%TYPE; 
  email         employees.email%TYPE; 
 
  valid_id_count        NUMBER := 0; 
  valid_flag            BOOLEAN := TRUE; 
  temp_emp_info         VARCHAR2(50); 
 
  BEGIN 
    emp_qry := 'SELECT FIRST_NAME, LAST_NAME, EMAIL FROM EMPLOYEES '; 
    IF emp_email LIKE '%@%' THEN 
      temp_emp_info := substr(emp_email,0,instr(emp_email,'@')-1); 
      emp_qry := emp_qry || 'WHERE EMAIL = :emp_email'; 
    ELSIF emp_email NOT LIKE '%.mycompany.com' THEN 
      RAISE_APPLICATION_ERROR(-20001, 'Not a valid email address from ' || 
                            'this company!'); 
    ELSE 
      RAISE_APPLICATION_ERROR(-20002, 'Not a valid email address!'); 
    END IF; 
   
    IF valid_flag = TRUE THEN 
      EXECUTE IMMEDIATE emp_qry 
      INTO emp_first, emp_last, email 
      USING temp_emp_info; 
   
      DBMS_OUTPUT.PUT_LINE(emp_first || ' ' || emp_last || ' - ' || email); 
    ELSE  
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
    END IF; 
 
END; 
```
As you can see, there is no exception handler in this example. When the conditions are met, an 
exception is raised inline via RAISE_APPLICATION_EXCEPTION. 
**How It Works** 
The RAISE_APPLICATION_EXCEPTION procedure can associate an error number with an error message. The 
format for calling the RAISE_APPLICATION_EXCEPTION procedure is as follows: 
```sql
RAISE_APPLICATION_EXCEPTION(exception_number,  
                           exception_message[, retain_error_stack]); 
```
where exception_number is a number within the range of -20000 to -20999, and exception_message is a 
string of text that is equal to or less than 2KB in length. The optional retain_error_stack is a BOOLEAN 
value that tells Oracle whether this exception should be added to the existing error stack or whether the 
error stack should be wiped clean and this exception should be placed into it. By default, the value is 
FALSE, and all other exceptions are removed from the error stack, leaving this exception as the only one 
in the stack. 
When you invoke the procedure, the current block is halted immediately, and the exception is 
raised. No further processing takes place within the current block, and control is passed to the program 
that called the block or an enclosing block if the current block is nested. Therefore, if you need to 
perform any exception handling, then it needs to take place prior to calling 
RAISE_APPLICATION_EXCEPTION. There is no commit or rollback, so any updates or changes that have been 
made will be retained if you decide to issue a commit. Any OUT and IN OUT values, assuming you are in a 
procedure or a function, will be reverted. This is important to keep in mind, because it will help you 
determine whether to use an exception handler or issue a call to RAISE_APPLICATION_ERROR. 
When calling RAISE_APPLICATION_EXCEPTION, you pass an error number along with an associated 
exception message. Oracle sets aside the range of numbers from -20000 to -20999 for use by its 
customers for the purpose of declaring exceptions. Be sure to use a number within this range, or Oracle 
will raise its own exception to let you know that you are out of line and using one of its proprietary error 
numbers! 
■ Note There are some numbers within that range that are still used by Oracle-specific exceptions. Passing a 
TRUE value as the last argument in a call to RAISE_APPLICATION_EXCEPTION will retain any existing errors in the 
error stack. Passing TRUE is a good idea for the purposes of debugging so that the stack trace can be used to help 
find the code that is raising the exception. Otherwise, the exception stack is cleared.  
One may choose to create a function or procedure that has the sole purpose of calling 
RAISE_APPLICATION_EXCEPTION to raise an exception and associate an error number with an exception 
message. This technique can become quite useful if you are interested in using a custom error number 
for your exceptions, but you still need to perform proper exception handling when errors occur. You 
could use the OTHERS exception handler to call the function or procedure that uses 
RAISE_APPLICATION_EXCEPTION, passing the error number and a proper exception message. 

## 9-6. Redirecting Control After an Exception Is Raised 
**Problem** 
After an exception is raised within an application, usually the statements within the exception handler 
are executed, and then control goes to the next statement in the calling program or outside the current 
code block. Rather than printing an error message and exiting your code block after an exception, you 
want to perform some further activity. For instance, let’s say you are interested in logging the exception 
in a database table. You have a procedure for adding entries to the log table, and you want to make use 
of that procedure. 
**Solution** 
Invoke the procedure from within the exception handler. When the exception is raised, program control 
will be passed to the appropriate handler. The handler itself can provide an exception message for the 
user, but it will also call the procedure that is to be used for logging the exception in the database. The 
following example demonstrates this technique: 
```sql
CREATE OR REPLACE PROCEDURE log_error_messages(error_code  IN NUMBER, 
                                                message    IN VARCHAR2) AS 
PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN 
  DBMS_OUTPUT.PUT_LINE(message); 
  DBMS_OUTPUT.PUT_LINE('WRITING ERROR MESSAGE TO DATABASE'); 
END; 
 
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_info IN VARCHAR2) IS 
  emp_qry                 VARCHAR2(500); 
  emp_first                employees.first_name%TYPE; 
  emp_last                   employees.last_name%TYPE; 
  email                         employees.email%TYPE; 
 
  valid_id_count         NUMBER := 0; 
  valid_flag                  BOOLEAN := TRUE; 
  temp_emp_info       VARCHAR2(50); 
 
 
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
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
    END IF; 
   
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         
        DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
        log_error_messages(SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK); 
         
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('AN UNEXPECTED ERROR HAS OCCURRED, PLEASE ' || 
                           'TRY AGAIN'); 
        log_error_messages(SQLCODE, DBMS_UTILITY.FORMAT_ERROR_STACK); 
 END; 
```
In this scenario, the log_error_messages procedure would be called from within each of the 
exception handlers. Since it is an autonomous transaction, the log_error_messages procedure will 
execute without affecting the calling procedure. This ensures that no issues will arise if 
log_error_messages were to raise an exception. Control of the application would be passed to this 
procedure for the processing, and then the program would exit. 
**How It Works** 
It is possible to redirect control of your code after an exception has been raised using various 
techniques. After an exception is raised and control is redirected to the handler, the statements within 
the handler are executed, and then that program ends. If the code block that contains the exception 
handler is contained within enclosing code block, control will be passed to the next statement within the 
enclosing control block. Otherwise, the program will exit after statements are executed. 
To execute a particular action or series of processes after an exception has been raised, it is a useful 
technique to call a stored procedure or function from within the exception handler. In the **Solution** to 
this recipe, a logging procedure is called that will insert a row into the logging table after each exception 
is raised. This allows the program control to be passed to the procedure or function that is called, and 
when that body of code has completed execution, control is passed back to the exception handler. This 
is a very useful technique for logging exceptions but can also be used for various other tasks such as 
sending an e-mail alert or performing some database cleanup. 

## 9-7. Raising Exceptions and Continuing Processing 

**Problem** 
The application you are coding requires a series of INSERT, UPDATE, and DELETE statements to be called. 
You want to add proper exception handling to your code and also ensure that processing continues and 
all of the statements are executed even if an exception is raised. 
**Solution** 
Enclose each statement within its own code block, and provide an exception handler for each of the 
blocks. When an exception is raised within one of the nested blocks, then control will be passed back to 
the main code block, and execution will continue. This style of coding is displayed in the following 
example: 
```sql 
CREATE OR REPLACE PROCEDURE delete_employee (in_emp_id   IN NUMBER) AS 
  BEGIN 
    -- ENTER INITIAL NESTED CODE BLOCK TO PERFORM DELETE 
    BEGIN 
        -- DELETE EMP 
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         -- perform statements 
    END; 
 
     -- ENTER SECOND NESTED CODE BLOCK TO PERFORM LOG ENTRY 
     BEGIN 
        -- LOG DELETION OF  EMP 
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         -- perform statements 
    END; 
EXCEPTION WHEN OTHERS THEN 
  -- perform statements 
END; 
```
As this code stands, no exception will go on to become an unhanded exception because the 
outermost code block contains an exception handler using the OTHERS exception name. Every nested 
code block contains a handler, so every exception that is encountered in this application will be caught. 
**How It Works** 
Scope plays an important role when designing your application’s exception-handling system. When 
doing so, you should think of your application and determine whether portions of the code need to be 
executed regardless of any exception being raised. If this is the case, then you will need to provide proper 
exception handling and still ensure that the essential code is executed each run.  
The scope of an exception pertains to the code block in which the exception is declared. Once an 
exception has been encountered, program control halts immediately and is passed to the exception 
handler for the current block. If there is not an exception handler in the current code block or if no 
handler matches the exception that was raised, then control passes to the calling program or outer 
control block. Control is immediately passed to the exception handler of that program. If no exception 
handler exists or matches the exception being raised, then the execution of that block halts, and the 
exception is raised to the next calling program or outer code block, and so on.  
This pattern can be followed any number of times. That is why the technique used in the **Solution** to 
this recipe works well. There is one main code block that embodies two nested code blocks. Each of the 
blocks contains essential statements that need to be run. If an exception is raised within the DELETE 
block, then program control is passed back to its outer code block, and processing continues. In this 
case, both essential statements will always be executed, even if exceptions are raised. 

## 9-8. Associating Error Numbers with Exceptions That Have No Name 
**Problem** 
You want to associate an error number to those errors that do not have predefined names. 
**Solution** 
Make use of PRAGMA EXCEPTION_INIT to tell the compiler to associate an Oracle error number with an 
exception name. This will allow the use of an easy-to-identify name rather than an obscure error 
number when working with the exception. The example in this recipe shows how an error number can 
be associated with an exception name and how the exception can later be raised. 
```sql
CREATE OR REPLACE FUNCTION calculate_salary_hours(salary  IN NUMBER, 
                                              hours   IN NUMBER DEFAULT 1) 
RETURN NUMBER AS 
BEGIN 
  RETURN salary/hours; 
END; 
 
 
DECLARE 
  DIVISOR_IS_ZERO  EXCEPTION; 
  PRAGMA EXCEPTION_INIT(DIVISOR_IS_ZERO, -1476); 
  per_hour      NUMBER; 
BEGIN 
  SELECT calculate_salary_hours(0,0) 
  INTO per_hour 
  FROM DUAL; 
EXCEPTION WHEN DIVISOR_IS_ZERO THEN 
  DBMS_OUTPUT.PUT_LINE('You cannot pass a zero for the number of hours'); 
END; 
```
The exception declared within this example is associated with the ORA-01476 error code. When a 
divide-by-zero exception occurs, then the handler is executed. 
**How It Works** 
PRAGMA EXCEPTION_INIT allows an error number to be associated with an error name. Thus, it provides an 
easy way to handle those exceptions that are available only by default via an error number. It is much 
easier to identify an exception by name rather than by number, especially when you have been away 
from the code base for some length of time. 
The PRAGMA EXCEPTION_INIT must be declared within the declaration section of your code. The 
exception that is to be associated with the error number must be declared prior to the PRAGMA 
declaration. The format for using PRAGMA EXCEPTION_INIT is as follows: 
```sql
DECLARE 
  exception_name   EXCEPTION; 
  PRAGMA EXCEPTION_INIT(exception_name, <<exception_code>>); 
BEGIN 
  -- Perform statements 
EXCEPTION 
  WHEN exception_name THEN 
    -- Perform error handling 
END; 
```
The exception_name in this pseudocode refers to the name of the exception you are declaring. The 
<<exception_code>> is the number of the ORA-xxxxx error that you are associating with the exception. In 
the Solution to this recipe, ORA-01476 is associated with the exception. That exception in particular 
denotes divisor is equal to zero. When this exception is raised, it is easier to identify the cause of the 
error via the DIVISOR_IS_ZERO identifier than by the -01476 code. 
Whenever possible, it is essential to provide an easy means of identification for portions of code that 
may be difficult to understand. Exception numbers by themselves are not easily identifiable unless you 
see the exception often enough. Even then, an exception handler with the number -01476 in it seems 
obscure. In this case, it is always best to associate a more common name to the exception so that the 
code can instantly have meaning to someone who is unfamiliar with the code or to you when you need 
to maintain the code for years to come.  

## 9-9. Tracing an Exception to Its Origin  
**Problem** 
Your application continues to raise an exception that is being caught with the OTHERS handler. You’ve 
used SQLCODE and DBMS_UTILITY.FORMAT_ERROR_STACK to help you find the cause of the exception but are 
still unable to do so. 
**Solution** 
Use the stack trace for the exception to trace the error back to its origination. In particular, use 
DBMS_UTILITY.FORMAT_ERROR_BACKTRACE and DBMS_UTILITY.FORMAT_CALL_TRACE to help you find the cause 
of the exception. The following **Solution** demonstrates the use of FORMAT_ERROR_BACKTRACE: 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_detail(emp_info IN VARCHAR2) IS 
  emp_qry             VARCHAR2(500); 
  emp_first           employees.first_name%TYPE; 
  emp_last            employees.last_name%TYPE; 
  email               employees.email%TYPE; 
 
  valid_id_count      NUMBER := 0; 
  valid_flag          BOOLEAN := TRUE; 
  temp_emp_info       VARCHAR2(50); 
 
 
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
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
    END IF; 
   
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         
        DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); 
         
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('AN UNEXPECTED ERROR HAS OCCURRED, PLEASE ' || 
                           'TRY AGAIN'); 
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); 
 END; 
```
Here are the results when calling within invalid argument information: 
```sql
SQL> exec obtain_emp_detail('junea@'); 
THE INFORMATION YOU HAVE USED DOES NOT MATCH ANY EMPLOYEE RECORD 
ORA-06512: at "OBTAIN_EMP_DETAIL", line 32 
 
 
PL/SQL procedure successfully completed. 
```
As you can see, the exact line number that caused the exception to be raised is displayed. This is 
especially useful if you use a development environment that includes line numbering for your source 
code. If not, then you can certainly count out the line numbers manually. 
Similarly, DBMS_UTILITY.FORMAT_CALL_STACK lists the object number, line, and object where the issue 
had occurred. The following example uses the same procedure as the previous example, but this time 
DBMS_UTILITY.FORMAT_CALL_STACK is used in the exception handler: 
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
      DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
    END IF; 
   
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         
        DBMS_OUTPUT.PUT_LINE('THE INFORMATION YOU HAVE USED DOES ' || 
                           'NOT MATCH ANY EMPLOYEE RECORD'); 
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK); 
         
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('AN UNEXPECTED ERROR HAS OCCURRED, PLEASE ' || 
                           'TRY AGAIN'); 
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK); 
 END;
```
Here are the results when calling within invalid argument information:
```sql
SQL> exec obtain_emp_detail('june@'); 
THE INFORMATION YOU HAVE USED DOES NOT MATCH ANY EMPLOYEE RECORD
----- PL/SQL Call Stack ----- 
  object      line  object 
  handle    number 
name 
24DD3280     47  procedure OBTAIN_EMP_DETAIL
273AA66C      1 
anonymous block 
PL/SQL procedure successfully completed.
```
Each of the two utilities demonstrated in this Solution serves an explicit purpose—to assist you in
finding the cause of exceptions in your applications. 
**How It Works** 
Oracle provides a few different utilities to help diagnose and repair issues with code. The utilities
discussed in this recipe provide feedback regarding exceptions that have been raised within application
code. DBMS_UTILITY.FORMAT_ERROR_BACKTRACE is used to display the list of lines that goes back to the point
at which your application fails. This utility was added in Oracle Database 10g. Its ability to identify the
exact line number where the code has failed can save the time of reading through each line to look for
the errors. Using this information along with the Oracle exception that is raised should give you enough
insight to determine the exact cause of the Problem. 
The result from DBMS_UTILITY.FORMAT_ERROR_BACKTRACE can be assigned to a variable since it is a
function. Most likely a procedure will be used to log the exceptions so that they can be reviewed at a later
time. Such a procedure could accept the variable containing the result from
DBMS_UTILITY.FORMAT_ERROR_BACKTRACE as input. 
The DBMS_UTILITY.FORMAT_CALL_STACK function is used to print out a formatted string of the
execution call stack or the sequence of calls for your application. It displays the different objects used,
along with line numbers from which calls were made. It can be very useful for pinpointing those errors
that you are having trouble resolving. It can also be useful for obtaining information regarding the
execution order of your application. If you are unsure of exactly what order processes are being called,
this function will give you that information. 
Using a combination of these utilities when debugging and developing your code is a good practice.
You may find it useful to create helper functions that contain calls to these utilities so that you can easily
log all stack traces into a database table or a file for later viewing. These can be of utmost importance
when debugging issues or evaluating application execution. 

## 9-10. Displaying PL/SQL Compiler Warnings  
**Problem** 
You are interested in making your code more robust by ensuring that no issues will crop up as time goes 
by and the code evolves. You want to have the PL/SQL compiler alert you of possible issues with your 
code. 
**Solution** 
Use PL/SQL compile-time warnings to alert you of possible issues with your code. Enable warnings for 
your current session by issuing the proper ALTER SESSION statements or by using the DBMS_WARNING 
package to do so. This **Solution** will demonstrate each of these techniques to help you decide which will 
work best for your debugging purposes. 
First let’s take a look at using ALTER SESSION to enable and configure warnings for your 
environment. This technique can be very useful when you want to enable warnings for an entire session. 
The following example shows how to enable warnings and how to display them given a short code block: 
```sql
ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:ALL'; 
 
CREATE OR REPLACE FUNCTION calculate_salary_hours(salary  IN NUMBER, 
                                                  hours   IN NUMBER DEFAULT 1) 
RETURN NUMBER AS 
BEGIN 
  RETURN salary/hours; 
END; 
 
SHOW ERRORS; 
 
Here are the results from running create or replace function with all warnings enabled: 
 
Errors for FUNCTION CALCULATE_SALARY_HOURS: 
 
LINE/COL 
-------------------------------------------------------------------------------- 
ERROR 
-------------------------------------------------------------------------------- 
1/1
```
PLW-05018: unit CALCULATE_SALARY_HOURS omitted optional AUTHID clause; 
 default value DEFINER used 
 
Next, let’s look at the DBMS_WARNINGS package. Use of this technique is more helpful if you are using a 
development environment such as PL/SQL Developer that compiles your code for you. The following is 
an example of performing the same CREATE OR REPLACE FUNCTION as earlier, but this time using 
DBMS_WARNINGS: 
```sql
SQL> CALL DBMS_WARNING.SET_WARNING_SETTING_STRING('ENABLE:ALL','SESSION'); 
 
Call completed. 
 
CHAPTER 9  EXCEPTIONS 
212 
SQL> CREATE OR REPLACE FUNCTION calculate_salary_hours(salary  IN NUMBER, 
                                                  hours   IN NUMBER DEFAULT 1) 
RETURN NUMBER AS 
BEGIN 
  RETURN salary/hours; 
END; 
/  2    3    4    5    6    7   
 
SP2-0806: Function created with compilation warnings 
 
SQL> SHOW ERRORS; 
Errors for FUNCTION CALCULATE_SALARY_HOURS: 
 
LINE/COL 
-------------------------------------------------------------------------------- 
ERROR 
-------------------------------------------------------------------------------- 
1/1
```
PLW-05018: unit CALCULATE_SALARY_HOURS omitted optional AUTHID clause; default v 
alue DEFINER used 
 
Both techniques provide similar results, but one can be set at the database level and the other can 
be more useful for use in a development environment.  
**How It Works** 
Learning about warnings against your code can help you solidify your code and repair it so that it can 
become more robust when it is used in a production environment. Although PL/SQL warnings will not 
prevent the code from compiling and executing, they can certainly provide good insight to inform you of 
places in your code that could possibly incur issues at a later time. As you have learned from the **Solution** 
to this recipe, there are two techniques that can be used to enable warnings for your application. Those 
are the use of ALTER SESSION statements and the DBMS_WARNINGS package. Both are valid techniques for 
enabling and disabling warnings, but each has its own set of strong points and drawbacks. 
The PLSQL_WARNINGS compilation parameter must be used to enable or disable warnings within a 
session. By setting it, you can control the types of warnings that are displayed, along with how much 
information is displayed and even how it is displayed. This parameter can be set using the ALTER SESSION 
statement. The format for setting this parameter using ALTER SESSION is as follows: 
```sql
ALTER SESSION SET PLSQL_WARNINGS = "[ENABLE/DISABLE:PARAMETER]" 
```
The PLSQL_WARNINGS compilation parameter accepts a number of different parameters that each tell 
the compiler what types of warnings to display and what to ignore. There are three different categories of 
warnings that can be used. Table 9-3 shows the different types of warnings along with their descriptions. 
```text
Table 9-3. Warning  Categories 
Category                  Description 
PERFORMANCE               May hinder application performance 
INFORMATIONAL             May complicate application maintenance but contains no immediate issues 
SECURE                    May cause unexpected or incorrect results ALL Includes all the categories 
```
The DBMS_WARNINGS package works in a similar fashion: it accepts the same arguments as the 
PLSQL_WARNINGS parameter. The difference is that you can control when the warnings are enabled or 
disabled by placing the call to the package in locations that you choose. This does not matter much 
when working via SQL*Plus, but if you are using a development environment such as Oracle SQL 
Developer, then DBMS_WARNINGS must be used. The format for calling this procedure is as follows: 
```sql
CALL DBMS_WARNING.SET_WARNING_SETTING_STRING('warning_category:value','scope'); 
```
The categories are the same as PLSQL_WARNINGS, as are the values of the categories. The scope determines 
whether the warnings will be used for the duration of the session or for all sessions. There are various 
other options that can be used with the DBMS_WARNINGS package. To learn more about these options, 
please see the Oracle Database 11g documentation. 

