/*
Questions: What are the top skills based on salary?
 - Look at the average salary associated with each skill for Data analyst potitions
 - focus on roles with specified salaries, regardless of location
 - Why? it reveals how different skills impact salary levels for data analysts and helps identify 
 the most financial rewarding skills to acquire or improve  
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim USING(job_id)
INNER JOIn skills_dim USING(skill_id)
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;