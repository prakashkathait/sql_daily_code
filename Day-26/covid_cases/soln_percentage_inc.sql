with cases_cte as (
					select extract(month from dates) as reported_month,
					sum(cases_reported) as monthly_cases
					from covid_cases
					group by extract(month from dates)
), cumm_cte as (
select reported_month,monthly_cases,
sum(monthly_cases) over(order by reported_month) as cumm_cases 
from cases_cte)
select *, 
case when reported_month > 1 
                          then cast(round((monthly_cases/lag(cumm_cases) over(order by reported_month))*100,1) as varchar)
					else '-' end as percentage_increase
		from cumm_cte;