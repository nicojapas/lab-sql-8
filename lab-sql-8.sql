-- # Lab | SQL Queries 8

-- 1. Rank films by length (filter out the rows that have nulls or 0s in length column).
-- In your output, only select the columns title, length, and the rank.  
select
	title,
    length,
	dense_rank () over (order by length desc) as rank_by_length
from sakila.film
where length is not null and length != 0;

-- 2. Rank films by length within the `rating` category (filter out the rows that have nulls or 0s in length column).
-- In your output, only select the columns title, length, rating and the rank.  
select title, length, rating,
dense_rank () over (partition by rating order by length desc) as rank_by_length
from sakila.film
where length is not null and length != 0;

-- 3. How many films are there for each of the categories in the category table. Use appropriate join to write this query
select fcat.category_id, cat.name, count(fcat.category_id) as films_in_category
from sakila.film as f
inner join sakila.film_category as fcat
using (film_id)
inner join sakila.category as cat
using (category_id)
group by category_id;

-- 4. Which actor has appeared in the most films?
select
	concat(act.first_name, ' ', act.last_name) as actor_name,
	count(*) as number_of_films,
	dense_rank() over (
		order by count(*) desc
	) as ranked
from sakila.film
inner join sakila.film_actor as f_act using (film_id)
inner join sakila.actor as act using (actor_id)
group by actor_id
;

-- 5. Most active customer (the customer that has rented the most number of films)
select
	rnt.customer_id,
    concat(cst.first_name, ' ', cst.last_name) as customer_name,
    dense_rank() over(
		order by count(*)
	) as most_active_customer
from sakila.rental as rnt
inner join sakila.customer as cst using (customer_id)
group by (customer_id)
;

-- **Bonus**: Which is the most rented film?
-- The answer is Bucket Brotherhood
-- This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.
select
	rnt.rental_id,
    inv.inventory_id,
    flm.film_id,
    flm.title,
    count(*) as times_rented,
   	dense_rank() over (
		order by count(*) desc
	) as ranked
from sakila.rental as rnt
inner join sakila.inventory as inv using (inventory_id)
inner join sakila.film as flm using (film_id)
group by flm.film_id
;

