-- OBJECTIVE 1: TRACK CHANGES IN POPULARITY

-- 1.) Find the overall most popular girl name and most popular boy name.
-- Show how they have changed in populaarity rankings over the years.

SELECT * FROM names;

SELECT Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'F'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Jessica

SELECT Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'M'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Michael


SELECT * FROM

(WITH girl_names AS (SELECT Year, Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'F'
GROUP BY Year, Name)

SELECT Year, Name, 
		ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
FROM girl_names) AS popular_girl_names

WHERE Name = 'Jessica';


SELECT * FROM

(WITH boy_names AS (SELECT Year, Name, SUM(Births) AS num_babies
FROM names
WHERE Gender = 'M'
GROUP BY Year, Name)

SELECT Year, Name, 
		ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
FROM boy_names) AS popular_boy_names

WHERE Name = 'Michael';





-- 2.) Find the names with the biggest jumps in popularity from the first year
-- of the data set to the last year of the data set.

WITH names_1980 AS (

	WITH all_names AS (SELECT Year, Name, SUM(Births) AS num_babies
	FROM names
	GROUP BY Year, Name)

	SELECT Year, Name, 
			ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
	FROM all_names
	WHERE Year = 1980),
    
names_2009 AS (

	WITH all_names AS (SELECT Year, Name, SUM(Births) AS num_babies
	FROM names
	GROUP BY Year, Name)

	SELECT Year, Name, 
			ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) AS popularity
	FROM all_names
	WHERE Year = 2009)
    
SELECT t1.Year, t1.Name, t1.popularity, t2.Year, t2.Name, t2.popularity,
		CAST(t2.popularity AS SIGNED) - CAST(t1.popularity AS SIGNED) AS diff
FROM names_1980 t1 INNER JOIN names_2009 t2
	ON t1.Name = t2.Name
ORDER BY diff;










