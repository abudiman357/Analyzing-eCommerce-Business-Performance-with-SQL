-- Step 1 
-- Total company revenue/revenue information for each year

create table revenue_per_year as
select
	date_part('year', o.order_purchase_timestamp) as year,
	sum(rev_per_order) as revenue
from (
	select
		order_id,
		sum(price+freight_value) as rev_per_order
	from order_items
	group by 1
) subq
join orders o on subq.order_id = o.order_id
where o.order_status = 'delivered'
group by 1;

-- Step 2
-- Information on the total number of cancel orders for each year

create table total_cancel_category as 
select 
	date_part('year', order_purchase_timestamp) as year,
	count(1) as sum_canceled
from orders
where order_status = 'canceled'
group by 1;

-- Step 3
-- Product category that provides the highest total revenue for each year

create table top_category_by_revenue as 
select 
	year, 
	product_category_name, 
	revenue 
from (
select 
	date_part('year', o.order_purchase_timestamp) as year,
	p.product_category_name,
	sum(oi.price + oi.freight_value) as revenue,
	rank() over(partition by 
date_part('year', o.order_purchase_timestamp) 
 order by 
sum(oi.price + oi.freight_value) desc) as rnk
from order_items oi
join orders o on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
where o.order_status = 'delivered'
group by 1,2) subq
where rnk = 1

-- Step 4
-- Product category that has the highest number of cancel orders for each year

create table most_canceled_category as 
select 
	year, 
	product_category_name, 
	sum_canceled 
from (
select 
	date_part('year', o.order_purchase_timestamp) as year,
	p.product_category_name,
	count(1) as sum_canceled,
	rank() over(partition by 
date_part('year', o.order_purchase_timestamp) 
			 order by count(1) desc) as rnk
from order_items oi
join orders o on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
where o.order_status = 'canceled'
group by 1,2) subq
where rnk = 1;

-- Step 5
-- Combine the information that has been obtained into one table view

select 
	tcbr.year,
	rpy.revenue as revenue,
	tcc.sum_canceled as cancel,
	tcbr.product_category_name as top_category,
	mcc.product_category_name as top_cancel_category
from top_category_by_revenue tcbr
join revenue_per_year rpy on tcbr.year = rpy.year 
join most_canceled_category mcc on tcbr.year = mcc.year 
join total_cancel_category tcc on tcc.year = tcbr.year;