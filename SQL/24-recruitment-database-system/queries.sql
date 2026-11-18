
-- All available job offers
SELECT *
FROM recruitment.jobs;


-- Let's see which company posted each job
SELECT
    j.job_title,
    c.company_name,
    c.location,
    j.salary,
    j.job_type
FROM recruitment.jobs AS j
JOIN recruitment.companies AS c
    ON j.company_id = c.company_id;


-- Candidates and their applications
SELECT
    c.full_name,
    c.main_skill,
    j.job_title,
    a.status
FROM recruitment.applications AS a
JOIN recruitment.candidates AS c
    ON a.candidate_id = c.candidate_id
JOIN recruitment.jobs AS j
    ON a.job_id = j.job_id;


-- Find candidates who know Python
SELECT *
FROM recruitment.candidates
WHERE main_skill = 'Python';


-- Applications waiting for a decision
SELECT
    c.full_name,
    j.job_title,
    a.application_date
FROM recruitment.applications AS a
JOIN recruitment.candidates AS c
    ON a.candidate_id = c.candidate_id
JOIN recruitment.jobs AS j
    ON a.job_id = j.job_id
WHERE a.status = 'Pending';


-- Count applications for each job
SELECT
    j.job_title,
    COUNT(a.application_id) AS number_of_applications
FROM recruitment.jobs AS j
LEFT JOIN recruitment.applications AS a
    ON j.job_id = a.job_id
GROUP BY j.job_id, j.job_title;


-- Find the average salary
SELECT ROUND(AVG(salary), 2) AS average_salary
FROM recruitment.jobs;


-- Update an application after an interview
UPDATE recruitment.applications
SET status = 'Accepted'
WHERE candidate_id = 2 AND job_id = 2;


-- Check accepted applications
SELECT
    c.full_name,
    j.job_title,
    a.status
FROM recruitment.applications AS a
JOIN recruitment.candidates AS c
    ON a.candidate_id = c.candidate_id
JOIN recruitment.jobs AS j
    ON a.job_id = j.job_id
WHERE a.status = 'Accepted';
