---
title: Oracle PLSQL Recipes 10-PL/SQL Collections and Records
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


# 10. PL/SQL Collections and Records 
Collections are single-dimensional arrays of data all with the same datatype and are accessed by an 
index; usually the index is a number, but it can be a string. Collections indexed by strings are commonly 
known as hash arrays. 
Records are groups of related data, each with its own field name and datatype, similar to tables 
stored in the database. The record data structure in PL/SQL allows you to manipulate data at the field or 
record level. PL/SQL provides an easy method to define a record’s structure based on a database table’s 
structure or a cursor. Combining records and collections provide a powerful programming advantage 
described in the following recipes. 

## 10-1. Creating and Accessing a VARRAY 
**Problem** 
You have a small, static list of elements that you initialize once and that would benefit from using in a 
loop body. 
**Solution** 
Place the elements into a varray (or varying array). Once initialized, a varray may be referenced by its 
index. Begin by declaring a datatype of varray with a fixed number of elements, and then declare the 
datatype of the elements. Next, declare the variable that will hold the data using the newly defined type. 
For example, the following code creates a varying array to hold the abbreviations for the days of the 
week: 
```sql
DECLARE 
 
TYPE    dow_type IS VARRAY(7) OF VARCHAR2(3); 
dow     dow_type := dow_type ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'); 
 
BEGIN 
 
   FOR i IN 1..dow.COUNT LOOP 
      DBMS_OUTPUT.PUT_LINE (dow(i)); 
   END LOOP; 
 
END; 
 
Results 
Sun 
Mon 
Tue 
Wed 
Thu 
Fri 
Sat 
```
**How It Works** 
The type statement dow_type defines a data structure to store seven instances of VARCHAR2(3). This is 
sufficient space to hold the abbreviations of the seven days of the week. The dow variable is defined as a 
VARRAY of the dow_type defined in the previous line. That definition invokes a built-in constructor 
method to initialize values for each of the elements in the VARRAY. 
The FOR .. LOOP traverses the dow variable starting at the first element and ending with the last. The 
COUNT method returns the number of elements defined in a collection; in this recipe, there are seven 
elements in the VARRAY, so the LOOP increments from one to seven. The DBMS_OUTPUT.PUT_LINE statement 
displays its value. 
A VARRAY is best used when you know the size the array and it will not likely change. The VARRAY 
construct also allows you to initialize its values in the declaration section. 

## 10-2. Creating and Accessing an Indexed Table 
**Problem** 
You need to store a group of numbers for later processing in another procedure. 
**Solution** 
Create an indexed table using an integer index to reference the elements. For example, this recipe loads 
values into an indexed table of numbers.  
```sql
DECLARE 
 
TYPE    num_type IS TABLE OF number INDEX BY BINARY_INTEGER; 
nums    num_type; 
total   number; 
 
BEGIN 
 
   nums(1) := 127.56; 
   nums(2) := 56.79; 
   nums(3) := 295.34; 
 
   -- call subroutine to process numbers; 
   -- total := total_table (nums); 
END;  
```

**How It Works** 
PL/SQL tables are indexed collections of data of the same type. The datatype can be any of the built-in 
datatypes provided by PL/SQL; in this example, the datatype is a number. Here are some things to note 
about the example:
• The TYPE statement declares a TABLE of numbers. 
• The INDEX BY clause defines how the array is accessed, in this case by an INTEGER.  
• The array is populated by assigning values to specific indexes.  
Because the TABLE is INDEXED BY an INTEGER, there is no predefined limit on the index value, other 
than those imposed by Oracle, which is -231 – 231. Indexed tables are best suited for collections where the 
number of elements stored is not known until runtime. 
This recipe is an example of a TABLE indexed by an INTEGER. PL/SQL provides for tables indexed by 
strings as well. See Recipe 10-5 for an example. 

## 10-3. Creating Simple Records 
**Problem** 
You need a PL/SQL data structure to group related employee data to make manipulating the group 
easier. 
**Solution** 
Define a record structure of the related employee data, and then create a variable to hold the record 
structure. In this example, a simple RECORD structure is defined and initialized. 
```sql
DECLARE 
 
TYPE    rec_type IS RECORD ( 
                last_name       varchar2(25), 
                department      varchar2(30), 
                salary          number ); 
rec     rec_type; 
 
begin 
 
   rec.last_name        := 'Juno'; 
   rec.department       := 'IT'; 
   rec.salary           := '5000'; 
 
END;
```
**How It Works** 
Record structures are created in PL/SQL by using the TYPE statement along with a RECORD structure 
format. The fields defined in the record structure can be, and often are, of different datatypes. Record 
structures use dot notation to access individual fields. Once defined, the rec_type record structure in the 
**Solution** can be used throughout the code to create as many instantiations of data structures as needed. 

## 10-4. Creating and Accessing Record Collections 
**Problem** 
You need to load records from a database table or view into a simple data structure that would benefit 
from use in a loop body or to pass as a parameter to another function or procedure. You want to act 
upon sets of records as a single unit.  
**Solution** 
Use a TYPE to define a TABLE based on the database table structure. The following example declares a 
cursor and then uses it to declare the table of records. The result is a variable named recs that holds the 
data fetched by the cursor. 
```sql
DECLARE 
 
CURSOR  driver IS 
SELECT  * 
FROM    employees; 
 
TYPE    emp_type IS TABLE OF driver%ROWTYPE INDEX BY BINARY_INTEGER; 
recs    emp_type; 
total   number := 0.0; 
 
BEGIN 
 
   OPEN DRIVER; 
   FETCH DRIVER BULK COLLECT INTO recs; 
   CLOSE DRIVER; 
 
   DBMS_OUTPUT.PUT_LINE (recs.COUNT || ' records found'); 
 
   FOR i in 1..recs.COUNT LOOP 
      total := total + recs(i).salary; 
   END LOOP; 
 
END; 
```
When you execute this block of code, you will see a message such as the following: 103 records found 
**How It Works** 
The TYPE statement defines a data structure using the attributes (columns) of the employees table as 
elements within the structure. The TABLE OF clause defines multiple instances of the record structure. 
The INDEX BY clause defines the index method, in this case an integer. Think of this structure as a 
spreadsheet with the rows being separate records from the database and the columns being the 
attributes (fields) in the database. The recipe works whether your cursor selects all the fields (SELECT *) 
or selects just a subset of fields from the table.  
The BULK COLLECT portion of the fetch statement is more efficient than looping through the data in a 
standard cursor loop because PL/SQL switches control to the database just once to retrieve the data as 
opposed to switching to the database for each record retrieved in a cursor FOR .. LOOP. In a BULK 
COLLECT, all records meeting the query condition are retrieved and stored in the data structure in a single 
operation. Once the records are retrieved, processing may occur in a standard FOR .. standard FOR .. 
LOOP. 

## 10-5. Creating and Accessing Hash Array Collections  
**Problem** 
You want to use a single cursor to query employee data and sum the salaries across departments.  
**Solution** 
You can use two cursors—one to select all employees and the other to sum the salary grouping by 
department. However, you can more easily and efficiently accomplish your task by using one cursor and 
a hashed collection. Define your cursor to select employee data, joined with the department table. Use a 
hash array collection to total by department by using the INDEX BY option to index your collection based 
on the department name rather than an integer. The following code example illustrates this more 
efficient approach: 
```sql
DECLARE 
 
CURSOR  driver IS 
SELECT  ee.employee_id, ee.first_name, ee.last_name, ee.salary, d.department_name 
FROM    departments     d, 
        employees       ee 
WHERE   d.department_id = ee.department_id; 
  
TYPE    total_type IS TABLE OF number INDEX BY departments.department_name%TYPE; 
totals  total_type; 
 
dept    departments.department_name%TYPE; 
 
BEGIN 
 
   FOR rec IN driver LOOP 
      -- process paycheck 
      if NOT totals.EXISTS(rec.department_name) then  -- create element in the array 
         totals(rec.department_name) := 0; -- initialize to zero 
      end if; 
 
      totals(rec.department_name) := totals(rec.department_name) + nvl (rec.salary, 0); 
   END LOOP; 
 
   dept := totals.FIRST; 
   LOOP 
      EXIT WHEN dept IS NULL; 
      DBMS_OUTPUT.PUT_LINE (to_char (totals(dept),  '999,999.00') || ' ' || dept); 
      dept := totals.NEXT(dept); 
   END LOOP; 
END; 
```
When you execute this block of code, you will see the following results: 
```text
20,310.00 Accounting
58,720.00 Executive
51,600.00 Finance
6,500.00 Human Resources
19,000.00 Marketing
2,345.34 Payroll
10,000.00 Public Relations
304,500.00 Sales
156,400.00 Shipping
35,295.00 Web Developments 
```
**How It Works** 
The TOTAL_TYPES PL/SQL type is defined as a collection of numbers that is indexed by the department
name. Indexing by department name gives the advantage of automatically sorting the results by
department name. 
As new elements are created, using the EXISTS method, the index keys are automatically sorted by
PL/SQL. The totals are accumulated by department name as opposed to a numerical index, such as
department ID, which may not be sequential. This approach has the added advantage of not requiring a
separate collection for the department names. 
Once the employee paychecks are processed, the dept variable is initialized with the first
department name from the totals array using the FIRST method. In this example, the first department is
accounting. A loop is required to process the remaining records. The NEXT method is used to find the
next department name—in alphabetical order—and this process repeats until all departments are
displayed.  

## 10-6. Creating and Accessing Complex Collections 
**Problem** 
You need a routine to load managers and their corresponding employees from the database and store
them in one data structure. The data must be loaded in a manner such that direct reports are associated
with their manager. In addition, the number of direct reports for any given manager varies, so your
structure to hold the manager/employee relationships must handle any number of subordinates. 
**Solution** 
Combine records and collections to define one data structure capable of storing all the data. PL/SQL
allows you to use data structures you create via the type statement as datatypes within other collections.
Once your data structures are defined, use dot notation to distinguish attributes within the collections.
Use the structure’s index to reference items within the table. For example: 
```sql
SET SERVEROUT ON SIZE 1000000 
 
DECLARE 
 
TYPE    person_type IS RECORD ( 
                employee_id     employees.employee_id%TYPE, 
                first_name      employees.first_name%TYPE, 
                last_name       employees.last_name%TYPE); 
 
  -- a collection of people 
TYPE    direct_reports_type IS TABLE OF person_type INDEX BY BINARY_INTEGER;  
 
  -- the main record definition, which contains a collection of records 
TYPE    rec_type IS RECORD ( 
                mgr             person_type, 
                emps            direct_reports_type); 
 
TYPE    recs_type IS TABLE OF rec_type INDEX BY BINARY_INTEGER; 
recs    recs_type; 
 
CURSOR  mgr_cursor IS  -- finds all managers 
SELECT  employee_id, first_name, last_name 
FROM    employees 
WHERE   employee_id IN 
        (       SELECT  distinct manager_id 
                FROM    employees) 
ORDER BY last_name, first_name; 
 
CURSOR  emp_cursor (mgr_id integer) IS  -- finds all direct reports for a manager 
SELECT  employee_id, first_name, last_name 
FROM    employees 
WHERE   manager_id = mgr_id 
ORDER BY last_name, first_name; 
 
  -- temporary collection of records to hold the managers. 
TYPE            mgr_recs_type IS TABLE OF emp_cursor%ROWTYPE 
                                INDEX BY BINARY_INTEGER; 
mgr_recs        mgr_recs_type; 
 
BEGIN 
 
   OPEN mgr_cursor; 
   FETCH mgr_cursor BULK COLLECT INTO mgr_recs; 
   CLOSE mgr_cursor; 
 
   FOR i IN 1..mgr_recs.COUNT LOOP 
      recs(i).mgr := mgr_recs(i);  -- move the manager record into the final structure 
 
        -- moves direct reports directly into the final structure 
      OPEN emp_cursor (recs(i).mgr.employee_id); 
      FETCH emp_cursor BULK COLLECT INTO recs(i).emps; 
      CLOSE emp_cursor; 
   END LOOP; 
 
        -- traverse the data structure to display the manager and direct reports 
        -- note the use of dot notation within the data structure 
   FOR i IN 1..recs.COUNT LOOP 
      DBMS_OUTPUT.PUT_LINE ('Manager: ' || recs(i).mgr.last_name); 
      FOR j IN 1..recs(i).emps.count LOOP 
         DBMS_OUTPUT.PUT_LINE ('***   Employee: ' || recs(i).emps(j).last_name); 
      END LOOP; 
   END LOOP; 
 
END;  
```
Executing this code block produces the following results: 
 
Manager: Cambrault 
***   Employee: Bates 
***   Employee: Bloom 
***   Employee: Fox 
***   Employee: Kumar 
***   Employee: Ozer 
***   Employee: Smith 
…  <<snip>> 
Manager: Zlotkey 
***   Employee: Abel 
***   Employee: Grant 
***   Employee: Hutton 
***   Employee: Johnson 
***   Employee: Livingston 
***   Employee: Taylor 
**How It Works** 
Combining records with collections is one of the most powerful techniques for defining data structures 
in PL/SQL. It allows you to logically group common data, process large amounts of data efficiently, and 
seamlessly pass data between procedures and functions. 
The data structure contains a collection of managers; each manager contains a collection of direct 
reports. Managers and direct reports are both person_type. Once your complex structure is defined, you 
can use the BULK COLLECT feature to quickly fetch data from the database and load it into the structure. 
The BULK COLLECT of the MGR_CURSOR selects all persons who are managers at once and then loads 
them into the temporary structure MGR_RECS. Now that you have retrieved the records, it is easy to move 
them into your final data structure. Looping through the manager records allows you to move the entire 
data record for each manager via the RECS(I).MGR := MGR_RECS(I); statement. This statement moves 
every element (field) from the MGR_RECS into the RECS structure. 
The EMP_CURSOR uses the managers’ ID to fetch the managers’ direct reports. The cursor is opened by 
passing the managers’ ID, and then another BULK COLLECT is used to directly store the fetched data into 
the data structure; no temporary data structure is needed because the structure of the fetched data 
exactly matches the target data structure. 
Now that the data is stored in the data structure, it can be passed to another routine for processing. 
Grouping large sets of related data is an efficient method for exchanging data between routines. This 
helps separate data retrieval routines from business processing routines. It’s a very powerful feature in 
PL/SQL, as you’ll see in the next recipe. 

## 10-7. Passing a Collection As a Parameter 
**Problem** 
You want to pass a collection as a parameter to a procedure or function. For example, you have a data 
structure that contains employee data, and you need to pass the data to a routine that prints employee 
paychecks. 
**Solution** 
Create a collection of employee records to hold all employee data, and then pass the data to the 
subroutine to process the paychecks. The TYPE statement defining the data structure must be visible to 
the called procedure; therefore, it must be defined globally, prior to defining any procedure or function 
that uses it. 
In this example, employee data is fetched from the database into a collection and then passed to a 
subroutine for processing. 
```sql
set serverout on size 1000000 
 
DECLARE 
 
CURSOR  driver IS 
SELECT  employee_id, first_name, last_name, salary 
FROM    employees 
ORDER BY last_name, first_name; 
 
TYPE    emps_type IS TABLE OF driver%ROWTYPE; 
recs    emps_type; 
 
   PROCEDURE print_paycheck (emp_recs emps_type) IS 
 
   BEGIN 
 
      FOR i IN 1..emp_recs.COUNT LOOP 
         DBMS_OUTPUT.PUT ('Pay to the order of: '); 
         DBMS_OUTPUT.PUT (emp_recs(i).first_name || ' ' || emp_recs(i).last_name); 
         DBMS_OUTPUT.PUT_LINE (' $' || to_char (emp_recs(i).salary, 'FM999,990.00')); 
      END LOOP; 
 
   END;  
 
BEGIN 
 
   OPEN driver; 
   FETCH driver BULK COLLECT INTO recs; 
   CLOSE driver; 
 
   print_paycheck (recs); 
 
END;  
```
Results 
 
Pay to the order of: Ellen Abel $11,000.00 
Pay to the order of: Sundar Ande $6,400.00 
Pay to the order of: Mozhe Atkinson $2,800.00 
… <<snip>> 
Pay to the order of: Alana Walsh $3,100.00 
Pay to the order of: Matthew Weiss $8,000.00 
Pay to the order of: Eleni Zlotkey $10,500.00 
**How It Works** 
TYPE globally defines the data structure as a collection of records for use by the PL/SQL block and the 
enclosed procedure. This declaration of both the type and the procedure at the same level—inside the 
same code block—is necessary to allow the data to be passed to the function. The type and the 
procedure are within the same scope, and thus the procedure can reference the type and accept values 
of the type. 
Defining the recs structure as a collection makes it much easier to pass large amounts of data 
between routines with a single parameter. The data structure emps_type is defined as a collection of 
employee records that can be passed to any function or procedure that requires employee data for 
processing. This recipe is especially useful in that the logic of who receives a paycheck can be removed 
from the routine that does the printing or the routine that archives the payroll data, for example. 
## 10-8. Returning a Collection As a Parameter 
**Problem** 
Retrieving a collection of data is a common need. For example, you need a function that returns all 
employee data and is easily called from any procedure. 
**Solution** 
Write a function that returns a complete collection of employee data. In this example, a package is used 
to globally define a collection of employee records and return all employee data as a collection. 
```sql
CREATE OR REPLACE PACKAGE empData AS 
 
type    emps_type is table of employees%ROWTYPE INDEX BY BINARY_INTEGER; 
 
FUNCTION get_emp_data RETURN emps_type; 
 
END empData; 
 
CREATE OR REPLACE PACKAGE BODY empData as 
 
FUNCTION get_emp_data RETURN emps_type is 
 
cursor  driver is 
select  * 
from    employees 
order by last_name, first_name; 
 
recs    emps_type; 
 
begin 
 
   open driver; 
   FETCH driver BULK COLLECT INTO recs; 
   close driver; 
 
   return recs; 
 
end get_emp_data; 
 
end empData; 
 
declare 
 
emp_recs empData.emps_type; 
 
begin 
 
   emp_recs := empData.get_emp_data; 
   dbms_output.put_line ('Employee Records: ' || emp_recs.COUNT); 
 
END;  
```
Executing this block of code produces the following results. 
 Employee Records: 103 
**How It Works** 
By defining a PACKAGE, the data structure emps_type is available for use by any package, procedure, or 
function that has access rights to it.1 The function get_emp_data within the common package contains all 
the code necessary to fetch and return the employee data. This common routine can be used by multiple 
applications that require the employee data for processing. This is a much more efficient method than 
coding the same select statement in multiple applications. 
It is not uncommon to include business rules in this type of function; for example, the routine may 
fetch only active employees. If the definition of an active employee changes, you need to update only 
one routine to fix all the applications that use it. 
                                                 
1 To grant access rights, enter the following command: grant execute on empData to SCHEMA, where SCHEMA is 
the user name that requires access. To grant access to every user in the database, use grant execute on empData 
to PUBLIC;. 

## 10-9. Counting the Members in a Collection  
**Problem** 
You have a collection, and you need to determine the total number of elements in the collection. 
**Solution** 
Invoke the built-in COUNT method on the collection. For example, the following code creates two 
collections: a varying array and an INDEX BY array. The code then invokes the COUNT method on both 
collections, doing so before and after adding some records to each. 
```sql
DECLARE 
 
TYPE    vtype   IS VARRAY(3) OF DATE; 
TYPE    ctype   IS TABLE OF DATE INDEX BY BINARY_INTEGER; 
 
vdates  vtype := vtype (sysdate); 
cdates  ctype; 
 
BEGIN 
 
 
   DBMS_OUTPUT.PUT_LINE ('vdates size is: ' || vdates.COUNT); 
   DBMS_OUTPUT.PUT_LINE ('cdates size is: ' || cdates.COUNT); 
 
   FOR i IN 1..3 LOOP 
      cdates(i) := SYSDATE + 1; 
   END LOOP; 
 
   DBMS_OUTPUT.PUT_LINE ('cdates size is: ' || cdates.COUNT); 
 
END;  
```
Executing this block of code produces the following results: 
 
vdates size is: 1 
cdates size is: 0 
cdates size is: 3 
**How It Works** 
The variable vdates is initialized with one value, so its size is reported as 1 even though it is defined to 
hold a maximum of three values. The variable cdates is not initialized, so it is first reported with a size of 
1. The loop creates and sets three collection values, which increases its count to 3. 
Assigning a value directly to cdates(i) is allowed because cdates is an INDEX BY collection. 
Assigning a value to vdates in the loop would cause an error because the array has only one defined 
value. See the EXTEND method later in this chapter for more information on assigning values to non-INDEX 
BY collections. 
The COUNT method is especially useful when used on a collection populated with a fetch from BULK 
COLLECT statement to determine the number of records fetched or to process records in a FOR .. LOOP. 

## 10-10. Deleting a Record from a Collection 
**Problem** 
You need to randomly select employees from a collection. Using a random generator may select the 
same employee more than once, so you need to remove the record from the collection before selecting 
the next employee. 
**Solution** 
Invoke the built-in DELETE method on the collection. For example, the following code creates a collection 
of employees and then randomly selects one from the collection. The selected employee is removed 
from the collection using the DELETE method. This process is repeated until three employees have been 
selected. 
```sql
DECLARE 
 
CURSOR  driver IS 
SELECT  last_name 
FROM    employees; 
 
TYPE    rec_type IS TABLE OF driver%ROWTYPE INDEX BY BINARY_INTEGER; 
recs    rec_type; 
j       INTEGER; 
 
BEGIN 
 
   OPEN driver; 
   FETCH driver BULK COLLECT INTO recs; 
   CLOSE driver; 
 
   DBMS_RANDOM.INITIALIZE(TO_NUMBER (TO_CHAR (SYSDATE, 'SSSSS') ) ); 
 
   FOR i IN 1..3 LOOP 
--      Randomly select an employee 
      j := MOD (ABS (DBMS_RANDOM.RANDom), recs.COUNT) + 1; 
      DBMS_OUTPUT.PUT_LINE (recs(j).last_name); 
 
--      Move all employees up one postion in the collection 
      FOR k IN j+1..recs.COUNT LOOP 
         recs(k-1) := recs(k); 
      END LOOP; 
 
--      Remove the last element in the collection 
--      so the random number generator has the correct count. 
      recs.DELETE(recs.COUNT); 
   END LOOP; 
 
   DBMS_RANDOM.TERMINATE; 
 
END; 
```
Executing this block of code produces the following results: 
 
Olson 
Chung 
Seo 
**How It Works** 
The collection recs is populated with employee names via a BULK COLLECT. The FOR .. LOOP selects three 
employees at random by generating a random number between 1 and the number of records in the 
collection. Once an employee is selected, their name is removed from the collection, and the DELETE 
method is used to reduce the number of elements, which changes the value returned by the COUNT 
method for the next randomly generated number. 
  Note: The DELETE method applies only to collections that are indexed. You can invoke DELETE only if the 
collection’s underlying TYPE definition contains the INDEX BY clause. 

## 10-11. Checking Whether an Element Exists 
**Problem** 
You are processing elements in a collection but cannot be certain that each element exists. Referencing 
an element in a collection that does not exist will throw an exception. You want to avoid exceptions by 
testing for existence before you access an element. 
**Solution** 
Use the EXISTS method to test whether a collection has a value for a particular index value. In the 
following **Solution**, a table collection is created, and then the second element is deleted. It is important 
to note that a deleted element or an element that was never initialized is not equivalent to an element 
with a null value. 
```sql
DECLARE 
 
TYPE ctype IS TABLE OF DATE INDEX BY BINARY_INTEGER; 
 
cdates ctype; 
 
BEGIN 
 
   FOR i IN 1..3 LOOP 
  CHAPTER 10  PL/SQL COLLECTIONS AND RECORDS 
229 
     cdates(i) := sysdate + i; 
   END LOOP; 
 
   cdates.DELETE(2); 
 
   FOR i IN 1..3 LOOP 
      IF cdates.EXISTS(i) then 
         DBMS_OUTPUT.PUT_LINE ('cdates(' || i || ')= ' || cdates(i) ); 
      END IF; 
   END LOOP; 
 
END;  
```
Executing this block of code produces the following results: 
 
cdates(1)= 07-AUG-10 
cdates(3)= 09-AUG-10 
**How It Works** 
The first loop creates and initializes the elements in the collection; the DELETE method removes the 
second element. Now we’re ready to loop through the data. The second loop tests for the existence of the 
element index before attempting to use the variable. Attempting to access a value to an element in the 
collection that does not exist throws an exception. 
If the first loop initialized the collection elements to NULL, the remaining would execute in exactly 
the same manner. The only difference would be in the output from running the block of code. In this 
case, no dates would print. Referencing an element in a collection with a null value does not throw an 
exception because the indexed element exists, whereas referencing an element that does not exist does 
throw an exception. Here is the output in this example. Note neither **Solution** prints an element for 
subscript 2. 
 
cdates(1)= 
cdates(3)= 

## 10-12. Increasing the Size of a Collection 
**Problem** 
You have a VARRAY with a defined maximum size, but not all elements are initialized, and you need to 
add more elements to the collection. 
**Solution** 
Use the EXTEND method to create new elements within the predefined boundaries. The following 
example adds five elements using a loop: 
```sql
DECLARE 
 
TYPE    vtype   IS VARRAY(5) OF DATE; 
vdates  vtype := vtype (sysdate, sysdate+1, sysdate+2); -- initialize 3 of the 5 elements 
BEGIN 
   DBMS_OUTPUT.PUT_LINE ('vdates size is: ' || vdates.COUNT); 
   FOR i IN 1..5 LOOP 
      if NOT vdates.EXISTS(i) then 
         vdates.EXTEND; 
         vdates(i) := SYSDATE + i; 
      END IF; 
   END LOOP; 
   DBMS_OUTPUT.PUT_LINE ('vdates size is: ' || vdates.COUNT); 
END; 
```
Executing this block of code produces the following results: 
vdates size is: 3
vdates size is: 5 
**How It Works** 
The TYPE declaration defines a maximum of five elements in the collection, which is initialized with three
values. The loop tests for the existence of the elements by index number. The EXTEND method allocates
storage space for the new elements. Without the EXTEND statement preceding the assignment, Oracle will
raise an error “ORA-06533: Subscript beyond count.” This occurs when the loop attempts to assign a
value to the fourth element in the collection. 
The EXTEND method applies to TABLE and VARRAY collections that are not indexed. In other words, the
EXTEND method applies when the TABLE or VARRAY type definition does not contain the INDEX BY
clause. To assign a value to a collection that is indexed, simply reference the collection using the index
value.  

## 10-13. Navigating Collections 
**Problem** 
You need a routine to display sales totaled by region, which is stored in a collection of numbers, but the
collection is indexed by a character string. Using a LOOP from 1 to the maximum size will not work. 
**Solution** 
Use the FIRST and LAST method to traverse the collection allowing PL/SQL to supply the proper index
values. In this example, sales amounts are stored in a TABLE indexed by a string. 
```sql
DECLARE 
TYPE    ntype   IS TABLE OF NUMBER INDEX BY VARCHAR2(5);
nlist   ntype; 
idx     VARCHAR2(5); 
total   integer := 0; 
 
BEGIN 
 
   nlist('North') := 100; 
   nlist('South') := 125; 
   nlist('East')  := 75; 
   nlist('West')  := 75; 
 
   idx := nlist.FIRST; 
   LOOP 
      EXIT WHEN idx is null; 
      DBMS_OUTPUT.PUT_LINE (idx || ' = ' || nlist(idx) ); 
      total := total + nlist(idx); 
      idx   := nlist.NEXT(idx); 
   END LOOP; 
 
   DBMS_OUTPUT.PUT_LINE ('Total: ' || total); 
 
END;  
```
Executing this block of code produces the following results: 
 
East = 75 
North = 100 
South = 125 
West = 75 
Total: 375 
**How It Works** 
The FIRST method returns the lowest index value in the collection. In this case, the value is East, because 
the collection is sorted alphabetically. The loop is entered with idx initialized to the first value in the 
collection. The NEXT method returns the next index value alphabetically in the collection. The loop 
continues executing until the NEXT method returns a null value, which occurs after the last index value in 
the collect is retrieved. 
To traverse the collection in reverse alphabetical order, simply initialize the idx value to nlist.LAST. 
Then replace the nlist.NEXT with nlist.PRIOR. 
  Note The FIRST, NEXT, PRIOR, and LAST methods are most useful with associative arrays but also work with 
collections indexed by an integer. 

## 10-14. Trimming a Collection 
**Problem** 
You need to remove one or more items from the end of a non-INDEX BY collection. The DELETE method 
will not work because it applies only to INDEX BY collections. 
**Solution** 
Use the TRIM method to remove one or more elements from the end of the collection. In this example, a 
VARRY is initialized with five elements. The TRIM method is used to remove elements from the end of the 
collection. 
```sql
DECLARE 
 
TYPE    vtype   IS VARRAY(5) OF DATE; 
vdates  vtype := vtype (sysdate, sysdate+1, sysdate+2, sysdate+3, sysdate+4); 
 
BEGIN 
 
   DBMS_OUTPUT.PUT_LINE ('vdates size is: ' || vdates.COUNT); 
   vdates.TRIM; 
   DBMS_OUTPUT.PUT_LINE ('vdates size is: ' || vdates.COUNT); 
   vdates.TRIM(2); 
   DBMS_OUTPUT.PUT_LINE ('vdates size is: ' || vdates.COUNT); 
 
END;  
```
Executing this block of code produces the following results: 
 
vdates size is: 5 
vdates size is: 4 
vdates size is: 2 
**How It Works** 
The TRIM method deletes elements from the end of the collection including elements not initialized. It 
accepts an optional parameter for the number of elements to delete; otherwise, it defaults to the last 
element. The TRIM method applies to TABLE and VARRAY collections that are not indexed. If the underlying 
TYPE definition does not contain the INDEX BY clause, then you can invoke TRIM.  
The TRIM method is limited to removing elements from the end of a collection, whereas the DELETE 
method can remove elements anywhere in a collection. If you DELETE an element in the middle of a 
collection, then executing a FOR .. LOOP from one to the collection’s COUNT will not work properly. First, 
if you attempt to access the element that was deleted without checking whether it EXISTS, an exception is 
thrown. Second, the COUNT method will return a value that is less than the collection’s maximum index 
value, which means the FOR .. LOOP will not process all elements in the collection. 
