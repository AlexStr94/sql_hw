-- Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию о
-- каждом таком клиенте, включая его имя, электронную почту, телефон, общее количество бронирований,
-- а также список отелей, в которых они бронировали номера (объединенные в одно поле через запятую с
-- помощью CONCAT). Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям.
-- Отсортировать результаты по количеству бронирований в порядке убывания.


with booking_extra as (
	select c.id_customer as id_customer, count(*) as booking_count, avg(b.check_out_date - b.check_in_date) AS average_stay_days from customer c
	join booking b on b.id_customer = c.id_customer 
	group by c.id_customer
),
booking_hotels as (
	select c.id_customer as id_customer, STRING_AGG(DISTINCT h.name, ', ') AS hotels 
	from customer c
	join booking b on b.id_customer = c.id_customer 
	join room r on r.id_room = b.id_room 
	join hotel h on h.id_hotel = r.id_hotel 
	group by c.id_customer 
)
select 
	c."name",
	c.email,
	c.phone,
	b_e.booking_count,
	b_h.hotels,
	b_e.average_stay_days
from customer c 
join booking_extra b_e on c.id_customer = b_e.id_customer
join booking_hotels b_h on b_h.id_customer = c.id_customer
join booking b on b.id_customer = c.id_customer 
join room r on r.id_room = b.id_room 
join hotel h on h.id_hotel = r.id_hotel 