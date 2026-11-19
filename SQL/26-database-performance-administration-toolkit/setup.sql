
-- Project 26: Database Performance and Administration Toolkit
-- PostgreSQL performance monitoring and optimization.

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Customers table

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    city VARCHAR(80),
    registration_date DATE DEFAULT CURRENT_DATE
);

-- Products table

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(80),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0)
);

-- Orders table

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    order_status VARCHAR(30) DEFAULT 'Pending',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CHECK (
        order_status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')
    )
);

-- Sample customers

INSERT INTO customers
    (first_name, last_name, email, city)
VALUES
    ('Sara', 'Mansouri', 'sara@example.com', 'Algiers'),
    ('Yacine', 'Kaci', 'yacine@example.com', 'Oran'),
    ('Lina', 'Brahimi', 'lina@example.com', 'Mascara'),
    ('Amine', 'Ahmed', 'amine@example.com', 'Constantine'),
    ('Nour', 'Belkacem', 'nour@example.com', 'Algiers');

-- Sample products

INSERT INTO products
    (product_name, category, price, stock_quantity)
VALUES
    ('Laptop', 'Electronics', 125000, 10),
    ('Keyboard', 'Accessories', 4500, 25),
    ('Mouse', 'Accessories', 2200, 40),
    ('Monitor', 'Electronics', 38000, 8),
    ('Headphones', 'Accessories', 6500, 15);

-- Sample orders

INSERT INTO orders
    (customer_id, product_id, quantity, total_amount, order_status)
VALUES
    (1, 1, 1, 125000, 'Delivered'),
    (1, 2, 2, 9000, 'Shipped'),
    (2, 3, 1, 2200, 'Pending'),
    (3, 4, 1, 38000, 'Delivered'),
    (4, 5, 2, 13000, 'Pending'),
    (5, 2, 1, 4500, 'Cancelled'),
    (2, 1, 1, 125000, 'Shipped'),
    (3, 3, 3, 6600, 'Delivered');

-- -----------------------------------------
-- PERFORMANCE ANALYSIS
-- -----------------------------------------

-- 1. Display the database size

SELECT
    current_database() AS database_name,
    pg_size_pretty(
        pg_database_size(current_database())
    ) AS database_size;

-- 2. Display the size of each table

SELECT
    tablename,
    pg_size_pretty(
        pg_total_relation_size(
            schemaname || '.' || tablename
        )
    ) AS total_size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(
    schemaname || '.' || tablename
) DESC;

-- 3. Examine a query execution plan

EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 2;

-- 4. Examine execution plan with actual runtime

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE customer_id = 2;

-- -----------------------------------------
-- INDEX OPTIMIZATION
-- -----------------------------------------

-- 5. Create indexes for frequently searched columns

CREATE INDEX IF NOT EXISTS idx_orders_customer
ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_date
ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_products_category
ON products(category);

CREATE INDEX IF NOT EXISTS idx_customers_city
ON customers(city);

-- 6. Search orders using an indexed column

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM orders
WHERE customer_id = 2;

-- 7. List all indexes in the current schema

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- -----------------------------------------
-- DATABASE STATISTICS
-- -----------------------------------------

-- 8. Inspect table activity statistics

SELECT
    relname AS table_name,
    seq_scan,
    idx_scan,
    n_live_tup AS estimated_rows,
    n_dead_tup AS dead_rows
FROM pg_stat_user_tables
ORDER BY relname;

-- 9. Find the most frequently accessed tables
-- according to recorded table scans

SELECT
    relname AS table_name,
    seq_scan,
    idx_scan,
    seq_tup_read,
    idx_tup_fetch
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;

-- 10. Display the number of records in each table

SELECT 'customers' AS table_name, COUNT(*) AS total
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders;

-- -----------------------------------------
-- BUSINESS QUERIES
-- -----------------------------------------

-- 11. Calculate total sales

SELECT
    SUM(total_amount) AS total_sales
FROM orders
WHERE order_status <> 'Cancelled';

-- 12. Find the best-selling products

SELECT
    p.product_name,
    SUM(o.quantity) AS units_sold
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
WHERE o.order_status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

-- 13. Display customers and their total spending

SELECT
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spending DESC;

-- 14. Find products with low stock

SELECT
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < 10
ORDER BY stock_quantity;

-- -----------------------------------------
-- MAINTENANCE
-- -----------------------------------------

-- 15. Update planner statistics

ANALYZE customers;
ANALYZE products;
ANALYZE orders;

-- 16. Clean up dead tuples and reclaim reusable space

VACUUM (ANALYZE) customers;
VACUUM (ANALYZE) products;
VACUUM (ANALYZE) orders;

-- 17. Check table statistics after maintenance

SELECT
    relname AS table_name,
    n_live_tup,
    n_dead_tup,
    last_analyze,
    last_vacuum
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY relname;
