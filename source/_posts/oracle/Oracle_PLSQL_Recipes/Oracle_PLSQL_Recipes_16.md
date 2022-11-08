---
title: Oracle PLSQL Recipes 16-Accessing PL/SQL from JDBC
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

# 16. Accessing PL/SQL from JDBC 
HTTP, Groovy, and Jython 
Java programs run on a virtual machine known as the Java virtual machine (JVM). A version of the JVM is 
available for most operating systems and is deployed on millions of servers, desktops, phones, and even 
Blu-ray players throughout the world. Because of the widespread availability of the JVM, Java is 
considered a portable language: you can essentially write Java code once and run it just about anywhere, 
whether it’s on a Linux box, a Mac, Android phone, or a Windows desktop.  
The JVM has evolved over time, and Java is no longer the only language that can run on it. There 
have been many languages implemented in Java that provide different features for those who enjoy 
developing applications for the JVM. Each of these languages has its own syntax and constructs, and 
many of them can be viable alternatives for developing scripts, desktop applications, or enterprise-level 
web applications. As such, this chapter not only covers the ins and outs of accessing PL/SQL from Java 
application code but also includes recipes for working with two popular dynamic languages that run on 
the JVM: Jython and Groovy.  
This chapter is not intended to be an overall instruction set for using Java or any other language on 
the JVM. It is meant for the purpose of demonstrating how to access PL/SQL code from within these 
languages. The Java online community is outstanding, and a plethora of resources are available on the 
Web for learning about Java or other languages on the JVM. For more detailed information, please 
consult those resources, because this chapter will only provide **Solution**s targeting PL/SQL integration. 

## 16-1. Accessing a PL/SQL Stored Procedure via JDBC 
**Problem** 
You are writing a Java application that uses JDBC to access data, but you also want to call some PL/SQL 
stored procedures from within your Java application. 
**Solution** 
Use the JDBC API to connect to the database, and then execute prepareCall(), passing a string to it that 
consists of a PL/SQL code block that calls the stored procedure. For example, consider a stand-alone 
Java class that contains a method named increaseWage(). This method uses JDBC to obtain a database 
connection, create a CallableStatement, and then invoke the PL/SQL stored procedure that passes in the 
required variables. 
```java

import java.sql.*; 
import oracle.jdbc.*; 
public class EmployeeFacade { 
 
 public void increaseWage() 
 throws SQLException { 
  int ret_code; 
  Connection conn = null; 
  try { 
    //Load Oracle driver 
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver()); 
    //Obtain a connection 
 
    conn = DriverManager.getConnection("jdbc:oracle:thin:@hostname:port_number:mydb", 
                                                                              "user", 
"password"); 
    int emp_id = 199; 
    double increase_pct = .02; 
    int upper_bound = 10000; 
    CallableStatement pstmt = 
    conn.prepareCall("begin increase_wage(?,?,?); end;"); 
    pstmt.setInt(1, emp_id); 
    pstmt.setDouble(2, increase_pct); 
    pstmt.setInt(3, upper_bound); 
    pstmt.executeUpdate(); 
 
    pstmt.close(); 
    conn.commit(); 
    conn.close(); 
    System.out.println("Increase successful"); 
  } catch (SQLException e) {ret_code = e.getErrorCode(); 
    System.err.println(ret_code + e.getMessage()); conn.close();} 
  } 
 
  public static void main(String[] args){ 
      EmployeeFacade facade = new EmployeeFacade(); 
      try { 
          facade.increaseWage(); 
      } catch (SQLException e){ 
          System.err.println("A database exception has occurred."); 
      } 
  } 
}
```
Running this code within an integrated development environment such as NetBeans would result in 
the following output: 
 
run: 
Increase successful 
BUILD SUCCESSFUL (total time: 4 seconds) 
The EmployeeFacade class contains a main() method that is used to initiate the execution of the 
increaseWage() method. The increaseWage() method initializes three variables that are passed to the 
increase_wage PL/SQL stored procedure using a CallableStatement. 

**How It Works** 
It is possible to invoke a PL/SQL stored procedure from a JDBC call just as if you were issuing a call from 
PL/SQL. You can do so by passing a PL/SQL code block that contains the procedure call as a string to the 
JDBC connection. In the **Solution** to the example we’ve chosen for this recipe, a Java class named 
EmployeeFacade contains a method that makes a JDBC call to invoke a stored procedure. If you are 
unfamiliar with Java and database connectivity, you can see that using JDBC is very methodical. There 
are several steps that need to be taken in order to obtain a connection to the database, followed by the 
steps to perform the database transaction and lastly to commit the changes and close all of the JDBC 
constructs. 
Any Java work that is done using the JDBC API must include an exception handler for the 
java.sql.SQLException. As the increaseWage() method demonstrates, the SQLException is handled using 
a Java try-catch block. Prior to the try-catch block, a couple of variables are created that the rest of the 
method will use. One of the variables is the java.sql.Connection, which is to be used to make a 
connection to the database, execute the call, and then finally close the connection. In the next couple of 
lines, a try-catch block is started, and a connection is obtained to the Oracle Database using the 
DriverManager class. The getConnection() method accepts a JDBC URL pertaining to a database as well 
as a user name and password.  
 Note It is important to maintain a close watch on JDBC connections. They can be costly for performance, and 
only a limited number of connections is usually available for use. For this reason, a connection should always be 
obtained, used, and then closed. 
If a connection is successfully made to the database, then a CallableStatement is created that 
performs all the work against the database. If you wanted to issue a query, then you would use a 
PreparedStatement instead because CallableStatements are most useful for making PL/SQL calls. A 
string containing a PL/SQL code block is used to invoke the call to the PL/SQL stored procedure. The call 
is a bit different from native PL/SQL because it includes Java bind variables that represent the 
parameters that need to be passed into the procedure. A bind variable is represented by a question mark 
(?) character, and subsequent setter methods will be used to set values for each bind variable. After the 
CallableStatement’s prepareCall() method is invoked, variables are passed to the procedure using a 
series of setXXX() methods on the CallableStatement. The set methods correlate with the type of data 
that is being passed to the stored procedure, and they provide a positional parameter that maps the 
variable to the bind variable position in the call. For instance, the first setInt(1, emp_id) method 
contains an integer variable, emp_id, and it will be passed to the bind variable in the first position within 
the call. 
After all the variables have been set, the executeUpdate() method is called in order to execute the 
call to the procedure. If successful, program execution will continue. However, if unsuccessful for some 
reason, then a java.sql.SQLException will be thrown that will cause the execution of the Java program to 
be passed to the catch block. Finally, if the transaction was a success, then the connection commits the 
transaction, and the CallableStatement is closed, followed by the closing of the connection. You will 
notice that the throws SQLException clause has been placed within the method declaration. When any 
Java method contains a throws clause within the declaration, then you must code an exception handler 
for any Java code that calls the method. In this **Solution**, the throws clause has been put into place to 
handle any exceptions that may be raised when closing the connection within the exception-handling 
catch block. For more information on Java exception handling, please see the online documentation 
available at http://download.oracle.com/javase/tutorial/essential/exceptions/handling.html. 
The JDBC API can be used to call PL/SQL stored procedures by passing a PL/SQL code block in the 
form of a Java String to a CallableStatement object. The majority of the code using JDBC is spent 
creating and closing the database connections as well as the CallableStatements. If you are unfamiliar 
with JDBC, then you can learn more about it at www.oracle.com/technetwork/java/overview-
141217.html. It can be used for creating small Java programs or enterprise-level Java applications. The 
JDBC API has been around since the early days of Java, so it is quite mature and allows you to access the 
database and your PL/SQL programs directly. 

## 16-2. Accessing a PL/SQL Stored Function from JDBC 
**Problem** 
You want to utilize a PL/SQL function from a Java application that uses the JDBC API to connect to an 
Oracle Database and returns a value to the Java application.  
**Solution** 
Use the JDBC API and a CallableStatement to invoke the PL/SQL function by passing a Java String 
containing the function call to the CallableStatement. The following example demonstrates a Java 
method that accepts a parameter of type double and then makes a JDBC call to the PL/SQL function 
calc_quarter_hour using the parameter. It is assumed that this Java method is to be added into the class 
that was created in Recipe 16-1. 
```java
public void calcQuarterHour(double hours) 
            throws SQLException { 
        float returnValue; 
        int ret_code; 
        Connection conn = null; 
        try { 
            //Load Oracle driver 
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver()); 
            //Obtain a connection 
 
            conn = DriverManager.getConnection("jdbc:oracle:thin:@hostname:1521:mydb", 
                    "user", "password"); 
 
            CallableStatement pstmt = 
                    conn.prepareCall("{? = call calc_quarter_hour(?)}"); 
            
            pstmt.registerOutParameter(1, java.sql.Types.FLOAT); 
            pstmt.setDouble(2, hours); 
            pstmt.execute(); 
            returnValue = pstmt.getFloat(1); 
            pstmt.close(); 
            conn.commit(); 
            conn.close(); 
            System.out.println("The calculated value: " + returnValue); 
        } catch (SQLException e) { 
            ret_code = e.getErrorCode(); 
            System.err.println(ret_code + e.getMessage()); 
            conn.close(); 
        } 
    }
```
Update the main method from the class that was created in Recipe 16-1 to the following code in 
order to make a call to the new calcQuarterHour method. 
```java
public static void main(String[] args) { 
        EmployeeFacade facade = new EmployeeFacade(); 
        try { 
            facade.calcQuarterHour(7.667); 
        } catch (SQLException e) { 
            System.err.println("A database exception has occurred."); 
        } 
    } 
```
Running this code within an integrated development environment such as NetBeans would result in 
the following output: 
```sql
run: 
The calculated value: 7.75 
BUILD SUCCESSFUL (total time: 1 second) 
```
Values can be passed as parameters from Java to PL/SQL, and in turn, PL/SQL can pass return 
values back to Java. This helps form a seamless integration between the two languages. 
**How It Works** 
Calling a PL/SQL function from a JDBC application is not very much different from using native PL/SQL. 
The biggest difference is that you need to use the JDBC API to make the database call and to set and 
retrieve values from the database. The **Solution** to this recipe contains a Java method that accepts a 
double value representing a number of hours. The method connects to the Oracle Database using the 
JDBC, calls the PL/SQL function using a CallableStatement, and then returns the results.  
To make the connection, the database driver is first registered using the 
DriverManager.registerDriver() method and passing the appropriate driver for Oracle Database. Next, 
a connection is obtained using the DriverManager.getConnection() method by passing the URL for the 
Oracle Database that will be used, along with the appropriate user name and password. In Recipe 16-1, 
obtaining JDBC connections is discussed in more detail. If you haven’t yet read Recipe 16-1 and are 
unfamiliar with JDBC, we recommend you read it for more information on this important aspect of 
using the JDBC API. 
Once a connection has been obtained, a CallableStatement is created by calling the 
java.sql.Connection prepareCall() method and passing a Java String that contains the call to the 
PL/SQL function. The function call is in the following format: 
 
`{? = call calc_quarter_hour(?)} `
 
The String is surrounded by curly braces ({}), and the call to the PL/SQL function is preceded by 
the ? = characters. The question mark (?) character represents a bind variable in a Java prepared 
statement.  Bind variables are used to represent the returning value as well as the parameter value that 
will be passed into the function. The first ? character represents the returning value, whereas the ?
character within the parentheses correlates to the parameter being passed to the function. The PL/SQL
function is invoked using the call keyword followed by the function name. 
The next line of code registers the return value using the CallableStatement
registerOutParameter() method. This method accepts the bind variable position as its first argument
and accepts the datatype of the value as the second argument. In this example, the datatype is
java.sql.Types.FLOAT, which correlates to a PL/SQL float type. Many different types are available within
java.sql.Types, and if you are using a Java integrated development environment (IDE) that contains
code completion, then you should see a list of all available types after you type the trailing dot when
declaring java.sql.Type. Next, the parameter that will be passed into the PL/SQL function is set by
calling the setDouble() method and passing the bind variable position along with the value. Lastly, the
CallableStatement is executed by invoking the execute() method. 
If the function call is successful, then the return value of the function can be obtained by calling the
getFloat() method on the CallableStatement and passing the bind variable position. If you were calling
a PL/SQL function that had a different return type, then you would use the getter method that correlates
to the return type. This method will return the value of the call, so it should be assigned to a Java
variable. In the **Solution**, returnValue is the variable that is used to hold the value returned from the
function call. Finally, the CallableStatement is closed, and the transaction is committed by calling the
commit() method on the java.sql.Connection. 
The entire method is enclosed within a Java exception-handling try-catch block. Code that is
contained within the try block may or may not throw an exception. If an exception is thrown, then it can
be caught by a subsequent catch block. For more information on Java exception handling, please see the
documentation at http://download.oracle.com/javase/tutorial/essential/exceptions/handling.html. 
Interacting with PL/SQL functions from within a Java application can be quite powerful. You will
gain the most benefit if the function that you are calling is working with the data. Any application that is
not stored in the database will incur at least a minor performance hit when working with the database
because of connections and round-trips to and from the database server. If you have a PL/SQL function
that works with the database, then it can be more efficient to call the PL/SQL function from your Java
application rather than reproducing that function in Java code. 

## 16-3.  Accessing PL/SQL Web Procedures with HTTP 
**Problem** 
You are developing a Java web application that uses an Oracle Database. You have already created a
PL/SQL web application that displays some particular data from your database that is generated from an
input identifier. You want to use the PL/SQL web application to display that data by passing the
necessary input from the Java web application. 
**Solution** 
Write your PL/SQL web program to accept parameter values within a URL. Pass the values from your
Java web application to the PL/SQL application by embedding them within the URL that calls it. When
the URL is clicked, then it will redirect control to the PL/SQL application, passing the parameters that
are required to display the correct data. Suppose, for example, that you are writing a Java web
application that generates a list of employees on a web page. Suppose further that you have already
written PL/SQL web application that, given an employee_id, displays employee record details in a
browser. You want to combine that functionality with your Java program so that when you click one of
the employees in the list generated by the Java web program, it passes the selected employee’s ID to the 
PL/SQL web program. In turn, the PL/SQL program will display the detail for that ticket. In the following 
example, the EMP_RPT package that was introduced in Recipe 14-4 is accessed via a Java Server Faces 
page. 
 Note JSF is the Java standard for creation of server-side user interfaces. To learn more about this technology, 
please see the online documentation at www.oracle.com/technetwork/java/javaee/javaserverfaces-
139869.html. 
```html
<?xml version='1.0' encoding='UTF-8' ?> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" 
      xmlns:ui="http://java.sun.com/jsf/facelets" 
      xmlns:f="http://java.sun.com/jsf/core" 
      xmlns:h="http://java.sun.com/jsf/html"> 
 
    <body> 
 
        <ui:composition template="layout/my_layout.xhtml"> 
 
            <ui:define name="body"> 
                <f:view id="employeeView"> 
                    <h:form id="employeeResults"> 
                        <center> 
 
                            <br/> 
                            <h:messages id="messages" 
                                        errorClass="error" 
                                        infoClass="info" /> 
                            <br/> 
                            <span class="sub_head_sub"> 
                                Employee Listing 
                            </span> 
                            <br/> 
                            <br/> 
 
                            <h:dataTable id="employeeList" 
                                         rows="20" 
                                         value="#{employeeList}" 
                                         var="emp"> 
                                <f:facet name="header"> 
                                    <h:column > 
                                        <h:outputText value="First Name"/> 
                                    </h:column> 
                                    <h:column > 
                                        <h:outputText value="Last Name"/> 
                                    </h:column> 
                                    <h:column > 
                                        <h:outputText value="Email"/> 
                                    </h:column> 
                                </f:facet> 
 
                                <h:column id="firstNameCol"> 
                                    <h:outputText id="firstName" value="#{emp.firstName}"/> 
                                </h:column> 
                                <h:column id="lastNameCol"> 
                                    <h:outputText id="lastName" value="#{emp.lastName}"/> 
                                </h:column> 
 
                                <h:column id="emailCol"> 
                                    <h:outputLink value="http://my-oracle-application-
server:7778/DAD/emp_rpt.rpt" 
                                            target="_blank"> 
                                        <f:param name="emp_id" value="#{emp.employeeId}"/> 
                                        <h:outputText id="email" value="#{emp.email}"/> 
                                    </h:outputLink> 
                                </h:column> 
 
 
                            </h:dataTable> 
 
 
 
                        </center> 
                    </h:form> 
 
                </f:view> 
 
            </ui:define> 
 
        </ui:composition> 
 
    </body> 
</html> 
```
The JSF tags in this example would generate a web page that looks similar to Figure 16-1. However, 
it is important to note that JSF contains template functionality, so the look and feel of the user interface 
can be changed significantly if a different template were applied. 
 CHAPTER 16  ACCESSING PL/SQL FROM JDBC, HTTP, GROOVY, AND JYTHON 
353 
 
Figure 16-1.  Employee listing JSF web page 
 
For the sake of brevity, the Java code will not be displayed, because it is not essential for this 
**Solution**. However, if you want to learn more about writing Java web applications utilizing the Java 
Server Faces web framework, please see the online documentation available at 
www.oracle.com/technetwork/java/javaee/javaserverfaces-139869.html.  
When you look at the JSF page output on your monitor, you’ll see that the EMAIL column values are 
blue. This signifies that they are links that will take you to another page when selected with the mouse. 
In this case, the link will redirect users to a PL/SQL application that accepts the employee ID as input 
and in turn displays a result. Figure 16-2 shows the output from the PL/SQL web application when the e-
mail user name SKING is selected from the JSF page. 
 
 
Figure 16-2.  PL/SQL web application output 
 
**How It Works** 
Developing Java web applications and PL/SQL web applications can be quite different. However, 
accessing one from the other can be quite easy and can create powerful Solutions. In this recipe, a 
mashup consisting of a standard web URL passes data from a Java application to a PL/SQL stored 
procedure, and then the PL/SQL stored procedure displays content via a web page.  
The PL/SQL stored procedure in this recipe utilizes the built-in UTL_HTTP package to display content in 
HTML format via the Web. The procedure accepts one argument, an EMPLOYEE_ID. The given EMPLOYEE_ID 
field is used to query the database, and the content that is retrieved is displayed. The procedure is 
accessible from the Web because a Data Access Descriptor (DAD) has been created on the web server, 
which allows access to a particular schema’s web-accessible content. Using the DAD, a URL 
incorporating the host name, the DAD, and the procedure to be used can access the stored procedure. 
Please see Recipe 14-1 to learn more about creating DADs. For more details regarding the creation of 
web content using PL/SQL, please refer to Chapter 14. 
The Java application Extensible Hypertext Markup Language (XHTML) page that is displayed in the 
Solution to this recipe creates a listing of employee names by querying the database using EJB 
technology. Enterprise Java Beans (EJB) is part of the Java Enterprise Edition stack that is used for object 
relational mapping of Java code and database entities. For more information regarding EJB technology, 
please refer to the documentation at www.oracle.com/technetwork/java/index-jsp-140203.html.  
 The important code for this particular recipe is the web page code that resides within the Java 
Server Faces XHTML page. The generated list of employee names is a list of URLs that contain the host 
name of the Oracle Application Server, the DAD for the schema containing the PL/SQL you want to 
access, and the name of the PL/SQL stored procedure, which is EMP_RPT.RPT in this case. The URL also 
contains an embedded parameter that is passed to the stored procedure upon invocation. The following 
code shows an example of a URL that is generated by the Java application: 
 
`<a href="http://my-web-server:port/hr/EMP_RPT.RPT?emp_id=200"> `
The code that generates this URL is written in Java Server Faces using Facelets markup, as shown 
here: 
```html
<h:outputLink value="http://my-oracle-application-server:port/DAD/emp_rpt.rpt" 
                                            target="_blank"> 
               <f:param name="emp_id" value="#{emp.employeeId}"/> 
               <h:outputText id="email" value="#{emp.email}"/> 
</h:outputLink> 
```
The &emp_id=200 portion of the URL is the parameter name and value that is passed to the 
EMP_RPT.RPT procedure when called. In the case of the JSF markup, #{emp.employeeId} will pass this 
value as a parameter to the URL. In turn, the EMP_RPT.RPT procedure queries the EMPLOYEES table for the 
given EMPLOYEE_ID and displays the record data. In a sense, the Java application performs a redirect to 
the PL/SQL stored procedure, as illustrated by Figure 16-3.  
 
 
Figure 16-3. JSF to PL/SQL web redirect 
 Note Facelets is an open source web framework that is the default view handler technology for JSF. 
Any two languages that can be used to develop web applications can be used to create mashups in a 
similar fashion. A regular HTML page can include links to any PL/SQL stored procedure that has been 
deployed and made available using a DAD. This is a simple technique that can be used to allow 
applications to use data that resides in a remote database. 
 
## 16-4. Accessing PL/SQL from Jython 
**Problem** 
You are working with a Jython program and want to call some PL/SQL stored procedures or functions 
from it. 
**Solution** #1 
Use Jython’s zxJDBC API to obtain a connection to the Oracle Database, and then call the PL/SQL stored 
procedure passing parameters as required.  The following code is an example of a Jython script that 
performs these tasks: 
 
CHAPTER 16  ACCESSING PL/SQL FROM JDBC, HTTP, GROOVY, AND JYTHON 
356 
from __future__ import with_statement 
from com.ziclix.python.sql import zxJDBC 
 
Set up connection variables 
jdbc_url = "jdbc:oracle:thin:@host:1521:dbname" 
username = "user" 
password = "password" 
driver = "oracle.jdbc.driver.OracleDriver" 
 
obtain a connection using the with-statment 
with zxJDBC.connect(jdbc_url, username, password, driver) as conn: 
    with conn: 
        with conn.cursor() as c: 
            c.callproc('increase_wage',[199,.03,10000]) 
            print ‘Procedure call complete’ 
            conn.commit() 
This example does not display any real output; it only calls the INCREASE_WAGE procedure and 
performs a commit. After the procedure is called, a line of text is printed to alert the user that the 
procedure call is complete. 
**Solution** #2   
Use a Python web framework, such as Django, along with Jython to create a web application for 
deployment to a Java application server. Use the selected web framework’s built-in syntax to invoke the 
stored procedure or function call.  
 
`DJANGO`
Django is a popular web framework that is used with the Python programming language. Django has 
worked with Jython since the release of Jython 2.5. Django takes a model-view-controller approach to 
web design, whereas all code is separated from web pages. The web pages use templating that makes it 
easy to create dynamic and expressive web pages. Django uses an object-oriented approach to working 
with the database that is known as object relational mapping. For more information on the Django 
framework, please visit the Django web site at www.djangoproject.com/ and the Django-Jython project 
that is located at http://code.google.com/p/django-jython/. 
 
For example, here’s how you might use the Django web framework to create a call to the PL/SQL 
stored procedure CALC_QUARTER_HOUR that was demonstrated in Recipe 4-1. The following code 
demonstrates an excerpt taken from a Django view to make a call to an Oracle PL/SQL function: 
 
`Views.py`
from django.db import connection 
```python
def calc_hours(self, hours_in): 
        cursor = connection.cursor() 
        ret = cursor.callproc("CALC_QUARTER_HOUR", (hours_in))# calls PROCEDURE OR FUNCTION 
        cursor.close() 
        return ret 
```
This view code only demonstrates a function written in Python or Jython that will perform the call to 
the database and return a result. 
**How It Works** 
The Jython language is an incarnation of the Python language that has been implemented on the JVM. 
Using Jython provides a developer with all the corresponding syntax and language constructs that the 
Python language has to offer and allows them to be used to write applications running on the JVM. 
Furthermore, Jython applications have access to all the underlying libraries that the Java platform has to 
offer, which is a tremendous asset to any developer. Jython is one of the first additional languages 
developed to run on the JVM. It has matured over the years, although it remains a bit behind its sister 
language Python in release number. Jython can be used for developing scripts, desktop applications, and 
enterprise-level web applications. 
Using the zxJDBC API to Solve the Problem
In the first Solution to this recipe, Jython’s zxJDBC API is used to perform tasks against an Oracle 
Database. zxJDBC is an extension of the Java JDBC API that allows Jython developers to program JDBC 
calls in a Python-like syntax. Working with zxJDBC can be very efficient. It is similar to working with 
regular Java JDBC code, except the syntax makes development a bit easier since there are fewer lines of 
code to maintain. zxJDBC contains the function callproc() that can be used to make calls to PL/SQL 
procedures or functions. Once you have obtained a database connection, you allocate a cursor from the 
connection and invoke that cursor's callproc() function. The callproc() function accepts one 
argument, which is the name of the PL/SQL procedure to be called. The called procedure or function will 
return the results to the caller in a seamless manner. 
 
The zxJDBC API is useful for writing stand-alone Jython applications or scripts. Many developers 
and database administrators use Jython to script their nightly jobs, allowing zxJDBC to invoke PL/SQL 
functions and stored procedures. This is one alternative to using Oracle Scheduler for executing 
database tasks, and it can allow for much more flexibility because all the libraries available for use on the 
JVM are at your disposal.  
Using Django to Solve the Problem
Although zxJDBC is a great way to work with the database, there are other techniques that can be used 
for creation of web content that accesses PL/SQL. Many Jython users create web applications using 
different Python web frameworks. One such Python web framework is Django, and it can be used along 
with Jython to productively create web applications that run on the Java platform. The Django 
framework uses an object-oriented approach to work with the database. In other terms, Django provides 
an object-relational mapping Solution that allows developers to work with Python objects representing 
database tables rather than working directly with SQL. 
 
Django uses a model.py file to map a database table to a Python object. A views.py file is used to 
implement separate views for the web site, and a urls.py file is used to contain the valid URL mappings 
for a Django application. In the Solution to this recipe, a Python function that would go into the views.py 
file is displayed. The purpose of this function is to make a connection to the database and invoke a 
PL/SQL function call. The Django framework handles database connections for you by declaring some 
parameters for the database connection within a settings.py file for the project. As you can see from the 
example, obtaining a connection is trivial because you merely import it from the django.db package. The 
code is similar to using zxJDBC for calling a PL/SQL stored procedure or function. The cursor’s 
callProc() function is used to make the function call, and the syntax for performing that task is as 
follows: 
 
`cursor.callProc(function_or_procedure_name,(parameter_one, parameter_two, etc))`
 
The function or procedure name should be a string value, and the parameters can passed as a tuple 
or listed one by one, separated by commas. If calling a PL/SQL function, the callProc() function should 
be assigned to a variable because there will be a return result. Lastly, the cursor should be closed in order 
to release resources. Again, when using the Django framework connections to the database will be 
handled for you, so there is no need to worry about closing connections after a database call has been 
made. 
 
For more information on using the Django web framework, please visit the project home page at  
www.djangoproject.com. To use the Django web framework with Jython, you will also need to include the 
django-jython site package at http://code.google.com/p/django-jython/. 

## 16-5. Accessing PL/SQL from Groovy 
**Problem** 
You are writing a Groovy program and want to call some PL/SQL stored procedures or functions from it. 
**Solution** 
Use GroovySQL to establish a database connection, and make the call to the PL/SQL stored program. For 
example, here’s how you would use of GroovySQL to connect to an Oracle Database and call a PL/SQL 
function: 
```java
import groovy.sql.Sql 
import oracle.jdbc.driver.OracleTypes 
 
Sql sql = Sql.newInstance("jdbc:oracle:thin:@hostname:1521:dbname", 
                                                  
"username","password","oracle.jdbc.driver.OracleDriver") 
dept_id = 50 
 
sql.call('{? = call calc_quarter_hour(?)}', [Sql.DOUBLE, 6.35]) { qtr_hour-> 
  println qtr_hour 
} 
```
Short and to the point, the Groovy script in this example connects to an Oracle Database, executes a 
PL/SQL function call, returns a value, and prints the result. 

**How It Works** 
Groovy is a unique JVM language that is useful for developing productive and efficient applications. It 
can be used for developing a wide variety of applications, from scripts to enterprise-level web 
applications. The syntax of the Groovy language is unlike that of other languages on the JVM because the 
Groovy compiler allows you to write Java code and it will be deemed as valid Groovy. However, Groovy 
also has its own syntax that can be combined with Java syntax if you want to do so. Its flexibility allows 
for beginners to pick up the language as they go and allows advanced Groovy coders to write code in 
Groovy syntax that is magnitudes smaller than the amount of lines taken to write the same code in Java. 
 
In the **Solution** to this example, the Groovy SQL API is used to connect to an Oracle Database and 
issue a PL/SQL function call. The top of the script contains import statements. The imports in Groovy 
work in the same manner as Java imports. The groovy.sql.Sql import pulls all the Groovy SQL 
functionality into the script. The second import is used to pull in the Oracle driver.  
 
The database connection is made by using the Sql.newInstance method and passing the JDBC URL 
for the database along with the user name, password, and database driver class. The actual PL/SQL 
function call occurs with the Sql instance’s call() method, and the syntax is very similar to that of Java’s 
JDBC API, whereas you pass a string that is enclosed in curly braces in the following format. The 
following example demonstrates a call to the CALC_QUARTER_HOUR PL/SQL function that was written in 
Recipe 4-1: 
 
`{? = call calc_quarter_hour(?)} `
 
The question mark characters (?) correlate to bind variables. The second argument that is passed to 
the call() method is a list of parameters including the return type and value of the parameter that will 
be passed to the PL/SQL function. In this case, the PL/SQL function’s return type is 
groovy.sql.Sql.DOUBLE, and the value that will be passed to the function is 6.35. The code that follows 
the call is some Groovy syntactic sugar and is otherwise known as a closure. By specifying curly braces 
({}) after the function call, you are telling Groovy to pass any return values to the variable contained 
within the braces. In this case, qtr_hour will contain the result from the PL/SQL function call, and it 
prints the result upon return via use of the closure -> notation and then specifying a print statement 
afterward. 
 
If you have never seen Groovy code before, this syntax will seem a bit awkward. However, once you 
become used to the syntax, it will become a powerful asset to your tool box. It is easy to see that taking 
standard Java JDBC implementations for accessing PL/SQL and translating them into a different 
language will allow for the same PL/SQL connectivity across most languages that run on the JVM. For 
more information regarding the use of Groovy, Groovy SQL, or closures in Groovy, please see the online 
documentation at http://groovy.codehaus.org/Beginners+Tutorial. 