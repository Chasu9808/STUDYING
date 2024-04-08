--트랜잭션(ACID)
-- A  원자성 ( Atomicity )
-- C  일관성 ( Consistency ) : 일관적으로 DB 상태 유지
-- I  격리성 ( Isolation ) 
   -- :  트랜잭션 수행시 다른 트랜잭션의 작업이 끼어들지 못하도록 보장하는 것
-- D  지속성 ( Durability ) : 성공적으로 수행된 트랜잭션은 영원히 반영이 되는 것
   
--13장 p327  
--데이터사전
    --USER_   / ALL_  /DBA_
--인덱스  
--View(뷰)- 가상의 테이블(편의성, 보안성)
select * from dictionary;
--scott 계정이 가지고 있는 모든 테이블 조회
select table_name from user_tables;
--scott 계정이 가지고 있는 모든 객체 정보 조회
select owner, table_name from all_tables;

--p341
--View(뷰)- 가상의 테이블(편의성, 보안성)
create view vw_emp20
as (select empno, ename, job, deptno
    from emp
    where deptno > 20
);
select * from vw_emp20;
select * from user_views;

create or replace view vw_emp20
as
select empno, ename, job, deptno
from emp
where deptno>20;
--emp 테이블 전체 내용을  v_emp1  뷰 생성
create or replace view v_emp1
as
select * 
from emp;
select * from v_emp1;
-- v_emp1 (3000, '홍길동', sysdate) 추가
insert into v_emp1(empno, ename, hiredate)
values(3000, '홍길동', sysdate);
select * from v_emp1;

select * from emp;

delete from emp
where empno =3000;
commit;
select * from emp;

drop view v_emp1;

create or replace view v_emp1
as 
select empno, ename, hiredate
from emp
with read only;  -- 읽기만

select * from v_emp1;
insert into v_emp1(empno, ename, hiredate)
values(3000, '홍길동',sysdate);  -- 오류발생

--부서별 최대 급여를 받는 사람의 부서번호, 부서명 ,급여 출력
select * from emp;  -- 12행
select * from dept; -- 4행
--부서별 최대 급여
select deptno, max(sal) sal
from emp
group by deptno;

select e.deptno, d.dname, e.sal
from emp e, dept d
where e.deptno = d.deptno
and (e.deptno, e.sal) in (select deptno, max(sal)
                        from emp
                        group by deptno);
 ------------------   
 --인라인뷰
select e.deptno, d.dname, e.sal
from (select deptno, max(sal) sal
             from emp
             group by deptno) e, dept d
where e.deptno = d.deptno;
--p346
select * from emp order by ename desc;
-- 위에서 3개만 출력
select * from emp;

select  rownum rn, e.*
from (select *
      from emp 
      order by ename desc) e
where rownum <=3;

--with 사용 (p259)
with e as (select * from emp  order by ename desc)
select rownum, e.*
from e
where rownum <=3;

--p340 시퀀스
 create table dept_sequence
 as select *
 from dept
 where 1<>1;
 
 select * from dept_sequence;
 --시퀀스 생성
create sequence seq_dept_sequence
INCREMENT BY 10
START WITH 10
MAXVALUE  90
MINVALUE 0
NOCYCLE
NOCACHE;

select * from user_sequences;
select * from dept_sequence;
-- 'DATABASE' 'SEOUL' 값 추가
insert into dept_sequence(dname, loc)
values('DATABASE', 'SEOUL');
select * from dept_sequence;
insert into dept_sequence(deptno, dname, loc)
values(seq_dept_sequence.nextval,'DATABASE', 'SEOUL');
commit;
select * from dept_sequence;

insert into dept_sequence(deptno, dname, loc)values(seq_dept_sequence.nextval,'DATABASE1', 'SEOUL1');
insert into dept_sequence(deptno, dname, loc)values(seq_dept_sequence.nextval,'DATABASE2', 'SEOUL2');
insert into dept_sequence(deptno, dname, loc)values(seq_dept_sequence.nextval,'DATABASE3', 'SEOUL3');
insert into dept_sequence(deptno, dname, loc)values(seq_dept_sequence.nextval,'DATABASE4', 'SEOUL4');
insert into dept_sequence(deptno, dname, loc)values(seq_dept_sequence.nextval,'DATABASE5', 'SEOUL5');
commit;
select seq_dept_sequence.currval
from dual;
-- 시퀀스 삭제
drop SEQUENCE seq_dept_sequence;
drop table dept_sequence;

create sequence emp_seq
INCREMENT By 1
START WITH 1
MINVALUE 1
NOCACHE
NOCYCLE;

select emp_seq.nextval  from dual;

alter SEQUENCE emp_seq
INCREMENT By  20
CYCLE;

select emp_seq.nextval  from dual;
drop SEQUENCE emp_seq;

--  p360  제약조건  ===> 데이터무결성
--not null
--unique
--primary key(기본키) - not null / unique
--foreign key(외래키)
--check

-- p362
create table table_notnull(
    login_id varchar2(20) not null,
    login_pwd varchar2(20) not null,
    tel varchar2(20)
);
insert into table_notnull(login_id, login_pwd, tel) values('aa','1111','010-1111-2222');
commit;
select * from table_notnull;
insert into table_notnull(login_id, login_pwd, tel) values('bb','1111','010-1111-2222');
commit;
select * from table_notnull;

insert into table_notnull(login_id, login_pwd) values('cc','1111');
commit;
select * from table_notnull;

insert into table_notnull(login_pwd, tel) values('1111','010-1111-2222'); --오류발생  not null

create table table_notnull2(
    login_id varchar2(20) CONSTRAINT tbl_nn2_loginID not null,
    login_pwd varchar2(20)CONSTRAINT tbl_nn2_loginPWD not null,
    tel varchar2(20)
);
insert into table_notnull2 values('aa','1111','010-1111-2222');
insert into table_notnull2 values('aa','1111','010-1111-2222');
commit;

alter table table_notnull2
MODIFY (tel CONSTRAINT tbl_nn2_tel not null);
--오류발생(tel 이 not null 임)
--insert into table_notnull2(login_id, login_pwd) values('aa','1111');

--table_notnull2 에서  login_id 에 unique 제약조건 부여
alter table table_notnull2
modify(login_id  CONSTRAINT tbl_nn2_unique_loginID unique);

select * from table_notnull2;
delete from table_notnull2;
commit;
insert into table_notnull2 values('aa','1111','010-1111-2222');
-- 오류발생 (무결성 제약 조건(SCOTT.TBL_NN2_UNIQUE_LOGINID)에 위배)
--insert into table_notnull2 values('aa','1111','010-1111-2222');
commit;

--제약 조건 tbl_nn2_tel 삭제
alter table table_notnull2
drop constraint tbl_nn2_tel;

create table table_unique(
    login_id varchar2(20) constraint tbl_unique_loginID unique,
    login_pwd varchar2(20) not null,
    tel varchar2(20)
);
insert into table_unique values('aa','1111','010-1111-2222');
--오류발생
--insert into table_unique values('aa','1111','010-1111-2222');
insert into table_unique values(null,'1111','010-1111-2222');
insert into table_unique values(null,'3333','010-1111-4444');
select * from table_unique;
-- 제약 조건 조회
select owner, constraint_name
from user_constraints;

drop table table_unique;
drop table table_notnull2;
drop table table_notnull;
----
create table table_pk(
    login_id varchar2(20) primary key,
    login_pwd varchar2(20) not null,
    tel varchar2(20)
);
--오류발생 login_id 기본키이므로 반드시 not null,  unique 해야 함.
--insert into table_pk(login_pwd, tel) values('1111','010');
create table table_pk2(
    login_id varchar2(20) CONSTRAINT table_pk2_id primary key,
    login_pwd varchar2(20) not null,
    tel varchar2(20)
);
--오류발생 login_id 기본키이므로 반드시 not null,  unique 해야 함.
--insert into table_pk2(login_pwd, tel) values('1111','010');

--1)시퀀스 및 테이블 생성
--board(num, title, writer, content, regdate)
--      number,                       date(기본값 : sysdate)
-- num : 기본키
-- 시퀀스  생성:board_seq  1/1/1 no
create table board(
    num number(3) primary key,
    title varchar2(30),
    writer varchar2(30),
    content varchar2(100),
    regdate date default sysdate
);

create sequence board_seq
Increment by 1
start with 1
minvalue 1
nocycle
nocache;

--2) 데이터 추가
--(1, board1, 홍길동, 1번 게시글, 24/04/08), (2, board2, 강감찬, 2번 게시글, 24/04/08)
insert into board(num, title, writer, content)
values(board_seq.nextval, 'board1','홍길동','1번 게시글');
insert into board
values(board_seq.nextval, 'board1','홍길동','1번 게시글',sysdate);
-- 2번이 있으므로 무결성 제약조건 위반으로 오류
--insert into board values(2, 'board2','홍길동2','2번 게시글',sysdate);
commit;
select * from board;
--writer 컬럼명을  name 으로 변경
alter table board
rename column writer to name;

insert into board
values(board_seq.nextval, 'board2','홍길동2','2번 게시글',sysdate);
insert into board
values(board_seq.nextval, 'board3','홍길동3','3번 게시글',sysdate);
insert into board
values(board_seq.nextval, 'board4','홍길동4','4번 게시글',sysdate);
insert into board
values(board_seq.nextval, 'board5','홍길동5','5번 게시글',sysdate);
commit;
select * from board;
--board  num 내림차순으로 해서 위에서 3개만 출력
select * from board order by num desc;

select rownum rn, b.*
from (select * from board order by num desc) b
where rownum <=3;

drop sequence board_seq;
drop table board;
---
create table table_name(
    col1 varchar2(20) CONSTRAINT  table_name_pk_col1 primary key,
    col2 varchar2(20) not null,
    col3 varchar2(20)
);

create table table_name2(
    col1 varchar2(20),
    col2 varchar2(20) not null,
    col3 varchar2(20),
    primary key(col1)
);

create table table_name3(
    col1 varchar2(20),
    col2 varchar2(20) not null,
    col3 varchar2(20),
    CONSTRAINT  table_name3_pk_col1 primary key(col1)
);
drop table table_name;
drop table table_name2;
drop table table_name3;

-----외래키
-- dept_fk(부서번호, 부서명 , 지역)
create table dept_fk(
    deptno number(2) constraint deptfk_depntno_pk primary  key,
    dname varchar2(20),
    loc varchar2(20)
);
--emp_fk(사원번호, 사원명, 직책, 부서번호)
create table emp_fk(
    empno number(2) constraint empfk_empno_pk primary key,
    ename varchar2(20),
    job varchar2(20),
    deptno number(2)
);
insert into dept_fk values(10,'영업','부산');
insert into dept_fk values(20,'IT','서울');
insert into emp_fk values(1, '홍길동', '사원', 30);
commit;
select * from dept_fk;
select * from emp_fk;
drop table emp_fk;
create table emp_fk(
    empno number(2) constraint empfk_empno_pk primary key,
    ename varchar2(20),
    job varchar2(20),
    deptno number(2) constraint empfk_deptno_fk 
    references dept_fk(deptno)
);
-- 오류발생 dept_fk 테이블에 30번 부서가 없는데 30번 부서 추가하려고 해서 오류
insert into emp_fk values(1, '홍길동', '사원', 30);
insert into emp_fk values(1, '홍길동', '사원', 20);
insert into emp_fk(empno, ename, job) values(2, '강감찬', '팀장');
commit;
select * from emp_fk;
delete from emp_fk where empno=1;
insert into emp_fk values(1, '홍길동', '사원', 20);
commit;

select * from dept_fk;
-- 오류발생 
delete from dept_fk where deptno=20;
-- 오류발생 
update emp_fk set deptno =30 where empno =1;
-- 외래키 제약조건을 삭제
alter table emp_fk
drop CONSTRAINT empfk_deptno_fk;
-- 외래키 삭제로  insert 가능
insert into emp_fk values(3, '강감찬', '팀장', 40);
select * from emp_fk;
delete from emp_fk where empno=3;
commit;
--삭제한 외래키 추가
alter table emp_fk
add  CONSTRAINT empfk_deptno_fk FOREIGN KEY(deptno)
REFERENCES dept_fk(deptno)
on delete cascade;

delete from dept_fk where deptno=20;
select * from dept_fk;
select * from emp_fk;

create table table_check(
    login_id varchar2(20) CONSTRAINT tb_check_id_pk primary key,
    login_pwd varchar(20)
    CONSTRAINT tb_check_pwd_ch check (length(login_pwd) > 3),
    tel varchar2(20)
);
-- 오류발생 (체크 제약조건(SCOTT.TB_CHECK_PWD_CH)이 위배)
insert into table_check values('aaa','123','010');
--오류없음
insert into table_check values('aaa','12345','010');
commit;
select * from table_check;

-- board(num, title, userid, content, regdate) : 기본키(num)
-- comments(cnum,userid, msg, regdate, bnum ): 기본키(cnum) 외래키(bnum)
-- member(userid,username, tel) 기본키(userid)

-- 시퀀스 board_seq  / comment_seq

drop table board;
drop table member;
drop table comments;

create table member(
    userid number(3) CONSTRAINT pk_member1 primary key,
    username varchar2(30),
    tel varchar2(20)
);

create table board(
    num number(3) CONSTRAINT  pk_board1 primary key,
    title varchar2(30),
    userid number(3) CONSTRAINT fk_board1 
    references member(userid)
    on delete cascade,
    content varchar2(100),
    regdate date default sysdate
);
create sequence board_seq
Increment by 1
start with 1
minvalue 1
nocycle
nocache;

create sequence comment_seq
Increment by 1
start with 1
minvalue 1
nocycle
nocache;

create table comments(
    cnum number(3) CONSTRAINT  pk_comments primary key,
    userid number(3) CONSTRAINT fk_comments 
    references member(userid)
    on delete cascade,
    msg varchar2(100),
    regdate date default sysdate,
    bnum number(3) references  board(num)
    on delete cascade
 );
 
 desc USER_CONSTRAINTS;
  -- 제약조건(단, 테이블 명은 대문자로)
 select * from USER_CONSTRAINTS
 where table_name = 'BOARD';
 --제약조건 삭제
 alter table BOARD
 drop constraint FK_board1;
 



















