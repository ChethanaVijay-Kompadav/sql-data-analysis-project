
/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


--SELECT TOP 5 * FROM [gold].[dim_customers];
--SELECT TOP 5 * FROM [gold].[dim_products];
--SELECT TOP 5 * FROM [gold].[fact_sales];

-- Which 5 products Generating the Highest Revenue?
--simple ranking
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS Total_sales
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON F.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_sales DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT * FROM (
SELECT
p.product_name,
SUM(f.sales_amount) AS Total_sales,
RANK()OVER(ORDER BY SUM(f.sales_amount) DESC) AS product_rank
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON F.product_key = p.product_key
GROUP BY p.product_name)t
WHERE product_rank <=5;

-- What are the worst performing products in terms of sales
--simple ranking
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS Total_sales
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON F.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_sales ASC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT * FROM(
SELECT
p.product_name,
SUM(f.sales_amount) AS Total_sales,
ROW_NUMBER()OVER(ORDER BY SUM(f.sales_amount)) AS product_rank
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON F.product_key = p.product_key
GROUP BY p.product_name)t
WHERE product_rank <=5;

-- Find the top 10 Customers who have generated highest Revenue
--simple ranking
SELECT top 10
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS revenue
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id = c.customer_key
GROUP BY 
	c.customer_id, c.first_name, c.last_name
ORDER BY revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT * FROM(
SELECT
c.customer_id,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS revenue,
ROW_NUMBER()OVER(ORDER BY SUM(f.sales_amount) DESC) AS customer_rank
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id = c.customer_key
GROUP BY 
	c.customer_id, c.first_name, c.last_name)T
WHERE customer_rank <=10;

-- Find the top 3 Customers with fewest orders
--simple ranking
SELECT top 3
	c.customer_id,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) AS orders
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id = c.customer_key
GROUP BY 
	c.customer_id, c.first_name, c.last_name
ORDER BY orders;

-- Complex but Flexibly Ranking Using Window Functions
SELECT * FROM(
SELECT
c.customer_id,
c.first_name,
c.last_name,
COUNT(DISTINCT f.order_number) AS orders,
ROW_NUMBER()OVER(ORDER BY COUNT(DISTINCT f.order_number) ASC) AS order_rank
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id = c.customer_key
GROUP BY 
	c.customer_id, c.first_name, c.last_name)T
WHERE order_rank <=3;

