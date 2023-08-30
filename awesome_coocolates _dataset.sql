-- connecate  with data base 
use awesome chocolates ;
-- show excited tables 
show tables ;

-- describe tables
desc  geo ;
desc  people ;
desc  products ;
desc  sales ;

-- handle with tables 
select * from geo ;
select * from people  ;
select * from products ;
select * from sales ;
-- use where clause 
select * from sales 
where amount>10000;
-- use oreder by 
select * from sales 
where amount > 10000
order by amount ;

select * from sales 
where amount > 10000
order by amount desc ;
select * from sales 
where GeoID = 'g1' 
order by PID , amount desc ;

select * from sales 
where amount >10000 &&  SaleDate >='2022-01-01' 
order by amount ;

select * from sales 
where year(saledate) =2022 and amount >10000
order by amount ;

-- extract amount per box
select amount , boxes , amount/boxes 'amount per boxes ' from sales ;

-- find out all amount  when number of boxes between 0 and 50
select amount from sales 
where boxes >=0 and boxes<=50 ;

select amount from sales 
where boxes between 0 and 50 ;

-- find out amount when day is friday 
select * from sales 
where weekday(SaleDate) =4 ;

select * from people 
where team ='delish' or team ='jucies' ;

select * from people 
where team in ('delish', 'jucies');

select salesperson from people 
where Salesperson like 'k%' ;

select salesperson from people 
where Salesperson like '%e' ;

-- case operatoe 
select Amount,
	case when  amount <1000 then 'small amount'

		 when   amount >1000 and amount <5000 then 'medium amount '
	  else 'large amount' 
    end as 'Amount_Catogrey'  
    
from sales;


 
-- joins 
select s.Amount ,  p.product ,pe.team,g.geo
from sales as s
join products as p on S.PID =P.PID
join people as pe on s.SPID=pe.SPID 
join geo as g on s.GeoID =g.GeoID 
where amount< 5000 
and pe.team != '' 
and g.geo in ('usa','india')
 order by g.geo , s.amount ;
 
 -- use group by 
 select sum(amount) 'amount' ,sum(boxes) as boxes ,geo from sales as s
 join geo as g on s.geoid=g.geoid 
 group by geo ;
 
 select sum(amount) , team
from sales  s 
join people pe  on pe.SPID=s.spid 
group by team 
having  team != '' and sum(amount)>11000000 ;

select sum(amount) 'all amount' ,product from sales s
join  products  p on p.pid =s.pid 
group by product
having sum(amount) >2023100
order by 'all amount' ;

-- create a temporary table and aggregate data with partition by

with new_table (geo,product,amount, amount_geo, amount_product )
as 
( 
select g.geo , pr.product , s.amount  ,
sum(amount) over(partition by geo  order by amount ,geo,product )  'amount_geo' ,
sum(Amount) OVER (partition by product ) 'amount_product '
from sales s
join people pe on pe.spid=s.spid 
join geo g on g.geoid=s.geoid 
join products pr on pr.pid=s.pid
-- order by amount,'all amount by geo'
)

create table new_table (geo text ,product text,amount int , amount_geo int, amount_product int );
insert into new_table select g.geo , pr.product , s.amount  ,
sum(amount) over(partition by geo  order by amount ,geo,product )  'amount_geo' ,
sum(Amount) OVER (partition by product ) 'amount_product '
from sales s
join people pe on pe.spid=s.spid 
join geo g on g.geoid=s.geoid 
join products pr on pr.pid=s.pid;
select * from new_table order by geo, amount;
 
 
-- create view 
create view new_view as 
select g.geo , pr.product , s.amount  ,
sum(amount) over(partition by geo  order by amount ,geo,product ) as amount_geo ,
sum(Amount) OVER (partition by product )  as amount_product 
from sales s
join people pe on pe.spid=s.spid 
join geo g on g.geoid=s.geoid 
join products pr on pr.pid=s.pid
-- order by amount,'all amount by geo' 
;
 
select * from new_view order by geo,amount ; 



