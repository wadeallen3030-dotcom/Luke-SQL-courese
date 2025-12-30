/*
Question: what skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying data analyst jobs from first query
- Add the specific skilsl required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop
    that align with top salaries.
*/
WITH top_paying_jobs AS (
SELECT 
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim 
USING(company_id)
WHERE  
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND  
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
)

SELECT 
    tpj.*,
    skills
FROM top_paying_jobs tpj
INNER JOIN skills_job_dim USING(job_id)
INNER JOIn skills_dim USING(skill_id)
ORDER BY
    salary_year_avg DESC

-- 1) Core data analyst baseline
-- SQL (100%) is universal.
-- Python (87.5%) is almost universal.
-- Tableau (75%) is the dominant BI/dashboard tool in this set.
-- R (50%) is still present, but clearly less universal than Python.
-- Insight: In these high-paying postings, the most consistent trio is SQL + Python + Tableau.

-- 3) Productivity + stakeholder communication
-- Excel (37.5%)
-- Power BI (25%)
-- PowerPoint (12.5%)
-- Insight: Even at high salaries, “classic” business tooling remains relevant, especially for director/insight roles.