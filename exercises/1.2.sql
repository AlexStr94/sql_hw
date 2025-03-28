-- Найти информацию о производителях и моделях различных типов транспортных средств (автомобили, мотоциклы и велосипеды), которые соответствуют заданным критериям.

-- Автомобили:
-- Извлечь данные о всех автомобилях, которые имеют:

-- Мощность двигателя более 150 лошадиных сил.
-- Объем двигателя менее 3 литров.
-- Цену менее 35 тысяч долларов.
-- В выводе должны быть указаны производитель (maker), номер модели (model), мощность (horsepower), объем двигателя (engine_capacity) и тип транспортного средства, который будет обозначен как Car.

-- Мотоциклы:
-- Извлечь данные о всех мотоциклах, которые имеют:

-- Мощность двигателя более 150 лошадиных сил.
-- Объем двигателя менее 1,5 литров.
-- Цену менее 20 тысяч долларов.
-- В выводе должны быть указаны производитель (maker), номер модели (model), мощность (horsepower), объем двигателя (engine_capacity) и тип транспортного средства, который будет обозначен как Motorcycle.

-- Велосипеды:
-- Извлечь данные обо всех велосипедах, которые имеют:

-- Количество передач больше 18.
-- Цену менее 4 тысяч долларов.
-- В выводе должны быть указаны производитель (maker), номер модели (model), а также NULL для мощности и объема двигателя, так как эти характеристики не применимы для велосипедов. Тип транспортного средства будет обозначен как Bicycle.

-- Сортировка:
-- Результаты должны быть объединены в один набор данных и отсортированы по мощности в порядке убывания. Для велосипедов, у которых нет значения мощности, они будут располагаться внизу списка.

select * from (
	select v.maker, c.model, c.horsepower, c.engine_capacity, v."type" as vehicle_type from car c 
	join vehicle v on v.model = c.model
	where c.horsepower > 150 and c.engine_capacity < 3 and c.price < 35000
	union
	select v.maker, m.model, m.horsepower, m.engine_capacity, v."type" as vehicle_type from motorcycle m 
	join vehicle v on v.model = m.model
	where m.horsepower > 150 and m.engine_capacity < 1.5 and m.price < 20000
	union
	select v.maker, b.model, null as horsepower, null as engine_capacity, v."type" as vehicle_type from bicycle b
	join vehicle v on v.model = b.model
	where b.gear_count > 18 and b.price < 4000
)
order by horsepower desc nulls last