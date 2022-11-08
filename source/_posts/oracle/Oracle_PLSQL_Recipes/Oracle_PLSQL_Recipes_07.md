---
title: Oracle PLSQL Recipes 07-Numbers, Strings, and Dates
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


# 7. Numbers, Strings, and Dates 
Every PL/SQL program uses one or more datatypes. This chapter focuses on some details that you 
should know when working with data in the form of numbers, strings, and dates. Each recipe in this 
chapter provides a basic tip for working with these datatypes. From basic string concatenation to more 
advanced regular expression processing, you’ll learn some techniques for getting things done in an 
effective manner. You’ll learn about date calculations as well. When you’re done with this chapter, you’ll 
be ready to move on to the more advanced recipes later in the chapters to follow. 
## 7-1. Concatenating Strings

****Problem**** 
You have two or more text strings, or variables containing strings, that you want to combine. 

****Solution****
Use the concatenation operator to append the strings. In the following example, you can see that two 
variables are concatenated to a string of text to form a single string of text: 
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT employee_id, first_name, last_name 
  FROM EMPLOYEES 
  WHERE HIRE_DATE > TO_DATE('01/01/2000','MM/DD/YYYY'); 
   
  emp_rec       emp_cur%ROWTYPE; 
  emp_string    VARCHAR2(150); 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('EMPLOYEES HIRED AFTER 01/01/2000'); 
  DBMS_OUTPUT.PUT_LINE('================================'); 
  FOR emp_rec IN emp_cur LOOP 
        emp_string := emp_rec.first_name || ' ' || 
                      emp_rec.last_name || ' - ' || 
                      'ID #: ' || emp_rec.employee_id; 
 
        DBMS_OUTPUT.PUT_LINE(emp_string); 
  END LOOP; 
END; 
```
You can see that the example uses the concatenation operator || to formulate a string of text that 
contains each employee’s first name, last name, and employee ID number.  
****How It Works**** 
As you have seen in the **Solution** to this recipe, the concatenation operator is used for concatenating 
strings within your PL/SQL applications. When the concatenation operator is used to concatenate 
numbers with strings, the numbers are automatically converted into strings and then concatenated. 
Similarly, an automatic conversion occurs with dates before being concatenated. 
## 7-2. Adding Some Number of Days to a Date 

****Problem****
You want to add a number of days to a given date. For example, you are developing an application that 
calculates shipping dates for a company’s products. In this case, your application is processing 
shipments, and you need to calculate a date that is 14 days from the current date. 
****Solution****
Treat the number of days as an integer, and add that integer to your DATE value. The following lines of 
code show how this can be done: 
```sql
DECLARE 
  ship_date    DATE := SYSDATE + 14; 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('The shipping date for any products '|| 
                       'that are ordered today is ' || ship_date); 
END; 
 
The result that is displayed for this example will be 14 days past your current date.  
If you wanted to encapsulate this logic within a function, then it would be easy to do. The following 
function takes a date and a number as arguments. The function will perform simple mathematics and 
return the result. 
 
CREATE OR REPLACE FUNCTION calculate_days(date_to_change  IN DATE, 
                                          number_of_days  IN NUMBER) 
RETURN DATE IS 
BEGIN 
  RETURN date_to_change + number_of_days; 
END; 
```
Notice that the name of the function does not include the word add, such as ADD_DAYS. That was 
done on purpose because this function not only allows addition of days to a date, but if a negative 
number is passed in as an argument, then it will also subtract the number of days from the given date. 

****How It Works**** 
Since calculations such as these are the most common date calculations performed, Oracle makes them 
easy to do. If a number is added to or subtracted from a DATE value, Oracle Database will add or subtract 
that number of days from the date value. DATE types can have numbers added to them, and they can also 
have numbers subtracted from them. Multiplication and division do not work because it is not possible 
to perform such a calculation on a date. For example, it doesn’t mean anything to speak of multiplying a 
date by some value.  
If you are developing an application that always performs an addition or subtraction using the same 
number of days, it may be helpful to create a function such as the one demonstrated in the **Solution** to 
this recipe. For instance, if you were developing a billing application and always required a date that was 
30 days into the future of the current date, then you could create a function named BILLING_DATE and 
hard-code the 30 days into it. This is not necessary, but if your business or application depended upon it, 
then it may be a good idea to encapsulate logic to alleviate possible data entry errors. 

## 7-3. Adding a Number of Months to a Date 

****Problem**** 
You want to add some number of months to a date. For example, you are developing a payment 
application for a company, and it requires payments every six months. You need to enable the 
application to calculate the date six months in the future of the current date. 
■ Note This recipe’s **Solution** also works for subtracting months. Simply “add” a negative number of months.  

****Solution****
Use the ADD_MONTHS function to add six months onto the given date.  Doing so will enable your 
application to create bills for future payments.  This technique is demonstrated in the following 
example: 
```sql
DECLARE 
  new_date    DATE; 
BEGIN 
  new_date := ADD_MONTHS(sysdate,6); 
  DBMS_OUTPUT.PUT_LINE('The newly calculated date is: ' || new_date); 
END; 
```

This simple technique will enable you to add a number of months to any given date. As with any 
other logic, this could easily be encapsulated into a function for the specific purpose of producing a 
billing date that was six months into the future of the current date. Such a function may look something 
like the next example: 
```sql
CREATE OR REPLACE FUNCTION calc_billing_date IS 
BEGIN 
  RETURN ADD_MONTHS(sysdate, 6); 
END;
```

Although this function does not do much besides encapsulate logic, it is a good idea to code such 
functions when developing a larger application where this type of calculation may be performed several 
times. It will help to maintain consistency and alleviate maintenance issues if the date calculation ever 
needs to change. You could simply make the change within the function rather than visiting all the 
locations in the code that use the function. 

****How It Works**** 
Oracle provides the ADD_MONTHS function to assist with date calculations. This function has two 
purposes—to add or subtract a specified number of months from the given date. The syntax for use of 
the ADD_MONTHS function is as follows: 

```sql
ADD_MONTHS(date, integer) 
```

You can also use the function to subtract months from the given date. If the function is passed a 
negative integer in place of the month’s argument, then that number of months will be subtracted from 
the date. The following example demonstrates this functionality: 
```sql 
DECLARE 
  new_date    DATE; 
BEGIN 
  new_date := ADD_MONTHS(sysdate,-2); 
  DBMS_OUTPUT.PUT_LINE('The newly calculated date is: ' || new_date); 
END; 
```

As you can see from the example in Figure 7-3, the negative integer is the only change made to the 
code in order to achieve a subtraction of months rather than an addition. As a result, the example in this 
figure will return the current date minus two months. 
In the case that you are attempting to add months to a date that represents the last day of the 
month, the ADD_MONTHS function works a bit differently than you might expect. For instance, if it is August 
31 and you want to add one month, then you would expect the calculation to resolve to September 31, 
which is not possible. However, ADD_MONTHS is smart enough to return the last day of September in this 
case. The following code provides a demonstration: 
```sql 
DECLARE 
  new_date    DATE; 
BEGIN 
  new_date := ADD_MONTHS(to_date('08/31/2010','MM/DD/YYYY'),1); 
  DBMS_OUTPUT.PUT_LINE('The last day of next month is: ' || new_date); 
END; 
```

The following is the resulting output: 
 
The last day of next month is: 30-SEP-10 
 
PL/SQL procedure successfully completed. 
In general, if your source date is the late day of its month, then your result date will be forced to the 
last day of its respective month. Adding one month to September 30, for example, will yield October 31. 

## 7-4. Adding Years to a Date 

****Problem**** 
You are developing an application that requires date calculations to be performed. You need to 
determine how to add to a specified date. You may also want to subtract years.  

****Solution****
Create a function that will calculate a new date based upon the number of years that you have specified. 
If you want to subtract a number of years from a date, then pass a negative value for the number of years. 
The following code implements this functionality: 
```sql
CREATE OR REPLACE FUNCTION calculate_date_years (in_date DATE, 
                                    in_years NUMBER) 
RETURN DATE AS 
  new_date    DATE; 
BEGIN 
  IF in_date is NULL OR in_years is NULL THEN 
    RAISE NO_DATA_FOUND; 
  END IF; 
  new_date := ADD_MONTHS(in_date, 12 * in_years); 
  RETURN new_date; 
END; 
```
The example function expects to receive a date and a number of years to add or subtract as 
arguments. If one of those arguments is left out, then PL/SQL will raise an ORA-06553 error, and the 
example also raises a special NO_DATA_FOUND error if one or both of the arguments are NULL. The return 
value will be the input date but in the newly calculated year. 

****How It Works**** 
Oracle provides a couple of different ways to calculate dates based upon the addition or subtraction of 
years. One such technique is to use the ADD_MONTHS function that was discussed in Recipe 7-3, as the 
**Solution** to this recipe demonstrates. Simple mathematics allow you to multiply the number of years 
passed into the ADD_MONTHS function by 12 since there are 12 months in the year. Essentially this 
technique exploits the ADD_MONTHS function to return a date a specified number of dates into the future. 
■ Note See Recipe 7-3 for discussion of a corner case involving the use of ADD_MONTHS on a date that represents 
the final day of that date’s month.  
You can use this same technique to subtract a number of years from the specified date by passing a 
negative integer value that represents the number of years you want to subtract. For instance, if you 
wanted to subtract five years from the date 06/01/2000, then pass a -5 to the function that was created in 
the **Solution** to this recipe. The following query demonstrates this strategy. 
```sql 
select calculate_date_years(to_date('06/01/2000','MM/DD/YYYY'),-5) from dual; 
```
Here’s the result: 
```text
06/01/1995 
```
Using the ADD_MONTHS function works well for adding or subtracting a rounded number of years. 
However, if you wanted to add one year and six months, then it would take another line of code to add 
the number of months to the calculated date. The function in the next example is a modified version of 
the CALCULATE_DATE_YEARS function that allows you to specify a number of months to add or subtract as 
well: 
```sql
CREATE OR REPLACE FUNCTION calculate_date_years (in_date DATE, 
                                              in_years IN NUMBER, 
                                              in_months IN NUMBER DEFAULT 0) 
RETURN DATE AS 
  new_date    DATE; 
BEGIN 
  IF in_date is NULL OR in_years is NULL THEN 
    RAISE NO_DATA_FOUND; 
  END IF; 
  new_date := ADD_MONTHS(in_date, 12 * in_years); 
  -- Additional code to add the number of months to the calculated date 
  IF in_months != 0 THEN 
    new_date := ADD_MONTHS(new_date, in_months); 
  END IF; 
  RETURN new_date; 
END; 
```

Using the new function, you can pass positive integer values for the number of years and the 
number of months to add years or months to the date, or you can pass negative values for each to 
subtract years or months from the date. You can also use a combination of positive and negative integers 
for each to obtain the desired date. Since the modified function contains a DEFAULT value of 0 for the 
number of months, it is possible to not specify a number of months, and you will achieve the same result 
as the function in the **Solution** to the recipe. 
As you can see, this function is a bit easier to follow, but it does not allow for one to enter a negative 
value to subtract from the date. All the techniques described within this section have their own merit. 
However, it is always a good rule of thumb to write software so that it is easy to maintain in the future. 
Using this rule of thumb, the most favored technique of the three would be to use the ADD_MONTHS 
function as demonstrated in the **Solution**. Not only is this function easy to understand but also widely 
used by others within the Oracle community. 

## 7-5. Determining the Interval Between Two Dates 

****Problem**** 
You want to determine the number of days between two dates. For example, working on an application 
to calculate credit card late fees, you are required to determine the number of days between any two 
given dates. The difference in days between the two dates will produce the number of days that the 
payment is overdue. 

****Solution**** 
Subtract the two dates using simple math to find the interval in days. In this **Solution**, the example code 
subtracts the current date from the due date to obtain the number of days that the payment is past due: 
```sql
CREATE OR REPLACE FUNCTION find_interval(from_date IN DATE, 
                                         to_date IN DATE) 
RETURN NUMBER AS 
BEGIN 
  RETURN abs(trunc(to_date) – trunc(from_date)); 
END; 
```
This function will return the difference between the two dates passed as arguments. Note that the 
number of days will be a decimal value. Although it is just as easy to subtract one date from another 
without the use of a helper function, sometimes it is useful to encapsulate the logic. This is especially 
true if the same calculation will be performed multiple times throughout the application. 

****How It Works****
Oracle includes the ability to subtract dates in order to find the difference between the two. You can use 
this functionality within PL/SQL code or SQL queries. The result of the calculation is the number of 
fractional days between the two dates. That number can be rounded in order to find the number of days, 
or it can be formatted to determine the number of days, hours, minutes, and seconds. 
As it stands, the result from the subtraction of two will return the number of days between the given 
dates. If you were interested in returning the number of hours, minutes, or seconds between the two 
dates, then you could do so by applying some simple mathematics to the result of the subtraction. For 
instance, to find an interval in minutes, multiply the result by 24 * 60. The following functions show how 
this technique can be used to create separate functions for returning each time interval: 
```sql
CREATE OR REPLACE FUNCTION find_interval_hours(from_date IN DATE, 
                     to_date IN DATE) 
RETURN NUMBER AS 
BEGIN 
 RETURN abs(trunc(from_date) - trunc(to_date) )* 24; 
END; 
 
 
CREATE OR REPLACE FUNCTION find_interval_minutes(from_date IN DATE, 
                                         to_date IN DATE) 
RETURN NUMBER AS 
BEGIN 
  RETURN (from_date - to_date) * 24 * 60; 
END; 
 
 
CREATE OR REPLACE FUNCTION find_interval_seconds(from_date IN DATE, 
                                         to_date IN DATE) 
RETURN NUMBER AS 
BEGIN 
  RETURN (from_date - to_date) * 24 * 60 * 60; 
END;
```
Each of these functions will return a decimal number that can be rounded. Now you can mix and
match these functions as needed to return the desired time interval between two dates. 

## 7-6. Adding Hours, Minutes, Seconds, or Days to a Given Date 
****Problem**** 
One of your applications requires that you have the ability to add any number of days, hours, minutes, or
seconds to a given date and time to produce a new date and time. 
****Solution****
Create functions that add each of these time values to TIMESTAMP dataypes that are passed as an
argument. Each of these functions will return the given time plus the amount of time that is passed in as
argument. The following three functions will provide the ability to add hours, minutes, seconds, or days
to a given time. Each of these functions returns the calculated date and time using the TIMESTAMP
datatype.
```sql
CREATE OR REPLACE FUNCTION calc_hours(time_to_change IN TIMESTAMP, 
                     timeval IN NUMBER)
RETURN TIMESTAMP AS 
  new_time    TIMESTAMP;
BEGIN 
  new_time := time_to_change + NUMTODSINTERVAL(timeval,'HOUR'); 
  RETURN new_time;
END; 
CREATE OR REPLACE FUNCTION calc_minutes(time_to_change IN TIMESTAMP, 
                     timeval IN NUMBER)
RETURN TIMESTAMP AS 
  new_time    TIMESTAMP;
BEGIN 
  
  new_time := time_to_change + NUMTODSINTERVAL(timeval,'MINUTE'); 
  RETURN new_time;
END; 
CREATE OR REPLACE FUNCTION calc_seconds(time_to_change IN TIMESTAMP, 
                     timeval IN NUMBER)
RETURN TIMESTAMP AS 
  new_time    TIMESTAMP;
BEGIN 
  
  new_time := time_to_change + NUMTODSINTERVAL(timeval,'SECOND'); 
  RETURN new_time;
END; 

CREATE OR REPLACE FUNCTION calc_days(time_to_change IN TIMESTAMP, 
                     timeval IN NUMBER) 
RETURN TIMESTAMP as 
  new_time  TIMESTAMP; 
BEGIN 
  new_time := time_to_change + timeval; 
  RETURN new_time; 
END; 
``` 
All of these functions operate in a similar fashion. You must input a date in the form of a TIMESTAMP, 
and the calculated TIMESTAMP will be returned.  
****How It Works****
When performing the calculation of times and dates in Oracle, you have plenty of options. Over the 
years, Oracle Database has introduced newer functions to help alleviate some of the difficulties that 
were encountered when attempting date and time calculations in earlier versions of the database. Date 
and time calculations can be as simple as adding an integer to the DATE or TIMESTAMP. They can also be 
difficult when many multiplications and divisions occur within the same calculation. The **Solution** to this 
recipe provides you with an easy way to add time to a given date using the NUMTODSINTERVAL function. 
The syntax for this function is as follows: 
```sql
NUMTODSINTERVAL(number, expression) 
```
The expression that is passed to the function must be one of the following: HOUR, MINUTE, SECOND, or 
DAY. Technically, the functions created in the **Solution** are capable of subtracting the time or day values 
from the given date as well. If you were to pass a negative number to the functions, then the 
NUMTODSINTERVAL would subtract that many units from the given date and time and return the result. The 
functions in the **Solution** also do not lock you into using a TIMESTAMP; if you were to pass a DATE type in as 
an argument, then it would work just as well. 
In the past, you used to only have the ability to use fractions to add or subtract hours, minutes, and 
seconds to a date. Over the next few examples, I will show you the sort of fractional mathematics that 
you may see in legacy code. You can add a fraction to a date or TIMESTAMP as both will return a result. To 
add hours to a date, use the fraction x/24, where x is the number of hours (1–24) you want to add. You 
can subtract hours by using a negative value for x. This works because there are of course 24 hours in 
one day. The following example shows how you may see some legacy code using fractions to add hours. 
```sql
-- Add 1 hour to the current date 
result := SYSDATE + 1/24; 
 
-- Add 5 hours to the current date 
result := CURRENT_TIMESTAMP + 5/24; 
```
It is possible to add minutes to a date using a similar technique with fractions. To add minutes, use 
the fraction x/24/60, where x is the number of minutes (1–60) that you would like to add. Again, use a 
negative value in place of x in order to subtract that number of minutes from a date. This fraction works 
because it divides the number assigned to x by the hours in the day and then divides that result by the 
number of minutes in an hour. The next figure shows an example of this technique. 
```sql
-- Add 10 mintes to the current date 
result := SYSDATE + 10/24/60; 
-- Add 30 minutes to the current date 
result := CURRENT_TIMESTAMP + 30/24/60; 
``` 
Similarly, you can add seconds to a date by using the fraction x/24/3600. In this fraction, x is the 
number of seconds (1–60) that you want to add. Subtraction of seconds is possible by using a negative 
number for the x value. Just as with the other fractional calculations, this works because there are 3,600 
seconds in one hour. Therefore, the number assigned to x is divided by the number of hours in the day, 
and then that result is divided by the number of seconds in one hour. The next figure demonstrates 
adding seconds to the date using this technique: 
```sql
-- Add 10 seconds to the current date 
result := SYSDATE + 10/24/3600; 
 
-- Add 45 seconds to the current date 
result := CURRENT_TIMESTAMP + 45/24/3600; 
 
Using the fractional mathematics, you can add each of the different fractions to the given date and 
achieve the same result. It is not uncommon for legacy code using fractional mathematics for date 
calculation to look like the following: 
 
-- Add 2 hours, 5 minutes, and 30 seconds to the current date 
result := SYSDATE + 2/24 + 5/24/60 + 30/24/3600; 
```
There are a number of ways to add time intervals to a given date. I recommend using 
NUMTODSINTERVAL for performing mathematics on time values. In the past, this function was not available, 
so using fractional mathematics was the only way to add or subtract time from a given date. As shown in 
the **Solution** to this recipe, it is possible to encapsulate the logic inside of a PL/SQL function. If this is 
done, then you could change the implementation inside the function and someone using it would never 
know the difference. Date and time calculations can be made even easier to use by writing functions to 
encapsulate the logic. 

## 7-7. Returning the First Day of a Given Month 
****Problem**** 
You want to have the ability to obtain the name of the first day for a given month. 

****Solution****
Write a PL/SQL function that accepts a date and applies the necessary functions to return the first day of 
month for the given date. 
```sql
CREATE OR REPLACE FUNCTION first_day_of_month(in_date DATE) 
RETURN VARCHAR2 IS 
BEGIN 
  RETURN to_char(trunc(in_date,'MM'), 'DD-MON-YYYY'); 
END; 
```
The function created in this **Solution** will return the first day of the month that is passed into it 
because it is passed into the TRUNC function. 

****How It Works**** 
The TRUNC function can be useful for returning information from a DATE type. In this case, it is used to 
return the first day of the month from the given date. The **Solution** then converts the truncated date 
value to a character format and returns the result. 
The TRUNC function accepts two arguments, the first being the date that is to be truncated and the 
second being the format model. The format model is a series of characters that specifies how you want 
to truncate the given date. Table 7-1 lists the format models along with a description of each. 
Table 7-1. Format Models for TRUNC 
```text
Format              Model Description 
MI                              Returns the nearest minute 
HH, HH12, HH24                  Returns the nearest hour 
D, DY, DAY                      Returns the first day of the week 
W                               Returns the same day of the week as the first day of the month 
IW                              Returns the same day of the week as the first day of ISO year 
WW                              Returns the same day of the week as the first day of the year 
RM, MM, MON, MONTH              Returns to the nearest first day of the month 
Q                               Returns to the nearest quarter 
I, IY, IYYY                     Returns the ISO year 
Y, YY, YYY, SYEAR, YEAR, YYYY   Rounds to the nearest first day of the year 
CC, SCC                         Returns one greater than the first two digits of a given four-digit year
```
The **Solution** to this recipe returns the first day of the given month using the format model MM. 
## 7-8. Returning the Last Day of a Given Month 

****Problem**** 
You want to have the ability to obtain the last day for a given month. 

****Solution**** 
Use the Oracle built-in LAST_DAY function to return the last day of the month for the date that you pass 
into it. The following example demonstrates a code block in which the LAST_DAY function is used to 
return the last day of the current month: 
```sql
DECLARE 
  last_day  VARCHAR2(20); 
BEGIN 
  select LAST_DAY(sysdate) 
  INTO last_day 
  FROM DUAL; 
  DBMS_OUTPUT.PUT_LINE(last_day); 
END;
```

****How It Works**** 
The LAST_DAY function is an easy way to retrieve the date for the last day of a given date. To use the 
function, pass in any date, and the last day of the month for the given date will be returned. The function 
can be useful in combination with other functions, especially for converting strings into dates and then 
determining the last day of the given month for the date given in string format. For example, the 
following combination is used quite often: 
```sql
LAST_DAY(to_date(string_based_date,'MM/DD/YYYY')) 
```
## 7-9. Rounding a Number 

****Problem**** 
You are interested in rounding a given number. For example, let’s say you are working on employee 
timecards, and you want to round to the nearest tenth of an hour for every given hour amount. 

****Solution****
Use the Oracle built-in ROUND function to return the result that you desire. For this **Solution**, you are 
working with hours on employee timecards. To round to the nearest tenth, you would write a small 
PL/SQL function that uses the ROUND function and returns the result. The following example 
demonstrates this technique: 
```sql
CREATE OR REPLACE FUNCTION emp_labor_hours(time IN NUMBER) 
RETURN NUMBER IS 
BEGIN 
  RETURN ROUND(time, 1); 
END; 
```
The time will be rounded to the nearest tenth in this example because a 1 is passed as the second 
argument to the ROUND function. 
****How It Works**** 
The Oracle built-in ROUND function can be used for rounding numbers based upon a specified precision 
level. To use the ROUND function, pass a number that you would like to round as the first argument, and 
pass the optional precision level as the second argument. If you do not specify a precision level, then the 
number will be rounded to the nearest integer. If the precision is specified, then the number will be 
rounded to the number of decimal places specified by the precision argument.  
In the case of this **Solution**, a 1 was specified for the precision argument, so the number will be 
rounded to one decimal place. The precision can be up to eight decimal places. If you specify a precision 
larger than eight decimal places, then the precision will default to eight. 

## 7-10. Rounding a Datetime Value 
****Problem**** 
Given a particular date and time, you want the ability to round the date. 
****Solution****
Use the ROUND function passing the date you want to round along with the format model for the unit you 
want to round. For example, suppose that given a date and time, you want to the nearest day. To do this, 
you would pass in the date along with the DD format model. The following code block demonstrates this 
technique: 
```sql 
BEGIN 
  DBMS_OUTPUT.PUT_LINE(to_char(ROUND (SYSDATE, 'DD'),'MM/DD/YYYY - HH12:MI:SS')); 
 END; 
```
The previous code block will return the current date and time rounded to the nearest day. For 
example, if it is before 12 p.m., then it will round the given date back to 12 a.m. on that date; otherwise, it 
will round forward to 12 a.m. on the next date. 
**How It Works** 
You can also use the ROUND function for working with DATE types. To round a date using this function, you 
must specify the date you want to have rounded as the first argument along with the format parameter 
for the type of rounding you want to perform. Table 7-2 lists the different format parameters for 
performing DATE rounding. 
```text
Table 7-2. Format Parameters for DATE Rounding 
Format                            Parameter Description 
Y, YYY, YYYY, YEAR, SYEAR, SYYYY  Rounds to the nearest year 
I, IY, IYYY                       Rounds to the nearest ISO year 
Q                                 Rounds to the nearest quarter 
RM, MM, MON, MONTH                Rounds to the nearest month 
WW                                Rounds to the same day of the week as the first day of the year 
IW                                Rounds to the same day of the week as the first day of the ISO year
W                                 Rounds to the same day of the week as the first day of the month 
J, DD, DDD                        Rounds to the nearest day 
D, DY, DAY                        Rounds to the start day of the week 
HH, HH12, HH24                    Rounds to the nearest hour 
MI                                Rounds to the nearest minute 
```
If you find that you are using the same date conversion in many places throughout your application, 
then it may make sense to create a function to encapsulate the call to the ROUND function. Doing so would 
enable a simple function call that can be used to return the date value you require rather than 
remembering to use the correct format parameter each time. 

## 7-11. Tracking Time to a Millisecond 

****Problem**** 
You are interested in tracking time in a finely grained manner to the millisecond. For example, you want 
to determine the exact time in which a particular change is made to the database. 

****Solution****
Perform simple mathematics with the current date time in order to determine the exact time down the 
millisecond. The following function accepts a timestamp and returns the |milliseconds: 
```sql
CREATE OR REPLACE FUNCTION capture_milliseconds(in_time TIMESTAMP)  
RETURN NUMBER IS 
  milliseconds    NUMBER; 
  CHAPTER 7  NUMBERS, STRINGS, AND DATES 
147 
BEGIN 
select sum( 
   (extract(hour from in_time))*3600+ 
   (extract(minute from in_time))*60+ 
   (extract(second from in_time)))*1000 
into MILLISECONDS from dual; 
RETURN milliseconds; 
 
END;
```

****How It Works**** 
If your application requires a fine-grained accuracy for time, then you may want to track time in 
milliseconds. Performing a calculation such as the one demonstrated in the **Solution** to this recipe on a 
given DATE or TIMESTAMP can do this. By combining the EXTRACT function with some calculations, the 
desired milliseconds result can be achieved. 
The EXTRACT function is used to extract YEAR, MONTH, or DATE units from a DATE type. It can extract 
HOUR, MINUTE, or SECOND from a TIMESTAMP. Milliseconds can be calculated by obtaining the sum of the 
hours multiplied by 3600, the minutes multiplied by 60, and the seconds multiplied by 1000 from a given 
TIMESTAMP. If you need to use milliseconds in your program, then I recommend creating a function such 
as the one demonstrated in the **Solution** to this recipe to encapsulate this logic. 

## 7-12. Associating a Time Zone with a Date and Time 

****Problem**** 
You want to associate a time zone with a given date and time in order to be more precise. 

****Solution****
Create a code block that declares a field as type TIMESTAMP WITH TIME ZONE. Assign a TIMESTAMP to the 
newly declared field within the body of the code block. After doing so, the field that you declared will 
contain the date and time of the TIMESTAMP that you assigned along with the associated time zone. The 
following example demonstrates a code block that performs this technique using the SYSTIMESTAMP: 
```sql
DECLARE 
  time   TIMESTAMP WITH TIME ZONE; 
 BEGIN 
  time := SYSTIMESTAMP; 
  DBMS_OUTPUT.PUT_LINE(time); 
 END; 
```
The results that will be displayed via the call to DBMS_OUTPUT should resemble something similar to 
the following: 
```sql
29-AUG-10 10.27.58.639000 AM -05:00 
```
PL/SQL procedure successfully completed. 

****How It Works**** 
Prior to the TIMESTAMP datatype being introduced in Oracle 9i, the DATE type was the only way to work 
with dates. There were limited capabilities provided, and later the TIMESTAMP was created to fill those 
gaps. For those needing to make use of time zones, Oracle created the TIMESTAMP WITH TIME ZONE and 
TIMESTAMP WITH LOCAL TIME ZONE datatypes. Both of these datatypes provide a time zone to be 
associated with a given date, but they work a bit differently. When you specify the WITH TIME ZONE 
option, the time zone information is stored within the database along with the hours, minutes, and so 
on. However, if you specify the WITH LOCAL TIME ZONE option, the time zone information is not stored 
within the database, but rather it is calculated each time against a baseline time zone, which determines 
the time zone of your current session. 
In the **Solution** to this recipe, the time zone information is stored within the database along with the 
rest of the date and time associated with the TIMESTAMP. 

## 7-13. Finding a Pattern Within a String 

****Problem**** 
You want to find the number of occurrences of a particular pattern within a given string. For instance, 
you want to search for email addresses within a body of text. 

****Solution****
Use a regular expression to match a given string against the body of text and return the resulting count of 
matching occurrences. The following example searches through a given body of text and counts the 
number of email addresses it encounters. Any email address will be added to the tally because a regular 
expression is used to compare the strings. 
```sql
CREATE OR REPLACE PROCEDURE COUNT_EMAIL_IN_TEXT(text_var     IN VARCHAR2) AS 
  counter    NUMBER := 0; 
  mail_pattern    VARCHAR2(15) := '\w+@\w+(\.\w+)+'; 
BEGIN 
  counter := REGEXP_COUNT(text_var, mail_pattern); 
 
  IF COUNTER = 1 THEN 
    DBMS_OUTPUT.PUT_LINE('This passage provided contains 1 email address’); 
  ELSIF counter > 1 THEN 
    DBMS_OUTPUT.PUT_LINE('This passage provided contains '|| 
                     counter || ' email addresses'); 
  ELSE 
    DBMS_OUTPUT.PUT_LINE('This passage provided contains ' || 
            'no email addresses'); 
  END IF; 
END; 
```
The function in this example provides a single service because it counts the number of occurrences 
of an email address in a given body of text and returns the result. 

****How It Works**** 
You can use regular expressions to help match strings of numbers, text, or alphanumeric values. They 
are sequences of characters and symbols that assimilate a pattern that can be used to match against 
strings of text. A regular expression is similar to using the % symbol as a wildcard within a query, except 
that a regular expression provides a pattern that text must match against. Please refer to online Oracle 
documentation for a listing of the different options that can be used for creating regular expression 
patterns.  

Oracle introduced the REGEXP_COUNT function in Oracle 11g, which provides the functionality of counting 
the number of occurrences of a given string within a given body of text. The syntax for the REGEXP_COUNT 
function is as follows: 
```sql
REGEXP_COUNT(source_text, pattern, position, options) 
```
The source text for the function can be any string literal, variable, or column that has a datatype of 
VARCHAR2, NVARCHAR2, CHAR, NCHAR, CLOB, or NCLOB. The pattern is a regular expression or a string of text that 
will be used to match against. The position specifies the placement within the source text where the 
search should begin. By default, the position is 1. The options include different useful matching 
modifiers; please refer to the Oracle regular expression support documentation at 
http://download.oracle.com/docs/cd/E14072_01/server.112/e10592/ap_posix.htm#g693775 for a listing 
of the pattern matching modifiers that can be used as options. 
The REGEXP_COUNT function can be used within any Oracle SQL statement or PL/SQL program. The 
following are a few more examples of using this function: 
```sql
-- Count all occurrences of the letter 'l' in the word Hello 
result := REGEXP_COUNT('hello','l'); 
 
Returns:  2 
 
-- Count the number of occurrences of the pattern 'ells' beginning at 
-- the fifth character. 
result := REGEXP_COUNT('she sells sea shells by the sea shore', 
                      'ells',7,'c'); 
 
Returns: 1 
 
-- Count the number of words in the line 
result := REGEXP_COUNT('she sells sea shells by the sea shore', 
                      '\w+'); 
 
Returns: 8 
```
As you can see from these examples, the REGEXP_COUNT function is a great addition to the Oracle 
regular expression function family 

## 7-14. Determining the Position of a Pattern Within a String 

****Problem**** 
You want to return the position of a matching string within a body of text. Furthermore, you are want to
pattern match and therefore must invoke a regular expression function. For example, you need to find a
way to determine the position of a string that matches the pattern of a phone number. 

**Solutio**
Use the REGEXP_INSTR function to use a regular expression to search a body of text to find the position of
a phone number. The following code block demonstrates this technique by looping through each of the
rows in the EMPLOYEES table and determining whether the employee phone number is USA or
international:
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT * 
  FROM employees; 
  emp_rec       emp_cur%ROWTYPE; 
  position     NUMBER := 0; 
  counter        NUMBER := 0; 
  intl_count     NUMBER := 0;
BEGIN 
  FOR emp_rec IN emp_cur LOOP 
  position := REGEXP_INSTR(emp_rec.phone_number, 
  '([[:digit:]]{3})\.([[:digit:]]{3})\.([[:digit:]]{4})'); 
   
  IF position > 0 THEN 
    counter := counter + 1; 
  ELSE 
    intl_count := intl_count + 1; 
  END IF; 
  END LOOP; 
  DBMS_OUTPUT.PUT_LINE('Numbers within USA: ' || counter); 
  DBMS_OUTPUT.PUT_LINE('International Numbers: ' || intl_count); 
END; 
```
Result: 
Numbers within USA: 72
International Numbers: 35 
PL/SQL procedure successfully completed. 

****How It Works**** 
In the **Solution** to this recipe, the function uses REGEXP_INSTR to find all telephone numbers that match 
the U.S. telephone number format. The field passed into REGEXP_INSTR is always going to return a 
telephone number, but that number may be in an international format or a U.S. format. If the pattern of 
the telephone number matches that of a U.S. format, then the counter for U.S. numbers is increased by 
one. Otherwise, the counter for the international numbers is increased by one. The reasonable 
assumption is that if a number is not a U.S. number, that it is an “international” number. Using 
REGEXP_INSTR makes this a very easy function to implement. 
REGEXP_INSTR will return the position of the first or last character of the matching string depending 
upon the value of the return option argument. This function provides the same functionality of INSTR 
except that it also allows the ability to use regular expression patterns. The syntax for this function is as 
follows: 
```sql
REGEXP_INSTR(source_text, pattern, position, occurrence, 
                               return_option, match parameter, subexpression) 
```
All but the source_text and pattern parameters are optional. The source_text is the string of text to 
be searched. The pattern is a regular expression or string that will be matched against the source_text. 
The optional position argument is an integer that specifies on which character Oracle should start the 
search. The optional occurrence parameter specifies which occurrence of the pattern will have its 
position returned. The default occurrence argument is 1, which means that the position of the first 
matching string will be returned  
The optional return_option is used to specify special options that are outlined within the Oracle 
regular expression documentation that can be found at 
http://download.oracle.com/docs/cd/E11882_01/server.112/e10592/ap_posix.htm#g693775. The 
optional match_parameter allows you to change the default matching behavior. The subexpression 
parameter is optional, and it is an integer from 0 to 9 that indicates which subexpression in the 
source_text will be the target of the function. 

## 7-15. Finding and Replacing Text Within a String 

****Problem****
You want to replace each occurrence of a given string within a body of text. 
****Solution**** 
Use the REGEXP_REPLACE function to match a pattern of text against a given body of text, and replace all 
matching occurrences with a new string. In the following function, the REGEXP_REPLACE function is used 
to replace all occurrences of the JOB_TITLE ‘Programmer’ with the new title of ‘Developer.’ 
```sql
DECLARE 
  CURSOR job_cur IS 
  SELECT * 
  FROM jobs; 
 
  job_rec       job_cur%ROWTYPE; 
  new_job_title jobs.job_title%TYPE; 
BEGIN 
  FOR job_rec IN job_cur LOOP 
    IF REGEXP_INSTR(job_rec.job_title,'Programmer') > 0 THEN 
      new_job_title := REGEXP_REPLACE(job_rec.job_title, 'Programmer', 
                                    'Developer'); 
 
      UPDATE jobs 
      SET job_title = new_job_title 
      WHERE job_id = job_rec.job_id; 
     
      DBMS_OUTPUT.PUT_LINE(job_rec.job_title || ' replaced with ' || 
         new_job_title); 
    END IF; 
 END LOOP; 
 
END; 
```
Although this particular example does not use any regular expression patterns, it could be adjusted 
to do so. To find more information and tables specifying the options that are available for creating 
patterns, please refer to the online Oracle documentation. 
The **Solution** to this recipe prints out the revised text. Each occurrence of the ‘Programmer’ text is 
replaced with ‘Developer’, and the newly generated string is returned into the NEW_REVIEW variable. 

****How It Works****
The REGEXP_REPLACE function is a great way to find and replace strings within a body of text. The function 
can be used within any Oracle SQL statement or PL/SQL code. The syntax for the function is as follows: 
```sql
REGEXP_REPLACE(source_text, pattern, replacement_string, position, occurrence, options) 
```
The source text for the function can be any string literal, variable, or column that has a datatype of 
VARCHAR2, NVARCHAR2, CHAR, NCHAR, CLOB, or NCLOB. The pattern is a regular expression or a string of text that 
will be used to match against. The replacement string is will replace each occurrence of the string 
identified by the source text. The optional position specifies the placement within the source text where 
the search should begin. By default, the position is 1. The optional occurrence argument is a 
nonnegative integer that indicates the occurrence of the replace operation. If a 0 is specified, then all 
matching occurrences will be replaced. If a positive integer is specified, then Oracle will replace the 
match for that occurrence with the replacement string. The optional options argument includes 
different useful matching modifiers; please refer to the online Oracle documentation for a listing of the 
pattern matching modifiers that can be used as options. 
■ Note Do not use REGEXP_REPLACE if the replacement can be performed with a regular UPDATE statement. Since 
REGEXP_REPLACE uses regular expressions, it can be slower than a regular UPDATE. 
The following examples demonstrate how this function can be used within a PL/SQL application or 
a simple query. This next bit of code demonstrates how to replace numbers that match those within the 
given set. 
```sql 
select REGEXP_REPLACE('abcdefghi','[acegi]','x') from dual; 
```
Returns: xbxdxfxhx 
 
Next, we replace a Social Security Number with Xs. 
 
new_ssn := REGEXP_REPLACE('123-45-6789','[[:digit:]]{3}-[[:digit:]]{2}-[[:digit:]]{4}','xxx-
xxx-xxxx'); 
 
Returns: xxx-xxx-xxxx 
 
The REGEXP_REPLACE function can be most useful when attempting to replace patterns of strings within a 
given body of text such as the two previous examples have shown. As noted previously, if a standard 
UPDATE statement can be used to replace a value, then that should be the first choice, because regular 
expressions perform slightly slower. 