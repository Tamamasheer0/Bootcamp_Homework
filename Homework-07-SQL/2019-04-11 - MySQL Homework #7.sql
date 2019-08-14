USE sakila;
-- 1a. Display the First and Last Names of All Actors From the Table 'actor'.
SELECT first_name, last_name
FROM actor;

-- 1b. Display the First and Last Name of Each Actor in a Single Column in Upper Case.
SELECT CONCAT(UPPER(first_name), " ", UPPER(last_name)) as full_name
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you 
-- know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name="Joe";

-- 2b. Find all actors whose last name contains the letters 'GEN':
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters 'LI'. This time, order the rows
-- by last name and first name in that order:
SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using 'IN', display the 'country_id' and 'country' columns of the following countries: 
-- Afghanistan, Bangladesh, China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. you want to keep a description of each actor. You don't think you will be performing
-- queries on a description, so create a column in the table 'actor' named 'description' and
-- use the datatype 'BLOB' (Make sure to research the type 'BLOB', as the difference between
-- it and 'VARCHAR' are significant)
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_name;


-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort.
-- Delete the 'description' column.alter
ALTER TABLE	actor
DROP description;

-- 4a. List the last names of actors as well as how many actors have that last name.

SELECT last_name,
COUNT(last_name) as count
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors that have that last name, but only 
-- for names that are shared by at least two actors.
SELECT last_name, 
COUNT(last_name) as count
FROM actor
GROUP BY last_name
HAVING count > 1;

-- 4c. The actor 'Harpo Williams' was accidentally entereed in the 'actor' table as 'GROUCHO
-- WILLIAMS'. Write a query to fix the record.
UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO' AND
	  last_name='WILLIAMS';

-- 4d. Perhaps we were too hasty in changing 'GROUCHO' to 'HARPO'. It turns out that 'GROUCHO'
-- as the correct name after all!. In a single query, if the first name of the actor is currently
-- 'HARPO', change it to 'GROUCHO'.
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO' AND 
	  last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?



-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT s.first_name, s.last_name, a.address
FROM address as a
INNER JOIN staff as s
		ON s.address_id=a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT s.first_name, s.last_name,
SUM(p.amount) as total
FROM payment as p
INNER JOIN staff as s
		ON s.staff_id=p.staff_id
GROUP BY p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.title,
COUNT(fa.actor_id) as num_actors
FROM film_actor as fa
INNER JOIN film as f
	    ON fa.film_id=f.film_id
GROUP BY f.title;
 
 -- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
 SELECT f.title,
 COUNT(i.film_id) as num_copies
 FROM inventory as i
 INNER JOIN film as f
		ON i.film_id=f.film_id
 WHERE i.film_id=(
					SELECT film_id
					FROM film
                    WHERE title='Hunchback Impossible'
				);

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name,
SUM(p.amount) as total_amount_paid
FROM payment as p
INNER JOIN customer as c
		ON p.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q`
-- have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
 SELECT f.title
 FROM film as f
 WHERE f.title LIKE 'K%' OR
	   f.title LIKE 'Q%' AND
	   f.language_id=(
						SELECT language_id
                        FROM language
                        WHERE name='English'
						)
ORDER BY f.title ASC;
 
-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT a.first_name, a.last_name
FROM actor as a
WHERE a.actor_id IN (
						-- Return List of Actors In Movie w/ Film ID
						SELECT fa.actor_id
						FROM film_actor as fa
						WHERE fa.film_id = (
												-- Return Film ID >> "Alone Trip"
												SELECT f.film_id
												FROM film as f
												WHERE f.title='Alone Trip'
											)
					)
 ORDER BY a.first_name ASC;
 
 -- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
 -- Use joins to retrieve this information.
 SELECT c.first_name, c.last_name, c.email
 FROM customer as c
 WHERE c.address_id IN (
							-- Return List of "address_id" of All Canadian Cities
							SELECT a.address_id
                            FROM address as a
                            WHERE a.city_id IN (
													-- Returns List of "city_id" of All Canadian Cities
													SELECT ct.city_id
													FROM city as ct
                                                    -- Join Creates Table of Canadian Cities
                                                    INNER JOIN country as ctry
															ON ctry.country_id=ct.country_id
													WHERE ctry.country='Canada'
												)
						)
ORDER BY c.first_name ASC;
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title, description, release_year, rating, rental_rate
FROM film 
WHERE rating LIKE '%G%'
ORDER BY title ASC;
 
 -- 7e. Display the most frequently rented movies in descending order.
 SELECT * FROM rental;
 SELECT * FROM inventory;
 SELECT * FROM film;

SELECT f.title, f.description, f.rating, f.length, f.rental_rate, 
COUNT(f.film_id) as rental_ct
FROM film as f
RIGHT JOIN inventory as i
		 ON i.inventory_id=rental.inventory_id
GROUP BY f.film_id
ORDER BY rental_ct DESC
LIMIT 25; 





