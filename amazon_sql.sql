-- Amazon Business Analyst Interview Question

-- Q.1

CREATE TABLE t1
(x int, 
y int
);

CREATE TABLE t2
(z int,
z2 int
);

-- insert into t1 and t2
INSERT INTO t1
VALUES
(0, 6),
(1, 7),
(3, 0),
(1, 5)
;

INSERT INTO t2
VALUES
(3, 6),
(2, 8),
(1, 9),
(0, 4)
;


select * from t1;
select * from t2;

with cte as (
select *,row_number() over() as rn from t1
)
, ct2 as (
select *, row_number() over() as rn from t2 
)
select cte.x,cte.y,ct2.z
from cte join ct2 on cte.rn = ct2.rn;