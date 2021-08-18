-- 1.	What is a result set?
--      A selected set of rows from a database.
-- 2.	What is the difference between Union and Union All?
--      UNION combines the result set of 2+ SELECT statements with distinct values, while UNION ALL combines it with duplicated values.
-- 3.	What are the other Set Operators SQL Server has?
--      EXCEPT and INTERSECT.
-- 4.	What is the difference between Union and Join?
--      UNION combines rows from different queries, while JOIN combines columns from different tables.
-- 5.	What is the difference between INNER JOIN and FULL JOIN?
--      INNER JOIN results in the overlapping part of two datasets, while FULL JOIN also combines the outer parts of the two datasets.
-- 6.	What is difference between left join and outer join
--      LEFT JOIN is one type of OUTER JOINs(LEFT, RIGHT, FULL).
--      OUTER JOIN will return more rows when (INNER) JOIN.
--      For instance, LEFT (OUTER) JOIN will also return unmatched rows from the left table while joining.
-- 7.	What is cross join?
--      According to the definition on W3resource(https://www.w3resource.com/sql/joins/cross-join.php).
--      "CROSS JOIN produces a result set which is the number of rows in the first table multiplied by the number of rows in the second table.
--      If no WHERE clause is used along with CROSS JOIN, this kind of result is called as Cartesian Product".
--      In other words, CROSS JOIN makes different rows from 2 tables connect to each other.
--      Therefore, there will be COUNT(table1) * COUNT(table2) rows in the result set.
-- 8.	What is the difference between WHERE clause and HAVING clause?
--      Both Clauses are used to filter the records from the table.
--      WHERE is single based, and it can be used in SELECT, UPDATE, DELETE statements,
--      while HAVING is groups based, and it can only be used in SELECT statements.
-- 9.	Can there be multiple group by columns?
--      Yes, the SELECT column(s) should be grouped if using an aggregate function.
USE AdventureWorks2019
GO
-- Write queries for following scenarios
-- 1.	How many products can you find in the Production.Product table?
SELECT COUNT(*) AS NumOfProducts
FROM Production.Product
-- 2.	Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
-- First method, since COUNT(column) doesn't return NULL
SELECT COUNT(ProductSubcategoryID) AS NumOfProducts
FROM Production.Product
-- Second method
SELECT COUNT(*) AS NumOfProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
-- 3.	How many Products reside in each SubCategory? Write a query to display the results with the following titles.
-- ProductSubcategoryID CountedProducts
-- -------------------- ---------------
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID
HAVING ProductSubcategoryID IS NOT NULL
-- 4.	How many products that do not have a product subcategory.
SELECT COUNT(*) AS [Num Of Non-Subcategory Products]
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
-- 5.	Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) AS [Total Products]
FROM Production.ProductInventory
SELECT *
FROM Production.ProductInventory
-- 6.	Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--  ProductID           TheSum
-- -----------        ----------
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100
-- 7.	Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--    Shelf    ProductID    TheSum
-- ---------- ----------- -----------
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100
-- 8.	Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
-- 9.	Write query to see the average quantity of products by shelf from the table Production.ProductInventory
--  ProductID     Shelf     TheAvg
-- ----------- ---------- -----------
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
-- 10.	Write query to see the average quantity of products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--  ProductID     Shelf     TheAvg
-- ----------- ---------- -----------
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf
-- 11.	List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--      Color       Class    TheCount      AvgPrice
-- --------------- ------- ----------- -----------------
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class
-- Joins:
-- 12.  Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the following. 
-- Country                        Province
-- ---------                 ----------------------
SELECT c.Name AS Country, s.Name AS Province
FROM person.CountryRegion c JOIN person.StateProvince s
    ON c.CountryRegionCode = s.CountryRegionCode
ORDER BY Country
-- 13.	Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
-- Country                        Province
-- ---------                 ----------------------
SELECT c.Name AS Country, s.Name AS Province
FROM person.CountryRegion c JOIN person.StateProvince s
    ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name = 'Germany' OR c.Name = 'Canada'
ORDER BY Country
--         Using Northwind Database: (Use aliases for all the Joins)
USE Northwind
GO
-- 14.	List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON o.OrderID = od.OrderID
WHERE DATEDIFF(year, o.OrderDate, GETDATE()) <= 25
-- 15.	List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5
    o.ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity) DESC
-- 16.	List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5
    o.ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE DATEDIFF(year, o.OrderDate, GETDATE()) <= 25
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity) DESC
-- 17.	List all city names and number of customers in that city.
SELECT City, COUNT(CustomerID) AS NumofCustomers
FROM Customers
GROUP BY City
-- 18.	List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) AS NumofCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2
-- 19.	List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.CustomerID
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'
-- 20.	List the names of all customers with most recent order dates
SELECT c.CustomerID AS [Customer Name], o.OrderDate AS [Most Recent Order Dates]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC
-- 21.	Display the names of all customers along with the count of products they bought
SELECT c.CustomerID AS [Customer Name], SUM(od.Quantity) AS [Bought Products]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
ORDER BY c.CustomerID
-- 22.	Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID AS [Customer Name], SUM(od.Quantity) AS [Bought Products]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100
ORDER BY c.CustomerID
-- 23.	List all of the possible ways that suppliers can ship their products. Display the results as below
--      Supplier Company Name   	                  Shipping Company Name
-- ---------------------------------            ----------------------------------
SELECT DISTINCT sup.CompanyName AS [Supplier Company Name], ship.CompanyName AS [Shipping Company Name]
FROM Suppliers sup JOIN Products p ON sup.SupplierID = p.SupplierID
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Shippers ship ON o.ShipVia = ship.ShipperID
ORDER BY sup.CompanyName
-- 24.	Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON o.OrderID = od.OrderID
ORDER BY o.OrderDate
-- 25.	Displays pairs of employees who have the same job title.
SELECT DISTINCT a.Title, a.FirstName + ' ' + a.LastName AS [Employee Name]
FROM Employees a JOIN Employees b ON a.EmployeeID <> b.EmployeeID
WHERE a.Title = b.Title
ORDER BY [Employee Name]
-- 26.	Display all the Managers who have more than 2 employees reporting to them.
SELECT a.FirstName + ' ' + a.LastName AS [Manager Name]
FROM Employees a JOIN Employees b ON a.EmployeeID = b.ReportsTo
GROUP BY a.FirstName, a.LastName
HAVING COUNT(b.ReportsTo) > 2
ORDER BY [Manager Name]
-- 27.	Display the customers and suppliers by city. The results should have the following columns
-- City -- Name -- Contact Name -- Type (Customer or Supplier)
    SELECT City, CustomerID AS Name, ContactName AS [Contact Name], 'Customer' AS Type
    FROM Customers
UNION
    SELECT City, CompanyName AS Name, ContactName AS [Contact Name], 'Supplier' AS Type
    FROM Suppliers
ORDER BY CITY
-- 28.  Have two tables T1 and T2
-- F1.T1	F2.T2
--   1	      2
--   2	      3
--   3	      4
-- Please write a query to inner join these two tables and write down the result of this query.
-- SELECT * FROM T1 JOIN T2 ON T1.F1 = T2.F2
--      Result
--   F1	      F2
-- ------   ------
--   2	      2
--   3	      3
-- 29.  Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
-- SELECT * FROM T1 LEFT JOIN T2 ON T1.F1 = T2.F2
--      Result
--   F1	      F2
-- ------   ------
--   1       NULL
--   2	      2
--   3	      3