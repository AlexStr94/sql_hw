-- Определить, какие клиенты сделали более двух бронирований в разных отелях, и вывести информацию о
-- каждом таком клиенте, включая его имя, электронную почту, телефон, общее количество бронирований,
-- а также список отелей, в которых они бронировали номера (объединенные в одно поле через запятую с
-- помощью CONCAT). Также подсчитать среднюю длительность их пребывания (в днях) по всем бронированиям.
-- Отсортировать результаты по количеству бронирований в порядке убывания.

select 
	c."name",
	c.email,
	c.phone,
	count(b.id_booking) as booking_count,
	count(distinct h.id_hotel) as booking_hotel_count,
	avg(b.check_out_date - b.check_in_date) AS average_stay_days,
	STRING_AGG(DISTINCT h.name, ', ') AS hotels 
from customer c 
join booking b on b.id_customer = c.id_customer 
join room r on r.id_room = b.id_room 
join hotel h on h.id_hotel = r.id_hotel 
group by c.id_customer, c."name", c.email, c.phone
having count(b.id_booking) > 2 and count(distinct h.id_hotel) > 1
order by booking_count desc
