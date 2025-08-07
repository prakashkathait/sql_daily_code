/*
drop table if exists transactions;
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date timestamp
);

delete from Transactions;
INSERT INTO Transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO Transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');
*/

/* question:  Top 5 seller and buyer combinations who has done maximum transactions between them.
   condition: Disqualify the sellers who have acted as buyers and also the buyers who have acted as seller
   			  for the condition.
*/


with cte as (
				select *, 
				lead(customer_id,1) over(order by transaction_id) as buyer_id from transactions
),
cte_comb as (
				select customer_id,buyer_id,count(*) as no_of_trans from cte 
				where transaction_id % 2 <> 0
				group by customer_id,buyer_id
				order by no_of_trans desc
			),
fraud_trns as (
				select cc1.customer_id
				from cte_comb cc1
				inner join cte_comb cc2 on cc1.customer_id = cc2.buyer_id
				group by cc1.customer_id
			  )
select * from cte_comb 
where customer_id not in (select customer_id from fraud_trns)
and buyer_id not in (select customer_id from fraud_trns);