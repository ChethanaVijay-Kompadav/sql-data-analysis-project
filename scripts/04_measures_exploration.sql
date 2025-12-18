/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/


--SELECT * FROM [gold].[dim_customers];
--SELECT * FROM [gold].[dim_products];
--SELECT * FROM [gold].[fact_sales];


-- find the total sales
SELECT 
	SUM(sales_amount) AS total_sales 
FROM [gold].[fact_sales];

--Find how many items are sold
SELECT SUM(quantity) AS Total_items 
FROM [gold].[fact_sales];

-- Find the Average Selling Price
SELECT 
	AVG(price) AS avg_price 
FROM [gold].[fact_sales];

-- Find the Total number of Orders
SELECT 
	COUNT(order_number) AS order_count,
	COUNT(DISTINCT order_number) AS distinct_order_count
FROM [gold].[fact_sales];

-- Find the Total number of products
SELECT 
	COUNT(product_id) AS product_count,
	COUNT(DISTINCT product_id) AS distinct_product_count
FROM [gold].[dim_products];


-- Find the Total number of Customers
-- Find the total number of customers who have placed the Order
SELECT 
	COUNT(customer_id) AS customer_count,
	COUNT(DISTINCT customer_id) AS distinct_customer_count
FROM [gold].[dim_customers];

-- Generate a Report that shows all key metrics of the business
SELECT 
	'Total Sales' AS measure_name,SUM(sales_amount) AS measure_value FROM  [gold].[fact_sales]
UNION ALL
SELECT 'Total_items', SUM(quantity) FROM [gold].[fact_sales]
UNION ALL
SELECT 'Average Price', AVG(price) FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_id) FROM [gold].[dim_products]
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_id) FROM [gold].[dim_customers];