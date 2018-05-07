

# HACKERRANK SQL CHALLENGES


/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
A. Basic Select
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */


# 1. Revising the Select Query I (Easy)
SELECT * FROM CITY WHERE COUNTRYCODE = "USA" \
AND POPULATION > 100000

# 2. Revising the Select Query I (Easy)
SELECT NAME FROM CITY WHERE COUNTRYCODE = "USA" \
AND POPULATION > 120000

# 3. Select All (Easy)
SELECT * FROM CITY 

# 4. Select By ID (Easy)
SELECT * FROM CITY WHERE ID = 1661

# 5. Japanese Cities' Attributes (Easy)
SELECT * FROM CITY WHERE COUNTRYCODE = 'JPN'

# 6. Japanese Cities' Names (Easy)
SELECT NAME FROM CITY WHERE COUNTRYCODE = 'JPN'

# 7. Weather Observation Station 1 (Easy)
 SELECT CITY, STATE FROM STATION

# 8. Weather Observation Station 3 (Easy)
SELECT DISTINCT CITY FROM STATION WHERE MOD(ID,2) = 0

# 9. Weather Observation Station 4 (Easy)
SELECT COUNT(CITY) - COUNT(DISTINCT(CITY)) FROM STATION 


# 10. Weather Observation Station 5 (Easy)
SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY) ASC, CITY  LIMIT 1; 
SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY) DESC, CITY  LIMIT 1;

# 11. Weather Observation Station 6 (Easy)
SELECT DISTINCT CITY FROM STATION WHERE SUBSTR(CITY,1,1) IN ('A','E','I','O','U')

# 12. Weather Observation Station 7 (Easy)
SELECT DISTINCT CITY FROM STATION WHERE SUBSTR(CITY,LENGTH(CITY),LENGTH(CITY)) IN ('A','E','I','O','U')

# 13. Weather Observation Station 8 (Easy)
SELECT DISTINCT CITY FROM STATION 
WHERE (SUBSTRING(CITY,LEN(CITY), LEN(CITY)) IN ('A','E','I','O','U')) 
AND (SUBSTRING(CITY,1,1) IN ('A','E','I','O','U'))

# 14. Weather Observation Station 9 (Easy)
SELECT DISTINCT CITY FROM STATION WHERE SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U')

# 15. Weather Observation Station 10 (Easy)
SELECT DISTINCT CITY FROM STATION WHERE SUBSTRING(CITY,LEN(CITY), LEN(CITY)) NOT IN ('A','E','I','O','U')

# 16. Weather Observation Station 11 (Easy)
SELECT DISTINCT CITY FROM STATION 
WHERE (SUBSTRING(CITY,LEN(CITY), LEN(CITY)) NOT IN ('A','E','I','O','U')) 
OR (SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U'))

# 17. Weather Observation Station 12 (Easy)
SELECT DISTINCT CITY FROM STATION 
WHERE (SUBSTRING(CITY,LEN(CITY), LEN(CITY)) NOT IN ('A','E','I','O','U')) 
AND (SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U'))

# 18. Higher Than 75 Marks (Easy)
SELECT Name FROM STUDENTS
WHERE Marks > 75 
ORDER BY SUBSTRING(Name,LEN(Name)-2,LEN(Name)) ASC, ID ASC

# 19. Employee Names (Easy)
SELECT name FROM Employee ORDER BY name ASC

# 20. Employee Salaries (Easy)
SELECT name FROM Employee 
WHERE salary > 2000 AND months < 10
ORDER BY employee_id ASC







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
GROUP BY list

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
ORDER BY c.company_code ASC


/*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
C. Aggregation 
*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */


# 1.  Revising Aggregations - The Count Function (Easy)


# 2.  Revising Aggregations - The Sum Function (Easy)


# 3.  Revising Aggregations - Averages (Easy)


# 4. Average Population (Easy)

# 5. Japan Population (Easy)

# 6. Population Density Difference (Easy)

# 7. The Blunder (Easy)

# 8. Top Earners (Easy)

# 9. Weather Observation Station 2 (Easy)

# 10. Weather Observation Station 13 (Easy)

# 11. Weather Observation Station 14 (Easy)

# 12. Weather Observation Station 15 (Easy)

# 13. Weather Observation Station 16 (Easy)

# 14. Weather Observation Station 17 (Easy)

# 15. Weather Observation Station 18 (Medium)

# 16. Weather Observation Station 19 (Medium)

# 17. Weather Observation Station 20 (Medium)

# 18.





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

# 5. Top Competitors (Medium)

# 6. Ollivander's Inventory (Medium)

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
ORDER BY sum(b.maxscore) DESC, a.hacker_id ASC

















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






