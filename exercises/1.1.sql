-- Найдите производителей (maker) и модели всех мотоциклов, которые имеют мощность более 150 лошадиных сил, 
-- стоят менее 20 тысяч долларов и являются спортивными (тип Sport).
-- Также отсортируйте результаты по мощности в порядке убывания.

select v.maker, m.model from motorcycle m 
join vehicle v on v.model = m.model 
where m.horsepower > 150 and m.price < 20000 and m."type" = 'Sport'
order by horsepower desc