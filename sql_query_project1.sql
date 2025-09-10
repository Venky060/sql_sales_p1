-- create Database sales_dbp1

Create database sales_dbp1;

-- create table

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM  retail_sales
LIMIT 10;

select COUNT(*) from retail_sales;

-- Data Cleaning 
select * from retail_sales
where transactions_id is null 
 or sale_date is null
 or  sale_time is null
 or gender is null
 or category is null
 or quantity is null
 or  cogs is null
 or total_sale is null;

DELETE FROM retail_sales 
where transactions_id is null 
 or sale_date is null
 or  sale_time is null
 or gender is null
 or category is null
 or quantity is null
 or  cogs is null
 or total_sale is null;

 -- Data Exploration
 -- How many sales we have?
 select count(*) from retail_sales;

 -- How many uniuque customers we have ?
  select count(DISTINCT(customer_id)) as unique_cust from retail_sales;

  -- Data Analysis & Business Key Problems & Answers

  -- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
   
   select * from retail_sales
   where sale_date = '2022-11-05';
   
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
   
   select * from retail_sales
   where category = 'Clothing' 
         and
         quantity >= 4 
		 and
		 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
		 
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

   select category,
   SUM(total_sale) as net_sales,
   count (*) as total_sales 
   FROM retail_sales
   GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

   select 
   ROUND(avg(age),2) as avg_age 
   FROM retail_sales
   where category = 'Beauty';
   
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

   SELECT * FROM retail_sales
   WHERE total_sale > 1000;
   
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

   SELECT 
   category,
   gender,
   COUNT(transactions_id) as total_trns
   FROM retail_sales
   GROUP BY gender,category
   order by category;
   
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select years,months,avg_sale FROM 
  (select 
  Extract(Year FROM sale_date) as years,
  Extract(Month FROM sale_date) as months,
  Round(avg(total_sale)) as avg_sale,
  RANK()OVER(partition by Extract(Year  FROM sale_date) order by Round(avg(total_sale)) desc ) as rn
  FROM retail_sales
  GROUP BY years,months) as t
  WHERE rn = 1
  order by 1,3;
  
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

   select 
   customer_id,
   sum(total_sale) as high_sale
   FROM retail_sales 
   group by customer_id
   ORDER BY high_sale DESC 
   LIMIT 5;
   
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

   select 
   category,
   count(DISTINCT(customer_id)) as no_unique
   FROM retail_sales
   GROUP BY category;
   
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
  with hourly_sale as 
  (select *,
   case
       when Extract(HOUR FROM sale_time) <= 12 then 'Morning'
	   when Extract(HOUR FROM sale_time) BETWEEN 12 AND 17 then 'Afternoon'
	   else 'Evening'
	   end as shift
	   FROM retail_sales)
	   select shift,
	   count(*) as orders from hourly_sale
	   GROUP BY shift;


-- END OF  PROJECT 
 