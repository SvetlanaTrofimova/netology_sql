-- Выведите ФИО сотрудников и города магазинов, имеющих больше 300-от покупателей
select s.store_id, a.ccc, ss.first_name, ss.last_name, city.city 
from (
	select store_id, count(customer_id) as ccc
	from customer
	group by store_id
	having count(customer_id) > 300) as a
left join store s 
	on a.store_id = s.store_id
left join staff ss
	on s.store_id = ss.store_id 
left join address aaa
	on s.address_id = aaa.address_id
left join city
	on aaa.city_id = city.city_id
	
-- Выведите у каждого покупателя город в котором он живет
select customer.customer_id, customer.first_name, customer.last_name, city.city
from customer
left join address aa
	on customer.address_id = aa.address_id
left join city
	on aa.city_id = city.city_id
	
-- Выведите количество актеров, снимавшихся в фильмах, которые сдаются в аренду за 2,99
select count(distinct actor_id)
from film_actor hh
left join film
	on hh.film_id = film.film_id
where film.rental_rate = 2.99

