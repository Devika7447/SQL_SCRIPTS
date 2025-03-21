--Vendors and Sales Management Project
- Create vendors table
CREATE TABLE vendors (
    vendor_id SERIAL PRIMARY KEY,
    vendor_name TEXT,
    country TEXT
);

-- Create products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    price DECIMAL(10,2),
    tax_rate DECIMAL(5,2)  -- Tax rate as a percentage (e.g., 10.00 for 10%)
);

-- Create sales table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    vendor_id INT REFERENCES vendors(vendor_id),
    product_id INT REFERENCES products(product_id),
    sale_date DATE,
    quantity INT,
    total_price DECIMAL(10,2),
    tax_amount DECIMAL(10,2)
);

-- Insert vendors
INSERT INTO vendors (vendor_name, country) VALUES 
('Tech Solutions', 'USA'),
('Global Traders', 'UK'),
('EcoMart', 'Canada');

-- Insert products
INSERT INTO products (product_name, category, price, tax_rate) VALUES 
('Laptop', 'Electronics', 1200.00, 8.00),
('Office Chair', 'Furniture', 300.00, 5.00),
('Smartphone', 'Electronics', 900.00, 10.00);

-- Insert sales transactions
INSERT INTO sales (vendor_id, product_id, sale_date, quantity, total_price, tax_amount) VALUES 
(1, 1, '2024-02-01', 2, 2400.00, 192.00),  -- (8% tax on $2400)
(2, 2, '2024-02-05', 3, 900.00, 45.00),   -- (5% tax on $900)
(3, 3, '2024-02-10', 1, 900.00, 90.00),   -- (10% tax on $900)
(1, 3, '2024-02-12', 2, 1800.00, 180.00); -- (10% tax on $1800)

--Total Tax Collected Per Vendor
SELECT v.vendor_name, SUM(s.tax_amount) AS total_tax_collected
FROM sales s
JOIN vendors v ON s.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY total_tax_collected DESC;

--Total Sales Revenue Per Vendor

select * from vendors
select * from sales
select * from products

SELECT v.vendor_name, SUM(s.total_price) AS total_sales_revenue 
FROM sales s
JOIN vendors v ON s.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY total_sales_revenue DESC;

--Top-Selling Products

SELECT *
FROM (
    SELECT p.product_id, p.product_name, s.sale_id, s.total_price, 
           DENSE_RANK() OVER (PARTITION BY p.product_name ORDER BY SUM(s.total_price) DESC) AS dr
    FROM products AS p
    JOIN sales AS s ON p.product_id = s.product_id
    GROUP BY p.product_id, p.product_name, s.sale_id, s.total_price
) AS subquery
WHERE dr = 1;

--OR

SELECT p.product_name, SUM(s.quantity) AS total_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

--Monthly Tax Collection Trends
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year, 
    EXTRACT(MONTH FROM sale_date) AS month, 
    SUM(tax_amount) AS total_tax_collected
FROM sales
GROUP BY year, month
ORDER BY year, month;

-- Logistics & Delivery Tracking Project

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Deliveries (
    delivery_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    delivery_date DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Pending', 'In Transit', 'Delivered', 'Cancelled')),
    delivery_cost DECIMAL(10,2) NOT NULL
);

CREATE TABLE Delivery_Items (
    item_id SERIAL PRIMARY KEY,
    delivery_id INT REFERENCES Deliveries(delivery_id),
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    weight DECIMAL(5,2) NOT NULL
);

INSERT INTO Customers (customer_name, address, city, country) VALUES
('John Doe', '123 Maple St', 'New York', 'USA'),
('Jane Smith', '456 Oak St', 'Los Angeles', 'USA'),
('Carlos Ruiz', '789 Pine St', 'Madrid', 'Spain'),
('Marie Curie', '321 Elm St', 'Paris', 'France'),
('Hiro Tanaka', '654 Cedar St', 'Tokyo', 'Japan'),
('Anna Schmidt', '987 Birch St', 'Berlin', 'Germany'),
('Liam OConnor', '741 Spruce St', 'Dublin', 'Ireland'),
('Chen Wei', '852 Bamboo St', 'Beijing', 'China'),
('Fatima Hassan', '369 Palm St', 'Dubai', 'UAE'),
('Pablo Gonzalez', '159 Cypress St', 'Buenos Aires', 'Argentina');

INSERT INTO Deliveries (customer_id, delivery_date, status, delivery_cost) VALUES
(1, '2024-01-10', 'Delivered', 25.00),
(2, '2024-01-15', 'In Transit', 30.00),
(3, '2024-01-20', 'Pending', 20.00),
(4, '2024-02-05', 'Delivered', 50.00),
(5, '2024-02-10', 'Cancelled', 0.00),
(6, '2024-02-15', 'Delivered', 40.00),
(7, '2024-02-20', 'Pending', 35.00),
(8, '2024-02-25', 'In Transit', 45.00),
(9, '2024-03-01', 'Delivered', 55.00),
(10, '2024-03-05', 'Pending', 60.00);

INSERT INTO Delivery_Items (delivery_id, product_name, quantity, weight) VALUES
(1, 'Laptop', 1, 2.50),
(2, 'Monitor', 1, 5.00),
(3, 'Mouse', 2, 0.50),
(4, 'Keyboard', 1, 1.20),
(5, 'Printer', 1, 6.50),
(6, 'Hard Drive', 2, 1.00),
(7, 'USB Drive', 5, 0.20),
(8, 'Graphics Card', 1, 1.50),
(9, 'Motherboard', 1, 3.00),
(10, 'Webcam', 3, 0.75);

-- 1. Total deliveries per status
SELECT status, COUNT(*) AS total_deliveries
FROM Deliveries
GROUP BY status;

-- 2. Total delivery cost per customer
SELECT c.customer_name, SUM(d.delivery_cost) AS total_cost
FROM Deliveries d
JOIN Customers c ON d.customer_id = c.customer_id
GROUP BY c.customer_name;

-- 3. Average weight per delivery
SELECT d.delivery_id, AVG(di.weight) AS avg_weight
FROM Delivery_Items di
JOIN Deliveries d ON di.delivery_id = d.delivery_id
GROUP BY d.delivery_id;

-- 4. Most frequently delivered products
SELECT product_name, COUNT(*) AS total_delivered
FROM Delivery_Items
GROUP BY product_name
ORDER BY total_delivered DESC;

-- 5. Latest delivery per customer
SELECT c.customer_name, MAX(d.delivery_date) AS last_delivery
FROM Deliveries d
JOIN Customers c ON d.customer_id = c.customer_id
GROUP BY c.customer_name;

-- 6. Deliveries sorted by cost
SELECT * FROM Deliveries ORDER BY delivery_cost DESC;

-- 7. Pending and in-transit deliveries
SELECT * FROM Deliveries WHERE status IN ('Pending', 'In Transit');

--8 Customers with their total deliveries and last delivery date
SELECT c.customer_name, COUNT(d.delivery_id) AS total_deliveries, MAX(d.delivery_date) AS last_delivery
FROM Deliveries d
JOIN Customers c ON d.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_deliveries DESC;


--Advanced Inventory & Supplier Management Project
DROP TABLE IF EXISTS Suppliers CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    supplier_id INT REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL
);

INSERT INTO Suppliers (supplier_name, contact_person, phone, country) VALUES
('Tech Supplies Inc.', 'John Doe', '+1-555-1234', 'USA'),
('Office Solutions Ltd.', 'Jane Smith', '+44-555-5678', 'UK'),
('Global Parts Co.', 'Carlos Ruiz', '+34-555-8765', 'Spain'),
('Metro Components', 'Marie Curie', '+33-555-4321', 'France'),
('Nippon Electronics', 'Hiro Tanaka', '+81-555-6789', 'Japan'),
('EuroTech GmbH', 'Anna Schmidt', '+49-555-2468', 'Germany'),
('GreenEnergy Supplies', 'Liam OConnor', '+353-555-1357', 'Ireland'),
('Shenzhen Tech', 'Chen Wei', '+86-555-8642', 'China'),
('Dubai Solutions', 'Fatima Hassan', '+971-555-9753', 'UAE'),
('Buenos Aires Supplies', 'Pablo Gonzalez', '+54-555-7531', 'Argentina');

INSERT INTO Products (product_name, category, price, stock_quantity, supplier_id) VALUES
('Laptop', 'Electronics', 1200.00, 50, 1),
('Monitor', 'Electronics', 300.00, 80, 2),
('Mouse', 'Accessories', 25.00, 200, 3),
('Keyboard', 'Accessories', 45.00, 150, 4),
('Printer', 'Office Equipment', 150.00, 60, 5),
('Hard Drive', 'Storage', 90.00, 100, 6),
('USB Drive', 'Storage', 15.00, 500, 7),
('Graphics Card', 'Hardware', 500.00, 40, 8),
('Motherboard', 'Hardware', 250.00, 70, 9),
('Webcam', 'Accessories', 80.00, 120, 10);

INSERT INTO Orders (product_id, order_date, quantity, total_cost) VALUES
(1, '2024-01-10', 2, 2400.00),
(2, '2024-01-15', 3, 900.00),
(3, '2024-01-20', 5, 125.00),
(4, '2024-02-05', 4, 180.00),
(5, '2024-02-10', 1, 150.00),
(6, '2024-02-15', 6, 540.00),
(7, '2024-02-20', 10, 150.00),
(8, '2024-02-25', 2, 1000.00),
(9, '2024-03-01', 3, 750.00),
(10, '2024-03-05', 5, 400.00);

-- 1. Total stock available per category
SELECT category, SUM(stock_quantity) AS total_stock
FROM Products
GROUP BY category;

-- 2. Total order value per supplier
SELECT s.supplier_name, SUM(o.total_cost) AS total_order_value
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
JOIN Suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name;

-- 3. Average price of products per category
SELECT category, AVG(price) AS avg_price
FROM Products
GROUP BY category;

-- 4. Top-selling products (by quantity ordered)
SELECT p.product_name, SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- 5. Most profitable supplier (by order value)
SELECT s.supplier_name, SUM(o.total_cost) AS total_profit
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
JOIN Suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_profit DESC;

-- 6. Products with low stock (below threshold of 50)
SELECT product_name, stock_quantity
FROM Products
WHERE stock_quantity < 50
ORDER BY stock_quantity ASC;

-- 7. Monthly revenue from orders
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month, SUM(total_cost) AS monthly_revenue
FROM Orders
GROUP BY month
ORDER BY month;

-- 8. Suppliers with the most product variety
SELECT s.supplier_name, COUNT(p.product_id) AS total_products
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_products DESC;

--Advanced Retail Sales & Customer Insights Project
-- Database Schema

DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Sales CASCADE;
DROP TABLE IF EXISTS Returns CASCADE;
DROP TABLE IF EXISTS Discounts CASCADE;

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE Sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    product_id INT REFERENCES Products(product_id),
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

CREATE TABLE Returns (
    return_id SERIAL PRIMARY KEY,
    sale_id INT REFERENCES Sales(sale_id),
    return_date DATE NOT NULL,
    reason TEXT NOT NULL
);

CREATE TABLE Discounts (
    discount_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    discount_percentage DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Insert Sample Data
INSERT INTO Customers (customer_name, email, phone, city, country) VALUES
('Alice Johnson', 'alice@example.com', '+1-555-1234', 'New York', 'USA'),
('Bob Smith', 'bob@example.com', '+44-555-5678', 'London', 'UK'),
('Charlie Brown', 'charlie@example.com', '+34-555-8765', 'Madrid', 'Spain');

INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
('Smartphone', 'Electronics', 699.00, 100),
('Headphones', 'Accessories', 99.00, 200),
('Gaming Console', 'Electronics', 499.00, 50);

INSERT INTO Sales (customer_id, product_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2024-01-10', 1, 699.00),
(2, 2, '2024-01-15', 2, 198.00),
(3, 3, '2024-01-20', 1, 499.00);

INSERT INTO Returns (sale_id, return_date, reason) VALUES
(2, '2024-01-18', 'Defective product');

INSERT INTO Discounts (product_id, discount_percentage, start_date, end_date) VALUES
(1, 10.00, '2024-02-01', '2024-02-10'),
(2, 15.00, '2024-02-05', '2024-02-15');


-- 1. Total sales per product
SELECT p.product_name, SUM(s.total_amount) AS total_sales
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- 2. Monthly sales trends
SELECT TO_CHAR(s.sale_date, 'YYYY-MM') AS month, SUM(s.total_amount) AS total_revenue
FROM Sales s
GROUP BY month
ORDER BY month;

-- 3. Customers with the highest spending
SELECT c.customer_name, SUM(s.total_amount) AS total_spent
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 4. Percentage of sales affected by returns
SELECT (COUNT(r.return_id)::DECIMAL / COUNT(s.sale_id) * 100) AS return_rate
FROM Sales s
LEFT JOIN Returns r ON s.sale_id = r.sale_id;

-- 5. Products with active discounts
SELECT p.product_name, d.discount_percentage
FROM Discounts d
JOIN Products p ON d.product_id = p.product_id
WHERE CURRENT_DATE BETWEEN d.start_date AND d.end_date;

-- 6. Average order value per customer
SELECT c.customer_name, AVG(s.total_amount) AS avg_order_value
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name;

-- 7. Best-selling product category
SELECT p.category, SUM(s.total_amount) AS total_sales
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 8. Products most frequently returned
SELECT p.product_name, COUNT(r.return_id) AS total_returns
FROM Returns r
JOIN Sales s ON r.sale_id = s.sale_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_returns DESC;
