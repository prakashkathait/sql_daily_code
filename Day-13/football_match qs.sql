/*DROP TABLE IF EXISTS teams;
CREATE TABLE teams 
(
       team_id       INT PRIMARY KEY,
       team_name     VARCHAR(50) NOT NULL
);


DROP TABLE IF EXISTS matches;
CREATE TABLE matches 
(
       match_id 	INT PRIMARY KEY,
       host_team 	INT,
       guest_team 	INT,
       host_goals 	INT,
       guest_goals 	INT
);

INSERT INTO teams VALUES(10, 'Give');
INSERT INTO teams VALUES(20, 'Never');
INSERT INTO teams VALUES(30, 'You');
INSERT INTO teams VALUES(40, 'Up');
INSERT INTO teams VALUES(50, 'Gonna');

INSERT INTO matches VALUES(1, 30, 20, 1, 0);
INSERT INTO matches VALUES(2, 10, 20, 1, 2);
INSERT INTO matches VALUES(3, 20, 50, 2, 2);
INSERT INTO matches VALUES(4, 10, 30, 1, 0);
INSERT INTO matches VALUES(5, 30, 50, 0, 1);
*/

with cte as (
				SELECT *,
				CASE WHEN host_goals>guest_goals then 3 
				     WHEN guest_goals>host_goals then 0
					 else 1 end as team_host_score 
				,CASE WHEN guest_goals>host_goals then 3 
				     WHEN host_goals>guest_goals then 0
					 else 1 end as team_guest_score 
				FROM matches),
		host as (     select host_team, sum(team_host_score) as host_score
					  from cte
					  group by host_team),
		guest as (    select guest_team, sum(team_guest_score) as guest_score
					  from cte
					  group by guest_team)
    select coalesce(host_team,guest_team,t.team_id) as team,
	t.team_name,
	coalesce(host_score,0) + coalesce(guest_score,0) as num_points
	from host h 
	full join guest g on g.guest_team = h.host_team
	right join teams t on t.team_id = coalesce(host_team,guest_team)
	order by num_points desc,team;



