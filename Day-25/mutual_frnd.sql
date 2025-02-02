-- Problem: Finding the mutual friends for the given pairs 
-- Solution: 
with friend_cte as (
					select friend1,friend2 from Friends
					union all 
					select friend2,friend1 from Friends
)
select f.friend1,f.friend2, count(fc.friend2) as mutual_friends 
from Friends f 
LEFT JOIN friend_cte fc on f.friend1 = fc.friend1
and fc.friend2 in ( select fc2.friend2
					  from friend_cte fc2
					  where fc2.friend1 = f.friend2)
group by f.friend1,f.friend2
order by 1;
