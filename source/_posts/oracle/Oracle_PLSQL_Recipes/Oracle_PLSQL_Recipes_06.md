---
title: Oracle PLSQL Recipes 06-Type Conversion
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

 

# 6.Type Conversion 
Type conversion takes place in almost every PL/SQL program. It is important to know how to convert 
from one datatype to another so that your applications can contain more versatility. Not only are 
datatype conversions important to developers, but they can also be a godsend to database 
administrators. Type conversion can occur when moving data around from one table to another. It is 
also very common when obtaining data from input forms and performing calculations upon it. 
Whatever your use may be, this chapter will get you headed into the right direction with a handful of 
useful recipes. If your application works with dates or numbers, you will most likely find this chapter 
useful. There are two forms of datatype conversion: explicit conversion and implicit conversion. Explicit 
datatype conversion is what you will learn about in the following recipes. Using explicit conversion, you 
tell Oracle how you want types to be converted. Implicit conversion is automatically performed by 
Oracle. There are many datatypes that can be converted using implicit type conversion. However, it is 
not recommended that you rely on implicit conversion, because you never know exactly how Oracle will 
convert something. The recipes in this chapter will show you more reliable explicit conversion 
techniques that will give you the ability to convert types in such a way that your application will be rock 
solid. 

## 6-1. Converting a String to a Number 
**Problem** 
You need to convert some strings into numbers. For instance, your application contains several strings 
that are entered via a user input screen. These strings need to be converted into numbers so that they 
can be used to perform calculations. 
**Solution** 
Use the TO_NUMBER function to explicitly convert the VARCHAR2 field into a NUMBER. The following examples 
demonstrate the use of TO_NUMBER by showing how to convert some currency values taken from the user 
interface into numbers for storage in the database. 
The first example demonstrates the conversion of a variable with a datatype of VARCHAR2 into a 
NUMBER: 
```sql
DECLARE 
  in_dollars              VARCHAR2(10) := &dollars; 
  dollars_formatted  NUMBER; 
BEGIN 
  -- Assume that IN_DOLLARS is the user input in VARCHAR2 format 
  dollars_formatted := TO_NUMBER(in_dollars, '9G999D99'); 
  DBMS_OUTPUT.PUT_LINE(dollars_formatted); 
END; 
```
The TO_NUMBER function returns a number from a VARCHAR2 format. The previous example
demonstrates the typical usage of this function. 

****How It Works****
The TO_NUMBER function provides an explicit way to convert strings into NUMBER format in PL/SQL.
Although most string to NUMBER conversion is implicit via Oracle Database, it is always a best practice to
explicitly use the TO_NUMBER function to ensure that your code will not break at some point in the future.
The format for using the function is as follows: 
`TO_NUMBER(expression [, format [, 'nls' ] ])`
The expression can be a value of type `BINARY_DOUBLE`, `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. The
optional format is a mask that can be used to help format the expression value into a number. The mask
is a string of characters that represents the format of the string value that is contained in the expression
value. Table 6-1 shows the most commonly used format mask characters: 
Table 6-1. Common Formatting Mask Characters
|Character|Description|
|---|---|
|9|Represents a numeric character |
|D|Represents a decimal point |
|G|Represents a comma |

Although the use of a formatting mask is optional, it is a good idea to include it if you know the
format of the string. Doing so will help Oracle convert your value into a number more accurately(美[ˈækjərətli],adv.精确地,准确地). Lastly,
you can use the optional `nls` settings to set the `NLS_LANGUAGE` that is to be used to convert the string, the
NLS_CURRENCY, or any of the other NLS session parameters. Use of the nls parameter is not very common.  
■ Note For a complete listing of available session NLS parameters, issue the following query: 
```golang
SELECT * FROM NLS_SESSION_PARAMETERS.
```
It is also possible to convert strings into numbers using the `CAST` function. However, **for direct string
to number conversion, the TO_NUMBER function is the best tool for the job since it is straightforward and
easy to maintain**. For more information on the CAST function, please take a look at Recipe 6-5. 

## 6-2. Converting a String to a Date

****Problem****
You need to convert some strings into DATE types. Let’s say you have a requirement to insert date types 
into a database table column from one of your applications. The user is allowed to enter a date using 
your application’s web page, but it is in a string format after the user submits the page. You need to 
convert this date from a string to a date type. 

****Solution**** 
Use the `TO_DATE` function to convert the string values into the DATE type. This will allow your application 
to accept the date string in any format and convert it to a DATE type for you. The next example shows how 
to use the TO_DATE function: 

```sql 
my_val      DATE := TO_DATE('06/12/2010','MM/DD/YYYY'); 
```

You can convert the string through assignment, as shown in the preceding example, or directly 
within a query, as shown in the next example: 
```sql 
SELECT TO_DATE('December 31, 2010', 'Month DD, YYYY') FROM DUAL; 
```
As you can see, it is possible to convert multiple string formats into DATE types. 

****How It Works****
The `TO_DATE` function is arguably the most widely used conversion function in Oracle. Whether you are 
using the function to convert dates for proper formatting within a SQL query or you are accepting and 
converting user input, this function is extremely helpful for getting your data into the Oracle DATE 
format. The syntax for using this function is as follows: 

```sql
TO_DATE(expression[, format[,’nls’]]) 
```

The syntax is much like that of the other Oracle conversion functions in that it accepts a required 
expression or string and two optional parameters. The optional format is used to specify the format of 
the string and to assist Oracle in converting the value into a DATE type. Table 6-2 shows many of the more 
common characters that can be used to specify the date format. See the Oracle SQL Reference for a 
complete list of formatting characters. 
Table 6-2. Date Formatting Characters 
```text
Character Description 

MM        Represents the numeric month. 
MON       Represents an abbreviated month name. 
MONTH     Represents the entire month name. 
DD        Represents the numeric day of the month. 
DY        Abbreviation representing the day of the week. 
YY        Represents the two-digit year. 
YYYY      Represents the four-digit year. 
RR        Represents the rounded two-digit year. The year is rounded in the range 1950 to 2049 to assist with two-digit years such as 10. A two-digit year less than 50 will result in a four-digit year such as 2010. 
AM or PM  Represents the meridian indicator. 
HH        Represents the hour of the day in 12-hour time format. 
HH24      Represents the hour of the day in 24-hour time format. 
MI        Represents the minutes in time. 
SS        Represents the seconds in time. 
```
The standard, or default, date format in Oracle is `DD-MON-YY`, though your database administrator 
does have the ability to change that default format. If you want to convert a string that is in the default 
format into a DATE type, then the mask is not required. The following example demonstrates this 
capability: 
```sql
TO_DATE('27-MAY-10'); 
```

On the contrary, if you want to convert a string that is in a format that is different from the standard, 
then you must make use of a mask. The **Solution** to this recipe depicts this type of behavior. Dates are 
also in care of time in Oracle, so if you want to display the time in your date, then it is possible to do so 
using the proper format mask. The following conversion will include both the date and the time:

```sql 
TO_DATE('05/25/2010 07:35AM','MM/DD/YYYY HH:MIAM')
```

The TO_DATE conversion function is most often used when inserting or updating data. If you have a 
table column that has a DATE type, then you cannot place a string into that column unless it is in the 
standard date format. To get the data from an entry screen into the database, the TO_DATE function is 
usually used to convert the string into a date while the value is being inserted or updated. 
It is also possible to convert strings to dates using the CAST function. For more information on the 
use of the CAST function, please see Recipe 6-5.

## 6-3. Converting a Number to a String 

****Problem**** 
You need to alter some numbers into a currency format for display. Given a set of numbers, your 
application will perform a calculation and then convert the outcome into currency format, which will be 
a string type.

****Solution****

Use the TO_CHAR conversion function to obtain a nicely formatted currency string. The following code 
block accepts a number, performs a calculation, and then converts the number to a string:

```sql 
CREATE OR REPLACE FUNCTION CALCULATE_BILL(bill_amount IN NUMBER) 
 RETURN VARCHAR2 AS 
  tax                     NUMBER  := .12; 
  tip                     NUMBER  := .2; 
  total_bill              NUMBER  := 0; 
BEGIN 
  total_bill := bill_amount + (bill_amount * tax); 
  total_bill := total_bill + (total_bill * tip); 
  return to_char(total_bill, '$999.00'); 
END; 
```

When a bill amount is passed to the CALCULATE_BILL function, a nicely formatted dollar amount will 
be returned. If you were to pass 24.75 to the function, it would return $33.26. 
****How It Works****
The TO_CHAR function works much like the other Oracle TO_ conversion functions in that it accepts a 
number value along with an optional format mask and nls language value. Table 6-3 describes the more 
commonly used formatting mask characters for numbers. 
Table 6-3. Common Formatting Mask Characters 

```text
Character Description 
9 Represents a numeric character that displays only if a value is present 
. Represents a decimal point 
, Represents a comma 
$ Represents a dollar sign 
0 Represents a numeric character that will always display, even if null 
```

As you can see from the Solution to this recipe, the format mask of $999.00 is chosen. Why not use 
the mask of $999.99 for the conversion? By using the 0 instead of the 9, you ensure that the cents value 
will always be present. Even if the cents value is zero, you will still get a .00 at the end of your string. 
Essentially, the 0 character forces Oracle to pad with zeros rather than spaces. 
You can also pad with zero characters to the left of the decimal. Here’s an example: 

```sql 
select to_char(82,'0000099') from dual; 
```
That results in the following: 0000082
 
It is also possible to convert numbers to strings using the CAST function, although TO_CHAR makes for 
code that is easier to read and maintain. For more information on the use of the CAST function, please 
see recipe 6-5. 

## 6-4. Converting a Date to a String 

****Problem****
You want to convert a date into a nicely formatted string value. For example, you are converting a legacy 
application from another database vendor into a web-based Oracle application. A few of the fields on the 
web form are dates. The users of the application expect to see the dates in a specific format, so you need 
the dates to be formatted in a particular manner for display. 
****Solution**** 
Use the TO_CHAR function using the date masks. The TO_CHAR function offers many formatting options for 
returning a string from a DATE value. The following function accepts an EMPLOYEE_ID value and returns a 
representation of the HIRE_DATE spelled out. 
```sql
CREATE OR REPLACE PROCEDURE obtain_emp_hire_date(emp_id IN NUMBER) 
 AS 
 emp_hire_date    employees.hire_date%TYPE; 
 emp_first        employees.first_name%TYPE; 
 emp_last         employees.last_name%TYPE; 
BEGIN 
  SELECT hire_date, first_name, last_name 
  INTO emp_hire_date, emp_first, emp_last 
  FROM employees 
  WHERE employee_id = emp_id; 
 
  DBMS_OUTPUT.PUT_LINE(emp_first || ' ' || emp_last || ' was hired on: ' || TO_CHAR(emp_hire_date, 'DAY MONTH DDTH YYYY')); 
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('No employee found for the given ID'); 
END; 
``` 
If you pass the employee ID of 200 to this function, then it will return a result in the following 
format: Jennifer Whalen was hired on: THURSDAY   SEPTEMBER 17TH 1987 
 
PL/SQL procedure successfully completed. 

****How It Works****

As shown in the previous recipe, the TO_CHAR function accepts a NUMBER or DATE value and returns a nicely 
formatted string. Using the many formatting masks that are available, you can return a string-based 
representation in a number of ways. As demonstrated in the **Solution**s to this recipe and the previous 
one, the TO_CHAR function works a bit differently than the other conversion functions because the 
formatting mask is used to help produce the final string. Other conversion functions use the formatting 
mask to represent the format of the string you are passing in. In other words, TO_CHAR produces the 
formatted strings, whereas the other conversion functions accept them and produce a different 
datatype.

Table 6-4 lists some of the most commonly used characters for converting dates into strings. 
Table 6-4. Date Formatting Mask Characters 
```sql
Characters Description 
YYYY Represents the four-digit year 
YEAR Represents the spelled-out year 
YYY Represents the last three digits of the year 
YY Represents the last two digits of the year 
Y Represents the last digit of the year 
IYY Represents the last three digits of the ISO year 
IY Represents the last two digits of the ISO year 
I Represents the last digit of the ISO year 
Q Represents the quarter of the year 
MM Represents the month of the year 
MON Represents the abbreviated month name 
MONTH Represents the spelled-out month name padded with blanks 
RM Represents the Roman numeral month 
WW Represents the week of the year 
W Represents the week of the month 
IW Represents the ISO week of the year 
D Represents the day of the week 
DAY Represents the name of the day 
DD Represents the day of the month 
DDD Represents the day of the year 
DY Represents the abbreviated name of the day 
J Represents the Julian day 
HH Represents the hour of the day (1–12) 
HH12 Represents the hour of the day (1–12); same as HH 
HH24 Represents the hour of the day (0–23) 
MI Represents the minute of the hour (0–59) 
SS Represents the second (0–59) 
SSSSS Represents the seconds past midnight (0–86399) 
FF Represents the fractional seconds 
```

There are several formatting options, as you can see. It is best to spend some time with each of the 
different combinations to decide upon which one works best for your **Solution**.  
PL/SQL can make date formatting easy, because it is possible to create your own function that 
returns a date formatted per your application’s requirements. Sometimes it is difficult to remember all 
the different formatting options that are available for dates. It can also be quite painful to reference a 
table such as Table 6-4 each time you want to format a date string. You can instead create your own 
conversion function to support just the formats that you use, and no others. Such a function greatly 
reduces the possibility for error, thus enhancing consistency in how your application formats dates. 
The function in the following example accepts two parameters: the date to be converted and a string 
that specifies the output format. The second argument is limited to only four, easy-to-remember values: 
LONG, SHORT, STD, and DASH. 
 
-- Returns a date string formatted per the style 
-- that is passed into it.  The possible style strings 
-- are as follows: 
--   LONG => The spelled out date 
--   SHORT => The abbreviated date 
--   STD or blank => The standard date format mm/dd/yyyy 
--   DASH => The standard format with dashes mm-dd-yyyy 
```sql
CREATE OR REPLACE FUNCTION FORMAT_DATE(in_date IN DATE, 
                                       style IN VARCHAR2) 
 RETURN VARCHAR2 AS 
 formatted_date    VARCHAR2(100); 
BEGIN 
  CASE style 
    WHEN 'LONG' THEN  
        formatted_date := TO_CHAR(in_date, 'DAY MONTH DDTH YYYY'); 
    WHEN 'SHORT' THEN 
        formatted_date := TO_CHAR(in_date, 'DY MON DDTH YYYY'); 
    WHEN 'DASH' THEN 
        formatted_date := TO_CHAR(in_date, 'MM-DD-YYYY'); 
    ELSE 
        formatted_date := TO_CHAR(in_date, 'MM/DD/YYYY'); 
  END CASE; 
  RETURN formatted_date; 
END; 
```

This function is nice because you only need to remember a short string that is used to represent the 
date format that you’d like to return.  
It is also possible to convert dates to strings using the CAST function. For more information on the 
use of the CAST function, please see Recipe 6-5. 

## 6-5. Converting Strings to Timestamps 

****Problem**** 
You are working with a series of strings. You want to convert them into timestamps. 

****Solution****
Use the TO_TIMESTAMP function to convert the strings into timestamps. In this example, a trigger is 
created that will log an INSERT into the JOBS table. The logging table consists of two columns. The first 
column is used to store the date of the transaction, and it is of type TIMESTAMP WITH LOCAL TIME ZONE. 
The second column is used to contain a DESCRIPTION of type VARCHAR2. The trigger that performs the 
logging needs to combine a sysdate and a time zone value into a string prior to converting it into a 
TIMESTAMP. 
First, let’s create the table that will be used to log the changes on the JOBS table: 
```sql
CREATE TABLE time_log  
(job_time              TIMESTAMP WITH LOCAL TIME ZONE, 
 description           VARCHAR2(2000)); 
```
Next, a simple function is created that will return the time zone for a given city code. The function 
will return time zones for Chicago, Orlando, or San Jose because these are the different cities where our 
imaginary industry has offices. 
```sql
CREATE OR REPLACE FUNCTION find_tz (city IN VARCHAR2)  
RETURN NUMBER IS 
  tz          NUMBER := 0; 
BEGIN 
  IF city = 'CHI' THEN 
    tz := -5; 
  ELSIF city = 'ORD' THEN 
    tz := -4; 
  ELSIF city = 'SJ' THEN 
    tz := -7; 
  END IF; 
  RETURN tz; 
END; 
```
The last piece of code is the trigger that performs the INSERT on the logging table. This trigger 
performs a conversion of a string to a TIMESTAMP using the TO_TIMESTAMP_TZ function. 
```sql
CREATE OR REPLACE TRIGGER log_job_history 
AFTER INSERT ON jobs 
FOR EACH ROW 
DECLARE 
  my_ts  VARCHAR2(25) := to_char(sysdate, 'YYYY-MM-DD HH:MI:SS'); 
BEGIN 
  my_ts := my_ts || ' ' || find_tz('CHI'); 
   
  INSERT INTO time_log values( 
    TO_TIMESTAMP_TZ(my_ts, 'YYYY-MM-DD HH:MI:SS TZH:TZM'), 
    'INSERT' 
  ); 
 
END; 
```
In this example, the trigger is hard-coded to assume a Chicago entry, but in reality this information 
would have been obtained from the user’s session. However, since that code is out of scope for this 
recipe, the hard-coded city does the trick. 
****How It Works****
Similar to other Oracle conversion functions, the TO_TIMESTAMP_TZ and TO_TIMESTAMP functions accept 
two arguments. The first argument is a string value containing a date value in text form. The second 
argument is a format model that is used to coerce the given string value into the TIMESTAMP or TIMESTAMP 
WITH LOCAL TIME ZONE datatype. The TO_TIMESTAMP_TZ conversion will accept and convert a time zone 
along with the TIMESTAMP, whereas the TO_TIMESTAMP function will not account for a time zone. 
The format model is very similar to that of the TO_CHAR and TO_DATE functions. The format model will 
differ depending upon the format of the date that you want to convert. In the **Solution** to this recipe, the 
format included a standard Oracle date along with a time zone. For a complete listing of all possible 
format model characters, please refer to the Oracle SQL Reference manual. 

## 6-6. Writing ANSI-Compliant Conversions 
**Problem** 
You want to convert strings to dates using an ANSI-compliant methodology. 
**Solution** 
Use the CAST function, because it is ANSI-compliant. In this example, a procedure is written that will 
select each of the rows within the JOB_HISTORY table that fall within a specified date range. The dates will 
be converted into strings, and other information will be appended to the converted dates. This 
procedure will produce a simple report to display the JOB_HISTORY. 
```sql
CREATE OR REPLACE PROCEDURE job_history_rpt(in_start_date IN DATE, 
                                            in_end_date IN DATE) AS 
  CURSOR job_history_cur IS 
  SELECT CAST(hist.start_date AS VARCHAR2(12)) || ' - ' || 
         CAST(hist.end_date AS VARCHAR2(12)) || ': ' || 
         emp.first_name || ' ' || emp.last_name || ' - ' || 
         job_title || ' ' || department_name as details 
  FROM jobs jobs, 
       job_history hist, 
       employees emp, 
       departments dept 
  WHERE hist.start_date >= in_start_date 
  AND hist.end_date <= in_end_date 
  AND jobs.job_id = hist.job_id 
  AND emp.employee_id = hist.employee_id 
  AND dept.department_id = hist.department_id; 
 
 
  job_history_rec     job_history_cur%ROWTYPE; 
 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('JOB HISTORY REPORT FOR ' || 
    in_start_date || ' to ' || in_end_date);  
  FOR job_history_rec IN job_history_cur LOOP 
    DBMS_OUTPUT.PUT_LINE(job_history_rec.details); 
  END LOOP; 
END; 
```
Given the start date of September 1, 1989, the resulting output from this procedure will resemble the 
following: 
```sql
SQL> exec job_history_rpt(to_date('01-SEP-1989','DD-MON-YYYY'),sysdate); 
JOB HISTORY REPORT FOR 01-SEP-89 to 01-SEP-10 
13-JAN-93 - 24-JUL-98: Lex De Haan - Programmer IT 
21-SEP-89 - 27-OCT-93: Neena Kochhar - Public Accountant Accounting 
28-OCT-93 - 15-MAR-97: Neena Kochhar - Accounting Manager Accounting 
17-FEB-96 - 19-DEC-99: Michael Hartstein - Marketing Representative Marketing 
24-MAR-98 - 31-DEC-98: Jonathon Taylor - Sales Representative Sales
01-JAN-99 - 31-DEC-99: Jonathon Taylor - Sales Manager Sales
01-JUL-94 - 31-DEC-98: Jennifer Whalen - Public Accountant Executive 
PL/SQL procedure successfully completed.
```

****How It Works****
The CAST function can be used to easily convert datatypes. However, there is no real benefit to using CAST
as opposed to TO_NUMBER or TO_CHAR in most cases. The format for the CAST function is as follows: 
CAST(expression AS type_name) 
You can use this function to convert between different datatypes. Table 6-5 lists the different to and
from datatypes that the CAST function can handle. 

```text
Table 6-5. CAST Function Converstion Table 
CAST from Datatype To Datatype 
CHAR, VARCHAR2 CHAR, VARCHAR2
NUMBER
DATETIME/INTERVAL
RAW 
ROWID, UROWID 
NUMBER CHAR, VARCHAR2
NUMBER 
NCHAR, NVARCHAR2 
DATETIME/INTERVAL CHAR, VARCHAR2
DATETIME/INTERVAL
NCHAR, NVARCHAR2 
RAW CHAR, VARCHAR2
RAW 
NCHAR, NVARCHAR2 
ROWID, UROWID CHAR, VARCHAR2
ROWID, UROWID
NCHAR, NVARCHAR2 
NCHAR, NVARCHAR2 NCHAR, NVARCHAR2
```

The CAST function offers advantages to the TO_ conversion functions in some cases. For instance, if
you are attempting to write SQL that is 100 percent ANSI-compliant, then you should use the CAST
function because the Oracle conversion functions are not compliant. However, PL/SQL itself is not
ANSI-compliant, so the CAST function offers no advantages while writing PL/SQL code.  
The following are a few more examples of using the CAST function: 
```sql 
-- Convert date to VARCHAR2 
SELECT CAST('05-MAY-2010' AS VARCHAR2(15)) FROM DUAL; 
 
-- Convert string to NUMBER 
SELECT CAST('1024' AS NUMBER) FROM DUAL; 
 
-- Convert string to ROWID 
SELECT CAST('AAYyVSADsAAAAFLAAA' AS ROWID) FROM DUAL; 
```
If you prefer to have more control over your conversions, the Oracle TO_ conversion functions are 
the way to go. They allow you to provide a format mask to control the conversion formatting. 

## 6-7. Implicitly Converting Between PLS_INTEGER and NUMBER 

****Problem**** 
You want to convert a number to PLS_INTEGER datatype so that calculations can be performed. 

****Solution****
In this case, allow Oracle to do the footwork and implicitly convert between the two datatypes. In the 
following example, the function accepts a NUMBER, converts it to PLS_INTEGER, and performs a calculation 
returning the result. The function converts to PLS_INTEGER in order to gain a performance boost. 
```sql
CREATE OR REPLACE FUNCTION mass_energy_calc (mass IN NUMBER, 
                                             energy IN NUMBER) 
RETURN PLS_INTEGER IS 
  new_mass    PLS_INTEGER := mass; 
  new_energy  PLS_INTEGER := energy; 
BEGIN 
  RETURN ((new_mass * new_energy) * (new_mass * new_energy)); 
EXCEPTION 
  WHEN OTHERS THEN 
    RETURN -1; 
END; 
```

The function will accept NUMBER values, automatically convert them into PLS_INTEGER, and return a 
PLS_INTEGER type.
 
****How It Works**** 
Implicit conversion occurs when Oracle automatically converts from one datatype to another. Oracle 
will implicitly convert some datatypes but not others. As per the **Solution** to this recipe, one of the 
datatypes that supports implicit conversion is PLS_INTEGER. As a matter of fact, PLS_INTEGER cannot be 
converted using the TO_NUMBER function; so in this case, implicit is the best way to convert a PLS_INTEGER 
datatype to anything else. However, if there is a way to explicitly convert the datatype from one to 
another, then that is the recommended approach. You cannot be certain of the results when Oracle is 
automatically converting for you; explicit conversion allows you to have more control. 
The PLS_INTEGER datatype can be advantageous over using a NUMBER in some cases. For instance, a 
PLS_INTEGER has performance advantages when compared to a NUMBER for doing calculations because 
they use machine arithmetic as opposed to library arithmetic. Additionally, the PLS_INTEGER datatype 
requires less storage than its counterparts. In the **Solution** to this recipe, the function takes advantage of 
the faster calculation speed that is possible using PLS_INTEGER. 

