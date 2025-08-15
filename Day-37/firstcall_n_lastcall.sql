/* 
There is a phonelog table that has the information about callers call history.
write a SQL to find out callers whose first and last call was to the same person on a given day 

create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled timestamp
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');
*/

-- solution1 :

with cte as (
select *,date(datecalled) as date,
first_value(recipientid) over(partition by date(datecalled) order by datecalled) as firstcall	
,row_number() over(partition by date(datecalled) order by datecalled) as sl
from phonelog
) 
select callerid,recipientid,datecalled from cte 
where firstcall = recipientid and sl = (select max(sl) from cte);



-- solution2:

with cte as (
select callerid,date(datecalled) as date, min(datecalled) as first_call,max(datecalled) as last_call
from phonelog
group by callerid,date(datecalled)
order by callerid
) 
select c.*,p1.recipientid as recipientid
from cte c 
join phonelog p1 on c.callerid = p1.callerid and c.first_call = p1.datecalled
join phonelog p2 on c.callerid = p2.callerid and c.last_call =  p2.datecalled
where p1.recipientid = p2.recipientid;




