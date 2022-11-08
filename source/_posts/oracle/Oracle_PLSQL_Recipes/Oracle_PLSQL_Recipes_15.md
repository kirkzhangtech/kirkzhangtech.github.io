---
title: Oracle PLSQL Recipes 15-Java in the Database
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

# 15. Java in the Database 
 
Java plays an important role in the application development space today. It has become increasingly 
popular over the years, because it is cross-platform, powerful, and easy to learn. Although Java 
development is not directly related to PL/SQL, it is important for a PL/SQL developer to learn a bit about 
Java since there are some major benefits to using it to perform database tasks. Integrating the two 
languages when you’re building Oracle Database applications is a seamless effort. Oracle Database 11g 
contains JVM compatibility with Java 1.5, which includes substantial changes to the Java language, 
making it an even more complementary development platform. Also starting with Oracle 11g, the 
database includes a just-in-time compiler, which compiles Java bytecode into machine language 
instructions, making Java in the database run much faster. In 2010, Oracle acquired Sun Microsystems, 
so it now owns Java. This may help the database JVM compatibility remain in concert with the latest 
releases. 
In this chapter, you will learn how to combine the power of PL/SQL development with Java code 
that is stored within the database. You will learn how to create stored procedures, functions, and triggers 
using the Java language. Running Java in the database is a substantial topic that has filled entire books, 
but in this chapter, we will focus only on using the Java types in conjunction with PL/SQL applications—
which, after all, is the subject of this book. For complete documentation on using Java inside Oracle 
Database, please see the Oracle Java developers guide at 
http://download.oracle.com/docs/cd/E11882_01/java.112/e10588/toc.htm. 

## 15-1. Creating a Java Database Class  
**Problem** 
You want to write a Java class that will query the database and return a result.  
**Solution** 
Create a Java class that uses the Java Database Connectivity (JDBC) API to query the Oracle Database. 
For example, the Java class in the following example will query the EMPLOYEES table for all employees who 
belong to the IT department. The example entails a complete Java class that is named Employees. This 
class contains a method named getItEmps() that will become a Java stored procedure. The Employees 
class shown here will be stored into a file named Employees.java. 
 
import java.sql.*; 
import oracle.jdbc.*; 
```java
public class Employees { 
  public static void getItEmps(){ 
CHAPTER 15  JAVA IN THE DATABASE 
320 
      String firstName = null; 
      String lastName = null; 
      String email = null; 
      try { 
           Connection conn = DriverManager. 
                        getConnection("jdbc:default:connection:"); 
           String sql = "SELECT FIRST_NAME, LAST_NAME, EMAIL " +  
                        "FROM EMPLOYEES " + 
                        "WHERE DEPARTMENT_ID = 60"; 
           PreparedStatement pstmt = conn.prepareStatement(sql); 
           ResultSet rset = pstmt.executeQuery(); 
           while(rset.next()) { 
             firstName = rset.getString(1); 
             lastName = rset.getString(2); 
             email = rset.getString(3); 
             System.out.println(firstName + " " + lastName + " " + 
                                email); 
           } 
           pstmt.close(); 
           rset.close(); 
      } catch (SQLException ex){ 
          System.err.println("ERROR: " + ex); 
      }           
  }; 
```
The following lines from SQL*Plus show how to execute this Java in the database, followed by the
output from the program. Prior to executing the code, you must load it into the database and compile it.
You will learn more about doing this in the next recipe. To learn more about executing Java in the
database, please see Recipe 15-5. For now, it is important to see the output that will result from a
successful call to this Java program. 
```sql
SQL> exec get_it_emps;
Alexander Hunold AHUNOLD
Bruce Ernst BERNST
David Austin DAUSTIN
Valli Pataballa VPATABAL
Diana Lorentz DLORENTZ 
PL/SQL procedure successfully completed. 
```
The Java class in this example performs a simple query and then prints the result. Although this
class does not demonstrate the full potential of using Java, it is a good segue into Java database
development.  
**How It Works** 
Java is a mature language that can be used in conjunction with PL/SQL. Sometimes it makes sense to
code portions of your application in Java, while in other instances it may make sense to code the entire 
application in Java. Both PL/SQL and Java can coexist in the same application, and you must use PL/SQL 
to access Java via the database. 
This recipe demonstrates how to create a simple Java class that queries the database for EMPLOYEE 
records. The JDBC APIs provide a way for Java programs to methodically perform the tasks you will 
typically want to complete whenever you access a database, whether it’s querying data, updating 
records, or deleting rows.  
A Java class that you will use to access an Oracle Database as a stored procedure must adhere to a 
few standards. The class must be public, and each of its methods must be public and static. Failure to 
follow these standards will render the class methods inaccessible for use as stored procedures. 
The first step taken in the **Solution** to this recipe is to obtain a connection to the database. In a Java 
class that lives outside the database, obtaining a connection is a performance-intensive operation, and 
you must pass a user name and password along with the database host name. However, obtaining a 
connection using stored procedures is a bit different since they reside within the database itself. The 
only requirement is that you pass jdbc:default:connection to the getConnection() method. 
 
Next, the SQL query (sql) is formed as a String, and a PreparedStatement object (pstmt) is then 
created from it using the prepareStatement method. The prepared statement is what actually queries the 
database. The next line of code in the **Solution** issues the query by calling the executeQuery() method on 
the prepared statement object, which returns a result set. The result set is what you need to use in order 
to access the rows that have been returned via the query. Use a simple while loop to traverse the rows, 
and obtain each of the values from the result set within each iteration of the loop by indicating the 
position of the column you want to retrieve. For instance, to obtain the FIRST_NAME, you will call 
rset.getString(1) because FIRST_NAME is the first column that is listed within the query. 
Lastly, the class in the **Solution** closes the prepared statement and result set objects. Not doing so 
may cause issues such as memory leaks, although Java has a very efficient garbage collection system, so 
it should take care of this for you. Again, closing the objects is a form of good practice to ensure that 
resources can be reallocated. 
The Oracle Java virtual machine (JVM) also supports the use of SQLJ for database access. Use of 
SQLJ is beyond the scope of this book, but if you are interested in learning about it JVM, then please refer 
to the Oracle Java Developer Guide, which can be found at 
http://download.oracle.com/docs/cd/E11882_01/java.112/e10588/toc.htm. 

## 15-2. Loading a Java Database Class into a Database 
**Problem** 
You want to load a Java class into a schema within your Oracle Database. 
**Solution** #1 
You can use the CREATE JAVA command to load the Java source into the database by copying and pasting 
the Java source into a SQL file. This is the easiest way to create a Java class and then load it into the 
database if you are not working directly on the database server but rather remotely using an editor or 
SQL*Plus. The following lines of SQL code will load the Java class that was created in Recipe 15-1 into the 
database using the CREATE JAVA command: 
```sql
CREATE OR REPLACE JAVA SOURCE NAMED "Employees" AS 
import java.sql.*; 
import oracle.jdbc.*; 
 
public class Employees { 
  public static void getItEmps(){ 
      String firstName = null; 
      String lastName = null; 
      String email = null; 
      try { 
           Connection conn = DriverManager. 
                        getConnection("jdbc:default:connection:"); 
           String sql = "SELECT FIRST_NAME, LAST_NAME, EMAIL " +  
                        "FROM EMPLOYEES " + 
                        "WHERE DEPARTMENT_ID = 60"; 
 
           PreparedStatement pstmt = conn.prepareStatement(sql); 
           ResultSet rset = pstmt.executeQuery(); 
           while(rset.next()) { 
             firstName = rset.getString(1); 
             lastName = rset.getString(2); 
             email = rset.getString(3); 
             System.out.println(firstName + " " + lastName + " " + 
                                email); 
           } 
           pstmt.close(); 
           rset.close(); 
      } catch (SQLException ex){ 
          System.err.println("ERROR: " + ex); 
          } 
      }           
  };
```
Next, you need to compile the code. To do so, use the ALTER JAVA CLASS <name> RESOLVE command. 
The following line of code compiles the Employees Java source: 
 
ALTER JAVA CLASS "Employees" RESOLVE; 
**Solution** #2 
You can use the loadjava utility that is provided by Oracle in order to load Java code into the database. 
This situation works best if you are working directly on the database server and have access to the 
loadjava utility that is installed in the Oracle Database home. This utility is also nice to use if you already 
have the Java code stored in a file and do not want to copy and paste code into an editor or SQL*Plus. 
The following code demonstrates loading a Java source file named Employees.java using the loadjava 
utility: 
 
loadjava –user dbuser Employees.java 
 
After the command is issued, you will be prompted for the password to the user who you named 
using the –user option. By issuing the –resolve option, you will be loading the Java into the database and 
compiling at the same time. This saves you the step of issuing the ALTER JAVA CLASS <name> RESOLVE 
command. 
**How It Works** 
You can load Java source code into the database directly using the CREATE JAVA SOURCE command. This 
will load the source and make it accessible to the schema in which it was loaded. Once loaded, you can 
create a call specification for any of the class methods that you want to make into a stored procedure or 
function. The call specification maps the Java method names, parameter types, and return types to their 
SQL counterparts. You will learn more about creating call specifications in Recipe 15-4. We recommend 
compiling the source using the RESOLVE command before attempting to invoke any of its methods. 
However, if you do not issue the RESOLVE command, then Oracle Database will attempt to compile the 
Java source dynamically at runtime.  
 Note A class name can be a maximum of 30 characters in length. If the specified name is more than 30 
characters in length, then Oracle will automatically shorten it for you and create and use a map to correlate the 
long name with the shortened name. You can still specify the long name in most cases, and Oracle will 
automatically convert that name to the shortened name for you. However, in some cases you will need to use the 
DBMS_JAVA.SHORTNAME('long_classname') function to map the name for you. Conversely, if you want to retrieve 
the long name by using its corresponding short name, you can use the 
DBMS_JAVA.LONGNAME('short_classname') function. 
The loadjava utility, which is the tool you use to implement the second **Solution**, uses the CREATE 
JAVA command to load the Java into the database. It also allows you to specify the –resolve option, 
which will compile the code once it has been loaded. The advantage to using loadjava is that you can 
load Java source files directly into the database without the need to create a separate SQL file containing 
the CREATE JAVA command or copy and paste the Java class into SQL*Plus. The downside is that you 
must have access to the loadjava binary executable that resides on the Oracle Database server. This 
utility can also be used to load files of type .class, .sqlj. ,  .properties,  and .ser. 
If your code is unable to compile because of errors, then it will not execute if you attempt to invoke 
one of its methods. You must repair the error(s) and ensure that the code compiles successfully before it 
can be used. If your code does not compile, then you can check the USER_ERRORS table to see what 
issue(s) are preventing the code from compiling successfully. The USER_ERRORS table describes the 
current errors on all the objects that are contained within the user’s schema. To learn more about 
querying the USER_ERRORS table, please refer to Recipe 15-15. 

## 15-3. Loading a Compiled Java Class Into the Database 
**Problem** 
You want to load a compiled Java class into the database so that you can use one or more of its methods 
as stored procedures. 
**Solution** 
Use the loadjava command-line utility to load the compiled Java class into the database. The following 
line of code demonstrates how to use the loadjava utility to load a compiled Java class file named 
Employees.class into the database. 
 
loadjava -user dbuser -resolve Employees.class 
You will be prompted to enter the password for the database user who you designated when issuing 
the command. 
**How It Works** 
The loadjava utility can be used to load compiled Java class files into the database. To do so, you have 
access to the binary loadjava utility executable. Usually this means you are located directly on the 
Oracle Database server hosting the database that you want to load the Java into. Before you can invoke 
the loadjava utility, you should be sure that the ORACLE_SID for the target database has been set. If the 
server on which you are located contains more than one Oracle home, then it is a good idea to also set 
the ORACLE_HOME environment variable to be sure you will be invoking the correct version of the loadjava 
utility for your database. The loadjava utility is located within the bin directory of the Oracle Database 
home. The following statements show how to set these two environment variables on a Windows 
machine: 
```sql
SET ORACLE_SID=MYDATABASE 
SET ORACLE_HOME=<PATH_TO_ORACLE_HOME> 
```
If you happen to be working on a Unix or Linux machine, the equivalent commands would be as 
follows: 
```sql
setenv ORACLE_SID = MYDATABASE 
setenv ORACLE_HOME= <PATH_TO_ORACLE_HOME> 
```
You must have the following permissions in order to use the loadjava utility: 
• CREATE PROCEDURE 
• CREATE TABLE 
• Oracle.aurora.security.JServerPermission.loadLibraryInClass.classname 
 
Several options are at your disposal when using loadjava to load source or compiled class files into 
the database. The –resolve option can be used to compile Java source and mark it as VALID within the 
Oracle Database. The –resolver option can be used for locating other Java class files that your code is 
dependant upon. For a complete listing of loadjava options, please see the online Oracle 
documentation, which can be found at 
http://download.oracle.com/docs/cd/E11882_01/java.112/e10588/cheleven.htm#CACFHDJE. 
 
The loadjava utility is a member of the DBMS_JAVA package, and it can be invoked directly from 
within your PL/SQL code as well. To do this, issue a call to DBMS_JAVA.loadjava, and pass the options 
separated by spaces. This is demonstrated by the following lines of text in SQL*Plus: 
 
call dbms_java.loadjava(‘Employees.class’); 


## 15-4. Exposing a Java Class As a Stored Procedure 
**Problem** 
You have created a Java stored procedure and loaded it into the database, and now you want to access it 
via PL/SQL. 
**Solution** 
Create a PL/SQL call specification for the Java class. The PL/SQL call specification will essentially wrap 
the call to the Java class, enabling you to have access to the class from PL/SQL. The following code 
demonstrates the creation of a call specification for the Java class that was created in Recipe 15-1 and 
loaded into the database in Recipe 15-2. 
```sql
CREATE OR REPLACE PROCEDURE get_it_emps AS LANGUAGE JAVA 
NAME 'Employees.getItEmps()'; 
```
**How It Works** 
To make the Java class accessible from the database, you must create a PL/SQL call specification 
(sometimes known as PL/SQL wrapper) for the stored Java code. A call specification maps a Java method 
call to a PL/SQL procedure so that the Java code can be called from the database directly. A call 
specification also maps any parameters and return type to the Java code. To learn more about mapping 
parameters and return types, please see Recipe 15-7. 
The call specification for a Java stored procedure is a PL/SQL procedure itself that specifies AS 
LANGUAGE JAVA, followed by the name of the Java class and method that will be mapped to the procedure 
name. The name of the Java method to be invoked must be preceded by the Java class name that 
contains it. This is because the method has been defined as static, meaning it is a class method rather 
than an instance method. When a call to the specification is made, Oracle will automatically call the 
underlying Java class method. 
 Note Two types of methods can be created in a Java class: class methods and instance methods. Class 
methods belong to the class, rather than to an instance of the class. This means the methods are instantiated once 
for each class. Instance methods belong to an instance of the class. This means that if a new instance of the class 
is created, a new method will be created with that instance. Class methods have access to class variables 
(otherwise known as static), whereas instance methods have access only to instance variables. 

## 15-5. Executing a Java Stored Procedure 
**Problem** 
You want to execute a Java stored procedure that you have created from within SQL*Plus. 
CHAPTER 15  JAVA IN THE DATABASE 
326 
**Solution** 
Call the PL/SQL call specification that maps to the Java stored procedure. The following SQL*Plus code 
demonstrates how to execute the Java class for which you created a call specification in Recipe 15-3. 
```sql
SQL> set serveroutput on 
SQL> call dbms_java.set_output(2000); 
 
Call completed. 
 
SQL> exec get_it_emps; 
Alexander Hunold AHUNOLD 
Bruce Ernst BERNST 
David Austin DAUSTIN 
Valli Pataballa VPATABAL 
Diana Lorentz DLORENTZ 
 
PL/SQL procedure successfully completed.
``` 
As you can see, when the code is executed, the results are returned to SQL*Plus and displayed as if it 
were the output of a PL/SQL procedure or function. 
**How It Works** 
Java can be executed directly from within the database once a call specification has been made for the 
corresponding Java method. Since the call specification is a PL/SQL procedure itself, you can invoke the 
underlying Java just as if it were PL/SQL using the EXEC command from SQL*Plus or call it from any other 
PL/SQL block as if it were PL/SQL as illustrated in Recipe 15-6. To see any output from the Java, you 
must set the buffer size appropriately to display it. If the buffer size is not set, then no output will be 
displayed. Similarly, if the buffer size is set too small, then only a portion of the output will be displayed. 
Personally, we recommend setting the output size to 2000 and moving up from there if needed. To set 
the buffer size, issue this command: 
 
`CALL DBMS_JAVA.SET_OUTPUT(buffer_size); `
The Java will be executed seamlessly and display the result, if any, just as if it were a PL/SQL 
response. In the **Solution** to this recipe, the get_it_emps PL/SQL procedure is called. Since get_it_emps is 
a call specification, it will invoke the underlying Java class method getItEmps() that actually performs the 
query and displays the content. 

## 15-6. Calling a Java Stored Procedure from PL/SQL 
**Problem** 
You want to access a Java stored procedure from within one of your PL/SQL applications. For instance, 
you are creating a PL/SQL procedure, and you want to make a call to a Java stored procedure from 
within it. 
**Solution** 
Make a call to the Java stored procedure using the call specification that you created for it. The following 
code demonstrates a PL/SQL package that makes a call to a Java stored procedure and then resumes 
PL/SQL execution once the call has been made. 
```sql
CREATE OR REPLACE PROCEDURE employee_reports AS 
  CURSOR emp_cur IS 
  SELECT first_name, last_name, email 
  FROM employees 
  WHERE department_id = 50; 
 
  emp_rec    emp_cur%ROWTYPE; 
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Employees from Shipping Department'); 
  DBMS_OUTPUT.PUT_LINE('----------------------------------'); 
  FOR emp_rec IN emp_cur LOOP 
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' ||  
                         emp_rec.last_name || ' ' || 
                         emp_rec.email); 
  END LOOP; 
   
  DBMS_OUTPUT.PUT_LINE('=========================================='); 
  DBMS_OUTPUT.PUT_LINE('Employees from IT Department'); 
  DBMS_OUTPUT.PUT_LINE('----------------------------'); 
  get_it_emps; 
END; 
```
This results in the following output: 
```sql
SQL> EXEC EMPLOYEE_REPORTS 
Employees from Shipping Department 
---------------------------------- 
Matthew Weiss MWEISS 
Adam Fripp AFRIPP 
… 
Alana Walsh AWALSH 
Kevin Feeney KFEENEY 
Donald OConnell DOCONNEL 
Douglas Grant DGRANT 
========================================== 
Employees from IT Department 
---------------------------- 
Alexander Hunold AHUNOLD 
Bruce Ernst BERNST 
David Austin DAUSTIN 
Valli Pataballa VPATABAL 
Diana Lorentz DLORENTZ 
 
PL/SQL procedure successfully completed. 
```
The call to the Java stored procedure from within the PL/SQL procedure is seamless. It is integrated 
into the PL/SQL procedure body and invoked as if it were PL/SQL. 
**How It Works** 
The call specification publishes the Java stored procedure as if it were a PL/SQL procedure. This allows 
for seamless integration of Java stored procedures and PL/SQL. In the **Solution** to this recipe, the 
EMPLOYEES table is queried via a PL/SQL cursor for all employees who belong to department 50. That 
cursor is then parsed, and the results are displayed. After the cursor results have been processed, a call is 
made to the Java stored procedure getItEmps() using the call specification get_it_emps. The Java stored 
procedure is executed, and its results are displayed along with those from the PL/SQL cursor processing. 
As you can see, Java can be executed from PL/SQL just as if it were native PL/SQL code. It can be 
very useful to create database jobs utilizing Java stored procedures by developing a PL/SQL stored 
procedure or anonymous block that makes a series of calls to different Java stored procedures or 
functions that perform the actual processing. PL/SQL and Java in the database can be very 
complementary to each other. 

## 15-7. Passing Parameters Between PL/SQL and Java 
**Problem** 
You want to pass parameters from PL/SQL to a Java stored procedure that expects them. 
**Solution** 
Create a call specification that accepts the same number of parameters as the number the Java stored 
procedure expects. For this example, an additional method will be added to the Employee Java class that 
was created in Recipe 15-1. This method will be an enhanced version of the original method that will 
accept a department ID as an input argument. It will then query the database for the employees who 
belong to that department and display them.  
The following code is the enhanced Java method that will be added the Employees class contained 
within the Employees.java file: 
```sql
public static void getItEmpsByDept(int departmentId){ 
      String firstName = null; 
      String lastName = null; 
      String email = null; 
      try { 
           Connection conn = DriverManager. 
                        getConnection("jdbc:default:connection:"); 
           String sql = "SELECT FIRST_NAME, LAST_NAME, EMAIL " +  
                        "FROM EMPLOYEES " + 
                        "WHERE DEPARTMENT_ID = ?"; 
 
           PreparedStatement pstmt = conn.prepareStatement(sql); 
           pstmt.setInt(1, departmentId); 
           ResultSet rset = pstmt.executeQuery(); 
           while(rset.next()) { 
             firstName = rset.getString(1); 
             lastName = rset.getString(2); 
  CHAPTER 15  JAVA IN THE DATABASE 
329 
             email = rset.getString(3); 
             System.out.println(firstName + " " + lastName + " " + 
                                email); 
           } 
           pstmt.close(); 
           rset.close(); 
      } catch (SQLException ex){ 
          System.err.println("ERROR: " + ex); 
          } 
  } 
```
Once this method has been added to the Employees class, then the Java source should be loaded into 
the database using the technique demonstrated in Recipe 15-2.  
 Note You must include the OR REPLACE clause of the CREATE JAVA statement if the Employees source is 
already contained in the database. If you do not include this clause, then you will receive an Oracle error. 
Once the Java has been loaded into the database and compiled, you will need to create the call 
specification that will be used by PL/SQL for accessing the Java stored procedure. The following code 
demonstrates a call specification that will accept a parameter when invoked and pass it to the Java 
stored procedure: 
```sql
CREATE OR REPLACE PROCEDURE get_it_emps_by_dept(dept_id IN NUMBER) 
 AS LANGUAGE JAVA 
NAME 'Employees.getItEmpsByDept(int)'; 
```
The procedure can now be called by passing a department ID value as such: 
```sql
SQL> exec get_it_emps_by_dept(60);                          
Alexander Hunold AHUNOLD 
Bruce Ernst BERNST 
David Austin DAUSTIN 
Valli Pataballa VPATABAL 
Diana Lorentz DLORENTZ 
 
PL/SQL procedure successfully completed.
```
**How It Works** 
The call specification is what determines how a Java stored procedure or function’s arguments are 
mapped to PL/SQL arguments. To implement parameters, the call specification must match each 
parameter in the stored procedure or function to an argument in the specification. As mentioned in 
previous recipes, the call specification is a PL/SQL procedure itself, and each argument that is coded in 
the specification matches an argument that is coded within the Java stored procedure.  
The datatypes that Java uses do not match those used in PL/SQL. In fact, a translation must take 
place when passing parameters listed as a PL/SQL datatype to a Java stored procedure that accepts 
parameters as a Java datatype. If you are familiar enough with each of the two languages, the translation 
is fairly straightforward. However, there are always those cases where one is not sure what datatype to
match against. Table 15-1 lists some of the most common datatypes and how they map between Java
and PL/SQL. For a complete datatype map, please refer to the Oracle documentation at
http://download.oracle.com/docs/cd/B28359_01/java.111/b31225/chsix.htm#CHDFACEE. 
```text
Table 15-1. Datatype Map 
SQL Datatype      Java Type 
CHAR              oracle.sql.CHAR 
VARCHAR           java.lang.String 
LONG              java.lang.String 
NUMBER            java.lang.Integer,Java.lang.Float,Java.lang.Double,Java. math.BigDecimal,Java.lang.Byte,Oracle.sql.NUMBER,Java.lang.Short, 
DATE              oracle.sql.DATE 
TIMESTAMP         oracle.sql.TIMESTAMP 
TIMESTAMP         WITH TIME ZONE oracle.sql.TIMESTAMPTZ 
TIMESTAMP         WITH LOCAL TIME ZONE  oracle.sql.TIMESTAMPLTZ 
BLOB              oracle.sql.BLOB 
CLOB              oracle.sql.CLOB 
```
Creating a PL/SQL call specification that includes parameters must use the fully qualified Java class
name when specifying the parameter datatypes in the Java class method signature. If an incorrect
datatype is specified, then an exception will be thrown. For instance, if you want to pass a VARCHAR2 from
PL/SQL to a Java stored procedure, the signature for the Java class method must accept an argument of
type java.lang.String. The following pseudocode demonstrates this type of call specification: 
CREATE OR REPLACE PROCEDURE procedure_name(value   VARCHAR2)
AS LANGUAGE JAVA 
NAME ‘JavaClass.javaMethod(java.lang.String)’; 

## 15-8. Creating and Calling a Java Database Function 
**Problem** 
You want to create a database function using the Java language. 
  CHAPTER 15  JAVA IN THE DATABASE 
331 
**Solution** 
Create a function written in Java, and then create a call specification for the function. Ensure that the call 
specification allows for the same number of parameters to pair up with the Java function and allows for a 
returning result. For this recipe, you will add a function to the Employees Java class that will accept an 
employee ID and return that employee’s job title. The following code is the Java source for the function 
named getEmpJobTitle: 
```java
public static String getEmpJobTitle(int empId){ 
      String jobTitle = null; 
      try { 
           Connection conn = DriverManager. 
                        getConnection("jdbc:default:connection:"); 
           String sql = "SELECT JOB_TITLE " +  
                        "FROM EMPLOYEES EMP, " + 
            "JOBS JOBS " + 
                        "WHERE EMP.EMPLOYEE_ID = ? " + 
                         "AND JOBS.JOB_ID = EMP.JOB_ID"; 
 
           PreparedStatement pstmt = conn.prepareStatement(sql); 
           pstmt.setInt(1, empId); 
           ResultSet rset = pstmt.executeQuery(); 
           while(rset.next()) { 
             jobTitle = rset.getString(1); 
           } 
           pstmt.close(); 
           rset.close(); 
                          } catch (SQLException ex){ 
                                     System.err.println("ERROR: " + ex); 
                                     jobTitle = "N/A"; 
          } 
                  if (jobTitle == null){ 
                       jobTitle = "N/A"; 
                 } 
                                    return jobTitle; 
  } 
```
Next is the call specification for the function: 
 
CREATE OR REPLACE FUNCTION get_emp_job_title(emp_id IN NUMBER) 
RETURN VARCHAR2 AS LANGUAGE JAVA 
NAME 'Employees.getEmpJobTitle(int) return java.lang.String'; 
The function can now be called just like a PL/SQL function would. The following lines of code show 
a SQL SELECT statement that calls the function passing an employee ID number of 200. 
```sql
SQL> select get_emp_job_title(200) from dual; 
 
GET_EMP_JOB_TITLE(200) 
-------------------------------------------------------------------------------- 
Administration Assistant 
```

**How It Works** 
The difference between a stored procedure and a stored function is that a function always returns a 
value. In the Java language, a method may or may not return a value. The difference between a PL/SQL 
call specification for a Java stored procedure and a PL/SQL call specifcation for a Java function is that the 
PL/SQL call specification will specify a return value if it is being used to invoke an underlying function.  
In the **Solution** to this recipe, the example PL/SQL call specification returns a VARCHAR2 data type because 
the Java function that is being called will return a Java String. 
## 15-9. Creating a Java Database Trigger 
**Problem** 
You want to create a database trigger that uses a Java stored procedure to do its work. 
**Solution** 
Create a Java stored procedure that does the work you require, and publish it as a Java stored procedure, 
making it accessible to PL/SQL. Once it’s published, write a standard PL/SQL trigger that calls the Java 
stored procedure. 
For example, suppose you need a trigger to audit INSERT events on the EMPLOYEES table and record 
them in another table. First, you must create the table that will be used to record each of the logged 
events. The following DDL creates one: 
```sql
CREATE TABLE EMPLOYEE_AUDIT_LOG ( 
employee_id     NUMBER, 
enter_date      DATE); 
Next, you will need to code the Java stored procedure that you want to have executed each time an 
INSERT occurs on the EMPLOYEES table. Add the following Java method to the Employees class of previous 
recipes in this chapter: 
public static void employeeAudit(int empId){ 
      try { 
           Connection conn = DriverManager. 
                        getConnection("jdbc:default:connection:"); 
           String sql = "INSERT INTO EMPLOYEE_AUDIT_LOG VALUES(" + 
                    "?, sysdate)"; 
           PreparedStatement pstmt = conn.prepareStatement(sql); 
           pstmt.setInt(1, empId); 
           pstmt.executeUpdate(); 
       pstmt.close(); 
       conn.commit(); 
       
      } catch (SQLException ex){ 
          System.err.println("ERROR: " + ex); 
          } 
       
  } 
```
Next, the PL/SQL call specification for the Java stored procedure must be created. The following is 
the code to implement the call specification: 
```sql
CREATE OR REPLACE PROCEDURE emp_audit(emp_id NUMBER) 
AS LANGUAGE JAVA 
NAME 'Employees.employeeAudit(int)'; 
```

Finally, a trigger to call the EMP_AUDIT procedure must be created. The trigger will be executed on 
INSERT to the EMPLOYEES table. The following code will generate the trigger to call EMP_AUDIT: 
```sql
CREATE OR REPLACE TRIGGER emp_audit_ins 
AFTER INSERT ON EMPLOYEES 
FOR EACH ROW 
CALL emp_audit(:new.employee_id); 
```

Once all these pieces have been successfully created within the database, the EMP_AUDIT_INS trigger 
will be executed each time there is an INSERT made to the EMPLOYEES table. In turn, the trigger will call the 
EMP_AUDIT PL/SQL procedure, which calls the Java method contained within the Employees class. The 
SQL*Plus output shown here demonstrates an INSERT into the EMPLOYEES table, followed by a query on 
the EMPLOYEE_AUDIT_LOG table to show that the trigger has been invoked: 
```sql
SQL> insert into employees values( 
   employees_seq.nextval, 
   'Jane', 
   'Doe', 
   'jane.doe@mycompany.com', 
   null, 
   sysdate, 
   'FI_MGR', 
   null, 
   null, 
   null, 
   null); 
 
1 row created. 

SQL> select * from employee_audit_log; 
 
EMPLOYEE_ID ENTER_DAT 
----------- --------- 
    265 02-NOV-10 

```

**How It Works** 
A Java-based trigger combines the power of Java code with the native ease of performing data 
manipulation using PL/SQL triggers. Although creating a Java trigger requires more steps than using 
native PL/SQL, the Java code is portable. If your application is supported on more than one database 
platform, this lets you write code once and deploy it in many environments. It also makes sense to code 
a trigger using Java if you require the use of Java libraries or technologies that are unavailable to PL/SQL. 
In the **Solution** to this recipe, a trigger was created that will insert a row into an audit table each time 
an INSERT is made on the EMPLOYEES table. The actual work is performed within a Java method that is 
added to a Java class and loaded into the database. For more information on loading Java into the 
database, please see Recipe 15-2. To invoke the stored Java method, you must create a PL/SQL call 
specification, which maps the Java method to a PL/SQL stored procedure. The call specification can 
accept zero, one, or many parameters, and it will seamlessly pass the parameters to the underlying Java 
method. The final step to creating a Java trigger is to code a PL/SQL trigger that invokes the PL/SQL 
stored procedure that was created. 
Creating a Java-based trigger entails a series of steps. Each piece of code depends upon the others, 
and like a domino effect, the trigger will call the procedure that in turn executes the Java method. This 
**Solution** opens the world of Java libraries and thousands of possibilities to the standard PL/SQL trigger. 

## 15-10. Passing Data Objects from PL/SQL to Java 
**Problem** 
You have retrieved a row of data from the database using PL/SQL, and you want to populate a PL/SQL 
object type with that data and then pass the populated data object to a Java procedure.  
**Solution** 
Create a PL/SQL object type, along with a call specification for the Java stored procedure that you want 
to pass the object to. Ensure that the Java stored procedure accepts an object of type oracle.sql.STRUCT 
and that the call specification accepts the PL/SQL object type you have created. For this recipe, the 
example will demonstrate the creation of a Java method that will accept an Employee object and return 
that employee’s corresponding department name. The Java code will be invoked from within a PL/SQL 
anonymous block that queries each employee, loads an Employee object with the data, passes the object 
to the Java method, and returns the result. 
First, add the following Java method to the Employees class you’ve used with previous recipes in this 
chapter: 
```java
public static String getEmpDepartment(oracle.sql.STRUCT emp) { 
     
    String deptName = null; 
    BigDecimal employeeId = null; 
    try { 
          Object[] attribs = emp.getAttributes(); 
       // Use indexes to grab individual attributes. 
       Object empId = attribs[0]; 
       try{ 
           employeeId = (BigDecimal) empId; 
       } catch (ClassCastException cce) { 
           System.out.println(cce); 
       } 
       Connection conn = DriverManager. 
                        getConnection("jdbc:default:connection:"); 
           String sql = "SELECT DEPARTMENT_NAME " +  
                        "FROM DEPARTMENTS DEPT, " + 
            "EMPLOYEES EMP " + 
                        "WHERE EMP.EMPLOYEE_ID = ? " + 
            "AND DEPT.DEPARTMENT_ID = EMP.DEPARTMENT_ID"; 
 
           PreparedStatement pstmt = conn.prepareStatement(sql); 
           pstmt.setInt(1, employeeId.intValue()); 
           ResultSet rset = pstmt.executeQuery(); 
           while(rset.next()) { 
             deptName = rset.getString(1); 
           } 
           pstmt.close(); 
           rset.close(); 
      } catch (java.sql.SQLException ex){ 
          System.err.println("ERROR: " + ex); 
          deptName = "N/A"; 
          } 
      if (deptName == null){ 
        deptName = "N/A"; 
      } 
      return deptName; 
  }
```
Next, create the PL/SQL object that will contain employee information. The following SQL 
statement will create this object: 
```sql
CREATE TYPE Employee AS OBJECT ( 
emp_id NUMBER(6), 
first VARCHAR2(20), 
last  VARCHAR2(25), 
email VARCHAR2(25), 
job VARCHAR2(10), 
dept NUMBER(4) 
); 
```
Now you need to create the call specification for the Java method. Since the method is returning a 
value, the call specification needs to be a PL/SQL function that accepts an Employee object and returns a 
String value. The following code demonstrates such a call specification for the getEmpDepartment Java 
method: 
```sql
CREATE OR REPLACE FUNCTION get_emp_department (emp Employee) RETURN VARCHAR2 AS 
LANGUAGE JAVA 
NAME 'Employees.getEmpDepartment(oracle.sql.STRUCT) return java.lang.String'; 
```
Finally, call the new Java function from within an anonymous block. The following PL/SQL block 
uses a cursor to traverse the EMPLOYEES table and populates an Employee object with each iteration. In 
turn, the object is passed to the Java stored procedure via the PL/SQL function GET_EMP_DEPARTMENT, and 
the corresponding DEPARTMENT_NAME is returned. 
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT * FROM EMPLOYEES; 
   
  emp_rec    emp_cur%ROWTYPE; 
  emp        Employee; 
BEGIN 
  FOR emp_rec IN emp_cur LOOP 
    emp := Employee(emp_rec.employee_id, 
                    emp_rec.first_name, 
                    emp_rec.last_name, 
                    emp_rec.email, 
                    emp_rec.job_id, 
                    emp_rec.department_id); 
    DBMS_OUTPUT.PUT_LINE(emp.first || ' ' || emp.last || ' - ' || 
            get_emp_department(emp)); 
  END LOOP; 
END; 
```
**How It Works** 
Passing objects to Java code should be second nature to you since Java is an object-oriented language. 
You can create PL/SQL objects as well and use them within your PL/SQL and Java mashup applications. 
The **Solution** to this recipe demonstrated the creation of an Employee object in PL/SQL that was passed to 
Java.  
To accept a PL/SQL object type, Java code must use a parameter of type oracle.sql.STRUCT in place 
of the object. The STRUCT object is basically a container that allows the contents to be accessed by calling 
the getAttributes method. In the **Solution** to this recipe, the oracle.sql.STRUCT object is accepted in the 
Java class as a parameter, and then the getAttributes method is called on it. This creates an array of 
objects that contains the data. The Java stored procedure accesses the object using the 0 index position, 
which is the first placeholder from the PL/SQL object. This position maps to the emp_id field in the 
PL/SQL object. The Java class then uses that emp_id to query the database and retrieve a corresponding 
DEPARTMENT_ID if it exists. 
The call specification must accept the PL/SQL object type as a parameter but use the 
oracle.sql.STRUCT object as the parameter in the Java source signature. When the object is passed to the 
PL/SQL call specification procedure, it will be converted into an oracle.sql.STRUCT object, which is a 
datatype that a Java class can accept. 
Organizing your data into objects can be useful, especially when the object you are creating does 
not match a table definition exactly. For instance, you could create an object that contains employee 
information along with region information. There are no tables that contain both of these fields, so in 
order to retrieve the information together, you are forced into either using a SQL query that contains 
table joins or creating a database view. In such a case, it may be easier to populate the object using 
PL/SQL and then hand it off to the Java program for processing. 

## 15-11. Embedding a Java Class Into a PL/SQL Package 
**Problem** 
You are interested in creating a Java class and making each of its methods and attributes available to 
PL/SQL in an organized unit of code. 
**Solution** 
Use a PL/SQL package to declare each of the attributes and methods that reside within the Java class, 
and then create separate call specifications for each of the Java methods within the PL/SQL package 
body. The following code demonstrates the creation of a PL/SQL package named EMP_PKG, which 
declares each of the methods that reside within the Employee Java class and makes them available to 
PL/SQL via call specifications that are implemented within the package body. 
First, create the package header as follows: 
```sql
CREATE OR REPLACE PACKAGE EMP_PKG AS 
 
    PROCEDURE get_it_emps; 
    PROCEDURE get_it_emps_by_dept(dept_id IN NUMBER); 
    PROCEDURE emp_audit(emp_id NUMBER); 
     
    FUNCTION get_emp_job_title(emp_id IN NUMBER) RETURN VARCHAR2; 
    FUNCTION get_emp_department (emp Employee) RETURN VARCHAR2; 
 
END; 
Next, create the package body as follows, adding a call specification for each Java method or 
attribute you plan to use: 
 
CREATE PACKAGE BODY EMP_PKG AS 
 
    PROCEDURE get_it_emps 
    AS LANGUAGE JAVA 
    NAME 'Employees.getItEmps()'; 
     
    PROCEDURE get_it_emps_by_dept(dept_id IN NUMBER) 
    AS LANGUAGE JAVA 
    NAME 'Employees.getItEmpsByDept(int)'; 
     
    PROCEDURE emp_audit(emp_id NUMBER) 
    AS LANGUAGE JAVA 
    NAME 'Employees.employeeAudit(int)'; 
     
    FUNCTION get_emp_job_title(emp_id IN NUMBER) RETURN VARCHAR2 
    AS LANGUAGE JAVA 
    NAME 'Employees.getEmpJobTitle(int) return String'; 
     
    FUNCTION get_emp_department (emp Employee) RETURN VARCHAR2 
    AS LANGUAGE JAVA 
    NAME 'Employees.getEmpDepartment(oracle.sql.STRUCT) return java.lang.String'; 
 
END; 
```
Now the package can be used to call each of the underlying Java stored procedures instead of having 
separate PL/SQL procedures and functions for each. The following anonymous block has been modified 
to make use of the PL/SQL package for calling GET_EMP_DEPARTMENT rather than a stand-alone function. 
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT * FROM EMPLOYEES; 
   
  emp_rec    emp_cur%ROWTYPE; 
  emp        Employee; 
BEGIN 
  FOR emp_rec IN emp_cur LOOP 
    emp := Employee(emp_rec.employee_id, 
                    emp_rec.first_name, 
                    emp_rec.last_name, 
                    emp_rec.email, 
                    emp_rec.job_id, 
                    emp_rec.department_id); 
    DBMS_OUTPUT.PUT_LINE(emp.first || ' ' || emp.last || ' - ' || 
            emp_pkg.get_emp_department(emp)); 
  END LOOP; 
END; 
```
**How It Works** 
In programming, it is a best practice to organize code in a way that makes it easy to maintain.  Placing 
related procedures and functions inside a single PL/SQL package is one such application of that 
approach. The same can be said for working with Java code in the database. A few Java stored 
procedures or functions will not cause much trouble to maintain. However, once you start to 
accumulate more than a handful within the same underlying Java class, then it is a good idea to 
consolidate the call specifications into a single PL/SQL package. 
In the **Solution** to this recipe, all the Java stored procedures that are contained within the Employees 
Java class have call specifications that are grouped into a single PL/SQL package. If you create one 
PL/SQL package containing call specifications per each Java class that is loaded into the database, you 
will have a nicely organized environment. In some cases, you may have more than one Java class that 
contains the implementations that are to be used within a single PL/SQL application. In those cases, it 
may make more sense to combine all call specifications into a single PL/SQL package.  
Using PL/SQL package to group call specifications is a good idea. Not only will this technique make 
for easier maintenance, but it also makes for more uniform applications with consistent interfaces. 

## 15-12. Loading Java Libraries Into the Database 
**Problem** 
You want to create a Java class that utilizes some external Java libraries. To do so, you must load those 
external libraries into the database. 
**Solution** 
Use the loadjava utility to store the external libraries into the database. In this example, a Java utility 
class containing a method that uses the JavaMail API to send e-mail will be loaded into the database. The 
method relies on some external Java libraries to use the JavaMail API. The following loadjava commands 
demonstrate the loading of three essential JAR files for using the JavaMail API: 

loadjava –u <username> mail.jar 
loadjava –u <username> standard.jar 
loadjava –u <username> activation.jar 
 
Next, load the Java source for the JavaUtils class into the database: 
```sql
CREATE OR REPLACE JAVA SOURCE NAMED "JavaUtils" AS 
import java.util.*; 
import java.util.logging.Level; 
import java.util.logging.Logger; 
import javax.activation.*; 
import javax.mail.*; 
import javax.mail.internet.*; 
import javax.naming.*; 
 
public class JavaUtils { 
 
 public static void sendMail(String subject, 
            String recipient, 
            String message) { 
        try { 
 
            Properties props = System.getProperties(); 
            props.put("mail.from", "me@mycompany.com"); 
            props.put("mail.smtp.host","company.smtp.server"); 
            Session session = Session.getDefaultInstance(props,null); 
            Message msg = new MimeMessage(session); 
            msg = new MimeMessage(session); 
            msg.setSubject(subject); 
            msg.setSentDate(new java.util.Date()); 
            msg.setFrom(); 
             
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient, 
false)); 
             
            MimeBodyPart body = new MimeBodyPart(); 
            body.setText(message); 
            Multipart mp = new MimeMultipart(); 
            mp.addBodyPart(body); 
            msg.setContent(mp); 
 
            Transport.send(msg); 
        } catch (MessagingException ex) { 
            Logger.getLogger(JavaUtils.class.getName()).log(Level.SEVERE, null, ex); 
        }  
    };
```
Compile the Java sources using the ALTER JAVA SOURCE command. The sources should compile 
without issues since the JAR files containing the required library references have been loaded into the 
database. If the JAR files had not been loaded, then the class would not compile successfully. 

`ALTER JAVA SOURCE "JavaUtils" RESOLVE;` 
Lastly, create the call specification for the sendMail Java stored procedure. In this case, a PL/SQL 
package will be created that contains the call specification for sendMail. 
```sql 
CREATE OR REPLACE PACKAGE JAVA_UTILS AS 
    PROCEDURE send_mail(subject VARCHAR2, 
                        recipient VARCHAR2, 
                        message VARCHAR2); 
    
END; 
CREATE OR REPLACE PACKAGE BODY JAVA_UTILS AS 
    PROCEDURE send_mail(subject VARCHAR2, 
                        recipient VARCHAR2, 
                        message VARCHAR2) 
    AS LANGUAGE JAVA 
    NAME 'JavaUtils.sendMail(java.lang.String, java.lang.String, java.lang.String)'; 
    
END; 
```
The stored procedure can now be executed using the following command: 
EXEC java_utils.send_mail('Test','myemail@mycompany.com','Test Message'); 
If the message is sucessfully sent, you will see the following output: 
PL/SQL procedure successfully completed. 
**How It Works** 
Java libraries are packaged into JAR files so that they can be easily distributed. The loadjava utility can
be used to load Java libraries into the database. To use the utility, download the JAR files that you want to
load into the database, and place them into a directory that can be accessed by the database server.
Open the command prompt or terminal, traverse into that directory, and execute the loadjava utility,
using the –u flag to specify the database user and passing the name of the JAR file to load. If successful,
the JAR file will be loaded into the schema that you indicated with the –u flag, and you may begin to use
the libraries contained in the JAR file within your stored Java code. 
The loadjava utility contains a number of options. For a complete listing of loadjava options, please
see the online Oracle documentation at
http://download.oracle.com/docs/cd/B28359_01/java.111/b31225/cheleven.htm. 
Additional options are not necessary to load a JAR file into the schema that you indicate with the -u
flag. Since the JAR file consists of compiled Java libraries, there is no need to resolve the library once
loaded. As indicated in the **Solution** to this recipe, you can begin to import classes from the libraries as
soon as they have been loaded. 

## 15-13. Removing a Java Class 
**Problem** 
You want to drop a Java class from your database. 
**Solution** 
Issue the SQL DROP JAVA command along with the schema and object name you want to drop. For 
instance, you want to drop the Java source for the Employees class. In this case, you would issue the 
following command: 
 
`DROP JAVA SOURCE “Employees”;`
**How It Works** 
There may come a time when you need to drop a Java class or sources from the database. For instance, if 
you no longer want to maintain or allow access to a particular Java class, it may make sense to drop it. 
The DROP JAVA SOURCE command does this by passing the name of the class or source as demonstrated 
within the Solution to this recipe.  
 Note Be careful not to drop a Java class if other Java procedures or PL/SQL call specifications depend upon it. 
Doing so will invalidate any dependent code, and you will receive an error if you try to execute. The data dictionary 
provides views, such as DBA_DEPENDENCIES, that can be queried in order to find dependent objects. 
 
Alternately, if you are on the database server, there is a dropjava utility that works in the same 
fashion as the loadjava utility that was demonstrated in Recipe 15-3. To use the dropjava utility, issue 
the dropjava command at the command line, and pass the database connect string using the –u flag 
along with the name of the Java class or source you want to drop. The following example demonstrates 
the command to drop the Employees Java class using the dropjava utility. 
 
dropjava –u username/password@database_host:port:database_name Employees.class 
The dropjava utility actually invokes the DROP JAVA SOURCE command. The downside to using the 
utility is that you must be located on the database server to use it. I recommend using the DROP JAVA 
SOURCE command from SQL*Plus if possible because it tends to make life easier if you are working within 
SQL*Plus on a machine that is remote from the server. 

## 15-14. Retrieving Database Metadata with Java 
**Problem** 
You are interested in retrieving some metadata regarding the database from within your Java stored 
procedure. In this recipe, you want to list all the schemas within the database. 
**Solution** 
Create a Java stored procedure that utilizes the OracleDatabaseMetaData object to pull information from 
the connection. In the following example, a Java stored procedure is created that utilizes the 
OracleDatabaseMetaData object to retrieve schema names from the Oracle connection. This Java method 
will be added to the JavaUtils class. 
```java 
public static void listDatabaseSchemas() { 
        Connection conn = null; 
        try { 
            conn = DriverManager.getConnection("jdbc:default:connection:"); 
            OracleDatabaseMetaData meta = (OracleDatabaseMetaData) conn.getMetaData(); 
 
            if (meta == null) { 
                System.out.println("Database metadata is unavailable"); 
            } else { 
                ResultSet rs = meta.getSchemas(); 
                while (rs.next()) { 
                    System.out.println(rs.getString(1)); 
                } 
            } 
        } catch (SQLException ex) { 
            System.out.println(ex); 
        }  
    } 
```
The output from the execution of this Java method will be a list of all database schemas. 
**How It Works** 
Sometimes it may be useful to use Java code for obtaining database metadata. One such instance might 
arise when you are developing a Java class that needs to access database metadata. Your code will be 
easier to maintain and read if you use Java to obtain the metadata rather than a PL/SQL procedure. The 
OracleDatabaseMetaData object was created for that purpose. In the **Solution** to this recipe, the metadata 
object is used to retrieve a listing of all database schemas. However, several other methods can be called 
on the OracleDatabaseMetaData object to obtain other useful database metadata. For instance, 
information about the underlying database tables or columns can also be obtained using this resource. 
For a complete listing of the different options available via the OracleDatabaseMetaData object, please 
refer to the online documentation at 
www.oracle.com/technology/docs/tech/java/sqlj_jdbc/doc_library/javadoc/oracle.jdbc.driver.Orac
leDatabaseMetaData.html. 

In the **Solution** to this recipe, a Java Connection object is obtained using jdbc:default:connection. 
The getMetaData method can be called on a Connection object and casted to an OracleDatabaseMetaData 
object type. This **Solution** demonstrates this technique and then uses the object to retrieve information 
about the database. 

## 15-15. Querying the Database to Help Resolve Java  
Compilation Issues 
**Problem** 
You are attempting to compile Java source within the database, and you are receiving an unsuccessful 
result. You need to determine the underlying issue to the Problem that is preventing the Java source 
from compiling correctly. 
**Solution** 
Query the USER_ERRORS table to determine the cause of the compilation issue. For example, suppose the 
JavaUtils class source is loaded into the database with an incorrect variable name. This will cause a 
compiler error that will be displayed within the USER_ERRORS table. The following is an excerpt from a 
SQL*Plus session where an attempt has been made to compile the code: 
```sql
SQL> ALTER JAVA SOURCE "JavaUtils" RESOLVE; 
```
Warning: Java altered with compilation errors. 
 
Since compilation errors have occurred, query the USER_ERRORS table to determine the exact cause of 
the error so that it can be repaired. The following query demonstrates this technique: 
```sql
SQL> COL TEXT FOR A25 
SQL> SELECT NAME, TYPE, LINE, TEXT 
  2  FROM USER_ERRORS 
  3  WHERE TYPE LIKE 'JAVA%'; 
 
NAME                   TYPE          LINE TEXT 
------------------------------ ------------ ---------- ------------------------- 
JavaUtils               JAVA CLASS         0 ORA-29535: source require 
                               s recompilation 
 
JavaUtils               JAVA SOURCE         0 JavaUtils:51: cannot find 
                            symbol 
 
JavaUtils               JAVA SOURCE         0 symbol  : variable me 
JavaUtils               JAVA SOURCE         0 location: class JavaUtils 
JavaUtils               JAVA SOURCE         0               ResultSet 
                            rs = me.getSchemas(); 
 
 
NAME                   TYPE          LINE TEXT 
------------------------------ ------------ ---------- ------------------------- 
JavaUtils               JAVA SOURCE         0 
                                 ^ 
 
JavaUtils               JAVA SOURCE         0 1 error 
 
7 rows selected. 
```
**How It Works** 
The USER_ERRORS table contains the most recent errors generated by PL/SQL or Java code. It is the most 
useful way to determine the issues that are causing compilation errors when attempting to resolve Java 
source errors. Unlike PL/SQL, you are unable to issue the SHOW ERRORS command to display the most 
recent compiler errors. The Java compiler, as well as the PL/SQL compiler, writes output to the 
USER_ERRORS table, making it a beneficial tool when writing Java code for the database. 
