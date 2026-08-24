USE sales_analysis;

-- 1. View all customers
SELECT * FROM customers;

-- 2. Distinct customer cities
SELECT DISTINCT city
FROM customers;

-- 3. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 4. Total sales revenue
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- 5. Average order value
SELECT AVG(total_amount) AS average_order_value
FROM orders;

-- 6. Highest-value order
SELECT *
FROM orders
ORDER BY total_amount DESC
LIMIT 1;

-- 7. Sales by city
SELECT c.city,
       COUNT(DISTINCT c.customer_id) AS customers,
       SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue DESC;

-- 8. Sales by product category
SELECT p.category,
       SUM(o.quantity) AS units_sold,
       SUM(o.total_amount) AS revenue
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 9. Top customers by spending
SELECT c.customer_name,
       c.city,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent DESC
LIMIT 5;

-- 10. Customers spending above ₦300,000
SELECT c.customer_name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 300000
ORDER BY total_spent DESC;

-- 11. Monthly revenue
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

-- 12. Product performance
SELECT p.product_name,
       p.category,
       SUM(o.quantity) AS units_sold,
       SUM(o.total_amount) AS revenue
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC;

-- 13. Customers with no orders
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 14. Revenue contribution by city
SELECT c.city,
       SUM(o.total_amount) AS revenue,
       ROUND(
           SUM(o.total_amount) /
           (SELECT SUM(total_amount) FROM orders) * 100, 2
       ) AS revenue_percentage
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue DESC;

-- 15. Basic business insight: orders above average value
SELECT *
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC;
