create database  jointble ;
use jointble;
-- drop database worker ;

CREATE TABLE tb (
	tb1 INT NOT NULL
);
INSERT INTO tb
	(tb1) VALUES
		(1),(1),(1),(2),(2),(3),(4),(5);
        -- drop table tb2 ;    
        
CREATE TABLE tb2 (
	tb1 INT NOT NULL
);
INSERT INTO tb2
	(tb1) VALUES
		(1),(1),(2),(2),(2),(3),(3),(3),(4);

        select * from tb;
		select * from tb2;
        
 -- Left Join'
 select t1.tb1 from tb t1  left join tb2 t2 on  t1.tb1=t2.tb1 ;
 
  -- Inner Join
  
 select * from tb t1 join tb2 t2 on  t1.tb1=t2.tb1 ;
 
 -- Right Join
  select t2.tb1 from tb t1 right join tb2 t2 on  t1.tb1=t2.tb1 ;