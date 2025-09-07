/*
Find the IDs of the drivers who completed at least one trip a month for at least two months in a row.
*/

-- Solution:

with driver_cte as 
(
select 
    driver_id,
    date_trunc('month',trip_date)::date as trip_month
FROM uber_trips
WHERE is_completed is True
),
month_nums as (
SELECT 
driver_id,
EXTRACT(YEAR FROM trip_month) * 12 + EXTRACT(MONTH FROM trip_month) as ym_mn
FROM driver_cte
)
SELECT DISTINCT driver_id 
FROM (
SELECT 
    driver_id,
    ym_mn,
    LAG(ym_mn) OVER(PARTITION BY driver_id ORDER BY ym_mn) as prev_ym
FROM month_nums) t 
WHERE ym_mn - t.prev_ym = 1;