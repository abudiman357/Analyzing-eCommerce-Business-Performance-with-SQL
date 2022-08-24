with
-- Step 1
-- Average number of monthly active users for each year
mau_of_year as (
select
	year,
	round(avg(mau), 2) as avg_mau
from (
	select
		date_part('year', o.order_purchase_timestamp) as year,
		date_part('month', o.order_purchase_timestamp) as month,
		count(distinct c.customer_unique_id) as mau
	from orders o
	join customers c
	    on o.customer_id = c.customer_id
	group by 1, 2
) subq
group by 1),

-- Step 2
-- number of new customers every year

newcust_of_year as (
select
	date_part('year', first_order) as year,
	count(customer_unique_id) as new_customers
from
	(select
		c.customer_unique_id,
		min(o.order_purchase_timestamp) as first_order
	from orders as o
	join customers as c
		on c.customer_id = o.customer_id
	group by 1) as subq
group by 1
order by 1 asc),

-- Step 3
-- number of customers who make purchases more than once (repeat orders) in each year

repeat_of_year as (
select
    year,
    count(distinct customer) as repeat_customer
from(
    select
        date_part('year', o.order_purchase_timestamp) as year,
        c.customer_unique_id as customer,
        count(order_id) as total_transaction
    from customers c
    join orders o
        on c.customer_id=o.customer_id
    group by 1,2
    having count(order_id) > 1
)subq
group by 1),

-- Step 4
-- average number of orders made by customers for each year

avg_freq_of_year as (
select
    year,
    round(avg(total_transaction),4) as avg_transaction
from(
    select
        date_part('year', o.order_purchase_timestamp) as year,
		c.customer_unique_id as customer,
        count(order_id) as total_transaction
    from customers c
    join orders o
        on c.customer_id=o.customer_id
    group by 1,2
)subq
group by 1)

-- Step 5
-- Merge the tables above

select 
	moy.year, 
	moy.avg_mau, 
	noy.new_customers,
	roy.repeat_customer, 
	afoy.avg_transaction
from mau_of_year as moy 
join newcust_of_year as noy on moy.year = noy.year
join repeat_of_year as roy on roy.year = moy.year
join avg_freq_of_year as afoy on afoy.year = moy.year;
