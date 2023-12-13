Create database StudentManage;
Create table Department
(
	did varchar(10) primary key , 
	dname nvarchar(30) not null, 
	year date, 
)

Create table Student 
(
	sid varchar(10) primary key , 
	sname nvarchar(30) not null , 
	birthday date not null , 
	did varchar(10) foreign key references Department(did) ,
)

Create table Courses 
(
	cid varchar(10) primary key , 
	cname nvarchar(30) not null , 
	credit int , 
	did varchar(10) foreign key references Department(did) , 
)

Create table Condition 
(
	cid varchar(10) not null , 
	precid varchar(10) not null , 
	primary key (cid, precid),
)

Create table Result 
(
	sid varchar(10) not null , 
	cid varchar(10) not null , 
	score float , 
)
--1
insert into Department(did,dname) values
('AVAN',N'Khoa anh Van'),
('CNTT',N'Cong Nghe Thong tin'),
('DTVT',N'Dien Tu Vien Thong'),
('QTKD',N'Quan Tri Kinh Doanh')

insert into Student (sid , sname , birthday, did) values 
('522H0090','Vo Nhat Hao', '2004-05-12', 'AVAN'),
('522H0006','Dang Thanh Nhan', '2004-10-01', 'CNTT'),
('522H0099','Huynh Trong Tri', '2004-01-01', 'QTKD')


insert into Courses (cid, cname, credit, did) values 
('AV','Anh Van', 45, 'AVAN'),
('QT','Quan tri', 45, 'QTKD'),
('CTDL','Cau truc du lieu', 45, 'CNTT')

insert into Condition (cid, precid) values 
('AV', 'Eng'), 
('QT', 'Ath'), 
('CTDL', 'Pros')

insert into Result (sid ,cid, score) values 
('522H0090','AV',9.0),
('522H0006','QT',8.0),
('522H0099','CTDL',4.0)

select * from Department
select * from Student
select * from Courses
select * from Condition
select * from Result

--2 
SELECT * FROM Department 
WHERE DID NOT IN 
(SELECT distinct DID FROM Student);

--3 
SELECT * FROM Department 
WHERE DID NOT IN
(SELECT DISTINCT DID FROM Courses);

--4 
SELECT * FROM Courses 
WHERE cid NOT IN
(SELECT DISTINCT CID FROM Result);

--5 
SELECT * FROM Student 
WHERE sid NOT IN
(SELECT DISTINCT sid FROM Result);

--6
SELECT Student.sid, Student.sname, Student.birthday, Student.did, AVG(score) FROM Student, Result
WHERE Student.sid = Result.sid
GROUP BY Student.sid, Student.sname, Student.birthday, Student.did
HAVING AVG(score) < 5

--7
SELECT Student.sid, sname, AVG(score) FROM Student, Result
WHERE Student.sid = Result.sid
GROUP BY Student.sid, sname
HAVING AVG(score) >=
(SELECT top 1 AVG(score) FROM Result
GROUP BY sid
ORDER BY AVG(score) desc)

--8
SELECT * FROM Courses 
WHERE cid in 
(SELECT cid FROM Result 
GROUP BY cid 
HAVING count(*) >= 
(SELECT top 1 count(*) FROM Result 
GROUP BY cid 
ORDER BY count(*) desc))

--9
SELECT * FROM Courses 
WHERE cid in 
(SELECT cid FROM Result 
GROUP BY cid 
HAVING count(*) < 5)

--10
SELECT * FROM Courses 
WHERE cid in 
(SELECT cid FROM Result
GROUP BY cid
HAVING COUNT(*) >= 2)

--11 
SELECT * FROM Department
WHERE did in (
SELECT did FROM Student
WHERE sid in
(SELECT sid FROM Result
WHERE score = 
(SELECT MAX(AVG_SCORE) FROM 
(SELECT AVG(score) AS AVG_SCORE FROM Result
GROUP BY SID) AS SubQuery)));

--12 
UPDATE Result
SET score = score + 1
WHERE sid in
(SELECT sid
FROM Student
WHERE did = 'IT');

--13 
UPDATE Result
SET score = 
	CASE
	WHEN score + 1 > 10 THEN 10
	ELSE score + 1
	END
WHERE sid in
(SELECT sid FROM Student
WHERE did = 'IT');

--14
select Student.sid, Student.sname, Student.birthday, avg(score)
from Student, Result where Student.sid = Result.sid
group by Student.sid, Student.sname, Student.birthday
ORDER by avg(score) DESC, Student.birthday asc

--15
SELECT * FROM Courses 
WHERE did not in (
SELECT did FROM Student
WHERE sid in
(SELECT sid FROM Result
WHERE score = 
(SELECT MIN(AVG_SCORE) FROM 
(SELECT AVG(score) AS AVG_SCORE FROM Result
GROUP BY SID) AS SubQuery)));

--16
SELECT S.sid, S.sname, AVG(R.score) AS avg_score FROM Student AS S
INNER JOIN Result AS R ON S.sid = R.sid
WHERE S.did = 'IT' 
GROUP BY S.sid, S.sname
HAVING AVG(R.score) > (SELECT AVG(score) FROM Result AS R2
        INNER JOIN Student AS S2 ON R2.sid = S2.sid
        WHERE S2.did = 'IT')

--17
SELECT Student.sid, Student.sname, Student.birthday, avg(score) FROM Student, Result
WHERE Student.sid = Result.sid and sname like '%Nguyen%' and year(getDate())-year(birthday) < 20
GROUP BY Student.sid, Student.sname, Student.birthday, Student.did
HAVING AVG(score) >= 5