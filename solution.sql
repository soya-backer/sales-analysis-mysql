USE shopeasy_db;
select * from orders;
select * from products;
-- Marketing wants to know which cities our orders come from and which payment methods customers use. Give me each as a separate list.
select distinct city from orders;
select distinct payment_mode from orders;
-- The catalogue team needs a clean product list showing the product name, category and price, with proper headings.
select product_name as 'product name',category as 'product category',price as 'price details' from products;

-- Finance is auditing the April to June 2026 quarter. Show me all delivered orders from Kochi or Chennai placed in that period.
select order_date,order_status,city  from orders where order_date between '2026-04-01' and'2026-06-30' and order_status='delivered' and city in ('kochi','chennai'); 

-- The payments team is reviewing card and net banking activity. Show me the orders paid by credit card or net banking where more than 2 units were bought and the order was not cancelled.
select payment_mode,quantity,order_status from orders where payment_mode in ('credit card','net banking') and quantity>=2 and order_status <> 'cancelled';

-- Which products are priced between ₹1,000 and ₹5,000 and are not in the Electronics category?
select   product_name,category from products where price between '1000' and '5000' and category <> 'electronics';

-- The website search team is testing premium-sounding product names. Which products have "Pro" or "Max" in their name?
select product_name from products where product_name like '%pro%' or '%max%' ;

-- Marketing wants to send a message to customers whose names start with "S". Give me each such customer once.
select distinct customer_name from orders where customer_name like 's%' ;

-- Show me all cancelled or returned orders where we gave no discount.
select order_status,discount_percent from orders where order_status in ('cancelled','returned') and discount_percent is null;

-- Which products launched in 2026 have not received a customer rating yet?
select launch_date,rating from products where launch_date between '2026-01-01' and '2026-12-30' and rating is null;

-- Who are our 5 most expensive products, and what do they cost?
select product_name,price from products order by price desc limit 5;

-- Give me the full product list sorted by category from A to Z, and within each category with the most expensive product first.
select product_name,category from products order by category asc, price desc;

-- Show me our 10 biggest delivered orders: who ordered, from which city, and how much they paid.,
select order_status,city,total_amount from orders where order_status='delivered' order by total_amount desc limit 10;

-- Give management a one-line summary of all orders that were not cancelled: how many orders, total revenue, average order value, smallest order and largest order. Use readable headings.
select count(order_status) as orders_count,sum(total_amount) as total_revenue,avg(total_amount) as averege_order_value,min(total_amount) as small_order,
max(total_amount) as largest_order from orders where order_status <> 'not cancelled';

-- How many orders do we have in total, how many of them had a discount, and how many different customers have ordered?
select count(order_status) as no_of_orders,count(discount_percent) as discount,count(customer_name) as customers from orders;

-- For delivered orders, show each city with its number of orders and revenue, biggest revenue first.
select order_status,city,count(order_status) as orders,sum(total_amount) as revenue from orders 
where order_status='delivered'  group by city order by sum(total_amount) desc;

-- For orders that were not cancelled, show each payment method with its number of orders and average order value. Only include methods used on more than 12 orders.
SELECT payment_mode,COUNT(order_status) AS 'Number of Orders', AVG(total_amount) AS 'Average Order Value' FROM orders
 WHERE order_status <> 'Cancelled' GROUP BY payment_mode HAVING COUNT(*) > 12;
 
-- We want to reward loyal customers. Who has placed more than 4 orders (not counting cancelled ones)? Show their name, number of orders and total spend, and give me only the top 5 spenders.
select customer_name, count(order_status) as no_of_orders,sum(total_amount) as total_spend from orders
 where order_status <> 'cancelled' group by customer_name having count(*)>4 order by sum(total_amount) desc limit 3;
 
-- For each product category, show how many products we sell, their average price and the total units in stock. Leave out categories with 3 products or fewer.
select category,count(product_name) as no_of_products, avg(price) as avg_price,avg(stock_qty) as total_stock from products
group by category having count(*)>3;

-- Operations wants to find slow cities. Among delivered orders, which cities take more than 6 days on average to deliver? Show the average, slowest first.
SELECT city, AVG(delivery_days) AS 'Average Delivery Days' FROM orders
WHERE order_status = 'Delivered' GROUP BY city HAVING AVG(delivery_days) > 6 ORDER BY AVG(delivery_days) DESC;

-- Looking only at delivered orders placed on or after 1 April 2026, and leaving out Delhi, show the number of orders and revenue for each payment method. Only include methods with revenue above ₹15,000, and show just the top 2.
SELECT payment_mode, COUNT(*) AS 'Number of Orders', SUM(total_amount) AS 'Total Revenue' FROM orders
WHERE order_status = 'Delivered' AND order_date >= '2026-04-01' AND city <> 'Delhi' GROUP BY payment_mode HAVING SUM(total_amount) > 15000
ORDER BY SUM(total_amount) DESC LIMIT 2;