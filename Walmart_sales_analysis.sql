SELECT * FROM salesDataWalmart.sales;


-- --------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------Feature Engineering: ----------------------------------------------------------------
	-- Adding time_of_day (Morning, Afternoon, Evening) column
SELECT 
	time,
    (CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternooon"
        ELSE "Evening"
	END
    ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternooon"
        ELSE "Evening"
END
);


	-- Adding day_name column
SELECT date, DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

    
	-- Adding month_name column
SELECT date, MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ---------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------Exploratory Data Analysis: ---------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Product: -------------------------------------------------------------------------
SELECT * FROM salesDataWalmart.sales;

-- types of product lines
SELECT DISTINCT product_line
FROM sales; 

-- payment method distribution
SELECT payment_method, COUNT(payment_method)
FROM sales
GROUP BY payment_method; -- Cash

-- product line distribution
SELECT product_line, SUM(quantity) AS tot_sales
FROM sales
GROUP BY product_line
ORDER BY tot_sales DESC; -- Electronic accessories   
        
-- month / revenue distribution
SELECT month_name, SUM(total) AS tot_revenue
FROM sales
GROUP BY month_name;        
        
-- month / COGS distribution
SELECT month_name, SUM(cogs) AS tot_cogs
FROM sales
GROUP BY month_name;       
        
-- product line / revenue distribution
SELECT product_line, SUM(total) AS tot_revenue
FROM sales
GROUP BY product_line
ORDER BY tot_revenue DESC; 

-- city / revenue distribution
SELECT city, SUM(total) AS tot_revenue
FROM sales
GROUP BY city
ORDER BY tot_revenue DESC;        
        
-- product line / VAT distribution
SELECT product_line, AVG(VAT) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;    

-- "Good" > avg sales, "Bad" per product line sold
SELECT product_line, SUM(quantity) AS tot_sales,
		CASE 
			WHEN SUM(quantity) > (
				SELECT AVG(product_total)
                FROM (
					SELECT SUM(quantity) AS product_total
                    FROM sales
                    GROUP BY product_line
				) AS avg_table
			)
            THEN 'Good'
            ELSE 'Bad'
		END AS performance
FROM sales
GROUP BY product_line;


-- branch that sold more products than average product sold
SELECT branch, COUNT(*) AS tot_qty
FROM sales
GROUP BY branch
HAVING tot_qty > (SELECT AVG(quantity) FROM sales); 

-- gender / product line distribution
SELECT gender, product_line, COUNT(gender) AS cnt_gen
FROM sales
GROUP BY gender, product_line
ORDER BY cnt_gen DESC;

-- average rating of each product line
SELECT product_line, AVG(rating)
FROM sales
GROUP BY product_line;



-- ---------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Sales: ---------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(*) AS tot_sales
FROM sales
GROUP BY day_name, time_of_day
ORDER BY day_name;       
        
-- customer type / revenue distribution
SELECT customer_type, SUM(total) AS tot_rev
FROM sales
GROUP BY customer_type;        
        
-- city / VAT (Value Added Tax) distribution
SELECT city, AVG(VAT)
FROM sales
GROUP BY city;
        
-- customer type / VAT distribution
SELECT customer_type, AVG(VAT)
FROM sales
GROUP BY customer_type;    
    
    
    
-- ---------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Customer: ------------------------------------------------------------------------
-- types of customers
SELECT DISTINCT customer_type
FROM sales;        
        
-- types of payment methods
SELECT DISTINCT payment_method
FROM sales;        
        
-- customer distribution
SELECT customer_type, COUNT(*) AS cust_cnt
FROM sales
GROUP BY customer_type;      
        
-- gender distribution
SELECT gender, COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender;        
        
-- gender distribution per branch?
SELECT branch, gender, COUNT(*) AS gender_cnt
FROM sales
GROUP BY branch, gender
ORDER BY branch;        
        
-- time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating)
FROM sales
GROUP BY time_of_day;        
        
-- time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(rating)
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, COUNT(rating) DESC;        
        
-- avg rating per day of week
SELECT day_name, AVG(rating)
FROM sales
GROUP BY day_name
ORDER BY AVG(rating) DESC;        


