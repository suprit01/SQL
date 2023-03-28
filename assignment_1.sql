use practice;
create table kvcompany(emp_id int,person varchar(40),address varchar(40));
desc kvcompany;
alter table kvcompany add column emp_salary int;
alter table kvcompany add column dept_work varchar(40);
select *from kvcompany;
insert into kvcompany (emp_id,person,address,emp_salary,dept_work) values
( 101,'ganesh','Maharashtra',30000,'R&D'),
( 102,'ash','UP',80000,'finance'),
( 103,'kia','Maharahtra',69000,'operation'),
( 104,'amol','MP',39000,'training'),
( 105,'VK','Chennai',50000,'account'),
( 106,'vikas','Banglore',45000,'finance');



drop table kvcompany;

select * from kvcompany where emp_salary between 30000 and 75000;
select*from kvcompany where (emp_salary<52000);
select* from kvcompany where person like 'a%';
select *from kvcompany where (emp_id=101 && dept_work='R&D');
select*from kvcompany where address ='Maharashtra' ;