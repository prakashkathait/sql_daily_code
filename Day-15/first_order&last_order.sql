/*create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;*/




/*Q.Find out the order_date wise no_of_new_customer and no_of_repeat_customer 
 and revenue generated from both type of customers?
*/

with first_order as (
						select customer_id, min(order_date) as first_order_date
						from customer_orders
						group by customer_id
						order by first_order_date)
select fo.first_order_date
,sum(case when fo.first_order_date = co.order_date then 1 else 0 end) as new_order
,sum(case when fo.first_order_date <> co.order_date then 1 else 0 end) as repeat_order
,sum(case when fo.first_order_date = co.order_date then order_amount end) as new_order_revenue
,sum(case when fo.first_order_date <> co.order_date then order_amount end) as repeat_order_revenue
from first_order fo join customer_orders co on fo.customer_id = co.customer_id
group by fo.first_order_date
order by fo.first_order_date asc;
