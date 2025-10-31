-- Objective 4: Explore unique names in the dataset

-- 1.) Find the 10 most popular androgynous names (names given to both females and males)

SELECT Name, COUNT(DISTINCT GENDER) AS num_genders, SUM(Births) AS num_babies
FROM names
GROUP BY Name
HAVING num_genders = 2
ORDER BY num_babies DESC
LIMIT 10;




-- 2.) Find the length of the shortest and longest names, and identify the most popular 
-- short names (those with the fewest characters) and long names 
-- (those with the most characters)

SELECT Name, LENGTH(Name) AS name_length
FROM names
ORDER BY name_length; -- 2 

SELECT Name, LENGTH(Name) AS name_length
FROM names
ORDER BY name_length DESC; -- 15


WITH short_long_names AS (SELECT *
FROM names
WHERE LENGTH(Name) IN (2,15))

SELECT Name, SUM(Births) AS num_babies
FROM short_long_names
GROUP BY Name
ORDER BY num_babies DESC;

-- Fun Fact: The most popular short name is Ty and the most popular long name is Franciscojavier.







-- 3.) The founder of Maven Analytics is named Chris. Find the state with the highest percent 
-- of babies named "Chris"

SELECT State, (num_chris / num_babies) * 100 AS pct_chris
FROM

(WITH count_chris AS (SELECT State, SUM(Births) AS num_chris
FROM names
WHERE Name = 'Chris'
GROUP BY STATE),

count_all AS (SELECT State, SUM(Births) AS num_babies
FROM names
GROUP BY STATE)

SELECT cc.State, cc.num_chris, ca.num_babies
FROM count_chris cc INNER JOIN count_all ca
		ON cc.State = ca.State) AS state_chris_all
        
ORDER BY pct_chris DESC;





