/*
*	Grouping data
*/

select open_emp_id
from account;

/*GROUP BY CLAUSE*/
select open_emp_id
from account 
group by open_emp_id;

select open_emp_id, count(*) how_many
from account 
group by open_emp_id;

/*ERROR FUNCTION*/
select open_emp_id, count(*) how_many
from account
where count(*) > 4
group by open_emp_id;

select open_emp_id, count(*) how_many
from account
group by open_emp_id
having count(*) > 4;

/*
*AGGREGATION FUNCTIONS
*/
select max(avail_balance) max_balance,
	min(avail_balance) min_balance,
    avg(avail_balance) avg_balance,
    sum(avail_balance) tot_balance,
    count(*) num_accounts
from account 
where product_cd = 'CHK';


/*
*   Implicit groups and explict groups
*/

#ERROR
select product_cd,
    max(avail_balance) max_balance,
	min(avail_balance) min_balance,
    avg(avail_balance) avg_balance,
    sum(avail_balance) tot_balance,
    count(*) num_accounts
from account ;

/*Aggregation for kind of product*/
select product_cd,
    max(avail_balance) max_balance,
	min(avail_balance) min_balance,
    avg(avail_balance) avg_balance,
    sum(avail_balance) tot_balance,
    count(*) num_accounts
from account 
group by product_cd;

/*
*   COUNTING DISTINCT VALUES
*/


select account_id, open_emp_id
from account
order by open_emp_id;


select count(distinct open_emp_id)
from account;

/*
*   USING EXPRESSIONS
*/

select max(pending_balance - avail_balance) max_uncleared
from account;


/*
*   CONSIDERING NULL VALUES
*/

create table number_tbl
    (val  smallint)

insert into number_tbl VALUES (1);
insert into number_tbl VALUES (3);
insert into number_tbl VALUES (5);


select count(*) num_rows,
    count(val) num_vals,
    sum(val) total,
    max(val) max_val,
    avg(val) avg_val
from number_tbl;

/*Adding a null value*/
insert into number_tbl values(null)

select count(*) num_rows,
    count(val) num_vals,
    sum(val) total,
    max(val) max_val,
    avg(val) avg_val
from number_tbl;

/*
*   GENERATING GROUPS
*/

/**Grouping by a column*/ 

select product_cd, SUM(avail_balance) prod_balance
from account
group by product_cd;

/*Grouping by multiples columns*/

select product_cd, open_branch_id, sum(avail_balance) tot_balance
from account
group by product_cd, open_branch_id
order by product_cd;

/*Grouping using expressions*/
select extract(year from start_date) year,
    count(*) how_many
from employee
group by extract(year from start_date);

/*Generation brief (rollups)*/
select product_cd, open_branch_id, sum(avail_balance) tot_balance
from account
group by product_cd, open_branch_id with rollup;


/*
*   CONDITIONS IN FILTER OF GROUP
*/

select product_cd, sum(avail_balance) prod_balance
from account
where status = 'ACTIVE'
group by product_cd
having sum(avail_balance) >= 10000;

/*ERROR**/
select product_cd, sum(avail_balance) prod_balance
from account
where status = 'ACTIVE' 
    and sum(avail_balance) >= 10000;
group by product_cd;

select product_cd, sum(avail_balance) prod_balance
from account
where status = 'ACTIVE' 
group by product_cd
having min(avail_balance) >= 1000
    and max(avail_balance) <= 10000;


/*
*   EXERCISES
*/

/*8.1*/
select count(*)
from account;

/*8.2*/
select cust_id, count(account_id) num_accounts
from account
group by cust_id;

/*8.3*/
select cust_id, count(account_id) num_accounts
from account
group by cust_id
having count(*) >= 2;


/*8.4*/
select product_cd, open_branch_id, count(*) num_accounts,sum(avail_balance)
from account
group by product_cd, open_branch_id
having count(*) > 1
order by sum(avail_balance) desc;
