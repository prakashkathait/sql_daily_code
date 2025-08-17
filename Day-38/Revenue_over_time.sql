/*Revenue Over Time

Find the 3-month rolling average of total revenue from purchases given a table with users,
their purchase amount, and date purchased. Do not include returns which are represented by 
negative purchase values. Output the year-month (YYYY-MM) and 3-month rolling average of revenue,
 sorted from earliest month to latest month.


A 3-month rolling average is defined by calculating the average total revenue from all user 
purchases for the current month and previous two months. The first two months will not be a
 true 3-month rolling average since we are not given data from last year. Assume each month has at least one purchase.
*/
-- solution:

with rolling_avg as (
select to_char(created_at,'YYYY-MM') as year_month
,sum(purchase_amt) as tot_amt
from amazon_purchases
where purchase_amt>0 
group by to_char(created_at,'YYYY-MM')
)
select year_month, round(avg(tot_amt) over(order by year_month
                        rows between 2 preceding and current row),2) as avg_r
from rolling_avg;