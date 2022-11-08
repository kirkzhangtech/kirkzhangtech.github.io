---
title: Oracle PLSQL Recipes 11-Automating Routine Tasks
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


# 11. Automating Routine Tasks 
Oracle provides methods to schedule one-time and recurring jobs within the database, which is 
beneficial when you want to automate repetitive tasks and run them at times when a DBA may not be 
available. This chapter provides recipes to help you get started scheduling jobs (especially PL/SQL jobs), 
capturing output, sending e-mail notifications, and keeping data in sync with other databases. 

## 11-1. Scheduling Recurring Jobs 
**Problem** 
You want to schedule a PL/SQL procedure to run at a fixed time or at fixed intervals. 
**Solution** 
Use the EXEC DBMS_SCHEDULER.CREATE_JOB procedure to create and schedule one-time jobs and jobs that 
run on a recurring schedule. Suppose, for example, that you need to run a stored procedure named 
calc_commissions every night at 2:30 a.m. to calculate commissions based on the employees’ salaries. 
Normally, commissions would be based on sales, but the default HR schema doesn’t provide that table, 
so we’ll use an alternate calculation for demonstration purposes: 
```sql
EXEC DBMS_SCHEDULER.CREATE_JOB (               - 
           JOB_NAME=>'nighly_commissions',     - 
           JOB_TYPE=>'STORED_PROCEDURE',       - 
         JOB_ACTION=>'calc_commisions',        - 
            ENABLED=>TRUE,                     - 
    REPEAT_INTERVAL=>'FREQ=DAILY;INTERVAL=1;BYHOUR=02;BYMINUTE=30');
```

**How It Works** 
The DBMS_SCHEDULER.CREATE_JOB procedure sets up a nightly batch job. JOB_NAME must be unique. The 
JOB_TYPE, in this example, is STORED_PROCEDURE. This informs the scheduler the job is a PL/SQL procedure 
stored in the database. In addition to scheduling a stored procedure, the scheduler can also execute a 
PL/SQL_BLOCK, an external EXECUTABLE program, or a job CHAIN. See Recipe 11-6 for an example on 
scheduling job chains. 
The JOB_ACTION identifies the stored procedure to run. If the procedure is owned by another 
schema, then include the schema name, for example, HR.calc_commission. If the procedure is part of a 
larger package, include that as well, for example, HR.my_package.calc_commission. 
ENABLED is set to TRUE to tell the scheduler to run at the next scheduled time. By default, the ENABLED 
parameter is FALSE and would require a call to the DBMS_SCHEDULER.ENABLE procedure to enable the job. 
The REPEAT_INTERVAL is an important part of the CREATE_JOB routine. It identifies the frequency, in 
this case DAILY. The INTERVAL tells scheduler to run the job every day, as opposed to 2 or 3, which would 
run every other day, or every third day. The BYHOUR and BYMINUTE sections specifies the exact time of the 
day to run. In this example, the job will run at 2:30 a.m. 
The scheduled job, nightly_commissions, runs the stored procedure calc_commission, which reads 
the data, calculates the commission, and stores the commission records. Running this job nightly keeps 
the employees’ commission data current with respect to daily sales figures. 

## 11-2. E-mailing Output from a Scheduled Job 
**Problem** 
You have a scheduled job that runs a stored procedure at a regular interval. The procedure produces 
output that ordinarily would be sent to the screen via the DBMS_OUTPUT.PUT_LINE procedure, but since it 
runs as a nightly batch job, you want to send the output to a distribution list as an e-mail message. 
**Solution** 
Save the output in a CLOB variable and then send it to the target distribution list using the 
UTL_MAIL.SEND procedure. For example, suppose you want to audit the employee table periodically to 
find all employees who have not been assigned to a department within the company. Here’s a procedure 
to do that: 
```sql
CREATE OR REPLACE PROCEDURE employee_audit AS 
 
CURSOR    driver IS    -- find all employees not in a department 
SELECT    employee_id, first_name, last_name 
FROM      employees 
WHERE     department_id is null 
ORDER BY  last_name, first_name; 
 
buffer        CLOB := null; -- the e-mail message 
 
BEGIN 
 
   FOR rec IN driver LOOP    -- generate the e-mail message 
      buffer := buffer  || 
        rec.employee_id || ' '  || 
        rec.last_name   || ', ' || 
        rec.first_name  || chr(10); 
   END LOOP; 
 
--    Send the e-mail 
   IF buffer is not null THEN -- there are employees without a department 
      buffer := 'Employees with no Department' || CHR(10) || CHR(10) || buffer; 
 
      UTL_MAIL.SEND ( 
              SENDER=>'someone@mycompany.com', 
          RECIPIENTS=>'audit_list@mycompany.com', 
             SUBJECT=>'Employee Audit Results', 
             MESSAGE=>buffer); 
   END IF; 
 
END;
```
**How It Works** 
The procedure is very straightforward in that it finds all employees with no department. When run as a 
scheduled job, calls to DBMS_OUTPUT.PUT_LINE won’t work because there is no “screen” to view the output. 
Instead, the output is collected in a CLOB variable to later use in the UTL_MAIL.SEND procedure. The key to 
remember in this recipe is there is no screen output from a stored procedure while running as a 
scheduled job. You must store the intended output and either write it to an operating system file or, as in 
this example, send it to users in an e-mail. 

## 11-3. Using E-mail for Job Status Notification 
**Problem** 
You have a scheduled job that is running on a regular basis, and you need to know whether the job fails 
for any reason. 
**Solution** 
Use the ADD_JOB_EMAIL_NOTIFICATION procedure to set up an e-mail notification that sends an e-mail 
when the job fails to run successfully. Note, this **Solution** builds on Recipe 11-1 where a nightly batch job 
was set up to calculate commissions. 
```sql
EXEC DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (    - 
      JOB_NAME=>'nightly_commissions', - 
    RECIPIENTS=> 'me@my_company.com,dist_list@my_company.com'); 
```
**How It Works** 
The previous recipe is the simplest example of automating e-mail in the event a job fails. The 
ADD_JOB_EMAIL_NOTIFICATION procedure accepts several parameters; however, the only required 
parameters are JOB_NAME and RECIPIENTS. The JOB_NAME must already exist from a previous call to the 
CREATE_JOB procedure (see Recipe 11-1 for an example). The RECIPIENTS is a comma-separated list of e-
mail addresses to receive e-mail when an event occurs; by default the events that trigger an e-mail are 
JOB_FAILED, JOB_BROKEN, JOB_SCH_LIM_REACHED, JOB_CHAIN_STALLED, and JOB_OVER_MAX_DUR. Additional 
event parameters are JOB_ALL_EVENTS, JOB_COMPLETED, JOB_DISABLED, JOB_RUN_COMPLETED, JOB_STARTED, 
JOB_STOPPED, AND JOB_SUCCEEDED. 
The full format of the ADD_JOB_EMAIL_NOTIFICATION procedure accepts additional parameters, but 
the default for each is sufficient to keep tabs on the running jobs. The body of the e-mail will return the 
error messages required to debug the issue that caused the job to fail. 
To demonstrate the notification process, the commissions table was dropped after the job was set 
up to run. The database produced an e-mail with the following subject and body: 
 
SUBJECT: Oracle Scheduler Job Notification - HR.NIGHTLY_COMMISSIONS JOB_FAILED 
BODY: 
Job: JYTHON.NIGHTLY_COMMISSIONS 
Event: JOB_FAILED 
Date: 28-AUG-10 03.15.30.102000 PM US/CENTRAL 
Log id: 1118 
Job class: DEFAULT_JOB_CLASS 
Run count: 1 
Failure count: 1 
Retry count: 0 
Error code: 6575 
Error message: ORA-06575: Package or function CALC_COMMISSIONS is in an invalid state 

## 11-4. Refreshing a Materialized View on a Timed Interval 
**Problem** 
You have a materialized view that must be refreshed on a scheduled basis to reflect changes made to the 
underlying table. 
**Solution** 
First, create the materialized view with a CREATE MATERIALIZED VIEW statement. In this example, a 
materialized view is created consisting of the department and its total salary.: 
```sql
CREATE MATERIALIZED VIEW dept_salaries 
BUILD IMMEDIATE 
AS 
SELECT department_id, SUM(salary) total_salary 
FROM employees 
GROUP BY department_id; 
```
Display the contents of the materialized view: 
```sql
SELECT * 
FROM dept_salaries 
ORDER BY department_id; 
 
DEPARTMENT_ID TOTAL_SALARY 
------------- ------------ 
           10         6500 
           20        20200 
           30        43500 
           40         6500 
           50       297100 
           60        35000 
           70        10000 
           80       305600 
           90        58000 
          100        51600 
          110        20300 
                      7000 
```
Use the EXEC DBMS_REFRESH.MAKE procedure to set up a refresh of the materialized view: 
 
EXEC DBMS_REFRESH.MAKE ('HR_MVs', 'dept_salaries', SYSDATE, 'TRUNC(SYSDATE)+1'); 
 
Change the underlying data of the view.: 
 
UPDATE employees 
SET salary = salary * 1.03; 
 
COMMIT; 
 
Note that the materialized view has not changed: 
```sql
SELECT * 
FROM dept_salaries 
ORDER BY department_id; 
 
DEPARTMENT_ID TOTAL_SALARY 
------------- ------------ 
           10         6500 
           20        20200 
           30        43500 
           40         6500 
           50       297100 
           60        35000 
           70        10000 
           80       305600 
           90        58000 
          100        51600 
          110        20300 
                      7000 
```
Next, manually refresh the materialized view: 
```sql
EXEC DBMS_REFRESH.REFRESH ('HR_MVs'); 
```
The materialized view now reflects the updated salaries: 
```sql
SELECT * 
FROM dept_salaries 
ORDER BY department_id; 
 
DEPARTMENT_ID TOTAL_SALARY 
------------- ------------ 
           10         6695 
           20        20806 
           30        44805 
           40         6695 
           50       306013 
           60        36050 
           70        10300 
           80       314768 
           90        59740 
          100        53148 
          110        20909 
                      7210
```
**How It Works** 
The DBMS_REFRESH.MAKE procedure creates a list of materialized views that refresh at a specified time. 
Although you could schedule a job that calls the DBMS_REFRESH.REFRESH procedure to refresh the view, the 
MAKE procedure simplifies this automated task. In addition, once your refresh list is created, you can later 
add more materialized views to the schedule using the DBMS_REFRESH.ADD procedure. 
 The first argument of the DBMS_REFRESH.MAKE procedure specifies the name of this list; in this 
example, the list name is HR_MVs. This name must be unique among lists. The next parameter is a list of 
all materialized views to refresh. The procedure accepts either a comma-separated string of materialized 
view names or an INDEX BY table, each containing a view name. If the list contains a view not owned by 
the schema creating the list, then the view name must be qualified with the owner, for example, 
HR.dept_salaries. The third parameter specifies the first time the refresh will run. In this example, 
sysdate is used, so the refresh is immediate. The fourth parameter is the interval, which must be a 
function that returns a date/time for the next run time. This recipe uses 'TRUNC(SYSDATE)+1', which 
causes the refresh to run at midnight every night. 
In this example, the CREATE MATERIALIZED VIEW statement creates a simple materialized view of the 
total salary by departments, and the data is selected from the view to verify that it is populated with 
correct data.  
 Note After adding a 3 percent raise to each employee’s salary, we continue to see a materialized view that 
reflects the old data. The DBMS_REFRESH routine solves that Problem. 
Although the refresh list was created, the content of the materialized view remains unchanged until 
the automatic update, which occurs every night at midnight. After the refresh occurs, the materialized 
view will reflect all changes made to employee salary since the last refresh occurred. 
The manual call to DBMS_REFRESH.REFRESH demonstrates how the content of the materialized view 
changes once the view is refreshed. Without the call to the REFRESH procedure, the content of the 
materialized view remains unchanged until the next automated run of the REFRESH procedure. 

## 11-5. Synchronizing Data with a Remote Data Source 
**Problem** 
Your database instance requires data that is readily available in another Oracle instance but cannot be 
synchronized with a materialized view, and you do not want to duplicate data entry. 
**Solution** 
Write a procedure that creates a connection to the remote HR database and performs the steps needed 
to synchronize the two databases. Then use the EXEC DBMS_SCHEDULER.CREATE_JOB procedure to run the 
procedure on a regular basis. Suppose, for example, that your Oracle Database instance requires data 
from the HR employee table, which is in another instance. In addition, your employee table contains 
tables with foreign key references on the employee_id that prevents you from using a materialized view 
to keep the HR employee table in synchronization. 
Create a database connection to the remote HR database, and then download the data on a regular 
basis: 
```sql
CREATE DATABASE LINK hr_data 
CONNECT TO hr 
IDENTIFIED BY hr_password 
USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=node_name)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=hr_service_name)))'; 
 
CREATE OR REPLACE PROCEDURE sync_hr_data AS 
 
CURSOR    driver IS 
SELECT    * 
FROM    employees@hr_data; 
 
TYPE    recs_type IS TABLE OF driver%ROWTYPE INDEX BY BINARY_INTEGER; 
recs    recs_type; 
 
BEGIN 
 
   OPEN DRIVER; 
   FETCH DRIVER BULK COLLECT INTO recs; 
   CLOSE DRIVER; 
 
   FOR i IN 1..recs.COUNT LOOP 
      UPDATE employees 
      SET    first_name      = recs(i).first_name, 
        last_name            = recs(i).last_name, 
        email                = recs(i).email, 
        phone_number         = recs(i).phone_number, 
        hire_date            = recs(i).hire_date, 
        job_id               = recs(i).job_id, 
        salary               = recs(i).salary, 
        commission_pct       = recs(i).commission_pct, 
        manager_id           = recs(i).manager_id, 
        department_id        = recs(i).department_id 
      WHERE  employee_id     = recs(i).employee_id 
      AND    (    NVL(first_name,'~')  <> NVL(recs(i).first_name,'~') 
       OR    last_name                 <> recs(i).last_name 
       OR    email                     <> recs(i).email 
       OR    NVL(phone_number,'~')     <> NVL(recs(i).phone_number,'~') 
       OR    hire_date                 <> recs(i).hire_date 
       OR    job_id                    <> recs(i).job_id 
       OR    NVL(salary,-1)            <> NVL(recs(i).salary,-1) 
       OR    NVL(commission_pct,-1)    <> NVL(recs(i).commission_pct,-1) 
       OR    NVL(manager_id,-1)        <> NVL(recs(i).manager_id,-1) 
       OR    NVL(department_id,-1)     <> NVL(recs(i).department_id,-1) 
        ); 
   END LOOP; 
-- find all new rows in the HR database since the last refresh 
   INSERT INTO employees 
   SELECT * 
   FROM   employees@hr_data 
   WHERE  employee_id NOT IN ( 
    SELECT    employee_id 
    FROM      employees); 
END sync_hr_data; 
EXEC DBMS_SCHEDULER.CREATE_JOB (            - 
          JOB_NAME=>'sync_HR_employees',    - 
          JOB_TYPE=>'STORED_PROCEDURE',     - 
        JOB_ACTION=>'sync_hr_data',         - 
           ENABLED=>TRUE,                   - 
    REPEAT_INTERVAL=>'FREQ=DAILY;INTERVAL=1;BYHOUR=00;BYMINUTE=30');
```
**How It Works** 
A database link is required to access the data. This recipe focuses more on the synchronization process,
but the creation of the database link is demonstrated here. This link, when used, will remotely log into
the HR instance as the HR schema owner. 
The procedure sync_hr_data reads all records from the HR instances. It does so in a BULK COLLECT
statement, because this is the most efficient method to read large chunks of data, especially over a
remote connection. The procedure then loops through each of the employee records updating the local
records, but only if the data changed, because there is no need to issue the UPDATE unless something has
changed. The NVL is required in the WHERE clause to accommodate values that are NULL and change to a
non-NULL value, or vice versa. 
The final step is to schedule the nightly job. The CREATE_JOB procedure of the DBMS_SCHEDULER
package completes this recipe. The stored procedure sync_hr_data is executed nightly at 12:30 a.m. See
Recipe 11-1 for more information on scheduling a nightly batch job. 
## 11-6. Scheduling a Job Chain 
**Problem** 
You have several PL/SQL procedures that must run in a fixed sequence—some steps sequentially, others
in parallel. If one step fails, processing should stop. 
**Solution** 
Use the DBMS_SCHEDULER _CHAIN commands to create and define the order of execution of the chained
procedures. Figure 11-1 depicts a simple example of a chain of procedures where the successful
completion of step 1 kicks off parallel executions of two additional steps. When the two parallel steps
compete successfully, the final step runs. 
 
Figure 11-1. Flowchart representation of a job chain. 
The following code shows how you can use the CREATE_CHAIN, CREATE_PROGRAM, DEFINE_CHAIN_STEP, 
and DEFINE_CHAIN_RULE options to implement the order of execution shown in Figure 11-1. 
 
```sql
-- Define the Chain 
BEGIN 
   DBMS_SCHEDULER.CREATE_CHAIN ( 
    CHAIN_NAME    => 'Chain1'); 
END; 
 
-- Create/define the program to run in each step 
BEGIN 
   DBMS_SCHEDULER.CREATE_PROGRAM ( 
    PROGRAM_NAME    => 'Program1',   
    PROGRAM_TYPE    => 'STORED_PROCEDURE',   
    PROGRAM_ACTION  => 'Procedure1', 
    ENABLED         => true); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.CREATE_PROGRAM ( 
    PROGRAM_NAME    => 'Program2',   
    PROGRAM_TYPE    => 'STORED_PROCEDURE',   
    PROGRAM_ACTION  => 'Procedure2', 
    ENABLED         => true); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.CREATE_PROGRAM ( 
    PROGRAM_NAME    => 'Program3',   
    PROGRAM_TYPE    => 'STORED_PROCEDURE',   
    PROGRAM_ACTION  => 'Procedure3', 
    ENABLED         => true); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.CREATE_PROGRAM ( 
    PROGRAM_NAME    => 'Program4',   
    PROGRAM_TYPE    => 'STORED_PROCEDURE',   
    PROGRAM_ACTION  => 'Procedure4', 
    ENABLED         => true); 
END; 
 
-- Create each step using a unique name 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_STEP ( 
    CHAIN_NAME   => 'Chain1',   
    STEP_NAME    => 'Step1',   
    PROGRAM_NAME => 'Program1'); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_STEP ( 
    CHAIN_NAME   => 'Chain1',   
    STEP_NAME    => 'Step2_1',   
    PROGRAM_NAME => 'Program2'); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_STEP ( 
    CHAIN_NAME   => 'Chain1',   
    STEP_NAME    => 'Step2_2',   
    PROGRAM_NAME => 'Program3'); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_STEP ( 
    CHAIN_NAME   => 'Chain1',   
    STEP_NAME    => 'Step3',   
    PROGRAM_NAME => 'Program4'); 
END; 
 
-- Define the step rules; which step runs first and their order 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE ( 
    CHAIN_NAME   => 'Chain1', 
    CONDITION    => 'TRUE', 
    ACTION       => 'START Step1'); 
 
END; 
 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE ( 
    CHAIN_NAME   => 'Chain1', 
    CONDITION    => 'Step1 COMPLETED', 
    ACTION       => 'START Step2_1, Step2_2'); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE ( 
    CHAIN_NAME   => 'Chain1', 
    CONDITION    => 'Step2_1 COMPLETED AND Step2_2 COMPLETED', 
    ACTION       => 'START Step3'); 
END; 
 
BEGIN 
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE ( 
    CHAIN_NAME   => 'Chain1', 
    CONDITION    => 'Step3 COMPLETED', 
    ACTION       => 'END'); 
END; 
 
-- Enable the chain 
BEGIN 
   DBMS_SCHEDULER.ENABLE ('Chain1'); 
END; 
/ 
 
-- Schedule a Job to run the chain every night 
BEGIN 
   DBMS_SCHEDULE.CREATE_JOB ( 
    JOB_NAME        => 'chain1_Job', 
    JOB_TYPE        => 'CHAIN', 
    JOB_ACTION      => 'Chain1', 
    REPEAT_INTERVAL => 'freq=daily;byhour=3;byminute=0;bysecond=0', 
    enabled         => TRUE); 
END;
```
**How It Works** 
Defining and scheduling a job chain may seem daunting at first but can be broken down into the 
following steps: 
Create the chain. 
Define each program that will run. 
Create each step in the chain. 
Create the rules that link the chain together. 
Enable the chain. 
Schedule the chain as a job to run a specific time or interval. 
 
The DBMS_SCHEDULER.CREATE_CHAIN procedure creates a chain named as Chain1.  
 Note The chain_name must be unique and will be used in subsequent steps. 
The DBMS_SCHEDULER.CREATE_PROGRAM procedure defines the executable code that will run. The 
programs defined here are run when a chain step is executed. The procedure accepts the following 
parameters: 
• PROGRAM_NAME: A unique name to identify the program. 
• PROGRAM_TYPE : Valid values are plsql_block, stored_procedure, and executable. 
• PROGRAM_ACTION : Defines what code actually runs when executed based on the 
value for PROGRAM_TYPE. For a PROGRAM_TYPE of PLSQL_BLOCK, it is a text string of the 
PL/SQL code to run. For a STORED_PROCEDURE, it is the name of an internal PL/SQL 
procedure. For an EXECUTABLE, it is the name of an external program. 
• ENABLE : Determines whether the program can be executed; the default is FALSE if 
not specified. 
The DBMS_SCHEDULER.DEFINE_CHAIN_STEP procedure defines each step in the chain. You must supply 
the chain’s name as its first parameters, which was created in the DBMS_SCHEDULER.CREATE_CHAIN 
procedure, along with a unique name for the step in the chained process and the name of the PL/SQL 
program to execute during the step. Note that the program is the name assigned in the 
DBMS_SCHEDULER.CREATE_PROGRAM procedure; it is not the name of your PL/SQL program. 
The DBMS_SCHEDULER.DEFINE_CHAIN_RULE procedure defines how each step in the chain is linked 
together. Arguably, this is the most difficult step in the process because you must define the starting and 
ending steps in the chain properly. In addition, you must take care in defining links between sequential 
steps and parallel steps. Sketching a flow chart like the one shown in Figure 11-1 can aid in the 
sequencing of the chain steps. 
The DBMS_SCHEDULER.DEFINE_CHAIN_RULE procedure accepts the following parameters: 
• CHAIN_NAME: The name used when you created the chain. 
• CONDITION: An expression that must evaluate to a boolean expression and must 
evaluate to true to perform the action. Possible test conditions are NOT_STARTED, 
SCHEDULED, RUNNING, PAUSED, STALLED, SUCCEEDED, FAILED, and STOPPED. 
• ACTION: The action to perform when the condition evaluates to true. Possible 
actions are start a step, stop a step, or end the chain. 
• RULE_NAME: The name you want to give to the rule being created. If omitted, Oracle 
will generate a unique name. 
• COMMENTS : Optional text to describe the rule. 
In this example, the first call to the DBMS_SCHEDULER.DEFINE_CHAIN_RULE procedure sets the condition 
to TRUE and the action to START Step1. This causes step 1 to run immediately when the chain starts. The 
next call to the DBMS_SCHEDULER.DEFINE_CHAIN_RULE procedure defines the action to take when step 1 
completes successfully. In this example, steps 2.1 and 2.2 are started. Starting multiple steps 
simultaneously allows you to schedule steps to run in parallel. In the third call to the 
DBMS_SCHEDULER.DEFINE_CHAIN_RULE procedure, the condition waits for the successful completion of 
steps 2.1 and 2.2 and then starts step 3 as its action. The final call to the 
DBMS_SCHEDULER.DEFINE_CHAIN_RULE procedure waits for the successful completion of step 3 and then 
ends the chain. 
If any step in the chain fails, the entire chained process stops at its next condition test. For example, 
if step 1 fails, steps 2.1 and 2.2 are never started. However, if steps 2.1 and 2.2 are running and step 2.1 
fails, step 2.2 will continue to run and may complete successfully, but step 3 will never run. You can 
account for chain failures and other conditions by testing for a condition such as NOT_STARTED, 
SCHEDULED, RUNNING, PAUSED, STALLED, FAILED, and STOPPED. 
The call to the procedure DBMS_SCHEDULER.ENABLE does just what you expect; it enables the chain to 
run. It is best to keep the chain disabled while defining the steps and rules. You can run the chain 
manually with a call to the DBMS_SCHEDULE.RUN_CHAIN procedure or, as shown in this example, with a call 
to the DBMS_SCHEDULE.CREATE_JOB procedure. See Recipe 11-1 for more information on scheduling a job. 