--В каких городах больше одного аэропорта?

select city
from airports
group by city
having count(airport_name) > 1

--В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?

select distinct departure_airport from flights
where aircraft_code = (
	select aircraft_code from aircrafts
	order by "range" desc
	limit 1)

-- Вывести 10 рейсов с максимальным временем задержки вылета

select flight_no, (actual_departure - scheduled_departure) as aaa from flights
where actual_departure notnull 
order by aaa desc
limit 10

-- Были ли брони, по которым не были получены посадочные талоны?

select distinct book_ref from tickets t
left join boarding_passes bp on t.ticket_no = bp.ticket_no
where bp.seat_no is null

-- Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
-- Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого аэропорта на каждый день.
-- Т.е. в этом столбце должна отражаться накопительная сумма - сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за день.

select f.departure_airport, f.actual_departure, fi.book_seats, (ac.all_seats - coalesce(fi.book_seats, 0)) as free_seats,
round((ac.all_seats - coalesce(fi.book_seats, 0)) :: numeric / ac.all_seats :: numeric * 100, 2) as ratio,
coalesce(sum(fi.book_seats) over (partition by f.departure_airport, date(f.actual_departure) order by f.actual_departure), 0) as hhhhh
from flights f
left join (
	select aircraft_code, count(seat_no) as all_seats from seats
	group by aircraft_code) ac on f.aircraft_code = ac.aircraft_code
left join (
	select flight_id, count(seat_no) as book_seats from boarding_passes
	group by flight_id) fi on f.flight_id = fi.flight_id
	
-- Найдите процентное соотношение перелетов по типам самолетов от общего количества.

select aircraft_code, round(count(flight_id) :: numeric / (select count(flight_id) from flights) :: numeric * 100, 2) ||'%' as ratio from flights
group by aircraft_code 

-- Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?

with cte_b as (
	select distinct f.flight_id, a2.city, tf.fare_conditions, amount
	from flights f 
	left join ticket_flights tf on tf.flight_id = f.flight_id
	left join airports a2 on a2.airport_code = f.departure_airport
	where tf.fare_conditions = 'Business'),
cte_e as (
	select distinct f.flight_id, a2.city, tf.fare_conditions, tf.amount
	from flights f 
	left join ticket_flights tf on tf.flight_id = f.flight_id
	left join airports a2 on a2.airport_code = f.departure_airport
	where tf.fare_conditions = 'Economy')
select distinct cte_b.city, case when cte_b.amount - cte_e.amount > 0 then 'нет' else 'да' end as hhh
from cte_b
left join cte_e on cte_b.flight_id = cte_e.flight_id
where (case when cte_b.amount - cte_e.amount > 0 then 'нет' else 'да' end) = 'да'

-- Между какими городами нет прямых рейсов?

with
cte1 as (
	select distinct f.departure_airport, a2.city
	from flights f
	left join airports a2 on a2.airport_code = f.departure_airport),
cte2 as (
	select distinct f1.arrival_airport, a.city
	from flights f1 left join airports a on a.airport_code = f1.arrival_airport)
select cte1.city as dep1, cte2.city as arr1
from cte1, cte2
where cte1.city <> cte2.city
except
select distinct a2.city as dep, a.city as arr
from flights f 
left join airports a on a.airport_code = f.arrival_airport
left join airports a2 on a2.airport_code = f.departure_airport 

-- Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы.

select distinct a2.city as depc, a.city as arrc,
round(acos((sind(a2.latitude)*sind(a.latitude)+cosd(a2.latitude)*cosd(a.latitude)*cosd(a2.longitude - a.longitude))) :: numeric * 6371, 2) as distance, a3."range", a3.model, 
a3."range" - round(acos((sind(a2.latitude)*sind(a.latitude)+cosd(a2.latitude)*cosd(a.latitude)*cosd(a2.longitude -a.longitude))) :: numeric * 6371, 0) as diff
from flights f 
left join airports a on a.airport_code = f.arrival_airport
left join airports a2 on a2.airport_code = f.departure_airport
left join aircrafts a3 on a3.aircraft_code = f.aircraft_code 


