-- Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках,
-- и вывести информацию о каждом таком автомобиле для данного класса,
-- включая его класс, среднюю позицию и количество гонок, в которых он участвовал.
-- Также отсортировать результаты по средней позиции.

select 
car_name, car_class, average_position, race_count
from 
(
	select 
		cars."name" as car_name,
		cars."class" as car_class,
		avg(results."position") as average_position,
		count(results.*) as race_count,
		ROW_NUMBER() OVER (PARTITION BY cars.class ORDER BY AVG(results.position)) AS rank
	from cars
	join results on results.car = cars."name" 
	group by cars."class", cars."name"
)
where rank = 1
order by average_position;