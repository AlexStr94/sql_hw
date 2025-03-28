-- Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом таком автомобиле для данного класса,
-- включая его класс, среднюю позицию и количество гонок, в которых он участвовал.
-- Также отсортировать результаты по средней позиции.

select 
	cars."name" as car_name,
	cars."class" as car_class,
	avg(results."position") as average_position,
	count(results.*) as race_count 
from cars
join results on results.car = cars."name" 
group by cars."class", cars."name"
order by average_position;