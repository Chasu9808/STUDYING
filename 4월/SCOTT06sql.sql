-- 트랜잭션(ACID)
-- A  원자성 (ATOMICITY)
-- C  일관성 (CONSISTENCY) : 일관적으로 DB의 내용유지
-- I  격리성 (ISOLATION) : 트랜잭션 수행 시 다른 트랜잭션의 작업이 끼어들지 못하도록 보장하는 것
-- D  지속성 (DURABILITY): 성공적으로 수행된 트랜잭션은 영원히 반영이 되는것

-- 13장 327P
-- 데이터 사전
-- USER__ / ALL__ /DBA__ = DB 제공운영체제 자체소유중인 베타데이터
-- 인덱스
-- VIEW(뷰)- 가상의 테이블(편의성, 보안성)
select * from dictionary;
-- SCOTT 계정이 가지고 있는 모든 테이블
select table_name from user_tables;
-- SCOTT 계정이 가지고 있는 모든 객체 정보 조회
select owner, table_name from all_tables;

-- 341P VIEW(뷰)- 가상의 테이블(편의성, 보안성)
create view vw_emp20
as (select empno,ename,job,deptno
    from emp
    where deptno > 20);
    
select * from vw_emp20;
select * from user_views;

create view vw_emp20
as
select empno, ename, job, deptno
from emp
where deptno > 20;

-- emp 테이블 전체 내용을 v_emp1 뷰 생성
create view v_emp1
as
select * from emp;
-- v_emp1 (3000, '홍길동', sysdate) 추가
insert into v_emp1(empno,ename,hiredate)
values(3000, '홍길동', sysdate);

select * from v_emp1;

select * from emp;

create or replace view v_emp1
as
select empno ,ename , hiredate
from emp
with read only; -- 읽기만 가능

drop view v_emp1;

insert into v_emp1(empno, ename, hiredate)
values(3000,'홍길동',sysdate);

-- 서브쿼리 = 인라인뷰

-- 부서별 최대급여를 받는 사람의 부서번호,부서명,급여를 출력
select * from emp;
select * from dept;

select e.deptno, d.dname,sal
from emp e, dept d
where e.deptno = d.deptno
and (e.deptno,e.sal) in (select deptno,max(sal)
                            from emp
                            group by deptno);
                            
select e.deptno, d.dname, e.sal
from (select deptno,max(sal) sal
                            from emp
                            group by deptno) e, dept d
where e.deptno = d.deptno;

-- p346
select * from emp order by ename desc;
-- 위에서 3개만 출력

select * from emp ;

select rownum rn, e.* 
from (
        select * from emp
        order by ename desc
) e
where rownum <=3;

--with 사용
with e as (select * from emp order by ename desc)
select rownum, e.*
from e
where rownum < 3;

-- p340 시퀀스
-- 자동으로 숫자증가 (rownum)

create table dept_sequence
as select 
* from dept
where 1=2;

select * from dept_sequence;

create sequence seq_dept_sequence
increment by 10 -- 증가 수치
start with  10 -- 시작순서
maxvalue 90 -- 최대값
minvalue 0 -- 최소값
NOCYCLE -- 일정 조건만족시 처음으로 돌아감 no 붙이면 돌아가지 않음
nocache; -- 시퀀스값은 유일하여 상관이없음

select * from user_sequences;
select * from dept_sequence;

-- 'DATABASE' 'SEOUL' 값 추가
insert into dept_sequence(dname, loc) 
values ('DATABASE', 'SEOUL');

insert into dept_sequence(deptno,dname, loc) 
values (seq_dept_sequence.nextval,'DATABASE', 'SEOUL');
commit;

select * from dept_sequence;

insert into dept_sequence(deptno,dname, loc) 
values (seq_dept_sequence.nextval,'DATABASE1', 'SEOUL');
commit;
insert into dept_sequence(deptno,dname, loc) 
values (seq_dept_sequence.nextval,'DATABASE2', 'SEOUL');
commit;
insert into dept_sequence(deptno,dname, loc) 
values (seq_dept_sequence.nextval,'DATABASE3', 'SEOUL');
commit;
insert into dept_sequence(deptno,dname, loc) 
values (seq_dept_sequence.nextval,'DATABASE4', 'SEOUL');
commit;
insert into dept_sequence(deptno,dname, loc) 
values (seq_dept_sequence.nextval,'DATABASE5', 'SEOUL');
commit;

select seq_dept_sequence.currval -- 현재 시퀀스 내용정리
from dual;

drop sequence seq_dept_sequence;
drop table dept_sequence;

create sequence emp_seq
increment by 1
start with 1
minvalue 1
nocache
nocycle;

select emp_seq.nextval
from dual;

alter sequence emp_seq
increment by 20
cycle;

drop sequence emp_seq;

-- 제약조건 p360
-- not null
-- unique
-- primary key(기본키) - not null / unique
-- foreign key (외래키)
-- check

-- P362 
create table table_notnull(
        login_id varchar2(20) not null,
        login_pwd varchar2(20) not null,
        tel varchar2(20)
    );
    
    insert into table_notnull(login_id, login_pwd, tel) 
    values ('aa','1111','010-1111-2222');
    commit;
    select * from table_notnull;
    
    insert into table_notnull(login_id, login_pwd) 
    values ('cc','1111');
    commit;
    select * from table_notnull;
    
    insert into table_notnull(login_pwd, tel) 
    values ('1111','010-1111-2222'); --오류발생 not null
    
    commit;
    select * from table_notnull;
    
    create table table_notnull2(
        login_id varchar2(20) constraint tbl_nn2_loginID not null ,
        login_pwd varchar2(20) constraint tbl_nn2_loginPWD not null,
        tel varchar2(20)
        );

insert into table_notnull2 values ('aaa','1111','010-1111-2222');
insert into table_notnull2 values ('aaa','1111','010-1111-2222');

select * from table_notnull2;
--조건이 null만 아니면 되는걸로 되어있기 때문에 중복조건 제한없음
-- 제약 조건 조회    
select owner, constraint_name
from user_constraints;

alter table table_notnull2
modify (
            tel constraint tb1_nn2_tel not null
        );
        
 insert into table_notnull2 (login_id,login_pwd) values ('aaa','1111');
 -- not null 조건 적용이 되어 기입이 되지 않는것이 확인됨
 
 --table_notnull2에서 login_id에 uunique 제약조건 설정
 
 alter table table_notnull2 modify(login_id constraint tb_nn2_unique_loginID unique);
 
 delete from table_notnull2;
 commit;
 
 --제약조건 삭제 tb1_nn2_tel 삭제
 
 alter table table_notnull2
 drop constraint tb1_nn2_tel;
 
 create table table_unique(
            login_id varchar2(20) constraint tb1_unique_loginID unique,
            login_pwd varchar2(20) not null,
            tel varchar2(20)
            );
            
            insert into table_unique values ('aaa','1111','010-1111-2222');
            insert into table_unique values (null,'1111','010-1111-2222');
            insert into table_unique values (null,'1122','010-1111-2222');
            
            select * from table_unique;
            
            drop table table_unique;
            drop table table_notnull2;
            drop table table_notnull;
            
create table table_pk(
                        login_id varchar2(20) primary key,
                        login_pwd varchar2(20) not null,
                        tel varchar2(20)
                        );

-- 기본키인 login_id에 값을 추가하지 않았기 때문에                        
insert into table_pk(login_pwd,tel) values ('1111','010');

create table table_pk2(
                        login_id varchar2(20) constraint table_pk2_id  primary key,
                        login_pwd varchar2(20) not null,
                        tel varchar2(20)
                        );
                        
-- 오류발생 login_id 기본키이므로 반드시 not null, unique 해야 함
-- insert into table_pk2(login_pwd, tel) values ('1111','010');

--1) 시퀀스 및 테이블 생성
-- board (num, title, writer, content, regdate)
-- number                               date(기본값: sysdate)
-- num: 기본키
-- 시퀀스 생성: board_seq 1/1/1 no cycle no cache

--2) 데이터 추가
--(1, board1, 홍길동, 1번게시글, 24/04/08), (2,board2,강감찬, 2번 게시글, 24/04/08)

create table board (
                        num number(20) constraint board_num_key primary key,
                        title varchar2(20),
                        writer varchar2(20),
                        content varchar2(200),
                        regdate date
                    );
                    
desc board;

alter table board
modify regdate default sysdate;

create sequence board_seq
    increment by 1
    start with 1
    minvalue 1
    maxvalue 99999
    nocycle
    nocache;


insert all 
into board values (1,'board1','홍길동','1번게시글','24/04/08')
into board values (2,'board2','강감찬','2번게시글','24/04/08')
select * from dual;

insert into board(num, title, writer, content);
-- values(board_seq.nextval,'board1','홍길동','1번게시글','24/04/08');

--writer 컬럼명을 name으로 수정
alter table board rename column writer to name;

insert into board
values(board_seq.nextval, 'board3', '홍길동3', '3번게시글',sysdate);

--board num 내림차순으로 해서 위에서 3개만 출력
select * from board
order by num desc;

select rownum rn, b.* 
from (
        select * from board
        order by num desc
) b
where rownum <=3;

drop sequence board_seq;
drop table board;

--- 
create table table_name 
(
  col1 varchar2(20) constraint table_name_pk_col1 primary key,
  col2 varchar2(20) not null,
  col3 varchar2(20)
  );

create table table_name2 
(
  col1 varchar2(20) 
  col2 varchar2(20) not null,
  col3 varchar2(20),
  primary key(col1)
  );
  
  create table table_name3 
(
  col1 varchar2(20), 
  col2 varchar2(20) not null,
  col3 varchar2(20),
  constraint table_name3_pk_col1 primary key(col1)
  );
  
drop table table_name;
drop table table_name2;
drop table table_name3;

create table dept_fk(
    deptno number(2) constraint deptfk_deptno_pk primary key,
    dname varchar2(20),
    loc varchar2(20)
    );
    
--emp_fk (사원번호, 사원명, 직책, 부서번호)

create table emp_fk(
    empno number(2) constraint empfk_empno_pk primary key,
    ename varchar2(20),
    job varchar2(20),
    deptno number(2)
    );
    
    insert into dept_fk values(10,'영업','부산');
    insert into dept_fk values(20,'IT','서울');
    insert into emp_fk values(1, '홍길동', '사원', '30');
    commit;
    
    select * from emp_fk;
    drop table emp_fk;
    
    select * from dept_fk;
    
    create table emp_fk(
    empno number(2) constraint empfk_empno_pk primary key,
    ename varchar2(20),
    job varchar2(20),
    deptno number(2) constraint empfk_deptno_fk 
    references dept_fk(deptno)-- 외래키 설정 외부와 내부에서 만족하는 동일한 조건
    
    );
    
    select * from emp_fk;
    
    insert into emp_fk values(1, '홍길동', '사원', 30);
    insert into emp_fk values(1, '홍길동', '사원', 20);
    insert into emp_fk (empno,ename,job) values(2, '강감찬', '팀장');
    -- 외래키는 null 값은 가능 다만 참조가 안되는 값은 확인 불가능
    
    delete from emp_fk where empno =1;
    commit;
    
    select * from dept_fk;
    -- 무결성 제약조건에 걸림
    delete from dept_fk
    where deptno=20;
    
    update emp_fk set deptno = 30 where empno =1;
    
    alter table emp_fk 
    drop constraint empfk_deptno_fk;
    -- 외래키 삭제로 인한 insert 가능
    insert into emp_fk values(3, '강감찬', '팀장', 40);
    select * from emp_fk;
    
    delete from emp_fk
    where empno = 3;
    commit;
    -- 삭제한 외래키 추가
    alter table emp_fk 
    add constraint empfk_deptno_fk foreign key(deptno)
    references dept_fk(deptno)
    on delete cascade; -- 종속된 리스트들이 함께 삭제된다.
    
    delete from dept_fk where deptno=20;
    rollback;
    
    select * from dept_fk;
    select * from emp_fk;
    
    --check 범위 제약조건
    
    create table table_check
    (
        login_id varchar2(20) constraint tb_check_id_pk primary key,
        login_pwd varchar2(20) 
        constraint tb_check_pwd_ch check(length(login_pwd)>3),
        tel varchar2(20)
    );
    
    insert into table_check values('aaa','123','010');
    -- 체크 제약조건 위배
    insert into table_check values('aaa','12345','010');
    
    select * from table_check;
    
-- board(num, title, userid, content, regdate) : 기본키 (num)
-- comment(cnum,userid,msg,regdate,bnum) : 기본키(cnum) 외래키(bnum)
-- member(userid,username,tel) 기본키 (userid)

create table board (
                        num number(20) constraint board_num_key primary key,
                        title varchar2(20),
                        userid varchar2(20),
                        content varchar2(200),
                        regdate date
                    );
                    
                    select * from board;
                    
create table comments (
                        cnum number(20) constraint cnum_num_key primary key,
                        userid varchar2(20),
                        msg varchar2(20),
                        regdate date default sysdate,
                        bnum number(20) constraint cnum_bnum_forign_key 
                        references board(num)
                    );                    
                    
desc board;

create table member (
                        userid varchar2(20) constraint member_userid_key primary key,
                        username varchar2(200),
                        tel varchar2(30)
                    );

-- 시퀀스 board_seq / comment_seq    

create sequence board_seq
increment by 1
    start with 1
    minvalue 1
    maxvalue 99999
    nocycle
    nocache;            
    
    
create sequence comment_seq
increment by 1
    start with 1
    minvalue 1
    maxvalue 99999
    nocycle
    nocache;   
    
alter table board 
    add constraint board_userid_fky foreign key(userid)
    references member(userid); 
    
    alter table comments 
    add constraint comments_userid_fky foreign key(userid)
    references member(userid); 
    
    select * from member;
    
    
    
    drop table board;
    drop table comments;
    drop table member;
    
    create table member (
                        userid varchar2(20) constraint member_userid_key primary key,
                        username varchar2(200),
                        tel varchar2(30)
                    );
    
    create table board (
                        num number(20) constraint board_num_key primary key,
                        title varchar2(20),
                        userid varchar2(20) constraint fk_board1
                        references member(userid)
                        on delete cascade,
                        content varchar2(200),
                        regdate date default sysdate
                    );
                    
create sequence board_seq
increment by 1
    start with 1
    minvalue 1
    maxvalue 99999
    nocycle
    nocache;            
    
    
create sequence comment_seq
increment by 1
    start with 1
    minvalue 1
    maxvalue 99999
    nocycle
    nocache; 
    
create table comments (
                        cnum number(20) constraint pk_num_key primary key,
                        userid varchar2(20) constraint fk_comments
                        references member(userid),
                        msg varchar2(20),
                        regdate date default sysdate,
                        bnum number(20) references board(num)
                    );       
                    
                    
    
