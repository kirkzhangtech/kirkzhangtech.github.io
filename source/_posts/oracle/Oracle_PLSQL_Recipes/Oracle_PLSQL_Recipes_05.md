---
title: Oracle PLSQL Recipes 05-Triggers
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

# 5. Triggers 

Triggers play an important role in any database developer’s or database administrator’s career. They 
provide the ability to execute code upon the occurrence of defined database, schema, or system events. 
Triggers can be useful for enhancing applications by providing database capabilities when a table event 
occurs, providing alerts on system event occurrences, and so much more. Triggers are an enormous 
topic because they are very intricate constructs. However, even though triggers can open up a world of 
possibilities, they are easy to use. 
In this chapter, you will see recipes demonstrating the many different capabilities that triggers 
provide to you. If you are interested in learning how to create code that executes upon a database table–
level event, then this is the chapter for you. If you want to learn how to create an intricate alerting system 
that will send e-mail and create logs upon system events, then look at the recipes in this chapter. 
Triggers are intricate building blocks that can provide an enormous benefit to our databases and 
applications as a whole. By learning how to incorporate these recipes into your applications, you will be 
able to solve many issues and enhance a number of your application features. Triggers can be one of the 
most useful tools to add to a DBA or application developer’s arsenal. 

## 5-1. Automatically Generating Column Values(how use before insert)

****Problem**** 
You want to automatically generate certain column values for newly inserted rows. For example, one of your tables includes a date field that you want to have populated with the current date when a record is inserted. 

****Solution**** 
Create a trigger that executes BEFORE INSERT on the table. The trigger will capture the system date and populate this date field with it prior to inserting the row into the database. The following code demonstrates how to create a trigger that provides this type of functionality for your application. In the example, the EMPLOYEES table is going to have its HIRE_DATE populated with the current date when a record is inserted into the EMPLOYEES table. 

```sql
CREATE or REPLACE TRIGGER populate_hire_date 
BEFORE INSERT ON employees 
    FOR EACH ROW 
DECLARE 
BEGIN 
    :new.hire_date := sysdate; -- new.hire_date  means user's data
END; 
```

A BEFORE INSERT trigger has access to data before it is inserted into the table. This example 
demonstrates a useful technique for using this type of trigger. 

****How It Works**** 
You can use triggers to execute code when a DML statement, DDL statement, or system event occurs. 
This recipe demonstrates a trigger that executes when a DML event occurs. Specifically, the trigger that 
was created for this recipe is fired BEFORE a row is inserted into the EMPLOYEES table. Any DDL event 
trigger can be created to fire BEFORE or AFTER a row is inserted, updated, or deleted from a database table. 
This flexibility allows a developer or DBA the luxury of executing code either before or directly after the 
values are inserted into the database. 
The syntax for creating a trigger that will execute before an insert on a particular table is as follows: 
```sql
CREATE or REPLACE TRIGGER trigger_name 
BEFORE INSERT 
    ON table_name 
    [ FOR EACH ROW ] 
DECLARE 
    -- variable declarations 
BEGIN 
    -- trigger code 
EXCEPTION 
    WHEN ... 
    -- exception handling 
END; 
```
The CREATE OR REPLACE TRIGGER statement will do just what it says, either create the trigger in the 
current schema if none is specified or replace it if another trigger by that name already exists. The trigger 
name must be unique among other triggers within the same schema. Although it is possible to name a 
trigger the same as an existing table, we do not recommend doing so. Different triggers by the same 
name can coexist in the same database if they are in different schemas. 
The BEFORE INSERT clause is what tells Oracle when the trigger should be executed before a row is 
inserted into the table. The other option for insert triggers is AFTER INSERT, which causes the trigger to be 
executed after a row is inserted into the table. You will learn more about AFTER INSERT triggers in 
another recipe within this chapter. The optional `FOR EACH ROW` clause determines whether the trigger will 
be executed once for each row that is affected or once when the statement is executed. Essentially this 
clause determines whether it will become a row-level trigger or a statement level-trigger. The FOR EACH 
ROW clause can have a significant impact on the outcome of an UPDATE trigger. You will learn more about 
UPDATE triggers in the next recipe. 
The code that follows the optional FOR EACH ROW clause is the DECLARE section. Much like that of a 
procedure, this section of the trigger is used to declare any variables, types, or cursors that will be used 
by the trigger body. The body of the trigger also resembles(类似) that of a procedure. The trigger body is a 
standard code block that opens with the BEGIN keyword and ends with the END keyword. Any of the 
keywords and constructs that can be used within other PL/SQL code blocks can also be used in triggers. 
There are a couple of differences between the trigger and other code blocks in PL/SQL. First, a 
trigger is limited to 32KB in size. This is a bit of a limitation; however, it does not prevent a trigger from 
invoking other named code blocks. For example, you can write a trigger to invoke stored procedures and 
functions that are much longer than 32KB in size.  

Second, the `INSERT trigger` has access to data values prior to insertion in the database via the `:NEW` 
qualifier. This qualifier is what provides the power to the trigger construct. Using the `:NEW` qualifier along 
with a table column name allows you to access the value that is going to be placed into that column via 
the INSERT statement that has just occurred. In the **Solution** to is recipe, using `:NEW.FIRST_NAME` and 
`:NEW.LAST_NAME` allows you to reference the values that are going to be inserted into the FIRST_NAME and 
LAST_NAME columns before it occurs. This provides the ability to change the values or check the values for 
error prior to insertion. 

In the case of the **Solution** to this recipe, the HIRE_DATE will always be made the same as the date in 
which the record is inserted into the database. Even if the HIRE_DATE is set to some date in the past, this 
trigger will automatically assign SYSDATE to it and override the original value. Now, this may not be very 
practical example because the data entry clerk may not be inputting the data on the same day as the 
hire, but it does provide an effective learning tool for this type of situation. If you wanted to modify the 
trigger to be more realistic, then you could add an IF statement to check and see whether 
:NEW.HIRE_DATE already had a value. If it does, then that value is inserted into the database, but if left 
blank, then SYSDATE could be used. Such an example would be a more practical real-life **Solution**. 

summary:  
1. 32KB in size but you could  invoke function and procedure that more that 32kb
2. :NEW.FIRST_NAME allow you access data that you gonna insert
3. Even if the HIRE_DATE is set to some date in the past, this trigger will automatically assign SYSDATE to it and override the original value


## 5-2. Keeping Related Values in Sync

****Problem**** 
You want to keep related values in sync that happen to be stored in separate tables. For example, say you 
are updating the salary level for a number of jobs within the JOBS table. However, in doing so, you will 
need to update the salaries within the EMPLOYEES table for employees having those jobs. In short, if you 
update the salary range for a job, then you want to automatically update salaries to ensure that they fall 
within the new range.  

■ Note When we use the term related in this **Problem** description, we do not necessarily mean related in the 
relational sense that one commonly thinks about. There is no referential integrity issue in our scenario. Rather, we 
are instituting a business rule that says that employees automatically get salary bumps in response to changing 
salary ranges. Not all businesses would choose to institute such a rule. In fact, we suspect most businesses would 
not do such a thing.  

****Solution**** 
Create an AFTER UPDATE trigger on the primary table. In our example, create such a trigger to be executed 
after the JOBS table has been updated. This trigger will obtain the updated salary from the JOBS table and 
modify the data within the EMPLOYEES table accordingly. 
```sql
CREATE OR REPLACE TRIGGER job_salary_update 
AFTER UPDATE 
    ON jobs 
FOR EACH ROW 
DECLARE 
 
  CURSOR emp_cur IS 
  SELECT * FROM employees  
  WHERE job_id = :new.job_id 
  AND salary < :new.min_salary FOR UPDATE; 
 
  emp_rec  emp_cur%ROWTYPE; 
 
BEGIN 
 
    FOR emp_rec IN emp_cur LOOP 
        UPDATE employees 
        SET salary = :new.min_salary 
        WHERE CURRENT OF emp_cur; 
    END LOOP; 
 
END; 
```

Since this example uses an AFTER UPDATE trigger, you have access to both the :NEW and :OLD data value 
qualifiers. This can be very advantageous, as you’ll learn in the next section. 

****How It Works**** 
The update trigger provides the same type of functionality as an INSERT trigger. The syntax for an update 
trigger is almost identical to that of an insert trigger, other than the BEFORE UPDATE or AFTER UPDATE 
clause. A BEFORE UPDATE trigger is executed prior to an update on a database table. On the contrary, the 
AFTER UPDATE executes after an update has been made to a table.  
The optional FOR EACH ROW clause can make a great deal of difference when issuing an update 
trigger. If used, this clause tells Oracle to execute the trigger one time for every row that is updated. This 
is quite useful for capturing or modifying data as it is being updated. If the FOR EACH ROW clause is 
omitted, the trigger is executed one time either prior to or after the UPDATE has taken place. Without the 
FOR EACH ROW clause, the trigger is not executed once for each row but rather one time only for each 
UPDATE statement that is issued. 
As mentioned previously in this recipe, update triggers have access to the :OLD and :NEW qualifiers. 
The qualifiers allow the trigger to obtain the values of data that are being updated prior to (:OLD) and 
after (:NEW) the update has been made. Generally, update triggers are most useful for obtaining and 
modifying data values as the update is occurring. Update triggers, along with every other type of trigger, 
should be used judiciously because too many triggers on a table can become **Problem**atic. 
For example, the **Solution** to this recipe demonstrates a trigger in which a salary change in the JOBS 
table causes a trigger to execute. The trigger will be executed only if the JOBS table is updated. The cursor 
that is declared will select all the records within the EMPLOYEES table that contain a SALARY that is lower 
than the new MIN_SALARY for the corresponding JOB_ID. In the body of the trigger, the cursor result set is 
iterated, and each record is updated so that the SALARY is adjusted to the new MIN_SALARY amount for that 
job. 
If that trigger contains another update statement that modifies values in the EMPLOYEES table, then 
you must be sure that the EMPLOYEES table does not contain an update trigger that modifies values within 
the JOBS table. Otherwise, a vicious cycle could occur in which one trigger is causing another trigger to 
execute, which in turn causes the initial trigger to execute again, and so on. This may even cause an 
ORA-xxxxx error if Oracle detects a recursive loop. 
Update triggers can provide the best of both worlds because you have access to data values before 
and after they have been updated. 

## 5-3. Responding to an Update of a Specific Table Column 

****Problem**** 
You want to automatically update some particular values within a table based upon another update that 
has been made on a specific column of another table. For instance, assume that management has 
decided to change some positions around within your organization. A new manager is coming to one of 
the current manager positions, so several employees will receive a new manager. You need to find a way 
to update several employee records to change their manager from the old one to the new one.  

****Solution**** 
Create an AFTER UPDATE trigger that will be executed only when the MANAGER_ID column is updated. The 
following trigger uses a cursor to obtain the employees that are supervised(adj.有监督的) by the old manager. The 
trigger then determines whether the MANAGER_ID column has been updated, and if so, it loops through 
each employee who has the old manager in their record, and it updates the MANAGER_ID column to reflect 
the new manager’s ID. 
```sql
CREATE OR REPLACE TRIGGER dept_mgr_update 
AFTER UPDATE OF manager_id   -- column name
    ON departments  --table
FOR EACH ROW 
DECLARE 
  CURSOR emp_cur IS 
  SELECT * 
  FROM EMPLOYEES 
  WHERE manager_id = :old.manager_id 
  FOR UPDATE; 
BEGIN 
 
   
     FOR emp_rec IN emp_cur LOOP 
        UPDATE employees 
        SET manager_id = :new.manager_id 
        WHERE CURRENT OF emp_cur; 
     END LOOP; 
   
END; 
```
This trigger will be executed only if the MANAGER_ID column of the DEPARTMENTS table is updated. 
Triggers that have this ability provide for better database performance, because the trigger is not 
executed each time the DEPARTMENTS table has been updated. 

****How It Works**** 
Triggers can specify columns that must have their values updated in order to cause the trigger to 
execute. This allows the developer to have finer-grained control over when the trigger executes. You can 
take a few different strategies in order to cause a trigger to execute upon an update of a specified 
column. As is demonstrated in the **Solution** to this recipe, you can specify the column in the trigger 
declaration. This is one of the easiest approaches to take, and it causes the trigger to execute only if that 
specified column is updated. Alternatively, you can use a conditional predicate in the trigger body to 
determine whether the row you had specified in the declaration is indeed being updated. A conditional 
predicate can be used along with a specified column name to determine whether a specified action is 
being performed on the named column. You can use three conditional predicates, INSERTING, UPDATING, 
and DELETING. Therefore, a conditional predicate such as the following can be used to determine whether 
a specified column is being updated by the current statement: 

```sql 
IF UPDATING ('my_column') THEN 
  -- Some statements 
END IF; 
```

Using a conditional predicate(vt.断定为) ensures that the code in the THEN clause is executed only if a specified 
action is occurring against the named column. These predicates can also be used along with other 
conditions to have finer-grained control over your statements. For instance, if you want to ensure that a 
column was being updated and also that the current date does not match some end date, then you can 
combine those two conditions with an AND boolean operator. The following code demonstrates this type 
of conditional statement: 

```sql
IF UPDATING ('my_column') AND end_date > SYSDATE THEN 
  -- Some statements 
END IF; 
```

If you prefer to use the technique demonstrated in the **Solution** to this recipe, then you can still 
check to ensure that the specified column is being updated by using the `IF UPDATING` predicate without 
the column name specified. This technique would look like the following statement:

```sql 
IF UPDATING THEN 
  --some statements 
END IF; 
```

As mentioned in the **Solution** to this recipe, specifying a specific column can help decrease the 
amount of times that the trigger is fired because it is executed only when the specified column has been 
updated. Another advantage to using this level of constraint within your triggers is that you can add 
more triggers to the table if needed. For instance, if you needed to create another trigger to fire AFTER 
UPDATE on another column on the same table, then it would be possible to do so with less chance of a 
conflict. On the contrary(adj.相反的), if you were using a simple AFTER UPDATE trigger, then chances of a conflict are 
more likely to occur. 

summary:  
1. three types of update checking


## 5-4. Making a View Updatable 

****Problem**** 
You are working with a database view, and it needs to be updated. However, the view is not a simple 
view and is therefore read-only. If you tried to update a column value on the view, then you would 
receive an error. 

****Solution**** 
Use an `INSTEAD OF` trigger to specify the result of an update against the view, thus making the view 
updatable. For example, let’s begin with the following view definition: 
```sql
CREATE OR REPLACE VIEW EMP_JOB_VIEW AS 
  SELECT EMP.employee_ID, EMP.first_name, EMP.last_name, 
         EMP.email, JOB.job_title, 
         DEPT.department_name 
  FROM employees EMP, 
       jobs JOB, 
       departments DEPT 
  WHERE JOB.job_id = EMP.job_id 
  AND DEPT.department_id = EMP.department_id 
  ORDER BY EMP.last_name;  
```

Given the EMP_JOB_VIEW just shown, if you attempt to make an update to a column, then you will 
receive an error. The following demonstrates the consequences of attempting to update the 
DEPARTMENT_NAME column of the view. 
```sql
SQL> update emp_job_view 
  2  set department_name = 'dept' 
  3  where department_name = 'Sales'; 
where department_name = 'Sales' 
      * 
ERROR at line 3: 
ORA-01779: cannot modify a column which maps to a non key-preserved table 
```
However, using the `INSTEAD OF` clause, you can create a trigger to implement the logic for an UPDATE 
statement issued against the view. Here’s an example:

```sql
CREATE OR REPLACE TRIGGER update_emp_view 
INSTEAD OF UPDATE ON emp_job_view 
REFERENCING NEW AS NEW   -- note
FOR EACH ROW 
DECLARE 
  emp_rec                        employees%ROWTYPE; 
 
  title                          jobs.job_title%TYPE; 
  dept_name                      departments.department_name%TYPE; 
BEGIN 
 
    SELECT * 
    INTO emp_rec 
    FROM employees 
    WHERE employee_id = :new.employee_id; 
 
    UPDATE jobs 
    SET job_title = :new.job_title 
    WHERE job_id = emp_rec.job_id; 
 
    UPDATE departments 
    SET department_name = :new.department_name 
    WHERE department_id = emp_rec.department_id; 
     
    UPDATE employees 
    SET email = :new.email, 
    first_name = :new.first_name, 
    last_name = :new.last_name 
    WHERE employee_id = :new.employee_id;
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('No matching record exists'); 
END; 
```

The following are the results of issuing an update on the view when the UPDATE_EMP_VIEW trigger is in
place. The UPDATE is issued, and the INSTEAD OF trigger executes instead of the database’s built-in logic.
The result is that the rows containing a DEPARTMENT_NAME of Sales will be updated in the view. Hence, the
underlying(v.放在…的下面) row in the DEPARTMENTS table is updated to reflect the change.

```sql
SQL> update emp_job_view 
  2  set department_name = 'Sales Dept' 
  3  where department_name = 'Sales'; 
34 rows updated. 
```
If you were to query the view after performing the update, then you would see that the view data has
been updated to reflect the requested change. If you read through the code in the trigger body, you can
see the magician behind the curtain(n.幕;窗帘).

****How It Works**** 
Oftentimes it is beneficial to have access to view data via a trigger event. However, there are some views
that are read-only, and data manipulation(n.操纵;操作) is not allowed. Views that include any of the following
constructs are not updatable and therefore require the use of an `INSTEAD OF` trigger for manipulation: 
```
•SET 
•DISTINCT 
•GROUP BY, ORDER BY, CONNECT BY 
•MODEL 
•START WITH 
•Subquery within a SELECT or containing the WITH READ ONLY clause 
•Collection expressions 
•Aggregate or analytic functions 
```
A trigger that has been created with the INSTEAD OF clause allows you to declare a view name to be acted
upon, and then once the specified event occurs, the trigger is fired, which causes the actual INSERT,
UPDATE, or DELETE statement to occur. The trigger body actually acts upon the real tables behind the
scenes using the values that have been specified in the action. 
The format for the `INSTEAD OF` trigger is the same as any other trigger with the addition of the
INSTEAD OF clause. You can see in the **Solution** to this recipe that an additional clause has been specified,
namely, `REFERENCING NEW AS NEW`. The `REFERENCING` clause can be used by triggers to specify how you 
want to prefix `:NEW` or `:OLD` values. This allows you to use any alias for `:NEW` or `:OLD`, so it is possible to 
reference a new value using `:blah.my_value` if you used the following clause when you declared your 
trigger: 
```sql
REFERENCING NEW AS BLAH 
```

Although there is no real magic at work behind an INSTEAD OF trigger, they do abstract some of the 
implementation details away from the typical user such that working with a view is no different from 
working with an actual table. 

summary:  
1. (the changes of view be reflected at basic table)  


## 5-5. Altering the Functionality of Applications

****Problem****
You want to modify a third-party application, but you are not in a position to change the source code. 
Either you are not allowed to change the source or you simply do not have access to make changes. 
As an example, let’s consider a form in one application used to create jobs within the JOBS table. You 
want to enhance the application so that mail is sent to all the administrative staff members when a new 
job is created. However, your company does not own the license to modify the source code of the 
application.

****Solution**** 
You can often use triggers to add functionality to an application behind the scenes, without modifying 
application code. Sometimes you have to think creatively to come up with a trigger or blend of triggers 
that accomplishes your goal.  
You can solve our example **Problem** by creating a trigger that will execute after an insert has been made 
on the JOBS table. This trigger will obtain the information regarding the job that was just created and 
send an e-mail containing that information to all administrative personnel. In the following trigger, 
some necessary information regarding the new job entry is obtained and processed by the SEND_EMAIL 
procedure, which in turn sends the mail. 
First, here is the code for the trigger: 
```sql
CREATE OR REPLACE TRIGGER send_job_alert 
  AFTER INSERT ON jobs 
  FOR EACH ROW 
DECLARE 
  to_address                    varchar2(50) := 'admin_list@mycompany.com'; 
  v_subject                     varchar2(100) := 'New job created: ' || :new.job_title; 
  v_message                     varchar2(2000); 
BEGIN 
 
  v_message := 'There has been a new job created with an ID of ' || :new.job_id ||  
               ' and a title of ' || :new.job_title || '.  The salary range is: ' || 
               :new.min_salary || ' – ' || :new.max_salary; 
   -- Initiate the send_email procedure 
  SEND_EMAIL(to_address, v_subject,  v_message); 
               
END; 
``` 
Next is the stored procedure that actually sends the e-mail: 

```sql
CREATE OR REPLACE PROCEDURE send_email(to_address IN VARCHAR2, 
                                        subject IN VARCHAR2, 
                                        message IN VARCHAR2) AS 
BEGIN 
   UTL_MAIL.send(sender => 'me@address.com', 
            recipients => to_address, 
               subject => subject, 
               message => message, 
             mime_type => 'text; charset=us-ascii'); 
END; 
```

A trigger has the ability to call any other PL/SQL named block as long as it is in the same schema or 
the schema that contains the trigger has the correct privileges to access the named block in the other 
schema. 

****How It Works****

The ability to use triggers for altering third-party applications can be extremely beneficial. Using a DML 
trigger on INSERT, UPDATE, or DELETE of a particular table is a good way to control what occurs with 
application data once a database event occurs. This technique will be transparent to any application 
users because the trigger would most likely be executed when the user saves a record via a button that is 
built into the application. 

Although creating database triggers to alter functionality can be beneficial, you must also be careful 
not to create a trigger that will have an adverse effect on the application. For instance, if you create a 
trigger that updates some data that has been entered and the application is expecting to do something 
different with the data, then the application may not work as expected. One way to remedy(vt.补救;治疗;纠正) this issue 
would be to create an autonomous transaction. Autonomous transactions ensure that an application 
continues to run even if a dependent body of code fails. In this case, an autonomous transaction could 
prevent a failed trigger from crashing an application. To learn more about using autonomous 
transactions, please refer to Recipe 2-13. 

Another issue that could arise is one where too many triggers are created on the same table for the 
same event. You must be careful when creating triggers and be aware of all other triggers that will be 
executed during the same event. By default, Oracle does not fire triggers in any specific order, and the 
execution order can vary each time the database event occurs. Do not create triggers that depend upon 
other triggers, because your application will eventually fail! If you must create two or more triggers that 
execute on the same table for the same event, then please ensure that you are using proper techniques 
to make the triggers execute in the correct order. For more information on this topic, please refer to 
Recipe 5-11. 

The trigger in this particular recipe called a stored procedure. This was done so that the trigger body 
performed a specific task and remained concise. Triggers can call as many stored procedures as 
required, as long as the trigger itself is less than or equal to 32KB in size. The stored procedure in the 
**Solution** to this recipe is used to send an e-mail. As such, maintaining a separate procedure to perform 
the task of sending e-mail will allow the trigger body to remain concise, and the procedure can also be 
used elsewhere if needed. 
USING ORACLE’S UTL_MAIL PACKAGE 
The e-mail in the **Solution** to this recipe is sent using Oracle’s UTL_MAIL package. You will learn more 
about using this package in a later chapter, but for the purposes of testing this recipe, it is important to 
know that the UTL_MAIL package is not enabled by default. To install it, you must log in as the SYS user 
and execute the utlmail.sql and prvtmail.plb scripts that reside within the 
`$ORACLE_HOME/rdbms/admin` directory.  
An outgoing mail server must also be defined by setting the SMTP_OUT_SERVER initialization parameter 
prior to use.

summary:  
1. You must be careful when creating triggers and be aware of all other triggers that will be executed during the same event,Do not create triggers that depend upon 
other triggers
2. triggers invoked no order
3. `UTL_MAIL` PACKAGE is good tool send out mail

## 5-6. Validating Input Data 

****Problem**** 
You want to validate data before allowing it to be inserted into a table. If the input data does not pass 
your business-rules test, you want the INSERT statement to fail. For example, you want to ensure that an 
e-mail address field in the EMPLOYEE table never contains the domain portion of an e-mail address, in 
other words, that it never contains the @ character or anything following the @ character. 

■ Note Recipe 5-7 presents an alternative **Solution** to this same **Problem** that involves silently cleansing erroneous 
data as it is inserted.  

****Solution****
Generally speaking, do validation using BEFORE triggers, because that lets you trap(vt.诱捕;使…受限制) errors prior to changes 
being made to the data. For this recipe, you can write a BEFORE INSERT trigger to examine the e-mail 
address for any new employee. Raise an error if that address contains an @ character. The following 
example demonstrates a trigger that uses this technique. If an attempt to enter an invalid e-mail address 
occurs, an error will be raised. 
```sql
CREATE OR REPLACE TRIGGER check_email_address 
BEFORE INSERT ON employees 
FOR EACH ROW 
BEGIN 
  IF NOT INSTR(:new.email,'@') > 0 THEN 
    RAISE_APPLICATION_ERROR(-20001, 'INVALID EMAIL ADDRESS'); 
  END IF; 
END; 
```

****How It Works**** 
A BEFORE INSERT trigger is useful for performing the validation of data before it is inserted into the 
database. In the **Solution** to this recipe, a trigger is created that will check to ensure that a string that 
supposedly(adv.可能;按照推测) contains an e-mail address does indeed have an @ character within it. The trigger uses the 
Oracle built-in `INSTR` function inside a conditional statement to determine whether the @ character 
exists. If the character does not exist within the string, then the trigger will raise a user-defined error 
message. On the other hand, if the string does contain the character, then the trigger will not do 
anything. Coding a trigger for validation of data is quite common. Although the **Solution** to this recipe checks 
to ensure that an e-mail address is valid, you could write similar triggers to perform similar validation on 
other datatypes. 

## 5-7. Scrubbing(v.用力擦洗) Input Data 

****Problem**** 
You are interested in examining(检查) and correcting user input prior to it being inserted into a database table.  

****Solution****
Use a BEFORE INSERT trigger to scrub the data prior to allowing it to be inserted into the table. By using a 
trigger, you will have access to the data before it is inserted, which will provide you with the ability to 
assess the data before it is persisted.  
In this particular example, a trigger is being used to examine the data that was entered on a form for 
insertion into the EMPLOYEES table. The e-mail field is being validated to ensure that it is in a valid format. 
In particular, the e-mail field for the EMPLOYEES table includes only the address portion(n.部分;一份) to the left of the @ 
symbol. This trigger ensures that even if someone had entered the entire e-mail address, then only the 
valid portion would be inserted into the database. The following example demonstrates this 
functionality: 
```sql
CREATE OR REPLACE TRIGGER check_email_address 
BEFORE INSERT ON employees 
FOR EACH ROW 
DECLARE 
  temp_email              employees.email%TYPE := :new.email; 
BEGIN 
  IF INSTR(temp_email,'@') > 0 THEN 
    temp_email := SUBSTR(:new.email, 0, INSTR(temp_email, '@')-1); 
  END IF; 
 :new.email := temp_email; 
END; 
```

The trigger in this example uses a couple of different PL/SQL built-in functions to ensure that the 
data being inserted into the EMPLOYEES.EMAIL table is formatted correctly.

****How It Works****

BEFORE INSERT triggers work very nicely for verifying data prior to inserting it into the database. Since 
insert triggers have access to the `:NEW` qualifier, the values that are going to be inserted into the database 
table can be tested to ensure that they conform(vi.符合;遵照) to the proper standards and can then be manipulated(v.操作) if 
need be. When used in a BEFORE trigger, the `:NEW` value can be altered, allowing triggers to change values 
prior to when they are inserted. The `:OLD` qualifier will allow one to access the `NULL` old values, but they 
cannot be changed. 

Validating data with triggers can be very useful if used appropriately. As a rule of thumb, you should 
not attempt to create triggers for validating data that can be performed declaratively. For instance, if you 
need to ensure that a column of data is never NULL, then you should place a NOT NULL constraint on that 
column.There are only a couple of circumstances where you are required to enforce(vt. 实施，执行；强迫，强制) constraints within 
triggers, and those are as follows: 
• If you do not have access to the database objects to alter the table and add constraints because doing so would cause issues with a program that is in place 
• If the business logic cannot be reflected in a simple, declarative trigger 
• If your application requires a constraint to be enforced only part of the time
 
In all other circumstances, try to use database-level constraints because that is their job, and it can 
be done much more efficiently than using a trigger. However, trigger validation is perfect for situations 
such as those depicted in the **Solution** to this recipe, where complex business rules must be validated 
that are not possible with built-in constraints.

summary:  
1. above three rules must be clear
2. `INSTR`'s functionality
3. try to use database-level constraints because that is their job, and it can be done much more efficiently than using a trigger


## 5-8. Replacing a Column’s Value 

****Problem****
You want to verify that a column value is in the correct format when it is entered into the database.  If it 
is not in the correct format, then you want to adjust the value so that it is in the correct format before 
inserting into the database. For example, upon creation of an employee record, it is essential that the e-
mail address follows a certain format.  If the e-mail address is not uniform with other employee e-mail 
addresses, then it needs to be adjusted.  You want to write a trigger that ensures that the new employee 
EMAIL value will be in the correct format. 

****Solution**** 
Check the format using a BEFORE trigger. For this recipe, use a BEFORE INSERT trigger to determine 
whether the new EMAIL value is in the correct format.  If it is not, then adjust the value accordingly so that 
the new e-mail address will start with the first letter of the employee’s first name, followed by the 
employee’s last name.  If the new e-mail address is not unique, then a number must be added to the end 
of it to ensure that it will be unique. 
The following trigger demonstrates a BEFORE INSERT trigger that checks and updates the EMAIL value 
as described. This trigger will be fired whenever someone inserts values into the EMPLOYEES table. 

```sql
CREATE OR REPLACE TRIGGER populate_emp_email 
BEFORE INSERT ON employees 
FOR EACH ROW 
DECLARE 
  email_count          NUMBER := 0; 
  success_flag         BOOLEAN := FALSE; 
  temp_email           employees.email%TYPE; 
  email_idx            NUMBER := 0; 
BEGIN 
  -- check to see if the email address is in the correct format 
  IF :new.email != UPPER(SUBSTR(:new.first_name,0,1) || :new.last_name) THEN   --- more like linux style
    -- check the database to ensure that the new email address will be unique 
    temp_email := UPPER(SUBSTR(:new.first_name,0,1) || :new.last_name); 
    WHILE success_flag = FALSE LOOP 
        SELECT COUNT(*) 
        INTO email_count 
        FROM employees 
        WHERE email = temp_email; 
         
        -- if it is unique then end the loop 
        IF email_count = 0 THEN 
          success_flag := TRUE; 
        -- if not unique, then add the index number to the end and check again 
        ELSE 
          temp_email := UPPER(SUBSTR(:new.first_name,0,1) || :new.last_name) || email_idx; 
        END IF; 
        email_idx := email_idx + 1; 
    END LOOP; 
    :new.email := temp_email; 
  END IF; 
 
END; 
```

The value of the e-mail address must always follow the same format, and this trigger ensures that 
the any new EMAIL values will follow that format. If the new EMAIL value does follow the correct format, 
then it will be inserted into the database without changes, but if it does not follow the correct format, 
then this trigger will adjust the value accordingly. 

****How It Works**** 
Another frequent usage of triggers is to replace a value that someone is trying to insert into the database 
with some other value. Much like ensuring data integrity, you must write to the :NEW qualifier value in 
order to replace another value that was entered. When the :NEW value is overwritten, then that new value 
is inserted into the database instead of the original value. The BEFORE trigger acts as an interceptor where 
the values that are entered are intercepted prior to reaching the database table. The trigger has full reign 
to change values as needed as long as the values that are changed by the trigger still maintain the 
necessary requirements to meet the database table constraints that have been defined. 
Any DML trigger can include multiple trigger events, including INSERT, UPDATE, or DELETE events. Any 
combination of these three events can be used to fire a trigger. The events that are to be used for firing a 
trigger must be listed with the OR keyword between them. The following line of code is an example of 
using all three events on a BEFORE trigger: 

```sql
BEFORE INSERT OR UPDATE OR DELETE ON employees 
```

The events can be in any order within the BEFORE clause. Any combination of these three events can 
also be used with the AFTER trigger. The main difference between the BEFORE and AFTER triggers is what 
type of access each has to the :NEW and :OLD qualifiers. Table 4-1 lists the different types of triggers and 
their subsequent access to the qualifiers. 
Table 4-1. 

```sql
Trigger Types and Qualifier Acccess 
Trigger Type :NEW :OLD 
BEFORE Writeable Always contains NULL 
AFTER Not writeable  Always contains populated values 
INSERT Contains values  Contains NULL 
DELETE Contains NULL  Contains populated values 
UPDATE Contains populated values Contains populated values 
```

A BEFORE trigger has write access to values using the :NEW qualifier, and AFTER triggers do not since 
the data has already been inserted or updated in the table. INSERT triggers have meaningful access to 
values with the :NEW qualifier only; variables using the :OLD qualifier will be NULL. UPDATE triggers have 
meaningful access to values using both the :NEW and :OLD qualifiers. DELETE triggers have meaningful 
access only to values using the :old qualifier; values using the :new qualifier will be NULL. 
Performing tasks such as replacing values with triggers should be used only on an as-needed basis. 
This type of trigger can cause confusion for those who do not have access to the trigger code. It is also 
important to ensure that triggers do not act upon each other in order to avoid mutating table errors. This 
can occur if one trigger is updating the values of a table and another trigger is attempting to examine the 
values of the table at the same time.

summary:  
1. BEFORE trigger has write access,  AFTER triggers do not
2. DELETE triggers have meaningful access only to values using the :old qualifier; values using the :new qualifier will be NULL
3. INSERT triggers have meaningful access to values with the :NEW qualifier only; variables using the :OLD qualifier will be NULL
4. UPDATE triggers have meaningful access to values using both the :NEW and :OLD qualifiers

## 5-9. Triggering on a System Event 

****Problem**** 
You want to write a trigger that executes on a system event such as a login. For example, you want to 
increase security a bit for your database and ensure that users are logging into the database only during 
the week. In an effort to help control security, you want to receive an e-mail alert if someone logs into 
the database on the weekend. 

****Solution****
Create a system-level trigger that will log an event into a table if anyone logs into the database during off-
hours. To notify you as promptly as possible, it may also be a good idea to send an e-mail when this 
event occurs. To create a system-level trigger, use the AFTER LOGON ON DATABASE clause in your trigger 
definition. 
The first step in creating this **Solution** is to create an audit table. In the audit table you will want to 
capture the IP address of the user’s machine, the time and date of the login, and the authenticated 
username. The following code will create a table to hold this information: 
```sql
CREATE TABLE login_audit_table( 
ID                        NUMBER PRIMARY KEY,   -- Populated by sequence number 
login_audit_seq 
AUDIT_DATE                DATE NOT NULL, 
AUDIT_USER          VARCHAR2(50) NOT NULL, 
AUDIT_IP            VARCHAR2(50) NOT NULL, 
AUDIT_HOST          VARCHAR2(50) NOT NULL); 
```
Now that the auditing table has been created, it is time to create the trigger. The following code 
demonstrates the creation of a logon trigger: 
```sql
CREATE OR REPLACE TRIGGER login_audit_event 
AFTER LOGON ON DATABASE 
DECLARE 
  v_subject                      VARCHAR2(100) := 'User login audit event triggered'; 
  v_message                      VARCHAR2(1000); 
BEGIN 
  INSERT INTO login_audit_table values( 
    Login_audit_seq.nextval, 
    Sysdate, 
    SYS_CONTEXT('USERENV','SESSION_USERID'), 
    SYS_CONTEXT('USERENV','IP_ADDRESS'), 
    SYS_CONTEXT('USERENV','HOST')); 
    v_message := 'User ' || SYS_CONTEXT('USERENV','SESSION_USERID') || 
                           ' logged into the database at ' || sysdate || ' from host ' ||  
                SYS_CONTEXT('USERENV','HOST'); 
 
 
    SEND_email('DBA-GROUP@mycompany.com', 
                        v_subject, 
                        v_message); 
 
END; 
```

This simple trigger will fire each time someone logs into the database. To reduce the overhead of 
this trigger being initiated during normal business hours, this trigger should be disabled during normal 
business hours. It is possible to create a stored procedure that disables and enables the trigger and then 
schedule that procedure to be executed at certain times. However, if there are only a few users who will 
be logging into the database each day, then trigger controls such as these are not necessary. 

****How It Works****
Triggers are a great way to audit system events on a database. There are several types of system triggers: 
```sql
• AFTER STARTUP 
• BEFORE SHUTDOWN 
• AFTER LOGON 
• BEFORE LOGOFF 
• AFTER SUSPEND 
• AFTER SERVERERROR 
• AFTER DB_ROLE_CHANGE 
```
Each of these system events can be correlated to a trigger when the trigger includes the ON DATABASE 
clause, as shown here: 

```sql
CREATE OR REPLACE system_trigger 
trigger_type ON DATABASE 
…   
```
System triggers fire once for each correlating system event that occurs. Therefore, if there is a system 
trigger defined for both the LOGON and LOGOFF events, each will be fired one time for every user who logs 
onto or off the database. System triggers are excellent tools for helping audit database system events. 
Notice that the different system events have access only to certain types of events. For instance, STARTUP 
triggers can be fired only after the event occurs. This is because the Oracle Database is not available 
before STARTUP, so it would be impossible to fire a trigger beforehand. Similarly, SHUTDOWN triggers have 
access to the BEFORE event only because the database is unavailable after SHUTDOWN. 
In the **Solution** to this recipe, the trigger is intended to execute once after each login to the database. 
The trigger will insert some values from the current session into an auditing table, and it will send an e-
mail to the DBA group. It should be noted that Oracle Database provides some auditing capabilities to 
perform similar activities right out of the box. In fact, Oracle 11g turns on auditing by default for every 
database. However, the auditing options that are available via Oracle do not allow for sending e-mail as 
our **Solution** does. You may prefer to use Oracle’s internal auditing features for storing the audit trail and 
combine them with auditing triggers such as the one in this recipe for simply sending an e-mail when 
the event occurs. 
The SERVERERROR event is fired whenever an Oracle server error occurs. The SERVERERROR event can 
be useful for detecting user SQL errors or logging system errors. However, there are a few cases in which 
an Oracle server error does not trigger this event. Those Oracle errors are as follows: 

```sql
• ORA-01403:  No data found 
• ORA-01422:  Exact fetch returns more than requested number of rows 
• ORA-01423:  Error encountered while checking for extra rows in exact fetch 
• ORA-01034:  ORACLE not available 
• ORA-04030:  Out of process memory when trying to allocate bytes 
``` 
System event triggers can assist a DBA in administration of the database. These triggers can also 
help developers if SQL errors are triggering SERVERERROR events and notifying of possible SQL **Problem**s 
in the application. 

summary:  
1. System triggers are excellent tools for helping audit database system events
2. the different system events have access only to certain types of events
3. SHUTDOWN triggers have access to the BEFORE event only because the database is unavailable after SHUTDOWN
4. oracle contains itself audit subsystem that us powerful


## 5-10. Triggering on a Schema-Related Event 

****Problem**** 
You want to trigger on an event related to a change in a database schema. For example, if someone drops 
a database table on accident, it could cause much time and grief attempting to restore and recover data 
to its original state. Rather than doing so, you want to place a control mechanism into the database that 
will ensure that administrators cannot delete essential tables. 

****Solution**** 
Use a PL/SQL database trigger to raise an exception and send an alert to the DBA if someone attempts to
drop a table. This will prevent any tables from inadvertently being dropped, and it will also allow the
administrator to know whether someone is potentially trying to drop tables. 

```sql
CREATE OR REPLACE TRIGGER ddl_trigger
BEFORE CREATE OR ALTER OR DROP 
ON SCHEMA 
DECLARE 
  evt              VARCHAR2(2000); 
  v_subject        VARCHAR2(100) := 'Drop table attempt'; 
  v_message        VARCHAR2(1000);
BEGIN 
  SELECT ora_sysevent 
  INTO evt 
  FROM dual; 
  IF evt = 'DROP' THEN 
   RAISE_APPLICATION_ERROR(-20900, 'UNABLE TO DROP TABLE, ' || 
           'EVENT HAS BEEN LOGGED'); 
  END IF; 
  v_message := 'Table drop attempted by: '||  
    SYS_CONTEXT('USERENV','SESSION_USERID'); 
  SEND_EMAIL('DBA-GROUP@mycompany.com', 
             v_subject, 
             v_message);
END;
```
In this situation, both the user who attempts to drop the table and the members of the DBA-GROUP
mailing list will be notified. 

****How It Works****
You can use triggers to log or prevent certain database activities from occurring. In this recipe, you saw
how to create a trigger that will prevent a table from being dropped. The trigger will be executed prior to
any CREATE, ALTER, or DROP within the current schema. Within the body of the trigger, the event is checked
to see whether it is a DROP, and actions are taken if so.  
■ Note To be even more fine-grained, it is possible to specify a particular schema for the trigger to use.  Doing so
would look like the following: 

```sql
BEFORE CREATE ALTER OR DROP ON HR.SCHEMA 
… 
```

There are several other DDL trigger operations that can be used to help administer a database or 
application. The following are these operations along with the type of trigger that can be used with it: 

```sql
BEFORE / AFTER ALTER 
BEFORE / AFTER ANALYZE 
BEFORE / AFTER ASSOCIATE STATISTICS 
BEFORE / AFTER AUDIT 
BEFORE / AFTER COMMENT 
BEFORE / AFTER CREATE 
BEFORE / AFTER DDL 
BEFORE / AFTER DISASSOCIATE STATISTICS 
BEFORE / AFTER DROP 
BEFORE / AFTER GRANT 
BEFORE / AFTER NOAUDIT 
BEFORE / AFTER RENAME 
BEFORE / AFTER REVOKE 
BEFORE / AFTER TRUNCATE 
AFTER SUSPEND 
```

All DDL triggers can be fired using either BEFORE or AFTER event types. In most cases, triggers that are 
fired before a DDL event occurs are used to prevent the event from happening. On the other hand, 
triggers that are fired after an event occurs usually log information or send an e-mail. In the **Solution** to 
this recipe, a combination of those two situations exists. The BEFORE event type was used because the 
trigger is being used to prevent the tables from being dropped. However, logging or e-mailing can also 
occur to advise interested parties of the event. Typically a logging event occurs with an AFTER trigger so 
that the event has already occurred and the database is in a consistent state prior to the logging. 

## 5-11. Firing Two Triggers on the Same Event 

****Problem**** 
There is a requirement to create a trigger to enter the SYSDATE into the HIRE_DATE column of the 
LOCATIONS table. However, there is already a trigger in place that is fired BEFORE INSERT on the table, and 
you do not want the two triggers to conflict. 

****Solution****
Use the FOLLOWS clause to ensure the ordering of the execution of the triggers. The following example 
shows the creation of two triggers that are to be executed BEFORE INSERT on the EMPLOYEES table.  
First, we’ll create a trigger to verify that a new employee’s salary falls within range: 
```sql 
CREATE OR REPLACE TRIGGER verify_emp_salary 
BEFORE INSERT ON employees 
FOR EACH ROW 
DECLARE 
  v_min_sal     jobs.min_salary%TYPE; 
  v_max_sal     jobs.max_salary%TYPE; 
BEGIN 
  SELECT min_salary, max_salary 
  INTO v_min_sal, v_max_sal 
  FROM JOBS 
  WHERE JOB_ID = :new.JOB_ID; 
 
  IF :new.salary > v_max_sal THEN 
    RAISE_APPLICATION_ERROR(-20901, 
       'You cannot give a salary greater than the max in this category'); 
  ELSIF :new.salary < v_min_sal THEN 
    RAISE_APPLICATION_ERROR(-20902, 
       'You cannot give a salary less than the min in this category'); 
  END IF; 
END; 
```
Next, you’ll create a trigger to force the hire date to be the current date: 
```sql
CREATE or REPLACE TRIGGER populate_hire_date 
BEFORE INSERT 
    ON employees 
    FOR EACH ROW 
FOLLOWS verify_emp_salary 
DECLARE 
BEGIN 
    :new.hire_date := sysdate; 
END; 
```
 
Since it does not make sense to change the hire date if the record will not be inserted, you want the 
VERIFY_EMP_SALARY trigger to fire first. The FOLLOWS clause in the POPULATE_HIRE_DATE trigger ensures that 
this will be the case. 

****How It Works****
Oracle 11g introduced the `FOLLOWS` clause into the Oracle trigger that allows you to specify the ordering in 
which triggers should execute. The FOLLOWS clause specifies the trigger that should fire prior to the trigger 
being created. In other words, if you specify the FOLLOWS clause when creating a trigger, then you should 
name a trigger that you want to have executed prior to your new trigger. Hence, if you specify a trigger in 
the FOLLOWS clause that does not already exist, you will receive a compile error. 

■ Note The `PRECEDES`(v.领先(precede的三单形式);在…之先) clause was introduced in Oracle 11g as well. You can use this clause to specify the 
opposite situation that is resolved using the FOLLOWS clause. If you specify `PRECEDES` instead of `FOLLOWS`, then the 
trigger being created will fire prior to the trigger that you specify after the `PRECEDES` clause. 
By default, Oracle triggers fire in any arbitrary ordering. In the past, there was no way to guarantee 
the order in which triggers were to be executed. The addition of the `FOLLOWS` clause now allows you to do 
so. However, it is important that you do not make triggers dependent upon each other. Doing so could 
cause issues of one of the triggers were to be dropped for some reason. It is bad design to create a trigger 
that depends on the successful completion of another trigger, so the `FOLLOWS` clause should be used only 
in situations where there is no dependency. 

summary:  
1. if you wanna make sure two triggers keep up order to be executed, please use follow clause
2. dependent triggers is bad design



## 5-12. Creating a Trigger That Fires on Multiple Events

****Problem**** 
You have logic that is very similar for two different events. Thus, you want to combine that logic into a 
single trigger that fires for both. For example, let’s assume that we want to create a single trigger on the 
EMPLOYEES table with code to fire after each row that is inserted or modified and also with code to fire at 
the end of each of those statements’ executions. 

****Solution**** 
Use a compound(adj.复合的;混合的) trigger to combine all the triggers into a single body of code. The trigger in this **Solution** 
will execute based upon various timing points. It will execute AFTER EACH ROW in the EMPLOYEES table has 
been updated, as well as AFTER the entire update statement has been executed. The AFTER EACH ROW 
section of the trigger will audit the inserts and updates made on the table, and the AFTER STATEMENT 
section of the trigger will send notification to the DBA regarding audits that have occurred on the table. 
The following code shows the creation of a compound trigger that comprises(vt.包含;由…组成) each of these two 
triggers into one body of code: 

```sql 
CREATE OR REPLACE TRIGGER emp_table_auditing 
  FOR INSERT OR UPDATE ON employees 
    COMPOUND TRIGGER 
  -- Global variable section 
  table_upd_count       NUMBER := 0; 
  table_id_start        employees.employee_id%TYPE; 
 
  AFTER EACH ROW IS 
  BEGIN 
    SELECT MAX(employee_id) 
    INTO table_id_start 
    FROM employees; 
 
    IF INSERTING THEN 
      
      INSERT INTO update_access_log VALUES( 
        update_access_seq.nextval, 
        SYS_CONTEXT('USERENV','SESSION_USER'), 
        sysdate, 
        NULL, 
        :new.salary, 
        'EMPLOYEES - INSERT', 
        'SALARY'); 
      table_upd_count := table_upd_count + 1; 
 
 
    ELSIF UPDATING THEN 
      IF :old.salary != :new.salary THEN 
        INSERT INTO update_access_log VALUES( 
          update_access_seq.nextval, 
          SYS_CONTEXT('USERENV','SESSION_USER'), 
          sysdate, 
          :old.salary, 
          :new.salary, 
          'EMPLOYEES - UPDATE', 
          'SALARY'); 
        table_upd_count := table_upd_count + 1; 
      END IF; 
    END IF;    
 
  END AFTER EACH ROW; 
 
  AFTER STATEMENT IS 
    v_subject                     VARCHAR2(100) := 'Employee Table Update'; 
    v_message                     VARCHAR2(2000); 
  BEGIN 
         
    v_message := 'There have been ' || table_upd_count || 
     ' changes made to the employee table starting with ID #' || 
     table_id_start; 
 
    SEND_EMAIL('DBA-GROUP@my_company.com', 
               v_subject, 
               v_message); 
  END AFTER STATEMENT; 
 
END emp_table_auditing; 

``` 
The insert and update events are audited via the trigger that is coded using the AFTER EACH ROW 
clause, and then the AFTER STATEMENT trigger sends a notification to alert the DBA of each audit. The two 
triggers share a global variable that is declared prior to the code for the first trigger. 

****How It Works****

Prior to Oracle 11g, there was no easy way to create multiple triggers that were able to share the same global 
variable. The compound trigger was introduced with the release of Oracle 11g, and it allows multiple triggers for 
the same table to be embodied within a single trigger. Compound triggers allow you to code different timing 
points within the same trigger; those different events are as follows in logical execution order: 
```sql
• BEFORE STATEMENT 
• BEFORE EACH ROW 
• AFTER EACH ROW 
• AFTER STATEMENT 
```
Each of these timing points allows for the declaration of different trigger execution points. Using a 
compound trigger allows you to create a trigger that performs some actions: BEFORE INSERT on a table 
and AFTER INSERT on a table all within the same trigger body. In the case of the **Solution** to this recipe, an 
AFTER UPDATE trigger is coded within the same compound trigger as an AFTER STATEMENT trigger. The 
logical order of execution allows you to code triggers that depend upon others using this technique. In 
other recipes within this chapter, you have learned that it is not good programming practice to code 
triggers that depend upon each other. This is mainly because if one trigger is invalidated or dropped, 
then the other trigger that depends on it will automatically be invalidated. Since a compound trigger is 
one body of code, either the entire trigger is valid or invalid. Therefore, the failure points between two 
trigger bodies are removed.  
In the **Solution**, the AFTER STATEMENT trigger depends upon the AFTER EACH ROW trigger. If the AFTER 
EACH ROW trigger does not audit anything, then the AFTER STATEMENT trigger will still fire, but it will send 
an e-mail that signifies zero rows have been changed. The two trigger bodies are able to share access to 
global variables, types, and cursors via the use of the global declaration section. Anything declared 
within this section is visible to all triggers within the compound trigger body, so in the case of this 
**Solution**, you can use the first AFTER EACH ROW to update the value of the global variable, which is then in 
turn used within the AFTER STATEMENT trigger. The overall compound trigger structure is as follows: 
 
```sql
CREATE OR REPLACE TRIGGER trigger_name 
   FOR trigger_action ON table_name 
     COMPOUND TRIGGER 
    -- Global declaration section 
   global_variable VARCHAR2(10); 
  BEFORE STATEMENT IS 
  BEGIN 
     NULL; 
 -- Statements go here. 
  END BEFORE STATEMENT; 
  
  BEFORE EACH ROW IS 
  BEGIN 
    NULL; 
-- Statements go here.   
  END BEFORE EACH ROW; 
  
  AFTER EACH ROW IS  
  BEGIN 
     NULL; 
-- Statements go here. 
  END AFTER EACH ROW; 
  
  AFTER STATEMENT IS 
  BEGIN 
    NULL; 
 -- Statements go here. 
  END AFTER STATEMENT; 
  
  END trigger_name;  
```
Compound triggers can be very useful for incorporating several different timed(different stage data change) events on the same 
database table. Not only do they allow for easier maintenance because all code resides within one trigger 
body, but they also allow for shared variables among the trigger events as well as more robust 
dependency management. 

## 5-13. Creating a Trigger in a Disabled State 

****Problem**** 
After a planning meeting, your company has decided that it would be a great idea to create a trigger to 
send notification of updates to employee salaries. Since the trigger will be tied into the system-wide k
database application, you want to ensure that it compiles before enabling it so that it will not affect the 
rest of the application.  

****Solution**** 
Create a trigger that is in a disabled state by default. This will afford you the opportunity to ensure that 
the trigger has compiled successfully before you enable it. Use the new DISABLE clause to ensure that 
your trigger is in DISABLED state by default. 
The following trigger sends messages to employees when their salary is changed. The trigger is 
disabled by default to ensure that the application is not adversely affected if there is a compilation error. 

```sql
CREATE OR REPLACE TRIGGER send_salary_notice 
AFTER UPDATE OF SALARY ON employees 
FOR EACH ROW 
DISABLE 
DECLARE 
  v_subject     VARCHAR2(100) := 'Salary Update Has Occurrred'; 
  v_message     VARCHAR2(2000); 
BEGIN 
  v_message := 'Your salary has been increased from ' || 
             :old.salary || ' to ' || :new.salary || '.'  || 
             'If you have any questions or complaints, please ' || 
             'do not contact the DBA.'; 
 
  SEND_EMAIL(:new.email || '@mycompany.com', 
             v_subject, 
             v_message); 
END;   
```
On an annual basis, this trigger can be enabled via the following syntax: 

```sql
ALTER TRIGGER send_salary_notice ENABLE; 
```

It can then be disabled again using the same syntax: 
```sql 
ALTER TRIGGER send_salary_notice DISABLE; 
```

****How It Works**** 
Another welcome new feature with Oracle 11g is the ability to create triggers that are DISABLED by default. 
The syntax for creating a trigger in this fashion is as follows: 

```sql
CREATE OR REPLACE TRIGGER trigger_name 
ON UPDATE OR INSERT OR DELETION OF table_name 
[FOR EACH ROW] 
DISABLED 
DECLARE 
  -- Declarations go here. 
BEGIN 
  -- Statements go here. 
END; 
```
The new DISABLED clause is used upon creation of a trigger. By default, a trigger is ENABLED by creation, 
and this clause allows for the opposite to hold true.