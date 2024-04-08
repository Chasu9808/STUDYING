-- Ʈ�����(ACID)
-- A  ���ڼ� (ATOMICITY)
-- C  �ϰ��� (CONSISTENCY) : �ϰ������� DB�� ��������
-- I  �ݸ��� (ISOLATION) : Ʈ����� ���� �� �ٸ� Ʈ������� �۾��� ������� ���ϵ��� �����ϴ� ��
-- D  ���Ӽ� (DURABILITY): ���������� ����� Ʈ������� ������ �ݿ��� �Ǵ°�

-- 13�� 327P
-- ������ ����
-- USER__ / ALL__ /DBA__ = DB �����ü�� ��ü�������� ��Ÿ������
-- �ε���
-- VIEW(��)- ������ ���̺�(���Ǽ�, ���ȼ�)
select * from dictionary;
-- SCOTT ������ ������ �ִ� ��� ���̺�
select table_name from user_tables;
-- SCOTT ������ ������ �ִ� ��� ��ü ���� ��ȸ
select owner, table_name from all_tables;

-- 341P VIEW(��)- ������ ���̺�(���Ǽ�, ���ȼ�)
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

-- emp ���̺� ��ü ������ v_emp1 �� ����
create view v_emp1
as
select * from emp;
-- v_emp1 (3000, 'ȫ�浿', sysdate) �߰�
insert into v_emp1(empno,ename,hiredate)
values(3000, 'ȫ�浿', sysdate);

select * from v_emp1;

select * from emp;

create or replace view v_emp1
as
select empno ,ename , hiredate
from emp
with read only; -- �б⸸ ����

drop view v_emp1;

insert into v_emp1(empno, ename, hiredate)
values(3000,'ȫ�浿',sysdate);

-- �������� = �ζ��κ�

-- �μ��� �ִ�޿��� �޴� ����� �μ���ȣ,�μ���,�޿��� ���
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
-- ������ 3���� ���

select * from emp ;

select rownum rn, e.* 
from (
        select * from emp
        order by ename desc
) e
where rownum <=3;

--with ���
with e as (select * from emp order by ename desc)
select rownum, e.*
from e
where rownum < 3;

-- p340 ������
-- �ڵ����� �������� (rownum)

create table dept_sequence
as select 
* from dept
where 1=2;

select * from dept_sequence;

create sequence seq_dept_sequence
increment by 10 -- ���� ��ġ
start with  10 -- ���ۼ���
maxvalue 90 -- �ִ밪
minvalue 0 -- �ּҰ�
NOCYCLE -- ���� ���Ǹ����� ó������ ���ư� no ���̸� ���ư��� ����
nocache; -- ���������� �����Ͽ� ����̾���

select * from user_sequences;
select * from dept_sequence;

-- 'DATABASE' 'SEOUL' �� �߰�
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

select seq_dept_sequence.currval -- ���� ������ ��������
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

-- �������� p360
-- not null
-- unique
-- primary key(�⺻Ű) - not null / unique
-- foreign key (�ܷ�Ű)
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
    values ('1111','010-1111-2222'); --�����߻� not null
    
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
--������ null�� �ƴϸ� �Ǵ°ɷ� �Ǿ��ֱ� ������ �ߺ����� ���Ѿ���
-- ���� ���� ��ȸ    
select owner, constraint_name
from user_constraints;

alter table table_notnull2
modify (
            tel constraint tb1_nn2_tel not null
        );
        
 insert into table_notnull2 (login_id,login_pwd) values ('aaa','1111');
 -- not null ���� ������ �Ǿ� ������ ���� �ʴ°��� Ȯ�ε�
 
 --table_notnull2���� login_id�� uunique �������� ����
 
 alter table table_notnull2 modify(login_id constraint tb_nn2_unique_loginID unique);
 
 delete from table_notnull2;
 commit;
 
 --�������� ���� tb1_nn2_tel ����
 
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

-- �⺻Ű�� login_id�� ���� �߰����� �ʾұ� ������                        
insert into table_pk(login_pwd,tel) values ('1111','010');

create table table_pk2(
                        login_id varchar2(20) constraint table_pk2_id  primary key,
                        login_pwd varchar2(20) not null,
                        tel varchar2(20)
                        );
                        
-- �����߻� login_id �⺻Ű�̹Ƿ� �ݵ�� not null, unique �ؾ� ��
-- insert into table_pk2(login_pwd, tel) values ('1111','010');

--1) ������ �� ���̺� ����
-- board (num, title, writer, content, regdate)
-- number                               date(�⺻��: sysdate)
-- num: �⺻Ű
-- ������ ����: board_seq 1/1/1 no cycle no cache

--2) ������ �߰�
--(1, board1, ȫ�浿, 1���Խñ�, 24/04/08), (2,board2,������, 2�� �Խñ�, 24/04/08)

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
into board values (1,'board1','ȫ�浿','1���Խñ�','24/04/08')
into board values (2,'board2','������','2���Խñ�','24/04/08')
select * from dual;

insert into board(num, title, writer, content);
-- values(board_seq.nextval,'board1','ȫ�浿','1���Խñ�','24/04/08');

--writer �÷����� name���� ����
alter table board rename column writer to name;

insert into board
values(board_seq.nextval, 'board3', 'ȫ�浿3', '3���Խñ�',sysdate);

--board num ������������ �ؼ� ������ 3���� ���
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
    
--emp_fk (�����ȣ, �����, ��å, �μ���ȣ)

create table emp_fk(
    empno number(2) constraint empfk_empno_pk primary key,
    ename varchar2(20),
    job varchar2(20),
    deptno number(2)
    );
    
    insert into dept_fk values(10,'����','�λ�');
    insert into dept_fk values(20,'IT','����');
    insert into emp_fk values(1, 'ȫ�浿', '���', '30');
    commit;
    
    select * from emp_fk;
    drop table emp_fk;
    
    select * from dept_fk;
    
    create table emp_fk(
    empno number(2) constraint empfk_empno_pk primary key,
    ename varchar2(20),
    job varchar2(20),
    deptno number(2) constraint empfk_deptno_fk 
    references dept_fk(deptno)-- �ܷ�Ű ���� �ܺο� ���ο��� �����ϴ� ������ ����
    
    );
    
    select * from emp_fk;
    
    insert into emp_fk values(1, 'ȫ�浿', '���', 30);
    insert into emp_fk values(1, 'ȫ�浿', '���', 20);
    insert into emp_fk (empno,ename,job) values(2, '������', '����');
    -- �ܷ�Ű�� null ���� ���� �ٸ� ������ �ȵǴ� ���� Ȯ�� �Ұ���
    
    delete from emp_fk where empno =1;
    commit;
    
    select * from dept_fk;
    -- ���Ἲ �������ǿ� �ɸ�
    delete from dept_fk
    where deptno=20;
    
    update emp_fk set deptno = 30 where empno =1;
    
    alter table emp_fk 
    drop constraint empfk_deptno_fk;
    -- �ܷ�Ű ������ ���� insert ����
    insert into emp_fk values(3, '������', '����', 40);
    select * from emp_fk;
    
    delete from emp_fk
    where empno = 3;
    commit;
    -- ������ �ܷ�Ű �߰�
    alter table emp_fk 
    add constraint empfk_deptno_fk foreign key(deptno)
    references dept_fk(deptno)
    on delete cascade; -- ���ӵ� ����Ʈ���� �Բ� �����ȴ�.
    
    delete from dept_fk where deptno=20;
    rollback;
    
    select * from dept_fk;
    select * from emp_fk;
    
    --check ���� ��������
    
    create table table_check
    (
        login_id varchar2(20) constraint tb_check_id_pk primary key,
        login_pwd varchar2(20) 
        constraint tb_check_pwd_ch check(length(login_pwd)>3),
        tel varchar2(20)
    );
    
    insert into table_check values('aaa','123','010');
    -- üũ �������� ����
    insert into table_check values('aaa','12345','010');
    
    select * from table_check;
    
-- board(num, title, userid, content, regdate) : �⺻Ű (num)
-- comment(cnum,userid,msg,regdate,bnum) : �⺻Ű(cnum) �ܷ�Ű(bnum)
-- member(userid,username,tel) �⺻Ű (userid)

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

-- ������ board_seq / comment_seq    

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
                    
                    
    
