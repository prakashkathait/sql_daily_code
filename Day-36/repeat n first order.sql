/*
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

-- question : find the count of repeat customers & new customers 
-- solution: 

with first_order_cte as (
						select customer_id,min(order_date) as first_order_date from customer_orders
						group by customer_id
                       )
select o.order_date , 
sum(case when fo.first_order_date = o.order_date then 1 else 0 end) as first_order_flag,
sum(case when fo.first_order_date != o.order_date then 1 else 0 end) as repeat_order_flag,
sum(case when fo.first_order_date = o.order_date then o.order_amount else 0 end) as first_order_amnt,
sum(case when fo.first_order_date != o.order_date then o.order_amount else 0 end) as repeat_order_amnt
from first_order_cte fo JOIN customer_orders o on fo.customer_id = o.customer_id
group by o.order_date
order by o.order_date;