

# HACKERRANK SQL CHALLENGES


/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
A. Basic Select
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */


# 1. Revising the Select Query I (Easy)
SELECT * 
FROM CITY 
WHERE COUNTRYCODE = "USA" AND POPULATION > 100000;

# 2. Revising the Select Query I (Easy)
SELECT NAME 
FROM CITY 
WHERE COUNTRYCODE = "USA" AND POPULATION > 120000;

# 3. Select All (Easy)
SELECT * 
FROM CITY;

# 4. Select By ID (Easy)
SELECT * 
FROM CITY 
WHERE ID = 1661;

# 5. Japanese Cities Attributes (Easy)
SELECT * 
FROM CITY 
WHERE COUNTRYCODE = 'JPN';

# 6. Japanese Cities Names (Easy)
SELECT NAME 
FROM CITY 
WHERE COUNTRYCODE = 'JPN';

# 7. Weather Observation Station 1 (Easy)
 SELECT CITY, STATE 
 FROM STATION;

# 8. Weather Observation Station 3 (Easy)
SELECT DISTINCT CITY 
FROM STATION 
WHERE MOD(ID,2) = 0;

# 9. Weather Observation Station 4 (Easy)
SELECT COUNT(CITY) - COUNT(DISTINCT(CITY)) 
FROM STATION;


# 10. Weather Observation Station 5 (Easy)
SELECT CITY, LENGTH(CITY) 
FROM STATION 
ORDER BY LENGTH(CITY) ASC, CITY  LIMIT 1; 
SELECT CITY, LENGTH(CITY) 
FROM STATION 
ORDER BY LENGTH(CITY) DESC, CITY  LIMIT 1;

# 11. Weather Observation Station 6 (Easy)
SELECT DISTINCT CITY 
FROM STATION 
WHERE SUBSTR(CITY,1,1) IN ('A','E','I','O','U');

# 12. Weather Observation Station 7 (Easy)
SELECT DISTINCT CITY 
FROM STATION 
WHERE SUBSTR(CITY,LENGTH(CITY),LENGTH(CITY)) IN ('A','E','I','O','U');

# 13. Weather Observation Station 8 (Easy)
SELECT DISTINCT CITY 
FROM STATION 
WHERE (SUBSTRING(CITY,LEN(CITY), LEN(CITY)) IN ('A','E','I','O','U')) 
AND (SUBSTRING(CITY,1,1) IN ('A','E','I','O','U'));

# 14. Weather Observation Station 9 (Easy)
SELECT DISTINCT CITY 
FROM STATION 
WHERE SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U');

# 15. Weather Observation Station 10 (Easy)
SELECT DISTINCT CITY 
FROM STATION 
WHERE SUBSTRING(CITY,LEN(CITY), LEN(CITY)) NOT IN ('A','E','I','O','U');

# 16. Weather Observation Station 11 (Easy)
SELECT DISTINCT CITY FROM STATION 
WHERE (SUBSTRING(CITY,LEN(CITY), LEN(CITY)) NOT IN ('A','E','I','O','U')) 
OR (SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U'));

# 17. Weather Observation Station 12 (Easy)
SELECT DISTINCT CITY FROM STATION 
WHERE (SUBSTRING(CITY,LEN(CITY), LEN(CITY)) NOT IN ('A','E','I','O','U')) 
AND (SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U'));

# 18. Higher Than 75 Marks (Easy)
SELECT Name FROM STUDENTS
WHERE Marks > 75 
ORDER BY SUBSTRING(Name,LEN(Name)-2,LEN(Name)) ASC, ID ASC;

# 19. Employee Names (Easy)
SELECT name FROM Employee ORDER BY name ASC;

# 20. Employee Salaries (Easy)
SELECT name FROM Employee 
WHERE salary > 2000 AND months < 10
ORDER BY employee_id ASC;







/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
B. Advanced Select
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */


# 1. Type of Triangle (Easy)
SELECT CASE 
  WHEN A + B > C AND A + C > B AND B + C > A THEN 
    CASE WHEN A = B AND B = C THEN 'Equilateral' 
    WHEN A = B OR B = C OR A = C THEN 'Isosceles' 
    ELSE 'Scalene' END 
  ELSE 'Not A Triangle' END 
FROM TRIANGLES;

# 2. The PADS (Medium)
SELECT CONCAT(Name, '(', SUBSTRING(Occupation, 1, 1), ')') 
FROM OCCUPATIONS 
ORDER BY Name ASC;
SELECT CONCAT('There are a total of ', COUNT(Occupation), ' ', LOWER(Occupation), 's.') 
FROM OCCUPATIONS 
GROUP BY Occupation 
ORDER BY COUNT(Occupation), Occupation ASC;


# 3. Occupations (Medium)
SELECT MAX(Doctor), MAX(Professor), MAX(Singer), MAX(Actor)
FROM (SELECT CASE WHEN Occupation = 'Doctor' THEN name END AS Doctor
      , CASE WHEN Occupation = 'Professor' THEN name END AS Professor
      , CASE WHEN Occupation = 'Singer' THEN name END AS Singer
      , CASE WHEN Occupation = 'Actor' THEN name END AS Actor
      , RANK() OVER (PARTITION BY Occupation ORDER BY Name) AS list
    FROM Occupations) x
GROUP BY list;

# 4. Binary Tree Nodes (Medium)
SELECT N, CASE 
   WHEN P IS NULL THEN 'Root'
   WHEN N IN (SELECT P FROM BST) THEN 'Inner'
   ELSE 'Leaf'
END
FROM BST
ORDER by N;

# 5. New Companies (Medium)
WITH e AS (
    SELECT company_code,
      COUNT(DISTINCT(lead_manager_code)) AS LM,
      COUNT(DISTINCT(senior_manager_code)) AS SM,
      COUNT(DISTINCT(manager_code)) AS MM,
      COUNT(DISTINCT(employee_code)) AS EM
    FROM Employee GROUP BY company_code)
SELECT c.company_code, c.founder, e.LM, e.SM, e.MM, e.EM 
FROM Company c
LEFT JOIN e
ON c.company_code = e.company_code
ORDER BY c.company_code ASC;


/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
C. Aggregation 
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */


# 1.  Revising Aggregations - The Count Function (Easy)
SELECT COUNT(*)
FROM CITY
WHERE POPULATION > 100000;

# 2.  Revising Aggregations - The Sum Function (Easy)
SELECT SUM(POPULATION)
FROM CITY
GROUP BY DISTRICT
HAVING DISTRICT = 'California';

# 3.  Revising Aggregations - Averages (Easy)
SELECT AVG(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';

# 4. Average Population (Easy)
SELECT ROUND(AVG(POPULATION),0)
FROM CITY;

# 5. Japan Population (Easy)
SELECT SUM(POPULATION)
FROM CITY
WHERE COUNTRYCODE = 'JPN';

# 6. Population Density Difference (Easy)
SELECT MAX(POPULATION) - MIN(POPULATION)
FROM CITY;

# 7. The Blunder (Easy)
SELECT CEILING(AVG(Salary - CAST(REPLACE(Salary,'0','') as decimal)))
FROM EMPLOYEES;

# 8. Top Earners (Easy)
SELECT (months * salary), COUNT(*)
FROM employee
WHERE (months * salary) IN (SELECT MAX(months * salary) AS 'maxearnings' 
                            FROM employee)
GROUP BY (months * salary);

# 9. Weather Observation Station 2 (Easy)
SELECT ROUND(SUM(LAT_N), 2), ROUND(SUM(LONG_W), 2)
FROM STATION;

# 10. Weather Observation Station 13 (Easy)
SELECT TRUNCATE(SUM(LAT_N), 4)
FROM STATION
WHERE LAT_N BETWEEN 38.7880 AND 137.2345;

# 11. Weather Observation Station 14 (Easy)
SELECT ROUND(MAX(LAT_N), 4) 
FROM STATION 
WHERE LAT_N < 137.2345;

# 12. Weather Observation Station 15 (Easy)
SELECT ROUND(LONG_W, 4) 
FROM STATION 
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

# 13. Weather Observation Station 16 (Easy)
SELECT ROUND(MIN(LAT_N), 4) 
FROM STATION WHERE LAT_N > 38.7780;

# 14. Weather Observation Station 17 (Easy)
SELECT ROUND(LONG_W, 4) 
FROM STATION 
WHERE LAT_N = (SELECT MIN(LAT_N) 
               FROM STATION 
               WHERE LAT_N > 38.7780);


# 15. Weather Observation Station 18 (Medium)
SELECT ROUND(MAX(LAT_N) - MIN(LAT_N) + MAX(LONG_W) - MIN(LONG_W), 4) 
FROM STATION;



# 16. Weather Observation Station 19 (Medium)
SELECT ROUND(SQRT(POW(MAX(LAT_N) - MIN(LAT_N), 2) + POW(MAX(LONG_W) - MIN(LONG_W), 2)), 4) 
FROM STATION;




# 17. Weather Observation Station 20 (Medium)









/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
D. Basic Join
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */

# 1. Asian Population (Easy)
SELECT SUM(a.POPULATION) 
FROM CITY a
LEFT JOIN COUNTRY b ON a.COUNTRYCODE = b.CODE
WHERE b.CONTINENT = 'ASIA';

# 2. African Cities (Easy)
SELECT a.NAME
FROM CITY a
LEFT JOIN COUNTRY b ON a.COUNTRYCODE = b.CODE
WHERE b.CONTINENT = 'AFRICA';

# 3. Average Population of Each Continent (Easy)
SELECT a.CONTINENT, FLOOR(AVG(b.POPULATION))
FROM COUNTRY a
INNER JOIN CITY b
ON b.COUNTRYCODE = a.CODE
GROUP BY a.CONTINENT;

# 4. The Report (Medium)
with s as (
    SELECT ID, 
    CASE WHEN Marks < 70 THEN 'NULL' ELSE Name END AS Student, 
    Marks FROM Students
) SELECT s.Student, g.Grade, s.Marks FROM s
LEFT JOIN Grades g 
ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY g.Grade DESC, s.Student ASC, s.Marks ASC;

# 5. Top Competitors (Medium)
WITH s AS (
    SELECT h.name as hacker, a.submission_id, a.hacker_id as id, a.challenge_id, a.score,
           c.difficulty_level, d.score as maxscore
    FROM Submissions a
    LEFT JOIN Challenges c ON a.challenge_id = c.challenge_id
    LEFT JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    RIGHT JOIN Hackers h ON h.hacker_id = a.hacker_id)
SELECT id, hacker FROM s
WHERE score = maxscore
GROUP BY id, hacker
HAVING count(id) > 1
ORDER BY count(id) DESC, id ASC;


# 6. Ollivanders Inventory (Medium)

## REVIEW THIS

SELECT wands.id, min_prices.age, wands.coins_needed, wands.power
FROM wands
inner join (SELECT wands.code, wands.power, min(wands_property.age) as age, min(wands.coins_needed) AS min_price
            FROM wands
            inner join wands_property
            ON wands.code = wands_property.code
            WHERE wands_property.is_evil = 0
            GROUP BY wands.code, wands.power) min_prices
ON wands.code = min_prices.code
   AND wands.power = min_prices.power
   AND wands.coins_needed = min_prices.min_price
ORDER BY wands.power DESC, min_prices.age DESC;


# 7. Challenges (Medium)


# 8. Contest Leaderboard (Medium)
with b as (
    SELECT c.hacker_id, c.challenge_id, max(c.score) as maxscore 
    FROM (SELECT * FROM Submissions WHERE score > 0) as c 
    GROUP BY hacker_id, challenge_id)
SELECT a.hacker_id, a.name, sum(b.maxscore) as score
FROM Hackers a
LEFT JOIN b ON a.hacker_id = b.hacker_id
GROUP BY a.hacker_id, a.name
HAVING sum(b.maxscore) IS NOT NULL
ORDER BY sum(b.maxscore) DESC, a.hacker_id ASC;

















/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
E. Advanced Join
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */

# 1. Projects (Medium)

# 2. Placements (Medium)

# 3. Symmetric Pairs (Medium)

# 4. Interviews (Hard)

# 5. 15 Days of Learning SQL (Hard)

/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
F. Alternative Queries
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */


# 1. Draw The Triangle 1


# 2.Draw The Triangle 2

# 3. Print Prime Numbers (Medium)






