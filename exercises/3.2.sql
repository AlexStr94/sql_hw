-- Необходимо провести анализ клиентов, которые сделали более двух бронирований в разных отелях и потратили более 500 долларов на свои бронирования. Для этого:

-- Определить клиентов, которые сделали более двух бронирований и забронировали номера в более чем одном отеле. Вывести для каждого такого клиента следующие данные: 
-- ID_customer, имя, общее количество бронирований, общее количество уникальных отелей, в которых они бронировали номера, и общую сумму, потраченную на бронирования.
-- Также определить клиентов, которые потратили более 500 долларов на бронирования, и вывести для них ID_customer, имя, общую сумму, потраченную на бронирования, 
-- и общее количество бронирований.
-- В результате объединить данные из первых двух пунктов, чтобы получить список клиентов, 
-- которые соответствуют условиям обоих запросов. Отобразить поля: ID_customer, имя, общее количество бронирований, общую сумму, потраченную на бронирования, и общее количество уникальных отелей.
-- Результаты отсортировать по общей сумме, потраченной клиентами, в порядке возрастания.

with book_stat as (
	select 
		c.id_customer as id_customer,
		count(b.*) as total_bookings,
		count(h.*) as unique_hotels
	from customer c
	join booking b on b.id_customer = c.id_customer 
	join room r on r.id_room = b.id_room 
	join hotel h on h.id_hotel = r.id_hotel 
	group by c.id_customer
),
book_exspenses as (
	select 
		c.id_customer as id_customer,
		sum((b.check_out_date - b.check_in_date) * r.price) as total_spent
	from customer c
	join booking b on b.id_customer = c.id_customer 
	join room r on r.id_room = b.id_room 
	group by c.id_customer
)
select 
	c.id_customer,
	c."name" ,
	b_s.total_bookings,
	b_e.total_spent,
	b_s.unique_hotels
from customer c
join book_exspenses b_e on b_e.id_customer = c.id_customer
join book_stat b_s on b_s.id_customer = c.id_customer
where (b_s.total_bookings > 2 and b_s.unique_hotels > 1) or b_e.total_spent > 500
order by b_e.total_spent