-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?

SELECT YEAR(START) AS yr, Count(id) AS tot_encounters
FROM encounters
GROUP BY yr
ORDER BY yr;



-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgentcare, emergency, and inpatient)?
SELECT * FROM encounters;

SELECT YEAR(START) AS yr, 
		ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS ambulatory,
        ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'outpatient' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS outpatient,
        ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'wellness' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS wellness,
        ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'urgentcare' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS urgent_care,
        ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'emergency' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS emergency,
        ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'inpatient' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS inpatient
FROM encounters
GROUP BY yr
ORDER BY yr;



-- c. What percentage of encounters were over 24 hours versus under 24 hours?

SELECT COUNT(TIMESTAMPDIFF(HOUR, START, STOP))
FROM encounters
WHERE TIMESTAMPDIFF(HOUR, START, STOP) >= 24;

SELECT COUNT(TIMESTAMPDIFF(HOUR, START, STOP))
FROM encounters
WHERE TIMESTAMPDIFF(HOUR, START, STOP) < 24;

SELECT ROUND(SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) >= 24 THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS over_24_hours,
	   ROUND(SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) < 24 THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS under_24_hours
FROM encounters;







-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT * FROM encounters;

SELECT SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) AS tot_0_payer_coverage,
		ROUND(SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS pct_0_payer_coverage
FROM encounters; -- 13,586 (48.7%)



-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT * FROM procedures; 

SELECT DESCRIPTION AS procedures, COUNT(*) AS times_performed, AVG(BASE_COST) AS avg_base_cost
FROM procedures
GROUP BY procedures
ORDER BY times_performed DESC
LIMIT 10;


-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT DESCRIPTION AS procedures, COUNT(*) AS times_performed, AVG(BASE_COST) AS avg_base_cost
FROM procedures
GROUP BY procedures
ORDER BY avg_base_cost DESC
LIMIT 10;



-- d. What is the average total claim cost for encounters, broken down by payer?

SELECT PAYER, AVG(TOTAL_CLAIM_COST) AS avg_tot_claim_cost
FROM encounters
GROUP BY PAYER;






-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?
SELECT * FROM encounters;

SELECT CONCAT(YEAR(START), '-Q', QUARTER(START)) AS year_quarter,
		COUNT(DISTINCT PATIENT) AS unique_patients
FROM encounters
GROUP BY CONCAT(YEAR(START), '-Q', QUARTER(START));



-- b. How many patients were readmitted within 30 days of a previous encounter?

WITH patient_encounters AS (SELECT PATIENT, START, LAG(START) OVER (PARTITION BY PATIENT ORDER BY START) AS prev_enc
FROM encounters)

SELECT COUNT(DISTINCT PATIENT) AS patients_readmitted_within_30days
FROM patient_encounters
WHERE prev_enc IS NOT NULL AND DATEDIFF(START, prev_enc) <= 30; 


-- 772 patients were readmitted within 30 days of thier previous encounter




-- c. Which patients had the most readmissions?

SELECT PATIENT, COUNT(*) - 1 AS tot_readmissions
FROM encounters
GROUP BY PATIENT
HAVING tot_readmissions > 0
ORDER BY tot_readmissions DESC;













