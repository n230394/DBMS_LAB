/*--DBMS LAB ---*/
/*--WEEK 1:BUILDING A FOUNDATION-LEVEL TAXIATION DATABASE--*/
/*--1.SCENARIO--*/
/*--CREATEING THE DATABSE--*/
CREATE DATABASE TAXIATION;
USE TAXIATION;

/*---ENTITY 1:Taxpayer---*/
CREATE TABLE Taxpayer(taxpayer_id INT PRIMARY KEY,pan_number VARCHAR(10) NOT NULL UNIQUE,full_name VARCHAR(100) NOT NULL,
date_of_birth DATE NOT NULL,occupation VARCHAR(50) NOT NULL);
SHOW tables;
select * from Taxpayer;
Alter table Taxpayer add (annual_income decimal(12,2) not null,email varchar(100) unique,is_active boolean);


insert into Taxpayer(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)values(101,"ABCDE1234F","Ravi KUmar",'1995-06-15',"Software Engine",850000.00,"ravi.kumar@example.com",TRUE),
(102,"BCDEF2345G","Priya Sharma",'1992-11-22',"Docter",120000.00,"priya.sharma@example.com",True),
(103,"CDEFG3456H","Arjun Reddy",'1988-03-10',"Business Owner",180000.00,"arjun.reddy@example.com",True),
(104,"DEFGH4567J","Sneha Patel",'1998-08-05',"Teacher",620000.00,"sneha.patel@example.com",True),
(105,"EFGHJ5678K","Kiran Rao",'1990-01-18',"Freelancer",750000.00,"Kiran.rao@example.com",True),
(106,"FGHJK6789","Meera Singh",'1985-12-30',"Consultant",1500000.00,"meera.singh@example",False);





/*--Entity 2:Income category--*/
create table Income_Category(category_id int primary key,category_name varchar(50) not null unique,descriptionn varchar(200) not null,taxable boolean not null);
select * from Income_Category;
insert into Income_Category(category_id,category_name,descriptionn,taxable)values(1,"Salary","income recieved from employment",True),
(2,"Business","income received from property or rent",TRUE),(3,"House Property","Income received from property or rent",TRUE),
(4,"Capital Gains","income from transfer of eligible assets",TRUE),
(5,"Others sources","income such as bank interst",True),
(6,"Agricultural","income from eligible agricltural activities",false);



/*---ENtity3:Financial Year---*/

create table Financial_Year(year_id int primary key,year_label varchar(9) not null unique,state_date date not null,end_date date not null,filing_deadline date ,is_current boolean not null);
insert into Financial_year(year_id,year_label,state_date,end_date,filing_deadline,is_current)values(1,'2020-2021','2020-04-01','2021-03-31','2021-07-31',False),(2,'2021-2022','2021-04-01','2022-04-01','2022-07-31',false),
(3,'2022-2023','2022-04-01','2023-04-01','2024-07-31',false),(4,'2023-2024','2023-04-01','2024-03-31','2024-07-31',false),
(5,'2024-2025','2024-04-01','2025-03-31','2025-07-31',false);



/*---Entity 4: Income record---*/

create table Income_Record(income_id int primary key,taxpayer_id int not null,income_source varchar(100) not null,
category_name varchar(50) not null,amount decimal(12,2) not null,received_date date not null,financial_year varchar(9) not null);

INSERT INTO Income_Record
(income_id, taxpayer_id, income_source, category_name, amount, received_date, financial_year)
VALUES
(1001, 101, 'TechNova Solutions', 'Salary', 850000.00, '2026-03-31', '2025-2026'),
(1002, 102, 'City Care Hospital', 'Salary', 1200000.00, '2026-03-31', '2025-2026'),
(1003, 103, 'Reddy Enterprises', 'Business', 1800000.00, '2026-03-31', '2025-2026'),
(1004, 104, 'Sunrise School', 'Salary', 620000.00, '2026-03-31', '2025-2026'),
(1005, 105, 'Web Design Projects', 'Business', 750000.00, '2026-03-31', '2025-2026'),
(1006, 106, 'Professional Consulting', 'Business', 1500000.00, '2026-03-31', '2025-2026');




/*----PART D -DML tASKS---*/
insert into Taxpayer(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)values
(107,"ABCDE123x","Rohit sharma",'1985-12-31','Freelancer',700000.00,'rohit@example.com',TRUE);

update Taxpayer set annual_income=950000.00 where full_name="Ravi KUmar";
UPDATE Taxpayer
SET annual_income = 950000.00
WHERE taxpayer_id = 101;

UPDATE Taxpayer
SET occupation = 'Software Consultant'
WHERE taxpayer_id = 105;


UPDATE Taxpayer
SET is_active = TRUE
WHERE taxpayer_id = 106;



DELETE FROM Taxpayer
WHERE taxpayer_id = 107;


INSERT INTO Income_Category
(category_id, category_name, descriptionn, taxable)
VALUES
(7,'Rental Income','Income received from renting property',TRUE);


/*---Part E – DDL Tasks----*/
ALTER TABLE Taxpayer
ADD phone_number VARCHAR(15);


ALTER TABLE Income_Record
ADD remarks VARCHAR(200);


ALTER TABLE Taxpayer
MODIFY occupation VARCHAR(100);


CREATE TABLE Tax_Office
(
    office_id INT PRIMARY KEY,
    office_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);


INSERT INTO Tax_Office
VALUES
(1,'Hyderabad Tax Office','Hyderabad'),
(2,'Vijayawada Tax Office','Vijayawada');


TRUNCATE TABLE Tax_Office;

DROP TABLE Tax_Office;

/*---Part F – Constraint Observation---*/

INSERT INTO Taxpayer
VALUES
(101,'XYZAB1234P','Test User','1999-01-01','Engineer',500000.00,'test@example.com',TRUE);
/*--0	25	15:37:35	INSERT INTO Taxpayer
 VALUES
 (101,'XYZAB1234P','Test User','1999-01-01','Engineer',500000.00,'test@example.com',TRUE)	Error Code: 1136. Column count doesn't match value count at row 1	0.000 sec--*/


INSERT INTO Taxpayer
VALUES
(108,'ABCDE1234F','Another User','1998-02-15','Teacher',600000.00,'another@example.com',TRUE);

INSERT INTO Taxpayer
(taxpayer_id, pan_number, full_name, date_of_birth, occupation, annual_income, email, is_active)
VALUES
(109,'LMNOP5678Q',NULL,'1997-05-20','Doctor',900000.00,'doctor@example.com',TRUE);



