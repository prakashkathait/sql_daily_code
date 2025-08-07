/*drop table if exists airports;
drop table if exists flights;
CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time timestamp,
    end_time timestamp
);

delete from airports;
INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');

delete from flights;
INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');
*/

-- Question: Find the shortest route between New York and Tokoyo

select * from flights;

with cte as (
		select s.city_name as origin_city,e.city_name as end_city,f.start_time,f.end_time,f.flight_id
		from flights f 
		JOIN airports s on f.start_port = s.port_code
		JOIN airports e on f.end_port = e.port_code
            ),
direct_flight as (
		select origin_city,NULL as middle_city,end_city,
		round(EXTRACT(EPOCH FROM (end_time - start_time)) / 60,0) AS minutes_diff,
		flight_id from cte 
		where origin_city='New York' and end_city = 'Tokyo'
		)
select c1.origin_city as origin_city,c2.origin_city as middle_city,c2.end_city as end_city,
round(EXTRACT(EPOCH FROM (c2.end_time - c1.start_time)) / 60,0) AS minutes_diff,
CONCAT(c1.flight_id,',',c2.flight_id) as flights
from cte c1 join cte c2 on c1.end_city = c2.origin_city and c1.origin_city = 'New York' and c2.end_city = 'Tokyo'
where c1.end_time <= c2.start_time
group by c1.origin_city,c2.origin_city,c2.end_city,c1.flight_id,4,c2.flight_id
UNION 
select * from direct_flight;