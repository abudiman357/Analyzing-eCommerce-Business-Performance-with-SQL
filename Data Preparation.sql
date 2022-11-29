--Subtask 1
--Create table

CREATE TABLE customers (
	customer_id VARCHAR,
	customer_unique_id VARCHAR,
	customer_zip_code_prefix INT,
	customer_city VARCHAR,
	customer_state VARCHAR
);
CREATE TABLE geolocation (
	geo_zip_code_prefix VARCHAR,
	geo_lat VARCHAR,
	geo_lng VARCHAR,
	geo_city VARCHAR,
	geo_state VARCHAR
);
CREATE TABLE order_items (
	order_id VARCHAR,
	order_item_id INT,
	product_id VARCHAR,
	seller_id VARCHAR,
	shipping_limit_date TIMESTAMP,
	price FLOAT,
	freight_value FLOAT
);
CREATE TABLE order_payments (
	order_id VARCHAR,
	payment_sequential INT,
	payment_type VARCHAR,
	payment_installment INT,
	payment_value FLOAT
);
CREATE TABLE order_reviews (
	review_id VARCHAR,
	order_id VARCHAR,
	review_score INT, 
	review_comment_title VARCHAR,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP,
	review_answer TIMESTAMP
);
CREATE TABLE orders (
	order_id VARCHAR,
	customer_id VARCHAR,
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivered_date TIMESTAMP
);
CREATE TABLE products (
    num INT,
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_length NUMERIC,
	product_description_length NUMERIC,
	product_photos_qty NUMERIC,
	product_weight_g NUMERIC,
	product_length_cm NUMERIC,
	product_height_cm NUMERIC,
	product_width_cm NUMERIC
);
CREATE TABLE sellers (
	seller_id VARCHAR,
	seller_zip_code_prefix INT,
	seller_city VARCHAR,
	seller_state VARCHAR
);

--Subtask 2
--Import csv dataset to the table

COPY customers(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
FROM 'D:\Mini Project\1\Dataset\customers_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY geolocation(
	geo_zip_code_prefix,
	geo_lat,
	geo_lng,
	geo_city,
	geo_state
)
FROM 'D:\Mini Project\1\Dataset\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY order_items(
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
FROM 'D:\Mini Project\1\Dataset\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY order_payments(
	order_id,
	payment_sequential,
	payment_type,
	payment_installment,
	payment_value
)
FROM 'D:\Mini Project\1\Dataset\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY order_reviews(
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer
)
FROM 'D:\Mini Project\1\Dataset\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY orders(
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
    order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivered_date
)
FROM 'D:\Mini Project\1\Dataset\orders_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY products(
    num,
    product_id,
	product_category_name,
	product_name_length,
	product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
FROM 'D:\Mini Project\1\Dataset\product_dataset.csv'
DELIMITER ','
CSV HEADER;
COPY sellers(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
FROM 'D:\Mini Project\1\Dataset\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

--Subtask 3
--Determine primary key and foreign key for relation in each data and create ERD

-- Primary Key
ALTER TABLE customers ADD CONSTRAINT pk_cust PRIMARY KEY (customer_id);
ALTER TABLE orders ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);
ALTER TABLE products ADD CONSTRAINT pk_products PRIMARY KEY (product_id);
ALTER TABLE sellers ADD CONSTRAINT pk_seller PRIMARY KEY (seller_id);
-- Foreign Key
ALTER TABLE order_items ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY(product_id) REFERENCES products;
ALTER TABLE order_items	ADD FOREIGN KEY(seller_id) REFERENCES sellers;
ALTER TABLE order_payments ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_reviews ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE orders ADD FOREIGN KEY(customer_id) REFERENCES customers;
