-- Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from Movie
Inner join rating using (mID)
Inner join reviewer using (rID)
where title = "Gone with the Wind";

-- For any rating where the reviewer is the same as the director of the movie,
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from Movie
Inner join Rating using (mID)
inner join Reviewer using (rID)
where director = name;

select name, title, stars
from Movie, Rating, Reviewer
where Movie.mid = Rating.mID and Rating.rID = Reviewer.rID and director = name;

-- Return all reviewer names and movie names together in a single list, alphabetized.
-- (Sorting by the first name of the reviewer and first word in the title is fine;
-- no need for special processing on last names or removing "The".)
select title
from Movie
union
select name
from Reviewer
order by name, title;

-- Find the titles of all movies not reviewed by Chris Jackson.
select title
from Movie
where mID not in (
    select mID
    from Rating
    inner join reviewer using (rID)
    where name = "Chris Jackson"
    );


-- For all pairs of reviewers such that both reviewers gave a rating to the same movie,
-- return the names of both reviewers.
-- Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once.
-- For each pair, return the names in the pair in alphabetical order.
select distinct Re1.name, Re2.name
from Reviewer Re1, Reviewer Re2, Rating R1, Rating R2
where R1.mID = R2.mID and
      R1.rID = Re1.rID and
      R2.rID = Re2.rID and
      Re1.name < Re2.name
order by Re1.name, Re2.name;

-- For each rating that is the lowest (fewest stars) currently in the database,
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from Movie
INNER JOIN Rating using (mID)
INNER JOIN Reviewer using (rID)
where stars = (select min(stars) from rating);

-- List movie titles and average ratings, from highest-rated to lowest-rated.
-- If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as Av
from Movie
INNER JOIN Rating R on Movie.mID = R.mID
Group by R.mID
order by Av desc , title;

-- Find the names of all reviewers who have contributed three or more ratings.
--(As an extra challenge, try writing the query without HAVING or without COUNT.)
select name
from Reviewer
where (select count(*) from Rating where Rating.rID = Reviewer.rID) >= 3;

-- Some directors directed more than one movie.
-- For all such directors, return the titles of all movies directed by them,
-- along with the director name. Sort by director name, then movie title.
-- (As an extra challenge, try writing the query both with and without COUNT.)
select director, title
from Movie M1
where (select count(*) from Movie M2 where M1.director = M2.director) > 1
order by director, title;

select M1.title, M1.director
from Movie M1, Movie M2
where M1.director = M2.director
group by M1.mID
having count(*) > 1
order by M1.director, M1.title;

-- Find the movie(s) with the highest average rating.
-- Return the movie title(s) and average rating.
-- (Hint: This query is more difficult to write in SQLite than other systems;
-- you might think of it as finding the highest average rating
-- and then choosing the movie(s) with that average rating.)

select title, avg(stars) as Av
from movie
inner join Rating using (mID)
group by mId
Having Av = (
select max(Av)
from (
         select title, avg(stars) as Av
         from movie
         inner join Rating using (mID)
         group by mId
         )
);

-- Find the movie(s) with the lowest average rating.
-- Return the movie title(s) and average rating.
-- (Hint: This query may be more difficult to write in SQLite than other systems;
-- you might think of it as finding the lowest average rating and then choosing the movie(s)
-- with that average rating.)

select title, avg(stars) as Av
from Movie
inner join Rating using (mID)
group by mID
having av = (
    select min(Av)
    from (
             select title, avg(stars) as Av
             from Movie
             inner join Rating using (mID)
             group by mID
             )
    );

-- For each director, return the director's name together
-- with the title(s) of the movie(s) they directed that
-- received the highest rating among all of their movies,
-- and the value of that rating. Ignore movies whose director is NULL.

select distinct director, title, MAX(stars)
from Movie
inner join Rating using (mID)
where director is not null
group by director;