EXPLAIN PLAN FOR
    SELECT      ename, job, sal, dname
    FROM        emp e, dept d
    WHERE       e.deptno = d.deptno
    AND         NOT EXISTS  (SELECT *
                             FROM salgrade
                             WHERE e.sal = hisal);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

---------------------------------------------------------------------------------
| Id  | Operation            | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |          | 50012 |  2246K|   145   (1)| 00:00:01 |
|*  1 |  HASH JOIN RIGHT ANTI|          | 50012 |  2246K|   145   (1)| 00:00:01 |
|   2 |   TABLE ACCESS FULL  | SALGRADE |   999 |  2997 |     3   (0)| 00:00:01 |
|*  3 |   HASH JOIN          |          | 50012 |  2100K|   142   (1)| 00:00:01 |
|   4 |    TABLE ACCESS FULL | DEPT     |   507 |  7098 |     3   (0)| 00:00:01 |
|   5 |    TABLE ACCESS FULL | EMP      | 50111 |  1419K|   139   (1)| 00:00:01 |
---------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."SAL"="HISAL")
   3 - access("E"."DEPTNO"="D"."DEPTNO")

*/

EXPLAIN PLAN FOR
    SELECT      /*+ NO_USE_HASH(e d) */ ename, job, sal, dname
    FROM        emp e, dept d
    WHERE       e.deptno = d.deptno
    AND         NOT EXISTS  (SELECT *
                             FROM salgrade
                             WHERE e.sal = hisal);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              | 50012 |  2246K|       |   548   (1)| 00:00:01 |
|*  1 |  HASH JOIN RIGHT ANTI         |              | 50012 |  2246K|       |   548   (1)| 00:00:01 |
|   2 |   TABLE ACCESS FULL           | SALGRADE     |   999 |  2997 |       |     3   (0)| 00:00:01 |
|   3 |   MERGE JOIN                  |              | 50012 |  2100K|       |   545   (1)| 00:00:01 |
|   4 |    TABLE ACCESS BY INDEX ROWID| DEPT         |   507 |  7098 |       |     4   (0)| 00:00:01 |
|   5 |     INDEX FULL SCAN           | SYS_C0063105 |   507 |       |       |     1   (0)| 00:00:01 |
|*  6 |    SORT JOIN                  |              | 50111 |  1419K|  4344K|   541   (1)| 00:00:01 |
|   7 |     TABLE ACCESS FULL         | EMP          | 50111 |  1419K|       |   139   (1)| 00:00:01 |
------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."SAL"="HISAL")
   6 - access("E"."DEPTNO"="D"."DEPTNO")
       filter("E"."DEPTNO"="D"."DEPTNO")

*/