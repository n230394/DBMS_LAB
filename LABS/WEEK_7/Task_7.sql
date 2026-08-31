USE taxiation;
show tables;
select * from taxpayer;
select * from income_record;
select * from income_category;

/* Lvel 1  */
create view high_income as select * from income_record where amount=(select max(amount) from income_record);
create view low_income as select * from income_record where amount=(select min(amount) from income_record);
create view greater_than_avg as select * from income_record where amount>(select avg(amount) from income_record);
create view highest_income as select * from income_record where amount=(select max(amount) from income_record);
create view Bussiness_taxpayer as select * from taxpayer where occupation='Business Owner';


/* level 2 */

create view income_record_exist_for_taxpayer as select * from taxpayer where taxpayer_id in(select taxpayer_id from income_record );
create view business_category_taxpayer as select * from taxpayer where taxpayer_id in(
select taxpayer_id from income_record where category_id=2);


select * from financial_year;
 create view financial_year_2025 as select * from income_record where year_id in(
select f.year_id from financial_year  f
join income_record i on f.year_id=i.year_id
where year_label='2025-2026');




select * from income_record;
create view businnes_amount as select * from income_record where amount>(select min(amount) from income_record where category_id=2);
create view businnes_amount_salary as select * from income_record where amount<(select max(amount) from income_record where category_id=1);
create view taxpayer_amount as select * from taxpayer where taxpayer_id in(
select taxpayer_id from income_record where amount>(
select avg(amount) from income_record));
select * from income_category;

select * from income_category where category_id in(
select category_id from income_record);

select * from taxpayer where taxpayer_id not in(
select taxpayer_id from income_record where category_id=3);

select * from taxpayer where taxpayer_id not in(
select i.taxpayer_id from income_record i
join income_category ic
on i.category_id=ic.category_id
where category_name='Investment');


/* level -3 medium to advance */

select * from taxpayer where taxpayer_id in(
select taxpayer_id from income_record where amount=(select max(amount) from income_record));

select * from income_record where amount>(
select avg(amount) from income_record where category_id=2);


select * from taxpayer where annual_income>(
select avg(annual_income)from taxpayer);


select * from income_record where amoun>any(select amount from income_record where category_id=3);
select * from income_record where amount>all(select amount from income_record where category_id=3);

select * from income_category;
select * from income_record;
select * from income_category where category_id in(select category_id  from income_record where amount=(
select max(amount) from income_record));

select * from income_record;
select * from financial_year
where year_id in(
select year_id from income_record where amount>(
select sum(amount) from income_record
group by year_id));

select * from taxpayer where taxpayer_id in(
select taxpayer_id from income_record where amount=(select max(amount) from income_record));



/*  14. Real-World Taxation Analysis using Views */


