--1.ename 에서 처음부터 2글자만 추출하여 소문자로 출력
select ename, substr(ename, 1,2) 이름 ,lower(substr(ename, 1,2)) 소문자이름
from emp;

--REPLACE
select '010-1234-5678' as rep_before,
        replace('010-1234-5678','-',' ') rep_after
from dual;
--2. ename 에서 S 를  s로 변경하여 출력
select ename, replace(ename, 'S', 's')
from emp;

select 'Orace', LPAD('Orace',10,'#') as  LPAD1,
                RPAD('Orace',10,'#') as  RPAD1,
                LPAD('Orace',10) as  LPAD2,
                RPAD('Orace',10) as  RPAD2
from dual;
-- 연결 : concat
select concat(ename, job)
from emp;
select concat(ename, ':')
from emp;
--3. concat 사용하여  ename : job  예)SMITH:CLERK
select concat(concat(ename,':'), job)
from emp;

select concat(ename, concat(':',job))
from emp;

--4. 문자열 연결
select ename || ':' || job ename_job
from emp;

--5. 사원번호(empno)를 앞 2자리만 표현하고 뒤 2자리는 *표로 출력
select empno, substr(empno,1,2),rpad(substr(empno,1,2),4,'*')
from emp;

select  rpad(substr(empno,1,2),4,'*') 사원번호
from emp;

select  rpad(substr(empno,1,2),length(empno),'*') 사원번호
from emp;
-- 공백제거
select trim('   oracle    ') as str, length(trim('   oracle    ')) 길이,
       Ltrim('   oracle    ') as Lstr, length(Ltrim('   oracle    ')) Ltrim길이,
       Rtrim('   oracle    ') as Rstr, length(Rtrim('   oracle    ')) Rtrim길이
from dual;

--숫자
-- round(반올림)
select round(123.567,1),round(123.567,2),
       round(123.567,-1), round(123.567)
from dual;

--Trunc(버림)
select TRUNC(15.79, 1),TRUNC(15.793, 2),TRUNC(15.793, -1),TRUNC(15.793)
from dual;

--ceil, floor  가장 가까운 큰수, 작은 정수 반환
select ceil(3.14),floor(3.14),ceil(-3.14),floor(-3.14),trunc(-3.14),trunc(3.14)
from dual;

--나머지
select mod(15,6)
from dual;

--날짜
select sysdate 오늘,  sysdate+1 내일, sysdate-1 어제, sysdate+3
from dual; 

select sysdate, add_months(sysdate,3)
from dual;

select add_months('22/05/15',3)
from dual;
--사원의 번호, 이름, 입사일, 입사 10년 후 날짜 출력
select empno, ename, hiredate, add_months(hiredate,120) 입년후
from emp;

select empno, ename, hiredate,sysdate,
  months_between(hiredate,sysdate) as months1,
  months_between(sysdate,hiredate) as months2,
  trunc(months_between(sysdate,hiredate)) as months3
from emp;

select empno, ename, hiredate,sysdate,
  trunc(months_between(sysdate,hiredate))||'개월' as 근무개월수
from emp;

select empno, ename, hiredate,sysdate,
  concat(trunc(months_between(sysdate,hiredate)),'개월') as 근무개월수
from emp;
--
select sysdate, next_day(sysdate,'월요일'), last_day(sysdate), last_day('22/05/01')
from dual;
--6. 사원번호(empno)가 짝수인 사원의 번호(empno), 이름(ename), 직급(job) 출력
select empno, ename, job
from emp
where mod(empno,2)=0;
--7. 부서번호가 10번인 사원의 근무개월수 출력(버림)
select ename, trunc(months_between(sysdate, hiredate))||'개월' 근무개월수
from emp
where deptno=10;

--급여(sal)가 1500에서 3000 사이의 사원은 그 급여의 15%를 회비로 지불
-- 이름, 급여, 회비(반올림) 출력
select ename, sal,sal*0.15 회비, round(sal*0.15)
from emp
where sal>1500 and sal<=3000;

--p157형변환함수
--숫자+문자(500==>숫자)
select empno,ename, empno+'500' 
from emp
where ename='SMITH';
--오류발생
--select  'ABCD'+ empno, empno
--from emp
--where ename='SMITH';

select to_char(sysdate,'YYYY/MM/DD HH24:MI:SS') 현재날짜시간
from dual;

select to_char(sysdate, 'MM') from dual;
select to_char(sysdate, 'DD') from dual;
select to_char(sysdate, 'SS') from dual;
select to_char(sysdate, 'MI') from dual;
select to_char(sysdate, 'MON') from dual;
select to_char(sysdate, 'MONTH') from dual;
select to_char(sysdate, 'day') from dual;
select to_char(sysdate, 'DAY') from dual;
-- 입사일이 1,2,3월인 사원의 사번(empno), 이름(ename), 입사일(hiredate) 출력
select empno,ename,hiredate
from emp
where to_char(hiredate,'MM') in('01','02','03');

select empno,ename,hiredate
from emp
where to_char(hiredate,'MM') between '01' and '03';

--
select sal, to_char(sal,'$999,999') sal_$,
            to_char(sal, 'L999,999') as sal_L,
            to_char(sal, '000,999') as sal_0
from emp;

select to_char(123456, '$99,999')
from dual;

select to_number('1,300','999,999')-to_number('1,500','999,999')
from dual;
--80/12/17  일 이후로 입사한 사람 출력
select empno, ename, hiredate
from emp
where hiredate > '80/12/17';

select empno, ename, hiredate
from emp
where hiredate > to_date('1980/12/17', 'YYYY/MM/DD');

--   사번, 이름, 급여, 커미션, 급여+커미션 출력
select empno, ename, sal, comm,nvl(comm,0),sal+nvl(comm,0)
from emp;

 --nvl2(값, null 아닐때,  null)
select empno, ename, comm, nvl2(comm,'O','X')  
from emp;
-- 연봉 (1년치급여+comm)
select empno, ename, sal*12+nvl(comm,0) 연봉1 ,
    nvl2(comm, sal*12+comm, sal*12) 연봉2
from emp;

--mgr 인 null 이면 'CEO'로 출력,  empno, ename, mgr
select empno, ename,nvl(to_char(mgr),'CEO')
from emp;

select empno, ename,nvl(to_char(mgr),'CEO')
from emp
where mgr is null;

--p170
-- job 에 따라 급여 인상률을 다르게 설정
-- MANAGER 1.5  /    SALESMAN 1.2 / ANALST 1.05  / 1.04
-- decode
select empno, ename, job, sal,
       decode(job, 'MANAGER', sal*1.5,
                    'SALESMAN',sal*1.2,
                    'ANALST',sal*1.05,
                    sal*1.04) upsal
from emp;

--case when  end
select empno, ename, job, sal,
   case job
    when 'MANAGER' then sal*1.5
    when 'SALESMAN' then sal*1.2
    when 'ANALST' then sal*1.05
    else sal*1.04
   end  as upsal
from emp;

-- comm 이 null 이면 해당사함없음, comm=0 이면 수당없음
-- comm  이 있으면(50) 수당:50
-- empno, ename, comm, comm_text 출력
--case when  end
 select empno, ename, comm,
 case 
    when comm is null then '해당사항없음'
    when comm=0 then '수당없음'
    when comm > 0 then '수당:'||comm
 end as comm_text
 from emp;
 
select empno, ename,comm,
    decode (comm , null, '해당사항없음',
               0 , '수당없음',
                '수당:'||comm)
    as comm_text
 from emp;
 
  select empno, ename,to_char(comm),
    decode (comm , null, '해당사항없음'
               , 0 , '수당없음'
               , '수당:'||comm)
    as comm_text
 from emp;
 
 --professor 테이블 이용
 --1. professor 테이블에서 교수명(name)과 학과번호(deptno), 학과명 출력
 -- 학과번호가 101은 컴퓨터공학과 101이 아닌 학과는 학과명에
 -- 아무것도 출력하지 마세요
 select name, deptno, decode(deptno, 101,'컴퓨터공학과')  학과명 
 from professor;
 
 select name, deptno,
 case  when deptno=101 then '컴퓨터공학과'
 end 학과명
 from professor;
 
 --2. professor 테이블에서 교수명(name)과 학과번호(deptno), 학과명 출력
 -- 학과번호가 101은 컴퓨터공학과 101이 아닌 학과는 기타로 출력
 select name ,deptno, 
    decode(deptno, 101, '컴퓨터공학과', '기타')  "학과명"
  from professor;
  
 select name, deptno,
 case  when deptno=101 then '컴퓨터공학과'
        else '기타'
 end 학과명
 from professor;
 
 select name, deptno,
 case  deptno when 101 then '컴퓨터공학과'
        else '기타'
 end 학과명
 from professor;
 
--3. 학과번호가 101은 학과명은 컴퓨터공학과  로 출력하고
-- 102번은  멀티미디어공학과 
-- 201 소프트웨어 공학 나머지 기타
 select name ,deptno, 
    decode(deptno, 101, '컴퓨터공학과',
                   102, '멀티미디어공학과',
                   201,'소프트웨어 공학',
                   '기타')  학과명
  from professor;
  
  select name, deptno,
 case  deptno 
        when 101 then '컴퓨터공학과'
        when 102 then '멀티미디어공학과'
        when 201 then '소프트웨어 공학'
        else '기타'
 end 학과명
 from professor; 
 
 select name, deptno,
 case   
        when deptno = 101 then '컴퓨터공학과'
        when deptno = 102 then '멀티미디어공학과'
        when deptno = 201 then '소프트웨어 공학'
        else '기타'
 end 학과명
 from professor; 
 --p174 연습문제
 --1. 
 select empno, rpad(substr(empno,1,2),length(empno),'*')  MASKING_EMPNO,
        ename,
        rpad(substr(ename,1,1),length(ename),'*') MASKING_ENAME
 from emp;
 
 select empno, rpad(substr(empno,1,2),length(empno),'*')  MASKING_EMPNO,
        ename,
        rpad(substr(ename,1,1),length(ename),'*') MASKING_ENAME
 from emp
 where length(ename) >=5 and length(ename) <6;

 select empno, rpad(substr(empno,1,2),length(empno),'*')  MASKING_EMPNO,
        ename,
        rpad(substr(ename,1,1),length(ename),'*') MASKING_ENAME
 from emp
 where length(ename) =5 ;

--2. 
select empno, ename, sal,
  trunc(sal/21.5) day_pay,
  round(sal/21.5/8) time_pay
from emp;

-- 소수 세번째 자리에서 버림  /  두번째 소수점에서 반올림
select empno, ename, sal,
  trunc(sal/21.5,2) day_pay,
  round(sal/21.5/8,1) time_pay
from emp;
--3.
select empno, ename, 
       hiredate, next_day(add_months(hiredate,3), '월요일') R_JOB
from emp;

select empno, ename, hiredate,
       to_char(next_day(add_months(hiredate,3), '월요일'), 'YYYY-MM-DD' ) R_JOB,
       nvl(to_char(comm),'N/A') COMM
from emp;
--4.
select empno, ename,mgr,
 case 
    when mgr is null then '0000'
    when substr(mgr,1,2) ='75' then '5555'
    when substr(mgr,1,2) ='76' then '6666'
    when substr(mgr,1,2) ='77' then '7777'
    when substr(mgr,1,2) ='78' then '8888'
    else to_char(mgr)
  end as CHG_MGR
from emp;

--decode
select  empno, ename,mgr,
    decode(substr(mgr,1,2), null, '0000',
         '75', '5555',
         '76', '6666',
         '77', '7777',
         '78', '8888',
         to_char(mgr)
     ) as  CHG_MGR
from emp;

select sal from emp;
select sum(sal) from emp;
select DISTINCT(sal) from emp;
select sum(DISTINCT(sal)) from emp;
select  sum(sal) 합계,  sum(DISTINCT(sal)) 합계2
from emp ;
-- 급여합계 와 comm 합계
select sum(sal), sum(comm)
from emp;

select sal from emp;
select ename from emp;
select count(sal) from emp;
select count(distinct(sal)) from emp;
select count(ename) from emp;
select count(*) from emp;

--부서번호가 30인 사원 수
select count(*)
from emp
where deptno=30;

-- comm 이 null 이 아닌 개수
select count(comm), count(*)
from emp
where comm is not null;

select count(sal), count(distinct(sal)), count(all sal)
from emp;
desc emp;

--최대값
select max(sal)
from emp;

--최소값
select min(sal) from emp;

select max(sal), min(sal) from emp;

--평균
select avg(sal) from emp;
--평균을 반올림해서 구하기 (소수첫번째까지 출력)
select round(avg(sal),1) from emp;

-- 부서번호가 20인 사원의 입사일 중 가장 최근 입사일 출력
select max(hiredate)
from emp
where deptno=20;
--professor 테이블
select * from professor;
-- 1. 총 교수 수 출력
select count(*) from professor;
-- 2.교수들 급여 합계
select sum(sal) from professor;
--3. 급여 평균
select avg(sal) from professor;

--4. 급여 평균을 구하는 소수점 첫째자리에서 반올림
select round(avg(sal)) from professor;
select round(avg(sal),0) from professor;
--5. 교수중에서 최고급여
select max(sal) from professor;
--6. 교수 중에서 최소급여
select min(sal) from professor;

--7. 교수 중에서 최고 급여를 받는 사람의 이름과 급여 출력
select name, sal
from professor
where sal = 500;

select name, sal
from professor
where sal = (select max(sal) from professor);



