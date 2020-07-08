----------------------------------------------------
-- Analytic functions
-----------------------------------------------------

select emp.dep_id, count(*) EMP_PEER_DEP_CNT 
from employee emp 
GROUP BY emp.dep_id;



SELECT emp.dep_id, COUNT(*) over (partition by emp.dep_id) 
FROM employee emp;




SELECT emp.dep_id, COUNT(*) over () 
FROM employee emp;





------------------------------
-- ordering in pratition 

-- row_number
-- rank
-- dense_rank

SELECT emp.*, 
       ROW_NUMBER() over (partition by emp.dep_id order by emp.birth_date) ROW_NUMBER,
       dense_rank() over (partition by emp.dep_id order by emp.birth_date) dense_rank,
       rank()       over (partition by emp.dep_id order by emp.birth_date) rank
FROM employee emp
order by emp.dep_id, emp.birth_date;





--------------------------------
-- statistic in partition
-- SUM, AVG, MIN, MAX - no order is nescessary
SELECT emp.*, 
       SUM(emp.salary)       over (partition by emp.dep_id )  sum_salary,
       trunc(AVG(emp.salary) over (partition by emp.dep_id )) AVG,
       MIN(emp.salary)       over (partition by emp.dep_id )  MIN,
       MAX(emp.salary)       over (partition by emp.dep_id )  MAX
FROM employee emp
order by emp.dep_id, emp.birth_date;






----------------------------
-- FIRST_VALUE, (LAST_VALUE)
-- find the highest and the lowest value in group
select emp.*,
       FIRST_VALUE(emp.salary) over (partition by emp.dep_id order by emp.salary)       lowest_salary_in_dep,
       FIRST_VALUE(emp.salary) over (partition by emp.dep_id order by emp.salary desc)  higest_salary_in_dep,
       trunc (emp.salary*100 / FIRST_VALUE(emp.salary) over (partition by emp.dep_id order by emp.salary desc))||'%' ratio_in_dep 
  FROM employee emp       
  order by emp.dep_id, emp.salary;







----------------------------
-- LEAD and LAG
-- access to record before/next
-- you can say offset, default
select emp.*,
       LAG(emp.name||' ('||emp.salary||')',1,'nobody') over (partition by emp.dep_id order by emp.salary)        first_poor_in_dep,
       LEAD(emp.name||' ('||emp.salary||')',1,'nobody') over (partition by emp.dep_id order by emp.salary)       first_rich_in_dep
  FROM employee emp       
  order by emp.dep_id, emp.salary;





-----------------------------------------
-- Vsimnete si, no foreign key
--ALTER TABLE department ADD UNIQUE (id);
--ALTER TABLE employee ADD FOREIGN KEY (dep_id) REFERENCES department(id);

drop table employee2salary_category;
drop view salary_category;
drop table employee;
drop table department;
drop sequence department_seq;
