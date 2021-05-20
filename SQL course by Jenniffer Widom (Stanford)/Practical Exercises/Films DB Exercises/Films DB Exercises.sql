-- Find the titles of all movies directed by Steven Spielberg.
select title
from Movie
where director = "Steven Spielberg";

--Find all years that have a movie that received a rating of 4 or 5,
-- and sort them in increasing order.
select distinct year
from Rating, Movie
where Movie.mID = rating.mID and stars in (4,5)
order by year asc;

--Find the titles of all movies that have no ratings.
select title
from Movie
where mID not in (select mID from Rating);

--Some reviewers didn't provide a date with their rating.
--Find the names of all reviewers who have ratings with a NULL value for the date.
select name
from Reviewer, Rating
where Reviewer.rID = rating.rID and ratingDate is null;

--Write a query to return the ratings data in a more readable format:
-- reviewer name, movie title, stars, and ratingDate.
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select name, title, stars, ratingDate
from Rating, Reviewer, Movie
where Movie.mID = rating.mID and Reviewer.rId = Rating.rID
order by name, title, stars;

select name, title, stars, ratingDate
from Movie
inner join rating on Movie.mID = Rating.mId
inner join reviewer on Reviewer.rID = Rating.rID
order by name, title, stars;

SELECT name, title, stars, ratingDate
FROM Movie NATURAL JOIN Rating NATURAL JOIN Reviewer
ORDER BY name, title, stars;

SELECT name, title, stars, ratingDate
FROM Movie
         INNER JOIN Rating USING(mId)
         INNER JOIN Reviewer USING(rId)
ORDER BY name, title, stars;

--For all cases where the same reviewer rated the same movie twice and
-- gave it a higher rating the second time, return the reviewer's name
-- and the title of the movie.

select name, title
from Movie
inner join Rating R1 using (mID)
inner join Rating R2 using (rID)
inner join Reviewer using (rId)
where R1.mID = r2.mID and R1.stars < R2.stars and R1.ratingDate < R2.ratingDate;

--For each movie that has at least one rating,
-- find the highest number of stars that movie received.
-- Return the movie title and number of stars. Sort by movie title.

select title, max(stars)
from Movie, Rating
where Movie.mID = Rating.mID
group by Movie.mID
order by title;

--For each movie, return the title and the 'rating spread',
-- that is, the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread from highest to lowest, then by movie title.

select title, (max(stars) - min(stars) ) sp
from Movie
inner join Rating using (mID)
group by Movie.mID
order by sp desc, title;

--Find the difference between the average rating of movies released before 1980
-- and the average rating of movies released after 1980.
-- (Make sure to calculate the average rating for each movie,
-- then the average of those averages for movies before 1980 and movies after.
-- Don't just calculate the overall average rating before and after 1980.)

select avg(Before1980.avg) - avg(After1980.avg)
from (
     select avg(stars) as avg
     from Movie
     inner join rating using (mID)
     where year < 1980
     group by mID
         ) as Before1980, (
     select avg(stars) as avg
     from Movie
     inner join rating using (mID)
     where year > 1980
     group by mID
    ) as After1980;


