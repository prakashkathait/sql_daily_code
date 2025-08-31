/* drop table if exists orders;
CREATE TABLE orders (
    customer_id INT,
    order_date DATE,
    coupon_code VARCHAR(50)
);

-- ✅ Customer 1: First order in Jan, valid pattern
INSERT INTO Orders VALUES (1, '2025-01-10', NULL);
INSERT INTO Orders VALUES (1, '2025-02-05', NULL);
INSERT INTO Orders VALUES (1, '2025-02-20', NULL);
INSERT INTO Orders VALUES (1, '2025-03-01', NULL);
INSERT INTO Orders VALUES (1, '2025-03-10', NULL);
INSERT INTO Orders VALUES (1, '2025-03-15', 'DISC10'); -- last order with coupon ✅

-- ✅ Customer 2: First order in Feb, valid pattern
INSERT INTO Orders VALUES (2, '2025-02-02', NULL);   -- Month1 = 1
INSERT INTO Orders VALUES (2, '2025-02-05', NULL);   -- Month1 = 1
INSERT INTO Orders VALUES (2, '2025-03-05', NULL);   -- Month2 = 2
INSERT INTO Orders VALUES (2, '2025-03-18', NULL);
INSERT INTO Orders VALUES (2, '2025-03-20', NULL);   -- Month2 = 2
INSERT INTO Orders VALUES (2, '2025-03-22', NULL);
INSERT INTO Orders VALUES (2, '2025-04-02', NULL);   -- Month3 = 3
INSERT INTO Orders VALUES (2, '2025-04-10', NULL);
INSERT INTO Orders VALUES (2, '2025-04-15', 'DISC20'); -- last order with coupon ✅
INSERT INTO Orders VALUES (2, '2025-04-16', NULL);   -- Month3 = 3
INSERT INTO Orders VALUES (2, '2025-04-18', NULL);
INSERT INTO Orders VALUES (2, '2025-04-20', 'DISC20'); -- last order with coupon ✅

-- ❌ Customer 3: First order in March but wrong multiples
INSERT INTO Orders VALUES (3, '2025-03-05', NULL);  -- Month1 = 1
INSERT INTO Orders VALUES (3, '2025-04-10', NULL);  -- Month2 should have 2, but only 1 ❌
INSERT INTO Orders VALUES (3, '2025-05-15', 'DISC30');

-- ❌ Customer 4: First order in Feb but missing March (gap)
INSERT INTO Orders VALUES (4, '2025-02-01', NULL);  -- Month1
INSERT INTO Orders VALUES (4, '2025-04-05', 'DISC40'); -- Skipped March ❌

-- ❌ Customer 5: Valid multiples but last order has no coupon
INSERT INTO Orders VALUES (5, '2025-01-03', NULL);  -- M1 = 1
INSERT INTO Orders VALUES (5, '2025-02-05', NULL);  -- M2 = 2
INSERT INTO Orders VALUES (5, '2025-02-15', NULL);
INSERT INTO Orders VALUES (5, '2025-03-01', NULL);  -- M3 = 3
INSERT INTO Orders VALUES (5, '2025-03-08', 'DISC50'); -- coupon mid
INSERT INTO Orders VALUES (5, '2025-03-20', NULL);     -- last order no coupon ❌

-- ❌ Customer 6: Skips month 2, should be excluded
INSERT INTO Orders VALUES (6, '2025-01-05', NULL);     -- Month1 = 1 order
-- (no orders in Feb, so Month2 is missing ❌)
INSERT INTO Orders VALUES (6, '2025-03-02', NULL);     -- Month3 = 1st order
INSERT INTO Orders VALUES (6, '2025-03-15', NULL);     -- Month3 = 2nd order
-- Jump to May (Month5 relative to Jan)
INSERT INTO Orders VALUES (6, '2025-05-05', NULL);     
INSERT INTO Orders VALUES (6, '2025-05-10', NULL);     
INSERT INTO Orders VALUES (6, '2025-05-25', 'DISC60'); -- Last order with coupon
*/

/*Qs.: Find the number of customers based on the following conditions and he/she should placed order for the three 
	consequtive months
		1. A customer should order atleast one order in the first month of purchase.
		2. customer should order twice the first month of order count
		3. customer sholud order thrice the first month of order count
		4. Last month order should be done with the coupon code.
*/

-- solution:

with cte as (
select *, date_trunc('month',order_date)::date as order_month
, min(date_trunc('month',order_date)::date) over(partition by customer_id) as first_order_month
, last_value(coupon_code) over(partition by customer_id order by order_date
								rows between unbounded preceding and unbounded following) as last_coupon
from orders ),
month_cte as (
select *
,EXTRACT(MONTH from AGE(order_month,first_order_month))+1 as month_count 
from cte)
select * from (
select customer_id,
sum(case when month_count = 1 then 1 else 0 end) as first_mnth_order_cnt,
sum(case when month_count = 2 then 1 else 0 end) as second_mnth_order_cnt,
sum(case when month_count = 3 then 1 else 0 end) as third_mnth_order_cnt
from month_cte
where last_coupon is not null
group by customer_id) a 
where second_mnth_order_cnt = 2*first_mnth_order_cnt and third_mnth_order_cnt = 3*first_mnth_order_cnt
;
