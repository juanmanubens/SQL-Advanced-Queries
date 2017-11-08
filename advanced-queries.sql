/*
Query Practice:  Data Manipulation, Self Joins and Compound Queries
Juan Manubens

Part A:  Insert, Update, Delete and Normalization
*/


/*
1.  Insert a new row into the beer list.  The beer is Moonglow Weizenbock, and 8.7% 
alcohol Weizen Bock.  It is available at Monk’s in a 12oz bottle for $6.00.  
 
*/

INSERT beertemp ([Beer], [Alcohol], [Style], [Restaurant], [Neighborhood], [City], [State], [Price], [Container], [BeersAvail])
VALUES (N'Moonglow Weizenbock', 8.7, N'Weizen Bock', N'Monk''s Cafe', N'Rittenhouse', N'Philadelphia', N'PA', 6.0, N'12oz Bottle', 215)


select * from beertemp

/* 
Insert the same beer in the table leaving off all data except the beer name and 
alcohol content. Experiment with different substitute values for the alcohol content
 and see what gets inserted (try a value, NULL, and DEFAULT).  After you do these,
  run a select where Alcohol IS NULL and see what you return.

*/

-- Value
INSERT beertemp ([Beer], [Alcohol])
VALUES (N'Moonglow Weizenbock', 8.7)

-- Null
INSERT beertemp ([Beer], [Alcohol])
VALUES (N'Moonglow Weizenbock', NULL)

-- Default also returns Null
INSERT beertemp ([Beer], [Alcohol])
VALUES (N'Moonglow Weizenbock', DEFAULT)

select * from beertemp 
where Alcohol is null

select * from beertemp 

/* 
3. Delete the Moonglow records using an SQL delete.
*/ 

delete from beertemp 
where Beer = N'Moonglow Weizenbock'

/* 
4.  Write a query to update the Neighborhood field to ‘Central Main Line’ if
 the city in the database is Rosemont or Bryn Mawr.  Before you do the physical 
 UPDATE, run a select to check your WHERE  condition (Think about: Why should I 
 ALWAYS do this…?)
 
*/

UPDATE beertemp 
SET Neighborhood = N'Central Main Line'
WHERE City =  N'Rosemont' OR City =  N'Bryn Mawr'


/*
5.  Create a normalized Beerlist database (see notes for the tables, but try to 
do it on your own first by looking at it). (if for whatever reason you can’t do 
this, I put a set of normalized tables on the class database – Beers,
 Menu, Restaurants).
*/ 


-- distinct beers
select distinct Beer, Alcohol, Style 
into beers 
from beertemp


-- distinct restaurants
select distinct Restaurant, Neighborhood, City, BeersAvail
into restaurants 
from beertemp


-- distinct menus
select distinct Beer, Restaurant, Price, Container
into menus 
from beertemp


/*
6.  Using your normalized Beerlist database run a query that returns the Beer name 
and price for all beers that have the style ‘Tripel’ and Gullifty’s.  Before you
 run your query use SQL Management Studio to view the execution plan for the query. 
 
See if you can figure out what it is telling you.
*/ 

select beers.Beer, menus.Price
from beers
join menus on beers.Beer = menus.Beer
where beers.Style='Tripel' AND menus.Restaurant= 'Gullifty''s'


/* 
7.  Write the same query for the original (unnormalized table).  
Compare with the query in #6.
*/ 

-- Querying the unnormalized table returns 
-- redundant information

select beertemp.Beer, menus.Price
from beertemp
join menus on beertemp.Beer = menus.Beer
where beertemp.Style='Tripel' AND menus.Restaurant= 'Gullifty''s'



/* 
8.  Using joins (on the normalized tables) write a query that 
    provides the number of restaurants that stock each beer.  

    You did this earlier using the unnormalized table. (Note: you can 
    do this without joins on the Menu table alone, but just for practice, 
    take the Beers field off the beer table – in a real dataset the 
    Beers table would probably have a coded key rather than using the 
    name which would make this style more typical).
*/

select beers.Beer, count(*) as N_restaurants
from beers
join menus on beers.Beer = menus.Beer
group by beers.Beer

/* 
9.  Insert a new beer (“Victory Lager”) in the beers table.  

INSERT a new Restaurant (“The Greek Lady”) in the Restaurants table.  
Do not include any corresponding entries in the other table (that is, 
The Greek Lady does not sell beer, and nobody sells Victory Lager).  
Use LEFT JOIN, RIGHT JOIN and FULL JOIN to generate a list Beers 
stocked at each restaurant.  See what these queries return (if you 
have more than one join, use the same qualifier for all of them… that 
is LEFT, RIGHT or FULL…).
*/

INSERT restaurants ([Restaurant], [Neighborhood], [City], [BeersAvail] )
VALUES (N'The Greek Lady', N'University City', N'Philadelphia',  0)

--select * from restaurants

select restaurants.Restaurant, menus.Beer 
from restaurants
left join menus on restaurants.Restaurant = menus.Restaurant

/* 
Part B:  Subqueries and Self-Joins
Do these exercises on the larger dataset (bigbeer).  You can also do 
that on the smaller one if necessary.

10.  Write a query that lists all the restaurants that stock both 
Storm King and Hop Devil.  You will (probably) need to use a Self-join. 
*/


-- bigbeer
select distinct t1.Name
from bbt as t1
join bbt as t2 on t1.Name = t2.Name
where t1.Beer like '%storm king%' AND t2.Beer like '%hopdevil%'

-- beerlist
select distinct t1.Restaurant
from beertemp as t1
join beertemp as t2 on t1.Restaurant = t2.Restaurant
where t1.Beer like '%storm king%' AND t2.Beer like '%hopdevil%'



/* 
11.  (Harder) Write a query that identifies the lowest price beer in each 
restaurant and gives the restaurant, name and price.  You did a similar 
problem in query practice I, but did not have the beer name (remember 
	the discussion in class… why you can’t mix records and set operations). 

The easiest way to do this is a subquery in the WHERE clause.  I don’t think 
it is possible without either a join or a subquery.  Order this by ascending price.
*/

select Restaurant, Beer, Price
from menus as M1
where Price = (
    select MIN(Price)
    from menus as M2
    where M2.Restaurant = M1.Restaurant)
order by Price asc, Restaurant

/* 
Part C:  Big Compound Queries
This one has to be done on BigBeer (it contains the 
geocoded locations).
 
12.   Pick any beer that is commonly sold.  Write a query that finds 
the number of restaurants and the average price for that beer grouped in 
three categories based on distance from Huntman Hall:  0 to 5 miles, 
5-10 miles and greater than 10 miles.  Your resultset should return 
“0 to 5”, “5 to 10” and “>10” in column marked distance.    You can 
use the triangular distance formula:

Huntsman Hall is at Latitude:  39.9529° Longitude:  -75.1983° 
For distances you can use the formula:

Distance(Miles) = 69.04 * SQRT[(Lat1 - Lat2)^2  + (Lon1 - Lon2)^2]

Where (Lat1, Lon1) and (Lat2, Lon2) are the locations of the two 
points you are comparing. 
*/

CREATE FUNCTION fnDistance
(@latdegree1 float, @longdegree1 float, @latdegree2 float, @longdegree2 float)
RETURNS float
BEGIN
	DECLARE @distance float
	DECLARE @lat1 float
	DECLARE @long1 float
	DECLARE @lat2 float
	DECLARE @long2 float
	SET @lat1=RADIANS(@latdegree1)
	SET @long1=RADIANS(@longdegree1)
	SET @lat2=RADIANS(@latdegree2)
	SET @long2=RADIANS(@longdegree2)
	SET @distance = ATN2(SQRT(POWER(COS(@lat1)*SIN(@long2-@long1),2)+POWER(COS(@lat2)*SIN(@lat1)-
	SIN(@lat2)*COS(@lat1)*COS(@long2-@long1),2)),(SIN(@lat2)*SIN(@lat1)+
	COS(@lat2)*COS(@lat1)*COS(@long2-@long1)))*6372.795
	RETURN @distance
END
GO



with temp as (
select t1.Location, t1.Name, t1.Beer, t1.Price, 
       t1.Latitude, t1.Longitude, t1.Size from bbt t1
where t1.Beer = N'Yuengling Traditional Lager'
and   t1.Size = N'16oz')
select Location, Name, Latitude, Longitude, Price 
into #yloc
from temp 

DECLARE @@long float
DECLARE @@lat float
SET @@long =-75.197147
SET @@lat=39.953
select Location, Name, 
 oidd105.fnDistance(Latitude, Longitude, @@lat, @@long) As Dist, Price
into #yloc2 
from #yloc 

select Location, Name, Price,
  Case when Dist between 0 and 5 then N'0 to 5'
       when Dist > 5 and Dist <= 10 then N'5 to 10'
	   else N'>10' end as Distance
into #ydist
from #yloc2

select Location, Distance, count(*) as 'Number of Restaurants', 
       avg(Price) as 'Average Price - Yuengling (16oz)' from #ydist
group by Location, Distance
order by Location

