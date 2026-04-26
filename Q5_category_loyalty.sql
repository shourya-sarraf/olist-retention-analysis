-- Q5: Product Category Loyalty Analysis
-- Which categories generate the most loyal repeat customers?

WITH customer_categories AS (
    SELECT
        c.customer_unique_id,
        t.product_category_name_english as category_english,
        COUNT(DISTINCT o.order_id) as total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi ON oi.order_id = o.order_id
    JOIN olist_products_dataset p ON p.product_id = oi.product_id
    JOIN product_category_name_translation t 
        ON t.product_category_name = p.product_category_name
    GROUP BY c.customer_unique_id, t.product_category_name_english
)

SELECT
    category_english,
    COUNT(*) as total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) as repeat_customers,
    ROUND(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as repeat_rate
FROM customer_categories
GROUP BY category_english
HAVING COUNT(*) > 100
ORDER BY repeat_rate DESC
LIMIT 10;