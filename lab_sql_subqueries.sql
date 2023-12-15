-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT title, count(*) as number_available_copies FROM (
SELECT f.title FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
WHERE title =  "Hunchback Impossible" AND rental_duration > 0) as sub
GROUP BY title;


-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT actor_id as actors_appear_alone_trip FROM (SELECT actor_id FROM film_actor AS fa
JOIN film as f
ON fa.film_id = f.film_id
WHERE title = "Alone Trip") as sub1;

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM category
WHERE name = 'Family';

SELECT * FROM (
SELECT title FROM film as f
JOIN film_category as fc
ON f.film_id = fc.film_id
WHERE category_id = 8) as sub1;

-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT * FROM country
WHERE country = 'Canada';

SELECT * FROM(
SELECT concat(first_name, " ", last_name) as customer_from_canada, email FROM customer as c
JOIN address as a
ON c.address_id = a.address_id
JOIN city as ci
ON a.city_id = ci.city_id
WHERE country_id = 20) as sub1;

-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT COUNT(DISTINCT film_id) as number_diff_films, actor_id FROM film_actor
GROUP BY actor_id
ORDER BY number_diff_films DESC;
SELECT * FROM
(SELECT f.film_id, title FROM film as f
JOIN film_actor as fa
ON f.film_id = fa.film_id
WHERE actor_id = 107) as sub1
ORDER BY f.film_id;

-- Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT SUM(amount) as total_amount, customer_id FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC;
SELECT title FROM (
SELECT title FROM film as t
JOIN inventory as i
ON t.film_id = i.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
WHERE r.customer_id = 526) as sub1;

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT ROUND(AVG(sub1.sum_amount),2) as average_total_amount_spent FROM (SELECT SUM(amount) as sum_amount, customer_id FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC) as sub1;

SELECT customer_id, total_amount_spent FROM 
(SELECT customer_id, SUM(amount) as total_amount_spent FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 112.53) as sub1
ORDER BY total_amount_spent ASC;
