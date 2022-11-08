---
title: Oracle PLSQL Recipes 17-Unit Testing With utPLSQL
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



# 17. Unit Testing With utPLSQL 
Testing is a necessary evil of the application development process. Sadly, testing is oftentimes 
overlooked or bypassed when time is short. Distribution of untested or undertested code can lead to 
code that is riddled with bugs and to disappointed users. Unit testing with a well-constructed framework 
can help to alleviate some of the time that it takes to conform to a well-tested development process. 
There are a few different options available to you for testing your PL/SQL code. SQL Developer 
provides some good debugging options that you can read about in Recipe 12-12. You can also use 
DBMS_OUTPUT statements within your code to display the results of variables as your code executes. This is 
a good technique for helping to pinpoint issues in your code and one you can read about in Recipe 17-1. 
There are also unit-testing frameworks available that will help you to write unit tests for your PL/SQL 
code objects. Although not covered in this book, the PLUTO (PL/SQL Unit Testing for Oracle) framework 
(http://code.google.com/p/pluto-test-framework/) is one such framework. Another is the utPLSQL unit-
testing framework, and this chapter will focus on utPLSQL since it is more widely adopted than the 
others. 
The utPLSQL unit-testing framework can alleviate some of the pain of unit testing. The framework is 
easy to use and performs nicely for testing code under every circumstance that can be imagined. There 
are also many options in utPLSQL that can be used to enhance your unit testing process. This chapter 
includes recipes that show how to use the framework for testing PL/SQL objects, how to create test 
suites, and how to automate your unit tests. In the end, you will learn to make the unit testing process a 
functional part of your development process. As a result of using unit testing, your applications will be 
successful, and you will spend much less time maintaining the code base. 

## 17-1. Testing Stored PL/SQL Code Without Unit Tests  
**Problem** 
You want to ensure that a block of PL/SQL code is working properly, but don’t want to take the time to 
write a unit test. 
**Solution** 
 Wrap the code in DBMS_OUTPUT statements that display or print the results of intermediate and final 
computations and the results of complex conditional steps and branches. This will enable you to see the 
path that the code is taking when the function is called with specified parameters. The following 
example demonstrates this tactic for placing comments into strategic locations within a PL/SQL code 
block in order to help determine if code is functioning as expected. For example, suppose you wish to 
quickly test the function we introduced in the example for Recipe 4-1. Here’s how you’d modify it to 
quickly test the correctness of its results.  
```sql 
CREATE OR REPLACE 
FUNCTION CALC_QUARTER_HOUR(HOURS IN NUMBER) RETURN NUMBER AS 
  CALCULATED_HOURS NUMBER := 0; 
BEGIN 
 
   -- if HOURS is greater than one, then calculate the decimal portion 
  -- based upon quarterly hours 
 IF HOURS > 1 THEN 
  -- calculate the modulus of the HOURS variable and compare it to 
  DBMS_OUTPUT.Put_LINE('The value passed in was greater than one hour...'); 
  -- fractional values 
    IF MOD(HOURS, 1) <=.125 THEN 
       DBMS_OUTPUT.Put_LINE('The decimal portion < .125'); 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1); 
    ELSIF MOD(HOURS, 1) > .125 AND MOD(HOURS,1) <= .375 THEN 
       DBMS_OUTPUT.Put_LINE('The decimal portion <= .375'); 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.25,1); 
    ELSIF MOD(HOURS, 1) > .375 AND MOD(HOURS,1) <= .625 THEN 
       DBMS_OUTPUT.Put_LINE('The decimal portion <= .625'); 
       CALCULATED_HOURS := substr(to_char(HOURS),0,1) + MOD(.50,1); 
    ELSIF MOD(HOURS, 1) > .63 AND MOD(HOURS,1) <= .825 THEN 
       DBMS_OUTPUT.Put_LINE('The decimal portion <= .825'); 
       CALCULATED_HOURS := SUBSTR(TO_CHAR(HOURS),0,1) + MOD(.75,1); 
    ELSIF MOD(HOURS, 1) > .825 AND MOD(HOURS,1) <= .999 THEN 
       DBMS_OUTPUT.Put_LINE('The decimal portion <= .999'); 
       CALCULATED_HOURS := (substr(to_char(HOURS),0,1) + 1) + MOD(.00,1); 
    ELSE 
       DBMS_OUTPUT.Put_LINE('The hours passed in will use standard rounding'); 
       CALCULATED_HOURS := ROUND(HOURS,1); 
 
    END IF; 
 
  ELSE 
    -- if HOURS is less than one, then calculate the entire value 
    DBMS_OUTPUT.Put_LINE('Less than 1 hour was passed in...'); 
    -- based upon quarterly hours 
    IF HOURS > 0 AND HOURS <=.375 THEN 
        DBMS_OUTPUT.Put_LINE('The decimal portion < .125'); 
        CALCULATED_HOURS := .25; 
    ELSIF HOURS > .375 AND HOURS <= .625 THEN 
        DBMS_OUTPUT.Put_LINE('The decimal portion <= .625'); 
        CALCULATED_HOURS := .5; 
    ELSIF HOURS > .625 AND HOURS <= .825 THEN 
        DBMS_OUTPUT.Put_LINE('The decimal portion <= .825'); 
        CALCULATED_HOURS := .75; 
    ELSIF HOURS > .825 AND HOURS <= .999 THEN 
        DBMS_OUTPUT.Put_LINE('The decimal portion <= .999'); 
        CALCULATED_HOURS := 1; 
    ELSE 
        DBMS_OUTPUT.Put_LINE('The hours passed in will use standard rounding'); 
        CALCULATED_HOURS := ROUND(HOURS,1); 
    END IF; 
 
  END IF; 
 
  RETURN CALCULATED_HOURS; 
 
END CALC_QUARTER_HOUR; 
/
```
When the CALC_QUARTER_HOUR function is executed with a value of 7.34, the comments will be 
displayed as seen in the next snippet from a SQL*Plus session. 
```sql
SQL> set serveroutput on 
SQL> select calc_quarter_hour(7.34) from dual; 
 
CALC_QUARTER_HOUR(7.34) 
----------------------- 
                  7.25 
```
The value passed in was greater than one hour... 
The decimal portion <= .375 
**How It Works** 
The use of DBMS_OUTPUT statements within PL/SQL code for displaying data or information pertaining to 
the functionality of the code has been a great tactic for testing code in any language. As a matter of fact, 
it is probably one of the most widely used techniques for debugging code. The ability to see values as 
they are calculated or to determine how a condition is being handled can be very useful for determining 
whether your code is executing as it should. 
In order to use DBMS_OUTPUT statements for testing your code, you must place them in strategic 
locations. In the example for this recipe, comments have been placed within each of the IF-ELSE blocks 
to display a bit of text that will tell the developer how the values are being processed within the function. 
This can be very useful when testing the code because a series of numbers can be passed into the 
function in order to determine whether the correct result is being returned. If not, then you will be able 
to see exactly where the code is being evaluated incorrectly. 
Although using DBMS_OUTPUT statements in code can be very useful for determining where code is 
functioning properly, it can cause clutter, and can also create its own issues. For example, if you forget to 
place a quote after one of the DBMS_OUTPUT statements that you place into your code, then the code will 
not compile correctly, causing you to hunt for the cause of yet another issue. Also, it is a good idea to 
remove the output statements before code is released into production. This can take some time, which 
could be better spent on development. As a means for testing small units of code, using DBMS_OUTPUT 
statements works quite well. However, if you wish to develop entire test suites and automated unit 
testing then you should go on to read Recipe 17-2 regarding utPLSQL. 

## 17-2. Installing the utPLSQL Unit Testing Framework 
**Problem** 
You’ve chosen the utPLSQL unit-testing framework for PL/SQL for your work, and you want to install it. 
**Solution** 
First, download the utPLSQL sources from http://utplsql.sourceforge.net/. Once you have obtained 
the sources, use the following steps to install the utPLSQL package into the database for which you wish 
to write unit tests, and make it available for all schemas. 
Create a user to host the utPLSQL tables, packages, and other objects. In this 
example, the user will be named UTP, and the default permanent and 
temporary tablespaces will be used. 
```sql
SQL> create user utp identified by abc123; 
Grant privileges to the newly created UTP user using the GRANT privilege_name TO 
user_name statement, replacing values with the appropriate privilege and 
username. The user will require the following privileges: 
 Create session 
 Create procedure 
 Create table 
 Create view 
 Create sequence 
 Create public synonym 
 Drop public synonym 
Install the objects by running the ut_i_do.sql script. 
SQL> @ut_i_do install 
```
Once these steps have been completed then you will have the ability to run unit tests on packages 
that are loaded into different schemas within the database. 
**How It Works** 
Before you can begin to write and run unit tests within the utPLSQL framework for the PL/SQL contained 
within your database, you must install the utPLSQL package into a database schema. While the utPLSQL 
framework can be loaded into the SYSTEM schema, it is better to separate the framework into its own 
schema by creating a separate user and installing the packages, tables, and other objects into it. The 
**Solution** to this recipe steps through the recommended approach taken to install the utPLSQL framework 
into the database of your choice. 
Once you have created a user schema in which to install the utPLSQL framework objects, you must 
grant it the appropriate privileges. The majority of the privileges are used to create the objects that are 
required to make the framework functional. Public synonyms are created for many of the framework 
objects, and this allows them to be accessible to other database user accounts. After all privileges have 
been granted, running the ut_i_do.sql script and passing the install parameter will complete the 
installation of the framework. After completion, you can begin to build unit test packages and install 
them into different schemas within the database, depending on which PL/SQL objects that you wish to 
test.  
■ Note Unit tests will be executed from the same schema in which the PL/SQL object that is being tested resides, 
not from the schema that contains the utPLSQL framework objects. 

## 17-3. Building a utPLSQL Test Package 
**Problem** 
You would like to build a unit test package for one or more of the PL/SQL objects in your database 
schema. 
**Solution** 
You want to build a utPLSQL test package to test an object in your database. A test package consists of two 
separate files, a package header and a package body.  
Create a header for the test package and save it in a file with the same name you 
have given the header and with a .pks suffix. A header file contains three 
procedures: ut_setup, ut_teardown, and the procedure that performs the unit 
tests of the target object in your database. For example, suppose you want to 
create a unit test package to test the code for the CALC_QUARTERLY_HOURS 
function of Recipe 17-1. This package header should be stored into a file 
named ut_calc_quarter_hour.pks and loaded into the database whose objects 
you are testing. 
```sql
CREATE OR REPLACE PACKAGE ut_calc_quarter_hour 
IS 
  PROCEDURE ut_setup; 
  PROCEDURE ut_teardown; 
 
  PROCEDURE ut_calc_quarter_hour; 
END ut_calc_quarter_hour;
```
Create the package body that implements the procedures specified by the unit test 
package header and save it as a file with the same name as the header, but this 
time with a .pkb suffix. The following package body should be stored into a file 
named ut_calc_quarter_hour.pkb and loaded into the database. 
```sql
CREATE OR REPLACE PACKAGE BODY ut_calc_quarter_hour 
IS 
 
PROCEDURE ut_setup IS 
BEGIN 
  NULL; 
END; 
 
PROCEDURE ut_teardown IS 
BEGIN 
  NULL; 
END; 
 
PROCEDURE ut_calc_quarter_hour IS 
BEGIN 
 
  -- Perform unit tests here 
  NULL; 
   
END ut_calc_quarter_hour; 
 
END ut_calc_quarter_hour; 
```
The package body in this example conforms to the format that must be used for testing packages 
using the utPLSQL framework. 
■ Note The .pks and .pkb suffixes could be changed to something different, like .sql, if you wish. You could 
also store both the package header and body in the same file. However, utPLSQL framework will look for the .pks 
and .pkb suffixes in order to automatically recompile your test packages before each test. It is best to follow the 
utPLSQL convention to ensure that your test packages are always valid. 
**How It Works** 
A unit test package for the utPLSQL framework consists of a package header and a body. The package 
header declares a setup procedure, a teardown procedure, and a unit testing procedure. The package 
body consists of the PL/SQL code that implements the unit test. When you create a ut_PLSQL package, its 
name must be prefixed with ut_, followed by the procedure or function name for which you are writing 
the unit test. The unit test prefix can be changed, but ut_ is the default. For more information on 
changing the unit test prefix, please see Recipe 12-8. 
The test package body must contain both a setup and teardown procedure. These procedures must 
also be given names that use the same prefix you have chosen for your unit testing. Therefore, as you can 
see in the Solution to this recipe, the package header declares ut_setup and ut_teardown procedures. The 
ut_setup procedure is to initialize the variables or data structures the unit test procedure uses. When a 
unit test is executed, ut_setup is always the first procedure to execute. The ut_teardown procedure is 
used to clean up after all of the tests have been run. You should use this procedure to destroy all of the 
data structures and variables created to support your unit tests. The ut_teardown procedure is always 
executed last, after all unit tests have been run. 
■ Note If you are choosing to use manual registration for your tests, you will be required to register each test 
procedure in the ut_setup procedure as well. By default, registration of unit test procedures occurs automatically, 
so you do not need to register them within ut_setup. If you are interested in learning more about manual unit test 
registration, please see the online documentation that can be found at: http://utplsql.oracledeveloper.nl/ 
The package must also contain an implementation for your unit test procedures. The unit test 
procedure names should begin with the ut_ prefix followed by the name of the PL/SQL object that you 
are testing. In the case of the Solution for this recipe, the procedure name is ut_calc_quarter_hour. The 
Solution to this recipe does not contain any unit tests per se, but in order to perform a valid unit test of 
the PL/SQL object, you must define a test case for each possible scenario using the assertion routines 
that are made available by utAssert. To learn more about the different assertion routines, please see 
Recipe 17-4. 

## 17-4. Writing a utPLSQL Unit Test Procedure 

**Problem** 
You have a PL/SQL object that you’d like to test to verify it returns the expected values.  
**Solution** 
Create a utPLSQL test package to test every code branch and computation within your function. Use 
utPLSQL assertion statements to test every foreseeable use case for the function. For example, suppose 
you wish to test a simple factorial function that contains four code branches, each of which returns a 
value. Here’s the target function: 
```sql
CREATE OR REPLACE FUNCTION factorial (fact INTEGER) RETURN INTEGER is 
 
BEGIN 
 
   IF fact < 0 THEN RETURN NULL; 
   ELSIF fact = 0 THEN RETURN 1; 
   ELSIF fact = 1 THEN RETURN fact; 
   ELSE RETURN fact * factorial (fact-1); 
   END IF; 
 
END factorial; 
```
Next, create the unit test package to test the factorial function. Name the package using the same 
name as the function to be tested and adding the prefix ut_ to it In this example, you’ll name the 
package ut_factorial. Create the three required procedures within the package for setup, teardown, 
and testing. Remember to save the file as a PKS file (i.e., one with a .pks file extension).  
```sql
CREATE OR REPLACE PACKAGE ut_factorial IS 
 
   PROCEDURE ut_setup; 
   PROCEDURE ut_teardown; 
   PROCEDURE ut_factorial; 
 
END ut_factorial; 
```
Now create the unit testing package body. No code is required for the ut_setup or the ut_teardown 
procedures as these are usually reserved for code that updates the database prior to or after running the 
tests. For example, the setup procedure may insert records that are required only by the unit test, which 
means that the teardown routine must clean up any data the test leaves behind. The ut_factorial 

procedure is built with a series of assert statements that test each code branch in the factorial 
function. Remember to save the file as a PKB file (i.e., one with a .pkb file extension). 
```sql 
CREATE OR REPLACE PACKAGE BODY ut_factorial IS 
 
PROCEDURE ut_setup IS 
BEGIN 
   NULL; 
END ut_setup; 
 
PROCEDURE ut_teardown IS 
BEGIN 
   NULL; 
END ut_teardown; 
 
PROCEDURE ut_factorial IS 
BEGIN 
   utAssert.isnull ('is NULL test', factorial(-1)); 
   utAssert.eqQuery ('0! Test', 'select factorial(0) from dual', 'select 1 from dual'); 
   utAssert.eqQuery ('1! Test', 'select factorial(1) from dual', 'select 1 from dual'); 
   utAssert.eqQuery ('N! Test', 'select FACTORIAL(5) from dual', 'select 120 from dual'); 
END ut_factorial; 
 
END ut_factorial; 
```
**How It Works** 
The utPLSQL package contains a number of tests that can be used to ensure that your code is working 
properly. Each of these tests is an assertion, which is a statement that evaluates to either true or false 
depending on whether its conditions are met. The **Solution** to this recipe uses four tests to determine 
whether the function returns an appropriate result for each scenario. The utAssert.isnull procedure 
verifies the second parameter returns a null value when executed. The utAssert.eqQuery procedure uses 
the select statements in parameter positions two and three to determine if the unit test succeeds or 
fails. Each select statement must return the same value when executed to succeed. The three calls to 
utAssert.eqQuery procedure in the ut_factorial procedure tests one branch (if statement) within the 
factorial function. The expected return value from the factorial is used in the select statement of the 
third parameter to retrieve the value from dual. If the factorial is updated in such a way that any code 
branch no longer returns the expected value, the unit test will fail. This test should be performed after 
modifying the factorial function to test for bugs introduced by the update. Table 17-1 lists the different 
assertion tests that are part of the utAssert package. 
```text
Table 17-1. utPLSQL Assertion Tests 
Assertion Name Description 
utAssert.eq Checks equality of scalar values 
utAssert.eq_refc_query Checks equality of RefCursor and Query 
utAssert.eq_refc_table Checks equality of RefCursor and Database Tables 
Assertion Name  Description 
utAssert.eqcoll Checks equality of collections 
utAssert.eqcollapi Checks equality of collections 
utAssert.eqfile Checks equality of files 
utAssert.eqoutput Checks equality of DBMS_OUTPUT values 
utAssert.eqpipe Checks equality of database pipes 
utAssert.eqquery Checks equality of different queries 
utAssert.eqqueryvalue Checks equality of query against a value 
utAssert.eqtabcount Checks equality of table counts 
utAssert.eqtable Checks equality of different database tables 
UTASSERT.isnotnull Checks for NOT NULL values 
utAssert.isnull  Checks for NULL values 
utAssert.objexists Checks for the existence of database objects 
utAssert.objnotexists Checks for the existence of database objects 
utAssert.previous_failed Checks if the previous assertion failed 
utAssert.previous_passed Checks if the previous assertion passed 
utAssert.this Generic “this” procedure 
utAssert.throws Checks if a procedure or function throws an exception 
```
There are many other tests that can also be used to help build your unit test packages. For an entire 
list of the tests that are available, please see the documentation that can be found online at: 
http://utplsql.oracledeveloper.nl/. 

## 17-5. Running a utPLSQL Test 
**Problem** 
With a unit test package defined, you want to run it to verify that a function returns the values you expect 
under a variety of scenarios. 
CHAPTER 17  UNIT TESTING WITH UTPLSQL 
370 
**Solution** 
Use the utPLSQL.test procedure to run your test package. For example, suppose you want to run the unit
test you built in 17-4. To do so, enter the following commands. 
set serverout on 
exec utPLSQL.test('factorial', recompile_in => FALSE) 
Executing the commands above produces the following output. 
```text
>    SSSS   U     U   CCC     CCC   EEEEEEE   SSSS     SSSS 
>   S    S  U     U  C   C   C   C  E        S    S   S    S 
>  S        U     U C     C C     C E       S        S 
>   S       U     U C       C       E        S        S 
>    SSSS   U     U C       C       EEEE      SSSS     SSSS 
>        S  U     U C       C       E             S        S 
>         S U     U C     C C     C E              S        S 
>   S    S   U   U   C   C   C   C  E        S    S   S    S 
>    SSSS     UUU     CCC     CCC   EEEEEEE   SSSS     SSSS 
```
SUCCESS: "factorial" 
```text
> Individual Test Case Results: 
> 
SUCCESS - factorial.UT_FACTORIAL: ISNULL "is NULL test" Expected "" and got "" 
> 
SUCCESS - factorial.UT_FACTORIAL: EQQUERY "0! Test" Result: Result set for "select
factorial(0) from dual does match that of "select 1 from dual" 
 CHAPTER 17  UNIT TESTING WITH UTPLSQL 
371 
> 
SUCCESS - factorial.UT_FACTORIAL: EQQUERY "1! Test" Result: Result set for "select 
factorial(1) from dual does match that of "select 1 from dual" 
> 
SUCCESS - factorial.UT_FACTORIAL: EQQUERY "N! Test" Result: Result set for "select 
FACTORIAL(5) from dual does match that of "select 120 from dual" 
> 
> 
> Errors recorded in utPLSQL Error Log: 
> 
> NONE FOUND 
 
PL/SQL procedure successfully completed. 
SQL> spool off 
```
What if one of your test cases fails? Suppose that one of the test cases for the FACTORIAL test has 
been modified so that a failure will result. Following is the resulting output from a failed unit test. 
```sql
SQL> exec utPLSQL.test('factorial', recompile_in => FALSE) 
. 
>  FFFFFFF   AA     III  L      U     U RRRRR   EEEEEEE 
>  F        A  A     I   L      U     U R    R  E 
>  F       A    A    I   L      U     U R     R E 
>  F      A      A   I   L      U     U R     R E 
>  FFFF   A      A   I   L      U     U RRRRRR  EEEE 
CHAPTER 17  UNIT TESTING WITH UTPLSQL 
372 
>  F      AAAAAAAA   I   L      U     U R   R   E 
>  F      A      A   I   L      U     U R    R  E 
>  F      A      A   I   L       U   U  R     R E 
>  F      A      A  III  LLLLLLL  UUU   R     R EEEEEEE 
. 
FAILURE: "factorial" 
. 
> Individual Test Case Results: 
> 
SUCCESS - factorial.UT_FACTORIAL: ISNULL "is NULL test" Expected "" and got "" 
> 
SUCCESS - factorial.UT_FACTORIAL: EQQUERY "0! Test" Result: Result set for 
"select factorial(0) from dual does match that of "select 1 from dual" 
> 
SUCCESS - factorial.UT_FACTORIAL: EQQUERY "1! Test" Result: Result set for 
"select factorial(1) from dual does match that of "select 1 from dual" 
> 
FAILURE - factorial.UT_FACTORIAL: EQQUERY "N! Test" Result: Result set for 
"select FACTORIAL(5) from dual does  not match that of "select 121 from dual" 
> 
> 
> Errors recorded in utPLSQL Error Log: 
> 
> NONE FOUND 

PL/SQL procedure successfully completed. 
```
**How It Works** 
The utPLSQL framework makes it easy to execute all of the tests that you have setup within a unit test 
package; you need only to enter a utPLSQL.test command. In the **Solution** to this recipe, the SET 
SERVEROUT ON command enables output from the DBMS_OUTPUT statements within the utPLSQL.test 
procedure. Without this command you cannot view the results of the unit test. The call to the 
utPLSQL.test procedure passes two parameters, the first is the name of the unit test to run. Notice that 
you do not specify the name of the package built for the unit test. Instead, you pass the name of the 
function being tested. The second parameter tells the utPLSQL.test procedure not to recompile any of 
the code before running the test. 

## 17-6. Building a utPLSQL Test Suite 
**Problem** 
You have created numerous unit test procedures that you must run every time you modify your code. 
Running each test individually is both time-consuming and error-prone, as you may forget to run a test 
or two. You need a simple method to run all of your tests at once. 
**Solution** 
Use the utsuite.add command of utPLSQL to build a test suite, use the utPackage.add command to add 
individual unit tests to it, and then run the result. For example, here’s how to build a suite to run the unit 
tests you developed in Recipes 17-3 and 17-4. 
Create the test suite. 
exec utSuite.add ('My Test Suite', 'Test all my functions'); 
Add individual unit tests to the suite. 
exec utPackage.add ('My Test Suite', 'calc_quarter_hour'); 
exec utPackage.add ('My Test Suite', 'factorial'); 
Run the test suite. See recipe 17-7. 
**How It Works** 
The utSuite.add routine creates a new test suite using the text in the first parameter as its unique name. 
Note that the utPLSQL utility uppercases the suite name before saving, so take that into consideration, as 
suite names must be unique. The second parameter is descriptive text for your test suite. 
Once the suite is created, use the utPackage.add procedure to add existing unit tests to the suite. The 
first parameter must match the name of an existing test suite. The second parameter is the name of the 
unit test to run. As more unit tests are developed, they can be added to the suite to provide an easy 
method to run all tests at once. 

## 17-7. Running a utPLSQL Test Suite 
**Problem** 
You have defined a test suite and now wish to run the tests. 
**Solution** 
Use the utPLSQL.testSuite routine to run your tests. For example, here’s how run the test suite defined 
in Recipe 17-6. 

`exec utPLSQL.testSuite ('My Test Suite', recompile_in=>false);`
 
Executing the above test suite produces the following results. 
```sql
SQL> exec utPLSQL.testSuite ('My Test Suite', recompile_in=>false); 
. 
>    SSSS   U     U   CCC     CCC   EEEEEEE   SSSS     SSSS 
>   S    S  U     U  C   C   C   C  E        S    S   S    S 
>  S        U     U C     C C     C E       S        S 
>   S       U     U C       C       E        S        S 
>    SSSS   U     U C       C       EEEE      SSSS     SSSS 
>        S  U     U C       C       E             S        S 
>         S U     U C     C C     C E              S        S 
>   S    S   U   U   C   C   C   C  E        S    S   S    S 
>    SSSS     UUU     CCC     CCC   EEEEEEE   SSSS     SSSS 
. 
SUCCESS: "FACTORIAL" 
. 
> Individual Test Case Results: 
> 
 CHAPTER 17  UNIT TESTING WITH UTPLSQL 
375 
SUCCESS - FACTORIAL.UT_FACTORIAL: ISNULL "is NULL test" Expected "" and got "" 
> 
SUCCESS - FACTORIAL.UT_FACTORIAL: EQQUERY "0! Test" Result: Result set for "select 
factorial(0) from dual does match that of "select 1 from dual" 
> 
SUCCESS - FACTORIAL.UT_FACTORIAL: EQQUERY "1! Test" Result: Result set for "select 
factorial(1) from dual does match that of "select 1 from dual" 
> 
SUCCESS - FACTORIAL.UT_FACTORIAL: EQQUERY "N! Test" Result: Result set for "select 
FACTORIAL(5) from dual does match that of "select 120 from dual" 
> 
> 
> Errors recorded in utPLSQL Error Log: 
> 
> NONE FOUND 
. 
>    SSSS   U     U   CCC     CCC   EEEEEEE   SSSS     SSSS 
>   S    S  U     U  C   C   C   C  E        S    S   S    S 
>  S        U     U C     C C     C E       S        S 
>   S       U     U C       C       E        S        S 
>    SSSS   U     U C       C       EEEE      SSSS     SSSS 
>        S  U     U C       C       E             S        S 
>         S U     U C     C C     C E              S        S 
>   S    S   U   U   C   C   C   C  E        S    S   S    S 
>    SSSS     UUU     CCC     CCC   EEEEEEE   SSSS     SSSS 
CHAPTER 17  UNIT TESTING WITH UTPLSQL 
376 
. 
SUCCESS: "CALC_QUARTER_HOUR" 
. 
> Individual Test Case Results: 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: ISNULL "NULL value" Expected "" and got "" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .10 rounds down" 
Result: Result set for "select calc_quarter_hour(6.10) from dual does match that of "select 
6 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .15 rounds up" Result: 
Result set for "select calc_quarter_hour(6.15) from dual does match that of "select 6.25 
from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .35 rounds down" 
Result: Result set for "select calc_quarter_hour(6.35) from dual does match that of "select 
6.25 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .40 rounds up" Result: 
Result set for "select calc_quarter_hour(6.40) from dual does match that of "select 6.5 from 
dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .65 rounds up" Result: 
Result set for "select calc_quarter_hour(6.65) from dual does match that of "select 6.75 
from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .83 rounds down" 
Result: Result set for "select calc_quarter_hour(6.83) from dual does match that of "select 
7 from dual" 
 CHAPTER 17  UNIT TESTING WITH UTPLSQL 
377 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .92 rounds up" Result: 
Result set for "select calc_quarter_hour(6.92) from dual does match that of "select 7 from 
dual" 
> 
> 
> Errors recorded in utPLSQL Error Log: 
> 
> NONE FOUND 
If you happen to have a test fail, then the output of the test suite will display a failure message for 
the unit test that failed. In the following output, one of the test cases for the FACTORIAL unit test fails. 
>  FFFFFFF   AA     III  L      U     U RRRRR   EEEEEEE 
>  F        A  A     I   L      U     U R    R  E 
>  F       A    A    I   L      U     U R     R E 
>  F      A      A   I   L      U     U R     R E 
>  FFFF   A      A   I   L      U     U RRRRRR  EEEE 
>  F      AAAAAAAA   I   L      U     U R   R   E 
>  F      A      A   I   L      U     U R    R  E 
>  F      A      A   I   L       U   U  R     R E 
>  F      A      A  III  LLLLLLL  UUU   R     R EEEEEEE 
. 
FAILURE: "FACTORIAL" 
. 
> Individual Test Case Results: 
> 
SUCCESS - FACTORIAL.UT_FACTORIAL: ISNULL "is NULL test" Expected "" and got "" 
> 
SUCCESS - FACTORIAL.UT_FACTORIAL: EQQUERY "0! Test" Result: Result set for 
"select factorial(0) from dual does match that of "select 1 from dual" 
> 
SUCCESS - FACTORIAL.UT_FACTORIAL: EQQUERY "1! Test" Result: Result set for 
"select factorial(1) from dual does match that of "select 1 from dual" 
> 
FAILURE - FACTORIAL.UT_FACTORIAL: EQQUERY "N! Test" Result: Result set for 
"select FACTORIAL(5) from dual does  not match that of "select 121 from dual" 
> 
> 
> Errors recorded in utPLSQL Error Log: 
> 
> NONE FOUND 
. 
>    SSSS   U     U   CCC     CCC   EEEEEEE   SSSS     SSSS 
>   S    S  U     U  C   C   C   C  E        S    S   S    S 
>  S        U     U C     C C     C E       S        S 
>   S       U     U C       C       E        S        S 
>    SSSS   U     U C       C       EEEE      SSSS     SSSS 
>        S  U     U C       C       E             S       S 
 CHAPTER 17  UNIT TESTING WITH UTPLSQL 
379 
>         S U     U C     C C     C E              S        S 
>   S    S   U   U   C   C   C   C  E        S    S   S    S 
>    SSSS     UUU     CCC     CCC   EEEEEEE   SSSS     SSSS 
. 
SUCCESS: "CALC_QUARTER_HOUR" 
. 
> Individual Test Case Results: 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: ISNULL "NULL value" Expected 
"" and got "" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .10 rounds 
down" Result: Result set for "select calc_quarter_hour(6.10) from dual does 
match that of "select 6 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .15 rounds 
up" Result: Result set for "select calc_quarter_hour(6.15) from dual does match 
that of "select 6.25 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .35 rounds 
down" Result: Result set for "select calc_quarter_hour(6.35) from dual does 
match that of "select 6.25 from dual" 
> 
CHAPTER 17  UNIT TESTING WITH UTPLSQL 
380 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .40 rounds 
up" Result: Result set for "select calc_quarter_hour(6.40) from dual does match 
that of "select 6.5 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .65 rounds 
up" Result: Result set for "select calc_quarter_hour(6.65) from dual does match 
that of "select 6.75 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .83 rounds 
down" Result: Result set for "select calc_quarter_hour(6.83) from dual does 
match that of "select 7 from dual" 
> 
SUCCESS - CALC_QUARTER_HOUR.UT_CALC_QUARTER_HOUR: EQQUERY "Check that .92 rounds 
up" Result: Result set for "select calc_quarter_hour(6.92) from dual does match 
that of "select 7 from dual" 
> 
> 
> Errors recorded in utPLSQL Error Log: 
> 
> NONE FOUND 
PL/SQL procedure successfully completed. 
```
**How It Works** 
The utPLSQL.testSuite procedure steps though each unit test added using the utPackage.add procedure 
and executes each test. In turn, each test executes and sends its results to the screen. This is a quick 
method to run all tests and see the output on one screen capture. If one of the test cases within a unit 
test fails, all of the remaining tests in the suite will continue to execute, and the test that failed will be 
noted in the output. This is very useful as it will allow tests of many PL/SQL objects at once, and you will 
be able to see which tests had issues and which did not. 
■ Hint Spool the output to a file if the number of tests exceeds the screen buffer’s capacity. 

## 17-8. Reconfiguring utPLSQL Parameters 
**Problem** 
You would like to change some of the configurations for your utPLSQL install. For instance, you would 
like to change the prefix for all of your unit test packages so that, instead of beginning with ut_, they all 
start with test_. 
**Solution** 
Use the utConfig package to alter the configurations for utPLSQL. For this **Solution**, you will see how 
utConfig can be used to change the prefix that is used for all of your test packages. For example, here’s 
how to change the prefix for your test packages from ut_ to test_ using the utConfig package for the 
current schema. 
```sql
SQL> exec utConfig.setPrefix('test_'); 
 
PL/SQL procedure successfully completed. 
```
After executing the statement in the example, the utPLSQL unit test framework will look for test 
packages beginning with the test_ prefix rather than ut_ within the current schema, until the prefix is 
changed again using the utConfig package. 
**How It Works** 
The utPLSQL test framework can be configured to operate differently from its default manner by 
changing options using the utConfig package. Changes can be made for the current schema only, or for 
all schemas within the database. In the **Solution** to this recipe, you have seen that the prefix for test 
packages is configurable. To change the prefix, pass the desired prefix in string format to 
utConfig.setPrefix(). The setPrefix() procedure also accepts an additional schema name that will 
specify the schema to which the configuration option will be applied. If you do not pass a schema name, 
the changes will occur within the current schema. The actual format for executing the 
utConfig.setPrefix procedure is as follows: 
```sql
exec utConfig.setPrefix(desired_prefix, [schema]); 
```
There are many configurable options that can be changed using the utConfig package. Table 17-2 
shows the complete list of options. 
```text
Table 17-2. utConfig Configuration Options 
Option Description 
utConfig.autocompile Configure autocompile feature 
utConfig.registertest Configure the registration mode (manual or automatic) 
utConfig.setdateformat Configure the date format for the date portion of output file names 
utConfig.setdelimiter Configure the V2 delimiter 
utConfig.setdir Configure the directory containing the test package code 
utConfig.setfiledir Configure the directory for file output 
utConfig.setfileextension Configure the file extension for output file names 
utConfig.setfileinfo Configure all of the above file output related items 
utConfig.setincludeprogname Configure whether to include the name of the program being tested 
within output file names 
utConfig.setprefix Configure the default unit test prefix 
utConfig.setreporter Configure the default Output Reporter  
utConfig.settester Configure whose configuration is used 
utConfig.setuserprefix Configure the user prefix for output file names 
utConfig.showfailuresonly Switch off the display for successful tests 
```
You can set of the options shown here using a syntax similar to that shown for the setPrefix() 
procedure that was demonstrated in the **Solution** to this recipe. For more information on using the 
configurations listed in Table 17-2, please see the online documentation that can be found at: 
http://utplsql.oracledeveloper.nl/. Along with configurable options, the utConfig package includes 
some functions that can be called to retrieve information regarding the unit test configuration for the 
database or for a particular schema. Table 17-3 contains a listing of the options that utConfig makes 

available for obtaining information. 
```text
Table 17-3. utConfig Informational Options 
Option Name Description 
utConfig.autocompiling Returns autocompile flag value 
utConfig.dateformat Returns date format used to construct output file names 
utConfig.delimiter Returns V2 delimiter 
utConfig.dir Returns directory containing the test package code 
utConfig.filedir Returns file output directory 
utConfig.fileextension Returns output file name extension 
utConfig.fileinfo Returns all file output—related items 
utConfig.getreporter Obtains name of the default Output Reporter to use 
utConfig.includeprogname Returns whether to include the name of the program being tested 
within file names 
utConfig.prefix Returns default unit test prefix for your code 
utConfig.registering Returns registration mode 
utConfig.showconfig Displays a schema configuration 
utConfig.showingfailuresonly Returns whether successful test results are displayed 
utConfig.tester Returns the schema whose configuration is used 
utConfig.userprefix Returns the user prefix for output files 
```
The functions can be called just as if they were standard functions within your schema. Some, such 
as the utConfig.showconfig procedure, require you to set serveroutput on in order to display the output. 
The following excerpt from a SQL*Plus session shows a call to utConfig.showconfig. 
```sql
SQL> set serveroutput on 
SQL> exec utconfig.showconfig 
============================================================= 
utPLSQL Configuration for USERNAME 
Directory: 
Autcompile? 
Manual test registration? 
Prefix = 
Default reporter     = 
----- File Output settings: 
Output directory: 
User prefix     = 
Include progname? 
Date format     = 
File extension  = 
----- End File Output settings 
============================================================= 
 
PL/SQL procedure successfully completed. 
``` 
The utConfig package contains a variety of configurable options that will allow you to adjust unit 
testing according to your specific needs. Out of the box, the utPLSQL testing framework contains default 
values for each of these options, so you may never need to touch utConfig, but the option is available if 
you need it. Another nice feature is that you can set configurable options for a specific schema. Doing so 
will allow different schemas in the database to act differently when performing unit testing.  

## 17-9. Redirecting utPLSQL Test Results to a File 
**Problem** 
You are interested in writing the results of a unit test to a file. 
**Solution** 
Change the setting of the setreporter option of utPLSQL so that output is redirected to a file instead of 
DBMS_OUTPUT. Once the configuration has been altered, execute the unit tests for which you would like to 
have the output captured to the file. After you’ve run your tests, close the file and change the 
configuration back to its default. In the following lines of code, all of the steps that are necessary for 
redirecting test results to a file are exhibited. For example, suppose that the database has a directory that 
has already been enabled for use with the database named FILE_SYSTEM. 
```
SQL>  BEGIN 
  utconfig.setfiledir('FILE_SYSTEM'); 
  -- Causes output to be redirected to file system 
  utconfig.setreporter('File'); 
  utPLSQL.test('calc_quarter_hour'); 
  -- Closes the fle 
  utfilereporter.close(); 
  -- Returns output redirection to DBMS_OUTPUT 
  utconfig.setreporter('Output'); 
END; 
 
PL/SQL procedure successfully completed. 
```
When the code block in this example is executed, a file will be created within the directory 
represented by FILE_SYSTEM. The unit test for CALC_QUARTER_HOUR will then be executed and the results 
will be redirected to the newly created file. Lastly, the file will be closed and the output will be redirected 
back to DBMS_OUTPUT. 
**How It Works** 
One of the configurable options of utPLSQL allows for the output of your unit tests to be redirected. The 
choices for displaying unit test results include Output, File, and HTML. The standard Output option is 
Output , which causes output to be displayed within the SQL*Plus environment using DBMS_OUTPUT. The 
File option allows for a file to be created and unit test results to be written to that file. Lastly, the HTML 
option allows for unit test results to be formatted into file in the format of an HTML table. In the Solution
to this recipe, the use of the File output reporter is demonstrated. 
Prior to redirecting unit test output to a file, you must create a database directory using the CREATE 
DIRECTORY statement with a privileged account. For more information about creating directories, please 
see the Oracle documentation that can be found at: 
http://download.oracle.com/docs/cd/E11882_01/server.112/e17118/statements_5007.htm#SQLRF01207. 
Once you have created a database directory, you can use it to write the results of unit tests by setting the 
file directory using the utConfig.setfiledir() procedure. This procedure accepts the name of the 
database directory as a parameter. In the Solution to this recipe, the directory is named FILE_SYSTEM. To 
redirect the unit test output from utPLSQL, you must use the utConfig.setreporter() procedure. This 
procedure accepts the name of the reporter that you would like to use for displaying output. As you can 
see from the Solution to this recipe, the File reporter is chosen to redirect the output to a file on the file 
system. It is also possible to create a custom reporter configuration that you can pass to the 
utConfig.setreporter() procedure. For more information about creating customized reporters, please 
see the utPLSQL documentation that can be found at: 
http://utplsql.sourceforge.net/Doc/reporter.html. 
After the output has been redirected using utConfig.setreporter(), you can run as many tests as 
you wish and all of the output will be directed to a file instead of to the SQL*Plus command prompt. In 
the Solution to this recipe, the CALC_QUARTER_HOUR function is tested. Once you have finished running 
your tests, you must close the output file in order to make it available for you to use. If you fail to close 
the file, you will be unable to open it or use it because the database will maintain a lock on the file. To 
close the file, use issue utfilereporter.close(). Lastly, I recommend redirecting unit test output to the 
default Ouput option, which will cause it to be sent to DBMS_OUTPUT. By doing so, the next person who runs 
a unit test will receive the functionality that he or she expects by default, as the output will be directed to 
the screen. It is a good idea to set the default output at the beginning of all test suites just to ensure that 
you know where the output will be directed. However, if you are the only person running unit tests, or if 
you prefer to maintain the File reporter as your default, then omit the final call to 
utConfig.setreporter() that is shown in this Solution. 
Many times it can be useful to have unit test results redirected to an output file rather than 
displayed within the SQL*Plus environment. For instance, if you are running unit tests during off hours 
and would like to see the output, then it would be helpful to have it recorded to a file that can be viewed 
at a later time. Similarly, if you are running several unit tests, it may be easier to read through a file rather 
than scrolling through SQL*Plus output. Whatever the requirement may be, utPLSQL makes it easy to 
redirect unit test output to a file or another device by creating a custom reporter. 

## 17-10. Automating Unit Tests for PL/SQL and Java Stored Procedures Using Ant 
**Problem** 
You wish to automatically run your unit tests for PL/SQL code and Java stored procedures each day and 
to write the results of the unit test to a file. 
CHAPTER 17  UNIT TESTING WITH UTPLSQL 
386 
**Solution** 
Use Apache’s Ant build system to perform unit testing on your PL/SQL code. At the same time, Ant can 
build and compile any Java code that you will be using for your stored procedures. To do so, develop an 
Ant build script that will execute some SQL statements, automate your unit tests, and compile Java 
source into a directory. For example, the following build.xml file is an example of such a build that can 
be used to compile Java sources and execute unit tests on PL/SQL within a single Ant run. 
```html
<project name="MyPLSQLProject" default="unitTest" basedir="."> 
    <description> 
        PLSQL Unit Test and Application Builder 
    </description> 
  <!-- set global properties for this build --> 
  <property name="src" location="src"/> 
  <property name="build" location="build" value=”build”/> 
  <property name="user" value="myuser"/> 
  <property name="db_password" value="mypassword"/> 
  <property name="database.jdbc.url" value="jdbc:oracle:thin:@hostname:1521:database"/> 
 
  <target name="init"> 
    <!-- Create the time stamp --> 
    <tstamp/> 
    <mkdir dir="${build}"/> 
  </target> 
 
  <target name="compile" depends="init" 
        description="compile the source " > 
    <!-- Compile the java code from ${src} into ${build} --> 
    <!-- This is where you place the code for your java stored procedures --> 
    <javac srcdir="${src}" destdir="${build}"/> 
  </target> 
 
  <target name="unitTest" depends="compile" 
        description="Execute PLSQL Unit Tests" > 
    <sql 
     driver = "oracle.jdbc.driver.OracleDriver" 
     url = "${database.jdbc.url}" 
     userid = "${user}" 
     password = "${db_password}" 
     print="true" 
    > 
      call utconfig.setfiledir('FILE_SYSTEM'); 
      call utconfig.setreporter('File'); 
      call utPLSQL.test('calc_quarter_hour'); 
      -- Closes the fle 
      call utfilereporter.close(); 
      -- Returns output redirection to DBMS_OUTPUT 
      call utconfig.setreporter('Output'); 
 
    </sql> 
    
  </target> 
</project> 
```
This build script can be executed by issuing the ant command from within the terminal or 
command prompt. The results will resemble the following output. 
```java
juneau$ ant 
Buildfile: /Users/juneau/Documents/PLSQL_Recipes/sources/17/build.xml 
 
init: 
 
compile: 
    [javac] /Users/juneau/Documents/PLSQL_Recipes/sources/17/build.xml:22: warning: 
'includeantruntime' was not set, defaulting to build.sysclasspath=last; set to false for 
repeatable builds 
 
unitTest: 
      [sql] Executing commands 
      [sql] 0 rows affected 
      [sql] 0 rows affected 
      [sql] 0 rows affected 
      [sql] 0 rows affected 
      [sql] 0 rows affected 
      [sql] 5 of 5 SQL statements executed successfully 
 
BUILD SUCCESSFUL 
Total time: 4 seconds 
```
**How It Works** 
Automating unit tests can be very helpful, especially if you are working on a project where there may be 
more than one developer contributing code. The Apache Ant build system is useful for automating 
builds and unit tests for Java projects. However, it can also be used to perform a myriad of other tasks, 
including issuing SQL statements, as seen in the Solution to this recipe. Ant provides an entire build and 
unit test Solution that is easy to use. To set up a build, all you need to do is install Ant on your machine 
and then create a build.xml file that consists of targets that Ant will use to build the project. Once you 
have created a build file, then simply open a command prompt or terminal and traverse into the 
directory containing your build file. Once in the directory, issue the ant command and it will 
automatically look for a file named build.xml that will provide Ant the sequence used for the build.  
Ant uses simple logic to determine the order of sequence that will be used to execute the targets that 
are listed within the build.xml file. In the Solution to this recipe, the build file contains three targets, 
init, compile, and unitTest. Ant will start the build by executing the target listed within the <--project--> 
tag as the default. In this case, the default target is unitTest.  
 
`<project name="MyPLSQLProject" default="unitTest" basedir="."> `
 
The unitTest target contains a depends attribute, which lists the compile target. This tells Ant that 
the compile target should be executed first because unitTest depends upon its outcome.  
```html
<target name="unitTest" depends="compile" 
        description="Execute PLSQL Unit Tests" > 
```
Consequently, the compile target depends upon the init target, so init will be executed before 
compile.  
```html
<target name="compile" depends="init" 
        description="compile the source " > 
```
The order of target execution for the **Solution** to this recipe will be the init target first, followed by 
the compile target, and lastly the unitTest target. The project tag also contains an attribute named 
basedir. This attribute tells Ant where the build files should be located. In the **Solution** to this recipe, 
basedir contains a period “.” that tells Ant to use the current directory. 
At the top of the build file, you can see that there is a <description> tag. This is used to provide a 
brief description of the tasks completed by the build file. There are also several <property> tags. These 
tags are used to define the variables that will be used within the build file. Each <property> tag contains a 
name attribute and either a value or location attribute.  
```html
  <property name="src" location="src"/> 
  <property name="build" location="build" value=”build”/> 
  <property name="user" value="myuser"/> 
  <property name="db_password" value="mypassword"/> 
  <property name="database.jdbc.url" value="jdbc:oracle:thin:@hostname:1521:database"/> 
```
The properties that use a value attribute are used to assign values to the property name, whereas the 
properties that contain location attributes are used to assign a location to the property name. Properties 
can be referenced within the build file by using the following syntax: “${property_name}”. As you can see 
from the Solution to this recipe, each target within the build file consists of a number of tasks in the form 
of XML tags. The init target creates a timestamp by using the <--tstamp/> tag, and it creates a directory 
using the <--mkdir/> tag and passing the name of a directory to be created. In this case, the directory name 
will be named the same as the value that is assigned to the <--property> tag that is named build.  
```html
<target name="init"> 
    <!-- Create the time stamp --> 
    <tstamp/> 
    <mkdir dir="${build}"/> 
  </target> 
```
The compile target is used to compile all of the Java sources contained in the project. All of the 
sources should reside within a named directory that is located in the base directory of the Ant project. 
The compile target contains a single task using the <--javac> tag. This tag contains a src attribute that 
defines the location of the sources to be compiled, and a destdir attribute that tells Ant where to place 
the resulting Java class files. An Ant project that builds a Java project may contain only this task, but can 
build several hundred Java class files. In the Solution to this recipe, and for most Ant uses with PL/SQL 
projects, however, the project will probably contain no Java source files or only a few at most. If a project 
contains no Java source files, then the target will be executed, but the <--javac> task will do nothing since 
there are not any sources to be compiled. 
```html
<target name="compile" depends="init" 
        description="compile the source " > 
    <!-- Compile the java code from ${src} into ${build} --> 
    <!-- This is where you place the code for your java stored procedures --> 
    <javac srcdir="${src}" destdir="${build}"/> 
  </target> 
```
The most important target in the **Solution** to this recipe is the unitTest target. It consists of a single 
task using the <sql> tag. The sole purpose of the <sql> task is to execute SQL within a designated 
database. The <sql> tag contains a driver attribute that is used to list the JDBC driver for the target 
database, a url attribute used to define the JDBC URL for the target database, a userid and password 
attribute for defining the database username and password, and a print attribute that tells Ant whether 
to print the result sets from the SQL statements. In the **Solution** to this recipe, the SQL that is required to 
execute the unit tests is contained within the <sql> opening and closing tags. This causes the unit tests to 
be executed as if you were issuing these statements at the SQL*Plus command prompt. 
```html
<target name="unitTest" depends="compile" 
        description="Execute PLSQL Unit Tests" > 
    <sql 
     driver = "oracle.jdbc.driver.OracleDriver" 
     url = "${database.jdbc.url}" 
     userid = "${user}" 
     password = "${db_password}" 
     print="true" > 

      call utconfig.setfiledir('FILE_SYSTEM'); 
      call utconfig.setreporter('File'); 
      call utPLSQL.test('calc_quarter_hour'); 
      -- Closes the fle 
      call utfilereporter.close(); 
      -- Returns output redirection to DBMS_OUTPUT 
      call utconfig.setreporter('Output'); 
    </sql> 
    
  </target>
```
To automate your Ant build, you will need to set up an operating system task that starts the Ant
build. The task is very simple and needs to contain only very few lines. The following lines of code
contain batch script for the Windows operating system that can be used to invoke the Ant build. This
assumes that the java.exe executable is contained within the PATH environment variable. 
cd C:/path_to_project_directory
ant 
You will also need to ensure that the JDBC driver for the Oracle database is contained within your
CLASSPATH. If you do not include the JDBC driver in the CLASSPATH, then you will receive an error when
you try to execute the build. When the Ant build is executed, a file will be placed onto the database server
in the location designated by the FILE_SYSTEM database directory. The file will contain the results of the
unit test execution. 
Ant is a complex build system that can be used for configuration and preparation of your builds and unit
tests. It is a widely used build system, especially for organizations that do lots of Java development. As
you can see, it is easy to use, but does contain complexity in that there are a number of different tasks
and attributes that can be used. This recipe does not even scratch the surface of everything that Ant can
do. However, there are lots of sources for documentation on Ant that can be found online as well as in
book format. To learn more about Ant, you can start by reading the online documentation that can be
found at: http://ant.apache.org/manual/. 