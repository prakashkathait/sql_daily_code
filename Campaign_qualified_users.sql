-- Marketing Campaign Success [Advanced]

/*
You have the marketing_campaign table, which records in-app purchases by users. 
Users making their first in-app purchase enter a marketing campaign, 
where they see call-to-actions for more purchases. 
Find how many users made additional purchases due to the campaign's success.


The campaign starts one day after the first purchase. Users with only one or multiple 
purchases on the first day do not count, nor do users who later buy only the same products from their first day.

*/

with purchase_rank as (
SELECT *, 
DENSE_RANK() OVER(PARTITION BY user_id ORDER BY created_at) as r,
CONCAT(user_id,'-',product_id) as user_product
FROM marketing_campaign
)
SELECT COUNT(DISTINCT user_id) 
FROM purchase_rank p 
WHERE p.r > 1 AND p.user_product NOT IN (SELECT user_product FROM purchase_rank WHERE r=1);