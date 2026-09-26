-- Star schema: 4 dimension tables + 1 fact table, built from the orders table.
-- Safe to re-run: old tables are dropped first.

DROP TABLE IF EXISTS fact_order, dim_customer, dim_product, dim_channel, dim_date;

-- Dim_Customer: one row per customer
CREATE TABLE dim_customer AS
SELECT DISTINCT customer_id, customer_name, gender, age_group, city, region, customer_segment
FROM orders;
ALTER TABLE dim_customer ADD PRIMARY KEY (customer_id);

-- Dim_Product: one row per product (keyed by name, because product_id is unreliable)
CREATE TABLE dim_product (
    product_key      SERIAL PRIMARY KEY,
    product_name     TEXT NOT NULL,
    product_category TEXT NOT NULL
);
INSERT INTO dim_product (product_name, product_category)
SELECT DISTINCT product_name, product_category FROM orders;

-- Dim_Channel: one row per sales channel
CREATE TABLE dim_channel (
    channel_key   SERIAL PRIMARY KEY,
    sales_channel TEXT NOT NULL
);
INSERT INTO dim_channel (sales_channel)
SELECT DISTINCT sales_channel FROM orders;

-- Dim_Date: one row per order date
CREATE TABLE dim_date AS
SELECT DISTINCT
    order_date::date AS date_key,
    order_year       AS year,
    order_quarter    AS quarter,
    order_month      AS month,
    order_day        AS day_name
FROM orders;
ALTER TABLE dim_date ADD PRIMARY KEY (date_key);

-- Fact_Order: one row per order, linked to each dimension
CREATE TABLE fact_order AS
SELECT
    o.order_id,
    o.customer_id,
    p.product_key,
    c.channel_key,
    o.order_date::date AS date_key,
    o.quantity,
    o.unit_price,
    o.discount_rate,
    o.order_revenue,
    o.delivery_fee,
    o.total_amount,
    o.delivery_days,
    o.customer_rating,
    o.payment_method,
    o.order_status,
    o.delivery_status,
    o.return_flag
FROM orders o
JOIN dim_product p ON p.product_name = o.product_name AND p.product_category = o.product_category
JOIN dim_channel c ON c.sales_channel = o.sales_channel;

ALTER TABLE fact_order ADD PRIMARY KEY (order_id);
ALTER TABLE fact_order ADD FOREIGN KEY (customer_id) REFERENCES dim_customer (customer_id);
ALTER TABLE fact_order ADD FOREIGN KEY (product_key) REFERENCES dim_product (product_key);
ALTER TABLE fact_order ADD FOREIGN KEY (channel_key) REFERENCES dim_channel (channel_key);
ALTER TABLE fact_order ADD FOREIGN KEY (date_key)    REFERENCES dim_date (date_key);