-- Find out the employees who attended all compan events

select * from employees;
select distinct event_name from events;
-- solution :

select emp.name , count(distinct event_name) as event_attended
from events ev 
JOIN employees emp on ev.emp_id = emp.id
group by emp.name
having count(distinct event_name) = (select count(distinct event_name) from events);