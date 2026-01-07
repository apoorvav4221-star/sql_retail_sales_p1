-- SQL Retail Sales Analysis - P1

CREATE TABLE retail_sales
	(transactions_id int,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender	varchar(10),
	age	int,
	category	varchar(15),
	quantiy	int,
	price_per_unit	float,
	cogs	float,
	total_sale	float
	);

SELECT * FROM retail_sales;

SELECT
	COUNT(*)
FROM retail_sales;

--Data Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

ALTER TABLE retail_sales
RENAME COLUMN quantiy to quantity;

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_date IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales 
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_date IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


-- Data Exploration

--Q. how many sales we have

SELECT count(*) FROM retail_sales;

-- Q. How many unique customer we have 

SELECT COUNT(DISTINCT(customer_id)) AS total_sale FROM retail_sales; 

-- Q. How many unique customer we have 

SELECT DISTINCT category AS total_sale FROM retail_sales; 

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales
	WHERE category = 'Clothing' 
	and 
	quantity >= 4 
	and
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
	category, 
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_sale_order
FROM retail_sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT ROUND(AVG(age),2) AS Average_age
FROM retail_sales
where category = 'Beauty'

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
	category, 
	gender, 
	COUNT(*) 
FROM retail_sales 
GROUP BY 
	category, 
	gender 
ORDER BY 1;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
	customer_id,
	sum(total_sale)as total__sale
FROM retail_sales
group by 1
ORDER BY 2 desc
LIMIT 5

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
	COUNT(DISTINCT customer_id) AS unique_customer,
	category
FROM retail_sales
group by 2

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'morning_shift'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'afternoon_shift'
		ELSE 'evening_shift'
	END as shift
FROM retail_sales)
	select shift,
	count(*) as total_order
from hourly_sale
group by shift;

-- End of project 