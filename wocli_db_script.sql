-- This script is to init the wocli DB
create database wocli ;

drop table Authors;
drop table Addon;
drop table AddonAuthors;

create table Authors (
	id int not null,
	url varchar(250) not null,
	name varchar(250) not null,
	primary key(id)
);

create table Addon (
	id int not null,
	
	primary key (id)
);

create table AddonAuthors (
	addon_id int not null,
	author_id int not null,
	primary key (addon_id,author_id),
	foreign key ( addon_id ) references id ( Addon ) on delete cascade,
	foreign key ( author_id ) references id ( Authors ) on delete cascade
);

create table Category (
	id int not null,
	name varchar(250) not null,
	url varchar(250),
	primary key(id)
);

create table AddonCategories (
	addon_id int not null,
	category_id int not null,
	primary key (addon_id,author_id),
	foreign key ( addon_id ) references id ( Addon ) on delete cascade,
	foreign key ( category_id ) references id ( Category ) on delete cascade
);