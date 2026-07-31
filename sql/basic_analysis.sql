CREATE DATABASE SalesOperationsPortfolio;
GO

USE SalesOperationsPortfolio;
GO
Select TOP 10 *
From [dbo].[sales_operations_dataset]

Select COUNT (*)
From	[dbo].[sales_operations_dataset]

-- Total Sales and Profit
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit
FROM [dbo].[sales_operations_dataset]

-- Sales by Region

Select Region,
			ROUND(SUM(sales), 2) AS total_sales,
			ROUND(SUM(profit), 2) AS total_profit
From	 [dbo].[sales_operations_dataset]
Group by Region
Order by total_sales DESC;

-- Sales by Category

Select	Category,
			ROUND(SUM(sales), 2) AS total_sales,
			ROUND(SUM(profit), 2) AS total_profit
From	[dbo].[sales_operations_dataset]
Group by Category
Order By total_sales DESC;

-- Top five products

Select	 TOP 5 Product,
			 ROUND(SUM(sales), 2) AS total_sales,
			 SUM(Quantity) AS units_sold
From	[dbo].[sales_operations_dataset]
Group By Product
Order by total_sales DESC;

-- Repeat Customers

Select customer_id,
			COUNT (*) AS order_count,
			ROUND(SUM(sales), 2) AS total_customer_sales
FROM	[dbo].[sales_operations_dataset]
Group By customer_id
Having Count (*) > 1
Order By order_count DESC, total_customer_sales DESC;

-- Monthly Sales Trend

Select YEAR(Order_Date) AS order_year,
			MONTH(Order_Date) AS  order_month,
			ROUND(SUM(Sales), 2) AS monthly_sales,
			ROUND(SUM(profit), 2)  AS monthly_profit
From	[dbo].[sales_operations_dataset]
Group By YEAR(Order_Date), MONTH(Order_Date)
Order By	order_year, order_month;

-- Product ranking using a window function

WITH product_sales AS 
	(
		Select
			category,
			product,
			SUM(sales) AS total_sales
		From	[dbo].[sales_operations_dataset]
		Group By	Category,  Product
	)
Select Category, 
			Product,
			ROUND(total_sales, 2) AS total_sales,
			RANK() OVER (PARTITION BY Category
			Order By total_sales DESC) AS product_rank
FROM	product_sales
Order By Category, product_rank;



