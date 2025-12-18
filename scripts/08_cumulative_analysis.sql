/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

--SELECT * FROM [gold].[fact_sales];

-- Calculate the total sales per DAY
-- and the running total of sales over time 
SELECT 
	order_date,
	total_sales,
	SUM(total_sales)OVER(ORDER BY order_date) AS cumulative_sales
FROM(
	SELECT
		order_date,
		SUM(sales_amount) AS total_sales -- row wise total sales
	FROM [gold].[fact_sales]
	WHERE order_date IS NOT NULL
	GROUP BY order_date
	)T
ORDER BY order_date
	;

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT 
	order_date,
	total_sales,
	SUM(total_sales)OVER(ORDER BY order_date) AS cumulative_sales, -- cumulative sales upto current row by month
	avg_price,
	AVG(avg_price)OVER(ORDER BY order_date) AS running_averageprice -- cumulative sales upto current row by month
FROM(
	SELECT
		DATETRUNC(MONTH,order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price-- row wise total sales
	FROM [gold].[fact_sales]
	WHERE DATETRUNC(MONTH,order_date) IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)
	)T
ORDER BY order_date;