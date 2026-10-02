/*You are an aspiring data analyst looking to analyze the top paying roles and skills
		 * You will create SQL queries to explore this large dataset specific to you
		 * QUESTIONS TO ANSWER:
		 * 1) What are the top paying jobs for my role?
		 * 2) What are the skills  required for these top paying role?
		 * 3) What are the most in-demand skills for my role?
		 * 4) What are the top skills based on salary for my role?
		 * 5) What are the most optimal skills to learn?
		 * - OPTIMAL: High demand AND high paying
		 * 
		 * QUERY 1 QUESTION: What are the top paying opportunities for Data Analysts, offering insights into employment options and location flexibility
		 * - Identify the top highest paying Data Analyst roles that are available remotely
		 * - Focus on job postings with specified salaries (remove nulls)
		 * - Why? Aims to highlight the top paying oppotunities for Data Analysts, offering insights into employment options and location flexibility
		 */
		


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
