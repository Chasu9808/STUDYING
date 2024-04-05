--employees
--1. 부서번호가 80보다 큰 부서의
--사원아이디, firstname, 매니저 아이디 출력
select * from employees;

select employee_id, first_name 이름첫글자, manager_id 매니저아이디
from employees
where department_id > 80;

--2. 부서번호가 80보다 큰 부서의 사원아이디, firstname, 매니저 이름 출력

select e1.employee_id 사원아이디, e1.first_name 이름첫글자, e2.first_name "매니저 이름"
from employees e1, employees e2
where e1.manager_id = e2.employee_id
and e1.department_id > 80;

--3. Donald와 같은 연봉을 받는 사람의 아이디,이름,연봉 출력

select salary
from employees
where first_name = 'Donald';

select employee_id, first_name, salary
from employees
where salary = (
                select salary
                from employees
                where first_name = 'Donald'
);

--4. Donald 입사일이 동일하거나 늦게 입사한 사람의 아이디,급여,입사일 출력
select * from employees;

select employee_id 사번, salary 급여, hire_date 입사일,first_name 이름
from employees
where hire_date >= (
                        select hire_date
                        from employees
                        where first_name = 'Donald'
                    )
order by hire_date desc;

--5. 부서번호가 100번인 부서의 평균급여보다 많이받는 사원의 이름과 급여출력
select first_name || last_name 이름, salary 급여
from employees
where salary > (
                    select avg(nvl(salary,0))
                    from employees
                    where department_id = 100
                );
                
----
--1. sal_history(empid,hiredate,sal) 테이블 만드는데 employees 이용하여 구조만 생성
select * from employees;
create table sal_history
as select employee_id empid,hire_date hiredate,salary sal from employees
where 0<>0;

--2. mgr_history(empid,mgr,sal) 테이블 만드는데 employees 이용하여 구조만 생성
select * from employees;
create table mgr_history
as select employee_id empid,manager_id mgr,salary sal from employees
where 0<>0;

-- 3. employee_id가 200보다 큰 데이터를
-- 각각 sal_history와 mgr_history에 데이터 넣기
-- 조건없는 insert(unconditional insert)

insert into sal_history
select employee_id empid, hire_date hiredate ,salary sal
from employees
where employee_id >200;

select * from sal_history;

rollback;

insert all 
into sal_history values(empid,hiredate,sal)
into mgr_history values(empid, mgr, sal)
select employee_id empid, hire_date hiredate ,salary sal,manager_id mgr
from employees
where employee_id >200;

select * from sal_history;
select * from mgr_history;

-- 4. employee_id가 200보다 큰 데이터 중에서 sal > 10,000이면 sal_history
-- mgr이 200보다 크면 mgr_history 데이터 기입
-- 조건있는 insert(conditional insert)

insert all 
when sal > 10000 then
into sal_history values(empid,hiredate,sal)
when mgr > 200 then
into mgr_history values(empid, mgr, sal)
select employee_id empid, hire_date hiredate ,salary sal,manager_id mgr
from employees
where employee_id >200;
commit;

--11장 트랜잭션
-- 트랜잭션 : 더 이상 분할 할 수 없는 최소 수행 단위로
--          한번에 수행하여 작업을 완료하거나 모두 수행하지 않거나
--          all or nothing(commit, rollback)
--          tcl tranjaction control language 

--p298 읽기 일관성
-- 격리수준
-- ORACLE : read commited
-- mysql : repeatable commited

