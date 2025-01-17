/*
drop table if exists players;
create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

drop table if exists matches;
create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);*/

-- Problem : Finding the maximum score in each groups if there is a same score scored by the players then 
-- select the lowest playerid.
-- solution ::

with players_cte as (
					select first_player as players_id, first_score as score from matches
					union all
					select second_player as players_id, second_score as score from matches),
	score_cte as (
					select players_id, sum(score) as tot_score from players_cte
					group by players_id),
	group_cte as (
					select sc.players_id as players_id,p.group_id,sum(tot_score) as total_score,
					rank() over(partition by p.group_id order by sum(tot_score) desc, sc.players_id asc) as rn
					FROM score_cte sc join players p on sc.players_id = p.player_id
					group by sc.players_id , p.group_id
					)
				select players_id,group_id,total_score from group_cte 
				where rn=1;


