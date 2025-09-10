/*
Maximum Number of Employees Reached

Write a query that returns every employee that has ever worked for the company. 
For each employee, calculate the greatest number of employees that worked for the company 
during their tenure and the first date that number was reached. 
The termination date of an employee should not be counted as a working day.


Your output should have the employee ID, greatest number of employees that worked for the company
during the employee's tenure, and first date that number was reached.
*/

-- solution 

with events_date as
(
select hire_date as event_date from uber_employees
UNION 
select termination_date as event_date from uber_employees
ORDER BY 1
),
event_counts as (
select event_date, count(*) as no_of_emp 
from events_date JOIN uber_employees 
ON event_date >= hire_date
AND event_date < COALESCE(termination_date,CURRENT_DATE)
GROUP BY event_date
)
SELECT id,no_of_emp AS maxemp,event_date
FROM (
select id,no_of_emp,event_date,
RANK() OVER(PARTITION BY id ORDER BY no_of_emp DESC,event_date ASC) as rn
from event_counts ec  
JOIN uber_employees ub 
ON ec.event_date >= hire_date
AND ec.event_date < COALESCE(ub.termination_date,CURRENT_DATE)
    ) emp
WHERE rn = 1
ORDER BY 1;