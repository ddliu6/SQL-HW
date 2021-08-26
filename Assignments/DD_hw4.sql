-- Assignment Day4 –SQL:  Comprehensive practice
-- Answer following questions
-- 1.	What is View? What are the benefits of using views?
A view is a virtual table whose contents are defined by a query. 
Like a real table, a view consists of a set of named columns and rows of data
--Benefits:
To Simplify Data Manipulation: Views can simplify how users work with data. You can define frequently used joins, projections, UNION queries, and SELECT queries as views so that users do not have to specify all the conditions and qualifications every time an additional operation is performed on that data 
Views enable you to create a backward compatible interface for a table when its schema changes. 
To Customize Data: Views let different users to see data in different ways, even when they are using the same data at the same time. This is especially useful when users who have many different interests and skill levels share the same database. For example, a view can be created that retrieves only the data for the customers with whom an account manager deals. The view can determine which data to retrieve based on the login ID of the account manager who uses the view.
Distributed queries can also be used to define views that use data from multiple heterogeneous sources 
This is useful, for example, if you want to combine similarly structured data from different servers, each of which stores data for a different region of your organization.
-- 2.	Can data be modified through views?
Views that access multiple tables can only modify one of the tables in the view. 
Views that use functions, specify DISTINCT, or utilize the GROUP BY clause may not be updated.
-- 3.	What is stored procedure and what are the benefits of using it?
A stored procedure groups one or more Transact-SQL statements into a logical unit, stored as an object in a SQL Server database 
Unlike user-defined functions or views, when a stored procedure is executed for the first time (since the SQL Server instance was last started), SQL determines the most optimal query access plan and stores it in the plan memory cache. SQL Server can then reuse the plan on subsequent executions of this stored procedure 
Plan reuse allows stored procedures to provide fast and reliable performance compared to non-compiled ad hoc query equivalents.
--Benefits:
Increase database security . Using stored procedures provides increased security for a database by limiting direct access. Stored procedures generally result in improved performance because the database can optimize the data access plan used by the procedure and cache it for subsequent reuse
Faster execution: Stored procedures generally result in improved performance because the database can optimize the data access plan used by the procedure and cache it for subsequent reuse
Stored procedures help centralize your Transact-SQL code in the data tier. Websites or applications that embed ad hoc SQL are notoriously difficult to modify in a production environment. When ad hoc SQL is embedded in an application, you may spend too much time trying to find and debug the embedded SQL. Once you’ve found the bug, chances are you’ll need to recompile the page or program executable, causing unnecessary application outages or application distribution nightmares. If you centralize your Transact-SQL code in stored procedures, you’ll have only one place to look for SQL code or SQL batches. If you document the code properly, you’ll also be able to capture the areas that need fixing 
Stored procedures can help reduce network traffic for larger ad hoc queries. Programming your application call to execute a stored procedure, rather then push across a 5000 line SQL call, can have a positive impact on your network and application performance, particularly if the call is repeated thousands of times a minute 
Stored procedures encourage code reusability. 
-- 4.	What is the difference between view and stored procedure?
View is simple showcasing data stored in the database tables 
whereas a stored procedure is a group of statements that can be executed.
-- 5.	What is the difference between stored procedure and functions?
Stored Procedure (SP)	                                            Function (User Defined)
------------------------------------------------------------        -------------------------------------------------------------------------
SP can return zero, single or multiple values.	                    Function must return a single value (which may be a scalar or a table).
We can use transaction in SP.	                                    We cannot use transaction in UDF.
SP can have input/output parameter.	                                Only input parameter.
We can call function from SP.	                                    We cannot call SP from function.
We cannot use SP in SELECT/ WHERE/ HAVING statement.	                We can use UDF in SELECT/ WHERE/ HAVING statement.
We can use exception handling using Try-Catch block in SP.	        We cannot use Try-Catch block in UDF.
-- 6.	Can stored procedure return multiple result sets?
SP can return zero, single or multiple values.
-- 7.	Can stored procedure be executed as part of SELECT Statement? Why?
It cannot be used in SELECT/ WHERE/ HAVING statement.
-- 8.	What is Trigger? What types of Triggers are there?
Triggers are a special type of stored procedure that get executed (fired) when a specific event happens.
Executing a trigger is called "firing the trigger".
Triggers are automatically fired  on a event. (DML Statements like Insert , Delete or Update)
Triggers cannot be explicitly executed.
Types: DML, DDL, CLR, LOGAN
-- 9.	What are the scenarios to use Triggers?
Enforce Integrity beyond simple Referential Integrity
Implement business rules
Maintain audit record of changes
Accomplish cascading updates and deletes
-- 10.	What is the difference between Trigger and Stored Procedure?
A stored procedure is a user defined piece of code written in the local version of PL/SQL, which may return a value (making it a function) that is invoked by calling it explicitly.
A trigger is a stored procedure that runs automatically when various events happen (eg update, insert, delete).
-- Write queries for following scenarios
-- Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
USE NORTHWIND
GO
-- 1.	Lock tables Region, Territories, EmployeeTerritories and Employees.
--      Insert following information into the database.
--      In case of an error, no changes should be made to DB.
-- a.	A new region called “Middle Earth”;
BEGIN TRAN
INSERT INTO Region VALUES(5, 'Middle Earth')
COMMIT
-- b.	A new territory called “Gondor”, belongs to region “Middle Earth”;
BEGIN TRAN
INSERT INTO Territories VALUES(99999, 'Gondor', 5)
COMMIT
-- c.	A new employee “Aragorn King” who's territory is “Gondor”.
BEGIN TRAN
INSERT INTO Employees (LastName, FirstName) VALUES ('King', 'Aragorn')
INSERT INTO EmployeeTerritories VALUES (10, 99999)
COMMIT
-- 2.	Change territory “Gondor” to “Arnor”.
BEGIN TRAN
UPDATE Territories
SET TerritoryDescription = 'Arnor'
WHERE TerritoryID = 99999
COMMIT
-- 3.	Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE or you will delete everything.) In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
BEGIN TRAN
DELETE FROM EmployeeTerritories
WHERE EmployeeID = 10
DELETE FROM Territories
WHERE TerritoryID = 99999
DELETE FROM Region
WHERE RegionID = 5
COMMIT
-- 4.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantities for that product.
CREATE VIEW view_product_order_liu
AS
SELECT ProductName,SUM(Quantity) As TotalOrderQty FROM [Order Details] OD JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY ProductName
-- 5.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_liu @id INT, @qty INT OUT
AS
BEGIN
SELECT @qty = SUM(Quantity)  FROM [Order Details] OD JOIN Products P ON P.ProductID = OD.ProductID
WHERE P.ProductID = @id
GROUP BY ProductName
END
-- 6.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_liu @pname nvarchar(50)
AS
BEGIN
SELECT TOP 5 o.ShipCity MostOrderedCity, SUM(od.Quantity) Qty FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Products p ON od.ProductID = p.ProductID
WHERE ProductName = @pname
GROUP BY o.ShipCity
ORDER BY Qty DESC
END
-- 7.	Lock tables Region, Territories, EmployeeTerritories and Employees. Create a stored procedure “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Troy”; if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database, and then move those employees to “Stevens Point”.
CREATE PROC sp_move_employees_liu
AS
BEGIN
BEGIN TRAN
DECLARE @num INT = (SELECT COUNT(et.EmployeeID) FROM EmployeeTerritories et JOIN Territories t ON et.TerritoryID = t.TerritoryID WHERE t.TerritoryDescription = 'Troy')
IF @num > 0
    BEGIN
    INSERT INTO Territories VALUES(99999, 'Stevens Point', 3)
    UPDATE EmployeeTerritories SET TerritoryID = 99999 WHERE TerritoryID IN (SELECT TerritoryID FROM Territories WHERE TerritoryDescription = 'Troy')
    END
COMMIT
END
-- 8.	Create a trigger that when there are more than 100 employees in territory “Stevens Point”, move them back to Troy. (After test your code,) remove the trigger. Move those employees back to “Troy”, if any. Unlock the tables.
CREATE TRIGGER trg_after_insert ON EmployeeTerritories
AFTER INSERT
AS
BEGIN
DECLARE @qty INT
SELECT @qty = COUNT(EmployeeID) FROM EmployeeTerritories WHERE TerritoryID = 99999
IF @qty > 100
    BEGIN
    UPDATE EmployeeTerritories SET TerritoryID = (SELECT TerritoryID FROM Territories WHERE TerritoryDescription = 'Troy')
    WHERE EmployeeID IN (SELECT EmployeeID FROM EmployeeTerritories WHERE TerritoryID = 99999)
    END
END
-- 9.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE city_liu (
    Id INT PRIMARY KEY,
    City varchar(30)
)
CREATE TABLE people_liu (
    Id INT PRIMARY KEY,
    Name varchar(30),
    City INT FOREIGN KEY REFERENCES city_liu(Id) ON DELETE SET NULL
)

INSERT INTO city_liu VALUES(1, 'Seattle'), (2, 'Green Bay')
INSERT INTO people_liu VALUES(1, 'Aaron Rodgers', 2), (2, 'Russell Wilson', 1), (3, 'Jody Nelson', 2)
DELETE FROM city_liu WHERE City = 'Seattle'
INSERT INTO city_liu VALUES(3, 'Madison')
UPDATE people_liu SET City = 3 WHERE City IS NULL

CREATE VIEW Packers_chenghao
AS
SELECT Name FROM people_liu WHERE City = 2
-- 10.	Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_liu
AS
BEGIN
SELECT * INTO birthday_employees_your_liu FROM Employees WHERE MONTH(BirthDate) = 2
END
-- 11.	Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).
-- select 0-1 customers in the city, then count customers >= 2
CREATE PROC sp_liu_1
AS
BEGIN
SELECT City FROM Customers
WHERE CITY IN (SELECT c.City FROM Customers c JOIN Orders o ON o.CustomerID = c.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY od.ProductID, c.CustomerID, c.City HAVING COUNT(*) BETWEEN 0 AND 1)
GROUP BY City
HAVING COUNT(*)>2
END

CREATE PROC sp_liu_2
AS
BEGIN
SELECT City FROM Customers
GROUP BY City
HAVING COUNT(*)>2
INTERSECT
SELECT City FROM Customers C JOIN Orders O ON O.CustomerID=C.CustomerID JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY OD.ProductID,C.CustomerID,City
HAVING COUNT(*) BETWEEN 0 AND 1
END

CREATE PROC sp_liu_3
AS
BEGIN
SELECT DISTINCT c.City
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.City IN (SELECT City FROM Customers GROUP BY City HAVING COUNT(CustomerID) > 2)
GROUP BY c.City, od.ProductID, c.CustomerID
HAVING COUNT(od.ProductID) < 2
ORDER BY c.City
END
-- 12.	How do you make sure two tables have the same data?
Use EXCEPT between 2 tables, if it returns no row, then the data is the same 
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