
-- Project 23: University Database System
-- A small database for managing students, courses and enrollments.

-- Create the database tables

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    building VARCHAR(50)
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    birth_date DATE,
    department_id INT,
    enrollment_date DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    credits INT NOT NULL CHECK (credits BETWEEN 1 AND 10),
    department_id INT,

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade NUMERIC(4,2),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE,

    CONSTRAINT unique_student_course
        UNIQUE (student_id, course_id),

    CONSTRAINT valid_grade
        CHECK (grade IS NULL OR grade BETWEEN 0 AND 20)
);

-- Add departments

INSERT INTO departments (department_name, building)
VALUES
    ('Computer Science', 'Block A'),
    ('Mathematics', 'Block B'),
    ('Electronics', 'Block C'),
    ('Physics', 'Block D');

-- Add students

INSERT INTO students
    (first_name, last_name, email, birth_date, department_id)
VALUES
    ('Sara', 'Ahmed', 'sara.ahmed@example.com', '2004-03-12', 1),
    ('Yacine', 'Mansouri', 'yacine.m@example.com', '2003-07-22', 1),
    ('Lina', 'Brahimi', 'lina.b@example.com', '2004-01-05', 2),
    ('Amine', 'Kaci', 'amine.k@example.com', '2003-11-18', 3),
    ('Nour', 'Belkacem', 'nour.b@example.com', '2004-06-30', 2);

-- Add courses

INSERT INTO courses
    (course_name, course_code, credits, department_id)
VALUES
    ('Database Systems', 'CS301', 4, 1),
    ('Data Structures', 'CS302', 4, 1),
    ('Linear Algebra', 'MA201', 3, 2),
    ('Digital Electronics', 'EL301', 4, 3),
    ('Introduction to Physics', 'PH101', 3, 4);

-- Enroll students in courses

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    (1, 1, 16.50),
    (1, 2, 15.00),
    (2, 1, 13.50),
    (2, 2, 17.00),
    (3, 3, 18.00),
    (3, 1, 14.00),
    (4, 4, 12.50),
    (5, 3, 16.00),
    (5, 5, 17.50);

-- 1. Display all students with their departments

SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    s.email,
    d.department_name
FROM students s
LEFT JOIN departments d
    ON s.department_id = d.department_id
ORDER BY s.student_id;

-- 2. Display all available courses

SELECT
    c.course_code,
    c.course_name,
    c.credits,
    d.department_name
FROM courses c
LEFT JOIN departments d
    ON c.department_id = d.department_id
ORDER BY c.course_code;

-- 3. Display each student's enrolled courses and grades

SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
JOIN courses c
    ON e.course_id = c.course_id
ORDER BY s.student_id, c.course_name;

-- 4. Calculate the average grade for each student

SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    ROUND(AVG(e.grade), 2) AS average_grade
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY average_grade DESC;

-- 5. Find students with a grade of at least 16

SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE e.grade >= 16
ORDER BY e.grade DESC;

-- 6. Count the students in each department

SELECT
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s
    ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY student_count DESC;

-- 7. Find courses with no enrollments

SELECT
    c.course_code,
    c.course_name
FROM courses c
LEFT JOIN enrollments e
    ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- 8. Find the highest grade in the university

SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE e.grade = (
    SELECT MAX(grade)
    FROM enrollments
);

-- 9. Update a student's grade

UPDATE enrollments
SET grade = 17.00
WHERE student_id = 1
AND course_id = 1;

-- 10. Display the total number of students, courses and enrollments

SELECT
    (SELECT COUNT(*) FROM students) AS total_students,
    (SELECT COUNT(*) FROM courses) AS total_courses,
    (SELECT COUNT(*) FROM enrollments) AS total_enrollments;
