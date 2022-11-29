-- Step 1
-- The amount of use of each type of payment all the time sorted from the most favorite

SELECT
	payment_type,
	COUNT(order_id) AS payment_type_usage
FROM order_payments
GROUP BY 1
ORDER BY 2 DESC;
				   
--Subtask 2
--Show information detail of total payment type usage each year

SELECT
	payment_type,
	SUM(CASE WHEN year = 2016 THEN payment_type_usage ELSE 0 END) AS "year_2016",
	SUM(CASE WHEN year = 2017 THEN payment_type_usage ELSE 0 END) AS "year_2017",
	SUM(CASE WHEN year = 2018 THEN payment_type_usage ELSE 0 END) AS "year_2018",
	SUM(payment_type_usage) AS sum_payment_type_usage
FROM (SELECT
	  	DATE_PART('year', order_purchase_timestamp) AS year,
	 	payment_type,
	 	COUNT(payment_type) AS payment_type_usage
	  FROM orders AS o
	  JOIN order_payments AS op ON op.order_id = o.order_id
	  GROUP BY 1, 2
	 ) AS subq
GROUP BY 1
ORDER BY 2 DESC;
