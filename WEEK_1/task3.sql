USE TAXIATION;
/*------Part A – Verify Week-1 Database----------*/

SHOW TABLES;

/*----Part B – Built-in String Functions-----*/
/** Level 1 (Understanding)---*/
Select * FROM taxpayer;
select upper(full_name)from taxpayer;
select lower(occupation)from  taxpayer;
select left(full_name,4)from taxpayer;
select concat(full_name,occupation) from taxpayer;
/*---Level 2 (Application)----*/
show tables;
select * from income_category;
select * from income_record;
select concat(category_name, " inc")from income_category;
select trim(full_name)from taxpayer;
select substring_index(full_name,' ',1)from taxpayer;
/*----Level 3 (Advanced) ----*/
select concat(
     "Taxpayer :",full_name,
     "occupation :",occupation) as displayname from taxpayer;

select * from taxpayer where right(full_name,2)="AP";
select full_name from taxpayer;

/*----Part C – Built-in Numeric Functions----*/
/*  Level 1 ----*/
select * from income_record;
select * from income_category;
select round(amount)from income_record;
select abs(amount)from income_record;
select round(power(round(amount),2))from income_record;

/*---Level 3 ----*/
select round(rand()*100+1);
select round(sqrt(amount))from income_record;
select * from taxpayer;
select (annual_income*1.10) from taxpayer;

/*----Part D – Date Functions----*/
select curdate();
select concat(current_date(), ' ',current_time());
show tables;
select * from financial_year;
select year(state_date)from  financial_year;
select month(state_date)from  financial_year;
select  day(state_date)from  financial_year;

/*   Level 2  */
select date_add(state_date,interval 1 year)as end_date from financial_year;
select date_add(state_date,interval 30 month)as end_date from financial_year;
select date_sub(state_date,interval 7 day) as end_date from financial_year;
/*  Level 3  */
select datediff(state_date,end_date) as diff from financial_year;
select * from financial_year where year(end_date)=year(curdate());


/* Part E – Conversion Functions   */
/*Level 1 */
show tables;
select * from taxpayer;
select cast(annual_income as signed)from taxpayer;
select cast(taxpayer_id as char)from taxpayer;
select * from financial_year;
select cast(end_date as datetime)from financial_year;
select cast(state_date as datetime)from financial_year;
/* level 3  */
show tables;
select * from income_category;
select cast(annual_income as char)from taxpayer;
select cast(taxable as signed) from taxpayer;







