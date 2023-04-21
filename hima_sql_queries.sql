create database db ;
use db ;
-- drop database hima 
select  * from db.deaths  ;
select  * from db.expeditions  ;
select  * from db.peaks  ;


/*popular seasons to climb*/
----------------------------------------------------------------------------------------------------------
select season ,count(season)  as season_count from  db.expeditions
group by season ;

------------------------------------------------------------------------------------------------------------

 
----------------------------------------------------------------------------------------------------------------

select peak_name,season,count(peak_id) as no_of_expeditions
from db.expeditions
where peak_name in( select peak_name
from(select peak_name,count(peak_id) as no_of_expeditions,
rank()over(order by count(peak_id) desc)rnk
from db.expeditions
group by peak_name
order by count(peak_id) desc) rnk_table
where rnk<11)
group by peak_name,season
order by count(peak_id) desc;


------------------------------------------------------------------------------------------------------------
/*peak_wise top 3 participating countries*/


select peak_name,nationality,no_of_expeditions
from (select peak_name,nationality,count(peak_id) as no_of_expeditions,
dense_rank() over ( partition by peak_name order by count(peak_id) desc ) as rnk
from db.expeditions
where peak_name in(select peak_name from (select peak_name,count(peak_id) as no_of_expeditions,
rank()over (order by count(peak_id)  desc) as rnk1
from db.expeditions
group by count(peak_id) )as  rnk1_table
where rnk1 <11)
group by peak_name,nationality )as  rnk1_table
where rnk <4;


select peak_name,nationality,no_of_expeditions
from(
select peak_name,nationality,count(peak_id) as no_of_expeditions,
dense_rank()over(partition by peak_name order by count(peak_id) desc)rnk
from db.expeditions
where peak_name in(
select peak_name from (select peak_name,count(peak_id) as no_of_expeditions,
rank()over (order by count(peak_id)  desc)rnk1
from db.expeditions
group by peak_name) rnk1_table
where rnk1<11)
group by peak_name,nationality) as rnk_table
where rnk<4;


select peak_name,nationality,count(peak_id) as no_of_expeditions,
dense_rank()over(partition by peak_name order by count(peak_id) desc)rnk
from db.expeditions
group by nationality ,peak_name;

select peak_name,count(peak_id) as no_of_expeditions,
rank()over (order by count(peak_id)  desc)rnk1
from db.expeditions
group by peak_name;


-------------------------------------------------------------------------------------
/*Past ten years number of expeditions*/

select year,count(peak_id) as no_of_expeditions
from db.expeditions
group by year
order by year 
limit 10;

---------------------------------------------------------------------------------------------
/*The most popular host countries*/
with cte as (
select peak_name,host_cntr,count(peak_id) as no_of_expeditions,rank()over(order by count(peak_id) desc) as rnk
from db.expeditions
group by peak_name,host_cntr 
order by no_of_expeditions desc)
select * from cte 
where rnk <11 ;


select peak_name,host_cntr,count(peak_id) as no_of_expeditions
from db.expeditions
where peak_name in( select peak_name
from(select peak_name,count(peak_id) as no_of_expeditions,
rank()over(order by count(peak_id) desc)rnk
from db.expeditions
group by peak_name
order by count(peak_id) desc) rnk_table
where rnk<11)
group by peak_name,host_cntr
order by count(peak_id) desc;



----------------------------------------------------------------------------------------------

/*cause of death*/

select cause_of_death,count(peak_id) as no_of_expeditions
from db.deaths
where peak_name in( select peak_name
from(select peak_name,count(peak_id) as no_of_expeditions,
rank()over(order by count(peak_id) desc)rnk
from db.expeditions
group by peak_name
order by count(peak_id) desc) rnk_table
where rnk<11)
group by cause_of_death
order by count(peak_id) desc;

---------------------------------------------------------------------------------------------

/*Top 3 routes peak-wise*/

select peak_name,count(peak_id)as no_of_expeditions,(rte_1_name) as route_name
from  db.expeditions
group by peak_name ,rte_1_name ;

with cte as (
select peak_name,rte_1_name,count(peak_id) as no_of_expeditions,
dense_rank() over(partition by peak_name order by count(peak_id) desc) as rnk
from db.expeditions
group by peak_name ,rte_1_name)
select * from cte 
where rnk =1;

select peak_name,count(peak_id) as no_of_expeditions,
rank()over(order by count(peak_id) desc)rnk
from db.expeditions
group by peak_name;

select peak_name,no_of_expeditions,(rte_1_name) as route_name
from(
select peak_name,rte_1_name,count(peak_id) as no_of_expeditions,
dense_rank() over(partition by peak_name order by count(peak_id) desc)rnk1
from db.expeditions
where rte_1_name is not null and peak_name in( select peak_name
from(select peak_name,count(peak_id) as no_of_expeditions,
rank()over(order by count(peak_id) desc) as rnk
from db.expeditions
group by peak_name)rnk_table
where rnk<11)
group by peak_name,rte_1_name)rnk1_table
where rnk1<4
order by peak_name;


