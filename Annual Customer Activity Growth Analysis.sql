--Subtask 1
--Average number of monthly active users for each year

WITH
mau_of_year AS (
SELECT
	year,
	round(AVG(mau), 2) AS avg_mau
FROM (
	SELECT
		date_part('year', o.order_purchase_timestamp) AS year,
		date_part('month', o.order_purchase_timestamp) AS month,
		COUNT(DISTINCT c.customer_unique_id) AS mau
	FROM orders o
	JOIN customers c
	    ON o.customer_id = c.customer_id
	GROUP BY 1, 2
) subq
GROUP BY 1),

--Subtask 2
--number of new customers every year

newcust_of_year AS (
SELECT
	date_part('year', first_order) AS year,
	COUNT(customer_unique_id) AS new_customers
FROM
	(SELECT
		c.customer_unique_id,
		MIN(o.order_purchase_timestamp) AS first_order
	FROM orders AS o
	JOIN customers AS c
		ON c.customer_id = o.customer_id
	GROUP BY 1) AS subq
GROUP BY 1
ORDER BY 1 ASC),

--Subtask 3
--number of customers who make purchases more than once (repeat orders) in each year

repeat_of_year AS (
SELECT
    year,
    COUNT(DISTINCT customer) AS repeat_customer
FROM(
    SELECT
        date_part('year', o.order_purchase_timestamp) AS year,
        c.customer_unique_id AS customer,
        COUNT(order_id) AS total_transaction
    FROM customers c
    JOIN orders o
        ON c.customer_id=o.customer_id
    GROUP BY 1,2
    HAVING COUNT(order_id) > 1
)subq
GROUP BY 1),

--Subtask 4
--average number of orders made by customers for each year

avg_freq_of_year AS (
SELECT
    year,
    round(AVG(total_transaction),4) AS avg_transaction
FROM(
    SELECT
        date_part('year', o.order_purchase_timestamp) AS year,
		c.customer_unique_id AS customer,
        COUNT(order_id) AS total_transaction
    FROM customers c
    JOIN orders o
        ON c.customer_id=o.customer_id
    GROUP BY 1,2
)subq
GROUP BY 1)

--Subtask 5
--Merge the tables above

SELECT 
	moy.year, 
	moy.avg_mau,
	noy.new_customers,
	roy.repeat_customer, 
	afoy.avg_transaction
FROM mau_of_year AS moy 
JOIN newcust_of_year AS noy ON moy.year = noy.year
JOIN repeat_of_year AS roy ON roy.year = moy.year
JOIN avg_freq_of_year AS afoy ON afoy.year = moy.year;
