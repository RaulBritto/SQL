/*
*    SUBQUERY
*/

select account_id, product_cd, cust_id, avail_balance
from account
where account_id = (select max(account_id) from account);


select account_id, product_cd, cust_id, avail_balance
from account
where account_id = 29;

/*
*   SUBQUERY NON-CORRELATED
*/

/*subquery returning an unique value and column**/
select account_id, product_cd, cust_id, avail_balance
from account
where open_emp_id <> (select e.emp_id
    from employee e inner join branch b
        on e.assigned_branch_id = b.branch_id
    where e.title = 'Head Teller' and b.city = 'Woburn');

/*ERROR*/
select account_id, product_cd, cust_id, avail_balance
from account
where open_emp_id <> (select e.emp_id
    from employee e inner join branch b
        on e.assigned_branch_id = b.branch_id
    where e.title = 'Teller' and b.city = 'Woburn');    

/*subquery returning multiples lines and an unique column**/

/**IN operator*/
select branch_id, name, city
from branch
where name in ('Headquarters', 'Quincy Branch');

/*It is possible obtain the same result using this query*/
select branch_id, name, city
from branch
where name = 'Headquarters' or name = 'Quincy Branch';

select emp_id, fname, lname, title
from employee
where emp_id in (select superior_emp_id
    from employee);

/*Not in example*/
select emp_id, fname, lname, title
from employee
where emp_id not in (select superior_emp_id
    from employee
    where superior_emp_id is not null);

/*All operator**/
select emp_id, fname, lname, title
from employee
where emp_id <> all (select superior_emp_id
    from employee
    where superior_emp_id is not null);

/*ERROR**/
select emp_id, fname, lname, title
	from emp_id not in (1,2,Null);

select account_id, cust_id, product_cd, avail_balance
from account
where avail_balance < all (select a.avail_balance
    from account a inner join individual i
        on a.cust_id = i.cust_id
	where i.fname = 'Frank' and i.lname = 'Tucker');

/*Any operator*/
select account_id, cust_id, product_cd, avail_balance
from account
where avail_balance > any (select a.avail_balance
    from account a inner join individual i
        on a.cust_id = i.cust_id
	where i.fname = 'Frank' and i.lname = 'Tucker');


/*subquery returning multiples lines and columns*/
select account_id, product_cd, cust_id
from account
where open_branch_id = (select branch_id
    from branch
    where name = 'Woburn Branch')
    and open_emp_id in (select emp_id
    from employee
    where title = 'Teller' or title='Head Teller');

select account_id, product_cd, cust_id
from account
where (open_branch_id, open_emp_id) in
    (select b.branch_id, e.emp_id
    from branch b inner join employee e
        on b.branch_id = e.assigned_branch_id
    where b.name = 'Woburn Branch'
        and (e.title = 'Teller' or e.title = 'Head Teller'));

/*
*   CORRELATED SUBQUERIES
*/

/*Equality condition*/
select c.cust_id, c.cust_type_cd, c.city
from customer c
where 2 = (select count(*)
    from account a
    where a.cust_id = c.cust_id);

/*Interval conditions*/
select c.cust_id, c.cust_type_cd, c.city
from customer c
where (select sum(a.avail_balance)
    from account a
    where a.cust_id = c.cust_id)
between 5000 and 10000;

/**Operator exists*/
select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where exists (select 1
    from transaction t
    where  t.account_id = a.account_id
        and t.txn_date = '2004-09-30');

select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where exists (select t.txn_id, 'hello', 3.1415927
    from transaction t
    where  t.account_id = a.account_id
        and t.txn_date = '2004-09-30');


select a.account_id, a.product_cd, a.cust_id
from account a
where not exists (select 1
    from business b
    where b.cust_id = a.cust_id);
    
/*
*	Manipulating data using correlated subqueries (UPDATING TABLE)
*/
update account a 
set a.last_activity_date =
	(select max(t.txn_date)
    from transaction t
    where t.account_id = a.account_id);
    
/*More robust query*/
update account a
set a.last_activity_date =
	(select max(t.txn_date)
    from transaction t
    where  t.account_id = a.account_id)
where exists (select 1
	from transaction t
    where t.account_id = a.account_id);
    
/*Delete statement*/
delete from department
where not exists (select 1
	from employee
    where employee.dept_id = department.dept_id);
    
    
/*
*	WHEN TO USE SUBQUERIES
*/

/*Subqueries as database*/
select d.dept_id, d.name, e_cnt.how_many num_employees
from department d inner join
	(select dept_id, count(*) how_many
    from employee
    group by dept_id) e_cnt
	on d.dept_id = e_cnt.dept_id;
    
/*Manufacturing data*/   
/*Creating a classification table*/
select 'Small Fry' name, 0 low_limit, 4999.99 high_limit
union all
select 'Average Joes' name, 5000 low_limit, 9999.99 high_limit
union all
select 'Heavy Hitters' name, 10000 low_limit, 999999999.99 high_limit;


select groups_.name, count(*) num_customers
from (
	select sum(a.avail_balance) cust_balance
    from account a inner join product p
		on a.product_cd = p.product_cd
	where p.product_type_cd = 'ACCOUNT'
    group by a.cust_id) cust_rollup
    inner join 
    (select 'Small Fry' name, 0 low_limit, 4999.99 high_limit
	union all
	select 'Average Joes' name, 5000 low_limit, 9999.99 high_limit
	union all
	select 'Heavy Hitters' name, 10000 low_limit, 999999999.99 high_limit) groups_
on cust_rollup.cust_balance
	between groups_.low_limit and groups_.high_limit
group by groups_.name;


/*Task oriented queries*/
select p.name product, b.name branch,
	concat(e.fname, ' ', e.lname) name,
    sum(a.avail_balance) tot_deposits
from account a inner join employee e
	on a.open_emp_id = e.emp_id
	inner join branch b
    on a.open_branch_id = b.branch_id
    inner join product p
    on a.product_cd = p.product_cd
where p.product_type_cd = 'ACCOUNT'
group by p.name, b.name, e.fname, e.lname
order by 1,2;

/*Separe every task in a subquery*/

select product_cd, open_branch_id branch_id, open_emp_id emp_id,
	sum(avail_balance) tot_deposits
from account
group by product_cd, open_branch_id, open_emp_id;

/*Using a subquery in a from clause as main query*/
select p.name product, b.name branch,
	concat(e.fname, ' ', e.lname) name,
    account_groups.tot_deposits
from (select product_cd, open_branch_id branch_id, open_emp_id emp_id,
		sum(avail_balance) tot_deposits
	 from account
	 group by product_cd, open_branch_id, open_emp_id) account_groups
     inner join employee e on e.emp_id = account_groups.emp_id
     inner join branch b on b.branch_id = account_groups.branch_id
     inner join product p on p.product_cd = account_groups.product_cd
where p.product_type_cd = 'ACCOUNT'
order by 1,2;
	
/*Subquery in filter condition*/

select open_emp_id, count(*) how_many
from account
group by open_emp_id
having count(*) = (select max(emp_cnt.how_many)
					from (select count(*) how_many
							from account
							group by open_emp_id) emp_cnt);

/*Subquery as expression generator*/

select
(select p.name from product p
 where p.product_cd = a.product_cd
	and p.product_type_cd = 'ACCOUNT') product,
(select b.name from branch b
 where b.branch_id = a.open_branch_id) branch,
(select  concat(e.fname, ' ', e.lname) from employee e
 where e.emp_id = a.open_emp_id) name,
 sum(a.avail_balance) tot_deposits
from account a
group by a.product_cd, a.open_branch_id, a.open_emp_id
order by 1,2;


/*Removing null rows*/
select all_prods.product, all_prods.branch,
	all_prods.name, all_prods.tot_deposits
from (
	select
		(select p.name from product p
		 where p.product_cd = a.product_cd
			and p.product_type_cd = 'ACCOUNT') product,
		(select b.name from branch b
		 where b.branch_id = a.open_branch_id) branch,
		(select  concat(e.fname, ' ', e.lname) from employee e
		 where e.emp_id = a.open_emp_id) name,
		 sum(a.avail_balance) tot_deposits
	from account a
	group by a.product_cd, a.open_branch_id, a.open_emp_id) all_prods
where all_prods.product is not null
order by 1,2;

/*Subquery in order by clause*/
select emp.emp_id, concat(emp.fname, ' ', emp.lname) emp_name,
	(select concat(boss.fname, ' ', boss.lname)
     from employee boss
     where boss.emp_id = emp.superior_emp_id) boss_name
from employee emp
where emp.superior_emp_id is not null
order by (select boss.lname from employee boss
	where boss.emp_id = emp.superior_emp_id), emp.lname;

/*Insert values using subqueries*/
insert into account
	(account_id, product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
values (null, 
		(select product_cd from product where name = 'savings account'),
        (select cust_id from customer where fed_id = '555-55-5555'),
        '2008-09-25', '2008-09-25', 'ACTIVE',
        (select branch_id from branch where name = 'Quincy Branch'),
        (select emp_id from employee where lname = 'Portman' and fname = 'Frank'),
        0, 0);
        
/*
*	Exercises
*/

/*9.1*/
select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where a.product_cd in ( select product.product_cd
					from product
                    where product.product_type_cd = 'LOAN');
                    
/*9.2*/
select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where a.product_cd in ( select p.product_cd
						from product p
						where p.product_type_cd = 'LOAN'
							and p.product_cd = a.product_cd);
                            
select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where exists (	select 1
				from product p
				where p.product_type_cd = 'LOAN'
					and p.product_cd = a.product_cd);

/*9.3*/
select  e.emp_id, e.fname, e.lname, levels.name
from employee e
inner join
(
	select 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
	union all
	select 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
	union all
	select 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt
) levels
	on e.start_date between levels.start_dt and levels.end_dt
order by e.start_date desc;

/*9.4*/
select e.emp_id, e.fname, e.lname, 
		(select d.name 
		 from department d
         where d.dept_id = e.dept_id) dept_name,
        (select b.name
		 from branch b
         where b.branch_id = e.assigned_branch_id) branch
from employee e;