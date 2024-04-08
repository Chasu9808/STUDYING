-- CTAS ���
-- dept2 ���̺��� dcode�� 1000,1001,1002�� �����ͷ� ������
-- dept6 ���̺� ����(dcode,dname ����)
--1. dept2 -> dept6(dcode,dname,area)
create table dept6 as
select dcode,dname,area from dept2
where dcode in(1000,1001,1002);

-- 2. location(ũ�� 200) �÷� �߰�
alter table dept6 add location varchar2(200);

-- 3. dcode 1000�� location�� �λ����� ����
update dept6 set location = '�λ�'
where dcode = 1000;

-- 4. 2000,TEAM,BUSAN, �λ� -->�߰�
insert into dept6 
values(2000,'TEAM','BUSAN','�λ�');
select * from dept6;

-- 5. decode�� 2000���� �ָ� ����
delete from dept6
where dcode=2000;

-- 6. location Į�� ũ�⸦ 70���� ����
alter table dept6
modify (location varchar2(70));

desc dept6;
-- 7. location �÷� ����
alter table dept6
drop column location;
-- 8. dept6 ���̺� ����
drop table dept6;

select * from professor;

create table professor6 as
select * from professor
where 1<>1;

select * from professor6;
-- 9. professor6 ����

drop table professor6;

