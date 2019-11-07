-- 1. Install MySQL Server and MySQL WorkBench in your laptop.
-- 2. Create: Create a database named University in MySQL WorkBench.
DROP DATABASE IF EXISTS University;
CREATE DATABASE University;
use University;

-- 3. Create: Convert the given Entity-Relationship (ER) models as shown in Figure 2 to tables as we have learned in class and then create them using SQL in the University database.
drop table if exists department;
drop table if exists instructor;
drop table if exists student;

create table department
	(dept_name		varchar(20), 
	 building		varchar(15), 
	 budget		        numeric(12,2) check (budget > 0),
	 primary key (dept_name)
	);

create table instructor
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 salary			numeric(8,2) check (salary > 29000),
	 primary key (ID),
	 foreign key (dept_name) references department(dept_name)
		on delete set null
	);

create table student
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 tot_cred		numeric(3,0) check (tot_cred >= 0),
	 primary key (ID),
	 foreign key (dept_name) references department(dept_name)
		on delete set null
	);

create table advise
	(s_ID			varchar(5),
	 i_ID			varchar(5),
	 primary key (s_ID),
	 foreign key (i_ID) references instructor (ID)
		on delete set null,
	 foreign key (s_ID) references student (ID)
		on delete cascade
	);

-- 4. Insert: Insert all the values in the file named Data-University.xlsx into the University database using SQL.
insert into department values ('Biology', 'Watson', '90000');
insert into department values ('Comp. Sci.', 'Taylor', '100000');
insert into department values ('Elec. Eng.', 'Taylor', '85000');
insert into department values ('Finance', 'Painter', '120000');
insert into department values ('History', 'Painter', '50000');
insert into department values ('Music', 'Packard', '80000');
insert into department values ('Physics', 'Watson', '70000');

insert into instructor values ('10101', 'Srinivasan', 'Comp. Sci.', '65000');
insert into instructor values ('12121', 'Wu', 'Finance', '90000');
insert into instructor values ('15151', 'Mozart', 'Music', '40000');
insert into instructor values ('22222', 'Einstein', 'Physics', '95000');
insert into instructor values ('32343', 'El Said', 'History', '60000');
insert into instructor values ('33456', 'Gold', 'Physics', '87000');
insert into instructor values ('45565', 'Katz', 'Comp. Sci.', '75000');
insert into instructor values ('58583', 'Califieri', 'History', '62000');
insert into instructor values ('76543', 'Singh', 'Finance', '80000');
insert into instructor values ('76766', 'Crick', 'Biology', '72000');
insert into instructor values ('83821', 'Brandt', 'Comp. Sci.', '92000');
insert into instructor values ('98345', 'Kim', 'Elec. Eng.', '80000');

insert into student values ('00128', 'Zhang', 'Comp. Sci.', '102');
insert into student values ('12345', 'Shankar', 'Comp. Sci.', '32');
insert into student values ('19991', 'Brandt', 'History', '80');
insert into student values ('23121', 'Chavez', 'Finance', '110');
insert into student values ('44553', 'Peltier', 'Physics', '56');
insert into student values ('45678', 'Levy', 'Physics', '46');
insert into student values ('54321', 'Williams', 'Comp. Sci.', '54');
insert into student values ('55739', 'Sanchez', 'Music', '38');
insert into student values ('70557', 'Snow', 'Physics', '0');
insert into student values ('76543', 'Brown', 'Comp. Sci.', '58');
insert into student values ('76653', 'Aoi', 'Elec. Eng.', '60');
insert into student values ('98765', 'Bourikas', 'Elec. Eng.', '98');
insert into student values ('98988', 'Tanaka', 'Biology', '120');

insert into advise values ('00128', '45565');
insert into advise values ('12345', '10101');
insert into advise values ('23121', '76543');
insert into advise values ('44553', '22222');
insert into advise values ('45678', '22222');
insert into advise values ('76543', '45565');
insert into advise values ('76653', '98345');
insert into advise values ('98765', '98345');
insert into advise values ('98988', '76766');

-- Single-Table Queries:
-- (a) Select those students whose total credit are higher than 100 (including 100).
select * from student where tot_cred >= 100;

-- (b) Select those instructors whose salary are lower than 70000.00 (including 70000.00).
select * 
from instructor
where salary <= 70000;

-- (c) Select those departments whose budget are higher than 80000.00 (including 80000.00) and then sort them by budget in a descended order.
select * 
from department 
where budget >= 80000 
order by budget DESC;

-- (d) Calculate the average salary of those instructors whose salary are between 50000.00 and 100000.00 (including 50000.00 and 100000.00).
select avg(salary) as avg_salary 
from instructor  
where salary >= 50000 and salary <= 100000;

-- (e) Calculate the student number and teacher number of those departments with more than 2 students (including 2).
select student_num_table.dept_name, student_num_table.student_number, teacher_num_table.teacher_number
from 
(select dept_name, count(name) as student_number
from student
group by dept_name
having count(*)>=2) student_num_table
left outer join 
(select dept_name, count(name) as teacher_number
from instructor
group by dept_name) teacher_num_table
on student_num_table.dept_name = teacher_num_table.dept_name;

-- 6. Multi-Table Queries:
-- (a) Join table student with table advise conditioning on student ID under the following join types.
-- i. natural join
select * from student natural join advise;
--  ii. inner join
select* from student inner join advise on student.ID = advise.s_ID;
-- iii. left outer join
select* from student left outer join advise on student.ID = advise.s_ID;
--  iv. right outer join
select* from student right outer join advise on student.ID = advise.s_ID;
-- v. full outer join
select* from student left outer join advise on student.ID = advise.s_ID
union
select* from student right outer join advise on student.ID = advise.s_ID;
-- (b) List all instructors along with the number (including 0) of students they advise using a proper join type.
select name as teacher_name, count(s_ID) as student_number
from instructor left outer join advise on instructor.ID = advise.i_ID
group by instructor.name;

-- 7. Update: Double the salary of the instructors who advise more than 2 students (including 2).
SET SQL_SAFE_UPDATES = 0;
update instructor set salary = 2*salary
where ID in (
	select i_ID
	from advise
    group by i_ID
    having count(s_ID)>=2
);

-- 8. Delete: Delete the departments whose budget are lower than 50000.00 (including 50000.00).
delete from department where budget<=50000;
select * from department; 
select * from instructor; 


