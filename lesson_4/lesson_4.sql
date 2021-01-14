create schema lesson_4

create table lang (
	lang_id serial primary key,
	lang_name varchar(50) not null
)

insert into lang (lang_name)
values ('английский'), ('французский'), ('немецкий'), ('русский'), ('китайский')


create table country (
	country_id serial primary key,
	country_name varchar(50) not null
)

insert into country (country_name)
values ('Великобритания'), ('Германия'), ('Россия'), ('Китай'), ('Франция'), ('Канада'),
	('Швейцария'), ('Ирландия'), ('Белорусия')
	
alter table country add column Kingdom boolean

update country
set kingdom = true
where country_id = 1

create table nationality (
	nationality_id serial primary key,
	nationality_name varchar(50) not null
)

insert into nationality (nationality_name)
values ('славяне'), ('немцы'), ('англосаксы'), ('китайцы'), ('французы')
	
create table country_and_nationality (
	country_id int not null,
	nationality_id int not null,
	foreign key (country_id) references country(country_id),
	foreign key (nationality_id) references nationality(nationality_id)
)

insert into country_and_nationality (country_id, nationality_id)
select unnest (array [3, 9, 2, 7, 1, 2, 8, 4]),
	unnest (array [1, 1, 2, 2, 3, 3, 3, 4])

create table language_and_nationality (
	language_id int not null,
	nationality_id int not null,
	foreign key (language_id) references lang(lang_id),
	foreign key (nationality_id) references nationality(nationality_id)
)

insert into language_and_nationality (language_id, nationality_id)
select unnest (array [1, 2, 3, 3, 4, 5]),
	unnest (array [3, 5, 2, 3, 1, 4])


	
	
	
	