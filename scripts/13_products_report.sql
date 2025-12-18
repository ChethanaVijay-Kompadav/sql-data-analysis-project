/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================



IF OBJECT_ID('gold.products_report', 'V') IS NOT NULL
DROP VIEW gold.products_report;
GO


CREATE VIEW gold.products_report AS

WITH base_query AS(
/*--------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
--------------------------------------------------------------------------------*/
SELECT 
    f.order_number,
    f.customer_id,
    f.order_date,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON f.product_key = p.product_key),

customers_aggregation AS(
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT 
product_key,--
product_name,--
category,--
subcategory,--
cost,--
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
COUNT(order_number) AS total_orders,--
SUM(sales_amount) AS total_sales,--
COUNT(DISTINCT customer_id) AS total_customers,--
SUM(quantity) AS total_quantity,--
ROUND(AVG(CAST(sales_amount AS FLOAT) / (NULLIF(quantity,0))),1) AS avg_selling_price,
--MIN(order_date) AS first_order,
--MAX(order_date) AS last_order,
DATEDIFF(month, MAX(order_date), GETDATE()) AS recency

FROM base_query
GROUP BY product_key, 
product_name,
category,
subcategory,
cost)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    lifespan,
    recency,
    CASE 
        WHEN total_sales > 50000 THEN 'High-Performers'
        WHEN total_sales >= 10000 THEN 'Mid Range'
        ELSE 'Low-Performers'
    END AS customer_segment,
    -- average order revenue
    CASE
        WHEN total_sales = 0 THEN 0 
        ELSE total_sales / total_orders
    END AS avg_order_revenue,
    -- average monthly revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS average_monthly_revenue

 FROM customers_aggregation;

