
-- Let's see all the students first
SELECT *
FROM university_system.students;


-- Students with their department names
SELECT
    s.full_name,
    s.email,
    d.department_name
FROM university_system.students AS s
JOIN university_system.departments AS d
    ON s.department_id = d.department_id;


-- Courses and their departments
SELECT
    c.course_name,
    c.credits,
    d.department_name
FROM university_system.courses AS c
JOIN university_system.departments AS d
    ON c.department_id = d.department_id;


-- Who is taking which course?
SELECT
    s.full_name,
    c.course_name,
    e.grade
FROM university_system.enrollments AS e
JOIN university_system.students AS s
    ON e.student_id = s.student_id
JOIN university_system.courses AS c
    ON e.course_id = c.course_id;


-- Average grade for each student
SELECT
    s.full_name,
    ROUND(AVG(e.grade), 2) AS average_grade
FROM university_system.students AS s
JOIN university_system.enrollments AS e
    ON s.student_id = e.student_id
GROUP BY s.student_id, s.full_name;


-- How many students are in each department?
SELECT
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM university_system.departments AS d
LEFT JOIN university_system.students AS s
    ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;


-- Find students with a grade above 15
SELECT
    s.full_name,
    c.course_name,
    e.grade
FROM university_system.enrollments AS e
JOIN university_system.students AS s
    ON e.student_id = s.student_id
JOIN university_system.courses AS c
    ON e.course_id = c.course_id
WHERE e.grade > 15
ORDER BY e.grade DESC;


-- Update a student's grade
UPDATE university_system.enrollments
SET grade = 19
WHERE student_id = 3 AND course_id = 1;


-- Check the updated grade
SELECT *
FROM university_system.enrollments
WHERE student_id = 3 AND course_id = 1;
