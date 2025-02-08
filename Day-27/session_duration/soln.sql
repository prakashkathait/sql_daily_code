/* -- Popular Posts (From Stratascratch):
The column 'perc_viewed' in the table 'post_views' denotes the percentage of the session 
duration time the user spent viewing a post. Using it, calculate the total time that each 
post was viewed by users. Output post ID and the total viewing time in seconds, 
but only for posts with a total viewing time of over 5 seconds. */

with session_dur as (
						select session_id,
						ROUND(EXTRACT(EPOCH from (session_endtime - session_starttime)),0) as duration
						from user_sessions)
select post_id, 
sum((perc_viewed*duration)/100) as viewing_time
from post_views pv JOIN session_dur sd on pv.session_id = sd.session_id
group by post_id 
having sum((perc_viewed*duration)/100) > 5;