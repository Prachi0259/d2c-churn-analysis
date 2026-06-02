-- ============================================================
-- D2C Customer Churn Analysis — MySQL Queries
-- Dataset: Olist Brazilian E-Commerce (Kaggle)
-- Author: Prachi | MBA Business Analytics, DTU DSM
-- ============================================================

USE churn_analysis;

-- Q1: Build RFM base table
CREATE TABLE IF NOT EXISTS customer_rfm AS
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS frequency,
    ROUND(SUM(oi.price), 2) AS monetary,
    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp) FROM orders),
        MAX(o.order_purchase_timestamp)
    ) AS recency_days
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;

-- Q2: Assign RFM segments
CREATE TABLE IF NOT EXISTS rfm_segments AS
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    CASE
        WHEN recency_days <= 30 AND frequency >= 3 THEN 'Champions'
        WHEN recency_days <= 60 AND frequency >= 2 THEN 'Loyal'
        WHEN recency_days <= 30 AND frequency = 1  THEN 'Promising'
        WHEN recency_days BETWEEN 61 AND 120
             AND frequency >= 2                    THEN 'At Risk'
        WHEN recency_days > 120                    THEN 'Lost'
        ELSE 'Needs Attention'
    END AS segment
FROM customer_rfm;

-- Q3: Segment summary — customers, revenue, recency
SELECT
    segment,
    COUNT(*)                              AS customer_count,
    ROUND(100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER(), 1)          AS pct_of_base,
    ROUND(AVG(recency_days), 0)           AS avg_days_since_purchase,
    ROUND(AVG(frequency), 1)              AS avg_orders,
    ROUND(AVG(monetary), 2)               AS avg_revenue,
    ROUND(SUM(monetary), 2)               AS total_revenue
FROM rfm_segments
GROUP BY segment
ORDER BY avg_revenue DESC;

-- Q4: High-value At Risk customers — priority win-back list
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary
FROM rfm_segments
WHERE segment = 'At Risk'
  AND monetary > (SELECT AVG(monetary) FROM rfm_segments)
ORDER BY monetary DESC
LIMIT 20;

-- Q5: Monthly order volume trend
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id)                     AS total_orders,
    COUNT(DISTINCT c.customer_unique_id)           AS unique_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- Q6: One-time vs repeat buyer split
SELECT
    CASE WHEN frequency = 1
         THEN 'One-Time Buyer'
         ELSE 'Repeat Buyer'
    END                          AS buyer_type,
    COUNT(*)                     AS customer_count,
    ROUND(100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER(), 1) AS pct_of_base,
    ROUND(AVG(monetary), 2)      AS avg_revenue
FROM rfm_segments
GROUP BY buyer_type;