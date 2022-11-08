---
title: Oracle PLSQL Recipes 13-Analyzing and Improving
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

 
# 13. Analyzing and Improving 
Performance This chapter introduces several methods to help you analyze your code to improve its performance in 
terms of runtime or memory usage. Many recipes use the DBMS_PROFILE package, which is supplied by 
Oracle, to help in the analysis. It is a useful tool for identifying which lines of code consume the most 
execution time. 

## 13-1. Installing DBMS_PROFILER 
**Problem** 
You want to analyze and diagnose your code to find bottlenecks and areas where excess execution time 
is being spent, but the DBMS_PROFILER package is not installed. 
**Solution** 
Install the DBMS_PROFILER packages, and then create the tables and the Oracle sequence object they need 
in order to run. Once installed, you can use the DBMS_PROFILER package to help diagnose application 
performance issues. 
Installing the Packages 
To install the DBMS_PROFILER packages, follow these steps:  
The packages are owned by the SYS account; therefore, it requires DBA login 
access. Start by opening a SQL Plus connect with the connect sys command. If 
the operation is successful, the system will respond with the message 

“Connected.”  
connect sys/sys_pwd as sysdba 
Connected. 
Once connected, run the profload.sql script that can be found within the 
RDBMS/ADMIN directory contained in your Oracle Database home. The system 
will respond with a series of messages like those shown next. 
```
@[Oracle_Home]/RDBMS/ADMIN/profload.sql 
```
You should see the following output after executing the script: 
 
Package created. 
Grant succeeded. 
Synonym created. 
Library created. 
Package body created. 
Testing for correct installation 
SYS.DBMS_PROFILER successfully loaded. 
PL/SQL procedure successfully completed. 
Finally, enter the grant execute command to ensure that all schemas within the 
database have access to the DBMS_PROFILER package. 
grant execute on DBMS_PROFILER to PUBLIC; 
Grant succeeded. 
Creating the Profiler Tables and Sequence Object 
Create the tables and Oracle sequence object you need for the profiler to run. Log into the account that 
wants to use the profiler, and enter the following. The system will respond as follows: 
 
@[Oracle_Home]/RDBMS/ADMIN/proftab.sql 
**How It Works** 
The first step creates the packages and makes them available for public access. The second creates the 
required tables in the schema that wants to use the profiler. There are alternatives to this installation 
method based on needs and preferences. 
The DBA may, for example, want to grant execution privileges to specific users instead of everyone. 
Step 2 must be repeated for every user who wants to use the profiling tools. An alternative is for the DBA 
to create public synonyms for the tables and sequence created, thereby having only one copy of the 
profiler table, in which case the **Solution** changes as in the following example. In the following recipe, 
replace [Oracle_Home] with the exact path used to install the database software on your system. 
 
connect sys/sys_pwd as sysdba 
@[Oracle_Home]/RDBMS/ADMIN/profload.sql 
grant execute on DBMS_PROFILER to USER1, USER2, USER3; 
@[Oracle_Home]/RDBMS/ADMIN/proftab.sql 
 
CREATE PUBLIC SYNONYM plsql_profiler_data FOR plsql_profiler_data; 
CREATE PUBLIC SYNONYM plsql_profiler_units FOR plsql_profiler_units; 
CREATE PUBLIC SYNONYM plsql_profiler_runs FOR plsql_profiler_runs; 
CREATE PUBLIC SYNONYM plsql_profiler_runnumber FOR plsql_profiler_runnumber; 

## 13-2. Identifying Bottlenecks 
**Problem** 
You notice that a PL/SQL program is running slowly, and you need to identify what sections of the code 
are causing it to perform poorly. 
**Solution** 
Use the DBMS_PROFILER routines to analyze the code and find potential bottlenecks. In the following 
example, the profiler is used to collect statistics on a run of a program, and then a query displays the 
statistics.  
```sql
EXEC DBMS_PROFILER.START_PROFILER ('Test1', 'Testing One'); 
EXEC sync_hr_data;    -- the procedure identifed has having a bottleneck 
EXEC DBMS_PROFILER.FLUSH_DATA; 
EXEC DBMS_PROFILER.STOP_PROFILER; 
```
Now that the profile data is collected, you can query the underlying tables to see the results of the 
analysis: 
 
COL line# FORMAT 999 
COL hundredth FORMAT a6 
```sql
SELECT    d.line#, 
          to_char (d.total_time/10000000, '999.00') hundredth, 
          s.text 
FROM    user_source      s, 
        plsql_profiler_data  d, 
        plsql_profiler_units u, 
        plsql_profiler_runs  r 
WHERE  r.run_comment     = 'Test1' -- run_comment matches the text in START_PROFILER 
AND    u.runid           = r.runid 
AND    u.unit_owner      = r.run_owner 
AND    d.runid           = r.runid 
AND    d.unit_number     = u.unit_number 
AND    s.name            = u.unit_name 
AND    s.line            = d.line# 
ORDER BY d.line#; 
```

Here are the results of the previous query: 
 
 1     .00 PROCEDURE sync_hr_data AS 
 3     .00 CURSOR    driver is 
 4   11.58 SELECT    * 
 5     .00 FROM      employees@hr_data; 
 9    2.25    FOR recs IN driver LOOP 
10    1.64       UPDATE      employees 
15     .01 END sync_hr_data; 
 
Here is the complete source code for the sync_hr_data procedure: 
```sql
CREATE OR REPLACE PROCEDURE sync_hr_data AS 
 
CURSOR    driver IS 
SELECT    * 
FROM      employees@hr_data; 
 
BEGIN 
 
   FOR recs IN driver LOOP 
      UPDATE employees 
      SET    first_name  = recs.first_name 
      WHERE  employee_id = recs.employee_id; 
   END LOOP; 
 
END sync_hr_data;
``` 
**How It Works** 
There are four steps necessary to collect statistics on a running procedure: 
1. Call the DBMS_PROFILER.START_PROFILER routine to begin the process of 
collecting statistics. The two parameters allow you to give the run a name and 
a comment. Unique names are not required, but that will make it easier to 
query the results later. 
2. Execute the program you suspect has bottleneck issues; in this example, we 
run the sync_hr_data program.  
3. Execute DBMS_PROFILER.FLUSH_DATA to write the data collected to the profiler 
tables.  
4. Call the DBMS_PROFILER.STOP_PROFILER routine to, as the name implies, stop the 
collection of statistics. 
The query joins the profiler data with the source code lines to display executable lines and the 
execution time, in hundredths of a second. The raw data stores time in nanoseconds. The query results 
show three lines of code with actual execution time. 
The SELECT statement from the program unit in question, in which Oracle must establish a remote 
connection via a database link, consumes the majority of the execution time. The remainder of the time 
is consumed by the FOR statement, which fetches each record from the remote database connection, and 
the UPDATE statement, which writes the data to the local database. 
Selecting records in the loop and then updating them causes the program to switch context between 
PL/SQL and the database engine. Each iteration of the LOOP causes this switch to occur. In this example, 
there were 107 employee records updated. The next recipe shows you how to improve the performance 
of this procedure. 

## 13-3. Speeding Up Read/Write Loops 
**Problem** 
You have identified a loop that reads and writes large batches of data. You want to speed it up. 
**Solution** 
Use a BULK COLLECT statement to fetch the target data records, and then use a FORALL loop to update the 
local database. For example, suppose you want to speed up the sync_hr_data procedure demonstrated 
in Chapter 11: 
```sql
CREATE OR REPLACE PROCEDURE sync_hr_data AS 
 
CURSOR    driver IS 
SELECT    * 
FROM      employees@hr_data; 
 
TYPE    recs_type IS TABLE OF driver%ROWTYPE INDEX BY BINARY_INTEGER; 
recs    recs_type; 
 
BEGIN 
 
   OPEN driver; 
   FETCH driver BULK COLLECT INTO recs; 
   CLOSE driver; 
 
   FORALL i IN 1..recs.COUNT 
      UPDATE    employees 
      SET       first_name    = recs(i).first_name 
      WHERE     employee_id = recs(i).employee_id; 
 
END sync_hr_data; 
```
Run the profiler procedures to collect additional statistics: 
```sql
EXEC DBMS_PROFILER.START_PROFILER ('Test2', 'Testing Two'); 
EXEC sync_hr_data; 
EXEC DBMS_PROFILER.FLUSH_DATA; 
EXEC DBMS_PROFILER.STOP_PROFILER; 
```
Query the underlying tables to see the results of the analysis: 
```sql
COL line# FORMAT 999 
COL hundreth FORMAT A6 

SELECT    d.line#, 
          TO_CHAR (d.total_time/10000000, '999.00') hundreths, 
          s.text 
FROM    user_source             s, 
        plsql_profiler_data     d, 
        plsql_profiler_units    u, 
        plsql_profiler_runs     r 
WHERE    r.run_comment     = 'Test2' 
AND      u.runid           = r.runid 
AND      u.unit_owner      = r.run_owner 
AND      d.runid           = r.runid 
AND      d.unit_number     = u.unit_number 
AND      s.name            = u.unit_name 
AND      s.line            = d.line# 
ORDER BY d.line#; 
``` 
 1     .00 PROCEDURE sync_hr_data AS 
 3     .00 CURSOR    driver is 
 4   11.54 SELECT    * 
 5     .00 FROM      employees@hr_data; 
12     .00    OPEN driver; 
13    1.61    FETCH driver BULK COLLECT INTO recs; 
14     .01    CLOSE driver; 
16    1.15    FORALL i IN 1..recs.COUNT 
21     .00 END sync_hr_data; 
**How It Works** 
The procedure is updated from the previous recipe to use a BULK COLLECT statement to gather the data 
into a collection. The update statement uses the FORALL command to pass the entire collection of data to 
the Oracle engine for processing rather than updating one row at a time. BULK COLLECT and FORALL loops 
pass the entire dataset of the collections to the database engine for processing, unlike the loop in recipe 

## 13-2, where each iteration passes only one record at a time from the collection to the database. The 
constant switching back and forth between PL/SQL and the database engine creates unnecessary 
overhead. 
Perform the following steps to collect statistics on the update procedure: 
1. Run the DBMS_PROFILER.START_PROFILER routine to begin the process of 
collecting statistics. You use the two parameters of the routine to give the run a 
name and to post a comment. Unique names are not required, but doing so 
will make it easier to query the results later. 
2. Run the sync_hr_data program to collect statistics. 
3. Run the DBMS_PROFILER.FLUSH_DATA procedure to write the data collected to the 
tables. 
4. Run the DBMS_PROFILER.STOP_PROFILER routine to, as the name implies, stop 
the collection of statistics. 
The query joins the profiler data, using the run name of Test2, with the source code lines to display 
executable lines and the execution time, in hundredths of a second. The raw data stores time in 
nanoseconds. The query results show three lines of code with actual execution time. 
Comparing these results with the previous recipe, we note a 28 percent improvement, 2.25 to 1.61, 
in fetching the records via the BULK COLLECT statement, and a 30 percent improvement, 1.64 to 1.15, in 
the writing of the records via the FORALL statements. This improvement is realized while processing only 
107 records. Greater gains can be realized with larger data sets, especially when selecting records via a 
remote database link as there are fewer context switches between PL/SQL and the Oracle engine. 

## 13-4. Passing Large or Complex Collections as OUT Parameters 
**Problem** 
You have a procedure or function that accepts one or more large or complex collections that are also OUT 
parameters, and you need a more efficient method to pass these variables. 
**Solution** 
Pass the parameters to your procedure or function by reference using the NOCOPY option on the 
procedure or function declaration. 
```sql
CREATE OR REPLACE PACKAGE no_copy_test AS 
 
   TYPE rec_type IS TABLE OF all_objects%ROWTYPE INDEX BY BINARY_INTEGER; 
   PROCEDURE test; 
 
END no_copy_test; 
/ 
```
show error 
```sql
CREATE OR REPLACE PACKAGE BODY no_copy_test AS 
 
PROCEDURE proc1 (rec_list IN OUT rec_type) IS 
BEGIN 
   FOR i IN 1..rec_list.COUNT LOOP 
      rec_list(i) := rec_list(i); 
   END LOOP; 
END; 

PROCEDURE proc2 (rec_list IN OUT NOCOPY  rec_type) IS 
BEGIN 
   FOR i IN 1..rec_list.COUNT LOOP 
      rec_list(i) := rec_list(i); 
   END LOOP; 
END; 
 
PROCEDURE test IS 
 
CURSOR  driver IS 
SELECT  * 
FROM    all_objects; 
 
recs        rec_type; 
rec_count   integer; 
 
BEGIN 
 
   OPEN driver; 
   FETCH DRIVER BULK COLLECT INTO recs; 
   CLOSE driver; 
 
   rec_count := recs.COUNT; 
 
   DBMS_OUTPUT.PUT_LINE (systimestamp); 
   proc1 (recs); -- parameter passed by value 
   DBMS_OUTPUT.PUT_LINE (systimestamp); 
   proc2 (recs); -- paramter passed by reference 
   DBMS_OUTPUT.PUT_LINE (systimestamp); 
END test; 
 
END no_copy_test; 
/
```
```sql
set serverout on  -- Enable output from DBMS_OUTPUT statements 
EXEC no_copy_test.test; 
```
Running the procedure produced the following output: 
 
03-NOV-10 05.05.14.865000000 PM -05:00 
03-NOV-10 05.05.14.880000000 PM -05:00 
03-NOV-10 05.05.14.880000000 PM -05:00 
**How It Works** 
The recipe utilizes the NOCOPY feature within PL/SQL. It begins by defining two procedures within the test 
package. The first procedure, PROC1, accepts a collection of records using the default parameter-passing 
method, which is by VALUE. The second procedure, PROC2, is an exact copy of PROC1; however, its 
parameter is passed using the NOCOPY option. In PROC1, the parameter is passed in by VALUE, which means 
a copy of the entire collection is created in the REC_LIST variable within PROC1. In PROC2, the parameter 
data is passed by REFERENCE. Passing a parameter by reference does not copy the data; rather, it uses the 
existing data structure passed to it by the calling program. This method is more efficient for very large 
collections in both running time and in memory usage. 
The output from the test shows the first procedure, which passed its parameter by VALUE took longer 
to run than the second procedure, which passed its parameter by REFERENCE. In this example, the 
USER_OBJECTS table was used as the data for the parameter, which retrieved only 6,570 records. Larger 
performance gains can be realized with more records and more complex data structures. 

## 13-5. Optimizing Computationally Intensive Code 
**Problem** 
You have computationally intensive code that you want to optimize to decrease its running time. 
**Solution** 
Recompile the package, procedure, or function in native mode using the NATIVE setting: 
 
ALTER PACKAGE my_package COMPILE BODY PLSQL_CODE_TYPE=NATIVE REUSE SETTINGS; 
ALTER PROCEDURE my_procedure COMPILE PLSQL_CODE_TYPE=NATIVE REUSE SETTINGS; 
ALTER FUNCTION my_function COMPILE PLSQL_CODE_TYPE=NATIVE REUSE SETTINGS; 
 
Here is an example of a computationally intensive procedure. It uses the factorial function from 
Recipe 17-4. 
```sql
CREATE OR REPLACE PROCEDURE factorial_test as 
 
fact    NUMBER; 
 
BEGIN 
 
   FOR i IN 1..100 LOOP 
      fact := factorial(33); 
   END LOOP; 
 
END factorial_test; 
 
  -- enable display of execution time 
SET TIMING ON 
 
  -- run the test 
EXEC factorial_test 
 
PL/SQL procedure successfully completed. 
Elapsed: 00:00:01.18 
```
Now, recompile the code using the NATIVE option and rerun the test, noting any change in running 
time: 
```sql
ALTER PROCEDURE factorial_test COMPILE PLSQL_CODE_TYPE=NATIVE REUSE SETTINGS; 
 
EXEC factorial_test 
 
PL/SQL procedure successfully completed. 
Elapsed: 00:00:00.42 
```
**How It Works** 
The ALTER. . .COMPILE command invokes the compiler on the named object. The syntax differs slightly 
when recompiling a PACKAGE body in that the BODY clause follows the COMPILE statement. The 
PLSQL_CODE_TYPE=NATIVE clause compiles the code in NATIVE format, which runs faster than interpreted 
code. The REUSE SETTINGS clause ensures the code will be recompiled in the same mode if it later 
becomes invalid and requires automatic recompilation. 
Native mode realizes the most benefit from computational intensive code; it has little effect on DML 
statements (in other words, SELECT, INSERT, UPDATE, and DELETE). In the previous example, the factorial 
function is called repeatedly to simulate a computationally intensive procedure. When the procedure is 
compiled in the default, interpretive method, it completes its run in 1.18 seconds. When compiled in 
NATIVE mode, it completes in 0.42 seconds. This is a 64 percent improvement in running time! 

## 13-6. Improving Initial Execution Running Time 
**Problem** 
You have a procedure that you run frequently, and you want to improve its overall running time by
minimizing its startup time. 
**Solution** 
Use the DBMS_SHAPRED_POOL.KEEP procedure to keep a permanent copy of your code in the shared
memory pool. For example, the following statement pins the procedure my_large_procedure in the
database’s shared memory pool: 
```sql
DBMS_SHARED_POOL.KEEP ( 
   Name => 'my_large_procedure',  
   flag => 'P'); 
```
**How It Works** 
The DBMS_SHARED_POOL.KEEP procedure permanently keeps your code in the shared memory pool. By
default, when PL/SQL code is executed, Oracle must first read the entire block of code into memory if it
isn’t already there from a previous execution. As additional procedures are executed, less recently used
code in the shared memory pool begins to age. If there isn’t sufficient free space in the shared memory
pool, older code is removed to make room. 
If large procedures are run frequently and are aging out of the shared memory pool, then pinning
the procedure in the shared memory pool can improve performance by removing the overhead
necessary to reload the procedure again and again. 
The first parameter of the DBMS_SHARED_POOL.KEEP procedure is the name of the object you want to
pin in the shared memory pool. The second parameter identifies the object type of the first parameter.
The most commonly used values for FLAG are as follows: 
•P: The default, which specifies the object is a package, procedure, or function 
•T: Specifies the object is a trigger 
•Q: Specifies the object is a sequence 
You must have execute privileges on the DBMS_SHARED_POOL package to pin your code. An account with
SYSDBA privileges must grant execute on DBMS_SHARED_POOL to your schema or to public. 
