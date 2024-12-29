/*drop table if exists entries;
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')
*/
with distinct_resources as (
							select distinct name, resources from entries),
		agg_resources as (select name,string_agg(resources,',') as used_resources
		                  from distinct_resources	
						  group by name),
			total_visits as (select name,count(1) as total_visits,
							string_agg(resources,',') as resources_used
							from entries 
							group by name),
			floor_rank as (
							select name,floor,count(1) as no_of_visits,
							rank() over(partition by name order by count(1) desc) as rn 
							from entries
							group by name,floor)
					select fr.name,tv.total_visits,fr.floor as most_visited_floor,
					ar.used_resources
					from floor_rank fr
					inner join total_visits tv on fr.name = tv.name 
					inner join agg_resources ar on ar.name = fr.name
					where rn = 1
					order by most_visited_floor;
					










