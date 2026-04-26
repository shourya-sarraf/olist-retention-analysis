-- Q4: Customer Satisfaction vs Retention
-- Do customers who gave high review scores 
-- have higher repeat purchase rate?

WITH customer_reviews AS (
    SELECT
        c.customer_unique_id,
        MIN(r.review_score) as first_review_score,
        COUNT(DISTINCT o.order_id) as total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    first_review_score,
    COUNT(*) as total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) as repeat_customers,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as repeat_rate
FROM customer_reviews
GROUP BY first_review_score
ORDER BY first_review_score;