-- ������� ���� ���������� �����������
select customer_id, first_name, last_name
from customer
where active = 0;

-- ������� ��� ������, ���������� � 2006 ����
select film_id, title
from film
where release_year = 2006;

-- ������� 10 ��������� �������� �� ������ �������
select * from payment
order by payment_date desc
limit 10;

-- �������������� �����

-- 1 �������. ���������� ����� 3 ������� � ������� column_name. � ���� �������� ���������� ����� ������ � ������ film_actor � film_category, �� � ��� ��� ���� ����� �����������.

select cc.column_name, aa.constraint_name, cc.data_type, cc.table_name 
from information_schema.table_constraints as aa
left join information_schema.key_column_usage as bb
	on aa.constraint_name = bb.constraint_name
left join information_schema.columns as cc
	on bb.column_name = cc.column_name and bb.table_name = cc.table_name
where aa.constraint_type = 'PRIMARY KEY';

-- 2 ������. ���������� ����� ordinal_position. 

select aaa.table_name, ccc.column_name, aaa.constraint_name, ccc.data_type 
from information_schema.table_constraints as aaa
left join information_schema.columns as ccc
	on aaa.table_name = ccc.table_name
where aaa.constraint_type = 'PRIMARY KEY' and ccc.table_schema = 'public' and ccc.ordinal_position = 1
