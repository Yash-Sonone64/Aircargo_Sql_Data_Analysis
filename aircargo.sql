-- 2. Write a query to create a route_details table using suitable data types for the fields, such as route_id, flight_num, origin_airport,
-- destination_airport, aircraft_id, and distance_miles; implement the check constraint for the flight number and unique constraint for the
-- route_id fields; also, make sure that the distance miles field is greater than 0

CREATE TABLE route_details (
route_id INT PRIMARY KEY,
flight_num VARCHAR(10) UNIQUE,
origin_airport VARCHAR(100),
destination_airport VARCHAR(100),
aircraft_id INT,
distance_miles INT CHECK (distance_miles > 0)
);

-- 3. Write a query to display all the passengers (customers) who have traveled on routes 01 to 25; refer to the data from the passengers_on_flights table
SELECT * FROM passengers_on_flights
WHERE route_id BETWEEN 1 AND 25;

-- 4. Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
SELECT COUNT(*) AS number_of_passengers, SUM(price_per_ticket * no_of_tickets) AS total_revenue
FROM ticket_details
WHERE class_id = 'Bussiness';

-- 5. Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;

-- 6. Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id;

-- 7. Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM ticket_details WHERE brand = 'Emirates');

-- 8. Write a query to identify the customers who have traveled by Economy Plus class using Group By and Having clause on the passengers_on_flights table.

SELECT customer_id, COUNT(*) AS total_trips
FROM passengers_on_flights
WHERE class_id = 'Economy Plus'
GROUP BY customer_id
HAVING COUNT(*) > 0;

-- 9. Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
SELECT 
    CASE 
        WHEN SUM(price_per_ticket * no_of_tickets) > 10000 THEN 'Yes'
        ELSE 'No'
    END AS revenue_exceeded
FROM ticket_details;

-- 10. Write a query to create and grant access to a new user to perform operations on a database.
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'new_user'@'localhost';
FLUSH PRIVILEGES;

-- 11. Write a query to find the maximum ticket price for each class using window functions on the ticket_details table.
SELECT class_id, MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_ticket_price
FROM ticket_details;

-- 12. Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.

SELECT *FROM passengers_on_flights
WHERE route_id = 4;

-- 13. For route ID 4, write a query to view the execution plan of the passengers_on_flights table.
EXPLAIN SELECT * FROM passengers_on_flights WHERE route_id = 4;

-- 14. Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using the rollup function.
SELECT customer_id, SUM(price_per_ticket * no_of_tickets) AS total_spent
FROM ticket_details
GROUP BY customer_id WITH ROLLUP;

-- 15. Write a query to create a view with only business class customers along with the brand of airlines. 
CREATE VIEW business_class_customers AS
SELECT customer_id, brand
FROM ticket_details
WHERE class_id = 'Business';

-- 16. Write a query to create a stored procedure to get the details of all  passengers flying between a range of routes defined in run time. Also,
-- return an error message if the table doesn't exist.
DELIMITER $$
CREATE PROCEDURE GetPassengerDetails(IN start_route INT, IN end_route INT)
BEGIN
    IF EXISTS (SELECT * FROM passengers_on_flights) THEN
        SELECT * FROM passengers_on_flights WHERE route_id BETWEEN start_route AND end_route;
    ELSE
        SELECT 'Error: Table does not exist' AS error_message;
    END IF;
END $$
DELIMITER ;

CALL GetPassengerDetails(1,25);

-- 17. Write a query to create a stored procedure that extracts all the details from the routes table where the traveled distance is more than 2000 miles.
DELIMITER $$
CREATE PROCEDURE GetLongDistanceRoutes()
BEGIN
    SELECT * FROM routes WHERE distance_miles > 2000;
END $$
DELIMITER ;

CALL GetLongDistanceRoutes();

-- 18. Write a query to create a stored procedure that groups the distance traveled by each flight into three categories. The categories are, short 
-- distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.

DELIMITER $$
CREATE PROCEDURE GroupFlightDistances()
BEGIN
SELECT 
CASE 
	WHEN distance_miles BETWEEN 0 AND 2000 THEN 'SDT'
	WHEN distance_miles BETWEEN 2001 AND 6500 THEN 'IDT'
	WHEN distance_miles > 6500 THEN 'LDT'
	END AS distance_category,
	COUNT(*) AS count
    FROM routes
    GROUP BY distance_category;
END $$
DELIMITER ;

CALL GroupFlightDistances();

