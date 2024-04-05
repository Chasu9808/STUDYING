--employees
--1. �μ���ȣ�� 80���� ū �μ���
--������̵�, firstname, �Ŵ��� ���̵� ���
select * from employees;

select employee_id, first_name �̸�ù����, manager_id �Ŵ������̵�
from employees
where department_id > 80;

--2. �μ���ȣ�� 80���� ū �μ��� ������̵�, firstname, �Ŵ��� �̸� ���

select e1.employee_id ������̵�, e1.first_name �̸�ù����, e2.first_name "�Ŵ��� �̸�"
from employees e1, employees e2
where e1.manager_id = e2.employee_id
and e1.department_id > 80;

--3. Donald�� ���� ������ �޴� ����� ���̵�,�̸�,���� ���

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

--4. Donald �Ի����� �����ϰų� �ʰ� �Ի��� ����� ���̵�,�޿�,�Ի��� ���
select * from employees;

select employee_id ���, salary �޿�, hire_date �Ի���,first_name �̸�
from employees
where hire_date >= (
                        select hire_date
                        from employees
                        where first_name = 'Donald'
                    )
order by hire_date desc;

--5. �μ���ȣ�� 100���� �μ��� ��ձ޿����� ���̹޴� ����� �̸��� �޿����
select first_name || last_name �̸�, salary �޿�
from employees
where salary > (
                    select avg(nvl(salary,0))
                    from employees
                    where department_id = 100
                );
                
----
--1. sal_history(empid,hiredate,sal) ���̺� ����µ� employees �̿��Ͽ� ������ ����
select * from employees;
create table sal_history
as select employee_id empid,hire_date hiredate,salary sal from employees
where 0<>0;

--2. mgr_history(empid,mgr,sal) ���̺� ����µ� employees �̿��Ͽ� ������ ����
select * from employees;
create table mgr_history
as select employee_id empid,manager_id mgr,salary sal from employees
where 0<>0;

-- 3. employee_id�� 200���� ū �����͸�
-- ���� sal_history�� mgr_history�� ������ �ֱ�
-- ���Ǿ��� insert(unconditional insert)

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

-- 4. employee_id�� 200���� ū ������ �߿��� sal > 10,000�̸� sal_history
-- mgr�� 200���� ũ�� mgr_history ������ ����
-- �����ִ� insert(conditional insert)

insert all 
when sal > 10000 then
into sal_history values(empid,hiredate,sal)
when mgr > 200 then
into mgr_history values(empid, mgr, sal)
select employee_id empid, hire_date hiredate ,salary sal,manager_id mgr
from employees
where employee_id >200;
commit;

--11�� Ʈ�����
-- Ʈ����� : �� �̻� ���� �� �� ���� �ּ� ���� ������
--          �ѹ��� �����Ͽ� �۾��� �Ϸ��ϰų� ��� �������� �ʰų�
--          all or nothing(commit, rollback)
--          tcl tranjaction control language 

--p298 �б� �ϰ���
-- �ݸ�����
-- ORACLE : read commited
-- mysql : repeatable commited

