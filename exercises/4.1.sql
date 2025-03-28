-- Найти всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1), 
-- включая их подчиненных и подчиненных подчиненных. Для каждого сотрудника вывести следующую информацию:

-- EmployeeID: идентификатор сотрудника.
-- Имя сотрудника.
-- ManagerID: Идентификатор менеджера.
-- Название отдела, к которому он принадлежит.
-- Название роли, которую он занимает.
-- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце через запятую).
-- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце через запятую).
-- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

-- Требования:

-- Рекурсивно извлечь всех подчиненных сотрудников Ивана Иванова и их подчиненных.
-- Для каждого сотрудника отобразить информацию из всех таблиц.
-- Результаты должны быть отсортированы по имени сотрудника.
-- Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.

with recursive employee_hierarchy as (
	select e.employeeid as employeeid
	from employees e
	where e.employeeid = 1
	union all 
	select e.employeeid from employees e
	join employee_hierarchy eh on e.managerid = eh.employeeid
),
employee_projects as (
	select 
		e.employeeid as employeeid,
		STRING_AGG(DISTINCT p.projectname, ', ') AS projects
	from employees e
	join projects p on p.departmentid = e.departmentid 
	group by e.employeeid
), 
employee_tasks as (
	select 
		e.employeeid as employeeid,
		STRING_AGG(DISTINCT t.taskname, ', ') AS tasks 
	from employees e
	join tasks t on t.assignedto = e.employeeid 
	join projects p on t.projectid = p.projectid
	group by e.employeeid
)
select 
	e.employeeid as EmployeeID,
	e."name" as EmployeeName,
	e.managerid as ManagerID,
	d.departmentname as DepartmentName,
	r.rolename as RoleName,
	e_p.projects as ProjectNames,
	e_t.tasks as TaskNames
from employees e 
join departments d on e.departmentid = d.departmentid 
join roles r on r.roleid = e.roleid 
left join employee_projects e_p on e_p.employeeid = e.employeeid 
left join employee_tasks e_t on e_t.employeeid = e.employeeid 
where e.employeeid in (select employeeid from employee_hierarchy)
order by e."name" 

