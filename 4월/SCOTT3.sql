--p266
-- dml = data를 추가나 수정, 삭제하는 데이터 조작어
-- ddl = 객체를 생성,변경,삭제하는 데이터 정의어 (p311)

-- test1(no,name,address,tel)
--number(5), 문자열(20), 문자열(50), 문자열(20)

create table test1(
    no number(5), 
    name varchar2(20), 
    address varchar2(50),
    tel varchar2(20)
);

select * from test1;

--(1,'aaa')추가(no, name)

insert into test1(no,name) values(1,'aaa');

select * from test1;

--(2,'bbb','부산','010-1111-2222')

insert into test1(no,name,address,tel) values(2,'bbb','부산','010-1111-2222');

--(3,'ccc','부산','010-1111-2222')

insert into test1(no,name,address,tel) values(3,'ccc','부산','010-1111-2222');

--(4,'ddd','서울')
insert into test1(no,name,address) values(4,'ddd','서울');
commit;

create table dept_temp
as select * from dept;

--이름 홍길동으로 수정 2번조건
update test1 set name = '홍길동'
where no=2;

-- 이름 test 주소 서울 4번조건
update test1 set name='test', address='서울'
where no=4;

-- 삭제
-- test1 에서 1번삭제
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

insert into test(no,name) values(1,'홍길동');
insert into test(hiredate) values('24/03/30');

--test에서 번호가 1번인 사람의 이름을 강감찬으로 수정

update test set name = '강감찬'
where no=1;
select * from test;

--test에서 번호가 0인것을 삭제하고
--번호가 2인 데이터를 추가하기

delete from test
where no=0;

insert into test(no,name) values (2,'하늘보리');
select * from test;
commit;

--------
--CRUD(CREATE, READ(SELECT), UPDATE, DELETE)
--P266 (CTAS: CREATE TABLE AS SELECT) 기존테이블을 기준으로 만든 테이블

-------------------------
select * from dept_temp;
dept_temp 테이블에 50,database,seoul 추가
insert into dept_temp values (50,'database','seoul');

--테이블 구조만 복사
create table emp_temp
as select * from emp
where 1<>1;

select * from emp_temp;

--emp_temp (2111,'이순신','MANAGER',9999,'07/01/2019',4000,null,20)추가
insert into emp_temp 
values (2111,'이순신','MANAGER',9999,
TO_DATE('07/01/2019','DD/MM/YYYY'),4000,null,20);

--(3111,'강감찬,'MANAGER',9999,4000,NULL,20) 입사일은 오늘로 추가
insert into emp_temp (empno,ename,job,mgr,hiredate,sal,comm,deptno)
values (3111,'','MANAGER',9999,sysdate,4000,null,20);

select * from emp_temp;
commit;

--사원번호가 3111번인 사원의 급여를 5000으로 수정
update emp_temp set sal = 5000
where empno=3111;

select * from emp_temp;
delete from emp_temp;

--P275 서브쿼리를 사용하여 한 번에 여러 데이터 추가 (values 사용하지 않는다.)
--급여등급(salgrade)이 1인 사원만 emp_temp에 추가
select * from salgrade;
insert into emp_temp(empno, ename, job, mgr, hiredate, sal, comm, deptno)
select e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,e.deptno
from emp e, salgrade s
where e.sal between s.losal and s.hisal and s.grade =1;

commit;

--dept 테이블을 복사하여 dept_temp 2테이블을 생성하여 
--40번 부서명을 DATABASE 지역을 SEOUL로 수정

CREATE TABLE DEPT_TEMP2
AS SELECT * FROM DEPT;

SELECT * FROM DEPT_TEMP2;

UPDATE DEPT_TEMP2 SET DNAME='DATABASE', LOC='SEOUL'
WHERE DEPTNO = 40;

SELECT * FROM DEPT_TEMP2;
---
SELECT * FROM EMP_TEMP;

--7900번 이름을 강감찬으로 수정
UPDATE EMP_TEMP SET ENAME = 'JAMES'
WHERE EMPNO = 7900;
COMMIT;

--DEPT_TEMP2테이블에서 40번 내용 수정
--DEPT 테이블의 40번이 가지는 부서명과 지역으로 수정

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

--dept_temp2 모든 데이터 삭제

delete from dept_temp2;
select * from dept_temp2;
drop table dept_temp2;

-- dept 테이블을 이용하여 dept_tmp 테이블 생성하기
create table dept_tmp
as select * from dept;

select * from dept_tmp;

-- dept_tmp 테이블에 location 컬럼추가
alter table dept_tmp
add(location varchar2(50));

select * from dept_tmp;

--10번 부서의 location을 뉴욕으로 설정
update dept_tmp set location = '뉴욕'
where deptno = 10;

--컬럼 구조 수정
alter table dept_tmp modify(location varchar2(70));

--테이블 구조확인
desc dept_tmp;

alter table dept_tmp drop column location;
commit;
select * from dept_tmp;

--loc를 location으로 변경
alter table dept_tmp rename column loc to location;

--테이블 명 수정
rename dept_tmp to dept_tmptmp;

select * from dept_tmptmp;

--데이터 전체 삭제
delete from dept_tmptmp;

--마지막 COMMIT 이전까지 상황으로만  데이터 복구
rollback;
--전체 데이터 삭제
select * from dept_tmptmp;
truncate table dept_tmptmp; --rollback 불가능

--테이블 삭제 복구불가
drop table dept_tmptmp;

-- 9장 연습문제 262p

-- 전체 사원중 ALLEN과 같은 직책인 사원들의 사원정보, 부서정보를 다음과 같이
-- 출력하세요

SELECT JOB,EMPNO,ENAME,SAL,E.DEPTNO,DNAME
FROM EMP E,DEPT D
WHERE JOB = (
                SELECT JOB
                FROM EMP
                WHERE ENAME = 'ALLEN'
                )
                AND E.DEPTNO=D.DEPTNO
                ;
 
-- 전체 사원의 평균 급여(SAL)보다 높은 급여를 받는 사원들의 사원정보,
-- 부서정보,급여등급 정보를 출력하는 SQL문 작성 

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

--10번에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의
--사원정보,부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요

SELECT EMPNO,ENAME,E.DEPTNO,DNAME,LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND E.DEPTNO = 10 
AND JOB NOT IN (
                    SELECT JOB
                    FROM EMP
                    WHERE DEPTNO=30
                );

--직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원정보
--급여등급, 정보를 다음과 같이 출력하는 SQL문을 작성

--다중행 함수 사용X
SELECT E.EMPNO,E.ENAME,E.SAL,S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > (
                SELECT MAX(SAL)
                FROM EMP
                WHERE JOB = 'SALESMAN');
                
--다중행

SELECT E.EMPNO,E.ENAME,E.SAL,S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > ALL(
                SELECT (SAL)
                FROM EMP
                WHERE JOB = 'SALESMAN')
                ORDER BY E.EMPNO;
                
--테이블 생성
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

--CHAP10HW_EMP에 속한 사원 중 급여 등급이 5인 사원을 삭제하는 SQL
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

--1. emp 테이블 만들기
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
 
 --2 BIGO 탭 추가
 alter table emp_hw
 add BIGO varchar2(20);
 
 --3 BIGO 탭 변경
 alter table emp_hw
 modify BIGO varchar2(30);
 
 --4 BIGO열 이름을 REMARK로 변경
 alter table emp_hw
 rename column BIGO to REMARK;
 
 --5 EMP_HW 테이블에 EMP 테이블 데이터를 저장하고 REMARK 열은 NULL로 삽입
 INSERT INTO EMP_HW(EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
 SELECT *
 FROM EMP;
 
DELETE FROM EMP_HW;
 
 
