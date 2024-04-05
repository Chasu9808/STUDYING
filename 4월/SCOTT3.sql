--p266
-- dml = data�� �߰��� ����, �����ϴ� ������ ���۾�
-- ddl = ��ü�� ����,����,�����ϴ� ������ ���Ǿ� (p311)

-- test1(no,name,address,tel)
--number(5), ���ڿ�(20), ���ڿ�(50), ���ڿ�(20)

create table test1(
    no number(5), 
    name varchar2(20), 
    address varchar2(50),
    tel varchar2(20)
);

select * from test1;

--(1,'aaa')�߰�(no, name)

insert into test1(no,name) values(1,'aaa');

select * from test1;

--(2,'bbb','�λ�','010-1111-2222')

insert into test1(no,name,address,tel) values(2,'bbb','�λ�','010-1111-2222');

--(3,'ccc','�λ�','010-1111-2222')

insert into test1(no,name,address,tel) values(3,'ccc','�λ�','010-1111-2222');

--(4,'ddd','����')
insert into test1(no,name,address) values(4,'ddd','����');
commit;

create table dept_temp
as select * from dept;

--�̸� ȫ�浿���� ���� 2������
update test1 set name = 'ȫ�浿'
where no=2;

-- �̸� test �ּ� ���� 4������
update test1 set name='test', address='����'
where no=4;

-- ����
-- test1 ���� 1������
delete test1
where no=1;

delete test1
where no=2;

select * from test1;
commit;

delete from test1;

create table test (
                no number(3) default 0,
                name varchar2(20) default 'no name',
                hiredate date default sysdate
                );
select * from test;

insert into test(no,name) values(1,'ȫ�浿');
insert into test(hiredate) values('24/03/30');

--test���� ��ȣ�� 1���� ����� �̸��� ���������� ����

update test set name = '������'
where no=1;
select * from test;

--test���� ��ȣ�� 0�ΰ��� �����ϰ�
--��ȣ�� 2�� �����͸� �߰��ϱ�

delete from test
where no=0;

insert into test(no,name) values (2,'�ϴú���');
select * from test;
commit;

--------
--CRUD(CREATE, READ(SELECT), UPDATE, DELETE)
--P266 (CTAS: CREATE TABLE AS SELECT) �������̺��� �������� ���� ���̺�

-------------------------
select * from dept_temp;
dept_temp ���̺� 50,database,seoul �߰�
insert into dept_temp values (50,'database','seoul');

--���̺� ������ ����
create table emp_temp
as select * from emp
where 1<>1;

select * from emp_temp;

--emp_temp (2111,'�̼���','MANAGER',9999,'07/01/2019',4000,null,20)�߰�
insert into emp_temp 
values (2111,'�̼���','MANAGER',9999,
TO_DATE('07/01/2019','DD/MM/YYYY'),4000,null,20);

--(3111,'������,'MANAGER',9999,4000,NULL,20) �Ի����� ���÷� �߰�
insert into emp_temp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (3111,'','MANAGER',9999,sysdate,4000,null,20);

select * from emp_temp;
commit;

--�����ȣ�� 3111���� ����� �޿��� 5000���� ����
update emp_temp set sal = 5000
where empno=3111;

select * from emp_temp;
delete from emp_temp;

--P275 ���������� ����Ͽ� �� ���� ���� ������ �߰� (values ������� �ʴ´�.)
--�޿����(salgrade)�� 1�� ����� emp_temp�� �߰�
select * from salgrade;
insert into emp_temp(empno, ename, job, mgr, hiredate, sal, comm, deptno)
select e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,e.deptno
from emp e, salgrade s
where e.sal between s.losal and s.hisal and s.grade =1;

commit;

--dept ���̺��� �����Ͽ� dept_temp 2���̺��� �����Ͽ� 
--40�� �μ����� DATABASE ������ SEOUL�� ����

CREATE TABLE DEPT_TEMP2
AS SELECT * FROM DEPT;

SELECT * FROM DEPT_TEMP2;

UPDATE DEPT_TEMP2 SET DNAME='DATABASE', LOC='SEOUL'
WHERE DEPTNO = 40;

SELECT * FROM DEPT_TEMP2;
---
SELECT * FROM EMP_TEMP;

--7900�� �̸��� ���������� ����
UPDATE EMP_TEMP SET ENAME = 'JAMES'
WHERE EMPNO = 7900;
COMMIT;

--DEPT_TEMP2���̺��� 40�� ���� ����
--DEPT ���̺��� 40���� ������ �μ���� �������� ����

SELECT * FROM DEPT_TEMP2;

SELECT DNAME, LOC 
FROM DEPT
WHERE DEPTNO = 40;

UPDATE DEPT_TEMP2 SET(DNAME,LOC)=
(
    SELECT DNAME, LOC 
    FROM DEPT   
    WHERE DEPTNO = 40
)
WHERE DEPTNO = 40;

SELECT * FROM DEPT_TEMP2;

update dept_temp2 
set dname = (select dname from dept where deptno=40) ,
    loc = (select loc from dept where deptno = 40)
where deptno = 40;
commit;

--dept_temp2 ��� ������ ����

delete from dept_temp2;
select * from dept_temp2;
drop table dept_temp2;

-- dept ���̺��� �̿��Ͽ� dept_tmp ���̺� �����ϱ�
create table dept_tmp
as select * from dept;

select * from dept_tmp;

-- dept_tmp ���̺� location �÷��߰�
alter table dept_tmp
add(location varchar2(50));

select * from dept_tmp;

--10�� �μ��� location�� �������� ����
update dept_tmp set location = '����'
where deptno = 10;

--�÷� ���� ����
alter table dept_tmp modify(location varchar2(70));

--���̺� ����Ȯ��
desc dept_tmp;

alter table dept_tmp drop column location;
commit;
select * from dept_tmp;

--loc�� location���� ����
alter table dept_tmp rename column loc to location;

--���̺� �� ����
rename dept_tmp to dept_tmptmp;

select * from dept_tmptmp;

--������ ��ü ����
delete from dept_tmptmp;

--������ COMMIT �������� ��Ȳ���θ�  ������ ����
rollback;
--��ü ������ ����
select * from dept_tmptmp;
truncate table dept_tmptmp; --rollback �Ұ���

--���̺� ���� �����Ұ�
drop table dept_tmptmp;

-- 9�� �������� 262p

-- ��ü ����� ALLEN�� ���� ��å�� ������� �������, �μ������� ������ ����
-- ����ϼ���

SELECT JOB,EMPNO,ENAME,SAL,E.DEPTNO,DNAME
FROM EMP E,DEPT D
WHERE JOB = (
                SELECT JOB
                FROM EMP
                WHERE ENAME = 'ALLEN'
                )
                AND E.DEPTNO=D.DEPTNO
                ;
 
-- ��ü ����� ��� �޿�(SAL)���� ���� �޿��� �޴� ������� �������,
-- �μ�����,�޿���� ������ ����ϴ� SQL�� �ۼ� 

SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;

SELECT EMPNO,ENAME,DNAME,TO_CHAR(HIREDATE,'YYYY-MM-DD') HIREDATE
,LOC,SAL,GRADE
FROM EMP E,DEPT D, SALGRADE S
WHERE E.DEPTNO = D.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL
AND E.SAL > (
            SELECT AVG(SAL)
            FROM EMP
            )
ORDER BY SAL DESC,E.EMPNO;

--10���� �ٹ��ϴ� ��� �� 30�� �μ����� �������� �ʴ� ��å�� ���� �������
--�������,�μ� ������ ������ ���� ����ϴ� SQL���� �ۼ��ϼ���

SELECT EMPNO,ENAME,E.DEPTNO,DNAME,LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND E.DEPTNO = 10 
AND JOB NOT IN (
                    SELECT JOB
                    FROM EMP
                    WHERE DEPTNO=30
                );

--��å�� SALESMAN�� ������� �ְ� �޿����� ���� �޿��� �޴� ������� �������
--�޿����, ������ ������ ���� ����ϴ� SQL���� �ۼ�

--������ �Լ� ���X
SELECT E.EMPNO,E.ENAME,E.SAL,S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > (
                SELECT MAX(SAL)
                FROM EMP
                WHERE JOB = 'SALESMAN');
                
--������

SELECT E.EMPNO,E.ENAME,E.SAL,S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > ALL(
                SELECT (SAL)
                FROM EMP
                WHERE JOB = 'SALESMAN')
                ORDER BY E.EMPNO;
                
--���̺� ����
CREATE TABLE CHAP10HW_EMP AS SELECT * FROM EMP;
CREATE TABLE CHAP10HW_DEPT AS SELECT * FROM DEPT;
CREATE TABLE CHAP10HW_SALGRADE AS SELECT * FROM SALGRADE;

--1
INSERT INTO CHAP10HW_DEPT (DEPTNO,DNAME,LOC) 
SELECT 50,'ORACLE','BUSAN' FROM DUAL UNION ALL
SELECT 60,'SQL','ILSAN' FROM DUAL UNION ALL
SELECT 70,'SELECT','INCHEON' FROM DUAL UNION ALL
SELECT 80,'DML','BUNDANG' FROM DUAL; 

SELECT * FROM CHAP10HW_EMP;

--2
INSERT INTO CHAP10HW_EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
SELECT 7201,'TEST_USER1','MANAGER',7788,'2016-01-02',4500,NULL,50 from dual union all
SELECT 7202,'TEST_USER2','CLERK',7201,'2016-02-21',1800,NULL,50 from dual union all
SELECT 7203,'TEST_USER3','ANALYST',7201,'2016-04-11',3400,NULL,60 from dual union all
SELECT 7204,'TEST_USER4','SALESMAN',7201,'2016-05-31',2700,300,60 from dual union all
SELECT 7205,'TEST_USER5','CLERK',7201,'2016-07-20',2600,NULL,70 from dual union all
SELECT 7206,'TEST_USER6','CLERK',7201,'2016-09-08',2600,NULL,70 from dual union all
SELECT 7207,'TEST_USER7','LECTURER',7201,'2016-10-28',2300,NULL,80 from dual union all
SELECT 7208,'TEST_USER8','STUDENT',7201,'2016-03-09',1200,NULL,80 from dual;

UPDATE CHAP10HW_EMP SET HIREDATE='2018-03-09'
WHERE EMPNO = 7208;
SELECT * FROM CHAP10HW_EMP;

--3
UPDATE CHAP10HW_EMP SET DEPTNO = 70
WHERE SAL > (
                    SELECT AVG(SAL)
                    FROM CHAP10HW_EMP
                    WHERE DEPTNO = 50
            );
            
UPDATE CHAP10HW_EMP SET SAL=SAL*1.1, DEPTNO = 80
WHERE HIREDATE > (
                        SELECT MIN(HIREDATE)
                        FROM CHAP10HW_EMP
                        WHERE DEPTNO = 60
                    );

ROLLBACK;
SELECT * FROM CHAP10HW_EMP;
COMMIT;

--CHAP10HW_EMP�� ���� ��� �� �޿� ����� 5�� ����� �����ϴ� SQL
SELECT * FROM CHAP10HW_EMP
WHERE SAL = ANY (
                        SELECT SAL
                        FROM CHAP10HW_EMP c, salgrade s
                        WHERE c.sal between s.losal and s.hisal
                        and s.grade = 5);
                        
DELETE FROM CHAP10HW_EMP
WHERE SAL IN (SELECT SAL
                FROM CHAP10HW_EMP c, CHAP10HW_SALGRADE s
                WHERE c.sal between s.losal and s.hisal
                and s.grade = 5);

COMMIT;

--1. emp ���̺� �����
create table emp_hw
(empno number(4), 
 ename varchar2(10), 
 job varchar2(9),
 mgr number(4),
 hiredate date, 
 sal number(7,2), 
 comm number(7,2),
 deptno number(2)
 );
 select * from emp_hw;
 
 --2 BIGO �� �߰�
 alter table emp_hw
 add BIGO varchar2(20);
 
 --3 BIGO �� ����
 alter table emp_hw
 modify BIGO varchar2(30);
 
 --4 BIGO�� �̸��� REMARK�� ����
 alter table emp_hw
 rename column BIGO to REMARK;
 
 --5 EMP_HW ���̺� EMP ���̺� �����͸� �����ϰ� REMARK ���� NULL�� ����
 INSERT INTO EMP_HW(EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
 SELECT *
 FROM EMP;
 
DELETE FROM EMP_HW;
 
 
