#Equality conditions

select pt.name product_type, p.name product
from product p inner join product_type pt
	on p.product_type_cd = pt.product_type_cd
where pt.name = 'Customer Accounts';

#Inequality conditions
select pt.name product_type, p.name product
from product p inner join product_type pt
	on p.product_type_cd = pt.product_type_cd
where pt.name != 'Customer Accounts';

#Deleting data using equality condiction
delete from account
where status = 'CLOSED' and year(close_date) = 2002;

/*
#Intervale condition
*/

select emp_id, fname, lname, start_date
from employee
where start_date < '2003-01-01';

select emp_id, fname, lname, start_date
from employee
where start_date < '2003-01-01'
	and start_date >= '2001-01-01';
    
/*
*	Another way to apply a filter using two limits is using the BETWEEN operator.
*	The operator BETWEEN is inclusive, that is, a closed range.
* 	Another attention point when using BETWEEN it is necessary to define the under limit first.
*/
select emp_id, fname, lname, start_date
from employee
where start_date between '2001-01-01' and '2003-01-01';

select account_id, product_cd, cust_id, avail_balance
from account
where avail_balance between 3000 and 5000;

#BETWEEN using strings
select cust_id, fed_id
from customer
where cust_type_cd = 'I'
	and fed_id between '500-00-0000' and '999-99-9999';
    
#Filtering usign finite expressions
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd = 'CHK' OR product_cd = 'SAV'
	OR product_cd = 'CD' OR product_cd = 'MM';

#Changing the query above using IN operator    
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd IN ('CHK', 'SAV', 'CD' ,'MM');

#Using a subquery to do the same thing
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd in (select product_cd  from product
					where  product_type_cd = 'ACCOUNT');

#Using NOT IN
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd not in ('CHK','SAV','CD','MM');

#Filtering using parcial correspondence 
select emp_id, fname, lname
from employee
where left(lname, 1) = 'T';

#Using wildcards SQL
select lname
from employee
where lname like '_a%e%';

select cust_id, fed_id
from customer
where fed_id like '___-__-____';

#Using multiples expressions
select emp_id, fname, lname
from employee
where lname like 'F%' or lname like 'G%';


#Using Regular Expressions
select emp_id, fname, lname
from employee
where lname regexp '^[FG]';

#NULL Expression
#An expression could be null, bot not equals to null.

select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id is null;

select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id = null;


select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id is not null;

select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id != 6;

select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id != 6 or superior_emp_id is null;


/*
*	Exercises
*/

#Exercise 4.1 (Modified)
select *
from transaction
where txn_date < '2001-02-26' and (txn_type_cd = 'DBT' or amount >= 100);

#Exercise 4.2 
select txn_id
from transaction
where account_id in (4,11) and not (txn_type_cd = 'DBT' or amount > 100);

#Exercise 4.3
select account_id, open_date
from account
where year(open_date) = 2002;

#Exercise 4.4
select cust_id, lname, fname
from individual
where lname like '_a%e%';