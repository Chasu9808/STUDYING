--1. professor테이블에서 총 교수 수 출력
select count(*) from professor;

--2. 교수들 급여 합계
select sum(sal) from professor;

--3. 교수들 급여 평균
select avg(sal) from professor;

--4. 교수들 급여의 평균을 구하는데 소수점 첫째 자리에서 반올림
select round(avg(sal)) from professor;

--5. 교수들 중에서 최고 급여
select max(sal) from professor;

--6.교수들 중에서 최소 급여
select min(sal) from professor;
--7. 교수중에 최고 급여를 받는 사람의 이름과 급여를 출력
select name, sal
from professor
where sal=500;

select name, sal
from professor
where sal=(select max(sal) from  professor);
----
-- emp 테이블
--1. 10번 부서의 평균 급여
select round(avg(sal))
from emp
where deptno=10;

--20번 부서의 평균 급여 
select round(avg(sal)) from emp where deptno =20;

-- 30번 부서의 평균 급여
select round(avg(sal)) from emp where deptno =30;

--
select round(avg(sal)) from emp where deptno =10
union
select round(avg(sal)) from emp where deptno =20
union
select round(avg(sal)) from emp where deptno =30;

-- 부서별 직원 평균 급여출력 (부서번호, 평균출력)
select deptno, round(avg(sal)) as "부서별 평균급여"
from emp group by deptno;

-- 부서별 직원 평균 급여출력 (부서번호, 평균출력) 부서별 오름차순
select deptno, round(avg(sal)) as "부서별 평균급여"
from emp 
GROUP BY deptno
order by deptno;

-- emp 테이블에서 부서번호 및 직책(job) 별 평균급여, 부서번호 내림차순, 높은 급여 순으로 출력
select deptno, job, round(avg(sal)) avgsal
from emp
GROUP BY deptno, job
order by deptno desc, avgsal desc;

-- emp 테이블에서 부서번호 및 직책(job) 별 평균급여, 부서번호 내림차순, job 이름 오름차순으로 출력
select deptno, job, round(avg(sal)) 
from emp
GROUP BY deptno, job
order by deptno desc, job asc;

----professor 테이블 사용
select * from professor;
--1. 학과별(deptno) 교수들의 평균 급여
select deptno, avg(sal)
from professor
group by deptno;

-- 2. 학과별 교수들의 합계 급여(sal)
select deptno, sum(sal),count(*)
from professor
group by deptno
order by deptno;

--3. 학과별 직급별(posotion) 교수들의 평균 급여
select deptno, position, avg(sal)
from professor
group by deptno, position
order by deptno;
--4. 교수 중에서 급여(sal)와 보직수당(comm)을 합친 금액이 가장 많은 경우와
-- 가장 적은 경우  출력
-- 단,  comm 이 없는 교수의 급여는 0으로 계산, 급여는 소수점 둘째 자리에서 반올림
 select round(max(nvl(sal+comm, 0)), 1) 최대값,
        round(min(nvl(sal+comm, 0)), 1) 최소값
 from professor;
 
select round(max(sal+nvl(comm,0)), 1) 최대값,
       round(min(sal+nvl(comm,0)), 1) 최소값
 from professor;
 ---
 --5.직급별 평균 급여가 300보다 크면 '우수' 작거나 같으면 '보통'
  --- 직급별(position), 평균급여, 비고 출력
select position, avg(sal),
       case when avg(sal) > 300 then '우수'
            when avg(sal) <=300 then '보통'
       end   비고
from professor
group by position;
-----
--emp 테이블에서 입사일 년도별 인원 수 
-- total 1980  1981   1982
--  12     1    10     1 
select hiredate from emp;
select count(*) total,
        sum(decode(to_char(hiredate,'YYYY'),1980,1,0)) "1980년도",
        sum(decode(to_char(hiredate,'YYYY'),1981,1,0)) "1981년도",
        sum(decode(to_char(hiredate,'YYYY'),1982,1,0)) "1982년도"
from emp;
-- emp 테이블에서 1000이상의 급여를 가지고 있는 사람들에 대해서만 부서별 평균을 구하되
-- 부서별 평균이 2000 이상인 부서번호, 부서별 평균급여 출력

select deptno, round(avg(sal))
from emp
where sal>1000
group by deptno
having avg(sal) >=2000;

select deptno, round(avg(sal))
from emp
group by deptno
having avg(sal) >=2000;

--professor 테이블
-- 학과별(deptno) 직급별(position) 교수들의 평균 급여 중에서 평균 급여가 400이상인거 출력
-- 학과번호 직급 평균급여
select deptno, position, avg(sal)
from professor
group by deptno, position
having avg(sal) >= 400;

---p196
select deptno,job,count(*),max(sal), sum(sal), min(sal), avg(sal)
from emp
group by deptno, job
order by deptno, job;
-- rollup(A,B,C)  A,B,C / A,B / A 에 대한 거 출력
-- rollup(A,B)  A,B / A 에 대한 거 출력
select deptno, job, count(*), max(sal), sum(sal),min(sal), round(avg(sal))
from emp
group by rollup(deptno, job)
order by deptno,job;
-- cube(A,B,C)  A,B,C / A,B / A,C / B,C/ A/B/C 에 대한 거 출력
-- cube(A,B)  A,B / A /B 에 대한 거 출력
select deptno, job, count(*), max(sal), sum(sal),min(sal), round(avg(sal))
from emp
group by cube(deptno, job)
order by deptno,job;

---- 조인  p215
select * from emp;
select * from dept;
--  사원번호(empno), 사원이름(ename),   job, dname, loc
select * 
from emp, dept; 

select *
from emp e, dept d
where e.deptno = d.deptno;

select empno, ename, job, e.deptno,dname, loc
from emp e, dept d
where e.deptno = d.deptno;

---
 select * from emp;
 select * from salgrade;
 --비등가조인
 select *
 from emp e, salgrade  s
 where e.sal between s.losal and s.hisal;
 -- 자신의 상사(mgr) 의 이름 출력
  select * 
  from emp e1, emp e2
  where e1.mgr = e2.empno;
  
  --자체조인(셀프조인)
  select e1.empno, e1.ename, e1.mgr, e2.empno 상사회원번호, e2.ename 상사이름
  from emp e1, emp e2
  where e1.mgr = e2.empno;
  
  --emp 테이블에서  deptno가 30번인 사원들 조회하여
  --comm 값이 있을 경우 'Exist' 을
  --comm 값이  null 경우 'Null' 출력
select empno, ename, comm, nvl2(comm, 'Exist','Null')
from emp
where deptno =30;

-- 급여가 2500이하이고 사번이 9999 이하인 사원의 정보를 출력
-- 사원번호(empno), 이름(ename), 급여(sal), 부서번호(deptno), 부서명(dname), 부서지역(loc)
 select e.empno, e.ename, e.sal, d.deptno, d.dname, d.loc
from emp e, dept d
where e.deptno = d.deptno and e.sal <=2500 and e.empno<9999;

-- 이름이 'ALLEN' 인 사원의 부서명 출력
select e.ename, d.dname
from emp e, dept d
where ename = 'ALLEN' and e.deptno = d.deptno;

select e.ename, d.dname
from emp e, dept d
where  e.deptno = d.deptno and ename = 'ALLEN';

--1. 급여가 3000에서 5000사이인 직원의 이름과 소속 부서명을 출력하라
select e.ename, d.dname, e.sal
from emp e, dept d
where e.deptno = d.deptno
    and e.sal between 3000 and 5000;
    
select e.ename, d.dname, e.sal
from emp e join dept d
on e.deptno = d.deptno
and e.sal between 3000 and 5000;
    

--2. 직급이 MANAGER인 사원의 이름, 부서명을 출력하라
select e.ename, d.dname, e.sal
from emp e, dept d
where e.deptno = d.deptno and e.job = 'MANAGER';

select e.ename, d.dname, e.sal
from emp e join dept d
on e.deptno = d.deptno and e.job = 'MANAGER'; 

--p212~213 연습문제
--1. emp 테이블/ 부서번호, 평균급여, 최고급여, 최저급여, 사원수 출력
--단, 평균급여는 소수점 제외, 각 부서번호별 출력
select  deptno, 
        trunc(avg(sal)) avg_sal,
        max(sal) max_sal,
        min(sal) min_sal,
        count(*) as cnt
from emp
group by deptno
order by deptno;

--2, 같은 직책에 종사하는 사원이 3명 이상인 직책과 인원수
select job, count(*)
from emp
group by job
having count(*)  >=3;

--3. 사원들의 입사연도를 기준으로 부서별로 몇명이 입사했는지 출력
select  to_char(hiredate, 'YYYY') HIRE_YEAR, deptno, count(*) CNT
from emp
group by to_char(hiredate, 'YYYY'),deptno;

--4. 추가수당(comm)받는 사원 수와 받지 않는 사원 수 출력
select nvl2(comm, 'O','X') EXIST_COMM , count(*) CNT
from emp
group by nvl2(comm, 'O','X');

--5. 각 부서의 입사연도별 사원수, 최고급여, 급여 합, 평균 급여 출력하고
-- 각 부서별 소계와 총계 출력
select deptno, 
        to_char(hiredate,'YYYY') HIRE_YEAR, 
        count(*) CNT,
        max(sal) MAX_SAL,
        sum(sal) SUM_SAL,
        round(avg(sal),1) AVG_SAL
from emp
group by rollup(deptno, to_char(hiredate,'YYYY'))
order by deptno;
---------
-- 조인
--1. ACCOUNTING 부서 소속 사원의 이름과 입사일을 출력
select ename, hiredate
from emp e,dept d
where e.deptno = d.deptno and   dname='ACCOUNTING';
-- join~on 사용
select e.ename, e.hiredate
from emp e join dept d
on e.deptno = d.deptno and d.dname='ACCOUNTING';

--2. 0보다 많은  comm 을 받는 사원 이름과 부서명 출력
select e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno 
    and e.comm is not null
    and e.comm > 0; 
    
select e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno 
    and e.comm is not null
    and e.comm <> 0;     
    
select e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno 
    and e.comm > 0;     
    
select e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno 
    and e.comm <> 0;      

-- join ~ on
select e.ename, d.dname
from emp e join dept d
            on  e.deptno = d.deptno 
            and e.comm is not null
            and e.comm <> 0;
            
-- 3.  뉴욕에서 근무하는 사원의 이름과 급여를 출력하라
select e.ename, e.sal
from emp e, dept d
where e.deptno = d.deptno 
   and d.loc = 'NEW YORK';

--join ~ on
select  e.ename, e.sal
from emp e join dept d
on e.deptno = d.deptno
and  d.loc = 'NEW YORK';

--4. SMITH와 동일한 근무지에서 근무하는 사원의 이름을 출력
select * from emp;
select * from dept;

select ename
from emp
where deptno = (select deptno from emp where ename='SMITH')
  and ename <> 'SMITH';
-- 셀프조인  
select friend.ename as "SMITH 동료"
from emp e, emp friend
where e.deptno = friend.deptno 
        and e.ename = 'SMITH' 
        and friend.ename <> 'SMITH';
        
select f.ename as smith동료
from emp e join emp f
on e.deptno = f.deptno 
    and e.ename = 'SMITH' and f.ename <> 'SMITH';
    
-- 매니저가 KING인 사원들의 이름과 직급을 출력하라
select e.ename, e.job, e.mgr
from emp e, emp m
where e.mgr = m.empno
    and m.ename= 'KING';
    
select ename, job, mgr
from emp
where mgr = (select empno from emp where ename = 'KING');

select e.ename, e.job, e.mgr
from emp e join emp m
            on e.mgr = m.empno 
            and m.ename = 'KING';
            
-- p229
select * from emp;
select e1.empno, e1.ename, e1.mgr 매니저번호
from emp e1, emp e2
where e1.mgr = e2.empno(+);

select * from emp;
select e1.empno, e1.ename, e1.mgr 매니저번호
from emp e1, emp e2
where e1.mgr(+)= e2.empno;

--p232  표준
select e.empno, e.ename,e.sal, e.mgr, deptno, d.dname, d.loc
from emp e natural join dept d
where e.sal>2000
order by deptno, e.empno;
--
select e.empno, e.ename,e.sal, e.mgr, deptno, d.dname, d.loc
from emp e join dept d using(deptno)
where e.sal > 2000
order by deptno, e.empno;

--p234(join~on : 가장 많이 사용하는 방법)
select  e.empno, e.ename,e.sal, e.mgr, e.deptno, d.dname, d.loc
from emp e join dept d
on e.deptno = d.deptno 
where e.sal > 2000;

-----
select * from emp;
select * from dept;
--모든 부서 출력
select e.ename, d.deptno, d.dname
from emp e, dept d
where e.deptno(+) = d.deptno
order by e.deptno;

select e.ename, d.deptno, d.dname
from emp e right outer join dept d 
        on e.deptno = d.deptno;
        
select e.ename, d.deptno, d.dname
from dept d left outer join emp e
        on e.deptno = d.deptno;        
       
 ----

select e.ename, d.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno(+)
order by e.deptno;

select e.ename, d.deptno, d.dname
from emp e left outer join dept d 
        on e.deptno = d.deptno;








 





  



















