-- Find the names of all students
-- who are friends with someone named Gabriel.
select H1.name
from Highschooler H1
INNER JOIN Friend on H1.ID = Friend.ID1
Inner join Highschooler H2 on H2.Id = Friend.ID2
where H2.name = "Gabriel";

-- For every student who likes someone 2 or more grades younger than themselves,
-- return that student's name and grade, and the name and grade of the student they like.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1
INNER JOIN Likes on H1.Id = Likes.ID1
INNER JOIN Highschooler H2 on H2.Id = Likes.ID2
where (H1.grade - H2.grade) >= 2;

-- For every pair of students who both like each other,
-- return the name and grade of both students.
-- Include each pair only once, with the two names in alphabetical order.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes L1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) AND (H2.ID = L2.ID1 AND H1.ID = L2.ID2) AND H1.name < H2.name
ORDER BY H1.name, H2.name;

-- Find all students who do not appear in the Likes table
-- (as a student who likes or is liked) and return their names and grades.
-- Sort by grade, then by name within each grade.
select name, grade
from Highschooler
where Highschooler.ID not in (select Id1 from Likes union select ID2 from Likes)
order by grade, name;

-- For every situation where student A likes student B,
-- but we have no information about whom B likes
-- (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select H1.name , H1.grade, H2.name, H2.grade
from Highschooler H1
inner join Likes on H1.id = Likes.Id1
inner JOIN Highschooler H2 ON H2.ID = Likes.ID2
where (H1.id = Likes.ID1 and H2.id = Likes.ID2) and H2.id not in (select  ID1 from Likes);

-- Find names and grades of students who only have friends in the same grade.
-- Return the result sorted by grade, then by name within each grade.
select name, grade
from Highschooler H1
where ID not in (
    select ID1
    from Friend, Highschooler H2
    where H1.ID = Friend.ID1 and H2.ID = Friend.ID2 and  H1.grade <> H2.grade
)
ORDER BY grade, name;

-- For each student A who likes a student B where the two are not friends,
-- find if they have a friend C in common (who can introduce them!). For all such trios,
-- return the name and grade of A, B, and C.

select H1.name, H1.grade, H2.name, H2.grade,  H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes, Friend F1, Friend F2
WHERE (H1.ID = Likes.ID1 AND H2.ID = Likes.ID2) AND H2.ID NOT IN (
    SELECT ID2
    FROM Friend
    WHERE ID1 = H1.ID
) AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2) AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2);

-- Find the difference between the number of students in the school and
-- the number of different first names.

select count (ID) - count(distinct name) as diff
from Highschooler;

-- Find the name and grade of all students
-- who are liked by more than one other student.

select name, grade
from Highschooler
inner join likes on Highschooler.Id = Likes.ID2
group by ID2
having count(*) > 1;

-- For every situation where student A likes student B,
-- but student B likes a different student C, return the names and grades of A, B, and C

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
where (h1.Id = L1.ID1 and h2.Id = L1.Id2) and (h2.id = L2.id1 and h3.id = L2.ID2) and h1.ID <> l2.ID2;


-- Find those students for whom all of their friends are in different grades from themselves.
-- Return the students' names and grades.

select name, grade
from Highschooler
where id not in (
    select H1.Id
    from Highschooler H1, Highschooler H2, Friend
    where H1.id = Friend.Id1 and H2.id = friend.id2 and  h1.grade = h2.grade
    );

-- What is the average number of friends per student?
-- (Your result should be just one number.)

select avg(f)
from (select count(Id2) as f
    from Friend);

-- Find the number of students who are either friends
-- with Cassandra or are friends of friends of Cassandra.
-- Do not count Cassandra, even though technically she is a friend of a friend.

select count(distinct f1.id1)
from Friend f1, Friend f2, (select ID from Highschooler where name = 'Cassandra') as C
where f1.id2 = C.ID or (f1.id1 <> c.id and f1.ID2 = f2.ID1 and f2.ID2 = C.ID);

-- Find the name and grade of the student(s) with the greatest number of friends.

select name, grade
from Highschooler
INNER JOIN Friend on Highschooler.Id = Friend.ID1
group by ID
HAVING COUNT(*) = (
    SELECT MAX(count)
    FROM (
             SELECT COUNT(*) AS count
             FROM Friend
             GROUP BY ID1
         )
);
