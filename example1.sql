select * from dual;
select 'TEST' from dual;
select user from dual;
select rownum from dual;
select rowid from dual;
select 1+9/4, trunc(1+9/4) from dual;
select DBMS_RANDOM.RANDOM from dual;

select 'true' from dual where 1 = 1;
select 'true' from dual where 1 = 2;
select 'true' from dual where null = null;

select sysdate from dual;
select SYSTIMESTAMP from dual;





--------------------------------------
-- TIME fce
select aa fce,bb sys ,cc db from
(
select '-' aa,                        'SYS*' bb,                               'CURRENT*' cc                                ,1 ord from dual union
select '*date',                         to_char(sysdate),                       to_char(CURRENT_DATE)                       ,2 ord from dual union
select '*timestamp',                    to_char(SYSTIMESTAMP),                  to_char(CURRENT_TIMESTAMP)                  ,3 ord from dual union
select 'SYS_EXTRACT_UTC(*timestamp))',  to_char(SYS_EXTRACT_UTC(SYSTIMESTAMP)), to_char(SYS_EXTRACT_UTC(CURRENT_TIMESTAMP)) ,4 ord from dual union
select '*timezone',                     to_char(SYSTIMESTAMP,'TZR'),             to_char(SESSIONTIMEZONE)                   ,5 ord from dual) order by ord;

ALTER SESSION SET TIME_ZONE = '10:0';
--ALTER DATABASE SET TIME_ZONE = '0:0';


