
-- 4. Self Join
select S.St_Fname, Super.*
from Student S , Student Super
where Super.St_Id = S.St_Super

select S.St_Fname, Super.*
from Student S inner join Student Super
on Super.St_Id = S.St_Super

-- Multi Table Join
-- Equi Join Syntax
select S.St_Fname, Crs_Name, Grade
from Student S, Stud_Course SC, Course C
where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id

-- Inner Join Syntax
select S.St_Fname, Crs_Name, Grade
from Student s inner join Stud_Course SC
on S.St_Id = SC.St_Id 
inner join Course C
on C.Crs_Id = SC.Crs_Id
----------------------------------
-- Join + DML
-- Update 

-- Updates Grades Of Student Who 're Living in Cairo
update SC
	set grade += 10
from Student S inner join Stud_Course SC
on  S.St_Id = SC.St_Id and St_Address = 'cairo'

-- Self Study
-- Delete
-- Insert
----------------------------------------------------------
----------------------------------------------------------
=======================================================
--------------------- Built-in Functions --------------
=======================================================

------------------- 1. Aggregate Functions ---------------
--  Return Just Only One Value (Scalar Functions) 
--  That Value is Not Existed In Database
--	Count, Sum, Avg, Max, Min  

select count(*)
from student

select count(St_Id)
from student

--The Count of Students That have Ages (Not Null)
select count(st_age) 
from student

select count(*) , count(st_id), count(st_lname), count(st_age)
from Student

select sum(salary)
from instructor


select avg(st_age)
from Student

select sum(st_age)/COUNT(*)
from Student
select sum(st_age)/COUNT(st_age)
from Student


select Max(Salary) as MaxSalary, Min(Salary) as MinSalary
from Instructor


-- Minimum Salary For Each Department
select Dept_Id, Min(Salary) as MininmumSalary
from Instructor
Group By Dept_Id


-- You Can't Group By With * or PK 
-- We Grouping With Repeated Value Column


Select Dept_Id, St_Address, Count(St_Id) as NumberOfStudents
From Student
Group By Dept_Id, St_Address  -- Will Group Here With Which Column?
-- If You Select Columns With Aggregate Functions, 
-- You Must Group By With The Same Columns 



-- Get Number Of Student For Each Department [that has more than 3 students]
select S.Dept_Id, D.Dept_Name, Count(St_Id) as NumberOfStudents
from Student S, Department D
where D.Dept_Id = S.Dept_Id
group by S.Dept_Id , D.Dept_Name
having Count(St_Id) > 3


-- Get Number Of Student For Each Department [Need Join?]
select Dept_id, Count(St_Id) as NumberOfStudents
from Student
group by Dept_Id
where dept_id is not null

select S.Dept_id, Count(S.St_Id) as NumberOfStudents
from Student S, Department D
where D.Dept_Id = S.Dept_Id
group by S.Dept_Id

-- Get Sum Salary of Instructors For Each  [Which has more than 3 Instructors]
select Dept_Id, Sum(Salary) as SumOfSalary
from Instructor
group by Dept_Id
having Count(Ins_Id) > 3


-- You Can't Use Agg Functions Inside Where Clause (Not Valid)
-- Because Aggreagate Generate Groups That 'Having' Works With it
-- Where Works With Rows => in order to Make Filteration
select Sum(Salary)
from Instructor
where count(Ins_Id) < 100 -- Not Valid

-- You Can Use Having Without Group By Only In Case Of Selecting Just Agg Functions
select Sum(Salary)
from Instructor
having count(Ins_Id) < 100 -- Valid

-- Group By With Self Join
select Super.St_FName, Count(Stud.St_Id)
from Student Stud, Student Super
where Super.St_Id = Stud.St_Super
group by Super.St_FName


------------------------------------------------------------
---------------------- 2. Null Functions -------------------
------- 1. IsNull
select st_Fname
from Student

select st_Fname
from Student
where St_Fname is not null

select isnull(st_Fname, '')
from Student

select isnull(st_Fname, 'Student Has No FName')
from Student

select isnull(st_Fname, St_Lname) as NewName
from Student

------- 2. Coalesce
select coalesce(st_Fname, St_Lname, St_Address, 'No Data')
from Student


---------------------------------------------------------
---------------------- 3. Casting Functions -------------

select St_Fname +' '+ St_Age
from student

------- 1. Convert [Convert From Any DateType To DateType]
select St_Fname +' '+ Convert(varchar(2), St_Age)
from student

select 'Student Name= ' + St_Fname + ' & Age= '+ Convert(varchar(2), St_Age)
from student

select IsNull(St_Fname,'')+' '+ Convert(varchar(2), IsNull(St_Age, 0))
from student

-- Concat => Convert All Values To String Even If Null Values (Empty String)
select Concat(St_Fname, ' ', St_Age)
from student


------- 2. Cast [Convert From Any DateType To DateType]
select cast(getdate() as varchar(50))

-- Convert Take Third Parameter If You Casting From Date To String
-- For Specifying The Date Format You Need
select convert(varchar(50),getdate(),101)
select convert(varchar(50),getdate(),102)
select convert(varchar(50),getdate(),110)
select convert(varchar(50),getdate(),111)

------- 3. Format [Convert From Date To String]

select format(getdate(),'dd-MM-yyyy')
select format(getdate(),'dddd MMMM yyyy')
select format(getdate(),'ddd MMM yy')
select format(getdate(),'dddd')
select format(getdate(),'MMMM')
select format(getdate(),'hh:mm:ss')
select format(getdate(),'hh tt')
select format(getdate(),'HH')
select format(getdate(),'dd MM yyyy hh:mm:ss')
select format(getdate(),'dd MM yyyy hh:mm:ss tt')
select format(getdate(),'dd')

---------------------------------------------------------
------------------- 4. DateTime Functions ---------------

select getdate()
select day(getdate())
select Month(GETDATE())
select eomonth(getdate())
select eomonth('1/1/2000')
select format(eomonth(getdate()),'dd')
select format(eomonth(getdate()),'dddd')

---------------------------------------------------------
------------------- 5. String Functions -----------------

select lower(st_fname),upper(st_lname)
from Student

select substring(st_fname,1,3)
from Student

select len(st_fname),st_fname
from Student

---------------------------------------------------------
--------------------- 6. Math Functions -----------------

select power(2,2)


-- log sin cos tan

---------------------------------------------------------
--------------------- 7. System Functions ---------------

select db_name()

select suser_name()

select @@ServerName


==============================================================
---------------------- Sub Query -----------------------------
-- Output Of Sub Query[Inner] As Input To Another Query[Outer]
-- SubQuery Is Very Slow (Not Recommended Except Some Cases)

/* 
select *
from student
where st_age > avg(st_age) => Not Valid
*/

select *
from student
where st_age > (select avg(st_age) from student) --23 just value

/*
select *, count(st_id)
from student => Not Valid
*/
select *,(select count(st_id) from student) --14
from student

-- SubQuery Vs Join

-- Get Departments Names That Have Students

select distinct D.Dept_Name
from Department D inner join Student S
on D.Dept_Id = S.Dept_Id

select dept_name
from Department
where Dept_Id in (	select distinct(Dept_Id)
					from Student
					where Dept_Id is not null
				)

-- SubQuery With DML
--------- SubQuery With Delete

--Delete Students Grades Who Are Living in Cairo
delete from Stud_Course
where St_Id in (
				Select St_Id from Student 
				where St_Address = 'Cairo'
				)
delete SC
from Student S inner join Stud_Course SC
on S.St_Id = SC.St_Id 
where S.St_Address = 'Cairo'


