-- 1.	Design a Database for a company to Manage all its projects.
-- Company has diverse offices in several countries, which manage and co-ordinate the project of that country.
-- Head office has a unique name, city, country, address, phone number and name of the director.
-- Every head office manages a set of projects with Project code, title, project starting and end date, assigned budget and name of the person in-charge. 
-- One project is formed by the set of operations that can affect to several cities.
-- We want to know what actions are realized in each city storing its name, country and number of inhabitants.
CREATE DATABASE Company

CREATE TABLE Offices
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255) UNIQUE,
    City VARCHAR(255),
    Country VARCHAR(255),
    Address VARCHAR(255),
    Phone VARCHAR(255),
    DirectorId INT FOREIGN KEY REFERENCES Employees(Id) ON DELETE SET NULL
)

CREATE TABLE Projects
(
    ProjectCode INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    Budget MONEY,
    PersonInCharge INT FOREIGN KEY REFERENCES Employees(Id) ON DELETE SET NULL
)

CREATE TABLE Employees
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255) UNIQUE,
    Phone VARCHAR(255),
    OfficeId INT FOREIGN KEY REFERENCES Offices(Id) ON DELETE SET NULL,
    ProjectId INT FOREIGN KEY REFERENCES Projects(ProjectCode) ON DELETE SET NULL,
)
-- 2.	Design a database for a lending company which manages lending among people (p2p lending)
-- Lenders that lending money are registered with an Id, name and available amount of money for the financial operations. 
-- Borrowers are identified by their id and the company registers their name and a risk value depending on their personal situation.
-- When borrowers apply for a loan, a new loan code, the total amount, the refund deadline, the interest rate and its purpose are stored in database. 
-- Lenders choose the amount they want to invest in each loan. A lender can contribute with different partial amounts to several loans.
CREATE DATABASE LendingCompany

CREATE TABLE Lenders
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255),
    AvailableAmount MONEY
)
CREATE TABLE Borrowers
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255),
    RiskValue DECIMAL(4,2)
)

CREATE TABLE LoanLog
(
    LoanCode INT IDENTITY(1,1) PRIMARY KEY,
    LenderId INT FOREIGN KEY REFERENCES Lenders(Id) ON DELETE CASCADE,
    BorrowerId INT FOREIGN KEY REFERENCES Borrowers(Id) ON DELETE CASCADE,
    TotalAmount MONEY,
    RefundDeadline DATE,
    InterestRate DECIMAL(5,2),
    Purpose VARCHAR(255)
)
-- 3.	Design a database to maintain the menu of a restaurant.
-- Each course has its name, a short description, photo and final price.
-- Each course has categories characterized by their names, short description, name of the employee in-charge of them.
-- Besides the courses, some recipes are stored. They are formed by the name of their ingredients, the required amount, units of measurements and the current amount in the store.
CREATE DATABASE Menu

CREATE TABLE CourseCategories
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255),
    Descrition VARCHAR(255),
    EmployeeInCharge VARCHAR(255)
)

CREATE TABLE Ingredients
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255),
    Descrition VARCHAR(255),
    CurrentAmount INT
)

CREATE TABLE ReceiptIngredients
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IngredientId INT FOREIGN KEY REFERENCES Ingredients(Id) ON DELETE SET NULL,
    RequiredAmount INT,
    UnitofMeasurement VARCHAR(255)
)

CREATE TABLE Receipts
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IngredientId INT FOREIGN KEY REFERENCES ReceiptIngredients(Id) ON DELETE SET NULL,
    Descrition VARCHAR(255),
    CurrentAmount INT
)

CREATE TABLE Courses
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255),
    CategoryId INT FOREIGN KEY REFERENCES CourseCategories(Id) ON DELETE SET NULL,
    ReceiptId INT FOREIGN KEY REFERENCES Receipts(Id) ON DELETE SET NULL,
    Descrition VARCHAR(255),
    Photo VARCHAR(255),
    FinalPrice MONEY
)