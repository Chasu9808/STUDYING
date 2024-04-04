--P238 
-- EMP와 DEPT의 급여가 3000이상이며 직속상관이 반드시 존재함
-- 사원번호, 이름, 직책,매니저,hiredate,sal,comm,deptno,dname, loc
-- join ~ using 사용
select empno, ename, job, mgr, hiredate, sal, comm, deptno, dname, loc
from emp e join dept d using(deptno)
where sal >=3000 and mgr is not null;

select * from emp;
select * from dept;

select empno, ename, job, mgr, hiredate, sal, comm, d.deptno, dname, loc
from emp e join dept d 
on d.deptno = e.deptno and sal >=3000 and mgr is not null;
--P242 서브쿼리 WHERE 조건전에 쿼리를 들어가는 것
SELECT * FROM EMP;
--WARD 보다 월급이 많이 받은 사원 이름 출력
SELECT SAL FROM EMP WHERE ENAME = 'WARD';
SELECT ENAME
FROM EMP
WHERE SAL > (
            SELECT SAL 
            FROM EMP
            WHERE ENAME = 'WARD'
            );
-- 'ALLEN'의 직무(JOB)와 같은 사람의 이름,부서명,급여,직무출력
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT ENAME,JOB,D.DNAME,SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO 
AND JOB = (
            SELECT JOB 
            FROM EMP
            WHERE ENAME = 'ALLEN'
          )
            AND ENAME NOT LIKE 'ALLEN';
            
--'SMITH' 보다 일찍 입사한 사원의 정보
SELECT *
FROM EMP
WHERE HIREDATE < '81/02/20';

SELECT *
FROM EMP
WHERE HIREDATE < 
                (
                    SELECT HIREDATE
                    FROM EMP
                    WHERE ENAME = 'ALLEN'
                );
-- 전체 사원의 평균 임금보다 많은 사원의 사원번호,이름,부서명,입사일 출력


SELECT EMPNO,ENAME,D.DNAME,HIREDATE
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND
SAL > (
            SELECT AVG(SAL)
            FROM EMP
      );


--P248
-- 전체 사원의 평균 급여보다 작거나 같은 급여를 받고 있는
-- 20번 부서의 사원 및 부서정보
-- 사원번호,이름,직무,급여,부서번호,부서명,부서지역

SELECT EMPNO,ENAME,JOB,SAL,E.DEPTNO,DNAME,LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND SAL <= (
            SELECT AVG(SAL)
            FROM EMP
           )
AND D.DEPTNO = 20;

--각 부서별 최고급여와 동일한 급여를 받는 사원정보를 출력
SELECT *
FROM EMP
WHERE SAL IN (
                SELECT MAX(SAL)
                FROM EMP
                GROUP BY DEPTNO
             );
-- 30번 부서 중에서 10번 부서에는 없는 업무(JOB)를 하는 SALES
-- 사원의 사원번호, 이름, 부서명, 입사일, 지역 출력
SELECT * FROM DEPT;

SELECT JOB FROM EMP E
WHERE E.DEPTNO = 10;

SELECT JOB FROM EMP
WHERE DEPTNO = 30;

SELECT EMPNO,ENAME,D.DNAME,HIREDATE,D.LOC
FROM EMP E,DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND E.DEPTNO = 10
AND E.JOB NOT IN (
                     SELECT JOB FROM EMP 
                     WHERE DEPTNO = 30                  
                );
--MGR 이 KING인 사원의 이름과 JOB 출력 
--서브쿼리 출력
SELECT ENAME, JOB
FROM EMP
WHERE MGR = (
                SELECT EMPNO FROM EMP
                WHERE ENAME = 'KING'
               );

--서브쿼리 X

SELECT E1.ENAME, E1.JOB
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO AND E2.ENAME = 'KING';

SELECT * FROM EMP;

-- 매니저가 KING이거나 FORD인 사원의 이름과 직급 출력

SELECT EMPNO,ENAME,JOB,MGR
FROM EMP
WHERE MGR = (
                SELECT EMPNO FROM EMP
                WHERE ENAME = 'FORD'
            )
OR
MGR = (
                SELECT EMPNO FROM EMP
                WHERE ENAME = 'KING'
            )
;

SELECT ENAME,JOB
FROM EMP
WHERE MGR IN (
                SELECT EMPNO
                FROM EMP
                WHERE ENAME = 'KING' OR ENAME = 'FORD'
                );
            
SELECT E.ENAME, E.JOB
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO AND (M.ENAME = 'KING' OR M.ENAME='FORD');

--P251
SELECT ENAME, SAL
FROM EMP
WHERE SAL < ANY(SELECT SAL FROM EMP WHERE JOB='SALESMAN'
                OR ENAME='FORD' );

SELECT ENAME,JOB,SAL
FROM EMP;

--30번 부서보다 적은 급여를 받는 사원 출력 ANY ,ALL 사용
SELECT ENAME, SAL
FROM EMP
WHERE SAL < ANY(
                    SELECT MAX(SAL) FROM EMP WHERE DEPTNO = '30'
                );

SELECT ENAME, SAL
FROM EMP          
WHERE SAL < ALL(
                    SELECT MAX(SAL) FROM EMP WHERE DEPTNO = '30'
                );
                
-- 239~240P 8장 연습문제
-- 급여 SAL 2000초과인 사원들의 부서정보, 사원정보 출력
SELECT E.DEPTNO, DNAME, EMPNO,ENAME,SAL
FROM EMP E,DEPT D
WHERE SAL > 2000 AND E.DEPTNO = D.DEPTNO;

SELECT DEPTNO, DNAME, EMPNO,ENAME,SAL
FROM EMP E NATURAL JOIN DEPT D
WHERE SAL > 2000;

--각 부서별 (평균,최대,최소)급여, 사원수 출력
SELECT E.DEPTNO,DNAME,TRUNC(AVG(SAL)) AVG_SAL,MAX(SAL) MAX_SAL,MIN(SAL) MIN_SAL,COUNT(*) CNT
FROM EMP E,DEPT D
WHERE E.DEPTNO = D.DEPTNO
GROUP BY E.DEPTNO,DNAME;

SELECT E.DEPTNO,DNAME,ROUND(AVG(SAL)) AVG_SAL,MAX(SAL) MAX_SAL,MIN(SAL) MIN_SAL,COUNT(*) CNT
FROM EMP E JOIN DEPT D 
ON E.DEPTNO = D.DEPTNO
GROUP BY E.DEPTNO,DNAME;

SELECT DEPTNO,DNAME,TRUNC(AVG(SAL)) AVG_SAL,MAX(SAL) MAX_SAL,MIN(SAL) MIN_SAL,COUNT(*) CNT
FROM EMP E JOIN DEPT D
USING(DEPTNO)
GROUP BY DEPTNO,DNAME;

--모든 부서정보와 사원정보를 부서번호,사원이름으로 정렬하여 출력하기
SELECT E.DEPTNO, D.DNAME, E.EMPNO, E.ENAME,E.JOB,E.SAL
FROM EMP E, DEPT D
WHERE D.DEPTNO = E.DEPTNO(+)
ORDER BY D.DEPTNO,E.ENAME ASC;

SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME,E.JOB,E.SAL
FROM DEPT D LEFT OUTER JOIN EMP E
ON E.DEPTNO=D.DEPTNO
ORDER BY D.DEPTNO,E.ENAME ASC;

-- 모든 부서 정보, 사원 정보, 급여 등급 정보, 각 사원의 직속 상관의 정보를 부서번호,
-- 사원번호 순서로 정렬하여 출력해 보세요
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;

SELECT D.DEPTNO, D.DNAME, 
       E.EMPNO, E.ENAME, E.MGR, E.SAL, E.DEPTNO,
       S.LOSAL, S.HISAL, S.GRADE,
       E2.EMPNO MGR_EMPNO, E2.ENAME MGR_ENAME
FROM EMP E, DEPT D, SALGRADE S, EMP E2
WHERE E.DEPTNO(+) = D.DEPTNO
AND E.SAL BETWEEN S.LOSAL(+) AND S.HISAL(+)
AND E.MGR = E2.EMPNO(+)
ORDER BY D.DEPTNO, E.EMPNO;

SELECT D.DEPTNO, D.DNAME, 
       E.EMPNO, E.ENAME, E.MGR, E.SAL, E.DEPTNO,
       S.LOSAL, S.HISAL, S.GRADE,
       E2.EMPNO MGR_EMPNO, E2.ENAME MGR_ENAME
FROM EMP E 
RIGHT OUTER JOIN DEPT D
ON(E.DEPTNO = D.DEPTNO)
LEFT OUTER JOIN SALGRADE S
ON(E.SAL BETWEEN S.LOSAL AND S.HISAL)
LEFT OUTER JOIN EMP E2
ON(E.MGR = E2.EMPNO)
ORDER BY D.DEPTNO, E.EMPNO;

SELECT * FROM DEPT
WHERE EXISTS (
                SELECT DEPTNO
                FROM DEPT
                WHERE DEPTNO =20
                );
                
--P258 부서별 최대 급여를 가진 사원 정보 출력
SELECT DEPTNO, MAX(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT *
FROM EMP
WHERE(DEPTNO,SAL) IN (
                        SELECT DEPTNO, MAX(SAL)
                        FROM EMP
                        GROUP BY DEPTNO
                        );