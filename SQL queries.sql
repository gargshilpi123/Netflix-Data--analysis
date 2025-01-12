use entertainment;

-- 1. Count the number of movies vs Tv shows.
select type, count(*) as total_count_of_movies 
from netflix_titles
group by type;

-- 2. Find the Most Common Rating for Movies and TV Shows.
WITH most_common_rating AS
(select type,count(*) as cnt, rating,rank()over(partition by type order by count(*) desc )as ranking 
from netflix_titles
group by type,rating)
select type,rating,cnt from most_common_rating where most_common_rating.ranking=1 ;

-- 3. List All Movies Released in a Specific Year.
select title from netflix_titles where type='movie' and release_year='2020';

-- 4.Find the Top 5 Countries with the Most Content on Netflix.
select country , count(*) as cnt from 
(select TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country
    FROM 
        netflix_titles
    WHERE 
        country IS NOT NULL
) AS t1
GROUP BY 
    country
ORDER BY 
    cnt DESC limit 5;

-- 5. Identify the Longest Movie.
SELECT 
    title, 
    duration 
FROM 
    netflix_titles
WHERE 
    type = 'Movie' 
ORDER BY 
    CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;

-- 6. Find Content Added in the Last 5 Years.
select type,title,date_added from netflix_titles where date_added>=DATE_SUB(curdate(),INTERVAL 5 YEAR)order by date_added desc;

-- 7.Find All Movies/TV Shows by Director 'Saket Chaudhary';
SELECT * 
FROM netflix_titles
WHERE director LIKE '%Saket Chaudhary%';

-- 8.  List All TV Shows with More Than 5 Seasons.
select type,title,duration from netflix_titles where type='TV show'and CAST(SUBSTRING_INDEX(duration,' ',1)AS UNSIGNED) >5;

-- 9. Count the Number of Content Items in Each Genre.
SELECT 
    gener, 
    COUNT(*) AS cnt
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS gener
    FROM 
        netflix_titles
    WHERE 
        listed_in IS NOT NULL
) AS t1
GROUP BY 
    gener
ORDER BY 
    cnt DESC;
    
-- 10. Find each year and the average numbers of content release in India on netflix.
SELECT 
    YEAR(date_added) AS release_year, 
    COUNT(*) AS total_content,
    AVG(COUNT(*)) OVER () AS average_content
FROM 
    netflix_titles
WHERE 
    country LIKE '%India%' 
    AND date_added IS NOT NULL
GROUP BY 
    YEAR(date_added)
ORDER BY 
    release_year;

-- 11. List All Movies that are Documentaries.
select type ,title,listed_in from netflix_titles where listed_in LIKE '%Documentaries';

-- 12. Find All Content Without a Director.
select title ,date_added from netflix_titles where director is null;

-- 13. Find How Many Movies Actor 'Raashi khanna' Appeared in the Last 10 Years.
SELECT * 
FROM netflix_titles
WHERE cast LIKE '%Raashi khanna%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India.
select actor , count(*) as cnt from 
(select TRIM(SUBSTRING_INDEX(cast, ',',1)) AS actor
    FROM 
        netflix_titles where country ='India'
) AS t1
GROUP BY 
    actor
ORDER BY 
    cnt DESC limit 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
select description from netflix_titles where description like '%kill%' or '%voilence%';
