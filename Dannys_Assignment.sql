use dannys_dinner ;
CREATE TABLE sales (
  customer_id VARCHAR(1), 
  order_date DATE, 
  product_id INTEGER
);

INSERT INTO sales (
  customer_id, order_date, product_id
) 
VALUES 
  ('A', '2021-01-01', '1'), 
  ('A', '2021-01-01', '2'), 
  ('A', '2021-01-07', '2'), 
  ('A', '2021-01-10', '3'), 
  ('A', '2021-01-11', '3'), 
  ('A', '2021-01-11', '3'), 
  ('B', '2021-01-01', '2'), 
  ('B', '2021-01-02', '2'), 
  ('B', '2021-01-04', '1'), 
  ('B', '2021-01-11', '1'), 
  ('B', '2021-01-16', '3'), 
  ('B', '2021-02-01', '3'), 
  ('C', '2021-01-01', '3'), 
  ('C', '2021-01-01', '3'), 
  ('C', '2021-01-07', '3');
  select * from sales ;
  CREATE TABLE menu (
  product_id INTEGER, 
  product_name VARCHAR(5), 
  price INTEGER
);

INSERT INTO menu (product_id, product_name, price) 
VALUES 
  (1, 'sushi', 10), 
  (2, 'curry', 15), 
  (3, 'ramen', 12);
  select * from menu ;
  
  
CREATE TABLE members (
  customer_id VARCHAR(1), 
  join_date DATE
);

INSERT INTO members (customer_id, join_date) 
VALUES 
  ('A', '2021-01-07'), 
  ('B', '2021-01-09');

select * from members;

-- What is the total amount each customer spent at the restaurant?
select  customer_id, sum(price) as total_price
from sales s join menu m 
using (product_id )
group by customer_id
order by  customer_id ;

-- How many days has each customer visited the restaurant?
select  customer_id ,count( distinct order_date) as visit_count
from sales 
group by customer_id
order by customer_id ;

-- What was the first item from the menu purchased by each customer?
with cte as(
select  customer_id , product_name, order_date 
,dense_rank() over (partition by customer_id order by  order_date)  as rank1
from sales s inner join menu m
using (product_id))
select * from cte;
select  customer_id ,group_concat(distinct product_name order by product_name )as product_name from cte 
where rank1= 1 
group by customer_id ;



-- What is the most purchased item on the menu and how many times was it purchased by all customers?

select product_name  as most_item
,count( s.product_id ) as order_count
from menu m
inner join sales s on s.product_id = m.product_id
group by product_name
order by order_count  desc;
-- limit 1 ;


-- Which item was the most popular for each customer?
with cte as (
select customer_id ,product_name ,count(product_name) as most_count
,rank() over(partition by  customer_id order  by  count(product_name)desc) as rank_order
from menu m
inner join sales s on  m.product_id= s.product_id
group by  customer_id , product_name)
  -- select * from cte ;
select customer_id ,product_name, most_count from cte
where rank_order=1;


-- Which item was purchased first by the customer after they became a member?
with cte as(
select s.customer_id , product_name  ,order_date,join_date, m.product_id
,dense_rank() over(partition by s.customer_id  order by order_date) as rank_one  
from menu m
inner join sales s  on m.product_id = s.product_id
inner join members  b on b.customer_id = s.customer_id 
where order_date >= join_date
)
select customer_id, product_name, order_date from cte 
where rank_one =1 ;


-- Which item was purchased just before the customer became a member?

with cte as(
select s.customer_id , product_name  ,order_date,join_date, m.product_id
,dense_rank() over(partition by s.customer_id  order by order_date) as rank_one  
from menu m
inner join sales s  on m.product_id = s.product_id
inner join members  b on b.customer_id = s.customer_id 
where order_date < join_date
)
select customer_id, product_name, order_date,join_date from cte 
where rank_one =1 ;

--  What is the total items and amount spent for each member before they became a member?

select  s.customer_id, count(product_name) as total_items , concat('$' ,sum(price))as amount_spent from
menu m
inner join sales s on s.product_id = m.product_id
inner join members mem on mem.customer_id = s.customer_id
where order_date < join_date
group by customer_id
order by customer_id;

--  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id, sum( case 
when product_name ='Sushi' then price *20
else price *10 end) as customer_points
from menu m
inner join sales s on  s.product_id = m.product_id 
group by customer_id
order by customer_points desc ;

-- Total points that each customer has accrued after taking a membership
select s.customer_id, sum( case 
when product_name ='Sushi' then price *20
else price *10 end) as customer_points
from menu m
inner join sales s on  s.product_id = m.product_id 
inner join members mem on mem.customer_id = s.customer_id
where order_date >= join_date
group by s.customer_id
order by s.customer_id ;

-- Create basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL. 
-- Fill Member column as 'N' if the purchase was made before becoming a member and 'Y' if the after is amde after joining the membership.
select customer_id ,product_name, price, order_date ,if(order_date >= join_date,  'Y', 'N') as memb
from members m
right join sales using(customer_id)
inner join menu using(product_id)
order by customer_id ,order_date;

-- Rank All The Things
with cte as(
select customer_id ,product_name, price, order_date ,if(order_date >= join_date,  'Y', 'N') as memb
from members m
right join sales using(customer_id)
inner join menu using(product_id)
order by customer_id ,order_date)
select *, if( memb= 'N','Null',dense_rank() over(partition by customer_id,memb order by order_date ))as ranking from cte ;


-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January
with cte as
(select customer_id ,join_date , date_add(join_date, interval 6 day ) as program_last_date
from members)
select s.customer_id,
sum ( case when 
order_date between join_date  and cte then price*10*2
when order_Date not between join_date and cte and product_name='sushi' then price*10*2
when order_Date not between join_date and cte and product_name !='sushi' then price*10
end) as customer_points
from menu m
INNER JOIN sales AS s ON m.product_id = s.product_id
INNER JOIN cte AS mem ON mem.customer_id = s.customer_id
and order_date <= '2021-01-31'
AND order_date >=join_date
group by s.customer_id
order by s.customer_id; 

