-- create table
DROP TABLE IF EXISTS RETAIL_SALAES;

CREATE TABLE RETAIL_SALES (
	TRANSACTION_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(10),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTITY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALES FLOAT
)
-- View Table
SELECT
	*
FROM
	RETAIL_SALES

	
-- Number Of Customers
SELECT
	COUNT(*)
FROM
	RETAIL_SALES

	
-- Data Clening

-- Check Data Is NULL
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTION_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALES IS NULL;

-- Delete NULL Data
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTION_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALES IS NULL;

-- Data Exploration
-- How many sales we have ? 
SELECT
	COUNT(TOTAL_SALES) AS TOTAL_SALES
FROM
	RETAIL_SALES
-- how many unique customer we have  ?
SELECT
	COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALES
FROM
	RETAIL_SALES
-- How many category we have  ?
SELECT DISTINCT
	CATEGORY
FROM
	RETAIL_SALES
	
-- Data Analysis & Business Key Problems & Answer

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
	
	
	
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05'

	
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTITY >= 4

	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	CATEGORY,
	SUM(TOTAL_SALES) AS NET_SALE,
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY

	
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	AVG(AGE) AS AVERAGE_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty'

	
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALES > 1000;

	
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	CATEGORY,
	GENDER,
	COUNT(TRANSACTION_ID) AS TOTAL_ORDERS
FROM
	RETAIL_SALES
GROUP BY
	1,
	2
ORDER BY
	1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
	MONTH,
	YEAR,
	AVG_SALE
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			AVG(TOTAL_SALES) AS AVG_SALE,
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						YEAR
						FROM
							SALE_DATE
					)
				ORDER BY
					AVG(TOTAL_SALES) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			1,
			2
	) AS T1
WHERE
	RANK = 1

	
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALES) AS TOTAL_SALES
FROM
	RETAIL_SALES
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5

	
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS CNT_UNIQUE_CS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY

	
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH
	HOURLY_SALE AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) < 12 THEN 'Morning'
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'Evening'
			END AS SHIFT
		FROM
			RETAIL_SALES
	)
SELECT
	SHIFT,
	COUNT(*) AS TOTAL_ORDERS
FROM
	HOURLY_SALE
GROUP BY
	SHIFT
	
	
-- END OF PROJECT