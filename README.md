# Data Job Market Analysis with SQL

## Introduction
This project uses SQL to explore the data job market, focusing on which roles pay the most, which skills are in demand, and which skills are worth learning.
It uncovers the most optimal skills to learn as a Data Enthusiast based on real time data science job posting data.

## Results
The most optimal skills were determined by developing a metric called "Skill Multiplier" that sums both the normalized demand and normalized salary of a given skill for a job title into a single metric

Checkout the queries: [sql project](Queries/)

## Background
I built this project with SQL. The data comes from Luke Barousse's job postings dataset, which contains real job listings with titles, salaries, locations, and required skills.
Data source: [dataset](https://lukebarousse.com/sql)

### The questions I wanted to answer were:
1. What are the top-paying jobs?
2. What skills do those top-paying jobs require?
3. What are the most in-demand skills?
4. Which skills are linked to the highest salaries?
5. Which skills are the most optimal to learn?

## Tools I Used
- **SQL:** for querying the data
- **PostgreSQL:** The database management system
- **DBeaver:** for writing and running my queries
- **Git and GitHub:** for sharing my work

## Analysis
Each query in this repository answers one question.

### 1. Top-paying Data Analyst job
Identify the top highest paying Data Analyst roles that are available remotely
Focus on job postings with specified salaries (remove nulls)
Why? Aims to highlight the top paying oppotunities for Data Analysts, offering insights into employment options and location flexibility

```sql
select 	job_id,
		job_title,
		job_location,
		job_schedule_type,
		salary_year_avg,
		job_posted_date,
		name AS company_name
from job_postings_fact 
left join company_dim on job_postings_fact.company_id = company_dim.company_id 
where job_title_short = 'Data Analyst' 
and job_location = 'Anywhere'
and salary_year_avg is not null
order by salary_year_avg desc
limit 10
```

### 2. Skills for top-paying jobs

```sql
with top_paying_jobs as (
select 	job_id,
		job_title,
		salary_year_avg,
		name AS company_name
from job_postings_fact 
left join company_dim on job_postings_fact.company_id = company_dim.company_id 
where job_title_short = 'Data Analyst' 
and job_location = 'Anywhere'
and salary_year_avg is not null
order by salary_year_avg desc
limit 10
)
select top_paying_jobs.*,
		skills 
from top_paying_jobs 
inner join skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id 
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id 
order by salary_year_avg desc
```
### Insight: 
Here is the breakdown of the most demanded skills for data analytics in 2023, based on job postings:
 * SQL leads with a count of 8
 * Python follows with 7
 * Tableau follows with 6
 * Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

### 3. Most in-demand skills
What are the most in-demand skills for data analysts?
 * Join job postings to inner join table similar to query 2
 * Identify the top 5 in-demand skills for a data analyst.
 * Focus on all job postings.
 * Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.

```sql
select skills,
		count(skills_job_dim.job_id) as demand_count
from job_postings_fact 
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id 
where job_title_short = 'Data Analyst' and job_work_from_home is true	
group by skills 	
order by demand_count desc 
limit 5
```

### 4. Top-paying skills
What are the top skills based on salary?
 * Look at the average salary associated with each skill for Data Analyst positions
 * Focuses on roles with specified salaries, regardless of location
 * Why? It reveals how different skills impact salary levels for Data Analysts and helps 
 * identify the most financially rewarding skills to acquire or improve
   
```sql
select skills,
		round (AVG(salary_year_avg), 0) as avg_salary
from job_postings_fact 
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id 
where job_title_short = 'Data Analyst' and salary_year_avg is not null
and job_work_from_home is true	
group by skills 	
order by avg_salary desc 
limit 20
```

### INSIGHTS:
 * High Demand for big data and ML skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), ML tools (DataRobot, Jupyter), and Python libraries (Panda, Numpy), reflecting the industry's high valuation of data processing and predictive modeling capabilities

 * Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLap, Kubernates, Airflow) indicates a lucrative crossover b/w data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management
   
 * Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics

   
### 5. Most optimal skills
OPTIMAL: High demand AND high paying
  * Create CTEs for 3_top_demanded_skills and 4_top_paying_skills
  * Concentrate with remote positions with specified salaries
  * Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis

```sql 
 with skills_demand as (
 select skills_dim.skills,
 		skills_dim.skill_id,
		count(skills_job_dim.job_id) as demand_count
from job_postings_fact 
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id 
where job_title_short = 'Data Analyst' and job_work_from_home is true
and salary_year_avg is not null
group by skills_dim.skill_id
), average_salary as (
select skills_job_dim.skill_id,
		round (AVG(job_postings_fact.salary_year_avg), 0) as avg_salary
from job_postings_fact 
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id 
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id 
where job_title_short = 'Data Analyst' and salary_year_avg is not null
and job_work_from_home is true	
group by skills_job_dim.skill_id 
)
select skills_demand.skill_id,
		skills_demand.skills,
		demand_count,
		avg_salary
from skills_demand
inner join average_salary on skills_demand.skill_id = average_salary.skill_id
where demand_count >10
		--job_title_short = 'Data Analyst'
		--and salary_year_avg is not null 
		--and job_work_from_home = true
--group by skills_dim.skill_id
--having count (skills_job_dim.job_id) > 10
order by demand_count desc, 
		 demand_count desc
limit 25
```

## What I Learned
- [A SQL skill you picked up, for example joins, aggregate functions, or CTEs]
- [Something about working with real data]
- [Something you'd do differently next time]

## Insights
- [Your biggest finding]
- [A second finding]
- [Your overall takeaway about which skills to learn]

## Conclusion
[2-3 sentences summing up what the project showed and what you plan to do next.]
