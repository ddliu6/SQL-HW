-- Answer following questions
-- 1.	In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
        Joins, since the cost is lower in most cases.
-- 2.	What is CTE and when to use it?
        A Common Table Expression(CTE) is a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, DELETE, or MERGE statement.
-- 3.	What are Table Variables? What is their scope and where are they created in SQL Server?
        The table variable is a special data type that can be used to store temporary data similar to a temporary table.
        The table variable scope is within the batch. We can create a table variable inside a stored procedure and function as well.
        In this case, the table variable scope is within the stored procedure and function. 
        We cannot use it outside the scope of the batch, stored procedure or function.
-- 4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
        The DELETE statement is used when we want to remove some or all of the records from the table, 
        while the TRUNCATE statement will delete entire rows from a table.
        Truncate is faster compared to delete as it makes less use of the transaction log.
-- 5.	What is Identity column? How does DELETE and TRUNCATE affect it?
        IDENTITY column is a special type of column that is used to automatically generate key values based on a provided seed (starting point) and increment.
-- 6.	What is difference between “delete from table_name” and “truncate table table_name”?
        DELETE scans the table to generate a count of rows that were affected then delete the rows one by one and records an entry in the database log for each deleted row,
        while TRUNCATE TABLE just delete all the rows without providing any additional information.
-- Write queries for following scenarios
-- All scenarios are based on Database NORTHWIND.
USE NORTHWIND
GO
-- 1.	List all cities that have both Employees and Customers.
SELECT DISTINCT City FROM Customers WHERE City IN (SELECT City FROM Employees)
-- 2.	List all cities that have Customers but no Employee.
-- a.	Use sub-query
SELECT DISTINCT City FROM Customers 
WHERE City NOT IN (SELECT DISTINCT City FROM Employees WHERE City IS NOT NULL)
-- b.	Do not use sub-query
SELECT DISTINCT City FROM Customers  
EXCEPT 
SELECT DISTINCT City FROM Employees
-- 3.	List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) [TotalQTY]
FROM Products p LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY p.ProductName
-- 4.	List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) [TotalQTY]
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
ORDER BY c.City
-- 5.	List all Customer Cities that have at least two customers.
-- a.	Use union
SELECT City FROM Customers
EXCEPT
SELECT City FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) = 1
UNION 
SELECT City FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) = 0
-- b.	Use sub-query and no union
SELECT DISTINCT City
FROM Customers
WHERE City IN (SELECT City FROM Customers GROUP BY City HAVING COUNT(CustomerID) >= 2)
ORDER BY City
-- 6.	List all Customer Cities that have ordered at least two different kinds of products.
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City, od.ProductID
HAVING COUNT(od.ProductID) >= 2
ORDER BY c.City
-- 7.	List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.CustomerID Customer, c.City, o.ShipCity
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City <> o.ShipCity
ORDER BY c.CustomerID
-- 8.	List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 (SELECT TOP 1 ProductName FROM Products p JOIN [Order Details] od2 ON od2.ProductID = od1.ProductID WHERE p.ProductID = od1.ProductID) [Product Name],
    AVG(od1.UnitPrice) [AVG Price],
    (SELECT TOP 1 c.City FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
        JOIN [Order Details] od3 ON o.OrderID = od3.OrderID 
    WHERE od1.ProductID = od3.ProductID GROUP BY c.City ORDER BY SUM(od3.Quantity) DESC) MostOrderedCity
FROM [Order Details] od1
GROUP BY od1.ProductID
ORDER BY SUM(od1.Quantity) DESC
-- 9.	List all cities that have never ordered something but we have employees there.
-- a.	Use sub-query
SELECT DISTINCT City 
FROM Employees 
WHERE City NOT IN (SELECT ShipCity FROM Orders WHERE ShipCity IS NOT NULL)
-- b.	Do not use sub-query
SELECT DISTINCT City 
FROM Employees
WHERE City IS NOT NULL
EXCEPT 
SELECT ShipCity
FROM Orders 
WHERE ShipCity IS NOT NULL
-- 10.	List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is,
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT (SELECT TOP 1 e.City FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY e.EmployeeID, e.City
ORDER BY COUNT(o.OrderID) DESC) MostOrderedCity,
(SELECT TOP 1 e.City MostOrderedCity FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY e.EmployeeID, e.City
ORDER BY SUM(od.Quantity) DESC) MostQunatitySoldCity
-- 11.  How do you remove the duplicates record of a table?
WITH CTE AS
(
SELECT * , ROW_NUMBER() OVER (PARTITION BY col ORDER BY col) AS RN
FROM Table_Name
)
DELETE FROM CTE WHERE RN > 1
-- 12.  Sample table to be used for solutions below- 
--      Employee (empid integer, mgrid integer, deptid integer, salary money) Dept (deptid integer, deptname varchar(20))
--      Find employees who do not manage anybody.
SELECT empid FROM Employee
WHERE empid NOT IN (SELECT mgrid FROM Employee WHERE mgrid IS NULL)
-- 13.  Find departments that have maximum number of employees. 
--      (solution should consider scenario having more than 1 departments that have maximum number of employees). 
--      Result should only have - deptname, count of employees sorted by deptname.
SELECT d.deptname
FROM Dept d JOIN Employee e ON d.deptid = e.deptid
HAVING COUNT(empid) = 
(
    SELECT MAX(total) FROM (
    SELECT d.deptname, COUNT(e.empid) total
    FROM Dept d JOIN Employee e ON d.deptid = e.deptid
    GROUP BY d.deptname)
)
ORDER BY 1
-- 14.  Find top 3 employees (salary based) in every department.
--      Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.
SELECT TOP 3 d.deptname, e.empid, e.salary
FROM Dept d JOIN Employee e ON d.deptid = e.deptid
WHERE d.deptid IN 
(
    SELECT TOP 3 deptid, salary
    FROM Employee
    GROUP BY deptid 
    ORDER BY 2 DESC
)
ORDER BY 1, 3 DESC