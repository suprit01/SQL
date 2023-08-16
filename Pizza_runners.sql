
CREATE database pizza_runner_;
USE pizza_runner_;


-- The runners table shows the registration_date for each new runner
-- DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
-- Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.
-- DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);


INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
-- After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.
-- DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
 
  
  
-- Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
-- DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');
  
  
-- Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
-- DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');
  
  
-- table contains all of the topping_name values with their corresponding topping_id value
-- DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  
   select * from runner_orders;
  select * from customer_orders;
  select * from runners;
  select * from pizza_names;
  select * from pizza_recipes;
  select * from pizza_toppings;
  
  -- PIZZA METRICS
  
  -- How many pizzas were ordered?
  
  select count(order_id) as total_no_of_pizza  from customer_orders ;
  
  -- How many unique customer orders were made?
  select count(distinct order_id ) as unique_id  from customer_orders;
  
  --  How many successful orders were delivered by each runner?
  
  select runner_id,count(order_id) as total_delivered from runner_orders
  where cancellation is null
  group by runner_id;
  
  --  How many of each type of pizza was delivered?
  

  
  
  -- How many Vegetarian and Meatlovers were ordered by each customer?
  
  select co.customer_id,pn.pizza_name 
  from customer_orders co
  inner join pizza_names pn on pn.pizza_id=co.pizza_id
  group by pn.pizza_id,co.customer_id
  order by co.customer_id;
  
with cte as(  
  select customer_id,count(order_id) as pizza_count
  from customer_orders
  where pizza_id=1
  group by customer_id),
  cte2 as( 
  select customer_id,count(order_id) as pizza_count
  from customer_orders
  where pizza_id=2
  group by customer_id)
 select distinct a.customer_id, a.pizza_count,b.pizza_count from cte a  ,cte2 b ;
  

  -- What was the maximum number of pizzas delivered in a single order?

  SELECT    order_id,COUNT(pizza_id) AS total_pizzas
FROM customer_orders
GROUP BY order_id
ORDER BY total_pizzas DESC;



------------------------------------------------------------------------------

--  How many pizzas were delivered that had both exclusions and extras?
with cte as (
select customer_id ,
case when exclusions like '%' and extras like '%' then 1 else 0 end as change_pizaa
from customer_orders co
left join runner_orders  ro on ro.order_id=co.order_id
where duration is not null )

select customer_id , sum(change_pizaa) as total_count_change_pizza
from cte
group by customer_id
order by  total_count_change_pizza ;


------------------------------------------------------------------------------------------------------------------------

-- What was the total volume of pizzas ordered for each hour of the day?
select count(order_id) as total_orders,hour(order_time) as order_hour
from customer_orders
group by order_hour ;
------------------------------------------------------------------------------------------------------------------

-- What was the volume of orders for each day of the week?

with cte as (
select count(order_id) as total_orders ,weekday(order_time) as day
from customer_orders
group by day )
select  total_orders ,
case when day=0  then 'Monday'
when day=1  then 'Tuesday'
when day=2  then 'Wednesday'
when day=3  then 'Thursday'
when day=4  then 'Friday'  
when day=5  then 'Satday'
when day=6  then 'Sunday'  end as week_day from cte ;

------------------------------------------------------------------------------------------------------------------------

-- How many runner signed up for each 1 week period? (ie.week starts 2021-01-01)
select count(runner_id) as runner_count,
week(registration_date) as week
from runners
group by week;

---------------------------------------------------------------------------------------------------------------------

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select r.runner_id, avg(minute(pickup_time)) as time_minute
from customer_orders c left join runner_orders r on c.order_id=r.order_id
group by r.runner_id ;


--------------------------------------------------------------------------------------------------------------------------

-- What was the average distance travelled for each customer?
select c.customer_id ,avg(r.distance)  as avg_distance
from customer_orders c left join runner_orders r on c.order_id=r.order_id 
group by c.customer_id; 

----------------------------------------------------------------------------------------------------------------

-- What was the difference between the longest and shortest delivery times for all orders?

select max(duration)-min(duration) as time_diff
from runner_orders ;

-----------------------------------------------------------------------------------------------------------------------

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

select runner_id ,avg(distance) as avg_distance, avg(duration) as avg_duration
from runner_orders 
group by runner_id ;


-----------------------------------------------------------------------------------------------------------------------

-- What is the successful delivery percentage for each runner?
with cte as(
select runner_id ,
case when cancellation is null then 1 else 0 end as no_cancellation_count ,
case when cancellation is not  null then 1 else 0 end as cancellation_count
from runner_orders )
select runner_id,sum(no_cancellation_count)/(sum(cancellation_count) + sum(no_cancellation_count))*100 as delivery_percentage
from cte group by runner_id ;


-----------------------------------------------------------------------------------------------------------------------------

-- What are the standard ingredients for each pizza?
with cte as (
select r.pizza_id ,t.topping_name
from pizza_recipes r left join pizza_toppings t on t.topping_id=r.toppings )
select  c.pizza_id,c.topping_name,n.pizza_name from cte  c inner join pizza_names n on c.pizza_id=n.pizza_id ; 


-------------------------------------------------------------------------------------------------------------------


