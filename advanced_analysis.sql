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

-- Run total of sales

WITH daily_sales AS 
	(
		Select
			Order_Date,
			SUM(Sales) AS daily_sales
		From  [dbo].[sales_operations_dataset]
		Group By	Order_Date
	)
Select	Order_Date,
			daily_sales,
			SUM(daily_sales)
			OVER(
				Order By order_date) AS running_total
From daily_sales;

-- Month - over- month sales change

WITH monthly_sales AS 
	(
		Select DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS sales_month,
					SUM(Sales) AS total_sales
		From [dbo].[sales_operations_dataset]
		Group By YEAR(Order_Date), MONTH(Order_Date)
	)
Select	sales_month,
			total_sales,
			LAG(total_sales)OVER(ORDER BY sales_month) AS previous_month,
			total_sales -
			LAG(total_sales) OVER(ORDER BY sales_month) AS monthly_change
From	monthly_sales

-- Highest Sales customer in each region

WITH customer_sales AS
	(
		Select	Region,
					Customer_Id,
					SUM(Sales) AS total_sales
		From	[dbo].[sales_operations_dataset]
		Group By Region, Customer_ID
	)
Select *
From	
	(
		Select *,
		ROW_NUMBER() OVER(PARTITION BY Region
		Order By total_sales DESC
	)  AS  rn
		From customer_sales) t
		Where	rn = 1;
	
 