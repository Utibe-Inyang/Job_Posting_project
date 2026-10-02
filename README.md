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

```
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
[What you found. File: 2_top_paying_job_skills.sql]

### 3. Most in-demand skills
[What you found. File: 3_top_demanded_skills.sql]

### 4. Top-paying skills
[What you found. File: 4_top_paying_skills.sql]

### 5. Most optimal skills
[What you found. File: 5_optimal_skills.sql]

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
