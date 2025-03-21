--1
CREATE TABLE EMPLOYEES(
	EMPLOYEE_ID SERIAL PRIMARY KEY,
	NAME VARCHAR(100),
	DEPARTMENT VARCHAR(50),
	SALARY DECIMAL(10,2)
);
INSERT INTO EMPLOYEES(NAME,DEPARTMENT,SALARY)VALUES
('JOHN DOE','ENGINEERING',63000),
('JANE SMITH','ENGINEERING',55000),
('MICHAEL JOHNSON','ENGINEERING',64000),
('EMILY DAVIS','MARKETING',58000),
('CHRIS BROWN','MARKETING',56000),
('EMMA WILSON','MARKETING',59000),
('ALEX LEE','SALES',58000),
('SARAH ADAMS','SALES',58000),
('RYAN CLARK','SALES',61000);

--ADDED NEW RECORD
INSERT INTO EMPLOYEES VALUES
(11,'ZARA','IT',63000)

--Second highest salary
--Using 'Offset'
SELECT * FROM EMPLOYEES
ORDER BY SALARY DESC 
LIMIT 1 OFFSET 1;

--Using Windows function dense_rank
SELECT * FROM
(
	SELECT *,
	DENSE_RANK() OVER(ORDER BY SALARY DESC) DRN
	FROM EMPLOYEES 
)AS SUBQUERY
WHERE DRN=2; 

--SECOND HIGHEST SALARY FROM EACH DEPARTMENT
SELECT * FROM (
	SELECT *, 
	DENSE_RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY,DEPARTMENT DESC) DRN
	FROM EMPLOYEES
)AS SUBQUERY 
WHERE DRN=2 

--2
DROP TABLE IF EXISTS ORDERS;

CREATE TABLE ORDERS(
ORDERID INT PRIMARY KEY,
ORDERDATE DATE,
TOTALAMOUNT DECIMAL(10,2)
);

DROP TABLE IF EXISTS RETURNS;
CREATE TABLE RETURNS(
RETURNID INT PRIMARY KEY,
ORDERID INT,
FOREIGN KEY(ORDERID) REFERENCES ORDERS(ORDERID)
);


INSERT INTO ORDERS (ORDERID, ORDERDATE, TOTALAMOUNT) VALUES
(1, '2023-01-15', 150.50),
(2, '2023-02-20', 200.75),
(3, '2023-02-28', 300.25),
(4, '2023-03-10', 180.00),
(5, '2023-04-05', 250.80);

INSERT INTO RETURNS (RETURNID, ORDERID) VALUES
(101, 2),
(102, 4),
(103, 5),
(104, 1),
(105, 3);

SELECT * FROM ORDERS;
SELECT * FROM RETURNS;

--TOTAL NO OF RETURN ORDER EACH MONTH

SELECT 
	EXTRACT(MONTH FROM O.ORDERDATE) ||'-'|| EXTRACT(YEAR FROM O.ORDERDATE) AS MONTH,
	COUNT (R.ReturnID) AS TOTAL_RETURNS
FROM RETURNS AS R
LEFT JOIN 
ORDERS AS O
ON R.ORDERID=O.ORDERID
GROUP BY MONTH
ORDER BY MONTH

--3

DROP TABLE IF EXISTS PRODUCTS;
CREATE TABLE PRODUCTS(
	PRODUCT_ID INT PRIMARY KEY,
	PRODUCT_NAME VARCHAR(50),
	CATEGORY VARCHAR(50),
	QUANTITY_SOLD INT
);

INSERT INTO PRODUCTS (PRODUCT_ID, PRODUCT_NAME, CATEGORY, QUANTITY_SOLD) VALUES
(1, 'Samsung Galaxy S20', 'Electronics', 100),
(2, 'Apple iPhone 12 Pro', 'Electronics', 150),
(3, 'Sony PlayStation 5', 'Electronics', 80),
(4, 'Nike Air Max 270', 'Clothing', 200),
(5, 'Adidas Ultraboost 20', 'Clothing', 200),
(6, 'Levis Mens 501 Jeans', 'Clothing', 90),
(7, 'Instant Pot Duo 7-in-1', 'Home & Kitchen', 180),
(8, 'Keurig K-Classic Coffee Maker', 'Home & Kitchen', 130),
(9, 'iRobot Roomba 675 Robot Vacuum', 'Home & Kitchen', 130),
(10, 'Breville Compact Smart Oven', 'Home & Kitchen', 90),
(11, 'Dyson V11 Animal Cordless Vacuum', 'Home & Kitchen', 90);

SELECT * FROM PRODUCTS;

--TOP-SELLING PRODUCTS IN EACH CATEGORY


SELECT * FROM(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY CATEGORY ORDER BY QUANTITY_SOLD DESC) RN
	FROM PRODUCTS
	ORDER BY CATEGORY , QUANTITY_SOLD DESC)
AS SUBQUERY
WHERE RN=1

--LEAST SELLING PRODUCTS IN EACH CATEGORY

SELECT * FROM(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY CATEGORY ORDER BY QUANTITY_SOLD ) RN
	FROM PRODUCTS
	ORDER BY CATEGORY , QUANTITY_SOLD )
AS SUBQUERY
WHERE RN=1

--4
DROP TABLE IF EXISTS orde
create table orde(
  	category varchar(20),
	product varchar(20),
	user_id int , 
  	spend int,
  	transaction_date DATE
);

Insert into orde values
('appliance','refrigerator',165,246.00,'2021/12/26'),
('appliance','refrigerator',123,299.99,'2022/03/02'),
('appliance','washingmachine',123,219.80,'2022/03/02'),
('electronics','vacuum',178,152.00,'2022/04/05'),
('electronics','wirelessheadset',156,	249.90,'2022/07/08'),
('electronics','TV',145,189.00,'2022/07/15'),
('Television','TV',165,129.00,'2022/07/15'),
('Television','TV',163,129.00,'2022/07/15'),
('Television','TV',141,129.00,'2022/07/15'),
('toys','Ben10',145,189.00,'2022/07/15'),
('toys','Ben10',145,189.00,'2022/07/15'),
('toys','yoyo',165,129.00,'2022/07/15'),
('toys','yoyo',163,129.00,'2022/07/15'),
('toys','yoyo',141,129.00,'2022/07/15'),
('toys','yoyo',145,189.00,'2022/07/15'),
('electronics','vacuum',145,189.00,'2022/07/15');

WITH RANKED_CATEGORY
AS
(
SELECT category,total from
(
	SELECT 
	category,sum(spend) as total, DENSE_RANK() OVER(ORDER BY sum(spend) DESC) RN
	FROM orde 
	GROUP BY category 
	ORDER BY total DESC
)AS SUBQUERY
where RN<=2
)

SELECT category,product,total
FROM(
	SELECT o.product,o.category,sum(o.spend) as total, DENSE_RANK() OVER(PARTITION BY o.category ORDER BY SUM(o.spend) DESC) as pdrn
	FROM orde as o
	JOIN ranked_category as rc
	ON rc.category= o.category
	GROUP BY o.product,o.category 
	ORDER BY total DESC) SUBQUERY2
WHERE pdrn<=2

--5
--customers who 
--haven't made any purchases in the last month, 
--assuming today's date is April 2, 2024. 

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT,
    name VARCHAR(100),
    email VARCHAR(100)
);


DROP TABLE IF EXISTS ord;
CREATE TABLE ord (
    order_id INT ,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);



-- Inserting sample customers
INSERT INTO customers (customer_id, name, email) VALUES
(1, 'John Doe', 'john@example.com'),
(2, 'Jane Smith', 'jane@example.com'),
(3, 'Alice Johnson', 'alice@example.com'),
(4, 'Sam B', 'sb@example.com'),
(5, 'John Smith', 'j@example.com')	
;

-- Inserting sample orders
INSERT INTO ord (order_id, customer_id, order_date, amount) VALUES
(1, 1, '2024-03-05', 50.00),
(2, 2, '2024-03-10', 75.00),
(5, 4, '2024-04-02', 45.00),
(5, 2, '2024-04-02', 45.00)	,
(3, 4, '2024-04-15', 100.00),
(4, 1, '2024-04-01', 60.00),
(5, 5, '2024-04-02', 45.00);


SELECT * FROM customers
SELECT * FROM ord

SELECT 
	*
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM ord
							WHERE EXTRACT(MONTH from order_date) 
							= EXTRACT(MONTH FROM current_date)-1 	
							AND 
							EXTRACT(YEAR FROM order_date) = 
							EXTRACT(YEAR FROM current_date)
							);

--6
/*
How would you identify duplicate entries in
a SQL in given table employees columns are 
emp_id, name, department, salary
*/

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees(emp_id, name, department, salary) VALUES
(1, 'John Doe', 'Finance', 60000.00),
(2, 'Jane Smith', 'Finance', 65000.00), 
(2, 'Jane Smith', 'Finance', 65000.00),   -- Duplicate
(9, 'Lisa Anderson', 'Sales', 63000.00),
(9, 'Lisa Anderson', 'Sales', 63000.00),  -- Duplicate
(9, 'Lisa Anderson', 'Sales', 63000.00),  -- Duplicate
(10, 'Kevin Martinez', 'Sales', 61000.00);

SELECT * FROM employees

SELECT emp_id,COUNT(employees.emp_id) AS CNT 
FROM employees 
GROUP BY emp_id
HAVING COUNT(employees.emp_id)>1

--employee who is appearing more than twice in the table
SELECT employees.name,COUNT(employees.emp_id) AS CNT 
FROM employees 
GROUP BY employees.name
HAVING COUNT(employees.emp_id)>2

--7
/*
Write a SQL query to find all products that
haven't been sold in the last six months. 

Return the product_id, product_name, category, 
and price of these products.

*/

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

INSERT INTO Products (product_name, category, price) VALUES
('Product A', 'Category 1', 10.00),
('Product B', 'Category 2', 15.00),
('Product C', 'Category 1', 20.00),
('Product D', 'Category 3', 25.00);

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Sales (product_id, sale_date, quantity) VALUES
(1, '2023-09-15', 5),
(2, '2023-10-20', 3),
(1, '2024-01-05', 2),
(3, '2024-02-10', 4),
(4, '2023-12-03', 1);

SELECT p.*,s.sale_date 
FROM products as p
LEFT JOIN 
sales as s
ON p.product_id = s.product_id
WHERE s.sale_date IS NULL OR 
s.sale_date < current_date - INTERVAL '6 months'

--SELECT PRODUCT THAT HAS NOT RECIEVED ANY SALE IN PAST YEAR
SELECT p.*,s.sale_date 
FROM products as p
LEFT JOIN 
sales as s
ON p.product_id = s.product_id
WHERE s.sale_date IS NULL OR 
s.sale_date < current_date - INTERVAL '14 months'

--8
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    CustomerID INT,
    CustomerName VARCHAR(50)
);

DROP TABLE IF EXISTS purchases;
CREATE TABLE Purchases (
    PurchaseID INT,
    CustomerID INT,
    ProductName VARCHAR(50),
    PurchaseDate DATE
);

-- Insert sample data into Customers table
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'John'),
(2, 'Emma'),
(3, 'Michael'),
(4, 'Ben'),
(5, 'John')	;

-- Insert sample data into Purchases table
INSERT INTO Purchases (PurchaseID, CustomerID, ProductName, PurchaseDate) VALUES
(100, 1, 'iPhone', '2024-01-01'),
(101, 1, 'MacBook', '2024-01-20'),	
(102, 1, 'Airpods', '2024-03-10'),
(103, 2, 'iPad', '2024-03-05'),
(104, 2, 'iPhone', '2024-03-15'),
(105, 3, 'MacBook', '2024-03-20'),
(106, 3, 'Airpods', '2024-03-25'),
(107, 4, 'iPhone', '2024-03-22'),	
(108, 4, 'Airpods', '2024-03-29'),
(110, 5, 'Airpods', '2024-02-29'),
(109, 5, 'iPhone', '2024-03-22');

/*
write a SQL query to find customers who 
bought Airpods after purchasing an iPhone.
*/

SELECT * FROM customers;
SELECT * FROM purchases;

SELECT * FROM purchases WHERE productname='iPhone'
SELECT * FROM purchases WHERE productname='Airpods'

select c.* from customers as c
JOIN purchases as p
ON c.customerid=p.customerid
JOIN purchases as p1
ON c.customerid=p1.customerid
WHERE p.productname='iPhone'
AND
p1.productname='Airpods'
AND
p.purchasedate<p1.purchasedate

--chance that customer who bought macbook will buy an airpod
select *
from customers as c
JOIN purchases as p
ON c.customerid=p.customerid
JOIN purchases as p1
ON c.customerid=p1.customerid
WHERE p.productname='MacBook'
AND
p1.productname='Airpods'
AND
p.purchasedate<p1.purchasedate

--9


/*

Write a SQL query to classify employees into three categories based on their salary:

"High" - Salary greater than $70,000
"Medium" - Salary between $50,000 and $70,000 (inclusive)
"Low" - Salary less than $50,000

Your query should return the EmployeeID, FirstName, LastName, Department, Salary, and 
a new column SalaryCategory indicating the category to which each employee belongs.

*/

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary NUMERIC(10, 2)
);

-- Insert sample records into Employee table
INSERT INTO employees (EmployeeID, FirstName, LastName, Department, Salary) VALUES
(1, 'John', 'Doe', 'Finance', 75000.00),
(2, 'Jane', 'Smith', 'HR', 60000.00),
(3, 'Michael', 'Johnson', 'IT', 45000.00),
(4, 'Emily', 'Brown', 'Marketing', 55000.00),
(5, 'David', 'Williams', 'Finance', 80000.00),
(6, 'Sarah', 'Jones', 'HR', 48000.00),
(7, 'Chris', 'Taylor', 'IT', 72000.00),
(8, 'Jessica', 'Wilson', 'Marketing', 49000.00);

select * from employees;

SELECT *,
CASE 
WHEN salary >70000 THEN 'HIGH'
WHEN salary BETWEEN 50000 and 70000 THEN 'MEDIUM'
ELSE  'LOW'
END AS SALARY_CATEGORY
FROM employees



--10
/*

Identify returning customers based on their order history. 
Categorize customers as "Returning" if they have placed more than one return, 
and as "New" otherwise. 

Considering you have two table orders has information about sale
and returns has information about returns 

*/


DROP TABLE IF EXISTS ordi
DROP TABLE IF EXISTS returns;

CREATE TABLE ordi (
    order_id VARCHAR(10),
    customer_id VARCHAR(10),
    order_date DATE,
    product_id VARCHAR(10),
    quantity INT
);

CREATE TABLE returns (
    return_id VARCHAR(10),
    order_id VARCHAR(10)
    );

INSERT INTO ordi (order_id, customer_id, order_date, product_id, quantity)
VALUES
    ('1001', 'C001', '2023-01-15', 'P001', 4),
    ('1002', 'C001', '2023-02-20', 'P002', 3),
    ('1003', 'C002', '2023-03-10', 'P003', 8),
    ('1004', 'C003', '2023-04-05', 'P004', 2),
    ('1005', 'C004', '2023-05-20', 'P005', 3),
    ('1006', 'C002', '2023-06-15', 'P001', 6),
    ('1007', 'C003', '2023-07-20', 'P002', 1),
    ('1008', 'C004', '2023-08-10', 'P003', 2),
    ('1009', 'C005', '2023-09-05', 'P002', 3),
    ('1010', 'C001', '2023-10-20', 'P002', 1);

INSERT INTO returns (return_id, order_id)
VALUES
    ('R001', '1001'),
    ('R002', '1002'),
    ('R003', '1005'),
    ('R004', '1008'),
    ('R005', '1007');


SELECT * FROM ordi
select * from returns

select 
	o.customer_id,
	COUNT(o.order_id) as total_orders,
	COUNT(return_id) as total_returns,
	CASE 
		WHEN COUNT(r.return_id) > 1 THEN 'RETURNING'
		ELSE 'NEW'
	END AS CUSTOMER_CATEGORY
FROM ordi as o
LEFT JOIN returns as r
ON o.order_id=r.order_id
GROUP BY customer_id

/*
Categorize products based on their quantity sold into three categories:

"Low Demand": Quantity sold less than or equal to 5.
"Medium Demand": Quantity sold between 6 and 10 (inclusive).
"High Demand": Quantity sold greater than 10.
Expected Output:

Product ID
Quantity Sold
Demand Category


*/

select product_id,quantity, 
	CASE 
		WHEN quantity <= 5 THEN 'LOW DEMAND'
		WHEN quantity BETWEEN 6 AND 10 THEN 'MEDIUM DEMAND'
		ELSE 'HIGH DEMAND'
	END AS DEMAND_CATEGORY
FROM ordi 


