/*
*	Creating table person
*/

create table PERSON
	(person_id smallint unsigned,
    fname varchar(20),
    lname varchar(20),
    gender ENUM('M','F'),
    birth_date date,
    street varchar(30),
    city varchar(20),
    state varchar(20),
    country varchar(20),
    postal_code varchar(20),
    constraint pk_person primary key (person_id)
	);
    
/*
*	Creating table favorite_food
*/

create table favorite_food
(person_id smallint unsigned,
	food varchar(20),
	constraint pk_favorite_food primary key (person_id, food),
	constraint fk_fav_food_person_id foreign key (person_id)
	references person (person_id)
);


/*
* Updating the auto_increment to person_id.
*/
SET FOREIGN_KEY_CHECKS = 0;
alter table person modify person_id smallint unsigned auto_increment;
SET FOREIGN_KEY_CHECKS = 0;

/* 
*	Inset statements
*/
insert into person
	(person_id, fname, lname, gender, birth_date)
    values (null, 'William', 'Turner', 'M', '1972-05-27');
    
insert into favorite_food(person_id, food)
values (1, 'pizza');

insert into favorite_food (person_id, food)
values (1, 'cookies');

insert into favorite_food (person_id, food)
values (1, 'nachos');

insert into person
(person_id, fname, lname, gender, birth_date, street, city, state, country, postal_code)
values (null, 'Susan', 'Smith', 'F', '1975-11-02', '23 Maple St.', 'Arlington', 'VA', 'USA', '20220');

/*
*	Update statements
*/
update person
set street = '1225 Tremont St.',
	city = 'Boston',
    state = 'MA',
    country = 'USA',
    postal_code = '02138'
WHERE person_id = 1;

/*
*	Delete statements
*/

delete from person
where person_id = 2;

/*
*	Updating statement using string conversion
*/

update person
set birth_date = str_to_date('DEC-21-1980','%b-%d-%Y')
where person_id = 1;

/*
*	Dropind tables
*/
DROP TABLE favorite_food;
DROP TABLE person;
