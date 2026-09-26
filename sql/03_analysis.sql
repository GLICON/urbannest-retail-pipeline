-- Revenue by year
SELECT order_year, SUM(order_revenue) AS revenue
FROM orders WHERE order_status = 'Completed'
GROUP BY order_year ORDER BY order_year;

-- Revenue by product category
SELECT product_category, SUM(order_revenue) AS revenue
FROM orders WHERE order_status = 'Completed'
GROUP BY product_category ORDER BY revenue DESC;

-- Revenue by customer segment
SELECT customer_segment, SUM(order_revenue) AS revenue
FROM orders WHERE order_status = 'Completed'
GROUP BY customer_segment ORDER BY revenue DESC;

-- Revenue by sales channel
SELECT sales_channel, SUM(order_revenue) AS revenue
FROM orders WHERE order_status = 'Completed'
GROUP BY sales_channel ORDER BY revenue DESC;

-- Delivery performance
SELECT delivery_status, COUNT(*) AS orders
FROM orders
GROUP BY delivery_status ORDER BY orders DESC;