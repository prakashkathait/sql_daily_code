-- Find the median ages of countries

with cte as (
select country,age,
row_number() over(partition by country order by age) as rn,
cast(count(id) over(partition by country order by age
				range between unbounded preceding and unbounded following) as decimal) as ppl_age
from people)
select country,age
from cte 
where rn >= (ppl_age/2) and rn <= (ppl_age/2 + 1)
;