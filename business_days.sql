/*drop table if exists tickets;

create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
delete from tickets;
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);
delete from holidays;
insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day'); */

-- ques: Find the number of actual days and business days between the dates where the ticket is being resolved.

select ticket_id,create_date,resolved_date,
(resolved_date - create_date) as actual_days,
(business_days - no_of_holiday) as actual_business_days
from (
select ticket_id,create_Date,resolved_date,count(holiday_date) as no_of_holiday,
((resolved_date - create_date)) - 2*(((resolved_date - create_date)/7)) as business_days
from tickets 
left join holidays on holiday_date between create_date and resolved_date
group by ticket_id,create_date,resolved_date
order by ticket_id
) a 