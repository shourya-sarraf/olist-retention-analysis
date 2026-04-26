-- Q3: Delivery Experience Impact on Retention
-- Do customers who received late deliveries 
-- have lower repeat purchase rate?

WITH delivery_label AS (
    SELECT 
        c.customer_unique_id,
        CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date 
                THEN 'Late'
            WHEN order_delivered_customer_date <= order_estimated_delivery_date 
                THEN 'On Time'
        END as delivery_status
    FROM olist_customers_dataset c 
    JOIN olist_orders_dataset o 
        ON c.customer_id = o.customer_id
    WHERE order_delivered_customer_date IS NOT NULL
),

repeat_customers AS (
    SELECT 
        customer_unique_id,
        COUNT(*) as total_orders
    FROM delivery_label
    GROUP BY customer_unique_id
)

SELECT
    delivery_status,
    COUNT(*) as total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) as repeat_customers,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as repeat_rate
FROM repeat_customers r
JOIN delivery_label d ON r.customer_unique_id = d.customer_unique_id
GROUP BY delivery_status;