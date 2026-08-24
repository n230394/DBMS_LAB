USE taxiation;
show tables;
select * from financial_year;
select * from income_category;
select * from income_record;
select * from Taxpayer;

select * from income_record
where amount =(select max(amount) from income_record);


select * from income_record
where amount >(select avg(amount) from income_record);


select * from income_record
where amount =(select max(amount) from income_record);


select * from Taxpayer
where occupation in(select occupation from Taxpayer where occupation='Business owner');


/* levwl 2 */
select taxpayer_id,full_name from Taxpayer
where taxpayer_id in(select taxpayer_id from income_record);

select * from taxpayer
where taxpayer_id in( select taxpayer_id from income_record where category_id=2);


select * from income_record
where year_id=6;

select * from income_record
where year_id in (select year_id  from financial_year where year_id=6);



select * from income_record
where amount >(select min(amount) from income_record where  category_id=2);


select * from income_record
where amount <(select max(amount) from income_record where  category_id=1);


select * from income_record
where amount >(select avg(amount) from income_record);

select * from income_category
where category_id in( select category_id from income_record);


select * from income_category
where category_id not in( select category_id from income_record);


/* level_3 */
select * from Taxpayer
where taxpayer_id in(select taxpayer_id from income_record where amount=(select max(amount) from income_record));


select * from Taxpayer
where taxpayer_id in(select taxpayer_id from income_record where amount>(select avg(amount) from income_record
where category_id=2));


select * from Taxpayer
where taxpayer_id in(select taxpayer_id from income_record where amount>(select avg(amount) from income_record));


select  * from income_record where amount> any(select amount from income_record where category_id=3);

select * from income_record;
select  * from income_record where amount> all(select amount from income_record where category_id=3);


select * from financial_year
where year_id in(select year_id from income_record where amount=(select sum(amount) from income_record)
group by year_id);





