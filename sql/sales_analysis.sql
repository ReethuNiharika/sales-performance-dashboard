-- Sales Performance Analytics Project
-- Use this file in PostgreSQL/MySQL/SQL Server with minor date syntax adjustments.

CREATE TABLE sales_orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    region VARCHAR(50),
    segment VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(100),
    customer_id VARCHAR(20),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2),
    revenue DECIMAL(12,2),
    cost DECIMAL(12,2),
    profit DECIMAL(12,2)
);

-- KPI summary
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM sales_orders;

-- Monthly revenue and profit trend
SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,
    COUNT(DISTINCT order_id) AS orders
FROM sales_orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Regional performance
SELECT
    region,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS margin_pct
FROM sales_orders
GROUP BY region
ORDER BY revenue DESC;

-- Best and weak products
SELECT
    product,
    category,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,
    COUNT(*) AS order_count
FROM sales_orders
GROUP BY product, category
ORDER BY profit DESC;