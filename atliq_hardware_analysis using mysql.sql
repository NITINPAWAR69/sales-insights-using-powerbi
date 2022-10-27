use atliq;

-- preview dataset
SELECT * FROM atliq.transactions LIMIT 5;
SELECT * FROM atliq.customers LIMIT 5;
SELECT * FROM atliq.date limit 5;
SELECT * FROM atliq.markets LIMIT 5;
SELECT * FROM atliq.products LIMIT 5;

SELECT COUNT(*) FROM sales.transactions;
-- 'thre are 150283 rows present '

-- transactions in Mumbai
SELECT * FROM sales.transactions WHERE market_code="Mark002";

-- max sale amount of mumbai
-- using window fuctions
select t.*,
max(sales_amount) over( partition by market_code order by sales_amount desc) max_amnt
from transactions t; 

SELECT COUNT(*) FROM sales.transactions WHERE market_code="Mark002";
-- '11396'


-- rank of profit margin with respect to product

select t.*,
dense_rank() over(partition by product_code order by profit_margin desc) as ranK_product
from transactions t;



-- transactions in USD
SELECT * FROM sales.transactions where currency='INR';

SELECT COUNT(*) FROM sales.customers;
-- '38'

-- transactions by date
-- concatenate the transactions and dates records
SELECT sales.transactions.*, sales.date.* 
FROM sales.transactions INNER JOIN sales.date 
ON sales.transactions.order_date=sales.date.date;

-- all transactions in 2020
select t.*,d.*
from transactions t 
join date d on t.order_date = d.date
where atliq.d.year = 2020;

-- total revenue in 2020
SELECT SUM(sales.t.sales_amount) AS total_revenue_2020
FROM sales.transactions t INNER JOIN sales.date d
ON sales.t.order_date = sales.d.date
WHERE sales.d.year = 2020;
-- '142235559'

-- total profit margin in 2020
select sum(profit_margin) as total_profit_margin_2020
from transactions t 
join date d  on t.order_date = d.date
where d.year=2020;
-- 2060160.3399999968




-- total revenue in 2019
SELECT SUM(sales.transactions.sales_amount) AS total_revenue_2019
FROM sales.transactions INNER JOIN sales.date
ON sales.transactions.order_date = sales.date.date
WHERE sales.date.year = 2019;
-- '336452114'

-- total profit margin in 2019
select sum(profit_margin) as total_profit_margin_2019
from transactions t 
join date d  on t.order_date = d.date
where d.year=2019;
-- 10486543.889999973

-- over all revenues and profit are declining

-- revenue in mumbai in 2020
SELECT SUM(sales.transactions.sales_amount) AS total_revenue_2020_chennai
FROM sales.transactions INNER JOIN sales.date
ON sales.transactions.order_date = sales.date.date
WHERE sales.date.year = 2020 and sales.transactions.market_code = "Mark002";
-- '20183077'

-- revenue in mumbai in 2019
SELECT SUM(sales.transactions.sales_amount) AS total_revenue_2019_chennai
FROM sales.transactions INNER JOIN sales.date
ON sales.transactions.order_date = sales.date.date
WHERE sales.date.year = 2019 and sales.transactions.market_code = "Mark002";
-- '52007487'

-- products sold in mumbai
SELECT DISTINCT product_code FROM sales.transactions WHERE market_code = "MARK002";

-- garbage values
SELECT * FROM sales.transactions WHERE sales_amount <= 0;
SELECT COUNT(*) FROM sales.transactions WHERE sales_amount <= 0; -- '1611'

-- duplicate data
USE sales;
SELECT DISTINCT currency FROM transactions;
-- 'INR'
-- 'INR\r'
-- 'USD'
-- 'USD\r'
SELECT COUNT(currency) FROM transactions WHERE currency='INR'; -- '279'
SELECT COUNT(currency) FROM transactions WHERE currency='INR\r'; -- ''150000'
SELECT COUNT(currency) FROM transactions WHERE currency='USD'; -- '2'
SELECT COUNT(currency) FROM transactions WHERE currency='USD\r'; -- '2'

SELECT * FROM transactions WHERE currency='USD\r' or currency='USD'; -- duplicate records

-- revenue in 2020 without duplicates
SELECT SUM(transactions.sales_amount)
FROM transactions INNER JOIN date
ON transactions.order_date = date.date
WHERE date.year=2020 AND transactions.currency='INR\r' OR transactions.currency='USD\r';
-- '142225295'

-- revenue in Jan 2020 without duplicates
SELECT SUM(transactions.sales_amount)
FROM transactions INNER JOIN date
ON transactions.order_date = date.date
WHERE date.year=2020 AND date.month_name = 'January'
	AND (transactions.currency='INR\r' OR transactions.currency='USD\r');
-- '25656567'

-- revenue in Chennai 2020
SELECT SUM(transactions.sales_amount)
FROM transactions INNER JOIN date
ON transactions.order_date = date.date
WHERE date.year=2020 AND transactions.market_code='Mark001';
-- '2463024'
