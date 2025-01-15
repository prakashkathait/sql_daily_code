/*create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');
*/

select * from icc_world_cup;

-- solution 1:

with team as (
				select team_1 as team_name, 
				case when team_1 = winner then 1 else 0 end as win_flag
				from icc_world_cup
				union all
				select team_2 as team_name, 
				case when team_2 = winner then 1 else 0 end as win_flag
				from icc_world_cup
), 
match_details as (
select team_name, count(1) as match_played, sum(win_flag) as tot_winning from team 
group by team_name)
select *,(match_played - tot_winning) as loss_match
from match_details; 

-- solution 2: 

select team_name,count(1) as no_of_matches_played, sum(win_flag) as no_of_matches_won,
	count(1)-sum(win_flag) as no_of_losses
		from(			select team_1 as team_name, 
						case when team_1 = winner then 1 else 0 end as win_flag
						from icc_world_cup
						union all
						select team_2 as team_name, 
						case when team_2 = winner then 1 else 0 end as win_flag
						from icc_world_cup) A 
GROUP BY team_name
order by no_of_matches_won desc;
				

