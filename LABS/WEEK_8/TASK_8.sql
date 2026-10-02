use taxiation;
show tables;

SET AUTOCOMMIT=0;
select @@autocommit;
select * from income_record;


/* task 1,2*/
start transaction ;

update income_record set amount=900000 where income_id=1001;
select * from income_record where income_id=1001;
commit;
select * from income_record where income_id=1001;


/* task 3 */
start transaction ;
update income_record set amount=500000 where income_id=1001;
select * from income_record where income_id=1001;
rollback;
select * from income_record where income_id=1001;



/* task 4*/
start transaction;
insert into income_record(income_id,taxpayer_id,income_source,amount,received_date,remarks,category_id,year_id)
values(1007, 101, 'Part Time Income',300000, '2026-03-31',"",1, 6);
select * from income_record;
rollback;
select * from income_record;


/* task 5*/

start transaction;
delete from  income_record where  income_id=1001;
select * from income_record;
rollback;
select * from income_record;

/* task 6 */
start transaction;
UPDATE Income_Record
SET amount = 920000
WHERE income_id = 1001;

insert into income_record(income_id,taxpayer_id,income_source,amount,received_date,remarks,category_id,year_id)
values(1007, 101, 'Part Time Income',300000, '2026-03-31',"",1, 6);

select * from income_record;
commit;
select * from income_record;



/* Part C – TCL: Savepoints */

start transaction;
update income_record
set amount = 950000
where income_id = 1001;
savepoint sp1;

update income_record
set amount = 1300000
where income_id = 1002;

select * from income_record
where income_id in (1001, 1002);

rollback to savepoint sp1;
select *
from income_record
where income_id in (1001, 1002);


/* task 2*/
start transaction;

insert into income_record
(income_id, taxpayer_id, income_source, category_id, amount, received_date, year_id)
values
(1009, 101, 'Bonus Income', 1, 50000, '2026-03-31', 6);

savepoint sp1;

update income_record
set amount = 1400000
where income_id = 1002;

rollback to savepoint sp1;

select * from  income_record;


/* task 3*/
start transaction;

update income_record
set amount = 960000
where income_id = 1001;

savepoint sp1;

update income_record
set amount = 1250000
where income_id = 1002;

savepoint sp2;

update income_record
set amount = 1850000
where income_id = 1003;

rollback to savepoint sp1;

select *
from income_record
where income_id in (1001, 1002, 1003);




/* task 4*/
start transaction;

insert into income_record
(income_id, taxpayer_id, income_source, category_id, amount, received_date, year_id)
values
(1010, 101, 'Bonus Income', 1, 50000, '2026-03-31', 6);

update income_record
set amount = 950000
where income_id = 1001;

savepoint sp1;

delete from income_record
where income_id = 1006;

rollback to savepoint sp1;

select *
from income_record
where income_id in (1001, 1006, 1010);

commit;



/* task 5*/
start transaction;

update income_record
set amount = 970000
where income_id = 1001;

savepoint sp1;

release savepoint sp1;

rollback to savepoint sp1;



/* task 6*/
start transaction;

update income_record
set amount = 980000
where income_id = 1001;

savepoint sp1;

update income_record
set amount = 1350000
where income_id = 1002;

-- rollback to savepoint: only the second update is cancelled
rollback to savepoint sp1;

select *
from income_record
where income_id in (1001, 1002);

-- rollback: the entire transaction is cancelled
rollback;

select *
from income_record
where income_id in (1001, 1002);


//* part d – dcl: users and privileges */

revoke all privileges, grant option
from 'tax_clerk1'@'localhost';

show grants for 'tax_clerk1'@'localhost';


/* task 2 */

grant select on taxiation.taxpayer
to 'tax_clerk1'@'localhost';

show grants for 'tax_clerk1'@'localhost';


/* task 3 */

grant insert on taxiation.income_record
to 'tax_clerk1'@'localhost';

show grants for 'tax_clerk1'@'localhost';

/* task 4 */
select current_user();
update income_record
set amount = 900000
where income_id = 1001;
/* task 5 */
create or replace view Taxpayer_Income_Summary as
select taxpayer_id, sum(amount) as total_income
from Income_Record
group by taxpayer_id;

grant select on taxiation.Taxpayer_Income_Summary
to 'tax_clerk1'@'localhost';

show grants for 'tax_clerk1'@'localhost';

select *
from Taxpayer_Income_Summary;
/* task 6 */
revoke insert on taxiation.income_record
from 'tax_clerk1'@'localhost';

show grants for 'tax_clerk1'@'localhost';

/* Part E – DCL: Security and Least Privilege */

create user 'tax_data_entry'@'localhost'
identified by 'Tax@123';

grant select, insert
on taxiation.income_record
to 'tax_data_entry'@'localhost';

show grants for 'tax_data_entry'@'localhost';

select current_user();
/* task 2*/

create user 'tax_officer'@'localhost'
identified by 'Tax@456';

grant select, insert, update
on taxiation.income_record
to 'tax_officer'@'localhost';

show grants for 'tax_officer'@'localhost';

select *
from income_record;

insert into income_record
(income_id, taxpayer_id, income_source, category_id, amount, received_date, year_id)
values
(1017, 102, 'Bonus Income', 1, 60000, '2026-03-31', 6);

update income_record
set amount = 1250000
where income_id = 1002;

delete from income_record
where income_id = 1017;

/* task 3 */
create or replace view Taxpayer_Income_Summary as
select taxpayer_id,
       sum(amount) as total_income
from Income_Record
group by taxpayer_id;

grant select
on taxiation.Taxpayer_Income_Summary
to 'tax_officer'@'localhost';

show grants for 'tax_officer'@'localhost';

/* task 4 */
create user 'tax_user'@'localhost'
identified by 'Tax@789';

grant select, insert, update
on taxiation.income_record
to 'tax_user'@'localhost';

show grants for 'tax_user'@'localhost';

revoke update
on taxiation.income_record
from 'tax_user'@'localhost';

show grants for 'tax_user'@'localhost';

select *
from income_record;

-- INSERT should work
insert into income_record
(income_id, taxpayer_id, income_source, category_id, amount, received_date, year_id)
values
(1018, 103, 'Other Income', 5, 30000, '2026-03-31', 6);

-- UPDATE should be denied
update income_record
set amount = 1850000
where income_id = 1003;

/* task 5 */
show grants for 'tax_data_entry'@'localhost';

show grants for 'tax_officer'@'localhost';