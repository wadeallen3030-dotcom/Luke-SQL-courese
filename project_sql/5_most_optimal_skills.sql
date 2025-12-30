/*
Questions: waht are the most optimal skills to learn?
- identify skills in high demand and associate with high average salaries for data analyst roles
= concenrates on remote position with specified salaries
- Why? Target skills that offer job security and financial benefits, offering strategic insights for carrer development
*/

WITH skills_demand AS(
    SELECT 
        skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim USING(job_id)
    INNER JOIn skills_dim USING(skill_id)
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skill_id, skills
)
,
average_salary AS(
    SELECT 
        skill_id,
        skills,
        ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim USING(job_id)
    INNER JOIn skills_dim USING(skill_id)
    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY skill_id, skills
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary USING(skill_id)
WHERE demand_count > 10 
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25
;