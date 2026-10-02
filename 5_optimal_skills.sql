 /*What are the most optimal skills to learn?
  * OPTIMAL: High demand AND high paying
  * - Create CTEs for 3_top_demanded_skills and 4_top_paying_skills
  * - Concentrate with remote positions with specified salaries
  * Why? Targets skills that offer job security (hih demand) and financial benefits (high salaries),
  * offering strategic insights for career development in data analysis
  */
 
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