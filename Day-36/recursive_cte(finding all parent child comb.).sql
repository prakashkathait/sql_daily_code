/*CREATE TABLE Invested (
    pname VARCHAR(10),
    cname VARCHAR(10)
);

INSERT INTO Invested (pname, cname) VALUES
('Don', 'C1'),
('Don', 'C4'),
('Ron', 'C1'),
('Hil', 'C3');

CREATE TABLE Subsidiary (
    parent VARCHAR(10),
    child VARCHAR(10)
);

INSERT INTO Subsidiary (parent, child) VALUES
('C1', 'C2'),
('C2', 'C3'),
('C2', 'C5'),
('C4', 'C6');
*/
-- Question : Find the all possible combinations of the subsidiary and invested table combinations
-- Solution

	with recursive cte as (
	select parent,child from Subsidiary
	union all 
	select c.parent,s.child
	from cte c join subsidiary s on c.child = s.parent 
	)
	select p.pname,c.pname from cte
	join invested p on p.cname = cte.parent
	join invested c on c.cname = cte.child
	order by 1;
