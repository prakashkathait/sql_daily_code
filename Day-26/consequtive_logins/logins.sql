with group_cte as (
					select * 
					, dense_rank() over(partition by user_id order by login_date) as order_no
					, login_date - cast(dense_rank() over(partition by user_id 
																order by user_id , login_date) as int)
					  as date_group
					from user_login)
		select user_id,min(login_date) as start_date, max(login_date) as end_date
		,(max(login_date) - min(login_date))+1 as consequtive_dates
		from group_cte
		group by user_id,date_group
		having (max(login_date) - min(login_date))+1 >=5;