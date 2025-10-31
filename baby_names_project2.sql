-- Objective 2: Compare popularity across decades

-- 1.) For each year, return the 3 most popular girl names and 3 most popular boy names

SELECT * FROM

(WITH babies_by_year AS (SELECT Year, Gender, Name, SUM(Births) AS num_babies
FROM names
GROUP BY Year, Gender, Name)

SELECT Year, Gender, Name, num_babies,
		ROW_NUMBER() OVER (PARTITION BY Year, Gender ORDER BY num_babies DESC) AS popularity
FROM babies_by_year) AS top_three

WHERE popularity < 4;






-- 2.) For each decade, return the 3 most popular girl names and 3 most popular boy names


SELECT * FROM

(WITH babies_by_decade AS (SELECT (CASE WHEN Year BETWEEN 1980 AND 1989 THEN 'Eighties'
										WHEN Year BETWEEN 1990 AND 1999 THEN 'Nineties'
										WHEN Year BETWEEN 2000 AND 2009 THEN 'Two Thousands'
                                        ELSE 'None' END) AS decade,
Gender, Name, SUM(Births) AS num_babies
FROM names
GROUP BY decade, Gender, Name)

SELECT decade, Gender, Name, num_babies,
		ROW_NUMBER() OVER (PARTITION BY decade, Gender ORDER BY num_babies DESC) AS popularity
FROM babies_by_decade) AS top_three

WHERE popularity < 4;






-- FUN FACT: Girl names change a lot over the decades while the boy names change slightly 
-- and Michael is the most popular over the decades




