/* -- Problem Statement: IPL Winning Streak
Given table has details of every IPL 2023 matches. Identify the maximum winning streak for each team. 
Additional test cases: 
1) Update the dataset such that when Chennai Super Kings win match no 17, your query shows the updated streak.
2) Update the dataset such that Royal Challengers Bangalore loose all match and your query should populate the winning streak as 0
*/

with cte_teams as (
					select home_team as teams from ipl_results
					union 
					select away_team as teams from ipl_results),
	cte as (
			select 
			dates,concat(home_team,'Vs',away_team) as match,teams,result,
			row_number() over(partition by teams order by teams,dates) as id
			from cte_teams ct 
			join ipl_results i on ct.teams = i.home_team or ct.teams = i.away_team
	),
	cte_diff as (
	select *,
	id - row_number() over(partition by teams order by teams,dates) as diff
	from cte
	where result = teams),
	cte_final as (
					select *, count(1) over(partition by teams,diff order by teams,dates
											range between unbounded preceding and unbounded following) as streak
					from cte_diff
	)
	select teams,max(streak) as max_winning_streak
	from cte_final
	group by teams 
	order by max_winning_streak desc;