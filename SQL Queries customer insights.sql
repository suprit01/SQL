create database cinsights ;
use cinsights ;

CREATE TABLE country (
country_id INT PRIMARY KEY,
country_name VARCHAR(50),
head_office VARCHAR(50)
);
--------------------
INSERT INTO country (country_id, country_name, head_office)
VALUES (1, 'UK', 'London'),
(2, 'USA', 'New York'),
(3, 'China', 'Beijing');
--------------------
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
first_shop DATE,
age INT,
rewards VARCHAR(50),
can_email VARCHAR(50)
);

INSERT INTO customers (customer_id, first_shop, age, rewards, can_email)
VALUES (1, '2022-03-20', 23, 'yes', 'no'),
(2, '2022-03-25', 26, 'no', 'no'),
(3, '2022-04-06', 32, 'no', 'no'),
(4, '2022-04-13', 25, 'yes', 'yes'),
(5, '2022-04-22', 49, 'yes', 'yes'),
(6, '2022-06-18', 28, 'yes', 'no'),
(7, '2022-06-30', 36, 'no', 'no'),
(8, '2022-07-04', 37, 'yes', 'yes');


CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
date_shop DATE,
sales_channel VARCHAR(50),
country_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (country_id) REFERENCES country(country_id)
);
--------------------
INSERT INTO orders (order_id, customer_id, date_shop, sales_channel, country_id)
VALUES (1, 1, '2023-01-16', 'retail', 1),
(2, 4, '2023-01-20', 'retail', 1),
(3, 2, '2023-01-25', 'retail', 2),
(4, 3, '2023-01-25', 'online', 1),
(5, 1, '2023-01-28', 'retail', 3),
(6, 5, '2023-02-02', 'online', 1),
(7, 6, '2023-02-05', 'retail', 1),
(8, 3, '2023-02-11', 'online', 3);
--------------------
CREATE TABLE products (
product_id INT PRIMARY KEY,
category VARCHAR(50),
price NUMERIC(5,2)
);
--------------------
INSERT INTO products (product_id, category, price)
VALUES (1, 'food', 5.99),
(2, 'sports', 12.49),
(3, 'vitamins', 6.99),
(4, 'food', 0.89),
(5, 'vitamins', 15.99);
--------------------
CREATE TABLE baskets (
order_id INT,
product_id INT,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
--------------------
INSERT INTO baskets (order_id, product_id)
VALUES (1, 1),
(1, 2),
(1, 5),
(2, 4),
(3, 3),
(4, 2),
(4, 1),
(5, 3),
(5, 5),
(6, 4),
(6, 3),
(6, 1),
(7, 2),
(7, 1),
(8, 3),
(8, 3);

select * from  baskets ;
select * from products ;
select * from orders ;
select * from customers ;
select * from country ;

-- 1. What are the names of all the countries in the country table?

select country_name from country ;

-- 2. What is the total number of customers in the customers table?
select count(customer_id )as total_customers
from customers ;

-- 3. What is the average age of customers who can receive marketing emails (can_email is set to 'yes')?

select avg(age) as avg_age_customer from customers
where can_email ='yes' ;

-- 4. How many orders were made by customers aged 30 or older ?

select count(o.order_id) as num_orders_30_plus from customers c  left join orders o on   o.customer_id=c.customer_id
where c.age >=30 ;

-- 5. What is the total revenue generated by each product category?

select  p.category ,sum(p.price) as revenue from orders o left join  baskets b on o.order_id=b.order_id left join
 products p on p.product_id=b.product_id
 group by p.category ;


-- 6. What is the average price of products in the 'food' category?

select round(avg(price)) as avg_price_product from products
where category ='food' ;

-- 7. How many orders were made in each sales channel (sales_channel column) in the orders table?

select sales_channel ,count(order_id) as orders_channel from orders
 group by sales_channel;

-- 8.What is the date of the latest order made by a customer who can receive marketing emails?

select c.customer_id ,first_shop as first_date from customers c left join orders  o  on o.customer_id=c.customer_id 
where  can_email= 'yes'
order by first_date desc;


-- 9. What is the name of the country with the highest number of orders?

select c.country_name ,count( distinct order_id ) as no_of_orders   from country c left join orders o  on c.country_id=o.country_id 
group by c.country_name
order by no_of_orders desc ;

-- 10. What is the average age of customers who made orders in the 'vitamins' product category?

select avg(c.age) as avg_age_customer from customers c left join orders o on c.customer_id=o.customer_id
left join baskets b on b.order_id=o.order_id 
left join products p on p.product_id=b.product_id
where category='vitamins' ;
