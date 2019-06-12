/*
* 	JOINS
*/

/*Account per customer*/
select account_id, cust_id
from account;

/*Customer_id list*/
select cust_id
from customer;

/*Join between account and customer. All accounts have at least one customer.*/
select a.account_id, c.cust_id
from account a inner join customer c
	on a.cust_id = c.cust_id;
    
/*Join between account and business.*/
select a.account_id, b.cust_id, b.name
from account a inner join business b
	on a.cust_id = b.cust_id;
    
select cust_id, name
from business;

/*OUTER JOIN*/
select a.account_id, a.cust_id, b.name
from account a left outer join business b
	on a.cust_id = b.cust_id;
    
select a.account_id, a.cust_id, i.fname, i.lname
from account a left outer join individual i 
	on a.cust_id = i.cust_id;
    
/*LEFT OUTER JOIN VS RIGHT OUTER JOIN*/
select c.cust_id, b.name
from customer c left outer join business b
	on c.cust_id = b.cust_id;
    
select c.cust_id, b.name
from customer c right outer join business b
	on c.cust_id = b.cust_id;
    
/*OUTER JOIN USING THREE TABLES*/
select a.account_id, a.product_cd, concat(i.fname, ' ', i.lname) person_name, b.name bussiness_name
from account a left outer join individual i
	on a.cust_id = i.cust_id
	left outer join business b
    on a.cust_id = b.cust_id;
    
/*using subqueries to reduce the number of joins*/
select account_ind.account_id, account_ind.product_cd, account_ind.person_name, b.name business_name
from 
	(select a.account_id, a.product_cd, a.cust_id, concat(i.fname, ' ', i.lname) person_name 
     from account a left outer join individual i
		on a.cust_id = i.cust_id) account_ind
left outer join business b
on account_ind.cust_id = b.cust_id;

/*OUTER AUTO JOIN*/
select e.fname, e.lname, e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e inner join employee e_mgr
	on e.superior_emp_id = e_mgr.emp_id;
    
 /*Including the president*/   
select e.fname, e.lname, e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e left outer join employee e_mgr
	on e.superior_emp_id = e_mgr.emp_id;

/*change to right outer join, means show the employee for each surpevisor */    
select e.fname, e.lname, e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e right outer join employee e_mgr
	on e.superior_emp_id = e_mgr.emp_id;  

/*CROSS JOIN or cartesian product*/
select pt.name, p.product_cd, p.name
from product p cross join product_type pt;

/*Cross join application*/
select ones.num + tens.num + hundreds.num
from 
	(select 0 num union all
    select 1 num union all
    select 2 num union all
    select 3 num union all
    select 4 num union all
    select 5 num union all
    select 6 num union all
    select 7 num union all
    select 8 num union all
    select 9 num) ones
cross join
	(select 0 num union all
    select 10 num union all
    select 20 num union all
    select 30 num union all
    select 40 num union all
    select 50 num union all
    select 60 num union all
    select 70 num union all
    select 80 num union all
    select 90 num) tens
cross join
	(select 0 num union all
    select 100 num union all
    select 200 num union all
    select 300 num) hundreds
order by ones.num + tens.num + hundreds.num;


select days.dt, count(t.txn_id)
from transaction t right outer join 
(select date_add('2004-01-01', interval(ones.num + tens.num + hundreds.num) day) dt
from 
	(select 0 num union all
    select 1 num union all
    select 2 num union all
    select 3 num union all
    select 4 num union all
    select 5 num union all
    select 6 num union all
    select 7 num union all
    select 8 num union all
    select 9 num) ones
cross join
	(select 0 num union all
    select 10 num union all
    select 20 num union all
    select 30 num union all
    select 40 num union all
    select 50 num union all
    select 60 num union all
    select 70 num union all
    select 80 num union all
    select 90 num) tens
cross join
	(select 0 num union all
    select 100 num union all
    select 200 num union all
    select 300 num) hundreds
where date_add('2008-01-01', interval(ones.num + tens.num + hundreds.num) day) < '2009-01-01') days
	on days.dt = t.txn_date
group by days.dt
order by 1;

/*Natural joins*/
select a.account_id, a.cust_id, c.cust_type_cd, c.fed_id
from account a natural join customer c;

select a.account_id, a.cust_id, a.open_branch_id, b.name
from account a natural join branch b;


/*
* 	EXERCISES
*/

/*10.1*/
select p.product_cd, p.name, a.account_id, a.cust_id, a.avail_balance
from product p left outer join account a
	on p.product_cd = a.product_cd;
    
/*10.2*/
select p.product_cd, p.name, a.account_id, a.cust_id, a.avail_balance
from account a right outer join product p
	on p.product_cd = a.product_cd;
    
/*10.3*/
select account.account_id, account.product_cd, individual.fname, individual.lname, business.name
from account account left outer join individual individual
	on account.cust_id = individual.cust_id
left join business business
	on account.cust_id = business.cust_id ;
    
/*10.4*/
select (ones.num + tens.num + 1) number
from (select 0 num union all
		select 1 num union all
		select 2 num union all
        select 3 num union all
        select 4 num union all
        select 5 num union all
        select 6 num union all
        select 7 num union all
        select 8 num union all
        select 9 num) ones
cross join 
	(	select 0 num union all
		select 10 num union all
		select 20 num union all
        select 30 num union all
        select 40 num union all
        select 50 num union all
        select 60 num union all
        select 70 num union all
        select 80 num union all
        select 90 num) tens;