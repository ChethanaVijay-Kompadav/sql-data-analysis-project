--Which categories contribute the most to overall sales
/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

WITH CTE AS 
(SELECT 
	p.category,
	SUM(f.sales_amount) AS total_sales
	--SUM(f.sales_amount) OVER(PARTITION BY p.category) AS overall_sales
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON f.product_key = p.product_key
GROUP BY p.category)

SELECT 
category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100,2), '%') AS pct_sales
FROM CTE
ORDER BY pct_sales DESC;



