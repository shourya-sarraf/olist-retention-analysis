-- Q2: Cohort Retention Analysis
-- Of customers who first purchased in a given month, 
-- how many returned in following months?

WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        STRFTIME('%Y-%m', MIN(o.order_purchase_timestamp)) as cohort_month
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),

all_purchases AS (
    SELECT
        c.customer_unique_id,
        STRFTIME('%Y-%m', o.order_purchase_timestamp) as purchase_month
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
),

cohort_data AS (
    SELECT 
        f.cohort_month,
        a.purchase_month,
        COUNT(DISTINCT a.customer_unique_id) as customers
    FROM first_purchase f
    JOIN all_purchases a 
        ON f.customer_unique_id = a.customer_unique_id
    GROUP BY f.cohort_month, a.purchase_month
)

SELECT
    cohort_month,
    purchase_month,
    customers,
    ROUND(customers * 100.0 / FIRST_VALUE(customers) OVER (
        PARTITION BY cohort_month 
        ORDER BY purchase_month
    ), 2) as retention_percentage
FROM cohort_data
ORDER BY cohort_month, purchase_month;