# Introduction
This project focus on data analysts roles on the job market, diving into top paying jobs, top demand skills, and where high demand meets high salary.

You can check out all the SQL queries in the "project_sql" folder.

# Background
This is a project demonstration after following all the course prvided by Luke Barousse. The main questions for this projects are as follows:
- What are the top - paying jobs for data analyst
- WHat are the stkills required for these top paying roles
- What are the most in-demand skills
- What are the top skills based on salary
- What are the most optimal skills to learn
  
# Tools I used
To complete this project I used the following tools:

- SQL
- PostgreSQL
- Visual Studio Code
- Git & Github

# The analysis
To tackle the questions, I broke it down to the following steps:

1. Filter for specific role, location
```
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
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
LIMIT 10;
``` 

2. Using CTE and join to find target columns (title, skills, company and yearly average salary in this case)
```
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
```
3. Finding top demanding skills
```
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim USING(job_id)
INNER JOIn skills_dim USING(skill_id)
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

4. Matching top demanding skills with average salary
```
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
```

5. Puttig everything together to find the optimal skills to learn
```
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
```

# What I learned
- Query crafting: This could be a fun and hard at the same time as I'll need to think through logics of how to join tables, finding the column I neede and output the desired resutl.
- Porject: It's fulfiling to see that I'm able to complete something brick by brick then come up with a complete image at the end, and my skills could be improved along the way.
  
# Conclusion

### Insights:
It'd appear that core data analyst skills include the followings
- SQL (100%) is universal.
- Python (87.5%) is almost universal.
- Tableau (75%) is the dominant BI/dashboard tool in this set.
- R (50%) is still present, but clearly less universal than Python.
In these high-paying postings, the most consistent trio is SQL + Python + Tableau.

In addition, it'd appear that when communicating finding to stakeholders, even at high salaries, “classic” business tooling remains relevant such as Excel.
