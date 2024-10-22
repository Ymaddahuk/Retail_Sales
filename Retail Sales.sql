-- SQL Retail Sales Analysis
create Schema Proj2;

use Proj2;

-- Create table

create table retail_sales 
(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
    gender varchar(10),
	age	int,
    category varchar(20),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
);

select * from retail_sales;



-- Data cleaning

delete from retail_sales
where transactions_id Is null
or
sale_date Is null
or
sale_time Is null
or
customer_id Is null
or
gender Is null
or
age Is null
or
category Is null
or
quantiy Is null
or
price_per_unit Is null
or
cogs Is null
or
total_sale Is null
;



-- Data Exploration

-- How many sales do we have?
Select count(*) as total_sale
from retail_sales;

-- How many customers do we have?
Select count(distinct customer_id) as total_cust
from retail_sales;

-- How many categories do we have?
Select distinct category as categories
from retail_sales;




-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS WITH ANSWERS

-- My Analysis and findings
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
select * 
from retail_sales
where sale_date = "2022-11-05";



-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select *
from retail_sales
where category = "Clothing" and date_format(sale_date, "%Y-%m") = "2022-11" and quantity >= 4
;



-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sale, count(*) as total_orders
from retail_sales
group by category;




-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, avg(age) as average_age
from retail_sales
where category = "Beauty";




-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales
where total_sale >= 1000 ;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(transactions_id) as total_transactions
from retail_sales 
group by category, gender;



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(
select 
	Extract(year from sale_date) as year, extract(month from sale_date) as month,  avg(total_sale) as avg_monthly_sales, 
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as ranking
from retail_sales 
group by month
) as t1
where ranking = 1;




-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select  customer_id, sum(total_sale) as total_sales
from retail_sales 
group by customer_id 
order by total_sales desc
limit 5
;



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as customers 
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales as
(
select *,
	case
    when extract(hour from sale_time) < 12 then "Morning"
    when extract(hour from sale_time) between 12 and 17 then "Afternoon"
    else "Evening"
    end as shift
from retail_sales
)
select shift, count(*) as total_orders from hourly_sales
group by shift;


-- End of Project