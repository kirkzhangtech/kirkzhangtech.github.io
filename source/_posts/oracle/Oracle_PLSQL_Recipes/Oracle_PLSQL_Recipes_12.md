---
title: Oracle PLSQL Recipes 12-Oracle SQL Developer
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

 
# 12. Oracle SQL Developer 
Tools can be useful for increasing productivity while developing code. They oftentimes allow you to take 
shortcuts when coding by providing templates to start from or by providing autocompletion as words 
are typed. A good development tool can also be useful by incorporating several different utilities and 
functions into one development environment. Oracle SQL Developer is no exception, because it 
provides functionality for database administrators and PL/SQL developers alike. Functionalities include 
creating database tables, importing and exporting data, managing and administering multiple 
databases, and using robust PL/SQL development tools. 
Oracle SQL Developer is an enterprise-level development environment, and it would take an entire 
book to document each of its features. Rather than attempting to cover each of the available options, this 
chapter will focus on developing and maintaining Oracle PL/SQL code using the tool. Along the way, you 
will learn how to configure database connections and obtain information from database objects. In the 
end, you should feel comfortable developing PL/SQL applications using the Oracle SQL Developer 
environment. 

## 12-1. Creating Standard and Privileged Database Connections 
**Problem** 
You want to create a persistent connection to your database from within Oracle SQL Developer using 
both privileged and standard accounts so that you can work with your database. 
**Solution** 
Open Oracle SQL Developer, and select New from the File menu. This will open the Create a New 
window. Select the Database Connection option, and click OK. A New/Select Database Connection 
window opens, which has a list of existing database connections on the left side and an input form for 
creating a new connection on the right side, as shown in Figure 12-1. 
 
Figure 12-1. Creating a database connection 
If you are creating a standard connection, choose the Basic connection type. If you are creating a 
privileged connection as SYS, then choose the SYSDBA connection type. Once you have created a 
connection, then you will be able to connect to the database via the user for which you have made a 
connection and browse the objects belonging to that user’s schema. 
**How It Works** 
Before you can begin working with PL/SQL code in Oracle SQL Developer, you must create a database 
connection. Once created, this connection will remain in the database list that is located on the left side 
of the Oracle SQL Developer environment. During the process of creating the connection, you can either 
select the box to allow the password to be cached or keep it deselected so that you will be prompted to 
authenticate each time you want to use the connection. From a security standpoint, it is advised that you 
leave the box unchecked so that you are prompted to authenticate for each use.  
Once the connection has been successfully established and you are authenticated, the world of 
Oracle SQL Developer is opened up, and you have a plethora of options available. At this point, you have 
the ability to browse through all the database tables, views, stored programs, and other objects that are 
available to the user account that you used to initiate the connection to the database by simply using the 
tree menu located within the left pane of the environment. Figure 12-2 shows a sample of what you will 
see when your database connection has been established. 
 
Figure 12-2. Database connection in the navigator 
 Note If you plan to develop PL/SQL code for system events such as an AFTER LOGON trigger, you should create a 
separate connection for the privileged user using SYSDBA. This will allow you to traverse the privileged database 
objects. 
As mentioned in the introduction to this chapter, you will learn how to use those features provided 
by Oracle SQL Developer that are useful for PL/SQL application development. This does not mean the 
other features offered by the environment are not useful, but it would take an entire book to cover each 
feature that Oracle SQL Developer has to offer. Indeed, there are entire books on the topic. This book 
strives to provide you with the education and concepts that you will need to know to develop complete 
and robust PL/SQL applications using Oracle SQL Developer. 
## 12-2. Obtaining Information About Tables 
**Problem** 
You are interested in learning more about a particular database table. You also want to look at system 
triggers and other privileged PL/SQL objects. 
**Solution** 
Use the Oracle SQL Developer navigator to select the table that you want to view information about, as 
demonstrated in Figure 12-3.  
 
Figure 12-3. Viewing table information 
The editor window will then populate with a tab that consists of a worksheet and several subtabs.
Each of these tabs provides different information about the table you are inspecting. Figure 12-4 shows
the Columns tab of the Table Editor. 
Figure 12-4. Table Editor 
**How It Works** 
Oracle SQL Developer provides an excellent means for examining table metadata. When a table is
selected within the database connection navigator, a worksheet becomes available that includes detailed
information pertaining to the table characteristics and data. The first tab, which is labeled Columns,
includes information about the table columns and each of their datatypes. This is most likely the tab that
you will spend the most time in. It includes toolbar buttons that allow you to perform editing on the
table and to refresh the table view in the editor, and it even includes an extensive table manipulation
menu labeled Action that is a database administrator’s dream come true.  
Next, the Data tab provides a live view of the data that exists within the table. It also includes toolbar
buttons for inserting and deleting rows. This tab resembles a spreadsheet, and it allows different
columns to be edited and then committed to the database. For a PL/SQL developer, it is most useful for
editing data within a table that is being used for application debugging or testing purposes. 
The Triggers tab will be useful to PL/SQL developers because it displays a selectable list of all table
triggers. You can also create new triggers from the tab. Figure 12-5 shows the Triggers tab. 
 
Figure 12-5. Triggers tab of editor 
When a trigger is selected on the Triggers tab, its DDL is displayed in a panel on the bottom half of 
the window. The green arrow button will allow the trigger to be executed, and the refresh specifies an 
interval of time. You will learn more about trigger development in Recipe 12-11. 
Oracle SQL Developer provides very useful information regarding database tables for PL/SQL 
developers. It also provides convenient access for trigger development and manipulation. 
## 12-3. Enabling Output to Be Displayed 
**Problem** 
You want to display the results of DBMS_OUTPUT within Oracle SQL Developer. 
**Solution** 
Enable DBMS_OUTPUT for your connection via the Dbms Output pane. This pane resides on the lower-right 
side of the IDE. Do so by selecting the green plus icon within the pane and then choosing the desired 
connection from the resulting dialog box. Figure 12-6 shows the connection dialog box. After selecting 
the desired connection and then clicking the OK button, you will be prompted for a password for the 
connection if you are not already connected. Once a successful password has been entered, then 
DBMS_OUTPUT will be enabled for the specified connection. 
 
Figure 12-6. Select Connection dialog box 
After enabling the DBMS_OUTPUT option, you will be able to see the output from DBMS_OUTPUT within 
Oracle SQL Developer. This can be very useful, especially for testing purposes. 
**How It Works** 
The easiest way to enable SERVEROUTPUT for a particular database connection is to enable DBMS_OUTPUT 
from within the Dbms Output window. Doing so will enable output to be displayed within the pane 
when the code is executed. 
Note For more information on the DBMS_OUTPUT package, please see Recipe 1-6. 
Selecting the Dbms Output option from the View menu will open the DBMS_OUTPUT pane. This pane 
gives you several options that include the ability to save the script output, change the buffer size, and 
even print the output. To enable SERVEROUTPUT via the pane, you must select the green plus symbol and 
choose a database connection. You will see the correct script output if you run the script again after 
enabling DBMS_OUTPUT via one of the two options we have discussed. Figure 12-7 shows the Dbms Output 
pane. 
 
Figure 12-7. Dbms Output pane 
Once a connection has been established using the Dbms Output pane, all DBMS_OUTPUT code that is 
executed against that connection will be displayed within the pane. It is possible to have more than one 
connection established within the pane, and in this case different tabs can be used to select the 
connection of your choice. 

## 12-4. Writing and Executing PL/SQL 
**Problem** 
You want to use Oracle SQL Developer to execute an anonymous block of code. 
**Solution** 
Establish a connection to the database of your choice, and the SQL worksheet will automatically open. 
Once the worksheet has opened, you can type the code directly into it. For the purposes of this recipe, 
type or copy/paste the following anonymous block into a SQL worksheet: 
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT * FROM employees; 
   
  emp_rec emp_cur%ROWTYPE; 
BEGIN 
  FOR emp_rec IN emp_cur LOOP 
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name); 
  END LOOP; 
END; 
```
Figure 12-8 shows the Oracle SQL Developer worksheet after this anonymous block has been 
written into it. 
 
Figure 12-8. Oracle SQL Developer worksheet with PL/SQL anonymous block 
**How It Works** 
By default, when you establish a connection within Oracle SQL Developer, a SQL worksheet for that 
connection is opened. This worksheet can be used to create anonymous code blocks, run SQL 
statements, and create PL/SQL code objects. The SQL worksheet is analogous to the SQL*Plus command 
prompt, although it does not allow all the same commands that are available using SQL*Plus. 
If you want to open more than one SQL worksheet or a new worksheet for a connection, this can be 
done in various ways. You can right-click (Ctrl+click) the database connection of your choice and then 
select Open SQL Worksheet from the menu. Another way to open a new worksheet is to use the SQL 
Worksheet option within the Tools menu. This will allow you to specify the connection of your choice to 
open a worksheet against. 
As you type, you will notice that the worksheet will place all Oracle keywords into a different color. 
This helps distinguish between keywords and defined variables or stored programs. By default, the 
keywords are placed into a bold blue text, but this color can be adjusted within the user Preferences 
window that can be accessed from the Tools drop-down menu. Similarly, any text placed within single 
quotes will appear in a different color. By default, this is also blue, except it is not bold.  
Besides the syntax coloring, there are some other features of the SQL worksheet that can help make 
your programming life easier. Oracle SQL Developer will provide autocompletion for some SQL and 
PL/SQL statements. For instance, if you enter a package name and type a dot, all the package members 
will be displayed in the drop-down list. You can also press Ctrl+spacebar to manually activate the 
autocomplete drop-down list. After the drop-down list appears, you can use the arrow keys to choose 
the option you want to use and then hit the Tab key. Oracle SQL Developer provides similar 
autocompletion for table and column names and even SQL statement GROUP BY and ORDER BY clauses. 
Take a look at Figure 12-9 to see the autocomplete feature in action. 
 
Figure 12-9. Autocomplete drop-down list 
Another feature that helps productivity is to use Oracle SQL Developer snippets. To learn more 
about snippets, please see Recipe 12-7. Within the SQL worksheet toolbar, there is a group of buttons 
that can be used to help increase programmer productivity. The group of buttons at the far-right side of 
the toolbar contains a button for making highlighted words uppercase, lowercase, and initial-cap. The 
button that has an eraser on it can be used to quickly clear the SQL worksheet. There is also button that 
can be used to display the SQL History panel. This SQL History panel opens along the bottom of the 
Oracle SQL Developer environment, and it contains all the SQL that has been entered into the 
worksheet. Double-clicking any line of the history will automatically add that SQL to the current 
worksheet. Figure 12-10 shows the SQL History window. 
 
 
Figure 12-10. SQL History window 
To execute the SQL or PL/SQL that is contained within the script, you can use the first two toolbar 
icons. The first icon in the toolbar (as shown in Figure 12-8) is a green arrow will execute the code that is 
in the worksheet and display the result in a separate pane. The second icon in the toolbar (as shown in 
Figure 12-8) that resembles a piece of paper with a green arrow in front will execute the code within the 
worksheet and then display the output in a pane that can be saved as script output. 
 Note It is possible to have more than one SQL statement or PL/SQL block within the SQL worksheet at the same 
time. In doing so, only the highlighted code will be executed when the green arrow button is selected. If all the 
code is selected, then a separate output pane will appear for the output of each block or statement. However, if 
the Script icon (paper with green arrow) is selected, then all the highlighted code will have its output displayed in 
the resulting script output pane. 
Other toolbar options within the SQL worksheet include the ability to COMMIT or ROLLBACK changes 
that are made, run an explain plan on the current code, or set up autotrace. The SQL worksheet is like 
SQL*Plus with many additional features. It provides the power of many tools in one easy-to-use 
environment. 
## 12-5. Creating and Executing a Script

**Problem** 
You are interested in creating a PL/SQL script using Oracle SQL Developer that will run against your 
database. Once it has been created, you want to save it and then execute it. 
**Solution** 
Establish a connection to the database for which you want to create a script. By default, the SQL 
worksheet for the selected database will open. To create a script, choose New from the File menu or 
select the first icon on the left side of the toolbar that resembles a piece of paper with a plus sign. Next, 
select the SQL File option from the Create a New window. When the Create SQL File window opens, type 
in a file name for your script, and choose a directory in which to store it. For the purposes of this 
demonstration, choose the file name select_employees, browse and choose the desired storage location, 
and click OK. At this point, a new tab opens in the Oracle SQL Developer editor. This tab represents the 
SQL file you have just created. Type the following script into the editor for demonstration purposes: 
```sql
DECLARE 
  CURSOR emp_cur IS 
  SELECT * FROM employees; 
  emp_rec emp_cur%ROWTYPE; 
BEGIN 
  FOR emp_rec IN emp_cur LOOP 
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name); 
  END LOOP; 
END; 
``` 
After the script has been typed into the editor, your Oracle SQL Developer editor should resemble 
that shown in Figure 12-11. Save your script by clicking the Save icon that looks like a disk, or choose 
Save from the File menu. 
 
Figure 12-11. Typing a script into the SQL editor  
To execute the script, click the Run Script icon that is the second icon from the left above the editor, 
or press the F5 function key. You will be prompted to select a database connection. At this point, you can 
choose an existing connection, create a new connection, or edit an existing connection. Choose the 
database connection that coincides with the schema for this book. Once you select the connection, the 
script will execute against the database, and you will see another pane appear in the lower half of the 
Oracle SQL Developer window. This is the Script Output pane, and you should see a message that states 
"anonymous block completed."The editor should now look like Figure 12-12. 
 
Figure 12-12. Anonymous block completed 
**How It Works** 
In the **Solution** to this recipe, you learned how to create and execute a script using Oracle SQL 
Developer. As you were typing the script, you may have noticed that the text being typed is color-coded. 
Oracle SQL Developer places PL/SQL and SQL keywords into a different color text that can be chosen 
from within the preferences window, which is located within the Tools menu. The default color for 
keywords is blue. 
When the script is executed, it prompts for a database connection to use. Once that connection has 
been selected and established, then the script is run against the database. The script may not display any 
useful results by default, unless the SERVEROUTPUT has been enabled via the Dbms Output pane. To learn 
more about enabling DBMS_OUTPUT, please see Recipe 12-3. 
When you select the Save option, the script is written to disk to a file having the name you specified 
earlier. To execute a saved script, open the File menu, and then select the Open option. A dialog box will 
open that allows you to browse your file system for the script that you want to open. Once you have 
found the script and opened it, a new tab is opened, and the script is loaded into that tab along with all 
the options of an ordinary SQL worksheet (see Figure 12-13). 
 
 
Figure 12-13. Loaded script 
## 12-6. Accepting User Input for Substitution Variables 
**Problem** 
You want to create a PL/SQL application that accepts user input from the keyboard. To test the input, 
you want to have Oracle SQL Developer prompt you for input. 
**Solution** 
Use an ampersand in front of a text string just like in SQL*Plus. Assign the resulting user variable to a 
PL/SQL variable, or use the value inline. 
**How It Works** 
Just as SQL*Plus treats the ampersand as a token to denote user input, Oracle SQL Developer does the 
same. When an ampersand is encountered, Oracle SQL Developer will display a pop-up box to prompt 
the user for the input. For example, type or copy and paste the following code into the SQL worksheet, 
and then select the Run Statement toolbar button. 
```
DECLARE 
    email     VARCHAR2(25); 
BEGIN 
  SELECT   email 
  INTO  email 
  FROM employees 
  WHERE employee_id = &emp_id; 
 
  DBMS_OUTPUT.PUT_LINE('Email Address for ID: ' || email); 
EXCEPTION  
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('An unknown error has occured, please try again.'); 
END; 
```
When the code is executed, you will be prompted to provide a value for the emp_id variable. A 
separate dialog box that looks like the one shown in Figure 12-14 is displayed. 
 
Figure 12-14. Entering substitution variable 
If the value being accepted from the user is a string, then the ampersand-variable must be placed 
within single quotes. For example, &last_name would be used to prompt for user entry of a string value. 

## 12-7. Saving Pieces of Code for Quick Access 
**Problem** 
You want to save a portion of code so that it can be made easily reusable by other PL/SQL programs. 
  Tip This recipe also works for frequently used bits of SQL. 
**Solution** 
Use the Snippets window to create the reusable piece of code and use it for access at a later time.  
**How It Works** 
The Snippets window can be accessed by selecting the View menu and then choosing the Snippets 
option. The Snippets window will open as a pane on the far-right side of the Oracle SQL Developer 
environment. The pane consists of a toolbar that includes a button used for creating a new snippet and a 
button for editing an existing snippet. There is also a drop-down menu that consists of several menu 
options that organize each of the snippets into a different category. Figure 12-15 shows the Snippets 
pane. 
 
Figure 12-15. Snippets 
The snippet is used by dragging its text onto a SQL worksheet or script. Once dragged onto the
worksheet, the actual code is displayed in a template fashion. In some cases, you will need to change a
bit of the text to make it usable, but the reusable code that is provided by the snippet can greatly reduce
development time. 
You can add your own snippet by selecting the icon that resembles a piece of paper with a plus sign
on it from the Snippets panel. This opens the Save Snippet window (as shown in Figure 12-16) that gives
you the option of using one of the existing categories or typing a new one. You can also type a name and
tooltip for the snippet. The name of the snippet will appear in the Snippets panel after it has been saved.
The text of the snippet itself will be placed into the worksheet once you drag the name of your snippet to
a worksheet or script. 
Figure 12-16. Save Snippet pane 
The Edit Snippet icon (the one with the pencil through it) brings up another window that allows you 
to choose an existing snippet to edit, create a new snippet, or delete a snippet. Only those snippets that 
you have created are available for editing. Figure 12-17 displays the Edit Snippets window. 
 
Figure 12-17. Edit Snippets window 
The snippets are actually saved within an XML file named UserSnippets.xml. This file is located in 
your user sqldeveloper directory. This file can be transported to another machine and placed into the 
sqldeveloper directory so that the snippets can be made available in more than one place. This can be 
useful if you have a group of developers who may want to share snippets. The ability to copy the 
UserSnippets.xml file into other user sqldeveloper directories and make the snippets available to other 
users can certainly be advantageous. 
Snippets can be useful for saving the time of typing a SQL or PL/SQL construct. They can also be 
beneficial if you do not remember the exact syntax of a particular piece of code. They provide quick 
access to template-based **Solution**s.

## 12-8. Creating a Function 
**Problem** 
You want to create a function using Oracle SQL Developer. 
**Solution** 
You can manually create the function by typing the code into the SQL worksheet for the database 
connection for which you want to create. You can also use the Create Function Wizard within Oracle 
SQL Developer to provide some assistance throughout the function creation process. There are a couple
of different ways to invoke the Create Function Wizard. If you go to the File menu and select New, the 
Create a New window opens, and Function is one of the available options. You can also reach the same 
menu by selecting the New toolbar button. Both of these paths will lead you to the same window 
because after clicking OK, the Create PL/SQL Function window will appear (Figure 12-18).  
 
 
Figure 12-18. Create PL/SQL Function window 
A final way to invoke this same window is to establish a database connection and then expand the 
connection navigator to list all subfolders and then right-click the Functions subfolder. One of the 
available options after doing so will be New Function.  
**How It Works** 
If using the SQL worksheet to create a function, you will need to type the code for creating your function 
into the editor and then click the Run button to compile and save the object. If any errors are 
encountered while compiling, they will appear in the Messages window along with the line number that 
they occurred on. The SQL worksheet works very well for those who are well accustomed to creating 
functions. The Create Function Wizard may be the best choice for creating a function or those who like 
to write less code. 
 Note Using the Connections pane, you are able to browse both valid and invalid objects. An object may become 
invalid if it is not compilable, becomes stale, or because of issues with other dependencies. 
Once within the Create PL/SQL Function window, you will be able to name the function and specify 
any parameters that will need to be used. The first parameter in the list is already defined by default, and 
it represents the function’s return value. You can change the return type by selecting from the list of 
datatype options within the Type column of the parameter listing.  
To add a new parameter, click the plus symbol on the right side of the window, and a new line will 
be added to the parameter-listing table. You can then populate the name of the parameter, select a 
datatype and mode, and designate a default value if one should exist. After all parameters have been 
declared, click the OK button to continue. 
The function editor window will open, and it will contain the code that needs to be used for creation 
of the function that you have defined. All that is left to code will be any declarations and then the actual 
function code. The editor window contains a toolbar of options along with several tabs that can be used 
to find out more information about a function once it has been created (Figure 12-19). 
 
 
Figure 12-19. The Function Editor window 
The remaining function declarations and code should be typed into the editor, and when 
completed, the Save toolbar button or menu option can be used to compile and save the function into 
the database. If there are compilation errors upon saving, the errors will be displayed in a Compiler – Log 
window along with the line number on which the error occurred. By clicking the error in the window, 
your cursor will be placed on the line of code that needs to be repaired. Figure 12-20 shows the Compiler 
– Log window including a reference to an error in the code. 
 
 
Figure 12-20. Compilation errors in Function Editor 
Once you have successfully compiled and saved the function into the database, it can be executed 
for testing purposes using the green arrow icon within the Function Editor window. When you execute 
the function, the Run PL/SQL window will be displayed. If you defined any parameters for the function, 
you can supply values for them within the PL/SQL Block portion of the window. You can then click OK to 
execute the function using the value(s) you have defined within the window, and the results will be 
displayed in the Run Log window. The Run PL/SQL window can also be used to save your test case to a 
file or restore a test case from disk. The test case incorporates all the text that is contained within the 
PL/SQL block portion of the Run PL/SQL window. This window is displayed in Figure 12-21. 
 
 
Figure 12-21. Run PL/SQL window 
You can use the database navigator to display the functions contained within a particular database 
connection. If you highlight a particular trigger and right-click it, then a menu containing several options 
will be displayed. This is shown in Figure 12-22. 
 
 
Figure 12-22. Using the navigator with functions 
The options provided can be used for administering or editing the selected function. The Edit 
option will open the Function Editor, and it will contain the code for the selected function. If the selected 
function is not compiled successfully, then you can make changes to it and choose the Compile option 
  CHAPTER 12  ORACLE SQL DEVELOPER 
265 
within the right-click contextual menu to recompile the code. Similarly, the menu can be used to invoke 
the profiler, debug, or administer privileges for the function. 
## 12-9. Creating a Stored Procedure 
**Problem** 
You want to create a stored procedure using Oracle SQL Developer. 
**Solution** 
You can manually create a stored procedure by typing the code for creating your procedure into a SQL worksheet 
and executing it. You can also use the Create Procedure Wizard. To start the wizard, go to the File menu and 
select the New option. Once the Create a New dialog box opens (Figure 12-23), select Procedure. 
 
 
Figure 12-23. Create a New dialog box 
Once you click OK, you will be prompted to select a database connection. Doing so will open the 
Create PL/SQL Procedure Wizard. Alternatively, you can connect to the database of your choice and 
then expand the navigator so that all the objects within the database are available. Right-click the 
Procedures submenu, and select New Procedure, as shown in Figure 12-24. 
 
 
Figure 12-24. Right-click the Procedures submenu within a designated database connection. 
e
CHAPTER 12  ORACLE SQL DEVELOPER 
266 
**How It Works** 
You can use the Create a New Wizard or SQL worksheet to create a new stored procedure. The wizard is 
best suited for those who are new to PL/SQL or not very familiar with the overall syntax for creating a 
stored procedure. To use the wizard, select the File menu followed by the New option. At this point, you 
will be presented with the Create a New window that allows several options for creating new database 
objects or code. Select the Procedure option, and click OK. Oracle SQL Developer will now prompt you 
to select a database connection for which you will create the stored procedure. Select the connection of 
your choice, and click OK. The Create PL/SQL Procedure window will open, and it will resemble Figure 
12-25. 
 
 
Figure 12-25. Create PL/SQL Procedure window 
The Create PL/SQL Procedure window provides a window that can be used to create a procedure. 
You can select a schema and name the procedure. There is a check box that allows you to create your 
code using all lowercase if you want. Using the green plus symbol on the right side of the window, you 
can add a row of text to the Parameters window. By default, the parameter will be named PARAM1, and it 
will be given a datatype of VARCHAR2 with a mode of IN. All of these options can be changed, including the 
name. You can add zero or more parameters to the list, and you can rearrange their order by selecting a 
parameter from the list and using the arrow buttons on the right side of the window. You can select the 
DDL tab to see the actual code for creating the stored procedure, along with all the parameters you have 
defined. When finished, you can optionally choose to save your code to disk using the Save button and 
then click OK to create the procedure.  
Once you have completed and saved the Create PL/SQL Procedure form, the code is transferred to a 
SQL worksheet that is a procedure editor that contains buttons and tabs for working with the stored 
procedure, as shown in Figure 12-26. 
 
 
Figure 12-26. Stored Procedure Wizard 
The worksheet contains six tabs that can be used to find out more information about the stored 
procedure that it contains. This information includes the grants that have been made on the procedure. 
Other information includes dependencies, references, details, and profiles. You can add code to the 
procedure by typing into the editor. The editor will perform autocompletion where appropriate, and 
snippets can be dragged into the editor.  
Next, copy the following procedure into the editor for testing purposes: 
```sql
CREATE OR REPLACE PROCEDURE INCREASE_WAGE 
( 
  EMPNO_IN IN NUMBER, 
 PCT_INCREASE IN NUMBER   
) AS  
  emp_count    NUMBER := 0; 
  Results   VARCHAR2(50); 
BEGIN 
 
  SELECT count(*) 
  INTO EMP_COUNT 
  FROM EMPLOYEES 
  WHERE employee_id = empno_in; 
  
  IF emp_count > 0 THEN 
    UPDATE EMP 
    SET salary = salary + (salary * PCT_INCREASE) 
    WHERE employee_id = empno_in; 
    Results := 'SUCCESSFUL INCREASE'; 
  ELSE 
    Results := 'NO EMPLOYEE FOUND'; 
  END IF; 
 
  DBMS_OUTPUT.PUT_LINE(RESULTS); 
END; 
```
Once the procedure has been coded, select the Save option from the File menu, or click the Save 
icon that contains an image of a disk. This will compile and store the procedure into the database. You 
can alternatively use the Gears button to compile and save, which will produce the same results. If any 
compilation errors are found, they will be displayed in a pane below the editor along with the line 
number on which the error was found (Figure 12-27). 
 
Figure 12-27. Compilation errors 
If you double-click the error message, the cursor will be placed into the line of code that contains 
the error. In this case, you can see that the EMP table does not exist. Replace it with EMPLOYEES, and then 
click the Save button again. The procedure should now be successfully compiled and saved into the 
database. If you select the Refresh icon above the navigator, the new procedure will appear within the 
list of procedures for the database connection. 
To execute the procedure, right-click it within the navigator, and choose the Run option; this will 
cause the Run PL/SQL window to open. This window is shown in Figure 12-28. 
 
Figure 12-28. Run PL/SQL procedure window 
At this point, you have the option to save the file to disk or open another SQL file. If you want to test 
the procedure, then you can assign some values to the parameters within this window. Assign the values 
directly within the code that is listed in the PL/SQL Block section of the Run PL/SQL window. When you 
click OK, then the procedure will be executed. The results of the execution will be displayed in the log 
pane that is located below the editor pane.  
## 12-10. Creating a Package Header and Body 
**Problem** 
You want to create a package and store it into the database using Oracle SQL Developer. 
**Solution** 
Use the Create Package Wizard, or type the PL/SQL package code into a SQL worksheet. To start the 
wizard, go to the File menu, and select the New option. Once the Create a New dialog box opens, select 
Package, as shown in Figure 12-29. 
 
 
Figure 12-29. Creating a new package 
Once you click OK, you will be prompted to select a database connection. This will open the Create 
PL/SQL Package Wizard. Alternatively, you can connect to the database of your choice and then expand 
the navigator so that all the objects within the database are available. Right-click (Ctrl+click) the 
Packages submenu and select New Package. 
**How It Works** 
Creating a new package with Oracle SQL Developer is much the same as creating other code objects 
using this tool. You can develop using the manual technique of writing all code using the SQL worksheet, 
or you can use the creation wizards that are provided by the tool. You can type the example code into a 
SQL worksheet for your data connection and click the Run Statement toolbar button to compile and save 
the package into the database. You can also issue a Save As and save the code to a file on your 
workstation when writing code using the SQL worksheet.  
Alternatively, the wizard is useful for quickly creating the standard code for a package, and you can 
use the editor to add the details that are specific to your package. Once you have opened the New 
Package Wizard, you will be prompted to enter a package name. For the purposes of this recipe, enter 
the name PROCESS_EMPLOYEE_TIME, and click OK. If there is an existing object that has the same name, 
then you will be alerted via a red pop-up message (Figure 12-30). 
 
Figure 12-30. Naming the PL/SQL package using creation wizard 
 Note If you want to enter all code in lowercase for readability within the tool, you can select the check box
before clicking OK once the package has been named.  PL/SQL is not a case-sensitive language, so case does not
affect code execution. 
After proceeding, the package editor is opened, and it contains some standard package creation
code using the name that you placed into the wizard. As you can see from Figure 12-31, the package
editor contains several tabs, along with a search bar and Run, Debug, Compile, and Profile buttons.
Enter the following example code into the text box on the Code tab: 
```sql
CREATE OR REPLACE PACKAGE process_employee_time IS 
  total_employee_salary              NUMBER; 
  PROCEDURE grant_raises(pct_increase IN NUMBER); 
  PROCEDURE INCREASE_WAGE (empno_in IN NUMBER, 
                           Pct_increase IN NUMBER) ;
END;
```
Figure 12-31. Package editor window 
Click the Save button to compile and store the package into the database. Once this has been
completed, then the package header should be successfully stored in the database. Next, a package body
will need to be added in order to make the package functional. This can be done by expanding the
Package subfolder within the navigator. Once expanded, select the package for which you want to create
a body. Right-click the selected package, and select the Create Body option (Figure 12-32). 
Figure 12-32. Creating a package body 
Next, the standard package body creation code will be added to an editor much like the SQL 
worksheet. You can now edit this code accordingly to ensure that it performs the correct actions. Type 
the following package body into the editor, and then click the Save button to compile and store the 
package body: 
```sql
CREATE OR REPLACE PACKAGE BODY process_employee_time AS 
  PROCEDURE grant_raises ( 
    pct_increase IN NUMBER) as 
      CURSOR emp_cur is 
      SELECT employee_id 
      FROM employees; 
    BEGIN 
      FOR emp_rec IN emp_cur LOOP 
        increase_wage(emp_rec.employee_id, pct_increase); 
      END LOOP; 
      DBMS_OUTPUT.PUT_LINE('All employees have received the salary increase'); 
  END grant_raises; 
 
 PROCEDURE increase_wage ( 
  empno_in IN NUMBER, 
  Pct_increase IN NUMBER) as 
  Emp_count    NUMBER := 0; 
  Results   VARCHAR2(50); 
BEGIN 
  SELECT count(*) 
  INTO emp_count 
  FROM employees 
  WHERE employee_id = empno_in; 
  
  IF emp_count > 0 THEN 
    UPDATE employees 
    SET salary = salary + (salary * pct_increase) 
    WHERE employee_id = empno_in; 
  
    SELECT salary 
    INTO total_employee_salary 
    FROM employees 
    WHERE employee_id = empno_in; 
 
    Results := 'SUCCESSFUL INCREASE'; 
  ELSE 
    Results := 'NO EMPLOYEE FOUND'; 
  END IF; 
  DBMS_OUTPUT.PUT_LINE(results); 
   
 END increase_wage; 
END process_employee_time; 
```
If any compilation errors are encountered, an error window will be displayed providing the line 
number and specific error message that needs to be addressed. After any compile errors are repaired, the 
package body will be successfully created. You can then use the navigator to expand the package name 
and see the package body listed within it. Right-clicking the package body in the navigator offers some 
options such as Edit, Run, Compile, Profile, and Debug. You will learn more about debugging in Recipe 
12-12. The Edit option will open the package body editor if it is not already open. The Run option will 
open the Run PL/SQL window, which allows you to select a procedure or function to execute from the 
chosen package (Figure 12-33). 
 
Figure 12-33. Running the PL/SQL package 
Once a function or procedure is chosen from the Run PL/SQL window, it is executed using the 
values that are assigned to the variables within the PL/SQL Block panel of the window (this code is 
automatically generated by SQL*Developer). These values can be changed prior to running the package 
by editing the code that is displayed within the panel. This window also provides the opportunity to save 
the code to a file or load code from an existing file. 
Oracle SQL Developer makes developing PL/SQL packages easy. All the tools that are needed to 
successfully create, edit, and manage packages are available within the environment. Whether you are a 
beginner or seasoned expert, these tools will make package development and maintenance a breeze. 

## 12-11. Creating a Trigger 
**Problem** 
You need to create a DML database trigger that validates data prior to inserting it into a table, and you 
want to use Oracle SQL Developer to do so. For instance, you want to create a trigger that will validate an 
e-mail address prior to inserting a row into the EMPLOYEES table. 
**Solution** 
Use the Create Trigger Wizard, type the PL/SQL trigger code into a SQL worksheet, or use the trigger 
options that are available from the database table worksheet. To start the wizard, go to the File menu 
and select the New option. Once the Create a New dialog box opens, select Trigger. This will open the 
Create Trigger window, as shown in Figure 12-34. 
 
Figure 12-34. Creating a new trigger 
The Create Trigger window simplifies the process of creating a trigger because it provides all the 
essential details that are required up front. Once the information has been completed, the trigger code 
can be developed using the trigger editor window. 
**How It Works** 
As with all the other code creation techniques available in Oracle SQL Developer, there are various 
different ways to create a trigger. Using the SQL worksheet for a database connection is the best way to 
manually create a trigger. To do so, you will need to open the SQL worksheet, type the trigger creation 
code, and click the Run toolbar button to compile and save the code. The many wizards that are 
available for trigger creation can greatly simplify the process, especially if you are new to PL/SQL or rusty 
on the details of trigger creation. 
As mentioned in the **Solution** to the recipe, the Create Trigger window allows you to specify all the 
details for creating a trigger. You choose the type of trigger by selecting one of the options available from 
the drop-down menu. Different options become available in the window depending upon the type of 
trigger you choose to create. By default, a table trigger is chosen. Using that option, you can select the 
table from another drop-down list and choose whether the trigger should be executed on INSERT, UPDATE, 
or DELETE from the specified table. The wizard allows you to specify your own variable names for 
representing old and new table values. The timing for trigger execution is determined by selecting 
Before, Statement Level, After, or Row Level and specifying an optional WHEN clause. You can even specify 
whether the trigger is to be executed based upon a specific column. 
If you attempt to enter a trigger name that matches an existing object in the database within the 
specified schema, you will receive an error message, as shown in Figure 12-35. 
 
Figure 12-35. Create Trigger window–—object already exists 
After finishing with the Create Trigger Wizard and clicking the OK button, the initial trigger creation 
code will be displayed in an editor (Figure 12-36). 
 
Figure 12-36. Trigger Editor 
Type the following code into the editor, and hit the Save button to compile the code and save it into 
the database: 
```sql 
TRIGGER CHECK_EMAIL_ADDRESS 
BEFORE INSERT ON employees 
FOR EACH ROW 
BEGIN 
  IF NOT INSTR(:new.email,'@') > 0 THEN 
    RAISE_APPLICATION_ERROR(-20001, 'INVALID EMAIL ADDRESS'); 
  END IF; 
END; 
```
The Save button will automatically compile the code, and the output will appear in the Messages 
pane below the editor, as shown in Figure 12-37. 
 
 
Figure 12-37. Messages log 
After the trigger has been successfully compiled and stored into the database, it can be highlighted 
in the navigator, and right-clicking it will reveal several options (Figure 12-38). 
 
 
Figure 12-38. Trigger options 
These options help allow easy access for dropping, disabling, or enabling the trigger. Choosing the 
Edit option from this submenu will open the trigger in the editor window to allow for code 
modifications. 
Using the Create Trigger Wizard in Oracle SQL Developer can greatly reduce the time it takes to 
create a database trigger. By selecting the appropriate options within the wizard, you will be left with 
only the trigger functionality to code.  

## 12-12. Debugging Stored Code 
**Problem** 
One of your stored procedures contains logical errors, and you want to use Oracle SQL Developer to help 
you find the cause. 
**Solution** 
A few different options are available for debugging stored code within Oracle SQL Developer. The 
environment includes a complete debugger that provides the ability to set breakpoints within the code 
and modify variable values at runtime to investigate a **Problem** with your code. There are several ways to 
invoke the debugger for a particular piece of code. When a code object is opened within the editor, the 
toolbar will contain a red “bug” icon that can be used to invoke the debugger (Figure 12-39).  
 
Figure 12-39. Debugger icon 
The right-click contextual menu within the navigator also contains a Debug option for procedures 
and packages (Figure 12-40). 
 
Figure 12-40. Debugger option in Navigator 
**How It Works** 
Using the debugger is a great way to find issues with your code. The debugger enables the application to 
halt processing at the designated breakpoints so that you can inspect the current values of variables and 
step through each line of code so that issues can be pinpointed. Debugging PL/SQL programs is a 
multistep process that consists of first setting breakpoints in code, followed by compiling the code for 
debug, and lastly running the actual debugger. To use the debugger, the user who is running the 
debugger must be granted some database permissions. The user must be granted the DEBUG ANY 
PROCEDURE privilege to have debug capabilities on any procedure or DEBUG <procedure name> to allow 
debugging capabilities on a single procedure. The DEBUG CONNECT SESSION privilege must also be granted 
in order to allow access to the debugging session. 
After a user has been granted the proper permissions for debugging, the next step is to place a 
breakpoint (or several) into the code that will be debugged. For the purposes of this recipe, the 
INCREASE_WAGE procedure will be loaded into the procedure editor, and a breakpoint will be set by 
placing the mouse cursor on the left margin of the editor window next to the line of code that you want 
the debugger to pause execution at. Once the cursor is in the desired location, click in the left margin to 
place the breakpoint. Figure 12-41 shows a breakpoint that has been placed at the beginning of a SELECT 
statement within the INCREASE_WAGE procedure. 
 
Figure 12-41. Setting a breakpoint 
After one or more breakpoints have been placed, the code needs to be compiled for debug. To do so, 
use the icon in the editor toolbar for compiling, and select the Compile for Debug option. Once the code 
has been compiled for debug, its icon in the navigator will adopt a green bug to indicate that it is ready 
for debugging (Figure 12-42). 
 
Figure 12-42. Code ready for debug 
Next, the debugger can be started by selecting the debug icon within the editor or by right-clicking 
the code within the navigator and selecting the Debug option. If the user who is debugging the code 
does not have appropriate permissions to debug, then error messages such as those shown in Figure 12-
43 will be displayed. 
 
Figure 12-43. User not granted necessary permissions 
Assuming that the user has the correct permissions to debug, the Debug PL/SQL window will be 
displayed. This window provides information about the code that is being debugged including the target 
name, the parameters, and a PL/SQL block that will be executed in order to debug the code. The code 
that is contained within the PL/SQL block portion of the screen can be modified so that the parameters 
being passed into the code (if any) can be set to the values you choose (Figure 12-44). In Figure 12-44, 
the values have been set to an EMPNO_IN value of 10 and a PCT_INCREASE value of .03. 
 
 
Figure 12-44. Debug PL/SQL window 
Once the Debug PL/SQL window has been completed with the desired values, click OK to begin the 
debugger. This will cause Oracle SQL Developer to issue the DBMS_DEBUG_JDWP.CONNECT_TCP (hostname, 
port) command and start the debugging session. The debugger will start, and it will provide a number of 
different options, allowing you to step through the code one line at a time and see what the variable 
values are at any given point in time. You will see three tabs on the debugger: Data, Smart Data, and 
Watches. The Data tab is used for watching all the variables and their values as you walk through your 
code using the debugger. The Smart Data tab will keep track of only those variables that are part of the 
current piece of code that is being executed. You can set watches to determine which variables that you 
would like to keep track of. The inspector can be used to see the values within those variables you are 
watching. You are also given the very powerful ability to modify the values at runtime as the code is 
executing. This provides the capability of determining how code will react to different values that are 
passed into it. 
The Oracle SQL Developer debugger is a useful tool and provides an intuitive user interface over the 
DBMS_DEBUG_JDWP utility. Although this recipe covers only the basics to get you started, if you spend time 
using each feature of the debugger, then you will learn more powerful ways to help you maintain and 
debug issues found in your code. 

## 12-13. Compiling Code Within the Navigator 
**Problem** 
You want to compile some PL/SQL code within Oracle SQL Developer. In this **Solution**, the navigation 
menu of your Oracle SQL Developer environment contains code that has a red X on it. This means the 
code needs to be compiled or that it contains an error. 
**Solution** 
Select the code that needs to be compiled, and right-click (Ctrl+click) it. A menu will be displayed that 
lists several options. Select the Compile option from that menu (Figure 12-45). 
 
 
Figure 12-45. Compile option 
**How It Works** 
The Oracle SQL Developer navigation menu is very handy for quickly glancing at the code that a 
database contains. All the code that is successfully loaded into the database will contain a green check 
mark, whereas any code that has a compilation error will contain a red X label. Sometimes code needs to 
simply be recompiled in order to validate it and make it usable once again. This is most often the case 
after a database has just recently been migrated or updated. This can also occur if a particular piece of 
code depends upon another piece of code that has recently been modified, although Oracle Database 
11gR2 includes fine-grained dependencies that help alleviate this issue. Another event that may cause 
code to require recompilation is if an object that the code references such as a table or view has been 
changed. Whatever the case, Oracle SQL Developer makes it easy to recompile code by right-clicking it 
within the navigator and selecting Compile from the pop-up menu. 
 Note Oracle Database 11g introduced the idea of fine-grained dependencies. This allows PL/SQL objects to 
remain valid even if an object that they depend upon has changed, as long as the changes do not affect the 
PL/SQL object. For instance, if a column has been removed from a table and object A depends upon that table but 
not the specific column that was removed, then object A will remain valid. 
Once the compile task has been completed, a message will be displayed within the Messages panel to 
note whether the compilation was successful. If there were any issues encountered, they will be listed, 
each on a separate line, within the Messages window. The messages will contain the error code, as well 
as the line number that caused the exception to be raised. Double-clicking each error message will take 
you directly to the line of code that raised the exception so that you can begin working on repairs. 

 