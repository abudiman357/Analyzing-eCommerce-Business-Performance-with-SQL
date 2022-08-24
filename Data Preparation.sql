-- Step 1
-- Create table

create table customers (
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix int,
	customer_city varchar,
	customer_state varchar
);

create table geolocation (
	geo_zip_code_prefix varchar,
	geo_lat varchar,
	geo_lng varchar,
	geo_city varchar,
	geo_state varchar
);

create table order_items (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price float,
	freight_value float
);

create table order_payments (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installment int,
	payment_value float
);


create table order_reviews (
	review_id varchar,
	order_id varchar,
	review_score int, 
	review_comment_title varchar,
	review_comment_message text,
	review_creation_date timestamp,
	review_answer timestamp
);

create table orders (
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivered_date timestamp
);

create table products (
    num int,
	product_id varchar,
	product_category_name varchar,
	product_name_length numeric,
	product_description_length numeric,
	product_photos_qty numeric,
	product_weight_g numeric,
	product_length_cm numeric,
	product_height_cm numeric,
	product_width_cm numeric
);

create table sellers (
	seller_id varchar,
	seller_zip_code_prefix int,
	seller_city varchar,
	seller_state varchar
);

-- STEP 2
-- Import csv dataset to the table.

copy customers(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
from 'D:\Mini Project\1\customers_dataset.csv'
delimiter ','
csv header;

copy geolocation(
	geo_zip_code_prefix,
	geo_lat,
	geo_lng,
	geo_city,
	geo_state
)
from 'D:\Mini Project\1\geolocation_dataset.csv'
delimiter ','
csv header;

copy order_items(
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
from 'D:\Mini Project\1\order_items_dataset.csv'
delimiter ','
csv header;

copy order_payments(
	order_id,
	payment_sequential,
	payment_type,
	payment_installment,
	payment_value
)
from 'D:\Mini Project\1\order_payments_dataset.csv'
delimiter ','
csv header;

copy order_reviews(
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer
)
from 'D:\Mini Project\1\order_reviews_dataset.csv'
delimiter ','
csv header;

copy orders(
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
    order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivered_date
)
from 'D:\Mini Project\1\orders_dataset.csv'
delimiter ','
csv header;

copy products(
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
from 'D:\Mini Project\1\product_dataset.csv'
delimiter ','
csv header;

copy sellers(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
from 'D:\Mini Project\1\sellers_dataset.csv'
delimiter ','
csv header;

-- Step 3
-- Determine primary key and foreign key for relation in each data and create ERD

-- Primary Key
alter table customers add constraint pk_cust primary key (customer_id);
alter table orders add constraint pk_orders primary key (order_id);
alter table products add constraint pk_products primary key (product_id);
alter table sellers add constraint pk_seller primary key (seller_id);

-- Foreign Key
ALTER TABLE order_items ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY(product_id) REFERENCES products;
ALTER TABLE order_items	ADD FOREIGN KEY(seller_id) REFERENCES sellers;
ALTER TABLE order_payments ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_reviews ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE orders ADD FOREIGN KEY(customer_id) REFERENCES customers;