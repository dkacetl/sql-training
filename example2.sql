------------------------
--HRA PRSI
------------------------

--------
-- typy
select 'sedma' typ from dual union 
select 'osma' typ from dual union 
select 'devitka' typ from dual union 
select 'desitka' typ from dual union 
select 'spodek' typ from dual union 
select 'filek' typ from dual union 
select 'kral' typ from dual union
select 'eso' typ from dual; 

---------
-- barvy
select 'SRDCE' barva from dual union 
select 'LISTY' barva from dual union 
select 'KULE' barva from dual union
select 'ZALUDY' barva from dual; 

-------------
-- typ + sila
select 1 sila, 'sedma' typ from dual union 
select 2 sila, 'osma' typ from dual union 
select 3 sila, 'devitka' typ from dual union 
select 4 sila, 'desitka' typ from dual union 
select 5 sila, 'spodek' typ from dual union 
select 6 sila, 'filek' typ from dual union 
select 7 sila, 'kral' typ from dual union
select 8 sila, 'eso' typ from dual; 

----------------
-- viev KARTY
create view karty as 
select barva.barva, typ.typ, typ.sila 
from 
  ( select 'SRDCE' barva from dual union 
    select 'LISTY' barva from dual union 
    select 'KULE' barva from dual union
    select 'ZALUDY' barva from dual
  ) barva,

  ( select 1 sila, 'sedma' typ from dual union 
    select 2 sila, 'osma' typ from dual union 
    select 3 sila, 'devitka' typ from dual union 
    select 4 sila, 'desitka' typ from dual union 
    select 5 sila, 'spodek' typ from dual union 
    select 6 sila, 'filek' typ from dual union 
    select 7 sila, 'kral' typ from dual union
    select 8 sila, 'eso' typ from dual
  ) typ;


select * from karty;
---------------------------------
-- nejsilnejsi karty (odbocka)

select max(karty.sila) hodnota from karty; -- nejvetsi sila v balicku


-- kart. soucin
select * from karty, (select max(karty.sila) hodnota from karty) max_sila; 


-- vysledek
select karty.* from karty, (select max(karty.sila) hodnota from karty) max_sila
where max_sila.hodnota = karty.sila; 



-----------------------------------------------------------
-- NAHODNE KARTY - GENERATOR

select karty.* from karty order by DBMS_RANDOM.RANDOM; -- nahodne karty





create view nahodne_karty as
select nahodne_karty.barva, nahodne_karty.typ, 
       rownum poradi
from
  (select karty.* from karty order by DBMS_RANDOM.RANDOM) nahodne_karty;




-------------------------------------------------------------
-- vytvorit instanci hry
create table aktualni_balicek as
select * from nahodne_karty;

select * from aktualni_balicek;

-------------------------------------------------------------
-- rozdat hracum 4 karty

select aktualni_balicek.barva, aktualni_balicek.typ, 
--       poradi,    
--       poradi/4,
--       trunc(poradi/4), 
       trunc((poradi+3)/4) hrac
from
  aktualni_balicek;

-------------------------------------------------------------
-- rozdane karty
create view aktualni_rozdane_karty as
select aktualni_balicek.barva, aktualni_balicek.typ, 
       trunc((rownum+3)/4) hrac
from
  aktualni_balicek;


select * from aktualni_rozdane_karty;

select aktualni_rozdane_karty.*, rownum poradi from aktualni_rozdane_karty where hrac = 1;
select aktualni_rozdane_karty.*, rownum poradi from aktualni_rozdane_karty where hrac = 2;
select aktualni_rozdane_karty.*, rownum poradi from aktualni_rozdane_karty where hrac = 3;

----------------------------------------------
-- 1. karta hrac1;   karta hrac2;    karta hrac3
-- 2. karta hrac1;   karta hrac2;    karta hrac3
-- 3. karta hrac1;   karta hrac2;    karta hrac3
-- 4. karta hrac1;   karta hrac2;    karta hrac3

---------------------------------------------
-- bizardni transpozice
select hrac1.barva ||' '|| hrac1.typ hrac1,
       hrac2.barva ||' '|| hrac2.typ hrac2,
       hrac3.barva ||' '|| hrac3.typ hrac3 
from 
(select aktualni_rozdane_karty.*, rownum poradi from aktualni_rozdane_karty where hrac = 1) hrac1,
(select aktualni_rozdane_karty.*, rownum poradi from aktualni_rozdane_karty where hrac = 2) hrac2,
(select aktualni_rozdane_karty.*, rownum poradi from aktualni_rozdane_karty where hrac = 3) hrac3
where hrac1.poradi = hrac2.poradi and hrac2.poradi = hrac3.poradi;


--------------------
-- drop
drop view aktualni_rozdane_karty;
drop table aktualni_balicek;
drop view nahodne_karty;
drop view karty;



