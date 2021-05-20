-- Basic SELECT statement
SELECT sID, sName, GPA FROM Student WHERE GPA > 3.6;

-- Combining 2 relations
select sName, major from Student, Apply where Student.sId = Apply.sID;

-- Combining 2 relations and removing duplicates
select distinct sName, major from Student, Apply where Student.sID = Apply.sID;

-- Combining 2 relations
select sName, GPA, decision from Student, Apply where student.sID = Apply.sID and sizeHS < 1000
                                                  and  major = "CS" and cname = "Stanford";

-- Combining 2 relations and removing duplicates
select distinct College.cName from College, Apply where college.cName = Apply.cName and enrollment >20000 and
                                       major = "CS";

-- Combining 2 relations and sorted
select Student.sID, sName, GPA, apply.cName, enrollment from Student, College, Apply
where apply.sID = Student.sID and Apply.cName = College.cName
order by GPA desc, enrollment;
-- String matching on attribute values
select sID, major from Apply where major like "%bio%";

-- Making arithmetic
select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0) from Student;

-- Usage of variables
select S.sID, sName, GPA, A.cName, enrollment from Student S, College C, Apply A
where A.sID = S.sID and A.cName = C.cName;

-- Usage of variables
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and  S1.sID < S2.sID;

-- Set Operators (union) wo duplicates
select cName as name from College
union
select sName as name from Student;

-- Set Operators (union) with duplicates
select cName from College
union all
select sName from Student;

-- Set Operators (union) with duplicates ordered
select cName as Name from College
union all
select sName as Name from Student
order by Name;

-- Set Operators (intersect)
select sID from Apply where major = "CS"
intersect
select sID from Apply where major = "EE";
-- The same as above
select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = "CS" and A2.major = "EE";

-- Set Operators (except (difference)
select sId from Apply where major = "CS"
except
select sID from Apply where major = "EE";
-- The same as above
select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = "CS" and A2.major <> "EE";

-- Subqueries in Where
select sID, sName
from Student
where sID in (select sID from Apply where major = "CS");
-- The same
select distinct Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = "CS";

-- Subqueries in Where
select sName
from Student
where sID in (select sID from Apply where major = "CS");

-- Subqueries in Select and From
select *
from (select sID, sName, GPA, GPA * (sizeHS/1000) as scaleGPA
from Student) G
where abs(G.scaleGPA - GPA) > 1;

-- Subqueries in Select and From
select cName, state,
(select distinct sName
from Apply, Student
where College.cName = Apply.cName
and Apply.sID = Student.sID) as sName
from College;

-- Inner Join on condition
select distinct sName, major
from Student join Apply
on Student.sID = Apply.sID;

-- Inner Join on condition
select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
and sizeHS < 1000 and major = "CS" and cName = "Stanford";

-- Inner Join on condition
select Apply.sID, sName, GPA, Apply.cName, enrollment
from (Student join Apply on Apply.sID = Student.sID) join College
on Apply.cName = College.cName;

-- Natural Join
select distinct sID
from student natural join Apply

-- Natural Join
select sName, GPA
from Student join Apply using (sID)
where sizeHS < 1000 and major = "CS" and cName = "Stanford";

-- Natural Join
select S1.sID, S2.sID, S1.sName, S2.sName, S1.GPA, S2.GPA
from Student S1 join Student S2 using (GPA)
where S1.sID < S2.sID;

-- Left | Right | Full Outer Join
select sName, sID, cName, major
from Student full outer join Apply using(sID);
-- the same
select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, null, null
from Student
where sID not in (select sID from Apply)
union
select null, sID, cName, major
from Apply
where Apply.sID not in (select sID from Student);

-- Aggregation avg function
SELECT avg(GPA)
FROM Student, Apply
where Student.sID = Apply.sID and major = "CS";

-- Aggregation min function
SELECT min(GPA)
FROM Student, Apply
where Student.sID = Apply.sID and major = "CS";

-- Aggregation avg function
select avg(GPA)
from Student
where sID in (select sID from Apply where major = "CS");

-- Aggregation count function
select count (*)
from College
where enrollment > 15000;

-- Aggregation count function
select count(distinct sID)
from Apply
where cName = "Cornell";

-- Aggregation count function
select *
from Student S1
where (select count(*)
from Student S2
where S2.sID <> S1.sID and S2.GPA = S1.GPA) =
(select count(*) from Student S2
where S2.sID <> S1.sID
  and S2.sizeHS = S1.sizeHS);

-- Group clause
select cName, count(*)
from Apply
group by cName;

-- Group clause
select state, sum(enrollment)
from College
group by state;

-- Group clause
select cName, major, min(GPA), max(GPA)
from Student, Apply
where student.sID = Apply.sID
group by cName, major;

-- Group clause
select max (mx-mn)
from (select cName, major, min(GPA) as mn, max(GPA) as mx
from Student, Apply
where student.sID = Apply.sID
group by cName, major) M;

-- Group clause
select Student.sID, sName, count(distinct cName), cName
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

-- Group clause
select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID
union
select sID, 0
from Student
where sID not in (select sID from Apply);

--Having clause
select cName
from Apply
group by cName
having count(*) < 5;

-- the same
select distinct cName
from Apply A1
where 5 >(select count(*) from Apply A2 where A2.cName = A1.cName);

--Having clause
select major
from Student, Apply
where Student.sID = Apply.sID
group by major
having max(GPA) < (select avg(GPA) from Student);

--Data modification Statements / INSERT
insert into College values ("Carnegie Mellon", "PA", 11500);

--Data modification Statements / INSERT
insert into Apply
select sID, "Carnegie Mellon", "CS", null
from Student
where sID not in (select sID from Apply);

--Data modification Statements / INSERT
insert into Apply
select sID, "Carnegie Mellon", "EE", "Y"
from Student
where sID in (select sID from Apply where major = "EE" and decision="N");

--Data modification Statements / DELETE
delete from Apply
where sID in
(select sID
from Apply
group by sID
having count(distinct major) > 2);

--Data modification Statements / DELETE
delete
from College
where cName not in (select cName from Apply where major = "CS");

--Data modification Statements / UPDATE
update Apply
set decision = "Y", major = "economics"
where cName = "Carnegie Mellon"
and sID in (select sID from Student where GPA < 3.6);

--Data modification Statements / UPDATE
update Apply
set major = "CSE"
where major = "EE"
and sID in (select sID from Student
    where GPA >= all
(select GPA from Student
where sID in (select sID from Apply where major = "EE")));

--Data modification Statements / UPDATE
update Student
set GPA = (select max (GPA) from Student),
    sizeHS = (select min(sizeHS) from Student);

--Data modification Statements / UPDATE
update Apply
set decision = "Y";

