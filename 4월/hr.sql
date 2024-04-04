-- 1. professor ���̺��� ������ �̸��� �а����� ����ϵ�
-- �а� ��ȣ�� 101���̸� 'Computer Engineering'
-- 102 = 'Multimedia Engineering'
-- 103 = 'Software Engineering'
-- �������� 'ETC'�� ����ϼ���

SELECT * FROM PROFESSOR;
SELECT NAME,DEPTNO,
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

SELECT NAME,TEL,
CASE
WHEN SUBSTR(TEL,1,3) LIKE '02%' THEN '����'
WHEN SUBSTR(TEL,1,3) LIKE '051%' THEN '�λ�'
WHEN SUBSTR(TEL,1,3) LIKE '052%' THEN '���'
WHEN SUBSTR(TEL,1,3) LIKE '053%' THEN '�뱸'
ELSE '��Ÿ'
END AS "����"
FROM STUDENT;

