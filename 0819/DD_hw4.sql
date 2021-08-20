-- Assignment Day4 –SQL:  Comprehensive practice
-- Answer following questions
-- 1.	What is View? What are the benefits of using views?

-- 2.	Can data be modified through views?

-- 3.	What is stored procedure and what are the benefits of using it?

-- 4.	What is the difference between view and stored procedure?

-- 5.	What is the difference between stored procedure and functions?

-- 6.	Can stored procedure return multiple result sets?

-- 7.	Can stored procedure be executed as part of SELECT Statement? Why?

-- 8.	What is Trigger? What types of Triggers are there?

-- 9.	What are the scenarios to use Triggers?

-- 10.	What is the difference between Trigger and Stored Procedure?

-- Write queries for following scenarios
-- Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
USE NORTHWIND
GO
-- 1.	Lock tables Region, Territories, EmployeeTerritories and Employees. Insert following information into the database. In case of an error, no changes should be made to DB.

-- a.	A new region called “Middle Earth”;

-- b.	A new territory called “Gondor”, belongs to region “Middle Earth”;

-- c.	A new employee “Aragorn King” who's territory is “Gondor”.

-- 2.	Change territory “Gondor” to “Arnor”.

-- 3.	Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE or you will delete everything.) In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.

-- 4.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.

-- 5.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.

-- 6.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.

-- 7.	Lock tables Region, Territories, EmployeeTerritories and Employees. Create a stored procedure “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Tory”; if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database, and then move those employees to “Stevens Point”.

-- 8.	Create a trigger that when there are more than 100 employees in territory “Stevens Point”, move them back to Troy. (After test your code,) remove the trigger. Move those employees back to “Troy”, if any. Unlock the tables.

-- 9.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

-- 10.	Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.

-- 11.	Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).

-- 12.	How do you make sure two tables have the same data?

-- 14.
-- First Name	Last Name	Middle Name
--    John	      Green	
--    Mike	      White	         M
-- Output should be
-- Full Name
-- John Green
-- Mike White M.
-- Note: There is a dot after M when you output.
SELECT fname + ' ' + lname + ' ' + mname + '.' [Full Name]
FROM table
-- 15.
-- Student	Marks	Sex
--    Ci	 70	     F
--    Bob	 80	     M
--    Li	 90	     F
--    Mi	 95	     M
-- Find the top marks of Female students.
-- If there are to students have the max score, only output one.
SELECT Student
FROM table
WHERE Marks = (
    SELECT MAX(Marks)
FROM table
WHERE Sex = 'F'
ORDER BY Student DESC
)
-- 16.
-- Student	Marks	Sex
--    Li	 90	     F
--    Ci	 70	     F
--    Mi	 95	     M
--    Bob	 80	     M
-- How do you out put this?
    SELECT Student, Marks, Sex
    FROM table
    WHERE Sex = 'F'
UNION
    SELECT Student, Marks, Sex
    FROM table
    WHERE Sex = 'M'
ORDER BY Marks DESC