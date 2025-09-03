Qs: 
Provided a table with user id and the dates they visited the platform, find the top 3 users with the longest continuous streak of visiting the platform as of August 10, 2022. Output the user ID and the length of the streak.
In case of a tie, display all users with the top three longest streaks.

Solution: 

with unique_visits as ( -- removing the duplicates
                    select DISTINCT user_id, date_visited
                    FROM user_streaks
                    WHERE date_visited <= '2022-08-10'
                    -- ORDER BY user_id,date_visited
),
streak_flags as (
select *, 
CASE WHEN date_visited - 
                        LAG(date_visited) OVER(PARTITION BY user_id 
                                                ORDER BY date_visited) =1 
        THEN 0 
        ELSE 1 END AS new_streak
    FROM unique_visits
),
streak_ids as (                   						-- assign an id to every streak
select *, SUM(new_streak) OVER (PARTITION BY user_id
                                ORDER BY date_visited) AS streak_id 
    FROM streak_flags
),
streak_lengths AS (    -- Length of each streak 
SELECT user_id,
        streak_id,
        COUNT(*) AS streak_length
    FROM streak_ids
    GROUP BY user_id,streak_id
),
longest_per_user AS (      -- Keep only each user's longest streak
select user_id,MAX(streak_length) AS streak_length
FROM streak_lengths
GROUP BY user_id
),
ranked_lengths as (    -- ranking the distinct streak lengths
select  user_id,
                streak_length,
                DENSE_RANK() OVER(ORDER BY streak_length DESC) AS len_rank
FROM longest_per_user)
select user_id,streak_length from ranked_lengths
where len_rank <=3
order by streak_length DESC, user_id; -- in case of tie

-- Optimised version -- 

with unique_visits as (                      -- removing the duplicates
                    select DISTINCT user_id, date_visited
                    FROM user_streaks
                    WHERE date_visited <= '2022-08-10'
),
streak_flags as (
select *, 
CASE WHEN date_visited - 
                        LAG(date_visited) OVER(PARTITION BY user_id 
                                                ORDER BY date_visited) =1 
        THEN 0 
        ELSE 1 END AS new_streak
    FROM unique_visits
),
streak_ids as (                        -- assign an id to every streak
select *, SUM(new_streak) OVER (PARTITION BY user_id
                                ORDER BY date_visited) AS streak_id 
    FROM streak_flags
),
streak_lengths AS (                     -- Length of each streak 
SELECT user_id,
        streak_id,
        COUNT(*) AS streak_length
    FROM streak_ids
    GROUP BY user_id,streak_id
),
ranked_lengths as (    -- ranking the distinct streak lengths
select  user_id,
                streak_length,
                DENSE_RANK() OVER(ORDER BY streak_length DESC) AS len_rank
FROM streak_lengths)
select user_id,streak_length from ranked_lengths
where len_rank <=3
order by streak_length DESC, user_id; -- in case of tie