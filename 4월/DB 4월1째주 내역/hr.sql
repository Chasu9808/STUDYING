-- hr계정으로 접속하여
-- @본인폴더\test_data_eng_수정.sql 을 실행합니다.(f5)]
--@D:\jung\test_data_eng_수정.sql;

--1) Professor 테이블에서 교수의 이름과 학과 명을 출력하되
--학과 번호가 101 번 이면 ‘Computer Engineering’ , 
--102 번이면 ‘Multimedia Engineering' , 
--103 번이면 ‘Software Engineering'
-- 나머지는 ‘ETC’ 로 출력하세요.
select * from Professor;
select profno, name, deptno, 
    decode(deptno, 101, 'Computer Engineering',
    102, 'Multimedia Engineering',
    103, 'Software Engineering',
    'ETC') 학과명
from Professor;

--2) student
select * from student;
--tel의 지역번호에서 02 서울, 051 부산, 052 울산, 053 대구 
-- 나머지는 기타로 출력
--이름, 전화번호, 지역 출력
select name, tel from student;
select  substr(tel, 1,3) from student;
select instr(tel, ')') from student;
select  substr(tel, 1,instr(tel, ')')-1) from student;
select name, tel, 
    decode(substr(tel, 1,instr(tel, ')')-1), '2','서울',
            '051','부산',
            '052','울산',
            '053','대구',
            '기타')지역
from student;
--professor 테이블
--학과별로 소속 교수들의 평균급여, 최소급여, 최대급여 출력
--단, 평균급여가 300 넘는 것만 출력
select deptno, round(avg(pay)) 평균급여, min(pay) 최소급여, max(pay) 최대급여
from professor
group by deptno
having avg(pay)>300
order by deptno;


--student 테이블
--학생 수가 4명 이상인 학년에 대해서 학년, 학생 수, 평균 키, 평균 몸무게를 출력
--단, 평균 키와 평균 몸무게는 소숫점 첫 번째 자리에서 반올림하고,
--출력순서는 평균 키가 높은 순부터 내림차순으로 출력하여라.
select * from student;
select grade||'학년', count(*) 학생수, round(avg(height)) 평균키, round(avg(weight)) 평균몸무게
from student
group by grade
having count(*) >= 4
order by avg(height) desc;

-- 학생이름, 지도교수 이름 출력
select * from student;
select * from professor;

select s.name 학생이름 , p.name 지도교수
from student s, professor p
where s.profno = p.profno;

--join~on
select s.name 학생이름 , p.name 지도교수
from student s  join professor p
on s.profno = p.profno;

--gift, customer
select * from  gift;
select * from customer;
-- 고객이름, 포인트 ,선물
select c.gname 고객이름,  c.point  포인트, g.gname 선물
from customer c, gift g
where c.point between g_start and g_end;

--join on
select c.gname 고객이름,  c.point  포인트, g.gname 선물
from customer c join  gift g
on c.point between g_start and g_end;

-- 
select * from student;
select * from score;
select * from hakjum;
-- 학생들의 이름, 점수(total) 학점 출력
select s.name, s1.total, h.grade
from student s, score s1, hakjum h
where s.studno = s1.studno 
  and s1.total between h.min_point and h.max_point;
  
select s.name, s1.total, h.grade
from student s, score s1, hakjum h
where s.studno = s1.studno 
   and s1.total >=  h.min_point
   and s1.total <= h.max_point;

--join ~ on
select s.name, s1.total, h.grade
from  student s join  score s1 
                on s.studno = s1.studno
                join hakjum h
                on s1.total >=  h.min_point
                and s1.total <= h.max_point;
--   student ,     professor      
-- 학생이름과 지도교수 이름 출력하되 지도교수가 정해지지 않은 학생 이름도 출력
--15명
select s.name, p.name 
from student s, professor p
where s.profno = p.profno;
--20 명
select count(*) from student;
select s.name, p.name 
from student s, professor p
where s.profno = p.profno(+);
-- 표준
select s.name, p.name 
from student s left outer join professor p
on  s.profno = p.profno;

select s.name, p.name
from professor p  right outer join   student s
on  s.profno = p.profno;

-- 101(deptno1) 번 학과에 소속된 지도교수 이름 출력
-- 단, 지도교수가 없는 학생도 출력(학생이름, 지도교수이름 출력)
select deptno1, name, profno
from student
where deptno1=101;

select s.name 학생, p.name 지도교수, deptno1
from student s, professor p
where s.profno = p.profno(+) and s.deptno1= 101;

select s.name 학생, p.name 지도교수, deptno1
from student s left outer join professor p
    on s.profno = p.profno
    where s.deptno1 =101;
----------------------
select * from dept2;
select * from emp2;
-- dept2에서 area가 Seoul Branch Office 인 사원의 사원번호, 이름, 부서번호 출력
select empno, name, deptno
from emp2 e, dept2 d
where e.deptno = d.dcode and area= 'Seoul Branch Office';
--서브쿼리
select empno, name, deptno
from emp2
where deptno in (
            select dcode
            from dept2
            where area ='Seoul Branch Office'
        ) ;
-----student 테이블
-- student 테이블에서 각 학년별 최대 몸무게를 가진 학생의 학년, 이름, 몸무게 출력
--학년별 최대 몸무게
select  grade, max(weight)
from student
group by grade;

select grade, name ,weight
from student
where (grade, weight)  in ( 
                        select  grade, max(weight)
                        from student
                        group by grade
                        );
-- (professor,  department)  테이블
-- 각 학과별 입사일 가장 오래된 교수의 교수번호, 이름 ,학과명 출력
-- 단 입사일은 오름차순   (professor,  department) 
select * from professor;
select deptno, min(hiredate)
from professor
group by deptno;

select p.profno, p.name, p.deptno, d.dname, p.hiredate
from professor p , department d
where p.deptno = d.deptno
and (p.deptno, p.hiredate) in (select deptno, min(hiredate)
                                from professor
                                group by deptno)
order by p.hiredate;  

select p.profno, p.name, p.deptno, d.dname, p.hiredate
from professor p , department d
where p.deptno = d.deptno
and (p.deptno, p.hiredate) in (select deptno, min(hiredate)
                                from professor
                                group by deptno)
order by p.deptno;  

select p.profno, p.name, p.deptno, d.dname, p.hiredate
from professor p , department d
where p.deptno = d.deptno
and (p.deptno, p.hiredate) in (select deptno, min(hiredate)
                                from professor
                                group by deptno)
order by 3;  -- 3 은 select  순서




    

















