--CTAS ���
--dept2 ���̺���  dcode�� 1000,1001,1002�� �����ͷ� ������
--dept6 ���̺� ����(dcode, dname ����)
---1. dept2 -> dept6(dcode, dname, area)
select * from dept2;

create table dept6
as select dcode, dname, area
from dept2
where dcode in (1000,1001,1002);

select * from dept6;

--2. location(ũ�� 200)  �÷� �߰�
alter table dept6
add(location varchar2(200));
-- 3. dcode 1000 �� location �� �λ� ����
update dept6
set location = '�λ�'
where dcode =1000;
commit;
--4. 2000, TEAM , BUSAN,  �λ� -->�߰�
insert into dept6(dcode, dname, area, location)
values(2000, 'TEAM' , 'BUSAN',  '�λ�');
commit;

insert into dept6
values(2000, 'TEAM' , 'BUSAN',  '�λ�');
commit;
select * from dept6;
--5. decode�� 2000 �� ����
delete from dept6
where dcode = 2000;
commit;
--6. location �÷� ũ�⸦ 70 ���� ����
alter table dept6
MODIFY(location varchar2(70));
desc dept6;
--7.  location �÷� ����
alter table dept6
drop column location;
--8. dept6 ���̺� ����
drop table dept6;
--------
--1.professor  ���̺� ������ �����ؼ� professor6 ����
create table professor6
as select *
from professor
where 1=2;
select * from professor6;
--2. professor6 ����
drop table professor6;




