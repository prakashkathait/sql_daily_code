/*drop table if exists customer_orders;

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;
*/

1) Find the new and repeated customers ?

with first_order as (   select customer_id, min(order_date) as first_order_dt
						from customer_orders
						group by customer_id
						order by first_order_dt)
select c.order_date, 
sum(case when f.first_order_dt = c.order_date then 1 else 0 end) as first_order_count,
sum(case when f.first_order_dt != c.order_date then 1 else 0 end) as repeat_order_count,
sum(case when f.first_order_dt = c.order_date then order_amount else 0 end) as first_order_amnt,
sum(case when f.first_order_dt != c.order_date then order_amount else 0 end) as repeat_order_amnt
from first_order f join 
customer_orders c on f.customer_id = c.customer_id
group by c.order_date
order by c.order_date;