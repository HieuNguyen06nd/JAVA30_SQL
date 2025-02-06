SELECT * FROM sakila.city;
-- 1
select City, country from city join country on city.country_id = country.country_id;
-- 2
select * from country;
select City, country from city join country on city.country_id = country.country_id where country.country = 'United States';
-- 3
select address, City from address join city on city.city_id = address.city_id where city = 'Hanoi';
-- 4
select film.title, film.description, category.name, rating from film join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id where film.rating = 'R';

-- 5
select film.title, film.description, actor.first_name  from film join film_actor on film_actor.film_id = film.film_id 
join actor on film_actor.actor_id = actor.actor_id where actor.first_name = 'Nick' and actor.last_name = 'Wahlberg';

-- 6 
select customer.email, country.country from customer join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id 
where country.country = 'United States';
