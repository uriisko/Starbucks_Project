
--- tableau vizualization 1 - stores by region and ownership type

select region, ownership_type, sum(Q4_fy22) as total
from master_table
where ownership_type = 'Company operated'
group by ownership_type, region
Union 
select region, ownership_type, sum(Q4_fy22) as total
from master_table
where ownership_type = 'Licenced stores'
group by ownership_type, region
order by 1

-- How many stores in USA, How much in China, What's the percentage of total stores?

create view V_All as
(
select country, sum(Q4_FY22) as Stores
from master_table
group by country
Having country in ('United States', 'China')
Union
select 'other' as country, sum(Q4_FY22) as stores
from master_table
where country not in ('United States', 'China'))

select A.*, cast((cast(A.stores as float) / cast(A.total_stores as float))*100 as decimal (6,2)) as 'pct%'
from(
select*, sum(stores) over (order by (select null)) as Total_Stores
from V_All) A

-- another try

select  A.*, cast((cast(A.stores as float) / cast(A.total_stores as float)) as decimal (6,2)) as 'pct%'
From
(
select top 2 country, sum(Q4_FY22) stores, sum(sum(Q4_FY22)) over(order by (select null)) as total_stores
from master_table
group by country
order by 2 desc ) A