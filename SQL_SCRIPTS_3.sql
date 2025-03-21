--21

/*
-- Question
You have a employees table with columns emp_id, emp_name,
department, salary, manager_id (manager is also emp in the table))

Identify employees who have a higher salary than their manager. 
*/


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10, 2),
    manager_id INT
);

INSERT INTO employees (employee_id, employee_name, department, salary, manager_id)
VALUES
    (1, 'John Doe', 'HR', 50000.00, NULL),
    (2, 'Jane Smith', 'HR', 55000.00, 1),
    (3, 'Michael Johnson', 'HR', 60000.00, 1),
    (4, 'Emily Davis', 'IT', 60000.00, NULL),
    (5, 'David Brown', 'IT', 65000.00, 4),
    (6, 'Sarah Wilson', 'Finance', 70000.00, NULL),
    (7, 'Robert Taylor', 'Finance', 75000.00, 6),
    (8, 'Jennifer Martinez', 'Finance', 80000.00, 6);

SELECT * FROM employees

select 
e.employee_id,
e.employee_name,
e.department,
e.salary,
e.manager_id,
m.employee_name as manager_name,
m.salary as manager_salary
from employees as e
JOIN 
employees as m
ON e.manager_id=m.employee_id
WHERE e.salary>m.salary	

-- Find all the employee who has salary greater than average salary?

SELECT * 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

--22


/*
-- Question
You have amazon orders data

For each week, find the total number 
of orders. 
Include only the orders that are 
from the first quarter of 2023.

The output should contain 'week' 
and 'quantity'.

*/

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    quantity INT
);


INSERT INTO orders 
(order_id, order_date, quantity) 
VALUES
(1, '2023-01-02', 5),
(2, '2023-02-05', 3),
(3, '2023-02-07', 2),
(4, '2023-03-10', 6),
(5, '2023-02-15', 4),
(6, '2023-04-21', 8),
(7, '2023-05-28', 7),
(8, '2023-05-05', 3),
(9, '2023-08-10', 5),
(10, '2023-05-02', 6),
(11, '2023-02-07', 4),
(12, '2023-04-15', 9),
(13, '2023-03-22', 7),
(14, '2023-04-30', 8),
(15, '2023-04-05', 6),
(16, '2023-02-02', 6),
(17, '2023-01-07', 4),
(18, '2023-05-15', 9),
(19, '2023-05-22', 7),
(20, '2023-06-30', 8),
(21, '2023-07-05', 6);

select 
extract(week from order_date) as week,
sum(quantity) as total_qty_sold
from orders
where
extract(year from order_date)=2023
AND
extract(quarter from order_date)=1
group by week;

-- Find each quarter and their total qty sale
select
extract(quarter from order_date) as quarter,
sum(quantity) as total_qty_sold
from orders
group by quarter

--23
/*
-- Amazon Data Analyst Interview
-- Top Monthly Sellers

You are provided with a transactional dataset from 
Amazon that contains detailed information about 
sales across different products and marketplaces. 

Your task is to list the top 3 sellers in each 
product category for January.

The output should contain 'seller_id' , 
'total_sales' ,'product_category' , 
'market_place', and 'month'.

*/

CREATE TABLE sales_data (
    seller_id VARCHAR(10),
    total_sales NUMERIC,
    product_category VARCHAR(20),
    market_place VARCHAR(10),
    month DATE
);



INSERT INTO sales_data (seller_id, total_sales, product_category, market_place, month)
VALUES
('s236', 36486.73, 'electronics', 'in', DATE '2024-01-01'),
('s918', 24286.4, 'books', 'uk', DATE '2024-01-01'),
('s163', 18846.34, 'electronics', 'us', DATE '2024-01-01'),
('s836', 35687.65, 'electronics', 'uk', DATE '2024-01-01'),
('s790', 31050.13, 'clothing', 'in', DATE '2024-01-01'),
('s195', 14299, 'books', 'de', DATE '2024-01-01'),
('s483', 49361.62, 'clothing', 'uk', DATE '2024-01-01'),
('s891', 48847.68, 'electronics', 'de', DATE '2024-01-01'),
('s272', 11324.61, 'toys', 'us', DATE '2024-01-01'),
('s712', 43739.86, 'toys', 'in', DATE '2024-01-01'),
('s968', 36042.66, 'electronics', 'jp', DATE '2024-01-01'),
('s728', 29158.51, 'books', 'us', DATE '2024-01-01'),
('s415', 24593.5, 'electronics', 'uk', DATE '2024-01-01'),
('s454', 35520.67, 'toys', 'in', DATE '2024-01-01'),
('s560', 27320.16, 'electronics', 'jp', DATE '2024-01-01'),
('s486', 37009.18, 'electronics', 'us', DATE '2024-01-01'),
('s749', 36277.83, 'toys', 'de', DATE '2024-01-01'),
('s798', 31162.45, 'electronics', 'in', DATE '2024-01-01'),
('s515', 26372.16, 'toys', 'in', DATE '2024-01-01'),
('s662', 22157.87, 'books', 'in', DATE '2024-01-01'),
('s919', 24963.97, 'toys', 'de', DATE '2024-01-01'),
('s863', 46652.67, 'electronics', 'us', DATE '2024-01-01'),
('s375', 18107.08, 'clothing', 'de', DATE '2024-01-01'),
('s583', 20268.34, 'toys', 'jp', DATE '2024-01-01'),
('s778', 19962.89, 'electronics', 'in', DATE '2024-01-01'),
('s694', 36519.05, 'electronics', 'in', DATE '2024-01-01'),
('s214', 18948.55, 'electronics', 'de', DATE '2024-01-01'),
('s830', 39169.01, 'toys', 'us', DATE '2024-01-01'),
('s383', 12310.73, 'books', 'in', DATE '2024-01-01'),
('s195', 45633.35, 'books', 'de', DATE '2024-01-01'),
('s196', 13643.27, 'books', 'jp', DATE '2024-01-01'),
('s796', 19637.44, 'electronics', 'jp', DATE '2024-01-01'),
('s334', 11999.1, 'clothing', 'de', DATE '2024-01-01'),
('s217', 23481.03, 'books', 'in', DATE '2024-01-01'),
('s123', 36277.83, 'toys', 'uk', DATE '2024-01-01'),
('s383', 17337.392, 'electronics', 'de', DATE '2024-02-01'),
('s515', 13998.997, 'electronics', 'jp', DATE '2024-02-01'),
('s583', 36035.539, 'books', 'jp', DATE '2024-02-01'),
('s195', 18493.564, 'toys', 'de', DATE '2024-02-01'),
('s728', 34466.126, 'electronics', 'de', DATE '2024-02-01'),
('s830', 48950.221, 'electronics', 'us', DATE '2024-02-01'),
('s483', 16820.965, 'electronics', 'uk', DATE '2024-02-01'),
('s778', 48625.281, 'toys', 'in', DATE '2024-02-01'),
('s918', 37369.321, 'clothing', 'de', DATE '2024-02-01'),
('s123', 46372.816, 'electronics', 'uk', DATE '2024-02-01'),
('s195', 18317.667, 'electronics', 'in', DATE '2024-02-01'),
('s798', 41005.313, 'books', 'in', DATE '2024-02-01'),
('s454', 39090.88, 'electronics', 'de', DATE '2024-02-01'),
('s454', 17839.314, 'toys', 'us', DATE '2024-02-01'),
('s798', 31587.685, 'toys', 'in', DATE '2024-02-01'),
('s778', 21237.38, 'books', 'jp', DATE '2024-02-01'),
('s236', 10625.456, 'toys', 'jp', DATE '2024-02-01'),
('s236', 17948.627, 'toys', 'jp', DATE '2024-02-01'),
('s749', 38453.678, 'toys', 'de', DATE '2024-02-01'),
('s790', 47052.035, 'toys', 'uk', DATE '2024-02-01'),
('s272', 34931.925, 'books', 'de', DATE '2024-02-01'),
('s375', 36753.65, 'toys', 'us', DATE '2024-02-01'),
('s214', 32449.737, 'toys', 'in', DATE '2024-02-01'),
('s163', 40431.402, 'electronics', 'in', DATE '2024-02-01'),
('s214', 30909.313, 'electronics', 'in', DATE '2024-02-01'),
('s415', 18068.768, 'electronics', 'jp', DATE '2024-02-01'),
('s836', 46302.659, 'clothing', 'jp', DATE '2024-02-01'),
('s383', 19151.927, 'electronics', 'uk', DATE '2024-02-01'),
('s863', 45218.714, 'books', 'us', DATE '2024-02-01'),
('s830', 18737.617, 'books', 'de', DATE '2024-02-01'),
('s968', 22973.801, 'toys', 'in', DATE '2024-02-01'),
('s334', 20885.29, 'electronics', 'uk', DATE '2024-02-01'),
('s163', 10278.085, 'electronics', 'de', DATE '2024-02-01'),
('s272', 29393.199, 'clothing', 'jp', DATE '2024-02-01'),
('s560', 16731.642, 'electronics', 'jp', DATE '2024-02-01'),
('s583', 38120.758, 'books', 'uk', DATE '2024-03-01'),
('s163', 22035.132, 'toys', 'uk', DATE '2024-03-01'),
('s918', 26441.481, 'clothing', 'jp', DATE '2024-03-01'),
('s334', 35374.054, 'books', 'in', DATE '2024-03-01'),
('s796', 32115.724, 'electronics', 'jp', DATE '2024-03-01'),
('s749', 39128.654, 'toys', 'in', DATE '2024-03-01'),
('s217', 35341.188, 'electronics', 'us', DATE '2024-03-01'),
('s334', 16028.702, 'books', 'us', DATE '2024-03-01'),
('s383', 44334.352, 'toys', 'in', DATE '2024-03-01'),
('s163', 42380.042, 'books', 'jp', DATE '2024-03-01'),
('s483', 16974.657, 'clothing', 'in', DATE '2024-03-01'),
('s236', 37027.605, 'electronics', 'de', DATE '2024-03-01'),
('s196', 45093.574, 'toys', 'uk', DATE '2024-03-01'),
('s486', 42688.888, 'books', 'in', DATE '2024-03-01'),
('s728', 32331.738, 'electronics', 'us', DATE '2024-03-01'),
('s123', 38014.313, 'electronics', 'us', DATE '2024-03-01'),
('s662', 45483.457, 'clothing', 'jp', DATE '2024-03-01'),
('s968', 47425.4, 'books', 'uk', DATE '2024-03-01'),
('s778', 36540.071, 'books', 'in', DATE '2024-03-01'),
('s798', 29424.55, 'toys', 'us', DATE '2024-03-01'),
('s334', 10723.015, 'toys', 'de', DATE '2024-03-01'),
('s662', 24658.751, 'electronics', 'uk', DATE '2024-03-01'),
('s163', 36304.516, 'clothing', 'us', DATE '2024-03-01'),
('s863', 20608.095, 'books', 'de', DATE '2024-03-01'),
('s214', 27375.775, 'toys', 'de', DATE '2024-03-01'),
('s334', 33076.155, 'clothing', 'in', DATE '2024-03-01'),
('s515', 32880.168, 'toys', 'us', DATE '2024-03-01'),
('s195', 48157.143, 'books', 'uk', DATE '2024-03-01'),
('s583', 23230.012, 'books', 'uk', DATE '2024-03-01'),
('s334', 13013.85, 'toys', 'jp', DATE '2024-03-01'),
('s375', 20738.994, 'electronics', 'in', DATE '2024-03-01'),
('s778', 25787.659, 'electronics', 'jp', DATE '2024-03-01'),
('s796', 36845.741, 'clothing', 'uk', DATE '2024-03-01'),
('s214', 21811.624, 'electronics', 'de', DATE '2024-03-01'),
('s334', 15464.853, 'books', 'in', DATE '2024-03-01');


SELECT * FROM sales_data;

select 
sum(total_sales) as cat_total_sale,
product_category,
seller_id
from sales_data
where extract(month from month)=1
group by 2

SELECT
    product_category,
    seller_id,
    sales
FROM 
   ( SELECT 
        product_category,
        seller_id,
        SUM(total_sales) as sales,
        DENSE_RANK() OVER(PARTITION BY product_category
        ORDER BY SUM(total_sales) DESC) dr
    FROM sales_data
    WHERE EXTRACT(MONTH FROM month) = 1
    GROUP BY product_category, seller_id
    ) as subquery
WHERE dr <=3;

--24

/*
Netflix Data Analyst Interview Question

For each video, find how many unique users 
flagged it. 
A unique user can be identified using the
combination of their first name and last name. 

Do not consider rows in which there is no flag ID.

*/

-- Create the user_flags table
CREATE TABLE user_flags (
    user_firstname VARCHAR(50),
    user_lastname VARCHAR(50),
    video_id VARCHAR(20),
    flag_id VARCHAR(20)
);

-- Insert the provided records into the user_flags table
INSERT INTO user_flags (user_firstname, user_lastname, video_id, flag_id) VALUES
('Richard', 'Hasson', 'y6120QOlsfU', '0cazx3'),
('Mark', 'May', 'Ct6BUPvE2sM', '1cn76u'),
('Gina', 'Korman', 'dQw4w9WgXcQ', '1i43zk'),
('Mark', 'May', 'Ct6BUPvE2sM', '1n0vef'),
('Mark', 'May', 'jNQXAC9IVRw', '1sv6ib'),
('Gina', 'Korman', 'dQw4w9WgXcQ', '20xekb'),
('Mark', 'May', '5qap5aO4i9A', '4cvwuv'),
('Daniel', 'Bell', '5qap5aO4i9A', '4sd6dv'),
('Richard', 'Hasson', 'y6120QOlsfU', '6jjkvn'),
('Pauline', 'Wilks', 'jNQXAC9IVRw', '7ks264'),
('Courtney', '', 'dQw4w9WgXcQ', NULL),
('Helen', 'Hearn', 'dQw4w9WgXcQ', '8946nx'),
('Mark', 'Johnson', 'y6120QOlsfU', '8wwg0l'),
('Richard', 'Hasson', 'dQw4w9WgXcQ', 'arydfd'),
('Gina', 'Korman', '', NULL),
('Mark', 'Johnson', 'y6120QOlsfU', 'bl40qw'),
('Richard', 'Hasson', 'dQw4w9WgXcQ', 'ehn1pt'),
('Lopez', '', 'dQw4w9WgXcQ', 'hucyzx'),
('Greg', '', '5qap5aO4i9A', NULL),
('Pauline', 'Wilks', 'jNQXAC9IVRw', 'i2l3oo'),
('Richard', 'Hasson', 'jNQXAC9IVRw', 'i6336w'),
('Johnson', 'y6120QOlsfU', '', 'iey5vi'),
('William', 'Kwan', 'y6120QOlsfU', 'kktiwe'),
('', 'Ct6BUPvE2sM', '', NULL),
('Loretta', 'Crutcher', 'y6120QOlsfU', 'nkjgku'),
('Pauline', 'Wilks', 'jNQXAC9IVRw', 'ov5gd8'),
('Mary', 'Thompson', 'Ct6BUPvE2sM', 'qa16ua'),
('Daniel', 'Bell', '5qap5aO4i9A', 'xciyse'),
('Evelyn', 'Johnson', 'dQw4w9WgXcQ', 'xvhk6d');

select * from user_flags

select video_id,
COUNT(distinct(concat(user_firstname, user_lastname))) as  cnt_users
from user_flags
where flag_id is not null
group by video_id
order by 2 desc

--25

/*
Question

Write an SQL script to display the 
immediate manager of an employee.

Given a table Employees with columns: 
Emp_No, Emp_Name, and Manager_Id.

The script should take an input parameter 
Emp_No and return the employee's name 
along with their immediate manager's name.

If an employee has no manager 
(i.e., Manager_Id is NULL), 
display "No Boss" for that employee.

*/

DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
  Emp_No DECIMAL(4,0) NOT NULL,
  Emp_Name VARCHAR(10),
  Job_Name VARCHAR(9),
  Manager_Id DECIMAL(4,0),
  HireDate DATE,
  Salary DECIMAL(7,2),
  Commission DECIMAL(7,2),  
  DeptNo DECIMAL(2,0) NOT NULL
);

INSERT INTO Employees (Emp_No, Emp_Name, Job_Name, Manager_Id, HireDate, Salary, Commission, DeptNo) VALUES
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10),
(7566, 'JONES', 'MANAGER', NULL, '1981-04-02', 2975, NULL, 20),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-07-29', 3000, NULL, 20),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20),
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', NULL, '1981-02-20', 1600, 300, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250, 1400, 30),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, 0, 30),
(7876, 'ADAMS', 'CLERK', NULL, '1987-06-02', 1100, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 30),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300, NULL, 10);

SELECT 
	e1.Emp_Name as employee_name,
	COALESCE(e2.Emp_Name,'NO BOSS') as manager_name
FROM Employees as e1
LEFT JOIN Employees as e2
ON e1.Manager_Id=e2.Emp_No
WHERE e1.emp_no=7499

--26

/*
Most Asked Data Analyst Interview Questions 

Write an SQL query to retrieve employee details 
from each department who have a salary greater 
than the average salary in their department.

*/

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
  Emp_No DECIMAL(4,0) NOT NULL,
  Emp_Name VARCHAR(10),
  Job_Name VARCHAR(9),
  Manager_Id DECIMAL(4,0),
  HireDate DATE,
  Salary DECIMAL(7,2),
  Commission DECIMAL(7,2),  
  Department VARCHAR(20) -- Changed from DeptNo to Department
);

INSERT INTO Employees (Emp_No, Emp_Name, Job_Name, Manager_Id, HireDate, Salary, Commission, Department) VALUES
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 'IT'),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 'HR'),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 'Marketing'),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 'Operations'),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-07-29', 3000, NULL, 'Operations'),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 'Operations'),
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 'Operations'),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600, 300, 'HR'),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 'HR'),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250, 1400, 'HR'),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, 0, 'HR'),
(7876, 'ADAMS', 'CLERK', 7788, '1987-06-02', 1100, NULL, 'Operations'),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 'HR'),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300, NULL, 'Marketing'),
(7905, 'BROWN', 'SALESMAN', 7698, '1981-11-12', 1250, 1400, 'HR'),
(7906, 'DAVIS', 'ANALYST', 7566, '1987-07-13', 3000, NULL, 'Operations'),
(7907, 'GARCIA', 'MANAGER', 7839, '1981-08-12', 2975, NULL, 'IT'),
(7908, 'HARRIS', 'SALESMAN', 7698, '1981-06-21', 1600, 300, 'HR'),
(7909, 'JACKSON', 'CLERK', 7902, '1981-11-17', 800, NULL, 'Operations'),
(7910, 'JOHNSON', 'MANAGER', 7839, '1981-04-02', 2850, NULL, 'Marketing'),
(7911, 'LEE', 'ANALYST', 7566, '1981-09-28', 1250, 1400, 'Operations'),
(7912, 'MARTINEZ', 'CLERK', 7902, '1981-12-03', 1250, NULL, 'Operations'),
(7913, 'MILLER', 'MANAGER', 7839, '1981-01-23', 2450, NULL, 'HR'),
(7914, 'RODRIGUEZ', 'SALESMAN', 7698, '1981-12-03', 1500, 0, 'Marketing'),
(7915, 'SMITH', 'CLERK', 7902, '1980-12-17', 1100, NULL, 'IT'),
(7916, 'TAYLOR', 'CLERK', 7902, '1981-02-20', 950, NULL, 'Marketing'),
(7917, 'THOMAS', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 'Operations'),
(7918, 'WHITE', 'ANALYST', 7566, '1981-09-28', 1300, NULL, 'IT'),
(7919, 'WILLIAMS', 'MANAGER', 7839, '1981-11-17', 5000, NULL, 'Marketing'),
(7920, 'WILSON', 'SALESMAN', 7698, '1981-05-01', 2850, NULL, 'HR'),
(7921, 'YOUNG', 'CLERK', 7902, '1981-06-09', 2450, NULL, 'Operations'),
(7922, 'ADAMS', 'ANALYST', 7566, '1987-07-13', 3000, NULL, 'HR'),
(7923, 'BROWN', 'MANAGER', 7839, '1981-08-12', 2975, NULL, 'Marketing'),
(7924, 'DAVIS', 'SALESMAN', 7698, '1981-06-21', 1600, 300, 'Operations');


SELECT * FROM Employees
SELECT 
    e1.emp_name,
    e1.salary,
    e1.department
FROM employees as e1
WHERE salary > (SELECT AVG(e2.salary)
                FROM employees as e2
                WHERE e2.department = e1.department) -- IT
    
SELECT * 
FROM Employees 
WHERE Salary < (SELECT AVG(Salary) FROM Employees);


--27
/*
SQL Challenge: Friday Purchases

Scenario:
IBM wants to analyze user purchases for Fridays
in the first quarter of the year. 

Calculate the average amount users spent
per order for each Friday.

Table:
Table Name: user_purchases

Columns:
user_id (int)
date (datetime)
amount_spent (float)
day_name (varchar)

Question:
Write an SQL query to find the average amount
spent by users per order for each Friday 
in the first quarter of the year.
*/

CREATE TABLE user_purchases (
    user_id INT,
    date DATE,
    amount_spent FLOAT,
    day_name VARCHAR(20)
);

-- Insert records into the user_purchases table
INSERT INTO user_purchases (user_id, date, amount_spent, day_name) VALUES
(1047, '2023-01-01', 288, 'Sunday'),
(1099, '2023-01-04', 803, 'Wednesday'),
(1055, '2023-01-07', 546, 'Saturday'),
(1040, '2023-01-10', 680, 'Tuesday'),
(1052, '2023-01-13', 889, 'Friday'),
(1052, '2023-01-13', 596, 'Friday'),
(1016, '2023-01-16', 960, 'Monday'),
(1023, '2023-01-17', 861, 'Tuesday'),
(1010, '2023-01-19', 758, 'Thursday'),
(1013, '2023-01-19', 346, 'Thursday'),
(1069, '2023-01-21', 541, 'Saturday'),
(1030, '2023-01-22', 175, 'Sunday'),
(1034, '2023-01-23', 707, 'Monday'),
(1019, '2023-01-25', 253, 'Wednesday'),
(1052, '2023-01-25', 868, 'Wednesday'),
(1095, '2023-01-27', 424, 'Friday'),
(1017, '2023-01-28', 755, 'Saturday'),
(1010, '2023-01-29', 615, 'Sunday'),
(1063, '2023-01-31', 534, 'Tuesday'),
(1019, '2023-02-03', 185, 'Friday'),
(1019, '2023-02-03', 995, 'Friday'),
(1092, '2023-02-06', 796, 'Monday'),
(1058, '2023-02-09', 384, 'Thursday'),
(1055, '2023-02-12', 319, 'Sunday'),
(1090, '2023-02-15', 168, 'Wednesday'),
(1090, '2023-02-18', 146, 'Saturday'),
(1062, '2023-02-21', 193, 'Tuesday'),
(1023, '2023-02-24', 259, 'Friday'),
(1023, '2023-02-24', 849, 'Friday'),
(1009, '2023-02-27', 552, 'Monday'),
(1012, '2023-03-02', 303, 'Thursday'),
(1001, '2023-03-05', 317, 'Sunday'),
(1058, '2023-03-08', 573, 'Wednesday'),
(1001, '2023-03-11', 531, 'Saturday'),
(1034, '2023-03-14', 440, 'Tuesday'),
(1096, '2023-03-17', 650, 'Friday'),
(1048, '2023-03-20', 711, 'Monday'),
(1089, '2023-03-23', 388, 'Thursday'),
(1001, '2023-03-26', 353, 'Sunday'),
(1016, '2023-03-29', 833, 'Wednesday');

SELECT * FROM user_purchases;

SELECT 
EXTRACT(WEEK FROM date) as week_num,
AVG(amount_spent) as avg_spent_friday
FROM user_purchases
Where
EXTRACT(Year from date)= 2023
and 
extract(quarter from date)=1
and
extract(dow from date)=5
group by 1

--28
/*
-- Most Profitable Companies
You are given a table called
forbes_global with columns
company, sector, industry, country, 
sales, profit, rank

Find out each country's most 
most profitable company details
*/

CREATE TABLE forbes_global (
    company VARCHAR(100),
    sector VARCHAR(100),
    industry VARCHAR(100),
    country VARCHAR(100),
    sales FLOAT,
    profits FLOAT,
    rank INT
);


-- Inserting the data
insert into forbes_global
VALUES  
('Walmart', 'Consumer Discretionary', 'General Merchandisers', 'United States', 482130.0, 14694.0, 1),
('Sinopec-China Petroleum', 'Energy', 'Oil & Gas Operations', 'China', 448452.0, 7840.0, 2),
('Royal Dutch Shell', 'Energy', 'Oil & Gas Operations', 'Netherlands', 396556.0, 15340.0, 3),
('China National Petroleum', 'Energy', 'Oil & Gas Operations', 'China', 392976.0, 2837.0, 4),
('State Grid', 'Utilities', 'Electric Utilities', 'China', 387056.0, 9573.0, 5),
('Saudi Aramco', 'Energy', 'Oil & Gas Operations', 'Saudi Arabia', 355905.0, 11002.0, 6),
('Volkswagen', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'Germany', 283565.0, 17742.4, 7),
('BP', 'Energy', 'Oil & Gas Operations', 'United Kingdom', 282616.0, 3591.0, 8),
('Amazon.com', 'Consumer Discretionary', 'Internet Services and Retailing', 'United States', 280522.0, 5362.0, 9),
('Toyota Motor', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'Japan', 275288.0, 18499.3, 10),
('Apple', 'Information Technology', 'Computers, Office Equipment', 'United States', 265595.0, 55256.0, 11),
('Exxon Mobil', 'Energy', 'Oil & Gas Operations', 'United States', 263910.0, 15850.0, 12),
('Berkshire Hathaway', 'Financials', 'Diversified Financials', 'United States', 247837.0, 8971.0, 13),
('Samsung Electronics', 'Information Technology', 'Electronics', 'South Korea', 245898.0, 19783.3, 14),
('McKesson', 'Health Care', 'Health Care: Pharmacy and Other Services', 'United States', 231091.0, 5070.0, 15),
('Glencore', 'Materials', 'Diversified Metals & Mining', 'Switzerland', 219754.0, 5436.0, 16),
('UnitedHealth Group', 'Health Care', 'Health Care: Insurance and Managed Care', 'United States', 201159.0, 13650.0, 17),
('Daimler', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'Germany', 197515.0, 8245.1, 18),
('CVS Health', 'Health Care', 'Health Care: Pharmacy and Other Services', 'United States', 194579.0, 6634.0, 19),
('AT&T', 'Telecommunication Services', 'Telecommunications', 'United States', 181193.0, 13906.0, 20),
('Foxconn', 'Technology', 'Electronics', 'Taiwan', 175617.0, 4103.4, 21),
('General Motors', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'United States', 174049.0, 6710.0, 22),
('Verizon Communications', 'Telecommunication Services', 'Telecommunications', 'United States', 170756.0, 19225.0, 23),
('Total', 'Energy', 'Oil & Gas Operations', 'France', 149769.0, 7480.0, 24),
('IBM', 'Information Technology', 'Information Technology Services', 'United States', 141682.0, 6606.0, 25),
('Ford Motor', 'Consumer Discretionary', 'Auto & Truck Manufacturers', 'United States', 140545.0, 6471.0, 26),
('Hon Hai Precision Industry', 'Technology', 'Electronics', 'Taiwan', 135129.0, 4493.3, 27),
('Trafigura Group', 'Energy', 'Trading', 'Singapore', 131638.0, 975.0, 28),
('General Electric', 'Industrials', 'Diversified Industrials', 'United States', 126661.0, 5136.0, 29),
('AmerisourceBergen', 'Health Care', 'Wholesalers: Health Care', 'United States', 122848.0, 1605.5, 30),
('Fannie Mae', 'Financials', 'Diversified Financials', 'United States', 120472.0, 18418.0, 31),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 120438.0, 975.0, 32),
('Koch Industries', 'Diversified', 'Diversified', 'United States', 115095.0, 5142.0, 33),
('Cardinal Health', 'Health Care', 'Wholesalers: Health Care', 'United States', 113982.0, 1377.0, 34),
('Alphabet', 'Technology', 'Internet Services and Retailing', 'United States', 110855.0, 18616.0, 35),
('Chevron', 'Energy', 'Oil & Gas Operations', 'United States', 110360.0, 5520.0, 36),
('Costco Wholesale', 'Consumer Discretionary', 'General Merchandisers', 'United States', 110215.0, 2115.0, 37),
('Cardinal Health', 'Health Care', 'Health Care: Pharmacy and Other Services', 'United States', 109838.0, 1718.0, 38),
('Ping An Insurance Group', 'Financials', 'Insurance', 'China', 109254.0, 2047.4, 39),
('Walgreens Boots Alliance', 'Consumer Staples', 'Food and Drug Stores', 'United States', 109026.0, 4563.0, 40),
('Costco Wholesale', 'Consumer Discretionary', 'Retailing', 'United States', 105156.0, 2115.0, 41),
('JPMorgan Chase', 'Financials', 'Diversified Financials', 'United States', 105153.0, 30615.0, 42),
('Verizon Communications', 'Telecommunication Services', 'Telecommunications', 'United States', 104887.0, 13568.0, 43),
('China Construction Bank', 'Financials', 'Banks', 'China', 104693.0, 38369.0, 44),
('China Construction Bank', 'Financials', 'Major Banks', 'China', 104692.9, 38369.2, 45),
('Trafigura Group', 'Energy', 'Trading', 'Netherlands', 103752.0, 975.0, 46),
('Exor Group', 'Financials', 'Diversified Financials', 'Netherlands', 103606.6, -611.2, 47),
('Anheuser-Busch InBev', 'Consumer Staples', 'Beverages', 'Belgium', 101541.0, 9536.0, 48),
('Bank of America', 'Financials', 'Banks', 'United States', 100264.0, 18724.0, 49),
('Bank of China', 'Financials', 'Banks', 'China', 99237.3, 28202.1, 50),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 97296.0, 975.0, 51),
('Dell Technologies', 'Technology', 'Computers, Office Equipment', 'United States', 94477.0, 2743.0, 52),
('CVS Health', 'Health Care', 'Health Care: Insurance and Managed Care', 'United States', 94005.0, 6239.0, 53),
('Trafigura Group', 'Energy', 'Trading', 'United Kingdom', 90345.0, 975.0, 54),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 88265.0, 975.0, 55),
('Trafigura Group', 'Energy', 'Trading', 'Netherlands', 88111.0, 975.0, 56),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 87044.0, 975.0, 57),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 84795.0, 975.0, 58),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 84361.0, 975.0, 59),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 83156.0, 975.0, 60),
('Trafigura Group', 'Energy', 'Trading', 'Switzerland', 82276.0, 975.0, 61);

SELECT * FROM forbes_global;

SELECT * FROM
(
SELECT *,
RANK() OVER (PARTITION BY country ORDER BY profits DESC) as rn
FROM forbes_global
)
where rn=1

-- Find out each sector top 2 most profitable company details
SELECT * FROM
(
SELECT *,
RANK() OVER (PARTITION BY sector ORDER BY profits DESC) as rn
FROM forbes_global
)
where rn<=2


--29
/*

You are given a table of New York housing 
price called house_transactions with columns
id, state, city, street_address, mkt_price

Identify properites where the mkt_price of the house 
exceeds the city's average mkt_price.

*/

-- Create the table
CREATE TABLE house_price (
    id INT,
    state VARCHAR(255),
    city VARCHAR(255),
    street_address VARCHAR(255),
    mkt_price INT
);
-- Insert all the records
INSERT INTO house_price (id, state, city, street_address, mkt_price) VALUES
(1, 'NY', 'New York City', '66 Trout Drive', 449761),
(2, 'NY', 'New York City', 'Atwater', 277527),
(3, 'NY', 'New York City', '58 Gates Street', 268394),
(4, 'NY', 'New York City', 'Norcross', 279929),
(5, 'NY', 'New York City', '337 Shore Ave.', 151592),
(6, 'NY', 'New York City', 'Plainfield', 624531),
(7, 'NY', 'New York City', '84 Central Street', 267345),
(8, 'NY', 'New York City', 'Passaic', 88504),
(9, 'NY', 'New York City', '951 Fulton Road', 270476),
(10, 'NY', 'New York City', 'Oxon Hill', 118112),
(11, 'CA', 'Los Angeles', '692 Redwood Court', 150707),
(12, 'CA', 'Los Angeles', 'Lewiston', 463180),
(13, 'CA', 'Los Angeles', '8368 West Acacia Ave.', 538865),
(14, 'CA', 'Los Angeles', 'Pearl', 390896),
(15, 'CA', 'Los Angeles', '8206 Old Riverview Rd.', 117754),
(16, 'CA', 'Los Angeles', 'Seattle', 424588),
(17, 'CA', 'Los Angeles', '7227 Joy Ridge Rd.', 156850),
(18, 'CA', 'Los Angeles', 'Battle Ground', 643454),
(19, 'CA', 'Los Angeles', '233 Bedford Ave.', 713841),
(20, 'CA', 'Los Angeles', 'Saint Albans', 295852),
(21, 'IL', 'Chicago', '8830 Baker St.', 12944),
(22, 'IL', 'Chicago', 'Watertown', 410766),
(23, 'IL', 'Chicago', '632 Princeton St.', 160696),
(24, 'IL', 'Chicago', 'Waxhaw', 464144),
(25, 'IL', 'Chicago', '7773 Tailwater Drive', 129393),
(26, 'IL', 'Chicago', 'Bonita Springs', 174886),
(27, 'IL', 'Chicago', '31 Summerhouse Rd.', 296008),
(28, 'IL', 'Chicago', 'Middleburg', 279000),
(29, 'IL', 'Chicago', '273 Windfall Avenue', 424846),
(30, 'IL', 'Chicago', 'Graham', 592268),
(31, 'TX', 'Houston', '91 Canterbury Dr.', 632014),
(32, 'TX', 'Houston', 'Dallas', 68868),
(33, 'TX', 'Houston', '503 Elmwood St.', 454184),
(34, 'TX', 'Houston', 'Kennewick', 186280),
(35, 'TX', 'Houston', '739 Chapel Street', 334474),
(36, 'TX', 'Houston', 'San Angelo', 204460),
(37, 'TX', 'Houston', '572 Parker Dr.', 678443),
(38, 'TX', 'Houston', 'Bellmore', 401090),
(39, 'TX', 'Houston', '8653 South Oxford Street', 482214),
(40, 'TX', 'Houston', 'Butler', 330868),
(41, 'AZ', 'Phoenix', '8667 S. Joy Ridge Court', 316291),
(42, 'AZ', 'Phoenix', 'Torrance', 210392),
(43, 'AZ', 'Phoenix', '35 Harvard St.', 167502),
(44, 'AZ', 'Phoenix', 'Nutley', 327554),
(45, 'AZ', 'Phoenix', '7313 Vermont St.', 285135),
(46, 'AZ', 'Phoenix', 'Lemont', 577667),
(47, 'AZ', 'Phoenix', '8905 Buttonwood Dr.', 212301),
(48, 'AZ', 'Phoenix', 'Lafayette', 317504);



SELECT * FROM house_price

SELECT 
    h1.id,
    h1.state,
    h1.city,
    h1.mkt_price
FROM house_price as h1 
WHERE h1.mkt_price >(
SELECT avg(h2.mkt_price)
from house_price as h2 where h2.city=h1.city
)

--30

/*
-- Amazon Data Analyst Interview Question
You have orders table with columns
order_id, customer_id, order_date, total_amount

Calculate the running total of orders for each
customer. 

Return the customer ID, order date, 
total amount of each order, and the 
cumulative total of orders for each customer
sorted by customer ID and order date.
*/

DROP TABLE IF EXISTS orders;
-- Create table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount FLOAT
);

-- Insert records
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
    (1001, '2024-01-01', 120.25),
    (1002, '2024-01-03', 80.99),
    (1003, '2024-01-05', 160.00),
    (1004, '2024-01-07', 95.50),
    (1001, '2024-02-09', 70.75),
    (1002, '2024-02-11', 220.00),
    (1003, '2024-02-13', 130.50),
    (1004, '2024-02-15', 70.25),
    (1001, '2024-02-17', 60.75),
    (1002, '2024-03-19', 180.99),
    (1003, '2024-03-21', 140.00),
    (1004, '2024-03-23', 110.50),
    (1001, '2024-03-25', 90.25),
    (1002, '2024-03-27', 200.00),
    (1003, '2024-03-29', 160.50),
    (1004, '2024-03-31', 120.75),
    (1001, '2024-03-02', 130.25),
    (1002, '2024-03-04', 90.99),
    (1003, '2024-03-06', 170.00),
    (1004, '2024-04-08', 105.50),
    (1001, '2024-04-10', 80.75),
    (1002, '2024-04-12', 240.00),
    (1003, '2024-04-14', 150.50),
    (1004, '2024-04-16', 80.25),
    (1001, '2024-04-18', 70.75);


SELECT *,
     SUM(total_amount) OVER(PARTITION BY 
    customer_id ORDER BY order_date)
    as running_total
FROM orders
ORDER BY customer_id, order_date

--Find each customer_id and revenue collected from them in each month
SELECT 
    customer_id, 
    DATE_TRUNC('month', order_date) AS order_month, 
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY customer_id, order_month
ORDER BY customer_id, order_month;

