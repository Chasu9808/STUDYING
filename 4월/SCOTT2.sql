--P238 
-- EMP�� DEPT�� �޿��� 3000�̻��̸� ���ӻ���� �ݵ�� ������
-- �����ȣ, �̸�, ��å,�Ŵ���,hiredate,sal,comm,deptno,dname, loc
-- join ~ using ���
select empno, ename, job, mgr, hiredate, sal, comm, deptno, dname, loc
from emp e join dept d using(deptno)
where sal >=3000 and mgr is not null;

select * from emp;
select * from dept;

select empno, ename, job, mgr, hiredate, sal, comm, d.deptno, dname, loc
from emp e join dept d 
on d.deptno = e.deptno and sal >=3000 and mgr is not null;
--P242 �������� WHERE �������� ������ ���� ��
SELECT * FROM EMP;
--WARD ���� ������ ���� ���� ��� �̸� ���
SELECT SAL FROM EMP WHERE ENAME = 'WARD';
SELECT ENAME
FROM EMP
WHERE SAL > (
            SELECT SAL 
            FROM EMP
            WHERE ENAME = 'WARD'
            );
-- 'ALLEN'�� ����(JOB)�� ���� ����� �̸�,�μ���,�޿�,�������
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
            
--'SMITH' ���� ���� �Ի��� ����� ����
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
-- ��ü ����� ��� �ӱݺ��� ���� ����� �����ȣ,�̸�,�μ���,�Ի��� ���


SELECT EMPNO,ENAME,D.DNAME,HIREDATE
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND
SAL > (
            SELECT AVG(SAL)
            FROM EMP
      );


--P248
-- ��ü ����� ��� �޿����� �۰ų� ���� �޿��� �ް� �ִ�
-- 20�� �μ��� ��� �� �μ�����
-- �����ȣ,�̸�,����,�޿�,�μ���ȣ,�μ���,�μ�����

SELECT EMPNO,ENAME,JOB,SAL,E.DEPTNO,DNAME,LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
AND SAL <= (
            SELECT AVG(SAL)
            FROM EMP
           )
AND D.DEPTNO = 20;

--�� �μ��� �ְ�޿��� ������ �޿��� �޴� ��������� ���
SELECT *
FROM EMP
WHERE SAL IN (
                SELECT MAX(SAL)
                FROM EMP
                GROUP BY DEPTNO
             );
-- 30�� �μ� �߿��� 10�� �μ����� ���� ����(JOB)�� �ϴ� SALES
-- ����� �����ȣ, �̸�, �μ���, �Ի���, ���� ���
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
--MGR �� KING�� ����� �̸��� JOB ��� 
--�������� ���
SELECT ENAME, JOB
FROM EMP
WHERE MGR = (
                SELECT EMPNO FROM EMP
                WHERE ENAME = 'KING'
               );

--�������� X

SELECT E1.ENAME, E1.JOB
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO AND E2.ENAME = 'KING';

SELECT * FROM EMP;

-- �Ŵ����� KING�̰ų� FORD�� ����� �̸��� ���� ���

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

--30�� �μ����� ���� �޿��� �޴� ��� ��� ANY ,ALL ���
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
                
-- 239~240P 8�� ��������
-- �޿� SAL 2000�ʰ��� ������� �μ�����, ������� ���
SELECT E.DEPTNO, DNAME, EMPNO,ENAME,SAL
FROM EMP E,DEPT D
WHERE SAL > 2000 AND E.DEPTNO = D.DEPTNO;

SELECT DEPTNO, DNAME, EMPNO,ENAME,SAL
FROM EMP E NATURAL JOIN DEPT D
WHERE SAL > 2000;

--�� �μ��� (���,�ִ�,�ּ�)�޿�, ����� ���
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

--��� �μ������� ��������� �μ���ȣ,����̸����� �����Ͽ� ����ϱ�
SELECT E.DEPTNO, D.DNAME, E.EMPNO, E.ENAME,E.JOB,E.SAL
FROM EMP E, DEPT D
WHERE D.DEPTNO = E.DEPTNO(+)
ORDER BY D.DEPTNO,E.ENAME ASC;

SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME,E.JOB,E.SAL
FROM DEPT D LEFT OUTER JOIN EMP E
ON E.DEPTNO=D.DEPTNO
ORDER BY D.DEPTNO,E.ENAME ASC;

-- ��� �μ� ����, ��� ����, �޿� ��� ����, �� ����� ���� ����� ������ �μ���ȣ,
-- �����ȣ ������ �����Ͽ� ����� ������
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
                
--P258 �μ��� �ִ� �޿��� ���� ��� ���� ���
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