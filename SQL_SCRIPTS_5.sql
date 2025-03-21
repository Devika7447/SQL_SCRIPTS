--1
-- Create the products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10, 2) NOT NULL
);

-- Create the orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    order_date DATE NOT NULL
);

-- Insert sample products
INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1200.00),
('Smartphone', 'Electronics', 800.00),
('Headphones', 'Electronics', 150.00),
('Coffee Maker', 'Home Appliances', 50.00),
('Blender', 'Home Appliances', 70.00);

-- Insert sample orders
INSERT INTO orders (product_id, quantity, order_date) VALUES
(1, 2, '2023-10-01'),
(2, 3, '2023-10-02'),
(3, 5, '2023-10-03'),
(4, 1, '2023-10-04'),
(5, 2, '2023-10-05'),
(1, 1, '2023-10-06'),
(2, 4, '2023-10-07'),
(3, 2, '2023-10-08');


select * from products
select * from orders

--Total sales revenue
SELECT
    SUM(p.price * o.quantity) AS total_revenue
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id;

--total sales by product
SELECT
    SUM(p.price * o.quantity) AS total_revenue,product_name,
	sum(quantity) as total_quantity
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY product_name
ORDER BY total_revenue

--top selling products
WITH product_sales AS (
    SELECT
        p.product_name,
        SUM(o.quantity) AS total_quantity_sold,
        DENSE_RANK() OVER (ORDER BY SUM(o.quantity) DESC) AS sales_rank
    FROM
        orders o
    JOIN
        products p ON o.product_id = p.product_id
    GROUP BY
        p.product_name
)
SELECT
    product_name,
    total_quantity_sold
FROM
    product_sales
WHERE
    sales_rank <= 3
ORDER BY
    sales_rank;

--or

SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity_sold
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    total_quantity_sold DESC
LIMIT 3;

--sales trend over time
SELECT
    o.order_date,
    SUM(p.price * o.quantity) AS daily_revenue
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY
    o.order_date
ORDER BY
    o.order_date;

--sales by category
SELECT
    SUM(p.price * o.quantity) AS total_revenue,category
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY category
ORDER BY total_revenue

--average order value

SELECT
    AVG(p.price * o.quantity) AS average_order_value
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id;

--monthly sales report
SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(p.price * o.quantity) AS monthly_revenue
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY
    DATE_TRUNC('month', o.order_date)
ORDER BY
    month;

--2

-- Create the employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary NUMERIC(10, 2) NOT NULL
);

-- Create the performance_reviews table
CREATE TABLE performance_reviews (
    review_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    review_date DATE NOT NULL,
    performance_score INT CHECK (performance_score BETWEEN 1 AND 10)
);

select * from employees
select * from performance_reviews
-- Insert sample employees
INSERT INTO employees (first_name, last_name, department, hire_date, salary) VALUES
('John', 'Doe', 'Sales', '2020-01-15', 50000.00),
('Jane', 'Smith', 'Marketing', '2019-05-20', 60000.00),
('Alice', 'Johnson', 'Sales', '2021-03-10', 55000.00),
('Bob', 'Brown', 'Engineering', '2018-11-01', 75000.00),
('Charlie', 'Davis', 'Marketing', '2022-07-05', 65000.00);

-- Insert sample performance reviews
INSERT INTO performance_reviews (employee_id, review_date, performance_score) VALUES
(1, '2023-01-10', 8),
(1, '2023-07-15', 9),
(2, '2023-02-20', 7),
(2, '2023-08-25', 8),
(3, '2023-03-30', 6),
(3, '2023-09-05', 7),
(4, '2023-04-12', 9),
(4, '2023-10-18', 10),
(5, '2023-05-22', 8),
(5, '2023-11-28', 9);

-- Average Performance Score by Employee
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    AVG(pr.performance_score) AS avg_performance_score
FROM
    employees e
JOIN
    performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY
    e.employee_id
ORDER BY
    avg_performance_score DESC;

--Top-Performing Employees

WITH employee_performance AS (
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        AVG(pr.performance_score) AS avg_performance_score,
        DENSE_RANK() OVER (ORDER BY AVG(pr.performance_score) DESC) AS performance_rank
    FROM
        employees e
    JOIN
        performance_reviews pr ON e.employee_id = pr.employee_id
    GROUP BY
        e.employee_id
)
SELECT
    first_name,
    last_name,
    avg_performance_score
FROM
    employee_performance
WHERE
    performance_rank <= 3;
	
-- Average Performance by Department
SELECT
    e.department,
    AVG(pr.performance_score) AS avg_department_score
FROM
    employees e
JOIN
    performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY
    e.department
ORDER BY
    avg_department_score DESC;

-- Employee Tenure

SELECT
    employee_id,
    first_name,
    last_name,
    DATE_PART('year', AGE(NOW(), hire_date)) AS tenure_years
FROM
    employees
ORDER BY
    tenure_years DESC;

--Employees with Performance Improvement
WITH latest_reviews AS (
    SELECT
        employee_id,
        performance_score,
        review_date,
        LAG(performance_score) OVER (PARTITION BY employee_id ORDER BY review_date) AS previous_score
    FROM
        performance_reviews
)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    lr.performance_score AS latest_score,
    lr.previous_score
FROM
    latest_reviews lr
JOIN
    employees e ON lr.employee_id = e.employee_id
WHERE
    lr.performance_score > lr.previous_score;

--Highest Paid Employees by Department

WITH ranked_employees AS (
    SELECT
        employee_id,
        first_name,
        last_name,
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM
        employees
)
SELECT
    first_name,
    last_name,
    department,
    salary
FROM
    ranked_employees
WHERE
    salary_rank = 1;


--3
DROP TABLE IF EXISTS orders;

-- Create the customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE NOT NULL
);

-- Create the orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    order_amount NUMERIC(10, 2) NOT NULL
);

-- Insert sample customers
INSERT INTO customers (first_name, last_name, email, signup_date) VALUES
('John', 'Doe', 'john.doe@example.com', '2022-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', '2022-02-20'),
('Alice', 'Johnson', 'alice.johnson@example.com', '2022-03-10'),
('Bob', 'Brown', 'bob.brown@example.com', '2022-04-01'),
('Charlie', 'Davis', 'charlie.davis@example.com', '2022-05-05');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, order_amount) VALUES
(1, '2022-02-01', 100.00),
(1, '2022-03-15', 150.00),
(2, '2022-03-10', 200.00),
(3, '2022-04-05', 50.00),
(3, '2022-05-10', 75.00),
(4, '2022-06-01', 300.00),
(5, '2022-07-05', 120.00),
(5, '2022-08-10', 80.00),
(5, '2022-09-15', 90.00);

select * from customers
select * from orders
-- Total Spending by Customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.order_amount) AS total_spent
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    total_spent DESC;


-- Number of Orders by Customer
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    total_orders DESC;

-- Average Order Value by Customer

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    AVG(o.order_amount) AS avg_order_value
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    avg_order_value DESC;

-- Customer Segmentation Based on Spending

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.order_amount) AS total_spent,
    CASE
        WHEN SUM(o.order_amount) > 200 THEN 'High Spender'
        WHEN SUM(o.order_amount) BETWEEN 100 AND 200 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_segment
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    total_spent DESC;

--Customer Lifetime Value (CLV)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.order_amount) AS total_spent,
    DATE_PART('month', AGE(NOW(), c.signup_date)) AS months_since_signup,
    CASE
        WHEN DATE_PART('month', AGE(NOW(), c.signup_date)) = 0 THEN SUM(o.order_amount) -- Handle division by 0
        ELSE SUM(o.order_amount) / DATE_PART('month', AGE(NOW(), c.signup_date))
    END AS clv
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    clv DESC;

--repeat customers
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
HAVING
    COUNT(o.order_id) > 1
ORDER BY
    total_orders DESC;

--4
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE air_quality (
    station_id SERIAL PRIMARY KEY,
    city_id INT REFERENCES cities(city_id),
    station_name VARCHAR(100),
    recorded_date DATE,
    pm25 DECIMAL(5,2),
    pm10 DECIMAL(5,2),
    co DECIMAL(5,2),
    no2 DECIMAL(5,2),
    so2 DECIMAL(5,2)
);



INSERT INTO cities (city_name, country) VALUES
('New Delhi', 'India'),
('Beijing', 'China'),
('Los Angeles', 'USA'),
('London', 'UK');

INSERT INTO air_quality (city_id, station_name, recorded_date, pm25, pm10, co, no2, so2) VALUES
(1, 'Delhi Central', '2024-02-01', 150.5, 220.3, 0.9, 45.2, 12.3),
(1, 'Delhi West', '2024-02-01', 140.2, 210.8, 1.1, 42.6, 11.5),
(2, 'Beijing North', '2024-02-01', 160.0, 250.1, 0.8, 50.0, 13.1),
(3, 'LA Downtown', '2024-02-01', 55.5, 80.3, 0.5, 30.2, 7.8),
(4, 'London Central', '2024-02-01', 40.8, 60.4, 0.4, 25.6, 6.2);

select * from cities
select * from air_quality

--Finding the Most Polluted Cities (Based on PM2.5 Levels)
SELECT c.city_name, AVG(a.pm25) AS avg_pm25
FROM air_quality a
JOIN cities c ON a.city_id = c.city_id
GROUP BY c.city_name
ORDER BY avg_pm25 DESC;

--Identifying Stations with the Worst Air Quality
SELECT station_name, pm25, pm10, no2, so2
FROM air_quality
ORDER BY pm25 DESC
LIMIT 5;

--Analyzing Air Pollution Trends Over Time
SELECT recorded_date, AVG(pm25) AS avg_pm25
FROM air_quality
GROUP BY recorded_date
ORDER BY recorded_date;

--Finding Cities Where Air Quality Meets WHO Standards

SELECT c.city_name, AVG(a.pm25) AS avg_pm25
FROM air_quality a
JOIN cities c ON a.city_id = c.city_id
GROUP BY c.city_name
HAVING AVG(a.pm25) < 50;

--5
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(100),
    country VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

CREATE TABLE accidents (
    accident_id SERIAL PRIMARY KEY,
    location_id INT REFERENCES locations(location_id),
    accident_date TIMESTAMP,
    severity VARCHAR(20),  -- ('Minor', 'Serious', 'Fatal')
    vehicles_involved INT,
    cause VARCHAR(255),
    weather_conditions VARCHAR(100),
    road_conditions VARCHAR(100)
);

INSERT INTO locations (city, country, latitude, longitude) VALUES
('New York', 'USA', 40.7128, -74.0060),
('Los Angeles', 'USA', 34.0522, -118.2437),
('London', 'UK', 51.5074, -0.1278),
('Delhi', 'India', 28.7041, 77.1025);

INSERT INTO accidents (location_id, accident_date, severity, vehicles_involved, cause, weather_conditions, road_conditions) VALUES
(1, '2024-02-01 08:30:00', 'Minor', 2, 'Speeding', 'Clear', 'Dry'),
(1, '2024-02-02 18:45:00', 'Serious', 3, 'Drunk Driving', 'Rainy', 'Wet'),
(2, '2024-02-03 07:15:00', 'Fatal', 4, 'Running Red Light', 'Foggy', 'Slippery'),
(3, '2024-02-04 21:00:00', 'Serious', 2, 'Distracted Driving', 'Clear', 'Dry'),
(4, '2024-02-05 09:20:00', 'Minor', 1, 'Reckless Driving', 'Clear', 'Dry');

SELECT * FROM locations
select * from accidents

--Identifying Accident Hotspots (Most Affected Cities)
SELECT l.city, COUNT(a.accident_id) AS total_accidents
FROM accidents a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.city
ORDER BY total_accidents DESC;

--Analyzing Accidents by Severity
SELECT severity, COUNT(accident_id) AS count
FROM accidents
GROUP BY severity
ORDER BY count DESC;

--Finding the Most Common Causes of Accidents
SELECT cause, COUNT(accident_id) AS count
FROM accidents
GROUP BY cause
ORDER BY count DESC
LIMIT 5;

--Accident Trends Over Time (Monthly Analysis)
SELECT DATE_TRUNC('month', accident_date) AS month, COUNT(accident_id) AS total_accidents
FROM accidents
GROUP BY month
ORDER BY month;

--Weather Conditions Impact on Accidents
SELECT weather_conditions, COUNT(accident_id) AS accident_count
FROM accidents
GROUP BY weather_conditions
ORDER BY accident_count DESC;

-- Severity Analysis Based on Road Conditions
SELECT road_conditions, severity, COUNT(accident_id) AS count
FROM accidents
GROUP BY road_conditions, severity
ORDER BY road_conditions, severity;

--Detecting Peak Accident Hours (Using Time Analysis)
SELECT EXTRACT(HOUR FROM accident_date) AS hour, COUNT(accident_id) AS total_accidents
FROM accidents
GROUP BY hour
ORDER BY total_accidents DESC
LIMIT 5;

--Finding Locations with Frequent Fatal Accidents
SELECT l.city, COUNT(a.accident_id) AS fatal_accidents
FROM accidents a
JOIN locations l ON a.location_id = l.location_id
WHERE a.severity = 'Fatal'
GROUP BY l.city
ORDER BY fatal_accidents DESC
LIMIT 5;

--6
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE energy_usage (
    usage_id SERIAL PRIMARY KEY,
    region_id INT REFERENCES regions(region_id),
    sector VARCHAR(50),  -- ('Residential', 'Commercial', 'Industrial', 'Agricultural')
    recorded_date TIMESTAMP,
    energy_consumed_kwh DECIMAL(10,2),  -- Energy consumed in kilowatt-hours (kWh)
    peak_load_mw DECIMAL(10,2) -- Peak load in megawatts (MW)
);

INSERT INTO regions (region_name, country) VALUES
('New York', 'USA'),
('California', 'USA'),
('London', 'UK'),
('Delhi', 'India');

INSERT INTO energy_usage (region_id, sector, recorded_date, energy_consumed_kwh, peak_load_mw) VALUES
(1, 'Residential', '2024-02-01 08:00:00', 5000.50, 250.30),
(1, 'Industrial', '2024-02-01 12:00:00', 15000.75, 600.50),
(2, 'Commercial', '2024-02-01 18:00:00', 8000.40, 350.80),
(3, 'Residential', '2024-02-02 07:00:00', 6000.20, 275.40),
(4, 'Agricultural', '2024-02-02 22:00:00', 4000.80, 180.60);

--Identifying Regions with the Highest Energy Consumption
SELECT r.region_name, SUM(e.energy_consumed_kwh) AS total_energy
FROM energy_usage e
JOIN regions r ON e.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_energy DESC;

--Peak Load Analysis (Time of Day with Highest Demand)
SELECT EXTRACT(HOUR FROM recorded_date) AS hour, AVG(peak_load_mw) AS avg_peak_load
FROM energy_usage
GROUP BY hour
ORDER BY avg_peak_load DESC
LIMIT 5;

-- Energy Consumption by Sector

SELECT sector, SUM(energy_consumed_kwh) AS total_consumption
FROM energy_usage
GROUP BY sector
ORDER BY total_consumption DESC;

-- Monthly Energy Usage Trends
SELECT DATE_TRUNC('month', recorded_date) AS month, SUM(energy_consumed_kwh) AS total_energy
FROM energy_usage
GROUP BY month
ORDER BY month;

--Identifying Energy Inefficiencies (High Load but Low Consumption)
SELECT region_name, sector, energy_consumed_kwh, peak_load_mw
FROM energy_usage e
JOIN regions r ON e.region_id = r.region_id
WHERE peak_load_mw > 500 AND energy_consumed_kwh < 5000;

--Detecting Seasonal Trends in Energy Usage
SELECT EXTRACT(MONTH FROM recorded_date) AS month, 
       AVG(energy_consumed_kwh) AS avg_energy_consumed
FROM energy_usage
GROUP BY month
ORDER BY avg_energy_consumed DESC;









