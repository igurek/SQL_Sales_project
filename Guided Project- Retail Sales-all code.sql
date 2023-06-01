-- PART 1: SQL BASICS

USE retail_sales;

-- first look at the data
-- 1) SELECT: return all rows
SELECT 
    *
FROM
    retail_sales;
    
-- 2) SELECT DISTINCT: unique values: kind of business
SELECT DISTINCT
    kind_of_business
FROM
    retail_sales;

-- unqiue values: industry
SELECT DISTINCT
    industry
FROM
    retail_sales;
     
-- 3) WHERE equal: return sales for the year 2022
SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    year = 2022;
    
-- 4) WHERE not equal: return every sales except the industry general merchandise

SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    industry != 'General Merchandise';
    
-- OR

SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    industry <> 'General Merchandise';
    
-- 5) WHERE <, >, <=, >=: 

SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    sales > 100000;
    
-- 6) WHERE ... AND ...:
SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    month =1 AND year = 2022;



    
-- 7) WHERE ... OR ...

SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    industry = 'General Merchandise' OR industry = 'Miscellaneous';
    
    
-- 8) WHERE ... IN:
SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    year IN (2022,2021,2020);
    
-- NOT IN

SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE
    year NOT IN (2022,2021,2020);
    
-- 9) WHERE ... LIKE: % and _:

SELECT 
    month, year, kind_of_business, industry, sales
FROM
    retail_sales
WHERE kind_of_business LIKE "a%";


SELECT DISTINCT industry
FROM
    retail_sales
WHERE industry LIKE "%home%";

-- 10) WHERE ... NULL:
SELECT 
    *
FROM
    retail_sales
WHERE
    sales IS NULL;

-- where ...  is not null

SELECT 
    *
FROM
    retail_sales
WHERE
    sales IS NOT NULL;


-- 11) ORDER BY:

SELECT 
    *
FROM
    retail_sales
ORDER BY sales DESC;

-- Which business kind had the highest sale in January 2022?

SELECT 
    *
FROM
    retail_sales
WHERE
    month = 1 AND year = 2022
ORDER BY sales DESC;
    
-- Which business kind had the lowest sale of all time?
SELECT 
    *
FROM
    retail_sales
ORDER BY sales ASC;

-- exclude null
SELECT 
    *
FROM
    retail_sales
WHERE
    sales IS NOT NULL
ORDER BY sales ASC;

-- PART 2: SQL AGGREGATION

-- 12) COUNT:

SELECT 
    COUNT(*)
FROM
    retail_sales;
    
-- count a column with null
SELECT 
    COUNT(sales)
FROM
    retail_sales;
    
-- count(distinct ...):

SELECT 
    COUNT(DISTINCT industry)
FROM
    retail_sales;
    
    
    
-- 13) sum, avg, max and min

-- What were the total sales, in dollars, of used car dealers in January 2022?
SELECT 
    SUM(sales)
FROM
    retail_sales
WHERE
    month = 1 AND year = 2022
        AND kind_of_business LIKE 'used car%';
        
-- What was the average sale in January 2022 of all data?

SELECT 
    AVG(sales)
FROM
    retail_sales
WHERE
    month = 1 AND year = 2022;

-- change the column name

SELECT 
    AVG(sales) AS average_sale
FROM
    retail_sales
WHERE
    month = 1 AND year = 2022;
    
    
    -- What is the minimum sale amount in the Automotive industry in March 2020?
SELECT 
    MIN(sales) AS min_sales
FROM
    retail_sales
WHERE
    month = 3 AND year = 2020
        AND industry LIKE 'Automotive%';


SELECT 
    *
FROM
    retail_sales
WHERE
    month = 3 AND year = 2020
        AND industry LIKE 'Automotive%'
ORDER BY sales ASC;

-- What is the maximum sale amount in the automotive industry in March 2020?
SELECT 
    MAX(sales) AS max_sales
FROM
    retail_sales
WHERE
    month = 3 AND year = 2020
        AND industry LIKE 'Automotive%';


-- 14) GROUP BY:

-- What was the max sale by industry in march 2020?
SELECT industry, MAX(sales) AS max_sales
FROM
    retail_sales
WHERE
    month = 3 AND year = 2020
GROUP BY industry;


-- order by sales desc

SELECT industry, MAX(sales) AS max_sales
FROM
    retail_sales
WHERE
    month = 3 AND year = 2020
GROUP BY industry
ORDER BY max_sales DESC;

-- average sale by industry:

SELECT industry, AVG(sales) AS avg_sales
FROM
    retail_sales
WHERE
    month = 3 AND year = 2020
GROUP BY industry
ORDER BY avg_sales DESC;


-- What is the all-time average sale by businesses?
SELECT 
    kind_of_business, AVG(sales) AS avg_sales
FROM
    retail_sales
GROUP BY kind_of_business
ORDER BY avg_sales DESC;

-- 15) HAVING:

-- Which businesses’ all-time average sale was above 10 billion dollars?
SELECT 
    kind_of_business, AVG(sales) AS avg_sales
FROM
    retail_sales
GROUP BY kind_of_business
HAVING avg_sales > 10000
ORDER BY avg_sales DESC;


-- PART 3: SQL ANALYSIS:
-- 1) Which industry had the highest sales revenue for 2022?

-- To answer this question, 
-- 1) we need to find the total sales grouped by industry. 
-- 2) We also need to filter year to 2022 since the question is asking about 2022 only. 
-- 3) We need to order by the sum of sales in descending order to easily see the highest sales on top:

SELECT 
    industry, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    year = 2022
GROUP BY industry
ORDER BY sum_sales DESC;


-- auto industry consists of 5 businesses
SELECT DISTINCT
    kind_of_business
FROM
    retail_sales
WHERE
    industry LIKE '%auto%';
    
-- office supplies and gifts industry consists of 
SELECT DISTINCT
    kind_of_business
FROM
    retail_sales
WHERE
    industry LIKE '%office supplies%';

-- 2) Which kind of businesses within the automotive industry had the highest sales revenue for 2022?

-- To answer this question:
-- 1) we need to find the total sales grouped by kind of business
-- 2) we need to filter the year to 2022 and the industry to automotive.


SELECT 
    kind_of_business, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    year = 2022
        AND industry = 'automotive'
GROUP BY kind_of_business
ORDER BY sum_sales DESC;

-- 3) What is the contribution percentage of each business in the automotive industry this year?

-- To answer this question: 
-- We need the total overall sales for the auto industry in the year 2022
-- We need to find the percentage sales by kind of business:
		-- We are going to calculate the percentage sales by dividing the total sales by kind of business to the total overall sales we find in the first part.
        
-- total sales by the automotive industry:

SELECT 
    SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    year = 2022 AND industry = 'Automotive'
GROUP BY industry
ORDER BY sum_sales DESC;


-- percentage contribution

SELECT 
    kind_of_business, SUM(sales)/5624234*100 as percent_sale
FROM
    retail_sales
WHERE
    year = 2022
        AND industry = 'automotive'
GROUP BY kind_of_business
ORDER BY percent_sale DESC;

-- with a subquery:

SELECT 
    kind_of_business,
    SUM(sales) / (SELECT 
            SUM(sales) sum_sales
        FROM
            retail_sales
        WHERE
            year = 2022 AND industry = 'Automotive'
        GROUP BY industry) * 100 AS percent_sale
FROM
    retail_sales
WHERE
    year = 2022 AND industry = 'automotive'
GROUP BY kind_of_business
ORDER BY percent_sale DESC;


-- 4) How has the sales revenue changed over time for the Motor vehicle and parts dealers?

-- To answer this question:
-- First, we need the total sales grouped by year
-- Second, we need to filter data so that the kind of business equals motor vehicle and parts dealers:

SELECT 
    year, SUM(sales) AS sum_sales
FROM
    retail_sales
WHERE
    kind_of_business = 'Motor vehicle and parts dealers'
GROUP BY 1
ORDER BY 2 DESC;

-- 5) How much did Motor Vehicles and Parts Dealers experience a month-over-month growth rate in 2020?
-- To answer this question:
-- Select the previous month and current month by using self-join. 
-- We need to filter this table to the year 2022 and the kind of business to motor vehicle and parts dealers
-- Calculate the growth rate using the formula (current - previous)/previous *100:



SELECT 
    curr.month AS current_month, 
    previous.month AS prev_month
FROM retail_sales AS curr
JOIN retail_sales AS previous 
    ON curr.month = previous.month + 1
    AND curr.year = previous.year
    AND curr.kind_of_business = previous.kind_of_business
WHERE
    curr.year = 2020 AND curr.kind_of_business = 'Motor vehicle and parts dealers';
    
    
-- growth rate

SELECT 
    curr.month AS current_month, 
    previous.month AS prev_month,
    (curr.sales - previous.sales) / previous.sales * 100 as mom
FROM
    retail_sales AS curr
        JOIN
    retail_sales AS previous 
    ON curr.month = previous.month + 1
    AND curr.year = previous.year
    AND curr.kind_of_business = previous.kind_of_business
WHERE
    curr.year = 2020 AND curr.kind_of_business = 'Motor vehicle and parts dealers';
    


-- 6) Which businesses have the highest total sales revenue for the Food & Beverage industry for each year?

-- To answer this question,
-- we first need to find the yearly total sales of each business in the Food & Beverage industry. 
	-- Total sales grouped by kind_of_business and year
	-- Filter data so that industry = ‘Food & Beverage’

-- Next, we need to get the maximum total sale for each year for each business within the Food and beverage industry
	-- Maximum of total sales grouped by year
	-- And kind_of_business that this maximum of total sales belongs to.


-- yearly total sales of each business in the industry
SELECT 
    kind_of_business, year, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    industry = 'Food & Beverage'
GROUP BY 1 , 2;

-- CTE
WITH total_sales AS(

SELECT 
    kind_of_business, year, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    industry = 'Food & Beverage'
GROUP BY 1 , 2

)

-- this is where we select the maximum sales
SELECT 
    year, MAX(sum_sales)
FROM
    total_sales
GROUP BY 1;



-- not correct:
WITH total_sales AS(

SELECT 
    kind_of_business, year, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    industry = 'Food & Beverage'
GROUP BY 1 , 2

)


SELECT 
    kind_of_business, year, MAX(sum_sales)
FROM
    total_sales
GROUP BY 1;




-- not correct


WITH total_sales AS(

SELECT 
    kind_of_business, year, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    industry = 'Food & Beverage'
GROUP BY 1 , 2

)


SELECT 
    kind_of_business, year, MAX(sum_sales)
FROM
    total_sales
GROUP BY 1, 2;



-- 2 CTEs


WITH total_sales AS(

SELECT 
    kind_of_business, year, SUM(sales) sum_sales
FROM
    retail_sales
WHERE
    industry = 'Food & Beverage'
GROUP BY 1 , 2

), 

top_sales AS( 

SELECT 
   year, MAX(sum_sales) as max_sales
FROM
    total_sales
GROUP BY 1

)

-- we need the year and kind of business from the first cte and the max_sales from the second cte
select cte1.year, 
	cte1.kind_of_business,
    max_sales 
from top_sales as cte2
join total_sales as cte1 
on cte1.sum_sales = cte2.max_sales
		and cte1.year = cte2.year 

;


-- all business in the industry
SELECT 
    distinct kind_of_business, naics_code
FROM
    retail_sales
WHERE
    industry = 'Food & Beverage';


-- 7) What is the revenue change in percentage for each industry from 2019 to 2020?

-- To answer this question,
-- first, we need the sum of sales for each industry for 2019 as the previous year and 2020 as the current year. 
	-- 	We need sum of sales grouped by industry for the year of 2019. This will be the previous year total sales
	-- We need the sum of sales grouped by industry for the year 2020. This will be the current industry 
-- Second, after having both previous and current year sales, we can calculate the growth rate with (current - previous)/previous multiplied by 100. 
	-- Create a CTE for sales in 2019 and create another CTE for sales in 2020
	-- Join these two CTEs to get the current and previous year sales



-- the sum of sales by industry in 2019
SELECT 
    industry, SUM(sales) AS sum_sales
FROM
    retail_sales
WHERE
    year = 2019
GROUP BY 1;



-- the sum of sales by industry in 2020
SELECT 
    industry, SUM(sales) AS sum_sales
FROM
    retail_sales
WHERE
    year = 2020
GROUP BY 1;



-- CTEs
WITH sales_2019 AS(SELECT 
    industry, SUM(sales) AS sum_sales_2019
FROM
    retail_sales
WHERE
    year = 2019
GROUP BY 1),

sales_2020 AS(SELECT 
    industry, SUM(sales) AS sum_sales_2020
FROM
    retail_sales
WHERE
    year = 2020
GROUP BY 1)

SELECT 
    cte1.industry,
    (sum_sales_2020 - sum_sales_2019) / sum_sales_2019 * 100 AS growth_rate
FROM
    sales_2019 AS cte1
JOIN
    sales_2020 AS cte2 ON cte1.industry = cte2.industry
ORDER BY growth_rate desc;
	

-- kind of business check
SELECT DISTINCT
    kind_of_business, naics_code
FROM
    retail_sales
WHERE
    industry = 'Miscellaneous';
    
    
SELECT DISTINCT
    kind_of_business, naics_code
FROM
    retail_sales
WHERE
    industry like 'sports%';

    

    
-- contribution percentage:
SELECT 
    kind_of_business,
    SUM(sales) / (SELECT 
            SUM(sales) sum_sales
        FROM
            retail_sales
        WHERE
            year = 2020 AND industry = 'Miscellaneous'
        GROUP BY industry) * 100 AS percent_sale
FROM
    retail_sales
WHERE
    year = 2020
 AND industry = 'Miscellaneous'
GROUP BY kind_of_business
ORDER BY percent_sale DESC;



-- 8) What are the year-over-year growth rates for each industry per year?
-- To answer this question:
-- First, we need the sum of sales by year and the industry.
-- Second, we can use this above query as a temporary table. 
	-- we can do a self-join, so we can have the current year and the previous year together as we did in question 5.


-- sum of sales by year and industry
SELECT 
    year, industry, SUM(sales) AS sum_sales
FROM
    retail_sales
GROUP BY 1, 2;


-- cte and self join
with total_sales as(
SELECT 
    year, industry, SUM(sales) AS sum_sales
FROM
    retail_sales
GROUP BY 1, 2)

SELECT curr.industry,
	previous.year as prev_year, 
    curr.year as current_year,
	(curr.sum_sales - previous.sum_sales) / previous.sum_sales *100 as yoy
from total_sales as curr
join total_sales as previous 
	on curr.year = previous.year + 1
    and curr.industry = previous.industry			
order by industry, curr.year desc;





-- 9) What are the yearly total sales for women’s clothing stores and men’s clothing stores?
-- Write a case statement to return both total sales in the same table


SELECT 
    year,
    SUM(CASE WHEN kind_of_business = 'Women\'s clothing stores' THEN sales
    END) AS womens_sales,
    SUM(CASE WHEN kind_of_business = 'Men\'s clothing stores' THEN sales
    END) AS mens_sales
FROM
    retail_sales
GROUP BY 1
;

-- 10) What is the yearly ratio of total sales for women's clothing stores to total sales for men's clothing stores?

-- To answer this question, 
-- we can use our above query as our table with a subquery, 
-- and from that table, we can select womens_sales divided by mens_sales to find the ratio. 


-- subquery:

SELECT 
    year,
    SUM(CASE WHEN kind_of_business = 'Women\'s clothing stores' THEN sales
    END) AS womens_sales,
    SUM(CASE WHEN kind_of_business = 'Men\'s clothing stores' THEN sales
    END) AS mens_sales
FROM
    retail_sales

GROUP BY 1;


-- main query:

SELECT 
    year, womens_sales / mens_sales AS women_to_men_ratio
FROM
    (SELECT 
        year,
            SUM(CASE WHEN kind_of_business = 'Women\'s clothing stores' THEN sales
            END) AS womens_sales,
            SUM(CASE WHEN kind_of_business = 'Men\'s clothing stores' THEN sales
            END) AS mens_sales
    FROM
        retail_sales
    GROUP BY 1) AS sale;

-- 11) What is the year-to-date total sale of each month for 2019, 2020, 2021, and 2022 for the women’s clothing stores?

-- to answer this question, we are going to use window functions

Select month, year, sales,
sum(sales) over(partition by year order by month) as ytd_sales
from retail_sales
where kind_of_business = 'Women\'s clothing stores' and year in (2019,2020,2021,2022)
order by year desc, month asc;

-- with a subquery
SELECT rs.month, rs.year, rs.sales, 
       (SELECT SUM(sales) 
        FROM retail_sales rs2 
        WHERE rs2.year = rs.year AND rs2.month <= rs.month AND rs2.kind_of_business = 'Women\'s clothing stores') AS ytd_sales
FROM retail_sales rs
WHERE rs.kind_of_business = 'Women\'s clothing stores' AND rs.year IN (2019, 2020, 2021, 2022);


-- 12) What is the month-over-month growth rate of women’s clothing businesses in 2022?

-- To answer this question
-- We need the current month sales and previous month sales to calculate mom growth rate.
-- The final table returns the month, current monthly sale, which are already available in the data 
-- and it returns the growth rate, which is current - previous/previous. 
	-- We can calculate the previous month's sales with a window function using the LAG() function instead of SUM(). 
    -- The lag function returns the previous value



select month, sales as current_sales, -- now we want the sales from 1 previous period
lag(sales, 1) over (order by month) as prev_sales
from retail_sales
where kind_of_business ='Women\'s clothing stores' and year =2022;


-- growth rate
select month, sales as current_sales,
lag(sales, 1) over (order by month) as prev_sales,
(sales - lag(sales, 1) over (order by month))/lag(sales, 1) over (order by month) *100 as growth_rate
from retail_sales
where kind_of_business ='Women\'s clothing stores' and year =2022;
