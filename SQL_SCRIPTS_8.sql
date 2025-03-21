--Employee Payroll Management
DROP TABLE IF EXISTS Payroll, Deductions, Bonuses, Attendance, Employees CASCADE;

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Position VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

--  Create Payroll Table
CREATE TABLE Payroll (
    PayrollID SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    BaseSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    TaxDeduction DECIMAL(10,2),
    NetPay DECIMAL(10,2),
    PayrollDate DATE
);

-- Create Deductions Table
CREATE TABLE Deductions (
    DeductionID SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    DeductionType VARCHAR(50),
    Amount DECIMAL(10,2),
    DeductionDate DATE
);

-- Create Bonuses Table
CREATE TABLE Bonuses (
    BonusID SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    BonusType VARCHAR(50),
    Amount DECIMAL(10,2),
    BonusDate DATE
);

--  Create Attendance Table
CREATE TABLE Attendance (
    AttendanceID SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    AttendanceDate DATE,
    Status VARCHAR(20) CHECK (Status IN ('Present', 'Absent', 'Leave'))
);

--  Insert Sample Data into Employees
INSERT INTO Employees (Name, Position, Department, Salary, HireDate) VALUES
('Alice Johnson', 'Manager', 'HR', 80000, '2018-06-15'),
('Bob Smith', 'Developer', 'IT', 70000, '2019-09-10'),
('Charlie Brown', 'Analyst', 'Finance', 60000, '2020-12-01');

--  Insert Sample Data into Payroll
INSERT INTO Payroll (EmployeeID, BaseSalary, Bonus, TaxDeduction, NetPay, PayrollDate) VALUES
(1, 80000, 5000, 10000, 75000, '2024-02-28'),
(2, 70000, 3000, 8000, 65000, '2024-02-28'),
(3, 60000, 2000, 6000, 56000, '2024-02-28');

--  Insert Sample Data into Deductions
INSERT INTO Deductions (EmployeeID, DeductionType, Amount, DeductionDate) VALUES
(1, 'Tax', 10000, '2024-02-28'),
(2, 'Insurance', 8000, '2024-02-28'),
(3, 'Pension', 6000, '2024-02-28');

--  Insert Sample Data into Bonuses
INSERT INTO Bonuses (EmployeeID, BonusType, Amount, BonusDate) VALUES
(1, 'Performance', 5000, '2024-02-28'),
(2, 'Holiday', 3000, '2024-02-28'),
(3, 'Year-End', 2000, '2024-02-28');

--  Insert Sample Data into Attendance
INSERT INTO Attendance (EmployeeID, AttendanceDate, Status) VALUES
(1, '2024-02-25', 'Present'),
(2, '2024-02-25', 'Absent'),
(3, '2024-02-25', 'Leave');


select * from Employees
select * from Payroll
select * from Deductions
select * from Bonuses
select * from Attendance

--  Get Employee Payroll Summary
SELECT e.Name, p.BaseSalary, p.Bonus, p.TaxDeduction, p.NetPay, p.PayrollDate
FROM Payroll p
JOIN Employees e ON p.EmployeeID = e.EmployeeID;

--  Calculate Total Payroll Expense
SELECT SUM(NetPay) AS TotalPayrollExpense FROM Payroll;

-- Find Employees with the Highest Bonuses
SELECT e.Name, b.BonusType, b.Amount
FROM Bonuses b
JOIN Employees e ON b.EmployeeID = e.EmployeeID
ORDER BY b.Amount DESC LIMIT 5;

--  Get Employees with Tax Deductions Over $5000
SELECT e.Name, d.DeductionType, d.Amount
FROM Deductions d
JOIN Employees e ON d.EmployeeID = e.EmployeeID
WHERE d.Amount > 5000;

--  Get Employees Who Were Absent in the Last Month
SELECT e.Name, COUNT(a.AttendanceID) AS AbsentDays
FROM Employees e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE a.Status = 'Absent' AND a.AttendanceDate >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY e.Name;

--  Find Employees Eligible for a Bonus (Based on Performance)
SELECT e.Name FROM Employees e
WHERE e.EmployeeID NOT IN (
    SELECT EmployeeID FROM Bonuses WHERE BonusDate >= CURRENT_DATE - INTERVAL '6 months'
);

--  Calculate Average Salary per Department
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department;

--  Find Employees with More Than One Deduction
SELECT e.Name, COUNT(d.DeductionID) AS DeductionCount
FROM Employees e
JOIN Deductions d ON e.EmployeeID = d.EmployeeID
GROUP BY e.Name
HAVING COUNT(d.DeductionID) > 1;

-- Get Employees Who Have Never Taken Leave
SELECT e.Name FROM Employees e
LEFT JOIN Attendance a ON e.EmployeeID = a.EmployeeID AND a.Status = 'Leave'
WHERE a.AttendanceID IS NULL;

--  Find Employees with the Longest Tenure
SELECT Name, HireDate, (CURRENT_DATE - HireDate) AS DaysWorked
FROM Employees
ORDER BY DaysWorked DESC LIMIT 5;

--Inventory Management System

--  Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS Shipments, Orders, Stock, Suppliers, Products CASCADE;

--  Create Products Table
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    SupplierID INT,
    StockQuantity INT
);

--  Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Contact VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

-- Create Stock Table
CREATE TABLE Stock (
    StockID SERIAL PRIMARY KEY,
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Create Orders Table
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

--  Create Shipments Table
CREATE TABLE Shipments (
    ShipmentID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ShipDate TIMESTAMP,
    Carrier VARCHAR(50),
    TrackingNumber VARCHAR(50)
);

--  Insert Sample Data into Suppliers
INSERT INTO Suppliers (Name, Contact, Email) VALUES
('ABC Distributors', '9876543210', 'contact@abc.com'),
('XYZ Supplies', '8765432109', 'support@xyz.com'),
('Global Traders', '7654321098', 'info@global.com');

-- Insert Sample Data into Products
INSERT INTO Products (Name, Category, Price, SupplierID, StockQuantity) VALUES
('Laptop', 'Electronics', 75000, 1, 10),
('Smartphone', 'Electronics', 50000, 2, 15),
('Headphones', 'Accessories', 3000, 3, 30);

--  Insert Sample Data into Stock
INSERT INTO Stock (ProductID, Quantity) VALUES
(1, 10),
(2, 15),
(3, 30);

--  Insert Sample Data into Orders
INSERT INTO Orders (ProductID, Quantity, Status) VALUES
(1, 2, 'Shipped'),
(2, 1, 'Pending'),
(3, 3, 'Delivered');

select * from Suppliers
select * from Products
select * from Stock
select * from Orders

--   Get All Orders with Product Names and Status
SELECT o.OrderID, p.Name AS Product, o.Quantity, o.OrderDate, o.Status
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID;

--   Find Low-Stock Products
SELECT Name, StockQuantity
FROM Products
WHERE StockQuantity < 5;

--   Get Total Revenue Generated
SELECT SUM(o.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered';

--   Find Suppliers with the Most Products
SELECT s.Name, COUNT(p.ProductID) AS TotalProducts
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.Name
ORDER BY TotalProducts DESC;

--   Get Orders That Haven’t Been Shipped Yet
SELECT o.OrderID, p.Name AS Product, o.Quantity
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
LEFT JOIN Shipments s ON o.OrderID = s.OrderID
WHERE s.ShipmentID IS NULL;

--   Get Monthly Sales Report
SELECT EXTRACT(MONTH FROM o.OrderDate) AS Month, SUM(o.Quantity * p.Price) AS MonthlySales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered'
GROUP BY Month
ORDER BY Month;

--   Get Most Popular Products by Sales
SELECT p.Name, SUM(o.Quantity) AS TotalSold
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalSold DESC LIMIT 5;

--   Find Unshipped Orders and Their Age
SELECT o.OrderID, p.Name AS Product, o.OrderDate, (CURRENT_DATE - o.OrderDate) AS DaysPending
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Status = 'Pending';

--   Get Supplier Performance (Orders Fulfilled)
SELECT s.Name, COUNT(o.OrderID) AS OrdersFulfilled
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.Status = 'Delivered'
GROUP BY s.Name
ORDER BY OrdersFulfilled DESC;

--   Get Shipment Tracking Information
SELECT s.ShipmentID, o.OrderID, p.Name AS Product, s.ShipDate, s.Carrier, s.TrackingNumber
FROM Shipments s
JOIN Orders o ON s.OrderID = o.OrderID
JOIN Products p ON o.ProductID = p.ProductID;


--student management system

-- 1 Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS Fees, Attendance, Grades, Enrollments, Courses, Teachers, Students CASCADE;

-- 2 Create Students Table
CREATE TABLE Students (
    StudentID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    EnrollmentDate DATE
);

-- 3 Create Teachers Table
CREATE TABLE Teachers (
    TeacherID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Subject VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

-- 4 Create Courses Table
CREATE TABLE Courses (
    CourseID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    TeacherID INT REFERENCES Teachers(TeacherID),
    Credits INT
);

-- 5 Create Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID SERIAL PRIMARY KEY,
    StudentID INT REFERENCES Students(StudentID),
    CourseID INT REFERENCES Courses(CourseID),
    EnrollmentDate DATE
);

-- 6 Create Grades Table
CREATE TABLE Grades (
    GradeID SERIAL PRIMARY KEY,
    StudentID INT REFERENCES Students(StudentID),
    CourseID INT REFERENCES Courses(CourseID),
    Grade CHAR(1) CHECK (Grade IN ('A', 'B', 'C', 'D', 'F'))
);

-- 7 Create Attendance Table
CREATE TABLE Attendance (
    AttendanceID SERIAL PRIMARY KEY,
    StudentID INT REFERENCES Students(StudentID),
    CourseID INT REFERENCES Courses(CourseID),
    AttendanceDate DATE,
    Status VARCHAR(10) CHECK (Status IN ('Present', 'Absent'))
);

-- 8 Create Fees Table
CREATE TABLE Fees (
    FeeID SERIAL PRIMARY KEY,
    StudentID INT REFERENCES Students(StudentID),
    Amount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Paid', 'Pending')),
    DueDate DATE
);

-- 9 Insert Sample Data into Students
INSERT INTO Students (Name, Age, Gender, Email, Phone, EnrollmentDate) VALUES
('Alice Johnson', 20, 'Female', 'alice@example.com', '9876543210', '2023-06-10'),
('Bob Smith', 22, 'Male', 'bob@example.com', '8765432109', '2023-06-10'),
('Charlie Brown', 21, 'Male', 'charlie@example.com', '7654321098', '2023-06-12');

-- 10 Insert Sample Data into Teachers
INSERT INTO Teachers (Name, Subject, Email) VALUES
('Dr. Alice Williams', 'Mathematics', 'alicew@university.com'),
('Dr. Bob Johnson', 'Computer Science', 'bobj@university.com'),
('Dr. Charlie Davis', 'Physics', 'charlied@university.com');

-- 11 Insert Sample Data into Courses
INSERT INTO Courses (Name, TeacherID, Credits) VALUES
('Algebra', 1, 3),
('Data Structures', 2, 4),
('Quantum Physics', 3, 3);

-- 12 Insert Sample Data into Enrollments
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, '2023-08-15'),
(1, 2, '2023-08-15'),
(2, 2, '2023-08-16'),
(3, 3, '2023-08-17');

-- 13 Insert Sample Data into Grades
INSERT INTO Grades (StudentID, CourseID, Grade) VALUES
(1, 1, 'A'),
(1, 2, 'B'),
(2, 2, 'C'),
(3, 3, 'D');

-- 14 Insert Sample Data into Attendance
INSERT INTO Attendance (StudentID, CourseID, AttendanceDate, Status) VALUES
(1, 1, '2024-02-10', 'Present'),
(1, 2, '2024-02-10', 'Absent'),
(2, 2, '2024-02-10', 'Present'),
(3, 3, '2024-02-10', 'Absent');

-- 15 Insert Sample Data into Fees
INSERT INTO Fees (StudentID, Amount, Status, DueDate) VALUES
(1, 1000, 'Paid', '2024-03-01'),
(2, 1000, 'Pending', '2024-03-01'),
(3, 1000, 'Paid', '2024-03-01');


select * from Students
select * from Teachers
select * from Courses
select * from Enrollments
select * from Grades
select * from Attendance
select *  from Fees

--Retrieve all students and their assigned courses.
select s.studentid,s.name,c.name as course_name
from Students as s
LEFT JOIN Enrollments as e
ON s.studentid=e.studentid
JOIN Courses as c
ON e.courseid=c.courseid
group by  s.studentid,s.name,c.name

--Find students who haven’t enrolled in any courses.
select s.name 
from Students as s
LEFT JOIN Enrollments as e
ON s.studentid=e.studentid
where enrollmentid is null

--List the courses with the highest number of enrollments.
select c.courseid,c.name as course_name, count(e.courseid) as no_of_enrollments
from Courses as c
join Enrollments as e
on c.courseid=e.courseid
group by c.courseid,c.name
order by count(e.courseid) desc

--Get the total fees paid by each student.
select s.name as Student_name,f.amount as fees
from Students as s
JOIN Fees as f
ON s.studentid=f.studentid

--Find students who have outstanding fee balances.
select s.name 
from Students as s
JOIN Fees as f
on s.studentid=f.studentid
where f.status='Pending'

-- Get attendance percentage for each student.
SELECT 
    s.Name AS StudentName,
    COUNT(a.AttendanceID) AS TotalClasses,
    COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) AS DaysPresent,
    ROUND((COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) * 100.0) / COUNT(a.AttendanceID), 2) AS AttendancePercentage
FROM Students s
JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.Name
ORDER BY AttendancePercentage DESC;

--Retrieve the top 5 students based on grades.
SELECT 
    s.Name AS StudentName,
    ROUND(AVG(CASE 
        WHEN g.Grade = 'A' THEN 4.0
        WHEN g.Grade = 'B' THEN 3.0
        WHEN g.Grade = 'C' THEN 2.0
        WHEN g.Grade = 'D' THEN 1.0
        WHEN g.Grade = 'F' THEN 0.0
    END), 2) AS GPA
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.Name
ORDER BY GPA DESC
LIMIT 5;



--List students who have failed in at least one course.
SELECT s.Name, g.CourseID, g.Grade
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.Grade = 'F';
--Find teachers assigned to more than 3 courses.
select t.name,count(t.teacherid) as no_of_courses from Teachers as t
join Courses as c
on t.teacherid=c.teacherid
group by t.name
having count(t.teacherid)>3
--Generate a semester performance report for students.
SELECT 
    s.Name AS StudentName, 
    COUNT(g.CourseID) AS TotalCourses, 
    ROUND(AVG(CASE 
        WHEN g.Grade = 'A' THEN 4.0
        WHEN g.Grade = 'B' THEN 3.0
        WHEN g.Grade = 'C' THEN 2.0
        WHEN g.Grade = 'D' THEN 1.0
        WHEN g.Grade = 'F' THEN 0.0
    END), 2) AS GPA, 
    MAX(g.Grade) AS HighestGrade, 
    MIN(g.Grade) AS LowestGrade, 
    CASE 
        WHEN COUNT(CASE WHEN g.Grade = 'F' THEN 1 END) > 0 THEN 'Fail'
        ELSE 'Pass'
    END AS Status
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.Name
ORDER BY GPA DESC;

--ONLINE SHOPPING SYSTEM
-- 1 Drop Existing Tables (If They Exist)
DROP TABLE IF EXISTS Payments, Orders, Products, Customers CASCADE;

-- 2 Create Customers Table
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3 Create Products Table
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT
);

-- 4 Create Orders Table
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

-- 5 Create Payments Table
CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    Amount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Paid', 'Pending')),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6 Insert Sample Data into Customers
INSERT INTO Customers (Name, Email, Phone) VALUES
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '8765432109'),
('Charlie Brown', 'charlie@example.com', '7654321098');

-- 7 Insert Sample Data into Products
INSERT INTO Products (Name, Category, Price, StockQuantity) VALUES
('Laptop', 'Electronics', 75000, 10),
('Smartphone', 'Electronics', 50000, 15),
('Headphones', 'Accessories', 3000, 30);

-- 8 Insert Sample Data into Orders
INSERT INTO Orders (CustomerID, ProductID, Quantity, Status) VALUES
(1, 1, 1, 'Delivered'),
(2, 2, 2, 'Pending'),
(3, 3, 1, 'Shipped');

-- 9 Insert Sample Data into Payments
INSERT INTO Payments (OrderID, Amount, Status) VALUES
(1, 75000, 'Paid'),
(2, 100000, 'Pending'),
(3, 3000, 'Paid');

-- 10 Retrieve all orders with customer and product details
SELECT o.OrderID, c.Name AS CustomerName, p.Name AS ProductName, o.Quantity, o.OrderDate, o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;

-- 11 Find customers who haven't placed any orders
SELECT c.Name
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 12 Get the total revenue generated from orders
SELECT SUM(o.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered';

-- 13 Find the most popular product based on sales
SELECT p.Name, SUM(o.Quantity) AS TotalSold
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalSold DESC LIMIT 1;

-- 14 Retrieve customers with pending payments
SELECT c.Name, p.Amount, p.Status
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.Status = 'Pending';
