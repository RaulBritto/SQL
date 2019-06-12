#Create a table of strings
create table string_tbl
(char_fld char(30),
vchar_fld varchar(30),
text_fld TEXT);

#Inserting valoues on database
insert into string_tbl (char_fld, vchar_fld, text_fld)
values ('This is char data',
	'This is varchar data',
    'This is text data');

#MYSQL will launch an error mensage    
update string_tbl
set vchar_fld = 'This is a piece of extremely long varchar data';

update string_tbl
set text_fld = 'This string doesn''t work, bu it does now';

select text_fld
from string_tbl;

select quote(text_fld)
from string_tbl;

#Inclduing special characters
select 'abcdef', CHAR(97,98,99,100,101,102,103);

select char (128,129,130,131,132,133,134,135,136,137);

select concat('danke sch', char(148), 'n');

select ascii('ö')

#Manipulation Strings

delete from string_tbl;

insert into string_tbl (char_fld, vchar_fld, text_fld)
values ('This string is 28 characters',
	'This string is 28 characters',
    'This string is 28 characters');
    
select length(char_fld) char_length,
	length(vchar_fld) varchar_length,
    length(text_fld) text_length
from string_tbl;

select position('characters' in vchar_fld)
from string_tbl;

select locate('is', vchar_fld, 5)
from string_tbl;

delete from string_tbl;

insert into string_tbl(vchar_fld) values ('abcd');
insert into string_tbl(vchar_fld) values ('xyz');
insert into string_tbl(vchar_fld) values ('QRSTUV');
insert into string_tbl(vchar_fld) values ('qrstuv');
insert into string_tbl(vchar_fld) values ('12345');

select vchar_fld
from string_tbl
order by vchar_fld;

select strcmp('12345','12345') 12345_12345,
	strcmp ('abcd', 'xyz') abcd_xyz,
    strcmp ('abcd', 'QRSTUV') abcd_QRSTUV,
    strcmp ('qrstuv', 'QRSTUV') qrstuv_QRSTUV,
    strcmp('12345','xyz') 12345_xyz,
    strcmp('xyz','qrstuv') xyz_qrstuv;
    
select name, name like '%ns' ends_in_ns
from department;    

select cust_id, cust_type_cd, fed_id,
	fed_id REGEXP '.{3}-.{2}-.{4}' is_ss_no_format
from customer;

#String functions that returning strings

delete from string_tbl;

insert into string_tbl (text_fld)
values ('This string was 29 characters');

#Attaching characteres to the original string
#CONCAT FUNCTION

update string_tbl
set text_fld = concat(text_fld, ', but now it is longer');

select text_fld
from string_tbl;

select concat(fname, ' ', lname, ' has been a ', title, ' since ', start_date) emp_narrative
from employee
where title = 'Teller' or title = 'Head Teller';

#INSERT FUCTION
select insert ('goodbye world', 9, 0, 'cruel ') string;
select insert ('goodbye world', 1, 7, 'hello') string;

#Substring to extract a substring
select substring('goodbye cruel world', 9, 5);

/*
*	Working with numeric data
*/

select (37*59)/ (78 - (8*6));

#MOD FUNCTION

#Interger numbers
select mod(10,4);

#Float numbers
select mod(22.75, 5);

#POWER FUNCTION
select pow(2,8);
select pow(2,10) kilobyte, pow(2,20) megabyte, pow(2,30) gigabyte, pow(2,40) terabyte;

#CONTROLING THE NUMBERIC PRECISION
select ceil(72.445), floor(72.445);
select ceil(72.00000000001), floor(72.999999999999);

#ROUND FUNCTION
select round(72.499999), round(72.5), round(72.50000001);
select round(72.0909, 1), round(72.0909, 2), round(72.0909,3);

#TRUNCATE FUNCTION
select truncate(27.0909, 1), truncate(72.0909,2), truncate(72.0909, 3);

select round(17, -1), truncate(17,-1);

#SIGN FUNCTION
select account_id, sign(avail_balance), abs(avail_balance)
from account;

/*
*	Working with temporal data
*/

select @@global.time_zone, @@session.time_zone;

update transaction
set txn_date = '2008-09-17 15:30:00'
where txn_id = 99999;

#Converting sting to date
select cast('2008-09-17 15:30:00' as datetime);
select cast('2008-09-17' as date) date_field,
	cast('108:17:57' as time) time_field; 

#Converting directly from a string    
update individual 
set birth_date = str_to_date('September 17, 2008', '%M %d, %Y')
where cust_id = 9999;

select current_date(), current_time(), current_timestamp();

#Handle temporal data

#DATE_ADD
select date_add(current_date(), interval 5 day);

update transaction
set txn_date = date_add(txn_date, interval '3:27:11' hour_second)
where txn_id = 9999;

update employee
set birth_date = date_add(birth_date, interval '9-11' year_month)
where emp_id;

select last_day('2008-09-17');

select current_timestamp() current_est,
	convert_tz(current_timestamp(), 'US/Eastern', 'UTC') current_utc;
    
/*
*	Temporal functions returning strings
*/

select dayname('2008-09-18');

select extract(year from '2008-09-18 22:19:05');

/*
*	Temporal functions return numbers
*/

select datediff('2009-09-03', '2009-06-24');

select datediff('2009-09-03 23:59:59', '2009-06-24 00:00:01');

select datediff('2009-06-24', '2009-09-03');

/*
*	Conversion functions
*/
select cast('1456328' as signed integer);

select cast('999ABC111' as unsigned integer);

show warnings;

/*
*	Exercises
*/

#7.1
select substring('Please find the substring in this string',17,9);

#7.2
select abs(-25.76823),sign(-25.76823),round(-25.76823,2);

#7.3
select month(current_date());
select extract(month from current_date);