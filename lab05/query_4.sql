EXPLAIN PLAN FOR
    SELECT      AVG(e.sal)
    FROM        emp e
    WHERE       e.deptno < 10
    AND         e.sal > 100
    AND         e.sal < 200;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |     1 |     6 |   139   (1)| 00:00:01 |
|   1 |  SORT AGGREGATE    |      |     1 |     6 |            |          |
|*  2 |   TABLE ACCESS FULL| EMP  |    57 |   342 |   139   (1)| 00:00:01 |
---------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter("E"."DEPTNO"<10 AND "E"."SAL"<200 AND "E"."SAL">100)

*/

CREATE INDEX emp_index ON emp(sal, deptno);

EXPLAIN PLAN FOR
    SELECT      AVG(e.sal)
    FROM        emp e
    WHERE       e.deptno < 10
    AND         e.sal > 100
    AND         e.sal < 200;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |     6 |     8   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE   |         |     1 |     6 |            |          |
|*  2 |   INDEX RANGE SCAN| EMP_SAL |    57 |   342 |     8   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("E"."SAL">100 AND "E"."SAL"<200 AND "E"."DEPTNO"<10)
       filter("E"."DEPTNO"<10)

*/

DROP INDEX emp_index;