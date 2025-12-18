/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

--find the youngest & oldest customers based on birthdate
SELECT
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
	MAX(birthdate) AS latest_birthdate,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM [gold].[dim_customers];

-- find the newest & oldest start_date of product
SELECT
	MIN(start_date) AS oldest_startdate,
	MAX(start_date) AS latest_startdate
FROM [gold].[dim_products];


-- Determine the first and last order date and the total duration in months
SELECT
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS year_timespan,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS month_timespan
FROM [gold].[fact_sales];



