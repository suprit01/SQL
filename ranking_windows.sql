create database company ;
use company;
create table emp (
emp_id int ,
emp_name varchar(40),
dept_id int ,
salary int 
);
insert into emp (emp_id,emp_name,dept_id,salary) values (1, 'sheop',100,10000),
(2, 'polp',100,15000),
(3,'olyu',100,10000),
(4, 'danny',100,5000),
(5, 'hari',100,12000),
(6, 'casw',200,12000),
(7, 'hkiip',200,9000),
(8,'elop',200,5000),
(9, 'vini',200,2000),
(10,'rodry',200,20000);
-- Rank     Dense Rank    row number
select emp_id ,emp_name ,dept_id,salary
,rank() over(order by salary desc) as rnk,
dense_rank() over(order by salary desc) as dense_rnk,
row_number() over(order by salary desc) as row_num  from emp ;


--  Dense rank
select emp_id ,emp_name ,salary
,dense_rank() over(order by salary desc) as dense_rnk from emp ;


-- Dept wise salary
select emp_id ,emp_name ,dept_id,salary,
rank() over(partition by dept_id order by salary desc) as dept_rnk from emp ;


-- Top employeee by salary dept wise


with cte as(
select emp_id ,emp_name ,dept_id ,salary,
rank() over(partition by dept_id order by salary desc) as dept_rnk from emp )
-- select * from cte;
select * from cte
where dept_rnk= 1
order by dept_id;


select * from emp;



create table emp2(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp2
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp2
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp2
values (3, 'Vikas', 100, 10000,4,37);
insert into emp2
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp2
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp2
values (6, 'Agam', 200, 12000,2, 14);
insert into emp2
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp2
values (8, 'Ashish', 200,5000,2,12);
insert into emp2
values (9, 'Mukesh',300,6000,6,51);
insert into emp2
values (10, 'Rakesh',300,7000,6,50);

-- Union and union all

select dept_id from emp
union all
select  department_id from emp2;

