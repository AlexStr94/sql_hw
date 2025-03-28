-- Вам необходимо провести анализ данных о бронированиях в отелях и определить предпочтения клиентов по типу отелей. Для этого выполните следующие шаги:

-- Категоризация отелей.
-- Определите категорию каждого отеля на основе средней стоимости номера:

-- «Дешевый»: средняя стоимость менее 175 долларов.
-- «Средний»: средняя стоимость от 175 до 300 долларов.
-- «Дорогой»: средняя стоимость более 300 долларов.
-- Анализ предпочтений клиентов.
-- Для каждого клиента определите предпочитаемый тип отеля на основании условия ниже:

-- Если у клиента есть хотя бы один «дорогой» отель, присвойте ему категорию «дорогой».
-- Если у клиента нет «дорогих» отелей, но есть хотя бы один «средний», присвойте ему категорию «средний».
-- Если у клиента нет «дорогих» и «средних» отелей, но есть «дешевые», присвойте ему категорию предпочитаемых отелей «дешевый».
-- Вывод информации.
-- Выведите для каждого клиента следующую информацию:

-- ID_customer: уникальный идентификатор клиента.
-- name: имя клиента.
-- preferred_hotel_type: предпочитаемый тип отеля.
-- visited_hotels: список уникальных отелей, которые посетил клиент.
-- Сортировка результатов.
-- Отсортируйте клиентов так, чтобы сначала шли клиенты с «дешевыми» отелями, затем со «средними» и в конце — с «дорогими».

with average_price as (
	select h.id_hotel as id_hotel, avg(r.price) as price from hotel h
	join room r on r.id_hotel = h.id_hotel 
	group by h.id_hotel
),
hotel_category as (
	select 
		h.id_hotel,
		case 
			when a.price < 175 then 1
			when a.price < 300 then 2
			else 3
		end as category
	from hotel h
	join average_price a on a.id_hotel = h.id_hotel
),
customer_category as (
	select
		c.id_customer as id_customer,
		max(h_c.category) as category
	from customer c
	join booking b on b.id_customer = c.id_customer 
	join room r on r.id_room = b.id_room 
	join hotel h on h.id_hotel = r.id_hotel 
	join hotel_category h_c on h_c.id_hotel = h.id_hotel
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
	c.id_customer,
	c.name,
	case 
		when c_c.category = 1 then 'Дешевый'
		when c_c.category = 2 then 'Средний'
		else 'Дорогой'
	end	as preferred_hotel_type,
	b_h.hotels
from customer c 
join customer_category c_c on c_c.id_customer = c.id_customer
join booking_hotels b_h on b_h.id_customer = c.id_customer 
order by c_c.category