--E-Commerce Sales Analysis System
-- 1️ Create Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2️ Create Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_quantity INT
);



-- 3️ Create Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

-- 4️ Create Order Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price DECIMAL(10, 2)
);

-- 5️ Create Sales Transactions Table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6️ Insert Sample Data into Customers
INSERT INTO customers (name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '8765432109'),
('Charlie Brown', 'charlie@example.com', '7654321098');

-- 7️ Insert Sample Data into Products
INSERT INTO products (name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 75000, 10),
('Smartphone', 'Electronics', 50000, 15),
('Headphones', 'Accessories', 3000, 30);

-- 8️ Insert Sample Data into Orders
INSERT INTO orders (customer_id, status) VALUES
(1, 'Shipped'),
(2, 'Pending'),
(3, 'Delivered');

-- 9️ Insert Sample Data into Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 75000),
(2, 2, 1, 50000),
(3, 3, 2, 6000);

-- 10 Insert Sample Data into Sales Transactions
INSERT INTO sales (order_id, amount, payment_method) VALUES
(1, 75000, 'Credit Card'),
(3, 6000, 'PayPal');

select * from customers
select * from products
select * from orders
select * from order_items
select * from sales

-- Get Total Sales Per Product
SELECT p.name, SUM(oi.quantity) AS total_sold, SUM(oi.price * oi.quantity) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name;

--Find the Most Active Customers
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_orders DESC;

--Monthly Sales Report
SELECT EXTRACT(MONTH FROM sale_date) AS month, SUM(amount) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;

--Find Products That Were Never Ordered
SELECT p.name FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Get Orders With Their Total Amount
SELECT o.order_id, c.name, SUM(oi.price * oi.quantity) AS total_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.name;

--Get Customers Who Have Not Placed Any Orders
SELECT c.name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- Get Top-Selling Products by Revenue
SELECT p.name, SUM(oi.quantity * oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY revenue DESC LIMIT 5;

--Get Average Order Value Per Customer
SELECT c.name, AVG(total_order_value) AS avg_order_value
FROM (
    SELECT o.customer_id, SUM(oi.price * oi.quantity) AS total_order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) subquery
JOIN customers c ON subquery.customer_id = c.customer_id
GROUP BY c.name;

--Get Number of Orders Per Month
SELECT EXTRACT(MONTH FROM order_date) AS month, COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

--Get Orders That Include More Than One Product
SELECT order_id FROM order_items
GROUP BY order_id
HAVING COUNT(quantity) > 1;

--hr employee management

-- 1️ Create Departments Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

-- 2️ Create Employees Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department_id INT REFERENCES departments(department_id),
    salary DECIMAL(10,2),
    hire_date DATE,
    status VARCHAR(20) CHECK (status IN ('Active', 'Resigned', 'On Leave'))
);

-- 3️ Create Attendance Table
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    attendance_date DATE,
    status VARCHAR(20) CHECK (status IN ('Present', 'Absent', 'Leave'))
);

-- 4️ Create Salaries Table
CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    amount DECIMAL(10,2),
    salary_date DATE
);

-- 5️ Insert Sample Data into Departments
INSERT INTO departments (name) VALUES
('HR'),
('IT'),
('Finance'),
('Marketing');

-- 6️ Insert Sample Data into Employees
INSERT INTO employees (name, department_id, salary, hire_date, status) VALUES
('Alice Johnson', 1, 60000, '2020-05-15', 'Active'),
('Bob Smith', 2, 75000, '2019-03-10', 'Active'),
('Charlie Brown', 3, 80000, '2018-07-20', 'Resigned');

-- 7️ Insert Sample Data into Attendance
INSERT INTO attendance (employee_id, attendance_date, status) VALUES
(1, '2024-02-25', 'Present'),
(2, '2024-02-25', 'Absent'),
(3, '2024-02-25', 'Leave');

-- 8️ Insert Sample Data into Salaries
INSERT INTO salaries (employee_id, amount, salary_date) VALUES
(1, 60000, '2024-02-01'),
(2, 75000, '2024-02-01'),
(3, 80000, '2024-01-01');

-- Get Total Employees in Each Department
SELECT d.name, COUNT(e.employee_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.name;

--  Find Employees with Highest Salaries
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 5;

--  Get Monthly Salary Expenses
SELECT EXTRACT(MONTH FROM salary_date) AS month, SUM(amount) AS total_salary_expense
FROM salaries
GROUP BY month ORDER BY month;

--  Find Employees Who Were Absent on a Given Date
SELECT e.name FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
WHERE a.attendance_date = '2024-02-25' AND a.status = 'Absent';

--  Get Employee Attendance Summary
SELECT e.name, COUNT(a.attendance_id) FILTER (WHERE a.status = 'Present') AS days_present,
       COUNT(a.attendance_id) FILTER (WHERE a.status = 'Absent') AS days_absent
FROM employees e
LEFT JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY e.name;

--  Get Average Salary Per Department
SELECT d.name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.name;

--  Get Employees Who Have Never Taken Leave
SELECT e.name FROM employees e
LEFT JOIN attendance a ON e.employee_id = a.employee_id AND a.status = 'Leave'
WHERE a.attendance_id IS NULL;

--  Get Employee Count by Status
SELECT status, COUNT(employee_id) FROM employees GROUP BY status;

--  Find Employees Hired in the Last 5 Years
SELECT name, hire_date FROM employees WHERE hire_date >= CURRENT_DATE - INTERVAL '5 years';

--  Get Employees With More Than 5 Absences
SELECT e.name, COUNT(a.attendance_id) AS total_absences
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
WHERE a.status = 'Absent'
GROUP BY e.name
HAVING COUNT(a.attendance_id) > 5;


--Hospital Management System

-- Create Patients Table
CREATE TABLE Patients (
    PatientID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Phone VARCHAR(15),
    Address TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Doctors Table
CREATE TABLE Doctors (
    DoctorID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

--  Create Appointments Table
CREATE TABLE Appointments (
    AppointmentID SERIAL PRIMARY KEY,
    PatientID INT REFERENCES Patients(PatientID),
    DoctorID INT REFERENCES Doctors(DoctorID),
    AppointmentDate TIMESTAMP,
    Status VARCHAR(20) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled'))
);

--  Create Treatments Table
CREATE TABLE Treatments (
    TreatmentID SERIAL PRIMARY KEY,
    PatientID INT REFERENCES Patients(PatientID),
    DoctorID INT REFERENCES Doctors(DoctorID),
    Diagnosis TEXT,
    Prescription TEXT,
    TreatmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Create Billing Table
CREATE TABLE Billing (
    BillID SERIAL PRIMARY KEY,
    PatientID INT REFERENCES Patients(PatientID),
    Amount DECIMAL(10,2),
    PaymentStatus VARCHAR(20) CHECK (PaymentStatus IN ('Paid', 'Pending')),
    BillDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Insert Sample Data into Patients
INSERT INTO Patients (Name, Age, Gender, Phone, Address) VALUES
('John Doe', 30, 'Male', '9876543210', '123 Main St'),
('Jane Smith', 25, 'Female', '8765432109', '456 Oak St'),
('Michael Brown', 40, 'Male', '7654321098', '789 Pine St');

--  Insert Sample Data into Doctors
INSERT INTO Doctors (Name, Specialty, Phone, Email) VALUES
('Dr. Alice Williams', 'Cardiology', '9876541234', 'alice@hospital.com'),
('Dr. Bob Johnson', 'Neurology', '8765435678', 'bob@hospital.com'),
('Dr. Charlie Davis', 'Pediatrics', '7654329876', 'charlie@hospital.com');

--  Insert Sample Data into Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status) VALUES
(1, 1, '2024-03-01 10:00:00', 'Scheduled'),
(2, 2, '2024-03-02 11:00:00', 'Completed'),
(3, 3, '2024-03-03 09:30:00', 'Cancelled');

-- Insert Sample Data into Treatments
INSERT INTO Treatments (PatientID, DoctorID, Diagnosis, Prescription) VALUES
(1, 1, 'High Blood Pressure', 'Aspirin, Rest'),
(2, 2, 'Migraine', 'Painkillers, Hydration'),
(3, 3, 'Flu', 'Rest, Vitamin C, Hydration');

-- Insert Sample Data into Billing
INSERT INTO Billing (PatientID, Amount, PaymentStatus) VALUES
(1, 5000, 'Paid'),
(2, 3000, 'Pending'),
(3, 1500, 'Paid');

--  Get All Appointments with Doctor and Patient Names
SELECT a.AppointmentID, p.Name AS Patient, d.Name AS Doctor, a.AppointmentDate, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;

--  Find the Most Popular Doctor (Most Appointments)
SELECT d.Name, COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.Name
ORDER BY TotalAppointments DESC;

--  Find Patients Who Haven’t Paid Their Bills
SELECT p.Name, b.Amount, b.PaymentStatus
FROM Patients p
JOIN Billing b ON p.PatientID = b.PatientID
WHERE b.PaymentStatus = 'Pending';

--  Get Total Revenue Earned by the Hospital
SELECT SUM(Amount) AS TotalRevenue FROM Billing WHERE PaymentStatus = 'Paid';

--  Get Patient Treatment History
SELECT p.Name, d.Name AS Doctor, t.Diagnosis, t.Prescription, t.TreatmentDate
FROM Treatments t
JOIN Patients p ON t.PatientID = p.PatientID
JOIN Doctors d ON t.DoctorID = d.DoctorID
ORDER BY t.TreatmentDate DESC;

-- Find Available Doctors (Doctors with No Scheduled Appointments)
SELECT d.Name FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID AND a.Status = 'Scheduled'
WHERE a.AppointmentID IS NULL;

-- Count Number of Appointments Per Status
SELECT Status, COUNT(AppointmentID) AS TotalAppointments
FROM Appointments
GROUP BY Status;

--  Get Patients Who Had More Than One Appointment
SELECT p.Name, COUNT(a.AppointmentID) AS AppointmentCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.Name
HAVING COUNT(a.AppointmentID) > 1;

--  Get Total Pending Payments Per Patient
SELECT p.Name, SUM(b.Amount) AS TotalPending
FROM Patients p
JOIN Billing b ON p.PatientID = b.PatientID
WHERE b.PaymentStatus = 'Pending'
GROUP BY p.Name;

--  Find the Last Appointment for Each Patient
SELECT p.Name, MAX(a.AppointmentDate) AS LastAppointmentDate
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.Name;

--Library Management System

--  Create Books Table
CREATE TABLE Books (
    BookID SERIAL PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    PublishedYear INT,
    CopiesAvailable INT
);

--  Create Members Table
CREATE TABLE Members (
    MemberID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    MembershipDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Create Borrow Records Table
CREATE TABLE BorrowRecords (
    BorrowID SERIAL PRIMARY KEY,
    MemberID INT REFERENCES Members(MemberID),
    BookID INT REFERENCES Books(BookID),
    BorrowDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DueDate TIMESTAMP,
    ReturnDate TIMESTAMP NULL
);

--  Create Fines Table
CREATE TABLE Fines (
    FineID SERIAL PRIMARY KEY,
    MemberID INT REFERENCES Members(MemberID),
    Amount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Paid', 'Pending')),
    FineDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Insert Sample Data into Books
INSERT INTO Books (Title, Author, Genre, PublishedYear, CopiesAvailable) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 1960, 4);

--  Insert Sample Data into Members
INSERT INTO Members (Name, Email, Phone) VALUES
('Alice Johnson', 'alice@example.com', '9876543210'),
('Bob Smith', 'bob@example.com', '8765432109'),
('Charlie Brown', 'charlie@example.com', '7654321098');

--  Insert Sample Data into Borrow Records
INSERT INTO BorrowRecords (MemberID, BookID, DueDate) VALUES
(1, 1, '2024-03-15'),
(2, 2, '2024-03-10'),
(3, 3, '2024-03-20');

--  Insert Sample Data into Fines
INSERT INTO Fines (MemberID, Amount, Status) VALUES
(1, 50.00, 'Paid'),
(2, 30.00, 'Pending'),
(3, 20.00, 'Paid');

select * from Books
select * from Members
select * from BorrowRecords
select * from Fines

--  Get All Borrowed Books with Member Names
SELECT br.BorrowID, m.Name AS Member, b.Title AS Book, br.BorrowDate, br.DueDate, br.ReturnDate
FROM BorrowRecords br
JOIN Members m ON br.MemberID = m.MemberID
JOIN Books b ON br.BookID = b.BookID;

--  Find Overdue Books
SELECT m.Name, b.Title, br.DueDate
FROM BorrowRecords br
JOIN Members m ON br.MemberID = m.MemberID
JOIN Books b ON br.BookID = b.BookID
WHERE br.ReturnDate IS NULL AND br.DueDate < CURRENT_DATE;

--  Find Members with Pending Fines
SELECT m.Name, f.Amount, f.Status
FROM Members m
JOIN Fines f ON m.MemberID = f.MemberID
WHERE f.Status = 'Pending';

--  Get Total Fine Collection
SELECT SUM(Amount) AS TotalCollected FROM Fines WHERE Status = 'Paid';

--  Find the Most Borrowed Books
SELECT b.Title, COUNT(br.BorrowID) AS BorrowCount
FROM Books b
JOIN BorrowRecords br ON b.BookID = br.BookID
GROUP BY b.Title
ORDER BY BorrowCount DESC;

--  Get Members Who Borrowed More Than 3 Books
SELECT m.Name, COUNT(br.BorrowID) AS TotalBorrows
FROM Members m
JOIN BorrowRecords br ON m.MemberID = br.MemberID
GROUP BY m.Name
HAVING COUNT(br.BorrowID) > 3;

--  Get Available Copies of Each Book
SELECT Title, CopiesAvailable FROM Books;

-- Find Books Not Borrowed Yet
SELECT Title FROM Books
WHERE BookID NOT IN (SELECT DISTINCT BookID FROM BorrowRecords);

--  Get Members with the Most Late Returns
SELECT m.Name, COUNT(br.BorrowID) AS LateReturns
FROM Members m
JOIN BorrowRecords br ON m.MemberID = br.MemberID
WHERE br.ReturnDate > br.DueDate
GROUP BY m.Name
ORDER BY LateReturns DESC;

-- Find the Last Borrowed Date of Each Book
SELECT b.Title, MAX(br.BorrowDate) AS LastBorrowedDate
FROM Books b
JOIN BorrowRecords br ON b.BookID = br.BookID
GROUP BY b.Title;

