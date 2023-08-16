-- Data in Motion SQL Study 

create database motion ;
use motion ;

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

-- Inserting values into the customer table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

-- Viewing the customer table
SELECT * FROM customers;

-- Creating the products table
CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

-- Inserting values into the products table
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

select * from products ;

-- Creating the orders table
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

-- Inserting values into the orders table
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

-- Viewing the orders table
SELECT * FROM orders;

-- Creating order items table
CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);


-- Inserting values into the order items table
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);

SELECT * FROM customers;
select * from products ;
select * from orders ;
select * from order_items ;

-- Questions 
-- Question One: Which product has the highest price? Only return a single row.
select product_name ,max(price)
from products
group by product_name ,price
order by price desc
limit 1 ;

-- Which customer has made the most orders?

select c.customer_id ,c.first_name ,c.last_name ,count(distinct o.order_id ) as no_of_orders from customers c
 join orders o on c.customer_id=o.customer_id 
 join order_items oi on oi.order_id=o.order_id 
 group by c.customer_id 
 order by c.customer_id 
 limit 3 ;

-- What’s the total revenue per product?
with sales as (
select p.product_id,p.product_name ,p.price , oi.quantity * p.price as amount from products p 
join order_items oi on oi.product_id=p.product_id 
order by p.product_name )
select product_name ,sum(amount) as total_revenue from sales 
group by product_name ;

--  Find the day with the highest revenue.

with sales as (
select p.product_id,p.product_name ,p.price , o.order_date , oi.quantity , oi.quantity * p.price as amount from products p 
join order_items oi on oi.product_id=p.product_id 
join orders o on oi.order_id=o.order_id
order by o.order_date )
select order_date ,sum(amount) as total_revenue from sales 
group by order_date ;



-- Find the first order (by date) for each customer.

select  c.customer_id ,c.first_name ,c.last_name ,min(o.order_date) as first_order_date from customers c 
join orders o on c.customer_id=o.customer_id 
group by c.customer_id ;

--  Find the top 3 customers who have ordered the most distinct products
with dis_pro as (
SELECT c.customer_id,c.first_name,c.last_name,o.order_id ,p.product_id, p.product_name FROM customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id )
select  customer_id, first_name,last_name,count(distinct product_id ) as distinct_product  from dis_pro  
group by  customer_id,first_name,last_name 
order by distinct_product desc 
limit 3 ;


-- Which product has been bought the least in terms of quantity?

select  p.product_id ,p.product_name,sum(quantity) as tot_qty from products p 
join order_items oi on p.product_id=oi.product_id  
group by  p.product_id ,p.product_name
order by tot_qty asc ;

-- What is the median order total ?

with ord as (
SELECT oi.order_id,p.product_id,p.product_name,o.order_date,oi.quantity,p.price,oi.quantity * p.price AS tot_amount FROM products p
join order_items oi on p.product_id=oi.product_id
join orders o on oi.order_id=o.order_id 
order by o.order_date )
select order_id,sum(tot_amount) as sum_of_orders from ord
group by order_id;


-- For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’

with ord as (
SELECT oi.order_id,p.product_id,p.product_name,o.order_date,oi.quantity,p.price,oi.quantity * p.price AS tot_amount FROM products p
join order_items oi on p.product_id=oi.product_id
join orders o on oi.order_id=o.order_id 
order by o.order_date )
select sum(tot_amount) as sum_of_orders , 
case when sum(tot_amount) >300 then 'Expensive' 
     when  sum(tot_amount) between 100 and 300 then 'Affordable' 
     else 'Chep' end as orders_type 
 from ord
group by order_id
order by order_id ;


-- Find customers who have ordered the product with the highest price.


with cte as (
SELECT DISTINCT c.customer_id,c.first_name,c.last_name,oi.order_id,o.order_date,p.product_name,p.price AS price FROM customers c 
join orders o on o.customer_id=c.customer_id
join order_items oi  on  o.order_id=oi.order_id 
join products p on p.product_id=oi.product_id
order by c.customer_id )
select customer_id,first_name,last_name ,max(price) as max_price from cte 
group by customer_id
order by max_price desc ;