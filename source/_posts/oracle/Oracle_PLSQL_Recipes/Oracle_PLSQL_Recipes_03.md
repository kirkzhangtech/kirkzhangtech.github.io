---
title: Oracle PLSQL Recipes 03-Looping and Logic
categories: 
- oracle
thumbnailImagePosition: bottom
coverImage: https://user-images.githubusercontent.com/46363359/199011812-44a2e355-c72a-4252-bac9-37ecded0cb54.jpg
metaAlignment: center
coverMeta: out
---

摘要: 其实这个讲PLSQL有点基础

<!-- more -->

<!-- toc -->


# 3. Looping and Logic

## 3.1. Choosing When to Execute Code

****Problem****
Your code contains a condition, and you are interested in executing code to perform specific actions if the condition evaluates to `TRUE`, `FALSE`, or `NULL`. 
****Solution**** 
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
****How It Works**** 
As shown in the **Solution**, the general format for the IF-THEN statement is as follows:
```sql
IF condition THEN
 Statements to be executed 
 …
END IF; 
```
The `IF-THEN` statement is one of the most frequently used conditional statements. If a given condition evaluates to `TRUE`, then the code contained within the IF-THEN statement is executed. If the condition evaluates to FALSE or NULL, then the statement is exited. However, it is possible to incorporate(vt.包含,吸收) a different set of statements if the condition is not satisfied. Please see Recipe 3-2 for an example. Any number of `IF-THEN` statements can be nested within one another. The statements within the `IF-THEN` will be executed if the condition that is specified evaluates to `TRUE`.

## 3-2. Choosing Between Two Mutually Exclusive Conditions
****Problem**** 
You have two conditions that are mutually(美 ['mjutʃuəli]adv.互相地,互助) exclusive. You want to execute one set of statements if the 
first condition evaluates to TRUE. Otherwise, if the first condition is FALSE or NULL, then execute a different 
set of statements. 
****Solution**** 
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
****How It Works****
The `IF-ELSE` statement syntax is basically the same as the `IF-THEN` syntax, except that a different set of 
statements is executed in the ELSE clause when the condition evaluates to FALSE or NULL. Therefore, if the 
first condition is FALSE or NULL, then the control automatically drops down into the statements contained 
within the ELSE clause and executes them.

## 3.3. Evaluating Multiple Mutually Exclusive Conditions

****Problem****
Your application has multiple conditions to evaluate, and each of them is mutually exclusive. If one of 
the conditions evaluates to FALSE, you’d like to evaluate the next one. You want that process to continue 
until there are no more conditions. 
Two **Solution**s are possible: one using IF and the other using `CASE`.

****Solution** #1**
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
****Solution** #2**
You can use the searched `CASE` statement to evaluate a boolean expression to determine which statements to execute among multiple, mutually exclusive conditions. The next example is a SQL*Plus script that performs the same tasks as ****Solution** #1** but this time using a searched `CASE` statement:
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
****How It Works****
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

****Problem****
You have a single expression that yields multiple outcomes. You are interested in evaluating the expression and performing a different set of statements depending upon the outcome. 
****Solution**** 
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

****How It Works****
There are two different types of CASE statements that can be used—those being the searched CASE and the simple CASE statement. The **Solution** to this recipe demonstrates the simple CASE. For an example of a searched CASE statement, please see Recipe 3-3.

The simple CASE statement begins with the keyword CASE followed by a single expression called a selector. The selector is evaluated one time, and it can evaluate to any PL/SQL type other than BLOB, BFILE, an object type, a record, or a collection type. The selector is followed by a series of WHEN clauses. The WHEN clauses are evaluated sequentially to determine whether the value of the selector equals the result from any of the WHEN clause expressions. If a match is found, then the corresponding WHEN clause is executed.

The CASE statement can include any number of WHEN clauses, and much like an IF statement, it can be followed with a trailing ELSE clause that will be executed if none of the WHEN expressions matches. If the ELSE clause is omitted, a predefined exception will be raised if the CASE statement does not match any of the WHEN clauses. The END CASE keywords end the statement.

## 3.5. Looping Until a Specified Condition Is Met

****Problem****
You want to loop through a set of statements until a specified condition evaluates to true. 
****Solution****
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
****How It Works****
The simple LOOP structure is very easy to use for generating a loop in your code. The LOOP keyword is used
to start the loop, and the END LOOP keywords are used to terminate it. Every simple loop must contain an
EXIT or GOTO statement; otherwise, the loop will become infinite and run indefinitely.
You can use a couple of different styles for the EXIT. When used alone, the EXIT keyword causes a
loop to be terminated immediately, and control is passed to the first statement following the loop. You
can use the EXIT-WHEN statement to terminate the loop based upon the evaluation of a condition after the
WHEN statement. If the condition evaluates to TRUE, then the loop is terminated; otherwise, it will
continue.
The following example shows the same LOOP as the example in the **Solution**, but instead of using an
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
****Problem****
You have created a cursor and retrieved a number of rows from the database. As a result, you want to 
loop through the results and do some processing on them. 
****Solution**** 
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

****Problem****
You want to iterate over a series of statements until a specified condition no longer evaluates to TRUE. 
****Solution**** 
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

****How It Works****
The WHILE loop tests a condition at the top of the loop, and if it evaluates to TRUE, then the statements within the loop are executed, and control is returned to the start of the loop where the condition is tested again. If the condition does not evaluate to TRUE, the loop is bypassed, and control goes to the next statement after the END LOOP. If the condition never fails, then an infinite loop is formed, so it is important to ensure that the condition will eventually evaluate to FALSE. It is important to note that the statements in the loop will never be executed if the condition evaluates to FALSE during the first pass. This situation is different from the simple loop that always 
iterates at least once because the EXIT condition is usually evaluated elsewhere in the loop. To ensure that a WHILE loop is always executed at least one time, you must ensure that the condition evaluates to TRUE at least once. One way to do this is to use a flag variable that is evaluated with each iteration of the loop. Set the flag equal to FALSE prior to starting the loop, and then set it to TRUE when a certain condition is met inside the loop. The following pseudocode depicts such a **Solution**:
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
****Problem****
If a specified conditional statement evaluates to TRUE, you want to terminate the current loop iteration of 
the loop early and start the next iteration immediately.
****Solution**** 
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
****How It Works****
You can use the CONTINUE statement in any loop to unconditionally halt execution of the current iteration 
of the loop and move to the next. As shown in the **Solution**, the CONTINUE statement is usually 
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

****Problem****
You are interested in executing the contents of a loop a specified number of times. For example, you are
interested in executing a loop ten times, and you need to number each line of output in the range by the
current loop index.
****Solution****
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
****How It Works****
The FOR loop will increment by one through the given range for each iteration until it reaches the end. 
The loop is opened using the keyword FOR, followed by a variable that will be used as the index for the 
loop. Following the index variable is the IN keyword, which is used to signify that the index variable 
should increment one by one through the given range, which is listed after the IN keyword. The loop is 
terminated using the END LOOP keywords. 
Each statement contained within the loop is executed once for each iteration of the loop. The index 
variable can be used within the loop, but it cannot be changed. As shown in the **Solution**, you may use 
the index for printing purposes, and it is oftentimes used in calculations as well.
The REVERSE keyword should be placed directly after the IN keyword and before the range that you
specify. The REVERSE keyword has no effect when working with cursors. If you need to iterate through 
cursor results in a specific order, then specify an ORDER BY clause in your SELECT statement. 

## 3.11 Iterating in Increments Other Than One

3-11. Iterating in Increments Other Than One
****Problem****
Rather than iterating through a range of numbers one at a time, you want to increment by some other 
value. For example, you might want to increment through even values such as 2, 4, 6, and so forth. 
****Solution**** 
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
****How It Works****
Unlike some other languages, PL/SQL does not include a STEP clause that can be used while looping. To 
work around that limitation, you will need to write your own stepping algorithm. In the **Solution** to this 
recipe, you can see that the algorithm was quite easy; you simply multiply the index by two to achieve 
the desired result. In this **Solution**, assigning the range of 1..5 as the index produces the effect of iterating 
through all even numbers from 2..10 when the current index is multiplied by two. 
Using similar techniques, you can increment through ranges of numbers in various intervals. 
However, sometimes this can become troublesome if you are attempting to step by anything other than 
even numbers. You can see an example of this in the next recipe.

## 3.12. Stepping Through a Loop Based on Odd-Numbered Increments

****Problem****
Rather than iterating through a range of numbers by even increments, you prefer to loop through the 
range using odd increments. 
****Solution****
Use the built-in MOD function to determine whether the current index is odd. If it is odd, then print out 
the value; otherwise, continue to the next iteration. The following example shows how to implement this 
**Solution**:

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
****How It Works****
The **Solution** depicts one possible workaround for a STEP replacement. Using the MOD function to 
determine whether a number is odd works quite well. The MOD function, otherwise known as the modulus 
function, is used to return the remainder from the division of the two numbers that are passed into the 
function. Therefore, this function is useful for determining even or odd numbers. In this case, if any 
value is returned from MOD, then the number is assumed to be odd, and the statements within the IF
statement will be executed.
Such a technique may be useful in the case of iterating through a collection of data such as a table. If 
you want to grab every other record from the collection, then performing a stepping **Solution** such as this 
or the **Solution** from Recipe 3-11 will allow you to achieve the desired result. You could easily use the 
resulting index from this technique as the index for a collection.

## 3.13. Exiting an Outer Loop Prematurely
****Problem**** 
Your code contains a nested loop, and you want the inner loop to have the ability to exit from both loops 
and stop iteration completely. 
****Solution****
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
****How It Works**** 
Any loop in PL/SQL can be labeled using a similar style to labels for code blocks. The label can be any 
valid identifier surrounded by angle brackets before the loop, and optionally the identifier can be placed 
at the end after the END LOOP clause. The result of such a labeling mechanism is that you will have a 
distinct start and end to the loops and more control over loop execution. 
In the **Solution** to this recipe, the label helps identify the outer loop so that it can be terminated with 
the EXIT clause. Without a label, the EXIT will terminate the innermost FOR loop. However, the label can 
also be used to help identify the loop’s index. In the **Solution**, this is not necessary because the outer loop 
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

This code will display the same results as the example given in the **Solution** to this recipe. The only
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
In this example, the same code that is used in the **Solution** to this recipe is rewritten to incorporate a
CONTINUE statement. This statement is used to move control of execution back to the outer loop. When
the CONTINUE statement is reached, execution of the current loop is immediately halted, and processing
continues to the loop designated by the label.

## 3.14. Jumping to a Designated Location in Code

****Problem****
You want your code to stop executing and jump to a different, designated location.
****Solution****
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
****How It Works****
The GOTO statement is used to branch code unconditionally. Code can be branched to any label within 
the same scope as the GOTO. In the **Solution**, the GOTO statement causes the code to branch to a parent 
code block. You could just as easily branch to a loop within the current or outer block. However, you 
cannot branch to a label within a subblock, IF statement, or LOOP. 

You should use this statement sparingly because arbitrary branching makes code difficult to read. Use 
conditional statements to branch whenever possible, because that’s why they were put into the 
language. As you can see from the **Solution**, the same code could have been written printing the “Invalid 
number” message within the ELSE clause. There are usually better alternatives to using GOTO.
