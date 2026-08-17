USE taxiation;
show tables;
/* partA -verify previous databse */
select * from financial_year;
select * from income_category; 
select * from income_record;
select * from taxpayer;
/* Part B – SQL JOIN Operations  */
/*Level 1 (Understanding) */


/*Task-1 Display every taxpayer along with the income source using an INNER JOIN.*/
select full_name  from taxpayer as t
inner join income_record as i
on t.taxpayer_id=i.taxpayer_id;

/*Task-2 Display every taxpayer along with the category of income they earn. */
select full_name,category_name from taxpayer as t
inner join income_category as i
on t.taxpayer_id=i.category_id;


/*Task-3 Display every income record along with its financial year. */
select i.income_source,f.year_label from income_record as i
inner join financial_year as f
on i.year_id=f.year_id;


/*Task-4 Display the taxpayer name together with the annual 
income and income amount recorded in the Income_Record 
table. */
select t.full_name,t.annual_income,i.amount from taxpayer as t
inner join income_record as i
on t.taxpayer_id=i.taxpayer_id; 


/*Task-5 Display the taxpayer name, income source, category 
name and financial year for every income record.*/
SELECT
    t.full_name,
    ir.income_source,
    c.category_name,
    fy.year_label
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
    ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
    ON ir.category_id = c.category_id
INNER JOIN Financial_Year AS fy
    ON ir.year_id = fy.year_id;
    
    
/*Level 2 (Application)*/
/*Task-1 Display all taxpayers who earn Salary income along with 
the organization from which they receive the income.*/
SELECT t.full_name,
       ir.income_source,
       c.category_name
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id
WHERE c.category_name = 'Salary';


/*Task-2 Display all taxpayers who earn Business income together 
with their occupation and income source.*/
select t.full_name,t.occupation,i.income_source,c.category_name from taxpayer as t
inner join income_record as i
on t.taxpayer_id=i.taxpayer_id
inner join income_category as c
on i.category_id=c.category_id
where c.category_name='Business';

/*Task-3 Display taxpayer details together with the financial year 
start date and end date. */


SELECT t.taxpayer_id,
       t.full_name,
       t.occupation,
       t.annual_income,
       fy.year_label,
       fy.state_date,
       fy.end_date
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Financial_Year AS fy
ON ir.year_id = fy.year_id;

/*Task-4 Display taxpayer details together with the description of 
the income category.*/
SELECT t.taxpayer_id,
       t.full_name,
       t.occupation,
       t.annual_income,
       c.category_name,
       c.descriptionn
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id;

/*Task-5 Display complete taxation information by joining 
Taxpayer, Income_Record, Income_Category, and Financial_Year. */
SELECT
    t.taxpayer_id,
    t.full_name,
    t.pan_number,
    t.occupation,
    t.annual_income,
    ir.income_source,
    ir.amount,
    c.category_name,
    c.descriptionn,
    fy.year_label,
    fy.state_date,
    fy.end_date
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id
INNER JOIN Financial_Year AS fy
ON ir.year_id = fy.year_id;

/*Level 3 (Medium to Advanced) */
/*Task-1 Display all taxpayers including those who have not yet 
submitted any income records.*/
SELECT
    t.taxpayer_id,
    t.full_name,
    t.occupation,
    ir.income_source,
    ir.amount
FROM Taxpayer AS t
LEFT JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id;
/*Task-2 Display all income categories including those that are not 
associated with any income records*/
SELECT
    c.category_id,
    c.category_name,
    c.descriptionn,
    ir.income_source,
    ir.amount
FROM Income_Category AS c
LEFT JOIN Income_Record AS ir
ON c.category_id = ir.category_id;
/*Task-3 Display all taxpayers and all income records, including 
unmatched records from both tables.*/
SELECT
    t.taxpayer_id,
    t.full_name,
    ir.income_id,
    ir.income_source,
    ir.amount
FROM Taxpayer AS t
LEFT JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id

UNION

SELECT
    t.taxpayer_id,
    t.full_name,
    ir.income_id,
    ir.income_source,
    ir.amount
FROM Taxpayer AS t
RIGHT JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id;
/*Task-4 Generate every possible combination of taxpayers and 
financial years. */
SELECT
    t.taxpayer_id,
    t.full_name,
    fy.year_id,
    fy.year_label
FROM Taxpayer AS t
CROSS JOIN Financial_Year AS fy;
/*Task-5 Display pairs of taxpayers having the same occupation 
without displaying the same taxpayer twice.*/
SELECT
    t1.taxpayer_id AS taxpayer1_id,
    t1.full_name AS taxpayer1_name,
    t2.taxpayer_id AS taxpayer2_id,
    t2.full_name AS taxpayer2_name,
    t1.occupation
FROM Taxpayer AS t1
INNER JOIN Taxpayer AS t2
ON t1.occupation = t2.occupation
AND t1.taxpayer_id < t2.taxpayer_id;
/*Additional Practice(optional) */
/*Task-6 Display the taxpayer name, PAN number, income source, 
income category and financial year in a single query.*/
SELECT
    t.full_name,
    t.pan_number,
    ir.income_source,
    c.category_name,
    fy.year_label
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id
INNER JOIN Financial_Year AS fy
ON ir.year_id = fy.year_id;
/*Task-7 Display all taxpayers together with their income category 
and category description.*/
SELECT
    t.full_name,
    c.category_name,
    c.descriptionn
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id;
/*task-8 Display the income source together with the financial year 
label.*/
SELECT
    ir.income_source,
    fy.year_label
FROM Income_Record AS ir
INNER JOIN Financial_Year AS fy
ON ir.year_id = fy.year_id;
/*Task-9 Display taxpayers whose income belongs to the Business 
category during the financial year 2025–2026. */

SELECT
    t.full_name,
    t.pan_number,
    ir.income_source,
    c.category_name,
    fy.year_label
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id
INNER JOIN Financial_Year AS fy
ON ir.year_id = fy.year_id
WHERE c.category_name = 'Business'
AND fy.year_label = '2025-2026';
/*Task-10 Display the complete taxation report containing taxpayer 
details, income details, category details and financial year 
details.*/
SELECT
    t.taxpayer_id,
    t.full_name,
    t.pan_number,
    t.occupation,
    t.annual_income,
    t.email,
    ir.income_id,
    ir.income_source,
    ir.amount,
    ir.received_date,
    c.category_id,
    c.category_name,
    c.descriptionn,
    c.taxable,
    fy.year_id,
    fy.year_label,
    fy.state_date,
    fy.end_date,
    fy.filing_deadline
FROM Taxpayer AS t
INNER JOIN Income_Record AS ir
ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category AS c
ON ir.category_id = c.category_id
INNER JOIN Financial_Year AS fy
ON ir.year_id = fy.year_id;