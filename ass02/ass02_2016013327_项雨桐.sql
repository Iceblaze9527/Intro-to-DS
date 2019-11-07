/*1*/
CREATE DATABASE University;
/*2*/
CREATE TABLE department 
(
	dept_name varchar(20),
    building varchar(20),
    budget decimal(10,2),
    PRIMARY KEY (dept_name)
);
CREATE TABLE instructor
(
	i_ID varchar(20),
    i_name varchar(20),
    dept_name varchar(20),
    salary decimal(8,2),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name),
    PRIMARY KEY (i_ID)
);
CREATE TABLE student
(
	s_ID varchar(20),
    s_name varchar(20),
    dept_name varchar(20),
    tot_cred int,
    FOREIGN KEY (dept_name) REFERENCES department(dept_name),
	PRIMARY KEY (s_ID)
);
CREATE TABLE advise
(
	i_ID varchar(20),
    s_ID varchar(20),
    FOREIGN KEY (i_ID) REFERENCES instructor(i_ID),
    FOREIGN KEY (s_ID) REFERENCES student(s_ID),
    PRIMARY KEY (i_ID,s_ID)
);
/*3*/
/*3.1*/
INSERT INTO department(dept_name,building,budget)
VALUES
('Biology','Watson',90000.00),
('Comp. Sci.','Taylor',100000.00),
('Elec. Eng.','Taylor',85000.00),
('Finance','Painter',120000.00),
('History','Painter',50000.00),
('Music','Packard',80000.00),
('Physics','Watson',70000.00);
/*3.2*/
INSERT INTO instructor(i_ID,i_name,dept_name,salary)
VALUES
('76766','Crick','Biology',72000.00),
('10101','Srinivasan','Comp. Sci.',65000.00),
('45565','Katz','Comp. Sci.',75000.00),
('83821','Brandt','Comp. Sci.',92000.00),
('98345','Kim','Elec. Eng.',80000.00),
('76543','Singh','Finance',80000.00),
('12121','Wu','Finance',90000.00),
('32343','El Said','History',60000.00),
('58583','Califieri','History',62000.00),
('15151','Mozart','Music',40000.00),
('22222','Einstein','Physics',95000.00),
('33456','Gold','Physics',87000.00);
/*3.3*/
INSERT INTO student(s_ID,s_name,dept_name,tot_cred)
VALUES
('98988','Tanaka','Biology',120),
('12345','Shankar','Comp. Sci.',32),
('76543','Brown','Comp. Sci.',58),
('00128','Zhang','Comp. Sci.',102),
('54321','Williams','Comp. Sci.',54),
('98765','Bourikas','Elec. Eng.',98),
('76653','Aoi','Elec. Eng.',60),
('23121','Chavez','Finance',110),
('19991','Brandt','History',80),
('55739','Sanchez','Music',38),
('44553','Peltier','Physics',56),
('45678','Levy','Physics',46),
('70557','Snow','Physics',0);
/*3.4*/
INSERT INTO advise(i_ID,s_ID)
VALUES
('76766','98988'),
('10101','12345'),
('45565','76543'),
('45565','00128'),
('98345','98765'),
('98345','76653'),
('76543','23121'),
('22222','44553'),
('22222','45678');
/*4.1*/
SELECT * FROM student
WHERE tot_cred >= 100;
/*4.2*/	
SELECT * FROM instructor
WHERE salary <= 70000.00;
/*4.3*/
SELECT * FROM department
WHERE budget >= 80000.00
ORDER BY budget DESC;
/*4.4*/
SELECT avg(salary) FROM instructor
WHERE salary >= 50000.00 AND salary <= 100000.00;
/*4.5*/
WITH temp AS
(SELECT count(s_ID) as total_students, dept_name as dept FROM student
GROUP BY dept
HAVING count(s_ID) >= 2)
SELECT count(instructor.i_ID) as total_instructors, temp.total_students, temp.dept as department FROM instructor inner join temp on temp.dept = instructor.dept_name
GROUP BY temp.dept;
/*5.1.1*/
SELECT * FROM student natural join advise;
/*5.1.2*/
SELECT * FROM student inner join advise on student.s_ID = advise.s_ID;
/*5.1.3*/
SELECT * FROM student left outer join advise on student.s_ID = advise.s_ID;
/*5.1.4*/
SELECT * FROM student right outer join advise on student.s_ID = advise.s_ID;
/*5.1.5*/	
SELECT * FROM student left outer join advise on student.s_ID = advise.s_ID
UNION
SELECT * FROM student right outer join advise on student.s_ID = advise.s_ID;
/*5.2*/
SELECT instructor.i_name, count(advise.s_ID) as total_student_advised FROM instructor 
left outer join advise on instructor.i_ID = advise.i_ID
GROUP BY instructor.i_name;
/*6*/
UPDATE instructor, 
(
SELECT instructor.i_name, count(advise.s_ID) as total_student_advised 
FROM instructor left outer join advise on instructor.i_ID = advise.i_ID
GROUP BY instructor.i_name
) AS statistics
SET instructor.salary = instructor.salary * 2
WHERE instructor.i_name = statistics.i_name AND statistics.total_student_advised >= 2;
/*7*/
ALTER TABLE instructor
DROP FOREIGN KEY instructor_ibfk_1;

ALTER TABLE instructor
ADD CONSTRAINT instructor_ibfk_2
FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE CASCADE;

ALTER TABLE studentinstructor_ibfk_2student_ibfk_2
DROP FOREIGN KEY student_ibfk_1;

ALTER TABLE student
ADD CONSTRAINT student_ibfk_2
FOREIGN KEY (dept_name) REFERENCES department(dept_name) ON DELETE CASCADE;

DELETE FROM department WHERE budget <= 50000.00;
			 
