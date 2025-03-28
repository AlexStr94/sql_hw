-- Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей, и вывести информацию об 
-- этом автомобиле, включая его класс, среднюю позицию, количество гонок, в которых он участвовал, и страну производства 
-- класса автомобиля. Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту 
-- (по имени автомобиля).

select 
	cars."name" as car_name,
	cars."class" as car_class,
	avg(results."position") as average_position,
	count(results.*) as race_count,
	classes.country 
from cars
join classes on classes."class" = cars."class" 
join results on results.car = cars."name" 
group by cars."class", cars."name", classes.country 
order by average_position, car_name
limit 1;