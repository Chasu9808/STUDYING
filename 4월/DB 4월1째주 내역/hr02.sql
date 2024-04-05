--employees
--1. 부서번호가 80보다 큰 부서의 사원아이디, firstname, 매니저 아이디 출력
select * from employees;
select employee_id 사원아이디, first_name firstname, manager_id "매니저 아이디"
from employees
where department_id > 80;

--2. 부서번호가 80보다 큰 부서의 사원아이디, firstname, 매니저 이름 출력
select e1.employee_id 사원아이디, e1.first_name firstname, e2.first_name "매니저 이름"
from employees e1, employees e2
where e1.manager_id  = e2.employee_id and e1.department_id > 80;

select e1.employee_id 사원아이디, e1.first_name firstname, e2.first_name "매니저 이름"
from employees e1, employees e2
where e1.manager_id  = e2.employee_id and e1.department_id > 80;

--3. Donald 같은 연봉을 받는 사람의 아이디, 이름, 연봉 출력
select salary
from employees
where first_name ='Donald';

select employee_id, first_name, salary
from employees
where salary = (
        select salary
        from employees
        where first_name ='Donald'
);
--4.Donald 입사일이 동일하거나 늦게 입사한 사람의 아이디, 급여, 입사일 출력
select hire_date
from employees
where first_name ='Donald';

select employee_id,  salary, hire_date
from employees
where hire_date >= (
        select hire_date
        from employees
        where first_name ='Donald'
);
--5. 부서번호가 100인 부서의 평균 급여보다 많은 급여를 받는 사원의 이름과 급여 출력
select first_name, salary from employees where department_id = 100;

select first_name, salary
from employees
where salary > (select avg(nvl(salary,0))
                from employees
                where  department_id = 100
                );
 ------
 --1. sal_history(empid, hiredate,sal) 테이블 만드는데 employees 이용하여 구조만 생성
 select * from employees;
 
 create table sal_history
 as select employee_id, hire_date,salary
 from employees;
 
 select * from sal_history;
 drop table sal_history;
 -- 구조만 복사  empid, hiredate,sal
 create table sal_history
 as select employee_id, hire_date,salary
 from employees
 where 1=2;
 
 drop table sal_history;
 
 create table sal_history
 as select employee_id as  empid , hire_date as  hiredate,salary as sal
 from employees
 where 1=2;
 
 --2.mgr_history(empid, mgr,sal) 테이블 만드는데 employees 이용하여 구조만 생성  
 create table mgr_history
 as select employee_id as  empid , manager_id as  mgr,salary as sal
 from employees
 where 1=2;
 select * from mgr_history;
--3.employee_id 가 200보다 큰 데이터를  sal_history 에 데이터 넣기
insert into sal_history 
select employee_id empid, hire_date hiredate, salary sal
from employees
where employee_id>200;

rollback;
select * from sal_history;

 --3.employee_id 가 200보다 큰 데이터를 
 --각각 sal_history 와 mgr_history에 데이터 넣기
 --조건없는 insert(unconditional insert)
insert all
into sal_history values(empid,hiredate,sal)
into mgr_history values(empid, mgr, sal)
select employee_id empid, hire_date hiredate, salary sal, manager_id mgr
from employees
where employee_id>200;

select * from sal_history;
select * from mgr_history;

delete from sal_history;
delete from mgr_history;
commit;

 --4.employee_id 가 200보다 큰 데이터 중에서 sal 이 10000보다 크면 sal_history
 -- mgr이 200 보다 크면  mgr_history에 데이터 넣기
 --조건있는 insert(conditional insert)
insert all
when sal >10000  then
            into sal_history values(empid,hiredate,sal)
when mgr > 200 then            
            into mgr_history values(empid, mgr, sal)
select employee_id empid, hire_date hiredate, salary sal, manager_id mgr
from employees
where employee_id>200;
commit;

select * from sal_history;
select * from mgr_history;
 
 




