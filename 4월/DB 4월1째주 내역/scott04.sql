--p238
-- emp, dept 급여가 3000이상이며 직속상관이 반드시 있어야함
-- 사원번호, 이름 , 직책(job), mgr, hiredate, sal, comm, deptno, dname, loc
-- join ~ using
select e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm, deptno,
 d.dname, d.loc
from emp e join dept d using (deptno)
where sal >= 3000 and e.mgr is not null;

select e.empno, e.ename, e.job, e.mgr, e.hiredate, e.sal, e.comm, e.deptno,
 d.dname, d.loc
from emp e join dept d 
on e.deptno = d.deptno
where sal >= 3000 and e.mgr is not null;
---p242 서브쿼리
select * from emp;
--WARD 보다 월급이 많이 받은 사원 이름 출력
select sal from emp where ename='WARD';
select ename from emp where sal > 1250;

select ename
from emp
where sal > (
                select sal
                from emp
                where ename = 'WARD'
            );
--'ALLEN' 의 직무(job)와 같은 사람의 이름(enmae),부서명(dname),급여(sal),직무(job) 출력
select job
from emp
where ename = 'ALLEN';
-- job  이 SALESMAN 사람의 이름(ename),부서명(dname),급여(sal),직무(job) 출력
select e.ename, d.dname, e.sal, e.job
from emp e, dept d
where e.deptno = d.deptno and e.job = 'SALESMAN';

select e.ename, d.dname, e.sal, e.job
from emp e, dept d
where e.deptno = d.deptno 
  and e.job =(
              select job
              from emp
              where ename = 'ALLEN'
              );
              
select e.ename, d.dname, e.sal, e.job
from emp e, dept d
where e.deptno = d.deptno 
  and e.job =(
              select job
              from emp
              where ename = 'ALLEN'
              )
  and e.ename <> 'ALLEN' ;     
-- ALLEN 보다 일찍 입사한 사원의 정보  
select hiredate
from emp
where ename = 'ALLEN';
select *
from emp
where hiredate < '81/02/20';

select *
from emp
where hiredate <(
        select hiredate
        from emp
        where ename = 'ALLEN'
        );
-- 전체 사원의 평균 임금보다 많은 사원의 
--사원번호(empno), 이름(ename), 부서명(dname), 입사일(hiredate) 출력   
select avg(sal)
from emp;

select e.empno, e.ename, d.dname, e.hiredate
from emp e, dept d
where e.deptno = d.deptno and
 e.sal > (select avg(sal) from emp);
 
 --p248
 --전체 사원의 평균 급여보다 작거나 같은 급여를 받고 있는
 -- 20번 부서의 사원 및 부서정보
 --사원번호(empno), 이름(ename), 직무(job), 급여(sal), 부서번호(deptno), 부서명(dname) ,부서지역(loc)
select e.empno, e.ename, e.job,e.sal, e.deptno, d.dname, d.loc
from emp e, dept d
where e.deptno = d.deptno 
        and e.deptno=20
        and e.sal <= (
                   select avg(sal)
                   from emp
                );
-- 각 부서별 최고 급여와 동일한 급여를 받는 사원 정보 출력
select deptno, max(sal)
from emp
group by deptno;

select *
from emp
where sal in (
    select  max(sal)
    from emp
    group by deptno
    );
-- 10번 부서 중에서 30번 부서에는 없는  업무(job)를 하는 (President)
-- 사원의 사원번호, 이름, 부서명, 입사일 ,지역 출력
select job from emp where deptno=10;
select job from emp where deptno=30;
select job from emp where deptno=10
minus
select job from emp where deptno=30;

select e.empno, e.ename, d.dname, e.hiredate, d.loc, e.job
from emp e, dept d
where e.deptno = d.deptno
    and e.deptno = 10
    and e.job  not in (
                select job
                from emp
                where deptno =30
         );
         
--mgr 인  KING 인 사원의 이름과  job  출력 
select * from emp;
select empno from emp where ename = 'KING';
select empno, ename,job from emp where mgr = 7839;
-- 서브쿼리 사용
select ename, job
from emp
where mgr = (
    select empno
    from emp
    where ename='KING'
);

-- 서브쿼리 사용 안함(셀프조인)
select e.ename, e.job
from emp e, emp m
where e.mgr = m.empno and m.ename ='KING';

-- 매니저가 KING  이거나 FORD  인 사원들의 이름과 직급 출력
--서브쿼리
 select empno
    from emp
    where ename = 'KING' or ename='FORD';

select ename, job
from emp
where mgr  in (
    select empno
    from emp
    where ename = 'KING' or ename='FORD'
 );
 
 --(셀프조인)
 select e.ename, e.job
 from emp e, emp m
 where e.mgr = m.empno and (m.ename='KING' or m.ename='FORD');
 
 select e.ename, e.job
 from emp e join emp m
 on e.mgr = m.empno and (m.ename='KING' or m.ename='FORD');
 
 --p251
 select ename, sal
 from emp
 where sal < any(select sal
                from emp
                where job='SALESMAN');
                
select ename, sal  from emp;  --12개
                
select sal               --1600  1250 1250  1500
from emp
where job='SALESMAN';

 select ename, sal
 from emp
 where sal < all (select sal     --1600  1250 1250  1500
                from emp
                where job='SALESMAN');
                
-- 30번 부서에서  최대급여보다 적은 급여를 받는 사원 출력(any, all 사용)
select sal from emp where deptno =30; --1600 1250 1250 2850 1500 950
select sal
from emp
where sal < ( select max(sal)
                from emp
                where deptno=30          
            );
            
select sal from emp
where sal < any(select sal
                from emp
                where deptno=30);
                
--- p239~p240 8장 연습문제
--1. 급여(sal)가 2000초과인 사원들의 부서정보, 사원정보
--deptno, dname, empno, ename, sal(2가지 방법)
select d.deptno, d.dname, e.empno, e.ename, e.sal
from emp e, dept d
where e.deptno = d.deptno and e.sal > 2000;

--natural ~ join  
select deptno, d.dname, e.empno, e.ename, e.sal
from emp e NATURAL JOIN dept d
where e.sal > 2000;
-- join ~ on
select d.deptno, d.dname, e.empno, e.ename, e.sal
from emp e join dept d
on e.deptno = d.deptno and e.sal > 2000;
  
--2.부서별 평균 급여, 최대급여, 최소급여, 사원수 출력
select e.deptno, d.dname, trunc(avg(e.sal)) as avg_sal, 
   max(e.sal) as max_sal,  min(e.sal) as min_sal,count(*) as cnt
from emp e, dept d
where e.deptno = d.deptno 
group by e.deptno, d.dname;

--join using 
select deptno, d.dname, trunc(avg(e.sal)) as avg_sal, 
   max(e.sal) as max_sal,  min(e.sal) as min_sal,count(*) as cnt
from emp e join  dept d
using(deptno) 
group by deptno, d.dname;

--join~on
select e.deptno, d.dname, trunc(avg(e.sal)) as avg_sal, 
   max(e.sal) as max_sal,  min(e.sal) as min_sal,count(*) as cnt
from emp e join dept d
on e.deptno = d.deptno 
group by e.deptno, d.dname;

--3. 부서번호, 사원이름 순으로 출력 부서정보는 모두 출력
-- + 
select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from emp e, dept d
where e.deptno(+) = d.deptno 
order by d.deptno, e.ename;

-- left  outer join 
select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from dept d left outer join emp e
on e.deptno = d.deptno 
order by d.deptno, e.ename;

-- right outer join
select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from emp e right outer join dept d
on e.deptno = d.deptno 
order by d.deptno, e.ename;

--4.모든 부서정보, 사원정보, 급여 등급정보, 각 사원의 직속 상관의 정보를 
 --부서번호, 사원 번호 순서로 정렬하여 출력
 select d.deptno, d.dname,
        e.empno, e.ename, e.mgr, e.sal, e.deptno,
        s.losal, s.hisal, s.grade,
        e2.empno mgr_empno, e2.ename mgr_ename
 from emp e, dept d, salgrade s, emp e2
 where e.deptno(+) = d.deptno
 and e.sal between s.losal(+) and s.hisal(+)
 and e.mgr = e2.empno(+)
 order by d.deptno, e.empno;
 --join~on
 select d.deptno, d.dname,
        e.empno, e.ename, e.mgr, e.sal, e.deptno,
        s.losal, s.hisal, s.grade,
        e2.empno mgr_empno, e2.ename mgr_ename
 from emp e right outer join dept d    on (e.deptno = d.deptno)
            left outer join salgrade s on (e.sal between s.losal and s.hisal)
            left outer join emp e2     on (e.mgr = e2.empno)
 order by d.deptno, e.empno;
 ---
 select * from dept;
 select *
 from dept
 where EXISTS (
        select deptno
        from dept
        where deptno =20
      );
--p258 부서별 최대 급여를 가진 사원 정보 출력
select *
from emp
where (deptno, sal) in (
                    select deptno,  max(sal)
                    from emp
                    group by deptno
                    );

 select deptno,  max(sal)
 from emp
 group by deptno;

 

 








