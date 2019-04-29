/*
*	Select statements examples
*/
select fname, lname
from employee;

select *
from department;

select dept_id, name
from department;

select name
from department;

/*
*	Native fuctions
*/

select emp_id,
'ACTIVE',
emp_id * 3.14159,
UPPER(lname)
from employee;

select version(),
	user(),
    database();
    
/*
*	Columns aliases
*/

select emp_id,
	'ACTIVE' as status,
    emp_id * 3.14159 as empid_x_pi,
    upper(lname) as last_name_upper
from employee;


/*
*	Removing duplicate rows
*/

select cust_id
from account;

select distinct cust_id
from account;

/*
*	WHERE CLAUSE
*/

/*
*	Subquery
*/
select e.emp_id, e.fname, e.lname
from (select emp_id, fname, lname, start_date, title
	from employee) e;
    
/*
*	Views
*/ 
create view employee_vw as
select emp_id, fname, lname,
	year(start_date) start_year
from employee;

select emp_id, start_year
from employee_vw;

/*
*	Tables links
*/
select employee.emp_id, employee.fname,
	employee.lname, department.name dept_name
from employee inner join department
	on employee.dept_id = department.dept_id;
    
/*
*	Table aliases
*/
select  e.emp_id, e.fname, e.lname, 
	d.name dept_name
from employee e inner join department d
	on e.dept_id = d.dept_id;
    
/*
*	Where clause
*/    
select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller';

select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller' 
	and start_date > '2002-01-01';
    
select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller' 
	or start_date > '2002-01-01';
    
select emp_id, fname, lname, start_date, title
from employee
where (title = 'Head Teller' and start_date > '2002-01-01')
	or (title = 'Teller' and start_date > '2003-01-01');
    
    
/*
*	Clauses group by and having
*/

select d.name, count(e.emp_id) num_employees
from department d inner join employee e
	on d.dept_id = e.dept_id
group by d.name
having count(e.emp_id) > 2;

/*
*	Clauses ORDER BY
*/

select open_emp_id, product_cd
from account;


select open_emp_id, product_cd
from account
order by open_emp_id;

select open_emp_id, product_cd
from account
order by open_emp_id, product_cd;

/*
*	DESC
*/

select account_id, product_cd, open_date, avail_balance
from account
order by avail_balance DESC;

/*
*	Order using expressions
*/

select cust_id, cust_type_cd, city, state, fed_id
from customer
order by right(fed_id,3);

/*
*	Ordering using numeric reference (columns)
*/

select emp_id, title, start_date, fname, lname
from employee
order by 2, 5;


/**********************\
|***	Exercises	***|
\**********************/

#Exercise 3.1
select emp_id, fname, lname
from employee
order by lname, fname;

#Exercise 3.2
select account_id, cust_id,  avail_balance
from account
where status = 'ACTIVE' 
	and avail_balance > 2500;
    
#Exercise 3.3
select distinct open_emp_id
from account;

#Exercise 3.4
select p.product_cd, a.cust_id, a.avail_balance
from product p inner join account a 
	on p.product_cd = a.product_cd
where p.product_type_cd = 'ACCOUNT'
order by p.product_cd, a.cust_id;