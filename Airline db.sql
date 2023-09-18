-- Exploratory Dive In The Airline DB

-- 1. Find list of airport codes in Europe/Moscow timezone.
SELECT airport_code
FROM airports
WHERE timezone = 'Europe/Moscow';

-- 2. Write a query to get the count of seats in various fare condition for every aircraft code.
SELECT aircraft_code, fare_conditions, count(seat_no) as seat_count
FROM seats
GROUP BY 1,2
ORDER BY 1;

-- 3. How many aircrafts codes have at least one Business class seats?
SELECT count(DISTINCT aircraft_code)
FROM seats
WHERE fare_conditions = 'Business';

-- 4. Find out the name of the airport having maximum number of departure flight.
SELECT JSON_UNQUOTE(JSON_EXTRACT(a.airport_name, '$.en')) AS airport_name
FROM airports AS a
JOIN flights AS f
ON f.departure_airport = a.airport_code
GROUP BY airport_name
ORDER BY COUNT(f.flight_id) DESC
LIMIT 1;

-- 5. Find out the name of the airport having least number of scheduled departure flights.
SELECT JSON_UNQUOTE(JSON_EXTRACT(a.airport_name, '$.en')) AS airport_name
FROM airports AS a
JOIN flights AS f
ON f.departure_airport = a.airport_code
GROUP BY airport_name
ORDER BY COUNT(f.departure_airport)
LIMIT 1;

-- 6. How many flights from ‘DME’ airport don’t have actual departure?
SELECT count(departure_airport)
FROM flights 
WHERE departure_airport = 'DME'
AND actual_departure IS NULL;

-- 7. Identify flight ids having range between 3000 to 6000.
SELECT f.flight_id AS Flight_Number, a.aircraft_code, a.range
FROM flights AS f 
join aircrafts AS a 
ON a.aircraft_code = f.aircraft_code
WHERE `RANGE` BETWEEN 3000 AND 6000;

-- 8. Write a query to get the count of flights flying between URS and KUF.
SELECT  COUNT (flight_id)
FROM flights 
WHERE departure_airport = 'KUF' AND arrival_airport = 'URS' 
OR departure_airport = 'URS' AND arrival_airport = 'KUF';

-- 9. Write a query to get the count of flights flying from either from NOZ or KRR.
SELECT COUNT (flight_id)
FROM flights 
WHERE  departure_airport IN ('NOZ', 'KRR');

-- 10.	Write a query to get the count of flights flying from KZN,DME,NBC,NJC,GDX,SGC,VKO,ROV.
SELECT departure_airport, COUNT (flight_id) as count_of_flights 
FROM flights 
WHERE departure_airport IN ('KZN','DME','NBC','NJC','GDX','SGC','VKO','ROV')
GROUP BY 1;

-- 11. Write a query to extract flight details having range between 3000 and 6000 and flying from DME.
SELECT DISTINCT(f.flight_no), a.aircraft_code, a.range, f.departure_airport
FROM flights AS f 
JOIN aircrafts AS a 
ON a.aircraft_code = f.aircraft_code
WHERE `RANGE` BETWEEN 3000 AND 6000 
AND departure_airport = 'DME';

-- 12. Find the list of flight ids which are using aircrafts from “Airbus” company and got cancelled or delayed.
SELECT f.flight_id, JSON_UNQUOTE(JSON_EXTRACT(a.model, '$.en')) AS aircraft_model
FROM flights AS f
JOIN aircrafts AS a
ON a.aircraft_code = f.aircraft_code
WHERE JSON_UNQUOTE(JSON_EXTRACT(a.model, '$.en')) LIKE '%Airbus%'
AND (status = 'Cancelled' OR status = 'Delayed');

-- 13. Find the list of flight ids which are using aircrafts from “Boeing” company and got cancelled or delayed.
SELECT f.flight_id, 
JSON_UNQUOTE(JSON_EXTRACT(a.model, '$.en')) AS aircraft_model
FROM flights AS f
JOIN aircrafts AS a
ON a.aircraft_code = f.aircraft_code
WHERE JSON_UNQUOTE(JSON_EXTRACT(a.model, '$.en')) LIKE '%Boeing%'
AND (status = 'Cancelled' OR status = 'Delayed');

-- 14. Which airport(name) has most cancelled flights (arriving)?
SELECT JSON_UNQUOTE(JSON_EXTRACT(a.airport_name, '$.en')) AS airport_name
FROM airports AS a
JOIN flights AS f
ON f.arrival_airport = a.airport_code
WHERE f.status = 'Cancelled'
GROUP BY JSON_UNQUOTE(JSON_EXTRACT(a.airport_name, '$.en'))
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 15. Identify flight ids which are using “Airbus aircrafts”.
SELECT f.flight_id, a.model AS aircraft_model
FROM flights AS f
JOIN aircrafts AS a
ON a.aircraft_code = f.aircraft_code
WHERE JSON_UNQUOTE(JSON_EXTRACT(a.model, '$.en')) LIKE '%Airbus%';

-- 16. Identify date-wise last flight id flying from every airport.
SELECT flight_id, flight_no, scheduled_departure, departure_airport
FROM(
SELECT flight_id, flight_no, scheduled_departure, departure_airport,
            ROW_NUMBER() OVER (PARTITION BY DATE(scheduled_departure), departure_airport ORDER BY scheduled_departure DESC) AS rn
        FROM
            flights
    ) AS last_flights
WHERE rn = 1;

-- 17. Identify list of customers who will get the refund due to cancellation of the flights and how much amount they will get.
SELECT t.passenger_name, SUM(tf.amount) as total_refund
FROM tickets AS t 
JOIN ticket_flights AS tf 
ON tf.ticket_no = t.ticket_no 
JOIN flights AS f  
ON f.flight_id = tf.flight_id
WHERE f.status = 'Cancelled'
GROUP BY 1;

-- 18.	Identify date wise first cancelled flight id flying for every airport.
SELECT flight_id, flight_no, scheduled_departure, departure_airport
FROM (SELECT flight_id, flight_no, scheduled_departure, departure_airport,
ROW_NUMBER() OVER (PARTITION BY DATE(scheduled_departure), departure_airport ORDER BY scheduled_departure) AS rn
FROM flights
WHERE status = 'Cancelled' ) AS first_cancelled_flights
WHERE rn = 1;

-- 19. Identify list of Airbus flight ids which got cancelled.
SELECT f.flight_id
FROM flights AS f
JOIN aircrafts AS a
ON a.aircraft_code = f.aircraft_code
WHERE JSON_UNQUOTE(JSON_EXTRACT(a.model, '$.en')) LIKE '%Airbus%'
AND f.status = 'Cancelled';

-- 20. Identify list of flight ids having highest range.
SELECT DISTINCT(f.flight_no), a.range
FROM flights AS f
JOIN aircrafts AS a 
ON a.aircraft_code = f.aircraft_code
ORDER BY 2 DESC





















 

