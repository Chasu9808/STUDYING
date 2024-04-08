-- CTAS 사용
-- dept2 테이블에서 dcode가 1000,1001,1002인 데이터로 구성된
-- dept6 테이블 생성(dcode,dname 구성)
--1. dept2 -> dept6(dcode,dname,area)
create table dept6 as
select dcode,dname,area from dept2
where dcode in(1000,1001,1002);

-- 2. location(크기 200) 컬럼 추가
alter table dept6 add location varchar2(200);

-- 3. dcode 1000의 location을 부산으로 수정
update dept6 set location = '부산'
where dcode = 1000;

-- 4. 2000,TEAM,BUSAN, 부산 -->추가
insert into dept6 
values(2000,'TEAM','BUSAN','부산');
select * from dept6;

-- 5. decode가 2000번인 애를 삭제
delete from dept6
where dcode=2000;

-- 6. location 칼럼 크기를 70으로 수정
alter table dept6
modify (location varchar2(70));

desc dept6;
-- 7. location 컬럼 삭제
alter table dept6
drop column location;
-- 8. dept6 테이블 삭제
drop table dept6;

select * from professor;

create table professor6 as
select * from professor
where 1<>1;

select * from professor6;
-- 9. professor6 삭제

drop table professor6;

