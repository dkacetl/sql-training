------------------------------------
-- department
--
create table department (
  id   number(19,1),
  name varchar2(1000)
);

-------------------------------------
-- inserts, lots of posibilites
-------------------------------------
insert into department(id,name) values (1,'ICT');
insert into department(id,name) values ((select count(*)+1 from department),'AppDev');
insert into department(id,name) select max(id)+1,'PlatfromDev' from department;
create sequence department_seq start with 4 increment by 1 nocache nocycle;
insert into department(id,name) values (department_seq.nextval,'Marketing');

select * from department;

--------------------------------------
-- employee 
--
create table employee (
  id   number(19,1),
  dep_id number(19,1),
  name varchar2(1000),
  birth_date date,
  salary number(19,0)
);

insert into employee(id,dep_id,name,birth_date,salary) values (1,1,'Martin Holy',to_date('25.4.1980','dd.mm.yyyy'),60000);
insert into employee(id,dep_id,name,birth_date,salary) values (2,1,'JJ',to_date('15.2.1987','dd.mm.yyyy'),30000);
insert into employee(id,dep_id,name,birth_date,salary) values (3,1,'Zdenek Silhan',to_date('1.10.1983','dd.mm.yyyy'),40000);
insert into employee(id,dep_id,name,birth_date,salary) values (4,2,'Dusan Juhas',to_date('30.6.1978','dd.mm.yyyy'),55000);
insert into employee(id,dep_id,name,birth_date,salary) values (5,2,'Jan Rabusic',to_date('24.12.1986','dd.mm.yyyy'),39000);
insert into employee(id,dep_id,name,birth_date,salary) values (6,2,'Adam Bohac',to_date('1.10.1983','dd.mm.yyyy'),1000);
insert into employee(id,dep_id,name,birth_date,salary) values (7,2,'Martin Ponocny',to_date('1.10.1983','dd.mm.yyyy'),42000);
insert into employee(id,dep_id,name,birth_date,salary) values (8,3,'Jan Cerny',to_date('30.6.1978','dd.mm.yyyy'),70000);
insert into employee(id,dep_id,name,birth_date,salary) values (9,3,'Jakub Hlavaty',to_date('24.12.1986','dd.mm.yyyy'),21000);
insert into employee(id,dep_id,name,birth_date,salary) values (10,3,'Michal Berkovec',to_date('1.10.1983','dd.mm.yyyy'),21000);
insert into employee(id,dep_id,name,birth_date,salary) values (11,3,'David Kacetl',to_date('1.10.1983','dd.mm.yyyy'),22000);
insert into employee(id,dep_id,name,birth_date,salary) values (12,4,'Sabinka',to_date('1.10.1983','dd.mm.yyyy'),70000);

commit;

-------------------------------------------
-- (1) all employees with SECOND highest salary

select * from employee order by salary desc;


-- select all arts of salary
(select salary from employee GROUP BY salary order by salary desc);


-- two highest salaries
select * from
(select salary from employee group by salary order by salary desc)
WHERE ROWNUM<=2;


-- second highest salary
select MIN(salary) from
(select salary from employee group by salary order by salary desc)
where rownum<=2;


-- (result) all employees with second highest salary
select * from employee
WHERE SALARY = 
 (select min(t.salary) from (select salary from employee group by salary order by salary desc) t
  where rownum <= 2)
order by salary;




---------------------------------------
-- (2) jungest employees peer department
select * from employee e;
select * from department d;




-- jungest birth_date peer department
select e.dep_id, MAX(e.birth_date) max_birth_date
from employee e
GROUP BY (e.dep_id);




---------------------------------------
-- (result) jungest employee in department 
select d.name deparment,e.name employee
FROM department d,  -- cartesian product (or join)
    ( select e.dep_id, max(e.birth_date) max_birth_date
      from employee e
      group by (e.dep_id)
    ) je,
    employee e
where d.id=je.dep_id 
      AND (je.max_birth_date = e.birth_date AND je.dep_id = e.dep_id); -- "2 column join"

-----------------------------
-- (3)
-- create report where employees are assigned to salary category (1 to 10000, 10001 to 20001...)
-- every category has unique id


-- define ids fo salary categories (id generator)
SELECT LEVEL num
FROM dual
CONNECT BY LEVEL <= 10;


-- define categories
SELECT LEVEL id, (level*10000)+1-10000 start_salary, (level*10000) stop_salary
FROM dual
CONNECT BY LEVEL <= 10;


-- better define categories (compute highest category)
SELECT LEVEL id, (level*10000)+1-10000 start_salary, (level*10000) stop_salary
FROM dual 
CONNECT BY LEVEL <= (select ((max(emp.salary)-1)/10000)+1 from employee emp);

-- create view
create view salary_category as
SELECT LEVEL id, (level*10000)+1-10000 start_salary, (level*10000) stop_salary
FROM dual 
CONNECT BY LEVEL <= (select ((max(emp.salary)-1)/10000)+1 from employee emp);




-------------------------------------------------
-- select aggregation employee to salary_category 
select emp.*,salary_category.id salary_category_id
from
  employee emp,
  salary_category
where 
  emp.salary >= salary_category.start_salary and emp.salary <= salary_category.stop_salary;



--------------------------------
-- create relation
create table employee2salary_category as
select emp.id emp_id, salary_category.id sc_id
from
  employee emp,
  salary_category
where 
  emp.salary >= salary_category.start_salary and emp.salary <= salary_category.stop_salary;




--------------------------------
-- (result)
select emp.name, emp.salary, sc.id salary_category
from 
  employee emp,
  employee2salary_category e2sc,
  salary_category sc
where   
  emp.id = e2sc.emp_id and e2sc.sc_id = sc.id
  and sc.id = 3;







