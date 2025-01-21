/*drop table if exists salary;
create table salary
(
	emp_id		int,
	emp_name	varchar(30),
	base_salary	int
);
insert into salary values(1, 'Rohan', 5000);
insert into salary values(2, 'Alex', 6000);
insert into salary values(3, 'Maryam', 7000);


drop table if exists income;
create table income
(
	id			int,
	income		varchar(20),
	percentage	int
);
insert into income values(1,'Basic', 100);
insert into income values(2,'Allowance', 4);
insert into income values(3,'Others', 6);


drop table if exists deduction;
create table deduction
(
	id			int,
	deduction	varchar(20),
	percentage	int
);
insert into deduction values(1,'Insurance', 5);
insert into deduction values(2,'Health', 6);
insert into deduction values(3,'House', 4);
*/

select * from salary;
select * from income;
select * from deduction;


drop table if exists emp_transaction;
create table emp_transaction
(
  emp_id  int,
  emp_name varchar(50),
  trans_type varchar(20),
  amount numeric 
);

insert into emp_transaction
select s.emp_id, s.emp_name,x.trans_type, 
case when x.trans_type = 'Allowance' then round(s.base_salary*(percentage/100),2)
	when x.trans_type = 'Basic' then round(s.base_salary*(percentage/100),2)
	when x.trans_type = 'Health' then round(s.base_salary*(percentage/100),2)
	when x.trans_type = 'House' then round(s.base_salary*(percentage/100),2)
	when x.trans_type = 'Insurance' then round(s.base_salary*(percentage/100),2)
	when x.trans_type = 'Others' then round(s.base_salary*(percentage/100),2) end as amount
from salary s
cross join (	select income as trans_type ,cast(percentage as decimal) from income
				union 
				select deduction as trans_type ,cast(percentage as decimal) from deduction) x;


-- Creating the report of the above transaction

create extension tablefunc;

select employee, 
basic,allowance,others,
(basic+allowance+others) as gross_amount,
insurance, health , house 
,(insurance + health + house ) as total_deductions
, (basic + allowance + others) - (insurance+health+house) as net_pay
from crosstab('select emp_name,trans_type,amount    -- this is the base query
				from emp_transaction
				order by emp_name, trans_type',
				'select distinct trans_type from emp_transaction order by trans_type'  -- this is the req col)
	as result (employee varchar, allowance numeric, basic numeric, health numeric,
				house numeric, insurance numeric, others numeric);
