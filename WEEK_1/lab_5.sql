use taxiation;
show tables;
select * from financial_year;
select * from income_category;
select * from income_record;
select sum(amount) from income_record;
select count(income_source) from income_record;
select avg(amount) from income_record;
select max(amount) from income_record;
select min(amount) from income_record;

/* level 2*/
select count(amount) from income_record
group by (income_source);

select sum(amount) from income_record
group by (income_source);


select avg(amount) from income_record
group by (income_source);

select max(amount) from income_record
group by(income_source);

select min(amount) from income_record
group by (income_source);



select count(amount) from income_record
group by (year_id);

select sum(amount) from income_record
group by (year_id);

select avg(amount) from income_record
group by (year_id);

select min(amount) from income_record
group by (year_id);

select max(amount) from income_record
group by (year_id);

select sum(amount) from income_record
group by year_id,income_source;


/* level 3*/

select sum(amount) from income_record
group by (income_source)
having sum(amount)>1000000;


select avg(amount) from income_record
group by (income_source)
having avg(amount)>50000;

select count(amount) from income_record
group by (year_id)
having count(amount)>3;


select sum(amount) from income_record
group by (income_source)
order by sum(amount) desc;


select sum(amount) from income_record
group by (income_source)
having sum(amount)>50000
order by sum(amount) desc;


select sum(amount),avg(amount) from income_record
group by (income_source);



select sum(amount) from income_record
group by income_source,year_id
order by sum(amount) desc
limit 1;



SELECT I.year_id,
       COUNT(DISTINCT I.taxpayer_id) AS total_taxpayers
FROM Income_Record I
JOIN Taxpayer T
ON I.taxpayer_id = T.taxpayer_id
GROUP BY I.year_id;


/* level 4*/
select category_id,
       SUM(amount) AS total_income
from Income_Record
group by category_id
order by SUM(amount) desc
limit 1;


select year_id,
       SUM(amount) AS total_income
from Income_Record
group by year_id
order by SUM(amount) desc
limit 1;


select category_id,
       avg(amount) AS total_income
from Income_Record
group by category_id
order by avg(amount) desc
limit 1;


select count(amount) from income_record
group by (income_source)
having count(amount)>3;


SELECT year_id,
       SUM(amount) AS total_income
FROM Income_Record
GROUP BY year_id
HAVING SUM(amount) > 1000000;

select C.category_name,
       count(*) AS number_of_records,
       sum(I.amount) AS total_income,
       avg(I.amount) AS average_income,
       max(I.amount) AS highest_income,
       min(I.amount) AS lowest_income
from Income_Record I
join Income_Category C
on I.category_id = C.category_id
group by C.category_name;

