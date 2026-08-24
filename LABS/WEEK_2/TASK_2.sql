/*---DBMS Lab — Week 2: Queries, Subqueries, Set Operators, and Foreign 
Key Constraints using a Taxation Database


/*---Part A – Redesigning the Database---*/
USE taxiation;

select * from financial_year;
select * from Income_Record;




ALTER TABLE Income_Record
DROP COLUMN category_name;

ALTER TABLE Income_Record
DROP COLUMN financial_year;

ALTER TABLE Income_Record
ADD category_id INT,
ADD year_id INT;


ALTER TABLE Income_Record
ADD CONSTRAINT fk_taxpayer
FOREIGN KEY (taxpayer_id)
REFERENCES Taxpayer(taxpayer_id);

ALTER TABLE Income_Record
ADD CONSTRAINT fk_category
FOREIGN KEY (category_id)
REFERENCES Income_Category(category_id);

ALTER TABLE Income_Record
ADD CONSTRAINT fk_year
FOREIGN KEY (year_id)
REFERENCES Financial_Year(year_id);


UPDATE Income_Record
SET category_id = 1, year_id = 6
WHERE income_id = 1001;

UPDATE Income_Record
SET category_id = 1, year_id = 6
WHERE income_id = 1002;

UPDATE Income_Record
SET category_id = 2, year_id = 6
WHERE income_id = 1003;

UPDATE Income_Record
SET category_id = 1, year_id = 6
WHERE income_id = 1004;

UPDATE Income_Record
SET category_id = 2, year_id = 6
WHERE income_id = 1005;

UPDATE Income_Record
SET category_id = 2, year_id = 6
WHERE income_id = 1006;


insert into Financial_year(year_id,year_label,state_date,end_date,filing_deadline,is_current)values
(6, '2025-2026', '2025-04-01', '2026-03-31', '2026-07-31', TRUE);


/*---Part B – Verifying Foreign Keys---*/

INSERT INTO Income_Record
VALUES
(1007,999,'ABC Company',500000,'2026-03-31',1,6);
/*--error--*/
/*---Cannot add or update a child row:
a foreign key constraint fails.---*/


INSERT INTO Income_Record
VALUES
(1008,101,'ABC Company',500000,'2026-03-31',20,6);

/*---Cannot add or update a child row:
a foreign key constraint fails.---*/


INSERT INTO Income_Record
VALUES
(1009,101,'ABC Company',500000,'2026-03-31',1,15);

/*---Cannot add or update a child row:
a foreign key constraint fails.---*/

DELETE FROM Taxpayer
WHERE taxpayer_id = 101;

/*---Cannot add or update a child row:
a foreign key constraint fails.---*/
 
 
 DELETE FROM Income_Category
WHERE category_id = 1;



/*---What is a Foreign Key?

A Foreign Key is a column that links one table to another table's Primary Key.

What is Referential Integrity?

Referential Integrity ensures that every foreign key value matches an existing primary key value in the parent table.

Why are Foreign Keys required?

Prevent invalid data.
Maintain relationships between tables.
Improve data consistency.
Prevent accidental deletion of related records.---*/





/*--Part C – DISTINCT--*/


SELECT occupation FROM Taxpayer;
SELECT DISTINCT occupation
FROM Taxpayer;


SELECT DISTINCT category_name
FROM Income_Category;


SELECT DISTINCT year_label
FROM Financial_Year;


SELECT DISTINCT income_source
FROM Income_Record;/


,
/*-----Part D – UNION-----*/
SELECT t.full_name
FROM Taxpayer t
JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.category_id = 1

UNION

SELECT t.full_name
FROM Taxpayer t
JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id
WHERE i.category_id = 2;



SELECT income_source
FROM Income_Record
WHERE year_id = 5

UNION

SELECT income_source
FROM Income_Record
WHERE year_id = 6;


SELECT full_name
FROM Taxpayer
WHERE occupation = 'Teacher'
UNION
SELECT full_name
FROM Taxpayer
WHERE occupation = 'Software Engineer';
/*----Part E – INTERSECT -----*/
select * from taxpayer;
select * from income_record;
select * from financial_year;
select * from income_category;


SELECT t.taxpayer_id, t.full_name
FROM Taxpayer t
JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id
GROUP BY t.taxpayer_id, t.full_name
HAVING COUNT(DISTINCT ir.category_id) = 2;


SELECT taxpayer_id
FROM Income_Record
WHERE year_id IN (5,6)
GROUP BY taxpayer_id
HAVING COUNT(DISTINCT year_id) = 2;

/*-----Part F – EXCEPT (MINUS)-----*//*NOT WORKING---*/
/*--1.--*/
SELECT DISTINCT t.taxpayer_id, t.full_name
FROM Taxpayer t
JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id
WHERE ir.category_id = 1
AND t.taxpayer_id NOT IN
(
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id = 2
);
/*2*/
SELECT DISTINCT taxpayer_id
FROM Income_Record
WHERE year_id = 6
AND taxpayer_id NOT IN
(
    SELECT taxpayer_id,
    FROM Income_Record
    WHERE year_id = 5
);

/*-----Part G – Nested Queries using IN----*/

SELECT full_name
FROM Taxpayer
WHERE taxpayer_id IN
(
    SELECT taxpayer_id
    FROM Income_Record
);



SELECT full_name, occupation
FROM Taxpayer
WHERE occupation IN
(
    SELECT DISTINCT t.occupation
    FROM Taxpayer t
    JOIN Income_Record ir
        ON t.taxpayer_id = ir.taxpayer_id
    WHERE ir.category_id = 2
);


/*-----Part H – Nested Queries using NOT IN----*/
SELECT taxpayer_id, full_name
FROM Taxpayer
WHERE taxpayer_id NOT IN
(
    SELECT taxpayer_id
    FROM Income_Record
);


SELECT category_id, category_name
FROM Income_Category
WHERE category_id NOT IN
(
    SELECT category_id
    FROM Income_Record
);


SELECT occupation from Taxpayer where occupation not in (select distinct t.occupation from Taxpayer t
join Income_Record ir on t.taxpayer_id=ir.taxpayer_id);


/*----Part I – EXISTS -----*/
SELECT t.taxpayer_id, t.full_name
FROM Taxpayer t
WHERE EXISTS
(
    SELECT 1
    FROM Income_Record ir
    WHERE ir.taxpayer_id = t.taxpayer_id
); 


SELECT c.category_id, c.category_name
FROM Income_Category c
WHERE EXISTS
(
    SELECT 1
    FROM Income_Record ir
    WHERE ir.category_id = c.category_id
);


/*------Part J – NOT EXISTS-----*/

SELECT t.taxpayer_id, t.full_name
FROM Taxpayer t
WHERE NOT EXISTS
(
    SELECT 1
    FROM Income_Record ir
    WHERE ir.taxpayer_id = t.taxpayer_id
);

SELECT c.category_id, c.category_name
FROM Income_Category c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Income_Record ir
    WHERE ir.category_id = c.category_id
);

/*----Part K – ANY-----*/

SELECT taxpayer_id, full_name, annual_income
FROM Taxpayer
WHERE annual_income > ANY
(
    SELECT annual_income
    FROM Taxpayer
    WHERE annual_income < 1000000
);

SELECT income_id, taxpayer_id, amount
FROM Income_Record
WHERE amount > ANY
(
    SELECT amount
    FROM Income_Record
    WHERE category_id = 1
);

/*----Part L – ALL-----*/

SELECT taxpayer_id, full_name, annual_income
FROM Taxpayer
WHERE annual_income > ALL
(
    SELECT annual_income
    FROM Taxpayer
    WHERE annual_income < 1000000
);

SELECT income_id, taxpayer_id, amount
FROM Income_Record
WHERE amount > ALL
(
    SELECT amount
    FROM Income_Record
    WHERE category_id = 1
);

/**------Part M – Additional Query Practice---------*/
/*1.*/
SELECT t.taxpayer_id,
       t.full_name,
       ir.income_source,
       ir.amount
FROM Taxpayer t
JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id;
/*---2.---*/
SELECT t.taxpayer_id,
       t.full_name,
       SUM(ir.amount) AS total_income
FROM Taxpayer t
JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id
GROUP BY t.taxpayer_id, t.full_name;
/*--3--*/
SELECT taxpayer_id,
       full_name,
       annual_income
FROM Taxpayer
WHERE annual_income > 1000000;
/*--4--*/
SELECT category_id,
       category_name
FROM Income_Category
WHERE taxable = TRUE;
/*---5--*/
SELECT year_id,
       year_label
FROM Financial_Year
WHERE is_current = TRUE;

/*--6--*/
SELECT t.full_name,
       c.category_name
FROM Taxpayer t
JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id
JOIN Income_Category c
ON ir.category_id = c.category_id;

/*---7---*/
SELECT MAX(amount) AS highest_income
FROM Income_Record;

/*---8---*/
SELECT MIN(amount) AS lowest_income
FROM Income_Record;

/*---9---*/
SELECT AVG(amount) AS average_income
FROM Income_Record;

/*--10---*/
SELECT COUNT(*) AS total_taxpayers
FROM Taxpayer;


/*------Part N – Mini Challenge------*/
/*--1--*/
SELECT taxpayer_id,
       full_name,
       annual_income
FROM Taxpayer
WHERE annual_income =
(
    SELECT MAX(annual_income)
    FROM Taxpayer
);


/*----2---*/
SELECT c.category_name,
       COUNT(*) AS total_records
FROM Income_Record ir
JOIN Income_Category c
ON ir.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_records DESC
LIMIT 1;

/*---3---*/
SELECT occupation,
       COUNT(*) AS total_taxpayers
FROM Taxpayer
GROUP BY occupation;

/*---4---*/
SELECT COUNT(*) AS active_taxpayers
FROM Taxpayer
WHERE is_active = TRUE;

/*----5----*/
SELECT fy.year_label,
       COUNT(*) AS total_records
FROM Income_Record ir
JOIN Financial_Year fy
ON ir.year_id = fy.year_id
GROUP BY fy.year_id, fy.year_label
ORDER BY total_records DESC
LIMIT 1;