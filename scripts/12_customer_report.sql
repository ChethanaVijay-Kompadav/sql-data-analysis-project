/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================

--SELECT TOP 5 * FROM [gold].[fact_sales];
--SELECT TOP 5 * FROM [gold].[dim_customers];

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
DROP VIEW gold.report_customers;

GO

CREATE VIEW gold.report_customers AS

WITH base_query AS(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_id,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	c.country,
	c.marital_status,
	c.gender,
	DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id = c.customer_key
WHERE F.order_date IS NOT NULL),

aggregation_query AS(
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT 
	customer_id,
	customer_number,
	customer_name,
	country,
	marital_status,
	gender,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(product_key) AS total_products,
	SUM(sales_amount) AS total_sales,
	--AVG(sales_amount) AS avg_salesamount,
	SUM(quantity) AS total_quantity,
	--MIN(order_date) AS first_order,
	--MAX(order_date) AS last_order,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	DATEDIFF(MONTH, MAX(order_date), GETDATE()) AS recency
FROM base_query
GROUP BY 
customer_id, customer_number, customer_name, country, marital_status,gender,age
) 

SELECT 
	customer_id,
	customer_number,
	customer_name,
	country,
	marital_status,
	gender,
	CASE 
        WHEN age > 20 THEN 'Below 20'
        WHEN age BETWEEN  20 AND 29 THEN '20-29'
		WHEN age BETWEEN  30 AND 39 THEN '30-39'
		WHEN age BETWEEN  40 AND 49 THEN '40-49'
        ELSE 'ABOVE 50'
    END AS age_group,
	CASE 
            WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment,
	recency,
	total_orders,
	total_products,
	total_sales,
	total_quantity,
	lifespan,
	CASE 
		WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_ordervalue,
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan
	END AS avg_monthly_spend
FROM aggregation_query;
