#Cartesian product

select e.fname, e.lname, d.name
from employee e join department d;

#Inner join example
select e.fname, e.lname, d.name
from employee e join department d
on e.dept_id = d.dept_id;

select e.fname, e.lname, d.name
from employee e inner join department d
on e.dept_id = d.dept_id;

select e.fname, e.lname, d.name
from employee e inner join department d
using(dept_id);

#Using ANSI in a join
select e.fname, e.lname, d.name
from employee e, department d
where e.dept_id = d.dept_id;

select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a, branch b, employee e
where a.open_emp_id  = e.emp_id
	and e.start_date < '2007-01-01'
    and e.assigned_branch_id = b.branch_id
	and (e.title = 'Teller' or e.title = 'Head Teller')
    and b.name = 'Woburn Branch';
    
select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a inner join employee e
	on a.open_emp_id = e.emp_id
    inner join branch b
    on e.assigned_branch_id = b.branch_id
where e.start_date < '2007-01-01'
	and (e.title = 'Teller' or e.title = 'Head Teller')
    and b.name = 'Woburn Branch';
    
#Join using three tables
#first using two tables

select a.account_id, c.fed_id
from account a inner join customer c
	on a.cust_id = c.cust_id
where c.cust_type_cd = 'B';

select a.account_id, c.fed_id , e.fname, e.lname
from account a inner join customer c
	on a.cust_id = c.cust_id
	inner join employee e
    on a.open_emp_id = e.emp_id
where c.cust_type_cd = 'B';

select a.account_id, c.fed_id, e.fname, e.lname
from customer c inner join account a
	on a.cust_id = c.cust_id
    inner join  employee e
    on a.open_emp_id = e.emp_id
where c.cust_type_cd = 'B';

select a.account_id, c.fed_id, e.fname, e.lname
from employee e  inner join account a
	on e.emp_id = a.open_emp_id
    inner join customer c
    on a.cust_id = c.cust_id
where c.cust_type_cd = 'B';

#Using a specific order of table joins
select straight_join a.account_id, c.fed_id, e.fname, e.lname
from customer c inner join account a
	on a.cust_id = c.cust_id
	inner join employee e
	on a.open_emp_id = e.emp_id
where c.cust_type_cd = 'B';


#Using subqueries as tables
select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a inner join
	(select emp_id, assigned_branch_id
    from employee
    where start_date < '2007-01-01'
		and (title = 'Teller' or title = 'Head Teller')) e
	on a.open_emp_id = e.emp_id
    inner join
		(select branch_id
			from branch
			where name = 'Woburn Branch') b
		where e.assigned_branch_id = b.branch_id;
        
#Subquery number 1
select emp_id, assigned_branch_id
from employee
where start_date < '2007-01-01'
and (title = 'Teller' or title = 'Head Teller');

#Subquery number 2
select branch_id
from branch
where name = 'Woburn Branch';

#Using the same table twice in a query
select a.account_id, e.emp_id, 
	b_a.name open_branch, b_e.name emp_branch
from account a inner join branch b_a
	on a.open_branch_id = b_a.branch_id
    inner join  employee e
    on a.open_emp_id = e.emp_id
    inner join branch b_e
    on e.assigned_branch_id = b_e.branch_id
where a.product_cd = 'CHK';

#Self join sql
select e.fname, e.lname,
	e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e inner join  employee e_mgr
	on e.superior_emp_id = e_mgr.emp_id;
    
#Not equivalent joins
select e.emp_id, e.fname, e.lname, e.start_date
from employee e inner join product p
	on e.start_date >= p.date_offered
    and e.start_date <= p.date_retired 
where p.name = 'no-fee checking';

select e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
from employee e1 inner join employee e2
	on e1.emp_id != e2.emp_id
where e1.title = 'Teller' and e2.title = 'Teller';

select e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
from employee e1 inner join employee e2
	on e1.emp_id < e2.emp_id
where e1.title = 'Teller' and e2.title = 'Teller';

#Join conditions versus filter conditions
select a.account_id, a.product_cd, c.fed_id
from account a inner join customer c
	on a.cust_id = c.cust_id
where c.cust_type_cd = 'B';

select a.account_id, a.product_cd, c.fed_id
from account a inner join customer c
	on a.cust_id = c.cust_id
		and c.cust_type_cd = 'B';
        
select a.account_id, a.product_cd, c.fed_id
from account a inner join customer c
where a.cust_id = c.cust_id
	and c.cust_type_cd = 'B';
    
#Exercises
#5.1
select e.emp_id, e.fname, e.lname, b.name
from employee e inner join branch b
on e.assigned_branch_id = b.branch_id;

#5.2
select a.account_id, c.fed_id, p.name
from account a inner join customer c
	on a.cust_id = c.cust_id
    inner join product p
    on p.product_cd = a.product_cd
where c.cust_type_cd = 'I';

#5.3
select e.emp_id, e.fname, e.lname
from employee e inner join employee e_b
on e.superior_emp_id = e_b.emp_id 
	and e.dept_id != e_b.dept_id;


