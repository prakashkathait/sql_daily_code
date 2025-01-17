/*drop table if exists entries;
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));
*/
/*
insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')
*/
select * from entries;
with resources as (
					select name, count(1) as total_visits, 
					string_agg(distinct resources,',') as resources_used
					from entries
					group by name)
	,most_vist as (
					select name, floor,
					rank() over(partition by name order by count(1) desc) as rnk
					from entries
					group by name,floor
	)
select r.name,mv.floor as most_visited_floor,r.total_visits,r.resources_used
from resources r join most_vist mv on r.name = mv.name 
where mv.rnk = 1;