/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time

-- total_sales with daywise granularity
SELECT 
order_date,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_number) AS total_orders
FROM [gold].[fact_sales]
GROUP BY order_date
ORDER BY order_date;

-- total_sales with MONTH granularity
-- Quick Date Functions
SELECT 
MONTH(order_date) AS order_date,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_number) AS total_orders
FROM [gold].[fact_sales]
WHERE MONTH(order_date) IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_date;

-- total_sales with year granularity
-- Quick Date Functions
SELECT 
YEAR(order_date) AS order_date,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_number) AS total_orders
FROM [gold].[fact_sales]
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_date;


-- total_sales with year & MONTH granularity
-- Quick Date Functions
SELECT 
YEAR(order_date) AS order_date_year,
MONTH(order_date) AS order_date_month,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_number) AS total_orders
FROM [gold].[fact_sales]
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_date_year, order_date_month;

-- total_sales with year & MONTH with DATETRUNC
SELECT 
DATETRUNC(MONTH, order_date) AS order_date,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_number) AS total_orders
FROM [gold].[fact_sales]
WHERE DATETRUNC(MONTH, order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY order_date;

-- total_sales with year & MONTH with FORMAT
SELECT 
FORMAT(order_date, 'yyyy-MMM') AS order_date,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_number) AS total_orders
FROM [gold].[fact_sales]
WHERE FORMAT(order_date, 'yyyy-MMM') IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM') 
ORDER BY order_date;