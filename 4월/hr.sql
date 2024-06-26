-- 1. professor 테이블에서 교수의 이름과 학과명을 출력하되
-- 학과 번호가 101번이면 'Computer Engineering'
-- 102 = 'Multimedia Engineering'
-- 103 = 'Software Engineering'
-- 나머지는 'ETC'로 출력하세요

SELECT * FROM PROFESSOR;
SELECT NAME,DEPTNO,
DECODE(DEPTNO,101,'Computer Engineering',
              102,'Multimedia Engineering',
              103, 'Software Engineering',
              'ETC')
FROM PROFESSOR;

-- 2. STUDENT
SELECT * FROM STUDENT;
-- TEL의 지역번호에서 02 서울, 051 부산, 052 울산, 053 대구
-- 나머지는 기타로 출력
-- 이름, 전화번호, 지역 출력

SELECT NAME,TEL,
CASE
WHEN SUBSTR(TEL,1,3) LIKE '02%' THEN '서울'
WHEN SUBSTR(TEL,1,3) LIKE '051%' THEN '부산'
WHEN SUBSTR(TEL,1,3) LIKE '052%' THEN '울산'
WHEN SUBSTR(TEL,1,3) LIKE '053%' THEN '대구'
ELSE '기타'
END AS "지역"
FROM STUDENT;

