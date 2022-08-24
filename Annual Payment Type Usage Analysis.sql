-- Step 1
-- The amount of use of each type of payment all the time sorted from the most favorite

select 
	payment_type,
	count(*) as total_used
from order_payments op
	join orders o 
        on op.order_id = o.order_id
group by 1
order by 2 desc;

-- Step 2
-- Information on the amount of use of each type of payment for each year

select
	date_part('year', o.order_purchase_timestamp) AS purchase_year,
	op.payment_type,
	count(*) as transactions
from orders o
	join order_payments op 
        on o.order_id = op.order_id
group by 1,2
order by 1, 3 desc;
	
select
	date_part('year', o.order_purchase_timestamp) as purchase_year,
	sum(case when (op.payment_type='credit_card') then 1 else 0 end) as credit_card,
	sum(case when (op.payment_type='boleto') then 1 else 0 end) as boleto,
	sum(case when (op.payment_type='voucher') then 1 else 0 end) as voucher,
	sum(case when (op.payment_type='debit_card') then 1 else 0 end) as debit_card,
	sum(case when (op.payment_type='not_defined') then 1 else 0 end) as not_defined
from orders o
	join order_payments op 
        on o.order_id = op.order_id
group by 1
order by 1;