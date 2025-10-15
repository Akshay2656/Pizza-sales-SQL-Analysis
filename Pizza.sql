create database pizza;

use pizza;

-- 1. Show all the columns from the pizza table 

select * from pizza_sales;

-- 2. Retrive only the pizza names and their prices 

select pizza_name , total_price 
from pizza_sales;

select pizza_name, 
	ROUND(SUM(total_price), 1) as full_price 
from pizza_sales
group by pizza_name 
order by full_price desc;

-- 3 list top 5 most expensive pizza's

select 
pizza_name , total_price
from pizza_sales
order by total_price desc
limit 5;

-- 4. categories of pizza 
select DISTINCT pizza_category
from pizza_sales;

-- 5 types of pizzas avail

select count(distinct pizza_size) as pizza_type
from pizza_sales;

-- 6 Sorting the veg and non veg pizza 

 select pizza_name, pizza_category , total_price 
 from pizza_sales
 order by pizza_category;
 
 select pizza_name ,
	case 
		when pizza_name like "chicken" then 'Chicken'
        else 'veggie' 
	end as pizza_category,
    total_price
from pizza_sales
order by pizza_category desc;


-- 6. calculate total revenue from all pizza sales.

select pizza_name, pizza_category, 
	SUM(total_price) as total_revenue
from pizza_sales
group by pizza_name, pizza_category
order by total_revenue desc;


-- 7 average pizza price by pizza category 

select pizza_category, ROUND(AVG(total_price),2) as avg_price
from pizza_sales
group by pizza_category
order by avg_price;


-- 8 find the total quantity sold.alter

select count(*) as total_pizza_sold 
from pizza_sales;

-- 9 calculate total sales by pizza size

select pizza_size, round(sum(total_price),0) as total_revenue
from pizza_sales 
group by pizza_size 
order by total_revenue desc;

-- 10. display total sales by month

select 
	 MONTHNAME(order_date) as month_name,
     MONTH(order_date) as month_number,
     sum(total_price) as total_sales
	from pizza_sales
group by MONTHNAME(order_date), MONTH(order_date)
order by month_number desc;

-- 10 . find the category that generated the most revenue

select 
pizza_category, round(SUM(total_price), 2) as total_revenue
from pizza_sales 
group by pizza_category
order by total_revenue desc
limit 1;


-- 11. find the number of orders per day

select order_date,
		COUNT(DISTINCT order_id) AS number_of_orders 
from pizza_sales
group by order_date
order by order_date;

-- 12. find the pizzas that generated revenue more than 30000

select 
	pizza_name, 
    pizza_category,
    ROUND(SUM(total_price),1) as Total_revenue 
from pizza_sales
group by pizza_name, pizza_category
having sum(total_price) > 30000;


-- 13 Use a CTE to find the total sales and revenue for each pizza 

with cte as(
select 
	pizza_name,
    SUM(quantity) as total_sales,
    ROUND(SUM(total_price),1) as total_revenue
from pizza_sales
group by pizza_name
)
select 
	pizza_name,
    total_sales,
    total_revenue
from cte;


-- 14. find the highest and lowest prices pizzas in each category

with cte_high as (
select 
	pizza_category,
    Round(SUM(total_price),2) as Total_revenue,
    ROW_NUMBER() over (order by sum(total_price) desc) as rankhigh
from pizza_sales
group by pizza_category
),
cte_low as (
select 
	pizza_category,
    ROUND(SUM(total_price),2) as total_revenue,
    ROW_NUMBER() over (order by SUM(total_price) asc) as ranklow
from pizza_sales
group by pizza_category
)
select 
	h.pizza_category AS category_high,
    h.total_revenue as revenue_high,
    l.pizza_category as category_low,
    l.total_revenue as revenue_low
from cte_high h
JOIN cte_low l
ON h.rankhigh = l.ranklow;


-- 15 Find the top 3 pizzas per category using rank() function

with rnk_pizza as (
select 
pizza_name,
pizza_category,
ROUND(sum(total_price),1) as total_revenue,
RANK() over (partition by pizza_category order by sum(total_price) desc) as rnk 
from pizza_sales
group by pizza_name, pizza_category
)
select 
pizza_name,
pizza_category,
total_revenue,
rnk
from rnk_pizza
where rnk <=3 
order by rnk asc, pizza_category;


-- 16 display pizza ranked by total quantity sold within each category

  with ranking as (
  select 
  pizza_name,
  pizza_category,
  Sum(quantity) as total_quantity
  from pizza_sales
  group by pizza_name, pizza_category
  )
  select
  pizza_category,
  pizza_name,
  RANK() over (partition by pizza_category order by total_quantity desc) as rnk
  from ranking
  order by pizza_category, pizza_name;
  
  
  -- 17 Rank pizzs based on total revenue 


with pizza_rank as (
select 
pizza_name,
pizza_category,
ROUND(SUM(total_price),1) as total_revenue,
RANK() over (order by sum(total_price) desc) as rnk
from pizza_sales
group by pizza_category, pizza_name
)
select 
pizza_name,
pizza_category,
total_revenue,
rnk
from pizza_rank
where rnk <= 1;
  
  
  
  
-- 18. Calculate the running total by order date 

with daily_sales as(
select 
order_date ,
round(sum(total_price),1) as total_revenue,
sum(quantity) as total_sales
from pizza_sales
group by order_date
)
select 
order_date,
total_revenue,
ROUND(SUM(total_revenue) over (order by order_date),1) as runnig_total_revenue,
SUM(total_sales) over (order by order_date) as running_total_sales
from daily_sales
order by order_date asc;
  
  
  
  
-- 19 . Show top 5 pizza that contribute most to overall revenue

with top_pizza as (
select 
pizza_name,
pizza_category,
pizza_size,
ROUND(SUM(total_price),1) as total_revenue,
RANK() over (order by sum(total_price)desc) as rnk
from pizza_sales
group by pizza_name, pizza_category, pizza_size
)
select * from top_pizza
where rnk<=6
order by rnk asc;
  
  
-- 20 percentage contribution of each pizza in revenue

with percentage as (
select 
	pizza_name,
	ROUND(SUM(total_price),1) as total_revenue
from pizza_sales
group by pizza_name
)
select 
	pizza_name,
    total_revenue,
	ROUND((total_revenue / (select sum(total_revenue) from percentage)) * 100, 2) as revenue_percentage
FROM percentage
order by revenue_percentage desc;