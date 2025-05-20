create database pizzahut;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) );

select * from pizzahut.orders;

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id) );


-- Retrieve the total number of orders placed.

select count(order_id) as totol_orders from orders;

-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.

select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id 
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.

select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizzas.size order by order_count desc limit 1;


-- List the top 5 most ordered pizza types along with their quantities. 


select pizza_types.name , sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.name order by total_quantity desc limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.name , sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.name;


-- Determine the distribution of orders by hour of the day.




select hour(orders.order_time) as hrs,count(order_id) as count_order 
from orders
group by hrs;



-- Join relevant tables to find the category-wise distribution of pizzas.

select pizza_types.category as categoryy , count(name) as count_name
from pizza_types

group by category ;


-- Group the orders by date and calculate the average number of pizzas ordered per day.


select round(avg(quantity),0) from
(select orders.order_date as dd , sum(order_details.quantity) as quantity
from  orders join order_details
on orders.order_id=order_details.order_id
group by dd) as table_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name as name_pizza , sum(pizzas.price * order_details.quantity) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by name_pizza  order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category , round((sum(pizzas.price * order_details.quantity) / (select sum(pizzas.price * order_details.quantity) from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id))*100,2) as revenue_percentage
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by revenue_percentage desc;


-- Analyze the cumulative revenue generated over time


select order_date, sum(revenue)
over(order by order_date) as cumm_revenue
from
(select orders.order_date , sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;
