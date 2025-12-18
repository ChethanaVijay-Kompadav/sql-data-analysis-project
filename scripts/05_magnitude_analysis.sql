/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/


--SELECT TOP 5 * FROM [gold].[dim_customers];
--SELECT TOP 5 * FROM [gold].[dim_products];
--SELECT TOP 5 * FROM [gold].[fact_sales];

--Find the Total Number of Customers by country & gender
SELECT
	country,
	gender,
	COUNT(customer_key) as total_customers
FROM [gold].[dim_customers]
GROUP BY country,gender
ORDER BY 3 DESC;

--Find the Total Number of Products by category & subcategory
SELECT
	category,
	subcategory,
	COUNT(product_key) as total_products
FROM [gold].[dim_products]
GROUP BY category,subcategory
ORDER BY 3 DESC;

--What is the average cost in each category?
SELECT 
	category,
	AVG(cost) AS average_cost
FROM  [gold].[dim_products]
GROUP BY category
ORDER BY 2 DESC;
	
--What is the total revenue generated for each category?
SELECT 
	p.category,
	sum(f.sales_amount) AS total_revenue
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


--What is the distribution of sold items across countries?
SELECT 
	c.country,
	sum(f.quantity) AS total_items_sold
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_customers] c
ON f.customer_id= c.customer_key
GROUP BY country
ORDER BY 2 DESC;
	