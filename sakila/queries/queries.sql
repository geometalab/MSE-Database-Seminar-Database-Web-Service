-- Queries for database sakila (PostgreSQL). 
-- Source: https://github.com/cantugabriela/Sakila-Queries-MySQL

-- Part 1
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name,last_name
FROM actor
ORDER BY last_name;
-> 100200 rows.

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT upper(concat(first_name,' ',last_name)) AS "Actor_Name"
FROM actor
ORDER BY 1;
-> 100200 rows.


-- Part 2
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='Joe';
--> 86 rows.

-- 2b. Find all actors whose last name contain the letters "gen":
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name ILIKE '%gen%';
--> 40 rows.

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name ILIKE '%LI%'
ORDER BY last_name, first_name;
--> 4065 rows.

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
--> 3 rows.


-- Part 4
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS "Last Name Count"
FROM actor
GROUP BY last_name
ORDER BY last_name;
--> 1496 rows. 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS "Last Name Count"
FROM actor
GROUP BY last_name
HAVING COUNT(*) >=2;
--> 1289 rows.


-- PART 6
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
-- Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff 
INNER JOIN address ON staff.address_id = address.address_id
ORDER BY last_name;
--> 2 rows.

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, SUM(amount) as "Total Amount"
FROM staff 
INNER JOIN payment ON staff.staff_id = payment.staff_id 
AND payment.payment_date >= '2005-08-01'::date
GROUP BY first_name, last_name;
--> 2 rows.

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_id) as "Actor Count"
FROM film_actor INNER JOIN film
ON film_actor.film_id = film.film_id
GROUP BY title
ORDER BY title;
--> 997 rows.

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT (title) as "Copies Available"
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title LIKE 'Hunchback Impossible'
GROUP BY film.title;
--> 1 row.

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) as "Total Paid by Each Customer"
FROM payment 
INNER JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;
--> 599 rows.


-- Part 7
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE 'K%' 
OR title LIKE 'Q%'
AND title IN (
  SELECT title
  FROM film
  WHERE language_id IN (
    SELECT language_id
    FROM "language"
    WHERE name ='English'
  )
);
--> 6501 rows.

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN (
     SELECT film_id
     FROM film
     WHERE title = 'Alone Trip'
  )
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
-- Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM customer
JOIN address ON (customer.address_id = address.address_id)
JOIN city ON (city.city_id = address.city_id)
JOIN country ON (country.country_id = city.country_id)
WHERE country.country= 'Canada';
--> 5 rows.

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN (
  SELECT film_id
  FROM film_category
  WHERE category_id IN (
    SELECT category_id
    FROM category
    WHERE name='Family'
  )
);

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_id) as "Rental Count"
FROM rental
JOIN inventory ON (rental.inventory_id = inventory.inventory_id)
JOIN film ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;
--> 958 rows.
					
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;
--> 2 rows.
					
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON country.country_id = city.country_id;
--> 2 rows.

-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name, SUM(amount)
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;
--> 5 rows.
