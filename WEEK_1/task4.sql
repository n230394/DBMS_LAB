USE TAXIATION;
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
select income_source,year_label from income record as i
inner join financial_year as f
on i.year_id==f.year_id;


