-- SQL Retail Sales Analysis -  P1


DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales
limit 5


select 
	count(*)
from retail_sales

-- Dta Cleaning --
select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- deleting null values --

delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null


-- Data Exploration --

-- Business key questions and answers -- 
-- 1. How many sale do we have --

select count(*) as total_sale from retail_sales

-- 2. How many unique customers do we have --

select count(distinct customer_id) as total_sale from retail_sales


select count(distinct category) as total_sale from retail_sales
select distinct category as total_sale from retail_sales

-- Data Analysis --

-- 1. Write a SQL Query to review all columns for sales made on "2022-11-05"
-- 2. Write a SQL query to retrieve all transactions where the category is "clothing" and the 
-- quantity sold is equal to or more than 4 in November 
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category
-- 4. Write a SQL query to find the average age of customers who purchased items 
-- from the 'Beauty' category
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- 6. Write a SQL query to find the total number of transaction (transaction_id) made by each 
-- gender in each year
-- 7. Write a SQL query to calculate the average sales for each month. Find out the best selling 
-- month in each year
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon 
-- between 12 & 17, Evening >17)


-- 1. Write a SQL Query to review all colunms for sales made on "2022-11-05"
select *
from retail_sales
where sale_date = '2022-11-05'

-- 2. Write a SQl query to retrive all transactions where the category is "Clothing" and the 
-- quantity sold is more than 10 in the month of November

select 
	category,
	SUM(quantity)
FROM retail_sales
where category = 'Clothing'
group by category

select *
from retail_sales
where category = 'Clothing'
	and 
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and 
	quantity >= 4;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category

select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by category;


-- 4. Write a SQL query to find the average age of customers who purchased items 
-- from the 'Beauty' category

select * from retail_sales

select 
	category,
	avg(age),
	round(avg(age)) as avg_age,
	round(avg(age), 2) as avg_age_to_2d
from retail_sales
where category = 'Beauty'
group by 1;


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * 
from retail_sales
where total_sale > 1000

-- Method 2 --

select 
	transactions_id,
	sum(total_sale) as sum_total_sales
from retail_sales
where total_sale > 1000
group by 1;


-- 6. Write a SQL query to find the total number of transaction (transactions_id) made by each 
-- gender in each year

select * from retail_sales

select
	category,
	gender,
	count(transactions_id) as number_of_transactions
from retail_sales
group by 
	category,gender
order by category


-- 7. Write a SQL query to calculate the average sales for each month. Find out the best selling 
-- month in each year

select * from retail_sales

select 
	extract(year from sale_date) as Year,
	extract(month from sale_date) as Month,
	avg(total_sale) as avg_sales
from retail_sales
group by 1, 2
order by 1, 3 DESC;

-- let's find the best selling month in each year using the RANK function.

select * from
(
	SELECT  
		EXTRACT(YEAR FROM sale_date) AS Year,
		EXTRACT(MONTH FROM sale_date) AS Month,
		AVG(total_sale) AS avg_sales,
		rank() over (partition by EXTRACT(YEAR FROM sale_date) order by AVG(total_sale) desc) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as t1
where rank = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales

select * from retail_sales

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
ORDER BY 2 DESC
limit 5


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category

select * from retail_sales

select 
	category,
	count(distinct customer_id) as count_of_unique_customers
from retail_sales
group by 1


-- 10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon 
-- between 12 & 17, Evening >17)

select * from retail_sales

select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
	end as shift
from retail_sales

-- note that we cannot use the group by function on the query above because it will be 
-- a little bit completed. so I'm going to save this in a CTE(Common Table Expression) 


with hourly_sales
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select * from hourly_sales

-- Note that if you run the code above, it will give you the same result as the 
-- normal select case statement


with hourly_sales
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sales
group by shift

----- END OF PROJECT -----
	



