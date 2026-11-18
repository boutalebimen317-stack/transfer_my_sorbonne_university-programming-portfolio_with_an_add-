
-- Project 24: Recruitment Database System
-- Managing companies, job offers, candidates and applications.

DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS companies;

-- 1. Companies

CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    industry VARCHAR(80)
);

-- 2. Job offers

CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    company_id INT NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    job_type VARCHAR(30) NOT NULL,
    salary NUMERIC(10,2) CHECK (salary >= 0),
    posted_date DATE DEFAULT CURRENT_DATE,
    job_status VARCHAR(20) DEFAULT 'Open',

    FOREIGN KEY (company_id)
        REFERENCES companies(company_id)
        ON DELETE CASCADE,

    CHECK (job_type IN ('Full-time', 'Part-time', 'Internship')),
    CHECK (job_status IN ('Open', 'Closed'))
);

-- 3. Candidates

CREATE TABLE candidates (
    candidate_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(25),
    education VARCHAR(100),
    experience_years INT DEFAULT 0 CHECK (experience_years >= 0)
);

-- 4. Applications

CREATE TABLE applications (
    application_id SERIAL PRIMARY KEY,
    candidate_id INT NOT NULL,
    job_id INT NOT NULL,
    application_date DATE DEFAULT CURRENT_DATE,
    application_status VARCHAR(30) DEFAULT 'Pending',

    FOREIGN KEY (candidate_id)
        REFERENCES candidates(candidate_id)
        ON DELETE CASCADE,

    FOREIGN KEY (job_id)
        REFERENCES jobs(job_id)
        ON DELETE CASCADE,

    UNIQUE (candidate_id, job_id),

    CHECK (
        application_status IN (
            'Pending',
            'Under Review',
            'Accepted',
            'Rejected'
        )
    )
);

-- Insert companies

INSERT INTO companies (company_name, location, industry)
VALUES
    ('Tech Solutions', 'Algiers', 'Information Technology'),
    ('Digital Future', 'Oran', 'Software Development'),
    ('Smart Systems', 'Constantine', 'Artificial Intelligence');

-- Insert job offers

INSERT INTO jobs
    (company_id, job_title, job_type, salary, job_status)
VALUES
    (1, 'Junior Python Developer', 'Full-time', 65000, 'Open'),
    (1, 'Database Assistant', 'Internship', 25000, 'Open'),
    (2, 'Frontend Developer', 'Full-time', 70000, 'Open'),
    (2, 'Web Development Intern', 'Internship', 20000, 'Closed'),
    (3, 'AI Research Assistant', 'Part-time', 55000, 'Open');

-- Insert candidates

INSERT INTO candidates
    (first_name, last_name, email, phone, education, experience_years)
VALUES
    ('Imane', 'Boutaleb', 'imane@example.com', '0550000001',
     'Computer Science', 1),

    ('Sara', 'Mansouri', 'sara@example.com', '0550000002',
     'Software Engineering', 2),

    ('Yacine', 'Kaci', 'yacine@example.com', '0550000003',
     'Computer Science', 0),

    ('Lina', 'Brahimi', 'lina@example.com', '0550000004',
     'Artificial Intelligence', 1),

    ('Amine', 'Ahmed', 'amine@example.com', '0550000005',
     'Information Systems', 3);

-- Insert applications

INSERT INTO applications
    (candidate_id, job_id, application_status)
VALUES
    (1, 1, 'Under Review'),
    (1, 2, 'Pending'),
    (2, 1, 'Accepted'),
    (2, 3, 'Pending'),
    (3, 2, 'Rejected'),
    (3, 3, 'Under Review'),
    (4, 5, 'Accepted'),
    (5, 1, 'Pending');

-- ------------------------------------------
-- RECRUITMENT REPORTS AND QUERIES
-- ------------------------------------------

-- 1. Display all available job offers with company names

SELECT
    j.job_id,
    j.job_title,
    j.job_type,
    j.salary,
    c.company_name
FROM jobs j
JOIN companies c
    ON j.company_id = c.company_id
WHERE j.job_status = 'Open'
ORDER BY j.salary DESC;

-- 2. Display all candidates

SELECT *
FROM candidates
ORDER BY last_name;

-- 3. Display applications with candidate and job information

SELECT
    a.application_id,
    c.first_name || ' ' || c.last_name AS candidate_name,
    j.job_title,
    co.company_name,
    a.application_status,
    a.application_date
FROM applications a
JOIN candidates c
    ON a.candidate_id = c.candidate_id
JOIN jobs j
    ON a.job_id = j.job_id
JOIN companies co
    ON j.company_id = co.company_id
ORDER BY a.application_id;

-- 4. Count applications for each job

SELECT
    j.job_title,
    COUNT(a.application_id) AS application_count
FROM jobs j
LEFT JOIN applications a
    ON j.job_id = a.job_id
GROUP BY j.job_id, j.job_title
ORDER BY application_count DESC;

-- 5. Display accepted applications

SELECT
    c.first_name,
    c.last_name,
    j.job_title,
    co.company_name
FROM applications a
JOIN candidates c
    ON a.candidate_id = c.candidate_id
JOIN jobs j
    ON a.job_id = j.job_id
JOIN companies co
    ON j.company_id = co.company_id
WHERE a.application_status = 'Accepted';

-- 6. Calculate the average salary of available jobs

SELECT
    ROUND(AVG(salary), 2) AS average_salary
FROM jobs
WHERE job_status = 'Open';

-- 7. Find candidates with at least two applications

SELECT
    c.candidate_id,
    c.first_name,
    c.last_name,
    COUNT(a.application_id) AS total_applications
FROM candidates c
JOIN applications a
    ON c.candidate_id = a.candidate_id
GROUP BY c.candidate_id, c.first_name, c.last_name
HAVING COUNT(a.application_id) >= 2;

-- 8. Count applications by status

SELECT
    application_status,
    COUNT(*) AS total
FROM applications
GROUP BY application_status
ORDER BY total DESC;

-- 9. Update an application status

UPDATE applications
SET application_status = 'Accepted'
WHERE application_id = 1;

-- 10. Display companies and their number of job offers

SELECT
    c.company_name,
    COUNT(j.job_id) AS total_jobs
FROM companies c
LEFT JOIN jobs j
    ON c.company_id = j.company_id
GROUP BY c.company_id, c.company_name
ORDER BY total_jobs DESC;

-- 11. Find candidates who have not applied for any job

SELECT
    c.candidate_id,
    c.first_name,
    c.last_name
FROM candidates c
LEFT JOIN applications a
    ON c.candidate_id = a.candidate_id
WHERE a.application_id IS NULL;

-- 12. Display the complete recruitment statistics

SELECT
    (SELECT COUNT(*) FROM companies) AS total_companies,
    (SELECT COUNT(*) FROM jobs) AS total_jobs,
    (SELECT COUNT(*) FROM candidates) AS total_candidates,
    (SELECT COUNT(*) FROM applications) AS total_applications;
