
-- Project 25: Database Maintenance and Backup System
-- PostgreSQL database administration practice.

DROP TABLE IF EXISTS system_logs;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Create departments

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- Create employees

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    salary NUMERIC(10,2) CHECK (salary >= 0),
    department_id INT,
    hire_date DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
);

-- Create a simple maintenance log

CREATE TABLE system_logs (
    log_id SERIAL PRIMARY KEY,
    action_name VARCHAR(100) NOT NULL,
    details TEXT,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample departments

INSERT INTO departments (department_name, location)
VALUES
    ('IT', 'Algiers'),
    ('Human Resources', 'Oran'),
    ('Finance', 'Constantine'),
    ('Marketing', 'Mascara');

-- Sample employees

INSERT INTO employees
    (first_name, last_name, email, salary, department_id, hire_date)
VALUES
    ('Sara', 'Mansouri', 'sara@example.com', 75000, 1, '2023-02-10'),
    ('Yacine', 'Kaci', 'yacine@example.com', 68000, 1, '2024-01-15'),
    ('Lina', 'Brahimi', 'lina@example.com', 55000, 2, '2022-06-20'),
    ('Amine', 'Ahmed', 'amine@example.com', 62000, 3, '2023-09-05'),
    ('Nour', 'Belkacem', 'nour@example.com', 50000, 4, '2024-03-12');

-- Record the initial setup

INSERT INTO system_logs (action_name, details)
VALUES
    ('DATABASE_SETUP', 'Created tables and inserted sample records');

-- -----------------------------------------
-- MAINTENANCE AND MONITORING QUERIES
-- -----------------------------------------

-- 1. Display all employees

SELECT *
FROM employees
ORDER BY employee_id;

-- 2. Count employees in each department

SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY employee_count DESC;

-- 3. Display the total salary expense

SELECT
    SUM(salary) AS total_salary_expense,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees;

-- 4. Find employees with salaries above the average

SELECT
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;

-- 5. Find employees who have been working
-- for more than two years

SELECT
    first_name,
    last_name,
    hire_date
FROM employees
WHERE hire_date < CURRENT_DATE - INTERVAL '2 years';

-- 6. Inspect table sizes

SELECT
    tablename,
    pg_size_pretty(
        pg_total_relation_size(
            schemaname || '.' || tablename
        )
    ) AS total_size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- 7. Inspect database size

SELECT
    current_database() AS database_name,
    pg_size_pretty(
        pg_database_size(current_database())
    ) AS database_size;

-- 8. Inspect table row estimates

SELECT
    relname AS table_name,
    n_live_tup AS estimated_rows,
    n_dead_tup AS dead_rows
FROM pg_stat_user_tables
ORDER BY relname;

-- 9. Find indexes in the current schema

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- 10. Create an index for employee email searches

CREATE INDEX IF NOT EXISTS idx_employees_email
ON employees(email);

-- 11. Record a maintenance action

INSERT INTO system_logs (action_name, details)
VALUES
    ('INDEX_CREATED', 'Created an index on employees.email');

-- 12. Display maintenance logs

SELECT *
FROM system_logs
ORDER BY log_date DESC;

-- 13. Remove employees with a salary below a chosen amount
-- This is a demonstration. Run only if you want to delete those rows.

-- DELETE FROM employees
-- WHERE salary < 40000;

-- 14. Record a maintenance summary

INSERT INTO system_logs (action_name, details)
VALUES
    ('MAINTENANCE_CHECK', 'Completed database inspection queries');

-- 15. Display the final employee count

SELECT
    COUNT(*) AS total_employees
FROM employees;
