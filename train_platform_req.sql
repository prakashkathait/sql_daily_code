/*
::Minimum Number of Platforms::
You are given a day worth of scheduled departure and arrival times of trains
at one train station. One platform can only accommodate one train from 
the beginning of the minute it's scheduled to arrive until the end of 
the minute it's scheduled to depart. Find the minimum number of platforms
necessary to accommodate the entire scheduled traffic.
*/

-- Solution

with event_cte as (
            select arrival_time as event_time , 1 as event from train_arrivals 
            UNION ALL 
            select departure_time as event_time , -1 as event from train_departures
),
max_running_cte as (
            select event_time , 
            sum(event) over(order by event_time) as running_sum 
            from event_cte
)
select max(running_sum) as min_pltform_req. 
from max_running_cte;