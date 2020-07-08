
--------------------------------------
-- employee 
--
create table employee (
  id   number(19,1),
  leader_id number(19,1),
  name varchar2(1000)
);

insert into employee(id,leader_id,name) values (1,12,'Martin Holy');
insert into employee(id,leader_id,name) values (2,1,'JJ');
insert into employee(id,leader_id,name) values (3,1,'Zdenek Silhan');
insert into employee(id,leader_id,name) values (4,12,'Dusan Juhas');
insert into employee(id,leader_id,name) values (5,4,'Jan Rabusic');
insert into employee(id,leader_id,name) values (6,4,'Adam Bohac');
insert into employee(id,leader_id,name) values (7,4,'Martin Ponocny');
insert into employee(id,leader_id,name) values (8,12,'Jan Cerny');
insert into employee(id,leader_id,name) values (9,8,'Jakub Hlavaty');
insert into employee(id,leader_id,name) values (10,8,'Michal Berkovec');
insert into employee(id,leader_id,name) values (11,8,'David Kacetl');
insert into employee(id,leader_id,name) values (12,null,'Sabinka');

commit;



-------------------------------------------
-- (1) show hiearchy
select lpad(' ',2*(level-1)) || employee.name  s 
  from employee 
  start with employee.leader_id is null
  connect by prior employee.id = employee.leader_id;



-------------------------------------------
-- create cycle on Sabinka
update employee set leader_id = 11 where id = 12;
commit;
select * from employee;



-- start form sabinka, 
select lpad(' ',2*(level-1)) || employee.name  s 
  from employee 
  start with employee.id=12
  connect by prior employee.id = employee.leader_id;


-- remove loop
update employee set leader_id = null where id = 12;
commit;






-----------------------------------------------
-- (2) recursion by "recursion_relation"
-- 
with recursion_relation(id, leader_id, name, hierarchy_level) as (
  select emp.id, emp.leader_id, emp.name, 0 from employee emp where emp.id = 12
  union all
  select emp.id, emp.leader_id, emp.name, rr.hierarchy_level+1 from employee emp, recursion_relation rr
  where emp.leader_id = rr.id
)
select * from recursion_relation;


drop table employee;
