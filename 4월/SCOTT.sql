--1. ename 에서 처음부터 2글자만 추출하여 소문자로 출력
select ename,
lower (substr(ename,1,2)) 이름
from emp;

--REPLACE
select '010-1234-5678' as rep_before,
replace('010-1234-5678','-','') rep_after
from dual;

--2. ename 에서 S를 s로 변경하여 출력
select ename,
replace(ename,'S','s')
from emp;

select 'Orace' , 
LPAD('Orace',10,'#') as LPAD1,
RPAD('Orace',10,'#') as RPAD1,
LPAD('Orace',10) as LPAD2,
RPAD('Orace',10) as RPAD2
from dual;

--연결: concat
select concat(ename, job)
from emp;
select concat(ename, ':')
from emp;

--3. concat 사용하여 ename : job (ex)SMITH:CLERK
select concat(concat(ename,':'),job)
from emp;

--4 문자열 연결
select ename || ':' || job ename_job
from emp;

--5. 사원번호(empno) 앞 2자리만 표현하고 뒤 2자리는 별표
select empno,
substr(empno,1,2), replace(empno,substr(empno,-2,2),'**')
from emp;

select empno, 
substr(empno,1,2), 
rpad(substr(empno,1,2),4,'*')
from emp;


select empno, 
substr(empno,1,2), 
rpad(substr(empno,1,2),
length(empno),'*')
from emp;

--
select trim('      oracle     ')as str, length(trim('      oracle      ')) 길이,
       trim('      oracle     ')as str, length(rtrim('      oracle      ')) ltrim길이,
       trim('      oracle     ')as str, length(ltrim('      oracle      ')) rtrim길이
from dual;

--숫자

--round(반올림)
select round(123.567,1), round(123.567,2), round(123.567,-1)
from dual;

--Trunc(버림)
select trunc(15.79,1), trunc(15.79,-1)
from dual;

--ceil, floor 가장 가까운 큰 수 , 작은 정수를 반환
select ceil(3.14), floor(3.14), ceil(-3.14), floor(-3.14)
from dual;

--나머지
select mod(15,6)
from dual;

--날짜
select sysdate 오늘, sysdate+1 내일, sysdate-1 어제
from dual;

select add_months(sysdate,3)
from dual;

-- 입사 10주년이 되는 사원의 번호, 이름, 입사일, 입사 10년 후 날짜 출력
select empno,ename,hiredate,add_months(hiredate,120)
from emp;

select empno,ename,hiredate,(hiredate+(interval '10' YEAR))
from emp;

select empno,ename,hiredate,sysdate,
concat(trunc(months_between(sysdate,hiredate)),'개월') as 근무개월수, 
trunc((months_between(sysdate,hiredate)) || '개월')
from emp;

--
select sysdate, next_day(sysdate,'월요일'), last_day(sysdate)
from dual;

--6 사원번호(empno)가 짝수인 사원의 번호(empno), 이름(ename), 직급(job)출력
select empno, ename, job  
from emp
where mod(empno,2) = 0;

--7 emp 테이블에서 부서번호가 10번인 사원의 근무개월 수 출력(버림)
select ename, trunc(months_between(sysdate,hiredate)) 근무개월수
from emp
where deptno = 10;

--8 급여(sal)가 1500 ~ 3000 사이의 사원은 그 급여의 15%를 회비로 지불해야한다.
-- 이름, 급여, 회비(반올림) 출력

select ename, sal, round(sal*0.15)
from emp
where sal > 1500 and sal <= 3000;

--p157 형변환 함수
select empno,ename,empno+'500'
from emp
where ename='SMITH';

select to_char(sysdate, 'YYYY/MM/DD HH:MI:SS') 금일날짜시간
from dual;

select to_char(sysdate, 'MM') from dual;
select to_char(sysdate, 'DD') from dual;
select to_char(sysdate, 'SS') from dual;
select to_char(sysdate, 'MI') from dual;
select to_char(sysdate, 'MON') from dual;
select to_char(sysdate, 'DAY') from dual;

-- 입사일이 1,2,3월인 사원의 사번, 이름, 입사일 출력

select empno, ename, hiredate
from emp
where to_char(hiredate, 'MM') = 1
or to_char(hiredate, 'MM') = 2
or to_char(hiredate, 'MM') = 3;

--
select sal, to_char(sal,'$999,999') sal_$,
            to_char(sal,'$000,999') sal_$ 
from emp;

select to_char(123, '$99999,9999')
from dual;

select to_char(123456, '$99,999')
from dual;

select to_number('1,300','9999999') - to_number('1,500','9999999')
from dual;

--80/12/17 일 이후로 입사한 사람 출력
select *
from emp
where to_char(hiredate) > '80/12/17';

select *
from emp
where hiredate > to_date('1980/12/17', 'YYYY/MM/DD');

--사번, 이름, 급여, 커미션, 급여+커미션 출력
select empno, ename, sal, nvl(comm,0), sal+nvl(comm,0)
from emp;

select empno, ename, sal, nvl2(comm,'O','X') 보너스
from emp;

--연봉 (1년치 급여+comm)
select empno, ename, sal*12+nvl(comm,0) 연봉,
nvl2(comm, sal*12+comm, sal*12) 연봉2
from emp;

--mgr이 null 이면 'CEO'로 출력, empno, ename, mgr
select empno, ename, nvl (to_char(mgr),'CEO')
from emp
where mgr is null;

--p170
-- job에 따라 급여 인상률 설정
-- managers 1.5 / salesman 1.2/ analst 1.05 / other 1.04
-- 조건문(if)
-- decode(여러가지 경우의 수를 나눌수 있음)

select empno, ename, job, sal,
       decode(job, 'MANAGER', sal*1.5, 
                   'SALESMAN', sal*1.2, 
                   'ANALST', sal*1.05,
                    sal*1.04) upsal
from emp;

--case when
select empno, ename, job, sal,
     case job
     when 'MANAGER' then sal*1.5
     when 'SALESMAN' then sal*1.2
     when 'ANALST' then sal*1.05
     else sal*1.04
     end as upsal
from emp;

-- comm 이 null이면 해당사항없음, comm=0이면 수당없음
-- comm이 있을 시 수당:50
-- empno, ename, comm, comm_test

select empno, ename, comm,
decode  (comm, null, '해당사항없음',
              0, '수당없음',
              '수당:' || comm) comm_text
from emp;

select empno, ename, comm,
case
    when comm is null then '해당사항없음'
    when comm = 0 then '수당없음'
    when comm > 0 then '수당:'||comm
end as comm_test
from emp;

select * from
emp;

-- professor 테이블 이용
-- professor 테이블에서 교수명과 학과번호, 학과명 출력

-- 학과 번호가 101번인 학과는 컴퓨터공학과 101이 아닌것은 학과명에 기타 출력

 select name, deptno,
case
     when deptno = 101 then '컴퓨터공학과'
     else '기타'
end as "학과명"
from professor;

-- 학과 번호가 101번인 학과는 컴퓨터공학과 102 멀티미디어 공학과
-- 학과 번호가 201 소프트웨어 공학 나머지 기타 

select * from professor;

select name, deptno,
case
     when deptno = 101 then '컴퓨터공학과'
     when deptno = 102 then '멀티미디어공학과'
     when deptno = 201 then '소프트웨어 공학과'
     else '기타'
end as "학과명"
from professor;


select name, deptno,
decode (deptno, 101, '컴퓨터공학과',
                102, '멀티미디어공학과' ,
                201, '소프트웨어공학과'
                    , '기타') as 학과명
from professor;

-----case 추가변형

select name, deptno,
case deptno
     when 101 then '컴퓨터공학과'
     when 102 then '멀티미디어공학과'
     when 201 then '소프트웨어 공학과'
     else '기타'
end as "학과명"
from professor;

-- 
select * from emp;

-- Q1 사원이름 5글자 이상 6글자 미만 사원정보 출력 (연습문제 1참조) 

select empno, replace(empno,substr(empno,-2,2),'**') as "MASKING_EMPNO", ename,
       RPAD(substr(ename,1,1),length(ename),'*') as "MASKING NAME"
from emp
where length(ename) = 5;

select empno, rpad(substr(empno,1,2),length(empno),'*') as "MASKING_EMPNO", 
       ename,
       rpad(substr(ename,1,1),length(ename),'*') as "MASKING NAME"
from emp       
       where length(ename) = 5;


-- Q2 하루 근무시간을 8시간으로 보고 하루급여와 시급을 계산하여 결과 출력, 단 하루 급여는
--    소수점 3째자리에서 버리고, 시급은 두번째 소수점에서 반올림
--    (연습문제 2참조) 
     
select empno, ename, sal, trunc(sal/21.5,2) as "DAY_PAY", 
round(sal/21.5/8,1) as "TIME_PAY"
from emp;

-- Q3 입사일을 기준으로 3개월이 지난 후 정직원이 됨 해당 날짜를 YYYY-MM-DD 형식으로 출력
-- 단 추가수당이 없을 시 N/A로 출력
-- (연습문제 3참조) 

select empno, ename, hiredate, 
       to_char(next_day(add_months(hiredate,3), '월요일'), 'YYYY-MM-DD')  R_JOB,
       nvl(to_char(comm),'N/A') COMM
from emp;

-- Q4 EMP 테이블의 모든 사원을 대상으로 직속 상관의 사원번호를 조건 기준으로 변경
-- when 형식
select empno, ename, nvl(to_char(mgr),' '),
case 
when mgr is null then '0000'
when substr(mgr,1,2) = '75' then '5555'
when substr(mgr,1,2) = '76' then '6666'
when substr(mgr,1,2) = '77' then '7777'
when substr(mgr,1,2) = '78' then '8888'
else to_char(mgr)
end as CHG_MGR
from emp;

-- decode 형식
select empno, ename, mgr,
       decode(substr(mgr,1,2), null, '0000',
              '75', '5555',
            '76', '6666',
            '77', '7777',
            '78', '8888',
            to_char(mgr)
            ) as CHG_MGR
            from emp;


--중복제외 합계
select sum(distinct(sal))
from emp;

--합계
select sum(sal)
from emp;

--급여합계와 comm 합계
select sum(sal), sum(comm)
from emp;

select sal from emp;
select count(sal) from emp;
select count(*) from emp;

-- 부서번호가 30인 사원 수
select count(*)
from emp
where deptno=30;

-- comm 이 null이 아닌 개수
select count(*)
from emp
where comm is not null; 

select count(sal), count(distinct(sal))
from emp; 

--최대값
select max(sal)
from emp;

--최소값
select min(sal) 
from emp;

select max(sal), min(sal)
from emp;

--평균
select avg(sal)
from emp;

--평균을 반올림해서 구하기(소수 첫째자리까지)
select round(avg(sal),1)
from emp;

-- 부서번호가 20인 사원의 입사일 중 가장 최근 입사일 출력
select max(hiredate)
from emp
where deptno=20;

select * from professor;
--professor 테이블

-- 1. 총 교수수 출력
    select count(PROFESSOR)
    FROM EMP;
    
-- 2. 교수들 급여 합계
      select sum(SAL)
      from professor;

-- 3. 급여평균
      select avg(sal)
      from professor;
      
-- 4. 급여평균 소수점 첫째자리에서 반올림
      select round(avg(sal),0)
      from professor;
      
-- 5. 교수중에서 최고급여
      select max(sal)
      from professor;

-- 6. 교수중에서 최소급여
      select min(sal)
      from professor;
      
--7. 교수중에서 최고급여를 받는 사람의 이름과 급여 
     select name, sal
     from professor
     where sal = (select max(sal) from professor);
     