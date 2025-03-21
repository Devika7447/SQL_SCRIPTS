/*
Complex Queries In SQL
1)	Recursive Common Table Expressions (CTEs): Used for hierarchical data
2)	Window Functions: Useful for running totals, ranking, moving averages, etc.
3)	Pivoting Data (crosstab) : Used to convert rows into columns, typically for reporting and summarization.
4)	JSONB Queries (Handling Semi-Structured Data) : Used to store, query, and manipulate semi-structured JSON data within PostgreSQL.
5)	Using Lateral Joins (For Correlated Subqueries) : Used for correlated subqueries where each row in the main query can reference subquery results.
6)	Full-Text Search : Used for efficient text-based searches in large documents, product descriptions, and logs.
7)	Partitioned Queries for Large Datasets : Used for querying massive datasets efficiently by storing data in separate partitions.
8)	Time-Series Analysis with Generate_series() : Used to fill in missing time intervals when working with time-series data.
9)	Using ARRAY Data Type : Used to store and manipulate multiple values in a single column, useful for tags, labels, and multi-valued attributes.
10)	Dynamic SQL Execution with PL/pgSQL : Used to execute dynamically generated SQL queries inside stored procedures and functions.
11)	Materialized Views for Performance Optimization : Used to store precomputed query results for faster access and improved performance.
12)	Row-Level Security (RLS) with Policies : Used for restricting access to specific rows in a table based on user roles.
13)	Foreign Data Wrappers (FDW) for External Data Access : Used to query and integrate external databases (e.g., PostgreSQL, MySQL, APIs) within PostgreSQL.
14)	Indexing Tricks for Performance : Used to speed up queries through techniques like partial indexes, GIN indexes, and covering indexes.
15)	Parallel Query Execution : Used to improve performance of large queries by leveraging multiple CPU cores.
16)	Event Triggers for Auditing Changes : Used to log schema changes automatically, useful for database audits and monitoring.
17)	Conditional Aggregation with FILTER : Used for applying conditions within aggregate functions to get more detailed insights.
18)	Temporal Queries with RANGE and INTERVA L : Used to find overlapping time periods in scheduling, bookings, and event management.
19)	Graph Queries using Recursive CTEs : Used to find relationships between nodes, such as shortest paths in networks.
20)	Data Masking for Sensitive Information : Used to protect personal or confidential data while keeping it readable for analysis.




*/

-- Employees Table (HR Management)
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT REFERENCES employees(id),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE
);

-- Sales Table (Revenue & Transactions)
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    amount NUMERIC(10,2),
    sales_rep_id INT REFERENCES employees(id)
);

-- Customers Table (Customer Insights)
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email TEXT,
    phone TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    preferences JSONB
);

-- Products Table (Product Catalog)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    stock_level INT
);

-- Insert Employees
INSERT INTO employees (name, manager_id, department, salary, hire_date) VALUES
('Alice', NULL, 'Management', 100000, '2020-01-01'),
('Bob', 1, 'Sales', 70000, '2021-03-15'),
('Charlie', 1, 'Engineering', 80000, '2022-05-10'),
('Dave', 2, 'Sales', 50000, '2023-06-20');

-- Insert Customers
INSERT INTO customers (name, email, phone, preferences) VALUES
('John Doe', 'john@example.com', '1234567890', '{"favorite_category": "Electronics"}'),
('Jane Smith', 'jane@example.com', '9876543210', '{"favorite_category": "Books"}');

-- Insert Products
INSERT INTO products (name, category, price, stock_level) VALUES
('Laptop', 'Electronics', 1500, 10),
('Book: AI Basics', 'Books', 30, 50);

-- Insert Sales
INSERT INTO sales (customer_id, product_id, sale_date, amount, sales_rep_id) VALUES
(1, 1, '2024-02-01', 1500, 2),
(2, 2, '2024-02-02', 30, 2);

-- Recursive CTE: Employee Hierarchy
WITH RECURSIVE employee_hierarchy AS (
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT * FROM employee_hierarchy ORDER BY level;

--Window Functions: Sales Performance

SELECT sales_rep_id, 
       SUM(amount) AS total_sales,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM sales
GROUP BY sales_rep_id;

--Pivoting Data: Monthly Sales Report
SELECT 
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(CASE WHEN product_id = 1 THEN amount ELSE 0 END) AS laptop_sales,
    SUM(CASE WHEN product_id = 2 THEN amount ELSE 0 END) AS book_sales
FROM sales
GROUP BY month;

--JSONB Queries: Find Customers Interested in Electronics
SELECT name, email FROM customers
WHERE preferences->>'favorite_category' = 'Electronics';

-- Lateral Joins: Latest Purchase Per Customer
SELECT c.id, c.name, latest_purchase.amount, latest_purchase.sale_date
FROM customers c
LEFT JOIN LATERAL (
    SELECT amount, sale_date FROM sales
    WHERE sales.customer_id = c.id
    ORDER BY sale_date DESC LIMIT 1
) latest_purchase ON true;

-- Full-Text Search: Find a Product by Name
SELECT * FROM products
WHERE to_tsvector(name) @@ to_tsquery('Laptop');

--Partitioned Sales Table for Performance
CREATE TABLE sales_partitioned (
    id SERIAL,
    customer_id INT,
    product_id INT,
    sale_date DATE NOT NULL,
    amount NUMERIC(10,2),
    sales_rep_id INT
) PARTITION BY RANGE (sale_date);

CREATE TABLE sales_2024_01 PARTITION OF sales_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

--Time-Series Analysis: Filling Missing Sales Dates
SELECT d::DATE AS day, COALESCE(SUM(s.amount), 0) AS total_sales
FROM generate_series('2024-01-01'::DATE, '2024-02-01'::DATE, '1 day'::INTERVAL) d
LEFT JOIN sales s ON s.sale_date = d
GROUP BY d;

--Data Masking: Hide Customer Phone Numbers
SELECT name, LEFT(phone, 3) || '****' AS masked_phone FROM customers;

-- Optimizations & Security
--  Indexing for Faster Queries
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_customers_email ON customers(email);

--Row-Level Security: Restrict Access to Own Sales
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;

CREATE POLICY sales_rep_policy ON sales
USING (sales_rep_id = current_user::INTEGER);

--Movie Streaming Analytics

-- Create Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    signup_date DATE
);

-- Create Movies Table
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    genre VARCHAR(50),
    release_year INT,
    metadata JSONB -- Stores additional attributes (IMDB rating, director)
);

-- Create Watch History Table
drop table if exists watch_history
CREATE TABLE watch_history (
    history_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    movie_id INT REFERENCES movies(movie_id),
    watch_date DATE
);

-- Create Subscriptions Table
drop table if exists subscriptions
CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    plan VARCHAR(50), -- 'Basic', 'Standard', 'Premium'
    amount NUMERIC(10,2),
    start_date DATE,
    end_date DATE
);

-- Insert Users
INSERT INTO users (name, email, signup_date) VALUES 
('Alice', 'alice@mail.com', '2024-01-01'),
('Bob', 'bob@mail.com', '2024-02-05'),
('Charlie', 'charlie@mail.com', '2024-03-10');

-- Insert Movies
INSERT INTO movies (title, genre, release_year, metadata) VALUES
('Inception', 'Sci-Fi', 2010, '{"IMDB": 8.8, "Director": "Christopher Nolan"}'),
('Avengers', 'Action', 2012, '{"IMDB": 8.0, "Director": "Joss Whedon"}'),
('Titanic', 'Romance', 1997, '{"IMDB": 7.8, "Director": "James Cameron"}');

-- Insert Watch History
INSERT INTO watch_history (user_id, movie_id, watch_date) VALUES
(1, 1, '2024-02-10'),
(1, 2, '2024-02-12'),
(2, 3, '2024-02-15'),
(3, 1, '2024-02-20');

-- Insert Subscriptions
INSERT INTO subscriptions (user_id, plan, amount, start_date, end_date) VALUES
(1, 'Premium', 15.99, '2024-01-01', '2024-02-01'),
(2, 'Standard', 12.99, '2024-02-05', '2024-03-05'),
(3, 'Basic', 9.99, '2024-03-10', '2024-04-10');

--Find Popular Movies (Most Watched)
SELECT m.title, COUNT(w.history_id) AS total_views
FROM watch_history w
JOIN movies m ON w.movie_id = m.movie_id
GROUP BY m.title
ORDER BY total_views DESC
LIMIT 5;

-- Monthly Subscription Revenue
SELECT 
    EXTRACT(MONTH FROM start_date) AS month,
    SUM(amount) AS total_revenue
FROM subscriptions
GROUP BY month
ORDER BY month;

--Find the First Movie Each User Watched (Lateral Join)
SELECT u.user_id, u.name, first_watch.*
FROM users u
LEFT JOIN LATERAL (
    SELECT m.title, w.watch_date
    FROM watch_history w
    JOIN movies m ON w.movie_id = m.movie_id
    WHERE w.user_id = u.user_id
    ORDER BY w.watch_date ASC LIMIT 1
) first_watch ON true;

-- Running Total of Subscription Revenue (Window Functions)
SELECT 
    start_date,
    SUM(amount) OVER (ORDER BY start_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM subscriptions;

--Search Movies by Title (Full-Text Search)
SELECT * FROM movies
WHERE to_tsvector(title) @@ to_tsquery('Inception');

-- Index Optimization for Fast Searches
CREATE INDEX idx_movies_title ON movies USING gin(to_tsvector('english', title));

-- Detect Duplicate Users (Data Cleaning)
SELECT name, email, COUNT(*) 
FROM users 
GROUP BY name, email
HAVING COUNT(*) > 1;
--Performance Optimization
-- Index on Watch History for Faster Queries
CREATE INDEX idx_watch_history_date ON watch_history(watch_date);
--Index for Fast User Lookups
CREATE INDEX idx_users_email ON users(email);

--Find Users Who Subscribed But Never Watched a Movie
SELECT u.user_id, u.name
FROM users u
LEFT JOIN watch_history w ON u.user_id = w.user_id
WHERE w.history_id IS NULL;

--Rank Movies by Popularity (Dense Rank)
SELECT title, COUNT(w.history_id) AS total_views, 
       DENSE_RANK() OVER (ORDER BY COUNT(w.history_id) DESC) AS popularity_rank
FROM movies m
JOIN watch_history w ON m.movie_id = w.movie_id
GROUP BY m.title;

--Percentage of Each Genre Watched (Window Function)
SELECT genre, 
       COUNT(*) AS total_watches, 
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM movies m
JOIN watch_history w ON m.movie_id = w.movie_id
GROUP BY genre
ORDER BY total_watches DESC;

--Get the Most Expensive Product in Each Category
SELECT category, name, price
FROM (
    SELECT category, name, price, 
           RANK() OVER (PARTITION BY category ORDER BY price DESC) AS rank
    FROM products
) ranked_products
WHERE rank = 1;










