/*
create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);


insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English'); */

-- find the companies who have atleast 2 users who speaks English and German both the language.

with cte as (
select company_id,user_id,count(language) from company_users
where language in ('English','German')
group by company_id,user_id
having count(language) >1 
)
select company_id from cte
group by company_id
having count(user_id) >= 2;

-- solution 2 : using the subquery 

select company_id, count(1)
from (
select company_id,user_id,count(language) from company_users
where language in ('English','German')
group by company_id,user_id
having count(language) >1 ) a 
group by company_id 
having count(1)>=2;