use swiggy_resturent;
select * from restaurants;


select substring_index(link,'/',-1) as id,link, name, city, rating, rating_count, cuisine, cost from restaurants;


-- 1. Finding the restaurant_id from the link
select substring_index(substring_index(link,'/',-1),'-',-1) as id, name, city, rating, rating_count, cuisine, cost from restaurants;



-- 2. Updating the restaurant_id in the original table
drop table if exists rest_1;
create table  rest_1 as 
		( select substring_index(substring_index(link,'/',-1),'-',-1) as id, name, city, rating, 
			rating_count, cuisine, cost FROM restaurants );
select * from rest_1;



-- 3. Clean the name column and update it on the table
drop table if exists  rest_2;
create table  rest_2 as
		( select id, lower(trim(name)) as name,city, rating, rating_count, cuisine, cost from rest_1 );
select * from rest_2;



-- 4. Clean the city &  cuisine column and update it on the table
drop table if exists rest_3;
create table  rest_3 as
		( select id, lower(trim(name)) as name, lower(city) as 'city', rating, rating_count, 
			lower(cuisine) as 'cuisine', cost from rest_2 );
select * from rest_3;


-- 5. Remove the odd cuisines from the table
drop table if exists clean;
create table  clean as
		( select * from rest_3 where cuisine not in ('combo','na','
			discount offer from garden cafe express kankurgachi',
			'svanidhi street food vendor','tex-mex','special discount from (hotel swagath)',
			'free delivery ! limited stocks!'));
select * from clean;


-- 6. Top-rated Restaurants: What are the top 10 restaurants with the highest ratings?
select name, city, rating, rating_count ,cuisine, cost 
  from  clean 
   order by rating  desc limit 10;

   
-- 7. Most Popular Cuisine: Which cuisine type appears the most across all restaurants?
select  cuisine ,count(*) as 'count'
  from clean
   group by cuisine
     order by  count desc limit 5;


-- 8. City-wise Cost Analysis: What is the average meal cost per city?
select city, round(avg(cost),2) as 'average_cost' 
 from clean
  group by city
   order by average_cost;



-- 9. High vs. Low Rated Restaurants: What factors (cost, cuisine, location) influence restaurant ratings?
-- 9.1 High-Rated Restaurants (4.5+)
select  avg(cost) as 'High_rated'
  from clean
    where rating >=4.5;
    
-- 9.2 Low-Rated Restaurants (≤3.0)
 select  avg(cost) as 'low_rated'
  from clean
    where rating<=3.0;  


-- 10. Affordable vs. Expensive Restaurants: What are the cheapest and most expensive restaurants in the dataset?
-- 10.1  Most expensive
select * from clean
  order by cost desc;

-- 10.1  least expensive
select * from clean
  order by cost asc;


-- 11. Distribution of Ratings: How are ratings distributed across restaurants?
select rating, COUNT(*) AS count 
  from clean 
    group by rating 
      order by rating ;

-- 12. Customer Engagement: Is there a correlation between rating count and restaurant rating?
select rating, corating_count 
  from clean 
    order by rating_count desc;

-- 13. most frequent city in dataset
select city as 'most_frequent_city', count(*)  as 'frequency'
from clean
   group by city 
     order by count(*) desc  limit 1;

-- 14  which city has most Revenue in restaurent
 select city , sum(cost*rating_count) as 'Revenue'
from clean
   group by city
     order by Revenue desc  limit 1;
 
-- 15  which city has least Revenue in restaurent
 select city , sum(cost*rating_count) as 'Revenue'
from clean
   group by city
     order by Revenue asc  limit 1;
 

