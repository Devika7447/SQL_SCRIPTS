--12
/*
/*

Write a solution to show the unique ID of each user, 
If a user does not have a unique ID replace just show null.

Return employee name and their unique_id.

*/

DROP TABLE IF EXISTS Employees
CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Employees (id, name) VALUES
    (1, 'Alice'),
    (7, 'Bob'),
    (11, 'Meir'),
    (90, 'Winston'),
    (3, 'Jonathan');


DROP TABLE IF EXISTS EmployeeUNI;

CREATE TABLE EmployeeUNI (
    id INT PRIMARY KEY,
    unique_id INT
);


INSERT INTO EmployeeUNI (id, unique_id) VALUES
    (3, 1),
    (11, 2),
    (90, 3);

SELECT * FROM Employees;
SELECT * FROM EmployeeUNI;

SELECT e.name,eu.unique_id 
FROM Employees as e
LEFT JOIN EmployeeUNI as eu
ON e.id=eu.id

--13
/*
You have a table named employees containing information about employees, 
including their emp_id, name, and manager_id. 
The manager_id refers to the emp_id of the employee's manager.


write a SQL query to retrieve all employees' 
details along with their manager's names based on the manager ID

*/
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO employees (emp_id, name, manager_id) VALUES
(1, 'John Doe', NULL),        -- John Doe is not a manager
(2, 'Jane Smith', 1),          -- Jane Smith's manager is John Doe
(3, 'Alice Johnson', 1),       -- Alice Johnson's manager is John Doe
(4, 'Bob Brown', 3),           -- Bob Brown's manager is Alice Johnson
(5, 'Emily White', NULL),      -- Emily White is not a manager
(6, 'Michael Lee', 3),         -- Michael Lee's manager is Alice Johnson
(7, 'David Clark', NULL),      -- David Clark is not a manager
(8, 'Sarah Davis', 2),         -- Sarah Davis's manager is Jane Smith
(9, 'Kevin Wilson', 2),        -- Kevin Wilson's manager is Jane Smith
(10, 'Laura Martinez', 4);     -- Laura Martinez's manager is Bob Brown

SELECT * FROM employees;

SELECT    
    e1.emp_id,
    e1.name,
    e1.manager_id,
    e2.name as manager_name
FROM employees as e1
CROSS JOIN 
employees as e2    
WHERE e1.manager_id = e2.emp_id


select distinct(e2.name),e2.emp_id 
from employees e1
inner join employees e2
on e1.manager_id = e2.emp_id;

--14

/*


You are given two tables: orders and customers. 
The orders table contains information about orders placed by customers, including the order_id, customer_id, order_date, and order_amount. 

The customers table contains information about customers, 
including the customer_id, customer_name, and customer_email.

-- Find the top 2 customers who have spent the most money across all their orders. 
Return their names, emails, and total amounts spent.

*/

SELECT * FROM orders
SELECT * FROM customers


SELECT c.customer_name,c.customer_email,sum(o.order_amount) as total_spent
FROM orders as o
LEFT JOIN customers as c
ON o.customer_id=c.customer_id
GROUP BY c.customer_name, c.customer_email
ORDER BY sum(o.order_amount) DESC 
LIMIT 2

--highest order -- count(c.customer_id)--sum(o.order_amount)
SELECT c.customer_name, count(c.customer_id) as No_of_orders, sum(o.order_amount) as total_spent
FROM orders as o
LEFT JOIN customers as c
ON o.customer_id=c.customer_id
GROUP BY c.customer_name
ORDER BY sum(o.order_amount) DESC 
LIMIT 1

--15

/*


Given a table named employees with the following columns:
id, name, department, managerId

Write a SQL query to find the names of 
managers who have at least five direct reports. 
Return the result table in any order.

Ensure that no employee is their own manager.

The result format should include only the names
of the managers meeting the criteria.
*/



DROP TABLE IF EXISTS employees;
CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    department VARCHAR(255),
    managerId INT
);

INSERT INTO Employees (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101),
(107, 'Michael', 'C', NULL),
(108, 'Sarah', 'C', 107),
(109, 'Emily', 'C', 107),
(110, 'Brian', 'C', 107);

SELECT * FROM Employees


SELECT 
     e2.name as manager_name
FROM employees as e1
JOIN 
employees as e2
ON e1.managerid = e2.id
GROUP BY e1.managerid, e2.name
HAVING COUNT(e1.id) >= 5;

--16
/*

Question:
Write an SQL query to find customers who have made 
purchases in all product categories.

Tables:
Customers: customer_id (INT), customer_name (VARCHAR)

Purchases: purchase_id (INT), customer_id (INT), 
product_category (VARCHAR)

Your query should return the customer_id and 
customer_name of these customers.

*/

DROP TABLE IF EXISTS customers;
-- Creating the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);


DROP TABLE IF EXISTS purchases;
-- Creating the Purchases table
CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    product_category VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Inserting sample data into Customers table
INSERT INTO Customers (customer_id, customer_name) VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie'),
    (4, 'David'),
    (5, 'Emma');

-- Inserting sample data into Purchases table
INSERT INTO Purchases (purchase_id, customer_id, product_category) VALUES
    (101, 1, 'Electronics'),
    (102, 1, 'Books'),
    (103, 1, 'Clothing'),
    (104, 1, 'Electronics'),
    (105, 2, 'Clothing'),
    (106, 1, 'Beauty'),
    (107, 3, 'Electronics'),
    (108, 3, 'Books'),
    (109, 4, 'Books'),
    (110, 4, 'Clothing'),
    (111, 4, 'Beauty'),
    (112, 5, 'Electronics'),
    (113, 5, 'Books');


SELECT * FROM customers;
SELECT * FROM purchases;


SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT p.product_category)
FROM customers as c
JOIN 
purchases as p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING  COUNT(DISTINCT p.product_category) = 
(SELECT COUNT(DISTINCT product_category) FROM purchases)

--17


/*
-- Q.
You have a table with below COLUMNS
emp_id employee_name, department, salary


Find the details of employees whose salary is greater
than the average salary across the entire company.
*/

DROP TABLE IF EXISTS employees;
-- Creating the employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- Inserting sample data for employees
INSERT INTO employees (employee_name, department, salary) 
VALUES
    ('John Doe', 'HR', 50000.00),
    ('Jane Smith', 'HR', 55000.00),
    ('Michael Johnson', 'HR', 60000.00),
    ('Emily Davis', 'IT', 60000.00),
    ('David Brown', 'IT', 65000.00),
    ('Sarah Wilson', 'Finance', 70000.00),
    ('Robert Taylor', 'Finance', 75000.00),
    ('Jennifer Martinez', 'Finance', 80000.00);


SELECT * FROM employees;

-- Find avg salary - 64375
-- select * from employees use where salary > Find avg salary
-- 


SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) from employees) ;

--19

-- Question 
You have a table called products with below columns
product_id, product_name, price, qty 

Calculate the percentage contribution of each product 
to total revenue?

Round the result into 2 decimal
*/


DROP TABLE IF EXISTS products;
-- Creating the products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    quantity_sold INT
);

-- Inserting sample data for products
INSERT INTO products (product_id, product_name, price, quantity_sold) VALUES
    (1, 'iPhone', 899.00, 600),
    (2, 'iMac', 1299.00, 150),
    (3, 'MacBook Pro', 1499.00, 500),
    (4, 'AirPods', 499.00, 800),
    (5, 'Accessories', 199.00, 300);


SELECT * FROM products;

SELECT SUM(price*quantity_sold) as revenue FROM products


SELECT 
product_id,
product_name,
price*quantity_sold as revenue_by_product,
ROUND(price*quantity_sold/(SELECT SUM(price * quantity_sold) from products) * 100,2) as contribution
FROM products

--20

/*

-- Amazon Data Analyst Interview Question

Write a query that'll identify returning active users. 

A returning active user is a user that has made a 
second purchase within 7 days of their first purchase

Output a list of user_ids of these returning active users.

*/

DROP TABLE IF EXISTS amazon_transactions;
CREATE TABLE amazon_transactions (
    id SERIAL PRIMARY KEY,
    user_id INT,
    item VARCHAR(255),
    purchase_date DATE,
    revenue NUMERIC
);

INSERT INTO amazon_transactions (user_id, item, purchase_date, revenue) VALUES
(109, 'milk', '2020-03-03', 123),
(139, 'biscuit', '2020-03-18', 421),
(120, 'milk', '2020-03-18', 176),
(108, 'banana', '2020-03-18', 862),
(130, 'milk', '2020-03-28', 333),
(103, 'bread', '2020-03-29', 862),
(122, 'banana', '2020-03-07', 952),
(125, 'bread', '2020-03-13', 317),
(139, 'bread', '2020-03-30', 929),
(141, 'banana', '2020-03-17', 812),
(116, 'bread', '2020-03-31', 226),
(128, 'bread', '2020-03-04', 112),
(146, 'biscuit', '2020-03-04', 362),
(119, 'banana', '2020-03-28', 127),
(142, 'bread', '2020-03-09', 503),
(122, 'bread', '2020-03-06', 593),
(128, 'biscuit', '2020-03-24', 160),
(112, 'banana', '2020-03-24', 262),
(149, 'banana', '2020-03-29', 382),
(100, 'banana', '2020-03-18', 599),
(130, 'milk', '2020-03-16', 604),
(103, 'milk', '2020-03-31', 290),
(112, 'banana', '2020-03-23', 523),
(102, 'bread', '2020-03-25', 325),
(120, 'biscuit', '2020-03-21', 858),
(109, 'bread', '2020-03-22', 432),
(101, 'milk', '2020-03-01', 449),
(138, 'milk', '2020-03-19', 961),
(100, 'milk', '2020-03-29', 410),
(129, 'milk', '2020-03-02', 771),
(123, 'milk', '2020-03-31', 434),
(104, 'biscuit', '2020-03-31', 957),
(110, 'bread', '2020-03-13', 210),
(143, 'bread', '2020-03-27', 870),
(130, 'milk', '2020-03-12', 176),
(128, 'milk', '2020-03-28', 498),
(133, 'banana', '2020-03-21', 837),
(150, 'banana', '2020-03-20', 927),
(120, 'milk', '2020-03-27', 793),
(109, 'bread', '2020-03-02', 362),
(110, 'bread', '2020-03-13', 262),
(140, 'milk', '2020-03-09', 468),
(112, 'banana', '2020-03-04', 381),
(117, 'biscuit', '2020-03-19', 831),
(137, 'banana', '2020-03-23', 490),
(130, 'bread', '2020-03-09', 149),
(133, 'bread', '2020-03-08', 658),
(143, 'milk', '2020-03-11', 317),
(111, 'biscuit', '2020-03-23', 204),
(150, 'banana', '2020-03-04', 299),
(131, 'bread', '2020-03-10', 155),
(140, 'biscuit', '2020-03-17', 810),
(147, 'banana', '2020-03-22', 702),
(119, 'biscuit', '2020-03-15', 355),
(116, 'milk', '2020-03-12', 468),
(141, 'milk', '2020-03-14', 254),
(143, 'bread', '2020-03-16', 647),
(105, 'bread', '2020-03-21', 562),
(149, 'biscuit', '2020-03-11', 827),
(117, 'banana', '2020-03-22', 249),
(150, 'banana', '2020-03-21', 450),
(134, 'bread', '2020-03-08', 981),
(133, 'banana', '2020-03-26', 353),
(127, 'milk', '2020-03-27', 300),
(101, 'milk', '2020-03-26', 740),
(137, 'biscuit', '2020-03-12', 473),
(113, 'biscuit', '2020-03-21', 278),
(141, 'bread', '2020-03-21', 118),
(112, 'biscuit', '2020-03-14', 334),
(118, 'milk', '2020-03-30', 603),
(111, 'milk', '2020-03-19', 205),
(146, 'biscuit', '2020-03-13', 599),
(148, 'banana', '2020-03-14', 530),
(100, 'banana', '2020-03-13', 175),
(105, 'banana', '2020-03-05', 815),
(129, 'milk', '2020-03-02', 489),
(121, 'milk', '2020-03-16', 476),
(117, 'bread', '2020-03-11', 270),
(133, 'milk', '2020-03-12', 446),
(124, 'bread', '2020-03-31', 937),
(145, 'bread', '2020-03-07', 821),
(105, 'banana', '2020-03-09', 972),
(131, 'milk', '2020-03-09', 808),
(114, 'biscuit', '2020-03-31', 202),
(120, 'milk', '2020-03-06', 898),
(130, 'milk', '2020-03-06', 581),
(141, 'biscuit', '2020-03-11', 749),
(147, 'bread', '2020-03-14', 262),
(118, 'milk', '2020-03-15', 735),
(136, 'biscuit', '2020-03-22', 410),
(132, 'bread', '2020-03-06', 161),
(137, 'biscuit', '2020-03-31', 427),
(107, 'bread', '2020-03-01', 701),
(111, 'biscuit', '2020-03-18', 218),
(100, 'bread', '2020-03-07', 410),
(106, 'milk', '2020-03-21', 379),
(114, 'banana', '2020-03-25', 705),
(110, 'bread', '2020-03-27', 225),
(130, 'milk', '2020-03-16', 494),
(117, 'bread', '2020-03-10', 209);

SELECT * FROM amazon_transactions

SELECT 
    DISTINCT a1.user_id as active_users
FROM amazon_transactions a1 -- first purchase table
JOIN amazon_transactions a2 -- second purchase table 
ON a1.user_id = a2.user_id    
AND a1.purchase_date < a2.purchase_date
AND a2.purchase_date - a1.purchase_date <= 7
ORDER BY 1

/*
Find the user_id who has not purchased anything for 7 days 
after first purchase but they have done second purchase after 7 days 
*/
SELECT 
    DISTINCT a1.user_id as active_users
FROM amazon_transactions a1 -- first purchase table
JOIN amazon_transactions a2 -- second purchase table 
ON a1.user_id = a2.user_id    
AND a1.purchase_date < a2.purchase_date
AND a2.purchase_date - a1.purchase_date > 7
ORDER BY 1

--21
/*
-- Calculate the total revenue from 
each customer in March 2019. 

Include only customers who 
were active in March 2019.

Output the revenue along with the 
customer id and sort the results based 
on the revenue in descending order.
*/
-- cx_id and their revenue SUM(total order cost)
-- filter march 2019

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id INT,
    cust_id INT,
    order_date DATE,
    order_details VARCHAR(50),
    total_order_cost INT
);

INSERT INTO orders (id, cust_id, order_date, order_details, total_order_cost) VALUES
(1, 7, '2019-03-04', 'Coat', 100),
(2, 7, '2019-03-01', 'Shoes', 80),
(3, 3, '2019-03-07', 'Skirt', 30),
(4, 7, '2019-02-01', 'Coat', 25),
(5, 7, '2019-03-10', 'Shoes', 80),
(6, 1, '2019-02-01', 'Boats', 100),
(7, 2, '2019-01-11', 'Shirts', 60),
(8, 1, '2019-03-11', 'Slipper', 20),
(9, 15, '2019-03-01', 'Jeans', 80),
(10, 15, '2019-03-09', 'Shirts', 50),
(11, 5, '2019-02-01', 'Shoes', 80),
(12, 12, '2019-01-11', 'Shirts', 60),
(13, 1, '2019-03-11', 'Slipper', 20),
(14, 4, '2019-02-01', 'Shoes', 80),
(15, 4, '2019-01-11', 'Shirts', 60),
(16, 3, '2019-04-19', 'Shirts', 50),
(17, 7, '2019-04-19', 'Suit', 150),
(18, 15, '2019-04-19', 'Skirt', 30),
(19, 15, '2019-04-20', 'Dresses', 200),
(20, 12, '2019-01-11', 'Coat', 125),
(21, 7, '2019-04-01', 'Suit', 50),
(22, 3, '2019-04-02', 'Skirt', 30),
(23, 4, '2019-04-03', 'Dresses', 50),
(24, 2, '2019-04-04', 'Coat', 25),
(25, 7, '2019-04-19', 'Coat', 125);



SELECT 
    cust_id,
    SUM(total_order_cost) total_revenue
FROM orders
WHERE order_date BETWEEN '2019-03-01' 
    AND '2019-03-31'
GROUP BY cust_id
ORDER BY total_revenue DESC;
