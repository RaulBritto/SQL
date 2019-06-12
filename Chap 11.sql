/*
*	CONDITIONAL LOGIC
*/

select c.cust_id, c.fed_id, c.cust_type_cd,
	concat(i.fname, ' ', i.lname) indiv_name,
    b.name busineess_name
from customer c left outer join individual i
	on c.cust_id = i.cust_id
    left outer join business b
    on c.cust_id = b.cust_id;
    
/*Turning the two name columns into an unique one.*/
select c.cust_id, c.fed_id,
	case
		when c.cust_type_cd = 'I'
			then concat(i.fname, ' ', i.lname)
		when c.cust_type_cd = 'B'
			then b.name
		else 'Unknown'
	end name
from customer c left outer join individual i
	on c.cust_id = i.cust_id
    left outer join business b
    on c.cust_id = b.cust_id;
    
/*
* 	CASE EXPRESSION in select
*/

case
	when employee.title = 'Head Teller'
		then 'Head Teller'
	when employee.title = 'Teller'
		and year(employee.start_date) > 2007
		then 'Teller Trainee'
	when employee.title = 'Teller'
		and year(employee.start_date) < 2006
		then 'Experienced Teller'
	when employee.title =  'Teller'
		then 'Teller'
	else 'Non-Teller'
End
	

select c.cust_id, c.fed_id,
	case
		when c.cust_type_cd = 'I' then 
			(select concat(i.fname, ' ', i.lname)
			 from individual i
			 where i.cust_id = c.cust_id)
		when c.cust_type_cd = 'B' then
			(select b.name
             from business b
			 where b.cust_id = c.cust_id)
		else 'Unknown'
	end name
from customer c;

/*Simple case expression*/
case customer.cust_type_cd
	when 'I' then 
		(select concat(i.fname, ' ', i.lname)
         from individual i
         where i.cust_id = customer.cust_id)
	when 'B' then 
		(select b.name
         from business b
         where b.cust_id = customer.cust_id)
	else 'Unknown Customer Type'
end

/*Case expression searched*/
case 
	when customer.cust_type_cd = 'I' then
		(select concat(i.fname, ' ', i.lname)
         from individual i
         where i.cust_id = customer.cust_id)
	when customer.cust_type_cd = 'B' then
		(select b.name
         from business b
         where b.cust_id = customer.cust)id)
	else 'Unknown Customer Type'
end

/*
*	EXAMPLES USING CASE EXPRESSION
*/
/*Results in several rows*/
select year(open_date) year, count(*) how_many
from account 
where open_date > '1999-12-31'
	and open_date < '2006-01-01'
group by year(open_date);


select 
	sum(case
		when extract(year from open_date) = 2000 then 1
		else 0
        end) year_2000,
	sum(case
		when extract(year from open_date) = 2001 then 1
		else 0
        end) year_2001,
	sum(case
		when extract(year from open_date) = 2002 then 1
		else 0
        end) year_2002,     
	sum(case
		when extract(year from open_date) = 2003 then 1
		else 0
        end) year_2003, 
	sum(case
		when extract(year from open_date) = 2004 then 1
		else 0
        end) year_2004,
	sum(case
		when extract(year from open_date) = 2005 then 1
		else 0
        end) year_2005
from account
where open_date > '1999-12-31' and open_date  < '2006-01-01';

/*Aggregation selective*/
select concat('ALERT!: Account #', a.account_id, ' Has Incorrect Balance!')
from account a 
where (a.avail_balance, a.pending_balance) <>
	(select 
		sum(case
			when t.funds_avail_date > current_timestamp()
				then 0
			when t.txn_type_cd = 'DBT'
				then t.amount * -1
			else t.amount
		end), 
	sum(case
			when t.txn_type_cd = 'DBT'
				then t.amount * -1
			else t.amount
		end)
from transaction t
where t.account_id = a.account_id);

/*Checking the existence*/
select c.cust_id, c.fed_id, c.cust_type_cd,
	case
		when exists (select 1 from account a
			where a.cust_id = c.cust_id
				and a.product_cd = 'CHK') then 'Y'
		else 'N'
	end has_checking,
    case when exists (select 1 from account a
			where a.cust_id = c.cust_id
				and a.product_cd = 'SAV') then 'Y'
		else 'N'
	end has_savings
from customer c;

/*Creating groups*/
select c.cust_id, c.fed_id, c.cust_type_cd,
	case (select count(*) from account a
			where a.cust_id = c.cust_id)
		when 0 then 'None'
        when 1 then '1'
        when 2 then '2'
        else '3+'
	end num_accounts
from customer c;

/*DIVIDING BY ZERO*/
select 100/0;

/*Treating denominators*/
select a.cust_id, a.product_cd, a.avail_balance /
	case 
		when prod_tots.tot_balance = 0 then 1
        else prod_tots.tot_balance
	end percent_of_total
from account a inner join 
	(select a.product_cd, sum(a.avail_balance) tot_balance
     from account a
     group by a.product_cd) prod_tots
on a.product_cd = prod_tots.product_cd
order by a.product_cd;

/*Updating using case*/
update account
set last_activity_date = current_timestamp(), 
	pending_balance = pending_balance + 
		(select t.amount * 
			case t.txn_type_cd when 'DBT' then -1 else 1 end
		from transaction t
        where t.txn_id = 999),
avail_balance = avail_balance + 
	(select
		case 
			when t.funds_avail_date > current_timestamp() then 0
            else t.amount *
				case t.txn_type_cd when 'DBT' then -1 else 1 end
		end
        from transaction t
        where t.txn_id = 999)
	where account_id = (select t.account_id
						from transaction t
                        where t.txn_id = 999);
                        
/*Treating null values*/
select emp_id, fname, lname, 
	case
		when title is null then 'Unknown'
        else title
	end title
from employee;

select (7*5)/((3 +14) * null);

/*
*	EXERCISES
*/

/*11.1*/
select emp_id,
	case 
		when title in ('President', 'Vice President', 'Treasurer', 'Loan Manager') then 'Management'
        when title in ('Operations Manager', 'Head Teller', 'Teller' )then 'Operations'
		else 'Unknown'
	end title
from employee;


/*Another solution*/
select emp_id,
	case
		when title  like '%President' or title = 'Loan Manager' or title = 'Treasurer'
			then 'Management'
		when title like '%Teller' or title = 'Operations Manager' then 'Operations'
	else 'Unknown'
	end title
from employee;

/*11.2*/
select open_branch_id, count(*)
from account
group by open_branch_id;

select 
	sum(case open_branch_id when 1 then	1 else 0 end) open_branch_1,
	sum(case open_branch_id when 2 then 1 else 0 end) open_branch_2,
	sum(case open_branch_id when 3 then 1 else 0 end) open_branch_3,
	sum(case open_branch_id when 4 then 1 else 0 end) open_branch_4
from account;