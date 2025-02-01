--  Question: Create a report of the employee's PRESENT and ABSENT based on their availability

    with emp_cte as (
						SELECT *, 
						row_number() over(partition by employee order by employee,dates) as rn
						from emp_attendance
					 ),
	cte_present as (
	select *, row_number() over(partition by employee order by employee,dates),
	rn - row_number() over(partition by employee order by employee,dates) as flag
	from emp_cte
    where status ='PRESENT'),
	cte_absent as (
	select *, row_number() over(partition by employee order by employee,dates),
	rn - row_number() over(partition by employee order by employee,dates) as flag
	from emp_cte
    where status ='ABSENT')
	select distinct employee
	,first_value(dates) over(partition by employee,flag order by employee,dates) as from_date
	,last_value(dates) over(partition by employee,flag order by employee,dates
							range between unbounded preceding and unbounded following) as to_date
	,status
	from cte_present
	union 
		select distinct employee
	   ,first_value(dates) over(partition by employee,flag order by employee,dates) as from_date
	   ,last_value(dates) over(partition by employee,flag order by employee,dates
							range between unbounded preceding and unbounded following) as to_date
	   ,status
	from cte_absent;
	