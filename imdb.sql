/*
IMDB Database Analysis - Juan Manubens

/*
Question 1: Basic Single and Multi-table queries

1.1. The show Farscape was a TV serial. Find the PrimaryName and MovieNameKey 
key for Farscape. 
(Show the query and answer but not the resultset).
*/

SELECT PrimaryName, MovieNameKey
FROM MovieMaster 
WHERE Movie like '%farscape%'

-- PrimaryName:  '"Farscape" (1999)'
-- MovieNameKey: 411585


/*
1.2. Using your answer from 1a, make a list of actors that appeared at least 50 times 
in Farscape. Order by the number of appearances (from greatest to least) breaking ties 
by last name. The resultset should have two columns – Name (with the First and Last Name) 
and Appearances. (show the query and resultset).
*/

SELECT FirstName, LastName, FirstName + ' ' + LastName as Name, ActorID
INTO #farscape
FROM Actors
WHERE MovieNameKey = 411585

SELECT Name, COUNT(ActorID) as Appearances
FROM #farscape
GROUP BY Name, LastName
HAVING COUNT(ActorID) >= 50
ORDER BY Appearances DESC, LastName DESC

/*
1.3. How many total Actors ever appeared in Farscape? (Just give the answer)
*/

SELECT COUNT(DISTINCT ActorID) as 'Total # of Actors'
FROM #farscape

-- 301



/*
For the remaining questions use MovieKey (not MovieNameKey) to identify productions.

Question 2: Grouping and Recoding

2.0 Generate the data and make a graph (in excel) of the fraction of female leads 
that appear in the actors database by year from 1997 to 2017 inclusive. A lead 
role is one where position=1. Dates can be identified by the MovieMaster.Date field. 

Your query should generate the fraction and the year – you should not have to do 
any additional processing other than making the graph. (Show the query and the graph)
*/

SELECT Actors.MovieKey, Actors.Position, Actors.Gender, MovieMaster.Date as 'Year'
INTO #leads
FROM Actors
JOIN MovieMaster ON MovieMaster.MovieKey = Actors.MovieKey
WHERE Position = 1 AND Date BETWEEN '1997' AND '2017'

SELECT *
FROM #leads

SELECT Gender, Year, count(*) as N 
INTO #leadsMF
FROM #leads
GROUP BY Year, Gender

SELECT *
FROM #leadsmf
ORDER BY Year Asc

SELECT Year, sum(N) as Nmf
INTO #leadsAll
FROM #leadsMF
GROUP BY Year

SELECT t1.Year, 100 * (CAST( t1.N as FLOAT) / CAST(t2.Nmf as FLOAT)) as Perc   
INTO #leadsF
FROM #leadsMF as t1
LEFT JOIN #leadsAll as t2 ON t1.Year = t2.Year
WHERE gender = 'F'

SELECT *
FROM #leadsF
ORDER BY Year Asc


/*
Question 3: Setup for Business Analysis
The business table has a lot of interesting information on it, but it is 
a mess both in terms of data quality and organization. This question will
involve creating queries that extract relevant information from the business 
table. You can (and should) reuse the queries here in the rest of the problems.
*/
/*
3.1. Budgets. Budgets are identified as code BT. We will focus on budget 
records that are unique for a movie, non-zero and in US dollars.

a. Write a query that returns a resultset with two fields – the moviekey 
and a field called Budget which has the budget for that movie. Restrict your 
results to US Dollars and non-zero records. Exclude any movie with multiple 
entries after those conditions have been applied. (Show the query and the 
top 5 results). 
*/

IF OBJECT_ID ('tempdb.dbo.#unique', 'U') IS NOT NULL
DROP TABLE #unique;

IF OBJECT_ID ('tempdb.dbo.#valid', 'U') IS NOT NULL
DROP TABLE #valid;

IF OBJECT_ID ('tempdb.dbo.#duplicateT', 'U') IS NOT NULL
DROP TABLE #duplicateT;


SELECT MovieKey, Amount as Budget
INTO #valid
FROM Business
WHERE Currency = 'USD' AND Amount > 0 AND Code = 'BT'



SELECT MovieKey, Budget
INTO #unique
FROM #valid
GROUP BY MovieKey, Budget
HAVING COUNT(MovieKey) = 1

SELECT Top 5 MovieKey, Budget  
FROM #unique
ORDER BY Budget DESC

/*
b. How many movies have duplicate budget records (just give the answer and how you got it).
*/


SELECT MovieKey, COUNT(MovieKey) as N 
INTO #duplicateT
FROM #valid
GROUP BY MovieKey
HAVING Count(MovieKey) > 1

SELECT COUNT(*) 
FROM #duplicateT



/*
3.2. Opening Weekend. The code OW gives opening weekend gross and number of screens. Write a 
query that returns the moviekey, opening weekend gross (OWGross) and opening weekend screens
(OWScreens). Restrict your results to openings in the USA, in US Dollars, where both screens 
and revenue are non-zero. If there are multiple OW records for a movie that meet these conditions, 
take the one with the largest OWGross (Beware: this condition will dictate much of how you write the 
rest of your query). Store the result in a temporary table called #Openings + the initials of 
all your team members. Also provide code to drop your temporary table prior to creating it if 
it already exists.
*/
/*
a. Write a query to show the first 5 results from the temporary table and snip that for 
your solution document. (show the query, including the drop and the results)
*/

-- delete temp table if it already exists:
IF OBJECT_ID ('tempdb.dbo.#OpeningsAHSHJM', 'U') IS NOT NULL
DROP TABLE #OpeningsAHSHJM;

SELECT MovieKey, MAX(Amount) as OWGross, MAX(Screens) as OWScreens 
INTO #OpeningsAHSHJM
FROM Business
WHERE Code = 'OW' AND Currency = 'USD' AND Country = 'USA' AND Amount > 0 AND Screens > 0
GROUP BY MovieKey
HAVING COUNT(*) = 1

SELECT TOP 5 * 
FROM #OpeningsAHSHJM
ORDER BY OWGross DESC

/*
b. How many records are on your temporary table? (just answer the question)
*/

SELECT COUNT(*)
FROM #OpeningsAHSHJM

--Answer: 8938

/*
3.3 Gross Revenue. You can also figure out how much money a movie made domestically 
or worldwide by looking at rows where the code is GR. A given movie will have multiple 
records at different points in time. To get the total gross, take the largest of these 
values given the where conditions. 

a. Create a temporary table with the name #GROSS + the initials of your 
team members. 
- The first column is the moviekey. 
- The second is the domestic gross (DomGross) which is 
  the largest of the records where the code is GR, the 
  currency is USD and the country is USA. 
- The third is the worldwide gross (WWGross) which is 
  the largest of the records where the code is GR, the 
  currency is USD and the country is Worldwide. 

There should be one row for any movie that has either domestic or 
worldwide gross (or both).

Also add a line before the query that drops the temporary table if it already exists. 
(Show your query and state the number of records your query returned).
*/
IF OBJECT_ID ('tempdb.dbo.#GROSSAHSHJM', 'U') IS NOT NULL
DROP TABLE #GROSSAHSHJM;

IF OBJECT_ID ('tempdb.dbo.#GR', 'U') IS NOT NULL
DROP TABLE #GR;

IF OBJECT_ID ('tempdb.dbo.#GRWW', 'U') IS NOT NULL
DROP TABLE #GRWW;

SELECT MovieKey, Max(Amount) as DomGross
INTO #GR
FROM Business
WHERE Code = 'GR' AND CURRENCY = 'USD' AND COUNTRY = 'USA'
GROUP BY MovieKey

SELECT MovieKey, Max(Amount) as WWGross
INTO #GRWW
FROM Business
WHERE Code = 'GR' AND CURRENCY = 'USD' AND COUNTRY = 'Worldwide'
GROUP BY MovieKey 

SELECT t1.MovieKey, t1.DomGross, t2.WWGross
INTO #GROSSAHSHJM
FROM #GR as t1
LEFT JOIN #GRWW as t2 ON t1.MovieKey = t2.MovieKey
WHERE t2.WWGross IS NOT NULL



/*
b. What are the 10 highest grossing movies worldwide of all time. (Show the query and resultset).
*/

SELECT TOP 10 t1.MovieKey, t2.Movie
FROM #GROSSAHSHJM as t1
LEFT JOIN MovieMaster as t2 
ON t1.MovieKey = t2.MovieKey
ORDER BY WWGross DESC


/*
Question 4: Business Analysis
For this analysis, you should use the queries in Q3 so you results are restricted to 
reasonably clean and comparable data.

4.1. US vs. Worldwide revenues.

a. Write a query that plots the ratio of Worldwide Gross to Domestic Gross for 
movies that have both reported by year. Group and order by year of release 
(MovieMaster.Date). Do the analysis for 1997 to 2017 inclusive. (Show the query and resultset) */

SELECT t1.MovieKey, t2.Movie, t2.Date, t1.DomGross, t1.WWGross, 
(CAST( t1.WWGross as FLOAT) / CAST(t1.DomGross as float)) as Ratio 
INTO #analysis
from #GROSSAHSHJM as t1
LEFT JOIN MovieMaster as t2 
ON t1.MovieKey = t2.MovieKey
WHERE t1.DomGross IS NOT NULL
AND t1.WWGross IS NOT NULL;

SELECT Movie, Date, DomGross, WWGross, Ratio
FROM #analysis
WHERE Date BETWEEN 1997 AND 2017
ORDER BY Date DESC

-- MISSING: Plots


/* b. What does this show? */


/*
4.2. Scope of release and revenue.

a. Group movies into buckets with the following number of screens at open: 10-100, 100-250, 
250-500, 500-1000, 1000-2500 and more than 2500 (do not include movies that opened on less 
than 10 screens). 
*/

SELECT * FROM #analysis

SELECT t1.MovieKey, t1.Movie, t1.Date, (t1.DomGross + t1.WWGross) as TotalGross, t2.Screens
INTO #screens 
FROM #analysis as t1
LEFT JOIN Business as t2
ON t1.MovieKey = t2.MovieKey
WHERE t2.Screens >= 10;






/*
For each bucket, compute a field which is the Average Gross per Screen and
the Number of Movies in each bucket. Order the buckets in increasing size. Return the exact 
result. Fields should be named as underlined.
*/

SELECT DISTINCT MovieKey, Movie, Date, TotalGross, Screens,
CASE WHEN Screens > 2500 then '2500+'
	 WHEN Screens BETWEEN 1001 AND 2500 then '1000-2500'
	 WHEN Screens BETWEEN 501 AND 1000 then '500-1000'
	 WHEN Screens BETWEEN 251 AND 500 then '250-500'
	 WHEN Screens BETWEEN 101 AND 250 then '100-250'
	 ELSE '10-100' END AS Bucket,
(CAST( TotalGross as FLOAT) / CAST(Screens as float)) as 'GrossPerScreen' 
INTO #buckets
FROM #screens

SELECT Bucket, AVG(GrossPerScreen) As 'AverageGrossperScreen', COUNT(GrossPerScreen) as 'NumberofMovies'
FROM #buckets
GROUP BY Bucket
ORDER BY NumberofMovies



/*
b. In 1 or 2 sentences explain what you found and speculate why. 
*/


/*
4.3 Make a list of “flops”. Find the five movies with the lowest opening weekend 
gross that had a budget more than $100 million that opened on more than 1000 screens. 
List the MovieName, the opening weekend gross and the average rating.
*/

SELECT DISTINCT t1.MovieKey, t2.Movie as MovieName, t1.OWGross, t1.OWScreens 
INTO #owscreens
FROM #OpeningsAHSHJM as t1
LEFT JOIN #screens as t2
ON t1.MovieKey = t2.MovieKey
WHERE t2.Movie IS NOT NULL
AND t1.OWScreens > 1000

SELECT DISTINCT t1.MovieKey, t1.MovieName, t1.OWGross, t1.OWScreens, t2.Budget
INTO #boxoffice
FROM #owscreens as t1
LEFT JOIN #unique as t2
ON t1.MovieKey = t2.MovieKey
WHERE t2.Budget IS NOT NULL
AND t2.Budget >= 100000000

SELECT * FROM #boxoffice

SELECT t1.MovieKey, t1.MovieName, t1.OWGross, t1.OWScreens, t1.Budget, t2.AvgRating
INTO #boxofficeR
FROM #boxoffice as t1
LEFT JOIN Ratings as t2
ON t1.MovieKey = t2.MovieKey
WHERE t2.AvgRating IS NOT NULL

SELECT TOP 5 MovieName, OWGross, AvgRating FROM #boxofficeR 
ORDER BY OWGross ASC




/*
4.4 Write a query that computes the “return on investment” defined here as the ratio of 
total domestic gross to budget for movies that appeared in or after 1990. Restrict your 
results to those that have an MPAA rating.

a. List the top 5 movies by ROI. Include the movie name, budget, total gross and ROI.
*/

SELECT *
INTO #mpaa
FROM #analysis
WHERE MovieKey in (
SELECT MovieKey FROM Mpaa) 
AND Date >= 1990


SELECT t1.MovieKey, t1.Movie, t1.Date, t1.DomGross, t1.WWGross, t2.Budget, 
(CAST( t1.DomGross as FLOAT) / CAST(t2.Budget as float)) as ROI 
INTO #ROI
FROM #mpaa as t1
LEFT JOIN #unique as t2
ON t1.MovieKey = t2.MovieKey

SELECT TOP 5 Movie, Budget, (DomGross + WWGross) as TotalGross, ROI 
FROM #ROI
ORDER BY ROI DESC


/*
b. Generate a single column table for all movies where ROI can be computed. Export this to 
Excel and generate a histogram (you do not need to show the resultset).
*/

SELECT t1.MovieKey, t1.Movie, t1.Date, t1.DomGross, t1.WWGross, t2.Budget, 
(CAST( t1.DomGross as FLOAT) / CAST(t2.Budget as float)) as ROI 
INTO #allROI
FROM #analysis as t1
LEFT JOIN #unique as t2
ON t1.MovieKey = t2.MovieKey

SELECT ROI FROM #allROI 
WHERE ROI IS NOT NULL
ORDER BY ROI DESC

/*
c. Explain what you observe. 
*/


-- TO DO




/*
Question 5: Six Degrees

In the famous ‘Six Degrees of Kevin Bacon’ game your task is find an actor who 
is as ‘far’ from Kevin Bacon as possible, where far is measured by the minimum 
number of other actors needed to connect your choice to Kevin Bacon (a connection 
is when they appear in the same movie or show). For instance, John Belushi is a Bacon 
Number 1, because he was in Animal House with Kevin Bacon. Dan Akroyd has a Bacon number 
of 2 because he was in the Blues Brothers with John Belushi, but Dan Akroyd never appeared 
in a movie with Kevin Bacon. It is quite hard to find actors with Bacon numbers much 
greater than 4.

(Note: in doing these counts you can exclude or include Kevin himself depending on what 
is convenient. Also make sure you have the right Kevin Bacon).
*/

SELECT ActorID, FirstName + ' ' + LastName as Name, MovieKey
INTO #actors
FROM Actors

SELECT * 
INTO #kevin
FROM #actors
WHERE ActorID = 122414


/*
5.1. How many actors have a Bacon Number of 1? (In network analysis this is 
referred to as Kevin Bacon’s degree).
*/

SELECT COUNT(DISTINCT ActorID)
FROM #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #kevin) AND ActorID != 122414



-- Bacon Number 1: 9402 actors excluding KB


/*
5.2. Write a generic query that allows you to compute degree for a given set of ActorIDs. 
How does Kevin Bacon’s degree (you computed above) compare to the degree of Samuel L. Jackson, 
Kevin Spacey, Jennifer Lawrence and Paul Reubens (aka Pee-Wee Herman)?
*/

DECLARE @InputID INT;
SET @InputID = 1000741326; -- Pick Actor ID here. Testing with 122414 (Kevin Bacon) shows it works
SELECT COUNT(DISTINCT ActorID) 
FROM #Actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #actors
WHERE ActorID = @InputID)
AND ActorID != @InputID;

1350898

-- Kevin Spacey (ID: 2263678):  10583
-- Samuel L. Jackson  (ID: 1121657): 15098
-- Paul Reubens (ID: 1989781):  4340
-- Jennifer Lawrence  (ID: 1000741326): 5731 



/*
5.3. How many movies (using the database provided) are connected to actors with a Bacon Number of 1?
*/

-- Bacon Degree 1 Movies: 667,398

SELECT COUNT(DISTINCT MovieKey) 
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #Actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #kevin) AND ActorID != 122414)



/*
Optional Extensions

5.5X. Compute the number of Actors for Bacon Numbers 1 to 6 using SQL queries. Once you do that, 
find at least one actor that has made more than 10 appearances that has a Bacon number of 6. 

(Hint: Easiest way is to alternative the calculations from 5.1 and 5.3
*/

-- Degree 1:
SELECT DISTINCT ActorID 
INTO #d1A
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #kevin) 
AND ActorID != 122414)


SELECT DISTINCT MovieKey 
INTO #d1M
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #kevin) 
AND ActorID != 122414)

-- Degree 2:
SELECT DISTINCT ActorID 
INTO #d2A
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d1M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d1A))

SELECT DISTINCT MovieKey 
INTO #d2M
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d1M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d1A))

-- Degree 3:
SELECT DISTINCT ActorID 
INTO #d3A
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d2M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d2A))

SELECT DISTINCT MovieKey 
INTO #d3M
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d2M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d2A))


-- Degree 4:
SELECT DISTINCT ActorID 
INTO #d4A
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d3M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d3A))

SELECT DISTINCT MovieKey 
INTO #d4M
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d3M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d3A))



-- Degree 5:
SELECT DISTINCT ActorID 
INTO #d5A
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d4M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d4A))

SELECT DISTINCT MovieKey 
INTO #d5M
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d4M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d4A))



-- Degree 6:
SELECT DISTINCT ActorID 
INTO #d6A
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d5M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d5A))

SELECT DISTINCT MovieKey 
INTO #d6M
FROM #actors
WHERE ActorID IN (
SELECT DISTINCT ActorID
FROM  #actors
WHERE MovieKey in (
SELECT DISTINCT MovieKey 
FROM #d5M) 
AND ActorID NOT IN (
SELECT DISTINCT ActorID 
FROM #d5A))

-- Numbers:

/*
Number of Actors with Bacon Number 1: 9402
Number of Actors with Bacon Number 2: 1142542
Number of Actors with Bacon Number 3: 2410382
Number of Actors with Bacon Number 4: 1461619
Number of Actors with Bacon Number 5: 2436571
Number of Actors with Bacon Number 6: 1464458    
*/

SELECT COUNT(*) 
FROM #d1A
SELECT COUNT(*) 
FROM #d2A
SELECT COUNT(*) 
FROM #d3A
SELECT COUNT(*) 
FROM #d4A
SELECT COUNT(*) 
FROM #d5A
SELECT COUNT(*) 
FROM #d6A

SELECT DISTINCT ActorID, COUNT(ActorID) as N 
INTO #over10
FROM Actors
GROUP BY ActorID
HAVING COUNT(ActorID) > 10

SELECT TOP 1  ActorID, Name 
FROM #actors
WHERE ActorID in (
SELECT TOP 1 ActorID 
FROM #d6A
WHERE ActorID in (
SELECT ActorID 
FROM #over10)
)