-- Q1: Repeat Purchase Rate
-- What percentage of customers made more than one purchase?

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) as total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

customer_type AS (
    SELECT
        CASE 
            WHEN total_orders = 1 THEN 'One Time Buyer'
            WHEN total_orders > 1 THEN 'Repeat Buyer'
        END as customer_type,
        COUNT(*) as customer_count
    FROM customer_orders
    GROUP BY customer_type
)

SELECT
    customer_type,
    customer_count,
    ROUND(customer_count * 100.0 / SUM(customer_count) OVER(), 2) as percentage
FROM customer_type;