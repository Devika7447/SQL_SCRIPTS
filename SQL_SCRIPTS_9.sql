-- 1 Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS Employees CASCADE;

-- 2 Create Employees Table
CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE,
    ManagerID INT REFERENCES Employees(EmployeeID)
);

-- 3 Insert Sample Data into Employees
INSERT INTO Employees (Name, Department, Salary, HireDate, ManagerID) VALUES
('Alice Johnson', 'HR', 90000, '2015-06-15', NULL),
('Bob Smith', 'HR', 75000, '2017-09-10', 1),
('Charlie Brown', 'Finance', 95000, '2014-03-12', NULL),
('David White', 'Finance', 85000, '2016-08-20', 3),
('Emma Davis', 'IT', 120000, '2013-07-25', NULL),
('Frank Taylor', 'IT', 100000, '2016-11-30', 5),
('Grace Adams', 'IT', 95000, '2018-05-15', 5),
('Hank Green', 'Finance', 78000, '2019-01-10', 3);

-- 4 Retrieve Employee Hierarchy Using Recursive CTE
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT EmployeeID, Name, Department, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL  -- Start with top-level managers
    
    UNION ALL
    
    SELECT e.EmployeeID, e.Name, e.Department, e.ManagerID, eh.Level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, ManagerID;

-- 5 Rank Employees by Salary Within Each Department Using Window Functions
SELECT Name, Department, Salary,
       RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 6 Identify the Top 3 Highest-Paid Employees Per Department
SELECT Name, Department, Salary
FROM (
    SELECT Name, Department, Salary,
           RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank
    FROM Employees
) RankedEmployees
WHERE Rank <= 3;

--Windows Function

-- 1 Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS Sales, Orders, Products, Customers CASCADE;

-- 2 Create Customers Table
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3 Create Products Table
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 4 Create Orders Table
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5 Create Sales Table
CREATE TABLE Sales (
    SaleID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    SaleAmount DECIMAL(10,2)
);

-- 6 Insert Sample Data into Customers
INSERT INTO Customers (Name, Email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');

-- 7 Insert Sample Data into Products
INSERT INTO Products (Name, Category, Price) VALUES
('Laptop', 'Electronics', 75000),
('Smartphone', 'Electronics', 50000),
('Headphones', 'Accessories', 3000);

-- 8 Insert Sample Data into Orders
INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-01-05'),
(2, '2024-01-10'),
(3, '2024-02-15'),
(1, '2024-02-20');

-- 9 Insert Sample Data into Sales
INSERT INTO Sales (OrderID, ProductID, Quantity, SaleAmount) VALUES
(1, 1, 1, 75000),
(2, 2, 2, 100000),
(3, 3, 1, 3000),
(4, 1, 1, 75000);

-- 10 Rank Best-Selling Products
SELECT ProductID, Name, Category, SUM(Quantity) AS TotalSold,
       RANK() OVER (ORDER BY SUM(Quantity) DESC) AS Rank
FROM Sales
JOIN Products USING (ProductID)
GROUP BY ProductID, Name, Category;

-- 11 Calculate Cumulative Revenue Over Time
SELECT OrderDate, SUM(SaleAmount) OVER (ORDER BY OrderDate) AS CumulativeRevenue
FROM Sales
JOIN Orders USING (OrderID);

-- 12 Find Each Customer's Last Order Date
SELECT CustomerID, Name, OrderDate,
       LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrder
FROM Orders
JOIN Customers USING (CustomerID);

-- 13 Compare Monthly Sales Trends
SELECT OrderDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY OrderDate) - SaleAmount AS SalesDifference
FROM Sales
JOIN Orders USING (OrderID);

-- 14 Calculate Running Average of Sales
SELECT OrderDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS RunningAvg
FROM Sales
JOIN Orders USING (OrderID);

--CUSTOMER RETENTION ANALYSIS

-- 1 Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS ChurnEvents, Transactions, Subscriptions, Customers CASCADE;

-- 2 Create Customers Table
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3 Create Subscriptions Table
CREATE TABLE Subscriptions (
    SubscriptionID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    Plan VARCHAR(50),
    StartDate DATE,
    EndDate DATE
);

-- 4 Create Transactions Table
CREATE TABLE Transactions (
    TransactionID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    Amount DECIMAL(10,2),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5 Create Churn Events Table
CREATE TABLE ChurnEvents (
    ChurnID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    ChurnDate DATE
);

-- 6 Insert Sample Data into Customers
INSERT INTO Customers (Name, Email, RegistrationDate) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-01'),
('Bob Smith', 'bob@example.com', '2023-02-15'),
('Charlie Brown', 'charlie@example.com', '2023-03-10');

-- 7 Insert Sample Data into Subscriptions
INSERT INTO Subscriptions (CustomerID, Plan, StartDate, EndDate) VALUES
(1, 'Premium', '2023-01-01', '2024-01-01'),
(2, 'Basic', '2023-02-15', '2024-02-15'),
(3, 'Premium', '2023-03-10', '2024-03-10');

-- 8 Insert Sample Data into Transactions
INSERT INTO Transactions (CustomerID, Amount, TransactionDate) VALUES
(1, 150, '2023-06-01'),
(1, 200, '2023-07-15'),
(2, 50, '2023-08-10'),
(3, 300, '2023-09-05'),
(1, 250, '2023-12-01');

-- 9 Insert Sample Data into Churn Events
INSERT INTO ChurnEvents (CustomerID, ChurnDate) VALUES
(2, '2024-01-15');

-- 10 Find Customers Who Haven't Made a Purchase in a Long Time
SELECT CustomerID, Name, TransactionDate,
       LAG(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) AS PreviousTransaction,
       TransactionDate - LAG(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) AS DaysSinceLastPurchase
FROM Transactions
JOIN Customers USING (CustomerID);

-- 12 Rank Customers by Total Spending
SELECT CustomerID, Name, SUM(Amount) AS TotalSpent,
       RANK() OVER (ORDER BY SUM(Amount) DESC) AS SpendingRank
FROM Transactions
JOIN Customers USING (CustomerID)
GROUP BY CustomerID, Name;

-- 13 Get First and Last Transaction Dates Per Customer
SELECT CustomerID, Name,
       FIRST_VALUE(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) AS FirstTransaction,
       LAST_VALUE(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastTransaction
FROM Transactions
JOIN Customers USING (CustomerID);

-- 14 Predict Churn Risk Based on Inactivity
SELECT CustomerID, Name, TransactionDate,
       LEAD(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) AS NextTransaction,
       LEAD(TransactionDate) OVER (PARTITION BY CustomerID ORDER BY TransactionDate) - TransactionDate AS DaysUntilNextPurchase
FROM Transactions
JOIN Customers USING (CustomerID);

-- INVENTORY DEMAND FORECASTING

-- 1 Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS Restocks, StockLevels, Sales, Products CASCADE;

-- 2 Create Products Table
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 3 Create Sales Table
CREATE TABLE Sales (
    SaleID SERIAL PRIMARY KEY,
    ProductID INT REFERENCES Products(ProductID),
    SaleDate DATE,
    QuantitySold INT
);

-- 4 Create Stock Levels Table
CREATE TABLE StockLevels (
    StockID SERIAL PRIMARY KEY,
    ProductID INT REFERENCES Products(ProductID),
    StockDate DATE,
    StockQuantity INT
);

-- 5 Create Restocks Table
CREATE TABLE Restocks (
    RestockID SERIAL PRIMARY KEY,
    ProductID INT REFERENCES Products(ProductID),
    RestockDate DATE,
    Quantity INT
);

-- 6 Insert Sample Data into Products
INSERT INTO Products (Name, Category, Price) VALUES
('Laptop', 'Electronics', 75000),
('Smartphone', 'Electronics', 50000),
('Headphones', 'Accessories', 3000);

-- 7 Insert Sample Data into Sales
INSERT INTO Sales (ProductID, SaleDate, QuantitySold) VALUES
(1, '2024-01-05', 5),
(2, '2024-01-10', 8),
(3, '2024-01-15', 12),
(1, '2024-02-05', 7),
(2, '2024-02-10', 10);

-- 8 Insert Sample Data into Stock Levels
INSERT INTO StockLevels (ProductID, StockDate, StockQuantity) VALUES
(1, '2024-01-01', 50),
(2, '2024-01-01', 40),
(3, '2024-01-01', 30),
(1, '2024-02-01', 35),
(2, '2024-02-01', 25);

-- 9 Insert Sample Data into Restocks
INSERT INTO Restocks (ProductID, RestockDate, Quantity) VALUES
(1, '2024-01-20', 10),
(2, '2024-02-15', 15);

-- 10 Track Product Demand Trends
SELECT ProductID, Name, SaleDate, QuantitySold,
       SUM(QuantitySold) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeSales
FROM Sales
JOIN Products USING (ProductID);

-- 11 Calculate Stock Turnover Rate
SELECT ProductID, Name, SaleDate, QuantitySold,
       AVG(QuantitySold) OVER (PARTITION BY ProductID ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvgSales
FROM Sales
JOIN Products USING (ProductID);

-- 12 Predict Restock Needs Based on Sales Trends
SELECT ProductID, Name, StockDate, StockQuantity,
       LEAD(StockQuantity) OVER (PARTITION BY ProductID ORDER BY StockDate) AS NextStockLevel
FROM StockLevels
JOIN Products USING (ProductID);

-- 13 Rank Best-Selling Products
SELECT ProductID, Name, SUM(QuantitySold) AS TotalSales,
       RANK() OVER (ORDER BY SUM(QuantitySold) DESC) AS SalesRank
FROM Sales
JOIN Products USING (ProductID)
GROUP BY ProductID, Name;

-- 14 Identify Slow-Moving Stock
SELECT ProductID, Name, SaleDate, QuantitySold,
       LAG(QuantitySold) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS PreviousSales
FROM Sales
JOIN Products USING (ProductID);
