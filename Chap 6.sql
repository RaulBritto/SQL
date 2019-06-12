#Union example
select 1 num, 'abc' str
union
select 9 num, 'xyz' str;

#Union operator
#UNION ALL

select 'ind' type_cd, cust_id, lname name 
from individual
union all
select 'bus' type_cd, cust_id, name
from business;

#UNION	(Duplicate lines)
select 'ind' type_cd, cust_id, lname name
from individual
union all
select 'bus' type_cd, cust_id, name
from business
union all 
select 'bus' type_cd, cust_id, name 
from business;

#Duplicate lines
select emp_id
from employee
where assigned_branch_id = 2
	and (title = 'Teller' or title = 'Head Teller')
UNION ALL 
select distinct open_emp_id
from account 
where open_branch_id = 2;

#Removing duplicates
select emp_id
from employee
where assigned_branch_id = 2
	and (title = 'Teller' or title = 'Head Teller')
UNION
select distinct open_emp_id
from account
where open_branch_id = 2;


#Intersection operator
select emp_id, fname, lname
from employee;

select cust_id, fname, lname
from individual;

select emp_id
from employee
where assigned_branch_id = 2
	and (title = 'Teller' or title = 'Head Teller');

select distinct open_emp_id 
from account
where open_branch_id = 2;

#Except operator
select emp_id
from employee
where assigned_branch_id =2
	and (title = 'Teller' or title = 'Head Teller');

select distinct open_emp_id
from account
where open_branch_id = 2;


/*
*	Operations rule applied in a set
*
*	Ordering
*
*	To order composed queries, it's necessary add a clause ORDER BY after the last query and you need to choose a column from the query 
*	of the composed query.
*/
select emp_id, assigned_branch_id
from employee
where title = 'Teller'
UNION
select open_emp_id, open_branch_id
from account
where product_cd = 'SAV'
order by emp_id;

/*
*	If you are doing a composite query it's fundamental to think about the order in the queries will be written to get the results wanted.
*/

select cust_id
from account
where product_cd in ('SAV', 'MM')
UNION ALL
select a.cust_id
from account a inner join branch b
	on a.open_branch_id = b.branch_id
where b.name = 'Woburn Branch'
UNION
select cust_id
from account
where avail_balance between 500 and 2500;



select cust_id
from account
where product_cd in ('SAV', 'MM')
UNION
select a.cust_id
from account a inner join branch b
	on a.open_branch_id = b.branch_id
where b.name = 'Woburn Branch'
UNION ALL
select cust_id
from account
where avail_balance between 500 and 2500;

#Exercises
#6.1

#A union B = 		{L M N O P Q R S T}
#A union all B = 	{L M N O P P Q R S T}
#A intersect  B = 	{P}
#A except B = 		{L M N O}

#6.2
select i.fname, i.lname
from individual i
union
select fname, lname
from employee;

#6.3
select fname, lname
from individual 
union
select fname, lname
from employee
order by lname;
