/*
Question: what are the most in-demand skills for data analyst?
- join job postings to inner table similar to query 2
- identify the top 5 in-demand skilsl for a data analyst
- focus on all job postings.
- Why? retrieves the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skilsl for job seekers.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim USING(job_id)
INNER JOIn skills_dim USING(skill_id)
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = 
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;