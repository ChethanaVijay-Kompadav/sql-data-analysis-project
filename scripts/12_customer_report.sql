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

--SELECT * FROM [gold].[fact_sales];
--SELECT * FROM [gold].[dim_customers];


WITH base_query AS(
SELECT 
	f.order_number,
	f.order_date,
	f.sales_amount,
	f.quantity,
	f.price,
	c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	c.country,
	c.marital_status,
	c.gender,
	c.birthdate
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id = c.customer_key
WHERE F.order_date IS NOT NULL),
aggregation_query AS(

SELECT 
	COUNT(order_number) as total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quan
FROM base_query


	)