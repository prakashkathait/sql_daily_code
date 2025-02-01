-- Solution 1

select generate_series(min(serial_no),max(serial_no)) as number_series
from invoice
except
select serial_no from invoice;

-- Solution 2:

with recursive cte as (
						select min(serial_no) as n from invoice 
						union 
						select (n+1) as n
						from cte 
						where n < (select max(serial_no) from invoice)
						)
select * from cte
except 
select serial_no from invoice;