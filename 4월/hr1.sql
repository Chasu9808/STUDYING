-- 1. professor ���̺��� ������ �̸��� �а����� ����ϵ�
-- �а� ��ȣ�� 101���̸� 'Computer Engineering'
-- 102 = 'Multimedia Engineering'
-- 103 = 'Software Engineering'
-- �������� 'ETC'�� ����ϼ���

SELECT * FROM PROFESSOR;
SELECT PROFNO, NAME,DEPTNO,
DECODE(DEPTNO,101,'Computer Engineering',
              102,'Multimedia Engineering',
              103, 'Software Engineering',
              'ETC')
FROM PROFESSOR;

-- 2. STUDENT
SELECT * FROM STUDENT;
-- TEL�� ������ȣ���� 02 ����, 051 �λ�, 052 ���, 053 �뱸
-- �������� ��Ÿ�� ���
-- �̸�, ��ȭ��ȣ, ���� ���

-- SELECT NAME,TEL,
-- CASE
-- WHEN SUBSTR(TEL,1,3) LIKE '02%' THEN '����'
-- WHEN SUBSTR(TEL,1,3) LIKE '051%' THEN '�λ�'
-- WHEN SUBSTR(TEL,1,3) LIKE '052%' THEN '���'
-- WHEN SUBSTR(TEL,1,3) LIKE '053%' THEN '�뱸'
-- ELSE '��Ÿ'
-- END AS "����"
-- FROM STUDENT;

SELECT NAME, TEL,
DECODE (SUBSTR(TEL ,1,INSTR(TEL, ')')-1),'2','����',
'051','�λ�',
'052','���',
'053','�뱸',
'��Ÿ')����
FROM STUDENT;

-- PROFESSOR ���̺�
-- �а����� �Ҽ� �������� ��ձ޿�, �ּұ޿�, �ִ�޿� ���
-- ��, ��ձ޿��� 300 �Ѵ� �͸� ���
SELECT * FROM PROFESSOR;
SELECT DEPTNO ,ROUND(AVG(PAY)),MIN(PAY),MAX(PAY)
FROM PROFESSOR
GROUP BY DEPTNO
HAVING AVG(PAY) > 300
ORDER BY DEPTNO;

--STUDENT ���̺�
--�л����� 4�� �̻��� �г⿡ ���ؼ� �г�, �л� ��, ��� Ű, ��� �����Ը� ���
--��, ��� Ű�� ��� �����Դ� �Ҽ��� ù ��° �ڸ����� �ݿø��ϰ�,
--��¼����� ��� Ű�� ���� ������ ������������ ����Ͽ���.
SELECT * FROM STUDENT;
SELECT GRADE ||'�г�', COUNT(*) �л���, ROUND(AVG(HEIGHT)) ���Ű, ROUND(AVG(WEIGHT)) ��ո�����
FROM STUDENT
GROUP BY GRADE
HAVING COUNT(*) >=4
ORDER BY AVG(HEIGHT) DESC;

-- �л��̸�, �������� �̸� ���
SELECT * FROM STUDENT;
SELECT * FROM PROFESSOR;


SELECT S.NAME �л�,P.NAME ��������  
FROM STUDENT S,PROFESSOR P
WHERE S.PROFNO = P.PROFNO;

SELECT S.NAME �л�,P.NAME �������� 
FROM STUDENT S JOIN PROFESSOR P
ON S.PROFNO = P.PROFNO;

--GIFT, CUSTOMER
SELECT * FROM GIFT;
SELECT * FROM CUSTOMER;
--���̸�, ����Ʈ, ����
--�� � ����
SELECT C.GNAME ���̸�, C.POINT ����Ʈ, G.GNAME ����
FROM CUSTOMER C, GIFT G
WHERE C.POINT BETWEEN G_START AND G_END;

SELECT C.GNAME ���̸�, C.POINT ����Ʈ, G.GNAME ����
FROM CUSTOMER C JOIN GIFT G
ON C.POINT BETWEEN G_START AND G_END;

--
SELECT * FROM STUDENT;
SELECT * FROM SCORE;
SELECT * FROM HAKJUM;

-- �л����� �̸�, ����, ���� ���
SELECT S.NAME, C.TOTAL, H.GRADE
FROM STUDENT S,SCORE C,HAKJUM H
WHERE S.STUDNO = C.STUDNO AND C.TOTAL BETWEEN H.MIN_POINT AND H.MAX_POINT;  

SELECT S.NAME, C.TOTAL, H.GRADE
FROM STUDENT S,SCORE C,HAKJUM H
WHERE S.STUDNO = C.STUDNO 
AND C.TOTAL >= H.MIN_POINT 
AND C.TOTAL <= H.MAX_POINT;

--JOIN ON ���

SELECT S.NAME, C.TOTAL, H.GRADE
FROM STUDENT S JOIN SCORE C 
ON S.STUDNO = C.STUDNO
JOIN HAKJUM H
ON  C.TOTAL >= H.MIN_POINT 
AND C.TOTAL <= H.MAX_POINT;

-- student , professor
-- �л��̸��� �������� �̸� ����ϵ� ���������� �������� ���� �л��̸��� ���
SELECT * FROM STUDENT;
SELECT * FROM PROFESSOR;

SELECT S.NAME �л��̸�, P.NAME ��������
FROM STUDENT S,PROFESSOR P
WHERE S.PROFNO = P.PROFNO (+);

SELECT S.NAME, P.NAME
FROM STUDENT S LEFT OUTER JOIN PROFESSOR P
ON S.PROFNO = P.PROFNO;

SELECT S.NAME, P.NAME
FROM PROFESSOR P RIGHT OUTER JOIN STUDENT S
ON S.PROFNO = P.PROFNO;

--101�� �а��� �Ҽӵ� �������� �̸����
--�� ���������� ���� �л��� ���(�л��̸�, ���������̸� ���)

SELECT S.NAME �л��̸�, P.NAME ��������, P.DEPTNO �а�
FROM STUDENT S,PROFESSOR P
WHERE S.DEPTNO1 = 101 
AND S.PROFNO = P.PROFNO(+);

SELECT S.NAME �л��̸�, P.NAME ��������, P.DEPTNO �а�
FROM STUDENT S LEFT OUTER JOIN PROFESSOR P
ON S.PROFNO = P.PROFNO(+)   WHERE S.DEPTNO1 = 101;
------------------------
SELECT * FROM DEPT2;
SELECT * FROM EMP2;
-- DEPT2���� ������ SEOUL BRANCH OFFICE�� ����� �����ȣ,�̸�, �μ���ȣ

SELECT E.EMPNO,E.NAME,E.DEPTNO
FROM EMP2 E, DEPT2 D
WHERE DEPTNO = DCODE AND AREA = 'Seoul Branch Office';

--

SELECT EMPNO,NAME,DEPTNO
FROM EMP2
WHERE DEPTNO IN (
                    SELECT DCODE
                    FROM DEPT2
                    WHERE AREA = 'Seoul Branch Office'
                );
----
-- STUDENT ���̺� �� �г⺰ �ִ� �����Ը� ���� �л��� �г�,�̸�,�����Ը� ����ϼ���
SELECT * FROM STUDENT;

SELECT GRADE �г�, NAME �̸�, MAX(WEIGHT)������
FROM STUDENT
GROUP BY GRADE,NAME;

SELECT GRADE, NAME, WEIGHT
FROM STUDENT
WHERE(GRADE,WEIGHT) IN (
                        SELECT GRADE , MAX(WEIGHT)
                        FROM STUDENT
                        GROUP BY GRADE
                        );
                        
--(PROFESSOR, DEPARTMENT) ���̺�
-- �� �а��� �Ի��� ���� ������ ������ ������ȣ, �̸�, �а��� ���
-- �� �Ի����� �������� (PROFESSOR, DEPARTMENT)
SELECT * FROM PROFESSOR;
SELECT DEPTNO,MIN(HIREDATE)
FROM PROFESSOR
GROUP BY DEPTNO;

SELECT P.PROFNO,P.NAME,P.DEPTNO,
       D.DNAME,P.HIREDATE
FROM PROFESSOR P, DEPARTMENT D
WHERE P.DEPTNO = D.DEPTNO
AND (P.DEPTNO, P.HIREDATE) IN (SELECT DEPTNO, MIN(HIREDATE)
                                FROM PROFESSOR
                                GROUP BY DEPTNO)
ORDER BY P.DEPTNO;

SELECT P.PROFNO,P.NAME,P.DEPTNO,
       D.DNAME,P.HIREDATE
FROM PROFESSOR P, DEPARTMENT D
WHERE P.DEPTNO = D.DEPTNO
AND (P.DEPTNO, P.HIREDATE) IN (SELECT DEPTNO, MIN(HIREDATE)
                                FROM PROFESSOR
                                GROUP BY DEPTNO)
ORDER BY 3;
