---
title: Oracle PLSQL Recipes 14-Using PL/SQL on the Web
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


# 14. Using PL/SQL on the Web 
Oracle’s Application Server provides a powerful gateway that exposes your PL/SQL procedures to web 
browsers. The gateway is defined using a Data Access Descriptor (DAD) that runs PL/SQL code as either 
the user defined in the DAD or as the user running the web application. 
Oracle provides a PL/SQL Web Toolkit, which is a set of procedures and functions that generate 
HTML tags. In addition to making your code easier to read and manage, the toolkit sends the HTML 
code through Apache directly to the client web browser. 
The following recipes teach you how to write PL/SQL procedures that produce interactive web 
pages. These recipes can be combined to create **Solution**s for complex business applications. 

## 14-1. Running a PL/SQL Procedure on the Web 
**Problem** 
You’d like to make your PL/SQL procedures accessible to users in a web browser via the Oracle 
Application Server. 
**Solution** 
To run a PL/SQL procedure on the Web, you must first configure a Data Access Descriptor (DAD) within 
the Oracle Application Server to define the connection information required between mod_plsql within 
the Oracle Application Server and the Oracle database that holds the PL/SQL procedures you wish to 
run. In this example the mod_plsql configuration file dads.conf (located in [Oracle_Home]\Apache\ 
modplsql\conf) is edited to define the DAD. 
```sql
<Location /DAD_NAME> 
    SetHandler pls_handler 
    Order deny,allow 
    Deny from all 
    Allow from localhost node1.mycompany.com node2.mycompany.com 
    AllowOverride None 
 
    PlsqlDatabaseUsername ORACLE_SCHEMA_NAME 
    PlsqlDatabasePassword PASSWORD 
    PlsqlDatabaseConnectString TNS_ENTRY 
    PlsqlSessionStateManagement StatelessWithResetPackageState 
    PlsqlMaxRequestsPerSession 1000 
    PlsqlFetchBufferSize 128 
    PlsqlCGIEnvironmentList QUERY_STRING 
    PlsqlErrorStyle DebugStyle 
</Location> 
```
You may repeat the <Location> data for additional DADs as required; perhaps one DAD for every 
major application. You must restart the Oracle Application Server for changes to the DAD configuration 
file to take effect. 
**How It Works** 
To verify that your DAD is configured properly and will run your PL/SQL code, log into the Oracle 
database defined in your DAD. The Oracle database account is defined in the PlsqlDatabaseUsername, 
PlsqlDatabasePassword and PlsqlDatabaseConnectString statements. Next, compile the following test 
procedure. 
```sql
create or replace procedure test as 
begin 
   htp.p ('Hello World!'); 
end; 
```
Finally, point your web browser to http://node_name/DAD_NAME/test. Where node_name is the 
name of the machine where the Oracle Application Server is installed and DAD_NAME is the name assigned 
your DAD in the <Location> tag within the mod_plsql configuration file and test is the name of the 
PL/SQL procedure create for this test. Your browser should respond with the text “Hello World!” 
The <Location> tag within the dads.conf file defines the equivalent of a virtual directory within 
Apache. When a request reaches the Oracle iAS Apache web server containing the location name defined 
in the DAD, the PL/SQL package or procedure specified in the remaining portion of the URL is executed. 
For example, if the URL is http://node.my_company.com/plsqlcgi/employee.rpt, plsqlcgi is the 
DAD_NAME, then employee is the package name and rpt is the procedure name. Calls to the PLSQL Web 
Toolkit within the employee.rpt procedure send output directly to the client’s web browser. 
The SetHandler directive invokes mod_plsql within Apache to handle requests for the virtual path 
defined by the <Location> tag. This directive is required to run PL/SQL packages and procedures 
through the Apache web server. 
The next three directives restrict access to the virtual path to the nodes specified on the Allow from 
line. To allow access from any web browser in the world, replace these three directives with the following 
two. 
• Order allow,deny  
• Allow from all 
The PlsqlDatabase directives define the connection information mod_plsql needs to log into the 
database. If the PlsqlDatabasePassword directive is supplied, Apache will automatically log into the 
database when requests from web clients are processed. The TNS_ENTRY is used to complete the login 
information. If the PlsqlDatabasePassword directive is omitted, the Web browser prompts the user for a 
username and password. The username entered by the user must exist in the database specified by the 
TNS_ENTRY name and the user must have execute privileges to the requested procedure. The procedure 
must be accessible to the ORACLE_SCHEMA_NAME specified in PlsqlDatabaseUsername. In other words, the 
schema must own the procedure or, if owned by another schema, it must have execute privileges to the 
procedure. 

## 14-2. Creating a Common Set of HTML Page Generation Procedures 
**Problem** 
Every web page you generate with a PL/SQL procedure requires a common HTML tag to start and 
another to finish every web page, and you do not wish to repeat the code to add those tags in every 
procedure you write for the Web. 
**Solution** 
Create a package that contains calls to the PL/SQL Web Toolkit procedures that produce the HTML code 
necessary to properly display a well-formed,1 HTML web page. In this example a package is created with 
two procedures, one to generate the HTML tags required to start a page and one to generate the closing 
HTML tags to finish a page. 
```sql
CREATE OR REPLACE PACKAGE common AS 
 
   PROCEDURE header (title VARCHAR2); 
   PROCEDURE footer; 
 
END common; 
```
```sql
CREATE OR REPLACE PACKAGE BODY common AS 
 
PROCEDURE header (title VARCHAR2) IS 
 
BEGIN 
 
   htp.p ('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" ' || 
          '"http://www.w3.org/TR/REC-html40/loose.dtd">'); 
   htp.htmlOpen; 
   htp.headOpen; 
   htp.meta ('Content-Type', null, 'text/html;' || 
              owa_util.get_cgi_env('REQUEST_IANA_CHARSET') ); 
   htp.meta ('Pragma', null, 'no-cache'); 
   htp.Title (title); 
   htp.headClose; 
   htp.bodyOpen; 
   htp.header (2, title); 
 
END HEADER; 

PROCEDURE footer IS 
 
BEGIN 
                                                
1 A well-formed HTML web page conforms to the standards defined by The World Wide Web Consortium 
(W3C). You can validate your HTML web pages at http://validator.w3.org/. 

-- This is a great place to add legal disclaimers, about us, contact us, etc. links 
   htp.hr;  -- horizontal line 
   htp.anchor ('http://www.mynode.com/legal_statement.html', 'Disclaimer'); 
   htp.anchor ('http://www.mynode.com/About.html', 'About Us'); 
   htp.bodyClose; 
   htp.htmlClose; 
 
END footer; 
 
END common; 
```

**How It Works** 
Recipe 14-1 includes a test procedure to verify the DAD is setup correctly; however the test procedure 
does not produce a well-formed HTML page. Here is the updated example from Recipe 14-1, this time 
with calls to the common header and footer procedures. 

```sql
create or replace procedure test as 
begin 
   common.header ('Test Page'); 
   htp.p ('Hello World!'); 
   common.footer; 
end; 
```

This procedure, when called from a web browser, produces the following HTML code. 
```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/ 
TR/REC-html40/loose.dtd"> 
<HTML> 
<HEAD> 
<META HTTP-EQUIV="Content-Type" NAME="" CONTENT="text/html;WINDOWS-1252"> 
<META HTTP-EQUIV="Pragma" NAME="" CONTENT="no-cache"> 
<TITLE>Test Page</TITLE> 
<BODY> 
<H2>Test Page</H2> 
Hello World! 
</BODY> 
</HTML> 
```
The header routine generates the necessary opening HTML code to properly display a web page. It 
begins by setting the document type, then sending the opening <HTML> and <HEAD> tags. It sets the 
content-type to the character set defined in the Apache environment variable, which is retrieved using a 
call to the PL/SQL Web Toolkit’s owa_util.get_cgi_env routine. The Pragma <META> tag tells the browser 
not to store the page’s content in its internal cache. This is useful when the PL/SQL routine returns time-
sensitive data because the users need to see real-time data. The remaining code sets the title in the user’s 
browser, opens the <BODY> tag and displays the title on the user’s web browser. 
The footer routine closes the <BODY> and <HTML> tags. As stated in the code’s comments, this is a 
good place to include any legal disclaimers or other useful text or links required for every web page 
generated. 
Oftentimes when creating an application, you will create several procedures that will make use of 
the same code. You could copy the code throughout your procedures, but it is more efficient and safer to 
write once and use in many different places. The creation of a common codebase that is accessible to 
each PL/SQL object within a schema can be quite an effective **Solution** for storing such code. 

## 14-3 Creating an Input Form 
**Problem** 
You require a web page that accepts and processes data entered by users. The data should be collected 
on the opening page and processed (stored in a table, used to update rows in a table, etc.) when the user 
clicks the Submit button. 
**Solution** 
Create a package using the Oracle PL/SQL Web Toolkit to display a data entry form and process the 
results. In this example a simple data entry form is created to collect employee information and send the 
user’s input to a second procedure for processing.  
■ Note See Recipe 14-2 for more information on the common package, which is used in this recipe. 
```sql
CREATE OR REPLACE PACKAGE input_form AS 
 
   null_array OWA_UTIL.IDENT_ARR; 
 
   PROCEDURE html; 
   PROCEDURE submit (emp_id     VARCHAR2, 
                     gender     VARCHAR2 DEFAULT NULL, 
                     options    OWA_UTIL.IDENT_ARR DEFAULT null_array, 
                     comments   varchar2); 
 
END input_form; 
```
```sql
CREATE OR REPLACE PACKAGE BODY input_form AS 
 
PROCEDURE html IS 
 
type    options_type is varray(3) of varchar2(50); 
options options_type := options_type ('I will attend the Team Meeting', 
                        'I will attend the social event', 
                        'I will attend the company tour'); 
 
BEGIN 
 
   common.header ('Input Form'); 
   htp.formOpen ('input_form.submit', 'POST'); 
 
   htp.p ('Employee ID: '); 
CHAPTER 14  USING PL/SQL ON THE WEB 
296 
   htp.formText ('emp_id', 9, 9); 
   htp.br; 
 
   htp.p ('Gender: '); 
   htp.formRadio ('gender', 'M'); 
   htp.p ('Male'); 
   htp.formRadio ('gender', 'F'); 
   htp.p ('Female'); 
   htp.br; 
 
   FOR i IN 1..10 LOOP 
      htp.formCheckBox ('options', i); 
      htp.p (options(i)); 
      htp.br; 
   END LOOP; 
   htp.br; 
 
   htp.p ('COMMENTS: '); 
   htp.formTextArea ('comments', 5, 50); 
   htp.br; 
 
   htp.formSubmit; 
   htp.formClose; 
   common.footer; 
 
END html; 
 
PROCEDURE submit (emp_id     VARCHAR2, 
                  gender     VARCHAR2 DEFAULT NULL, 
                  options    OWA_UTIL.IDENT_ARR DEFAULT null_array, 
                  comments   varchar2) is 
 
BEGIN 
 
   common.header ('Input Results'); 
   htp.bold ('You entered the following...'); 
   htp.br; 
 
   htp.p ('Employee ID: ' || emp_id); 
   htp.br; 
   htp.p ('Gender: ' || gender); 
   htp.br; 
   htp.p ('Comments: ' || comments); 
   htp.br; 
 
   htp.bold ('Options Selected...'); 
   htp.br; 
   FOR i IN 1..options.COUNT LOOP 
      htp.p (options(i)); 
      htp.br; 
   END LOOP; 
 
  CHAPTER 14  USING PL/SQL ON THE WEB 
297 
   common.footer; 
  
END submit; 
 
END input_form;
```

**How It Works** 
Access the web page using a link with an HTML anchor URL of http://node.mycompany.com/DAD_NAME/ 
input_form.html. 
■ Note See Recipe 14-1 to define the DAD_NAME. 
The input_form package specification defines an empty collection named null_array as the type 
OWA_UTIL.IDENT_ARR. It is used as the default value in the event the web form is submitted without 
checking at least one of the check boxes. Without the default value for the input parameter options, the 
call to input_form.submit will not work and returns an error to the user if no boxes are checked.  
■ Note See Recipe 14-9 for more information on viewing errors. 
The two procedures, html and submit, exposed in the package specification, are required to make 
them visible to the PL/SQL module within the Apache web server. It is important to note that it is not 
possible to call procedures via a URL if they are not defined in the package specification. 
The html procedure generates the data entry form shown in Figure 14-1. It begins with a call to 
header common procedure, which generates the opening HTML tags. The htp.formOpen call generates 
the <FORM> tag with the destination of the submit button to the submit procedure within the input_form 
package. 
The htp.p procedure call sends the data passed to it directly to the client's web browser, this 
procedure should not be confused with the htp.para, which produces the <P> tag. The htp.br call sends 
the <BR> tag to the client's web browser. 
The remainder of the procedure generates several form elements that accept user input. The 
htp.formText call generates a simple text box that accepts nine bytes. The htp.formRadio routine is called 
twice with the same variable name in the first parameter. This defines the variable gender with one of 
two possible values, M or F. The call to htp.formCheckBox within the FOR…LOOP generates the checkboxes, 
each having a unique value returned if checked by the user. Only the values checked are sent in a 
collection to the submit routine. The call to htp.formTextArea creates a multi-line, text box 50 characters 
wide and 5 lines deep. See Table 14-1 for a list of common PL/SQL Web Toolkit procedures that generate 
HTML form tags. 
The procedure ends with a calls to htp.formSubmit and htp.formClose, which generate the form’s 
submit button and the closing </FORM> tag. When the user clicks the submit button, the client’s web 
browser sends the data entered into the form to the submit routine within the input_form package. 
 
Figure 14-1. Form generated by the input_form.html procedure 
Table 14-1. Common form procedures in the PL/SQL Web Toolkit 
```text
Toolkit Procedure HTML Tag 
htp.formCheckbox <INPUT TYPE="CHECKBOX"> 
htp.formClose </FORM> 
htp.formHidden <INPUT TYPE="HIDDEN"> 
htp.formImage <IPUT TYPE="IMAGE"> 
htp.formOpen <FORM> 
htp.formPassword <INPUT TYPE="PASSWORD"> 
htp.formRadio <INPUT TYPE="RADIO"> 
htp.formReset <INPUT TYPE="RESET"> 
htp.formSelectClose </SELECT> 
htp.formSelectOpen <SELECT> 
htp.formSelectOption <OPTION> 
htp.formSubmit <INPUT TYPE="SUBMIT"> 
Toolkit Procedure  HTML Tag 
htp.formText <INPUT TYPE="TEXT"> 
htp.formTextarea <TEXTAREA></TEXTAREA> 
htp.formTextareaClose </TEXTAREA> 
htp.formTextareaOpen <TEXTAREA> 
```

## 14-4. Creating a Web–based Report Using PL/SQL Procedures 
**Problem** 
You need to generate a web page report that displays the results of a database query.  
**Solution** 
Create a package with two procedures, one to accept a user’s input, and another to query the database 
and display the results. Suppose, for example, that you need a report that displays information for an 
employee whose employee ID has been entered by an authorized user. This recipe uses the employee 
table in the HR schema. 
■ Note When defining packages that contain procedures you wish to access via web browsers, you must include 
each procedure you wish to access in the package specification.  
 
■ Note See Recipe 14-2 for more information on the common package, which is used in this recipe. 
```sql
CREATE OR REPLACE PACKAGE emp_rpt AS 
 
   PROCEDURE html; 
   PROCEDURE rpt (emp_id VARCHAR2); 
 
END emp_rpt; 

CREATE OR REPLACE PACKAGE BODY emp_rpt AS 
 
PROCEDURE html IS 
 
BEGIN 
 
   common.header ('Employee Report'); 
   htp.formOpen ('emp_rpt.rpt', 'POST'); 
   htp.p ('Employee ID:'); 
   htp.formText ('emp_id', 6, 6); 
   htp.formSubmit; 
   htp.formClose; 
   common.footer;  -- See recipe 14-2 for the common package. 
END html; 
PROCEDURE show_row (label VARCHAR2, value VARCHAR2) IS 
BEGIN 
   htp.tableRowOpen ('LEFT', 'TOP'); 
   htp.tableHeader (label, 'RIGHT'); 
   htp.tableData (value); 
   htp.tableRowClose; 
END show_row; 
PROCEDURE rpt (emp_id VARCHAR2) IS 
CURSOR  driver IS 
SELECT  * 
FROM    employees 
WHERE   employee_id = emp_id; 
rec             driver%ROWTYPE;
rec_found       BOOLEAN; 
BEGIN 
   common.header ('Employee Report'); 
  
   OPEN driver; 
   FETCH driver INTO rec; 
   rec_found := driver%FOUND; 
   CLOSE driver; 
   IF rec_found THEN 
      htp.tableOpen; 
      show_row ('Employee ID', rec.employee_id); 
      show_row ('First Name', rec.first_name); 
      show_row ('Last Name', rec.last_name); 
      show_row ('Email', rec.email); 
      show_row ('Phone', rec.phone_number); 
      show_row ('Hire Date', rec.hire_date); 
      show_row ('Salary', rec.salary); 
      show_row ('Commission %', rec.commission_pct); 
      htp.tableClose; 
   ELSE 
      htp.header (3, 'No such employee ID ' || emp_id); 
   END IF; 
 
   common.footer; -- See recipe 14-2 for the common package. 
 
EXCEPTION 
   WHEN OTHERS THEN 
   htp.header (3, 'Invalid employee ID. Click your browser''s back button and try again.'); 
   common.footer; 
 
END rpt; 
 
END emp_rpt; 
```

**How It Works** 
Users access the web page using the URL http://node.mycompany.com/DAD_NAME/emp_rpt.html.  
■ Note See Recipe 14-1 for more on how to define the DAD_NAME. 
The package specification is defined with two procedures, html and rpt. Exposing these procedures 
in the specification is required to make the PL/SQL procedures available within Apache. 
Next, the package body is defined. The html procedure generates the data entry form. It generates 
the opening HTML code by calling the common.header routine defined in recipe 14-2. Next, it calls the 
htp.formOpen to set the form’s action, which is to run the PL/SQL procedure emp_rpt.rpt, when the user 
clicks the submit button and to send the form data in a POST method, as opposed to GET. A simple 
prompt and a text box follows to allow the user to enter an employee ID. A call to form.submit, 
form.close and common.footer complete the HTML code. 
The show_row procedure is a handy subroutine to output one table row with two data cells. It 
displays data on the client’s browser in a formatted table, making it more visually appealing. 
The rpt procedure accepts the user’s input in the emp_id parameter and uses it to query the 
employee record. The common.header routine generates the opening HTML code. The cursor is opened 
and the data is fetched into the rec data structure. The rec_found variable stores the flag that identifies if 
a record was fetched. It needs to be referenced after the fetch and before the close. If a record is found, 
the employee data is displayed in a two-column table, shown in Figure 14-2, otherwise a message is sent 
to the user that the employee ID is not valid. 
The exception is necessary to trap the error generated if the user enters a non-numeric employee 
ID. Another option is to validate the user’s input prior to using it in the cursor query. 
■ Note See recipe 14-10 for an example of validating user input. 
 
Figure 14-2. Results from entering employee ID 200 on the previous data entry screen 
14-5. Displaying Data from Tables 
**Problem** 
You wish to provide the results from an SQL SELECT statement to the users via a web browser. 
**Solution** 
Use the Oracle PL/SQL Web Toolkit to SELECT and display data. The owa_util.tablePrint procedure 
accepts any table name for the ctable parameter. When this procedure is compiled in a schema with a 
DAD it can be accessed via the Web. This example displays information similar to the describe feature 
within SQL*Plus. 
■ Note See Recipe 14-1 to define a DAD and direct your browser to run your procedure.  
 
■ Note See Recipe 14-2 for more information on the common package, which is used in this recipe.  

```sql
CREATE OR REPLACE PROCEDURE descr_emp IS 
 
BEGIN 
 
   common.header ('The Employees Table'); 
 
   IF owa_util.tablePrint ( 
             ctable=>'user_tab_columns', 
        cattributes=>'BORDER', 
  CHAPTER 14  USING PL/SQL ON THE WEB 
303 
           ccolumns=>'column_name, data_type, data_length, data_precision, nullable', 
           cclauses=>'WHERE table_name=''EMPLOYEES'' ORDER BY column_id') then 
      NULL; 
   END IF; 
 
   common.footer; 
 
END descr_emp; 
```

**How It Works** 
Users access the web page using the URL http://node.mycompany.com/DAD_NAME/emp_rpt.html. The 
descr_emp procedure calls the owa_util.tablePrint procedure, which is included in the PL/SQL Web 
Toolkit. The ctable parameter defines the table the owa_util.tablePrint procedure accesses to read the 
data. The cattribributes parameter accepts options for the HTML <TABLE> tag. The ccolumns parameter 
allows you to specify which columns to select from the named table. If no columns are specified, then 
the procedure shows all columns. The cclauses parameter allows you to add a where clause and/or an 
order by statement. If no where clause is specified, all rows are returned. The output is shown in Figure 
14-3. 
 
Figure 14-3. Results of the descr_emp procedure 

## 14-6. Creating a Web Form Dropdown List from a Database Query 
**Problem** 
Your web form requires a dropdown list whose elements are drawn from a database table. 
**Solution** 
Use the htp.formSelectOpen, htp.formSelectOption and htp.formSelectClose procedures in the PL/SQL 
Web Toolkit to generate the required HTML tags. For example, suppose you need to use the HR schema 
to create a dropdown list of job titles from the JOBS table. Here’s how you’d do it. 
```sql
create or replace procedure job_list as 
 
cursor  driver is 
select  job_id, job_title 
from    jobs 
order by job_title; 
 
begin 
 
   common.header ('Job Title'); 
   htp.formSelectOpen ('id', 'Job Title: '); 
   htp.formSelectOption ('', 'SELECTED'); 
 
   for rec in driver LOOP 
      htp.formSelectOption (rec.job_title, cattributes=>'VALUE="' || rec.job_id || '"'); 
   end LOOP; 
 
   htp.formSelectClose; 
   common.footer; 
 
end job_list; 
```
This procedure produces the following web page. 
Figure 14-4. Dropdown list created by job_list procedure 
**How It Works** 
The htp.formSelectOpen procedure generates the HTML <SELECT NAME="id">, which defines the 
dropdown list in the web browser. In addition the procedure uses the second parameter as the prompt 
for the dropdown list. In this example the prompt is Job Title:. 
The call to htp.formSelectOption procedure defines the elements of the dropdown list. The first 
parameter is the text displayed in the list and the second parameter preselects the element in the list 
when it is first displayed. In this example the first call to the htp.formSelectOption procedure defines the 
default selected element in the list to an empty value. 
The subsequent calls to htp.formSelectOption that appear in the cursor for loop define the 
remaining elements in the dropdown list using the data selected from the JOBS table. The cattributes 
parameter is used to change the default value returned by the web browser when the element is selected 
from the list. 
The call to htp.formSelectClose generates the </SELECT> HTML tag to close the dropdown list. 
Dropdown lists usually appear within the <FORM> tags to accept user input and process that input on a 
subsequent page.  
■ Note See Recipe 14-3 for more information on creating an input form. 

## 14-7. Creating a Sortable Web Report 
**Problem** 
You need a report that displays data that is sorted by a field the user selects.  
**Solution** 
Create a package that prompts the user for a sort field, then generates the sorted output using the sort 
field parameter in the ORDER BY section of the SELECT statement. In this example the user is prompted to 
select a sort option on the EMPLOYEEs table. The options are to sort by last name, hire date, salary, or 
employee ID. 
■ Note See Recipe 14-1 to define a DAD and direct your browser to run your procedure.  
 
■ Note See Recipe 14-2 for more information on the common package, which is used in this recipe.  
```sql
CREATE OR REPLACE PACKAGE sorted AS 
 
   PROCEDURE html; 
   PROCEDURE rpt (sort_order VARCHAR2); 
 
END sorted; 

CREATE OR REPLACE PACKAGE BODY sorted AS 
 
PROCEDURE html IS 
 
BEGIN 
 
   common.header ('Sorted Report'); 
   htp.formOpen ('sorted.rpt', 'POST'); 
   htp.formSelectOpen ('sort_order', 'Select a Sort Order: '); 
   htp.formSelectOption ('Last Name'); 
   htp.formSelectOption ('Hire Date'); 
   htp.formSelectOption ('Salary'); 
   htp.formSelectOption ('Employee ID'); 
   htp.formSelectClose; 
   htp.formSubmit; 
   htp.formClose; 
   common.footer;  
END html; 
 
PROCEDURE rpt (sort_order VARCHAR2) IS 
 
CURSOR  driver IS 
SELECT  * 
FROM    employees 
ORDER BY DECODE (sort_order, 
                'Last Name',   last_name, 
                'Hire Date',   TO_CHAR (hire_date, 'YYYYMMDD'), 
                'Salary',      TO_CHAR (salary, '00000'), 
                'Employee ID', TO_CHAR (employee_id, '00000') ); 
 
BEGIN 
 
   common.header ('Sorted Report by '||sort_order); -- See recipe 14-2. 
   htp.tableOpen ('BORDER'); 
   htp.tableRowOpen ('LEFT', 'BOTTOM'); 
   htp.tableHeader ('Name'); 
   htp.tableHeader ('Hired'); 
   htp.tableHeader ('Salary'); 
   htp.tableHeader ('ID'); 
   htp.tableRowClose; 
 
   FOR rec IN driver LOOP 
      htp.tableRowOpen ('LEFT', 'TOP'); 
      htp.tableData (rec.last_name); 
      htp.tableData (rec.hire_date); 
      htp.tableData (rec.salary); 
      htp.tableData (rec.employee_id); 
      htp.tableRowClose; 
   END LOOP; 
 
   htp.tableClose; 
   common.footer; 
 
END rpt; 
 
END sorted; 
```

**How It Works** 
Users access the web page using the URL http://node.mycompany.com/DAD_NAME/sorted.html.  
■ Note See Recipe 14-1 for more on how to to define the DAD_NAME. 
The package specification is defined by exposing two procedures, html and rpt. You must define 
these procedures in the specification to make the PL/SQL procedures available within Apache. 
Next, the package body is defined. The html procedure generates the data entry form. It generates 
the opening HTML code by calling the common.header routine defined in Recipe 14-2. Next, it calls the 
htp.formOpen to set the form’s action when the user clicks the Submit button. The calls to 
htp.formSelectOpen, htp.formSelectOption and htp.formSelectClose procedures create the dropdown 
list for the user to select a sort order.  
■ Note See Recipe 14-6 for more information on how to create dropdown lists.  
A call to form.submit, form.close and common.footer complete the necessary HTML code. The form 
generated is shown in Figure 14-5. 
The rpt procedure accepts the sort_order parameter, which is used in the cursor to dynamically 
determine the sort order on the EMPLOYEES table. The order by option in the select statement uses the 
decode function to return the proper string needed for ordering based on the user’s input. 
The first set of parameters sent to the decode function, namely the first_name field, defines the data 
type returned by the decode function. This is important to note as the remaining data types returned 
from the decode function will be converted to strings to match the first_name. It is necessary to convert 
the numeric and date fields to strings that sort properly. For example, if the default date string format is 
dd-Mon-yy, then the hire dates will sort by the day of the month first, then by the month’s abbreviation 
and year. The desired sort order is year, month, then day. 
 
 
Figure 14-5. Initial data entry screen showing the sort options 

## 14-8. Passing Data Between Web Pages 
**Problem** 
You have a multi-page data entry form in which the final page requires data entered on pages that 
precede it. You need to pass the data gathered on previous pages to the current page. 
**Solution** 
Pass the name/value pairs from previous pages using the htp.formHidden procedure in the PL/SQL Web 
Toolkit. In this recipe each parameter is passed to the next form using hidden HTML elements. 
```sql
CREATE OR REPLACE PACKAGE multi AS 
 
   PROCEDURE page1; 
   PROCEDURE page2 (var1 varchar2); 
   PROCEDURE page3 (var1 varchar2, var2 varchar2); 
   PROCEDURE process (var1 varchar2, var2 varchar2, var3 varchar2); 
 
END multi; 
 
CREATE OR REPLACE PACKAGE BODY multi AS 
 
PROCEDURE page1 IS 
 
begin 
 
   htp.formOpen ('multi.page2', 'POST'); 
   htp.p ('Enter First Value:'); 
   htp.formText ('var1', 10, 10); 
   htp.formSubmit; 
   htp.formClose; 
 
END page1; 
 
PROCEDURE page2 (var1 VARCHAR2) IS 
 
begin 
 
   htp.formOpen ('multi.page3', 'POST'); 
   htp.formHidden ('var1', var1); 
   htp.p ('Enter Second Value:'); 
   htp.formText ('var2', 10, 10); 
   htp.formSubmit; 
   htp.formClose; 
 
END page2; 
 
PROCEDURE page3 (var1 VARCHAR2, var2 VARCHAR2) IS 
 
begin 
 
   htp.formOpen ('multi.process', 'POST'); 
   htp.formHidden ('var1', var1); 
   htp.formHidden ('var2', var2); 
   htp.p ('Enter Third Value:'); 
   htp.formText ('var3', 10, 10); 
   htp.formSubmit; 
   htp.formClose; 
 
END page3; 
 
PROCEDURE process (var1 varchar2, var2 varchar2, var3 varchar2) is 
 
BEGIN 
 
  htp.p ('The three variables entered are...'); 
  htp.br; 
 
  htp.p ('1=' || var1); 
  htp.br; 
  htp.p ('2=' || var2); 
  htp.br; 
  htp.p ('3=' || var3); 
 
END process; 
 
END multi; 
```
**How It Works** 
Users access the web page using the URL http://node.mycompany.com/DAD_NAME/multi.page1.  
■ Note See Recipe 14.1 to define the DAD_NAME. 
The page1 procedure within the mulit package prompts the user for an input value, which is passed
to procedure page2 as its parameter, var1. The htp.formHidden call in the page2 procedure produces an
HTML <>INPUT<> tag of type HIDDEN. In this recipe it produces the following HTML code in the client’s web
browser: <>INPUT TYPE="hidden" NAME="var1" VALUE="xxx"<>, where xxx is the text the user entered on the
first page of this multi-part form. 
The page2 procedure then accepts more user input into the form variable var2, which is passed to
page3 along with var1 collected on the first input page. The third page accepts the final user input and
passes it to the process procedure, where final processing occurs. 

## 14-9. Viewing Errors for Debugging Web Apps 
**Problem** 
You have a PL/SQL package or procedure called from a web client that generates errors and you need to
view the error message. 
**Solution** 
Choose one of the following two **Solution**s, depending on your circumstances. 
**Solution** #1 
If the package is in use in a production environment, then check the output of the Apache error log file.
The log file location is defined in the httpd.conf configuration file. The default log file location is
`[oracle_home]\Apache\Apache\logs directory`. Open the log file and search for the errors generated with
a timestamp that corresponds to the approximate time the error was generated. 
**Solution** #2 
If the application is in development or running in a non-production environment, change the default
error style within the DAD used to produce the web page that failed. The error style is defined in the
DADS.CONF file located in `[oracle_homme]\Apache\modplsql\conf`. Set the PlsqlErrorStyle to DebugStyle.  
■ Note See recipe 14-1 for more information on defining DADs. 
**How It Works** 
**Solution** #1 
The PL/SQL module within Apache logs all errors, complete with timestamps. New errors are written to
the end of the error log. This Solution is recommended for production environments where the display
of Apache environment variables may pose security issues. 
Here’s an example of an error message written to the error log. In this example, a procedure was 
called from the Web but was missing required parameters. 
 
`[error] [client 127.0.0.1] mod_plsql: /DAD_NAME/class_sched.list HTTP-404 `
 
class_sched.list: SIGNATURE (parameter names) MISMATCH 
VARIABLES IN FORM NOT IN PROCEDURE:  
NON-DEFAULT VARIABLES IN PROCEDURE NOT IN FORM: THIS_ID, THIS_ID_TYPE 
**Solution** #2 
Setting the PlsqlErrorStyle to DebugStyle causes Apache to display all PL/SQL error messages on the 
client’s web browser when the PL/SQL routine fails. It displays the same error messages normally found 
in the Apache log file plus a list of all Apache environment variables and their values. This **Solution** is 
recommended for non-production environments where errors are more likely to occur during 
development and testing. It has the advantage of immediate, onscreen feedback for developers and 
testers. 

The following is an example of an error message written to the web browser. 
```
class_sched.list: SIGNATURE (parameter names) MISMATCH 
VARIABLES IN FORM NOT IN PROCEDURE:  
NON-DEFAULT VARIABLES IN PROCEDURE NOT IN FORM: THIS_ID, THIS_ID_TYPE 
 
  DAD name: default 
  PROCEDURE  : class_sched.list 
  URL        : http://node.mycomp.com/DAD_NAME/class_sched.list 
  PARAMETERS : 
  =========== 
 
  ENVIRONMENT: 
  ============ 
    PLSQL_GATEWAY=WebDb 
    GATEWAY_IVERSION=3 
        << snip >> 
```
## 14-10. Generating JavaScript via PL/SQL

**Problem** 
Your procedure requires JavaScript but you do not have access to the Oracle application server to store 
the script file to make it accessible from Apache. 
**Solution** 
Use the Oracle PL/SQLWeb Toolkit to output JavaScript within your PL/SQL procedure. There are two 
steps to define and enable a JavaScript within your PL/SQL procedure. 
First, define the JavaScript source on the web page that requires access to your 
JavaScript routine using the HTML tag >SCRIPT<. 
Define a PL/SQL procedure to match the name of the <>SCRIPT<> tag’s source(src)
property. 
In the following example the html procedure defines the <>SCRIPT<> tag with the source set to 
empID.js and the js procedure generates the JavaScript code. 
```sql
CREATE OR REPLACE PACKAGE empID IS 
 
   PROCEDURE html; 
   PROCEdURE js; 
 
END empID; 
 
CREATE OR REPLACE PACKAGE BODY empID IS 
 
PROCEDURE html is 
 
BEGIN 
 
   common.header ('Employee Report'); -- See recipe 14-2 for the common package. 
   htp.p ('<SCRIPT LANGUAGE="JavaScript" SRC="'                 || 
                owa_util.get_cgi_env ('REQUEST_PROTOCOL')       || '://'        || 
                owa_util.get_cgi_env ('HTTP_HOST')              || 
                owa_util.get_cgi_env ('SCRIPT_NAME')            || '/empID.js"></SCRIPT>'); 
 
   htp.formOpen ('emp_rpt.rpt', 'POST'); -- See recipe 14-4 for the emp_rpt pacakge. 
   htp.p ('Employee ID:'); 
   htp.formText ('emp_id', 6, 6, cattributes=>'onChange="validateNumber(this.value);"'); 
 
   htp.formSubmit; 
   htp.formClose; 
   common.footer; -- See recipe 14-2 for the common package. 
 
 
END html; 
 
PROCEDURE js is 
 
BEGIN 
 
   htp.p (' 
 
function validateNumber (theNumber) { 
 
   if ( isNaN (theNumber) ) { 
      alert ("You must enter a number for the Employee ID"); 
      return false; } 
 
   return true; 
 
  CHAPTER 14  USING PL/SQL ON THE WEB 
313 
}'); 
 
END js; 
 
END empID; 
```
**How It Works** 
Begin by creating the package specification for empID, which exposes the html and js procedures. Next 
create the package body with two procedures, html and js. 
The html procedure generates the opening HTML code with a call to common.header. Next, the 
procedure generates a <--SCRIPT--> tag that identifies the location of the JavaScript to include in the user’s 
browser. The <--SCRIPT--> tag of this form is one of the few HTML tags not predefined in the PL/SQL Web 
Toolkit. 
The <--SCRIPT--> tag takes advantage of the owa_util package, which is also part of the PL/SQL Web 
Toolkit, to dynamically generate the web address of the JavaScript using the settings of the Apache 
environment values. This method avoids your having to hard-code the URL of the script into the 
procedure and allows it to run in any environment—development, integration, production, etc. The URL 
generated references the JavaScript package defined later in the package body. 
Next, the html procedure generates the <--FORM--> tag with emp_rpt.rpt as its target. When the user 
clicks the Submit button the form will call the PL/SQL procedure emp_rpt.rpt defined in Recipe 14-4. It 
will not call a procedure within the empID package. 
The htp.formText routine contains an extra parameter to include the JavaScript necessary to run 
when the user changes the value in the emp_id field. Nearly every procedure in the htp package includes 
the cattributes parameter, which provides for any additional option needed within the tag that is not 
already defined in the existing parameters. Figure 14-6 shows the data entry form with a non-numeric 
employee ID; in this example the letter “o” was used instead of a zero. JavaScript pops up the error 
message shown. 
The js procedure consists of a simple print statement that contains the entire contents of the 
JavaScript code. JavaScript allows either single or double quotes for character strings. Using double 
quotes in the JavaScript code avoids conflicts with the single quote requirements of PL/SQL. 

Figure 14-6. Error message generated by JavaScript when a non-numeric employee ID is entered 

## 14-11. Generating XML Output 

**Problem** 
You need to provide XML data for PL/SQL or other consumers of data from your Oracle database. 
**Solution** 
Use Oracle’s built-in DBMS_XMLGEN package to extract data from the database in standard XML format and 
then output the data through the Apache web server. In this example a generic procedure builds and 
outputs XML formatted data based on the SQL query statement passed to it. This procedure can be used 
in any application that requires XML output extracted from database tables. 

```sql
CREATE OR REPLACE PROCEDURE gen_xml (sql_stmt VARCHAR2) IS 
 
string          VARCHAR2(4000); 
ipos            INTEGER; 
offset          INTEGER; 
n               INTEGER := 1; 
 
qryctx          dbms_xmlgen.ctxhandle; 
result          CLOB; 
 
BEGIN 
 
   qryctx := dbms_xmlgen.newcontext (sql_stmt); 
   result := dbms_xmlgen.getxml (qryctx); 
   dbms_xmlgen.closecontext (qryctx); 
 
   owa_util.mime_header ('text/xml', true); 
   LOOP 
      EXIT WHEN result IS NULL; 
      ipos := dbms_lob.instr (result, CHR(10), 1, n); 
      EXIT WHEN ipos = 0; 
 
      string := dbms_lob.substr (result, ipos-offset, offset); 
      htp.p (string); 
 
      offset    := ipos + 1; 
      n         := n + 1; 
   END LOOP; 
 
   IF result IS NULL THEN 
      htp.p ('<ROWSET>'); 
      htp.p ('</ROWSET>'); 
   END IF; 
 
END gen_xml; 
```

**How It Works** 
The newcontext procedure in the dbms_xmlgen package executes the query passed to it in the first 
parameter. The getxml procedure returns the data in XML format. Each row of data from the select 
statement is enclosed in the XML tags <--ROW-->. Each field in the row is enclosed by its attribute (field) 
name in the database. For example, the employee ID is enclosed in the XML tag <--EMPLOYEE_ID-->. 
The owa_util.mime_header is called to output the proper string to the client’s browser, indicating the 
content of the web page is in standard XML format. At this point it is sufficient to simply output the XML 
data returned by the call to xmlgen with an htp.p statement. However, this approach works only if the 
length in bytes of the XML data does not exceed the maximum allowed by the htp.p procedure, which is 
32k. The LOOP breaks apart the XML data into smaller segments at each line break, CHR(10), insuring no 
call to htp.p exceeds the maximum length. 
The final IF statement returns an empty XML tag set if the result of the query returns no rows. 
Without the empty tag set your Ajax call will fail because the Ajax call to parse the data from the XML 
structure requires the <--ROWSET--> tags. 
Here is an example of the XML output produced from Recipe 14-12. Only the first two data rows 
retrieved are displayed. 
```html
<ROWSET> 
 <ROW> 
  <EMPLOYEE_ID>101</EMPLOYEE_ID> 
  <LAST_NAME>Kochhar</LAST_NAME> 
 </ROW> 
 <ROW> 
  <EMPLOYEE_ID>102</EMPLOYEE_ID> 
  <LAST_NAME>De Haan</LAST_NAME> 
 </ROW> 
</ROWSET> 
```

## 14-12. Creating an Input Form with AJAX 
**Problem** 
You need a web application that can interactively retrieve data based on partial data entered by the user. 
The data must be retrieved before the user clicks the Submit button to process the page. 
**Solution** 
Use JavaScript and Ajax to dynamically retrieve data as the user enters data into the web form. This 
recipe uses the EMPLOYEES table in the HR schema. 
The data entry screen is built with all managers in a single dropdown list, which includes a call to a 
JavaScript procedure that invokes Ajax to retrieve subordinate data. Once the user selects a manager, the 
employee dropdown list populates with the manager’s subordinates. The subordinates’ dropdown list is 
defined with an ID, which is required by JavaScript to access the list and load the manager’s 
subordinates. 
The package contains the procedure xml, which is required to produce the XML data required by the 
Ajax call. The PL/SQL procedure ajax.xml is called by the web browser within the AjaxMgr.js procedure. 
```sql
CREATE OR REPLACE PACKAGE ajax IS 
 
   PROCEDURE html; 
   PROCEDURE xml (ID INTEGER); 
 
END ajax; 
 
CREATE OR REPLACE PACKAGE BODY ajax IS 
 
PROCEDURE html is 
 
CURSOR  driver IS 
SELECT  employee_id, last_name 
FROM    employees 
WHERE   employee_id in 
(       SELECT  DISTINCT manager_id 
        FROM    employees) 
ORDER BY last_name; 
 
BEGIN 
 
   common.header ('Manager/Employee Example'); -- See recipe 14-2 for the common package. 
   htp.p ('<SCRIPT LANGUAGE="JavaScript" SRC="'         || 
                owa_util.get_cgi_env ('REQUEST_PROTOCOL')       || '://'        || 
                owa_util.get_cgi_env ('HTTP_HOST')              || 
                                '/js/AjaxMgr.js"></SCRIPT>'); 
 
   htp.formOpen ('#', 'POST'); 
   htp.p ('Select a Manager:'); 
   htp.formSelectOpen ('mgr', cattributes=>'onChange="loadEmployees(this.value);"'); 
   htp.formSelectOption ('', 'SELECTED'); 
 
   FOR rec IN driver LOOP 
      htp.formSelectOption (rec.last_name, cattributes=>'VALUE="'||rec.employee_id||'"'); 
   END LOOP; 
 
   htp.formSelectClose; 
   htp.br; 
 
   htp.p ('Select a Subordinate:'); 
   htp.formSelectOpen ('emp', cattributes=>'ID="emp_list"'); 
   htp.formSelectClose; 
   htp.br; 
 
   htp.formSubmit; 
   htp.formClose; 
   common.footer; 
 
END html; 
 
PROCEDURE xml (ID INTEGER) IS 
 
BEGIN 
 
-- see recipe 14-11 for more information on the gen_xml procedure. 
   gen_xml ('SELECT employee_id, last_name '    || 
           'FROM employees '                    || 
           'WHERE manager_id = ' || ID          || 
           ' ORDER by 1'); 
 
END xml; 
 
END ajax;
```
**How It Works** 
The recipe begins by defining the package specification with two packages, html and xml. The html 
package generates the HTML data entry form and the xml procedure generates the XML data required by 
the call to Ajax. 
The html procedure generates the opening HTML code with a call to common.header. Next, the 
procedure generates a <--SCRIPT--> tag that identifies the location of the JavaScript to include in the user’s 
browser. The <--SCRIPT--> tag of this form is one of the few HTML tags not pre-defined in the PL/SQL Web 
Toolkit. 
The <--SCRIPT--> tag takes advantage of the owa_util package, which is also part of the PL/SQL Web 
Toolkit. It dynamically generates the web address of the JavaScript based on Apache environment 
values. This method avoids hard-coding the URL into the procedure and allows it to run in any 
environment—development, integration, production, etc.  
■ Note The JavaScript, AjaxMgr.js, is included in the media but not reproduced here. 
An HTML form is opened with two dropdown lists defined. The first list is populated with the names 
of all managers from the employees table. The second dropdown list is intentionally left empty. It will be 
populated at runtime when the user selects a manager from the first dropdown list. Figure 14-7 shows 
the initial data entry screen generated by the html procedure, prior to the user selecting a manager from 
the manager’s dropdown list. 
The manager’s dropdown list, mgr, is created using the htp.formSelectOpen procedure with an 
additional parameter to define the JavaScript to execute when the selected item in the list changes. A 
change to the manager’s dropdown list invokes the JavaScript procedure loadEmployees, which was 
defined earlier in the <--SCRIPT--> tag. 
The employee’s dropdown list, emp, is also created using the htp.formSelectOpen procedure with an 
additional parameter to define the ID name of the object in the Web browser’s DOM2. This ID is required 
by the JavaScript to dynamically rebuild the employee dropdown list if the value in the manager 
dropdown list changes. Figure 14-8 shows the data entry form after a Manager is selected by the user. 
Note the Subordinate list is now populated. 
                                                 
2 A DOM (Document Object Model) “is a cross-platform and language-independent convention for 
representing and interacting with objects in HTML, XHTML and XML documents.” – Wikipedia. 
The xml procedure calls the gen_xml procedure, created in Recipe 14-11, to generate the data 
required to populate the employee dropdown list via the Ajax call. The gen_xml procedure is generic in 
that it only requires the select statement need to produce the XML output. 
 
Figure 14-7. Manager dropdown list with empty subordinate dropdown list 

Figure 14-8. Subordinate list after being populated by Ajax 