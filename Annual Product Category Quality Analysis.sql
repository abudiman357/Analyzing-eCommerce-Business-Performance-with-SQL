-- Step 1 
-- Total company revenue/revenue information for each year

CREATE TABLE total_revenue AS
SELECT
	DATE_PART('year', o.order_purchase_timestamp) AS year,
	SUM(oi.price + oi.freight_value) AS revenue
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY year ASC;

--Subtask 2
--Create table with information of total canceled order each year.
--Make sure filter order status with canceled.

CREATE TABLE total_canceled AS
SELECT
	DATE_PART('year', order_purchase_timestamp) AS year,
	COUNT(order_id) AS canceled_order
FROM orders
WHERE order_status = 'canceled'
GROUP BY 1
ORDER BY year ASC;

--Subtask 3
--Create table with product category name that give total most revenue each year.

CREATE TABLE top_revenue AS
SELECT
	year,
	top_revenue,
	top_product_revenue
FROM(SELECT
		DATE_PART('year', o.order_purchase_timestamp) AS year,
	 	p.product_category_name AS top_revenue,
	 	SUM(price + freight_value) AS top_product_revenue,
	 	RANK() OVER(PARTITION BY DATE_PART('year', o.order_purchase_timestamp)
				    ORDER BY SUM(oi.price + oi.freight_value) DESC
					) AS rank
	 FROM orders AS o
	 JOIN order_items AS oi ON oi.order_id = o.order_id
	 JOIN products AS p ON p.product_id = oi.product_id
	 WHERE order_status = 'delivered'
	 GROUP BY 1, 2
	 ) AS subq
WHERE rank = 1;

--Subtask 4
--Create table product category name with total most cancel order each year.

CREATE TABLE top_canceled AS
SELECT
	year,
	top_canceled,
	top_product_canceled
FROM(SELECT
		DATE_PART('year', o.order_purchase_timestamp) AS year,
	 	p.product_category_name AS top_canceled,
	 	COUNT(o.order_id) AS top_product_canceled,
	 	RANK() OVER(PARTITION BY DATE_PART('year', order_purchase_timestamp)
				    ORDER BY COUNT(o.order_id) DESC
					) AS rank
	 FROM orders AS o
	 JOIN order_items AS oi ON oi.order_id = o.order_id
	 JOIN products AS p ON p.product_id = oi.product_id
	 WHERE order_status = 'canceled'
	 GROUP BY 1, 2
	 ) AS subq
WHERE rank = 1;

--Subtask 5
--Group completed information in one display.

SELECT
	torev.year,
	tr.top_revenue,
	tr.top_product_revenue,
	torev.revenue AS total_revenue,
	tc.top_canceled,
	tc.top_product_canceled,
	tocan.canceled_order AS total_canceled
FROM total_revenue AS torev
JOIN total_canceled AS tocan ON tocan.year = torev.year
JOIN top_revenue AS tr ON tr.year = torev.year
JOIN top_canceled AS tc ON tc.year = torev.year;
