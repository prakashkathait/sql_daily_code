Question:
Compare the total number of comments made by users in each country between December 2019 and January 2020. 
For each month, rank countries by total comments using dense ranking (i.e., avoid gaps between ranks) in descending order.
Then, return the names of the countries whose rank improved from December to January.

-- Solution:

with total_comments as (
select date_trunc('month',cc.created_at)::date as created_on,
        country,sum(number_of_comments) as tot_comm
from fb_comments_count cc 
join fb_active_users au on cc.user_id = au.user_id
where cc.created_at >= '2019-12-01'
    and cc.created_at < '2020-02-01'
group by date_trunc('month',cc.created_at)::date,country
),
december_com as (
select country,
        tot_comm,
    dense_rank() over(order by tot_comm desc) as dec_rnk
from total_comments 
where created_on ='2019-12-01'
),
january_com as (
select country,
        tot_comm,
    dense_rank() over(order by tot_comm desc) as jan_rnk
from total_comments 
where created_on = '2020-01-01'
)
select distinct jc.country
from january_com jc JOIN december_com dc on jc.country = dc.country
where dec_rnk > jan_rnk;

