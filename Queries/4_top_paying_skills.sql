/*QUESTION:
 * What are the top skills based on salary?
 * - Look at the average salary associated with each skill for Data Analyst positions
 * - Focuses on roles with specified salaries, regardless of location
 * Why? It reveals how different skills impact salary levels for Data Analysts and helps 
 * identify the most financially rewarding skills to acquire or improve
 */

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


/*INSIGHTS:
 *1) High Demand for big data and ML skills: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase),
 *ML tools (DataRobot, Jupyter), and Python libraries (Panda, Numpy), reflecting the industry's high valuation of data processing and 
 *predictive modeling capabilities
 * 
 * 2) Software Development & Deployment Proficiency: Knowledge in development and deployment tools (GitLap, Kubernates, Airflow) indicates 
 * a lucrative crossover b/w data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline 
 * management
 * 
 * 3) Cloud Computing Expertise: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing 
 * importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics
 */
