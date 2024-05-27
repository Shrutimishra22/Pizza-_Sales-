Create database pizzahut;


Create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key (order_id));


Create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id) );

------------------------------------------------------------------------------
# Basic Questions........

#1 Retrieve the total number of orders placed.

Select count(order_id) as total_orders from orders;
------------------------------------------------------------------------------

#2 Calculate the total revenue generated from pizza sales.

Select
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details. pizza_id;
------------------------------------------------------------------------------

# 3. Identify the highest-priced pizza......

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;
------------------------------------------------------------------------------

# 4. Identify the most common pizza size ordered.......

select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;
------------------------------------------------------------------------------

# 5. List the top 5 most ordered pizza types along with their quantities...

Select Pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by Pizza_types.name order by quantity desc limit 5;
-------------------------------------------------------------------------------

# Intermediate Questions............

#1.Join the necessary tables to find the 
# total quantity of each pizza category ordered.

Select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas. pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;
------------------------------------------------------------------------------

# 2.Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);
--------------------------------------------------------------------------------

#3. Join relevant tables to find the category-wise distribution of pizzas.

Select category, count(name) from pizza_types
group by category;
------------------------------------------------------------------------------

#4. Group the orders by date and calculate the average 
# number of pizzas ordered per day.

Select avg(quantity) from 
(Select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;
-------------------------------------------------------------------------------

#5.Determine the top 3 most ordered pizza types based on revenue.

Select pizza_types.name,
sum(order_details.quantity * Pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;
----------------------------------------------------------------------------------

# Advance Questions........

#1. Calculate the percentage contribution of each pizza type to total revenue.

Select pizza_types.category,
(sum(order_details.quantity * Pizzas.price) / (Select
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id) )* 100 as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;
-----------------------------------------------------------------------------------------

#2. Analyze the cumulative revenue generated over time.

Select order_date, 
sum(revenue) over(order by order_date) as cum_revenue
from
(Select orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue 
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id 
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;
--------------------------------------------------------------------------------

# 3. Determine the top 3 most ordered pizza types 
# based on revenue for each pizza category.


Select name, revenue from 
(Select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from 
(Select pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;








	












