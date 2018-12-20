EXPLAIN PLAN FOR
    SELECT      d.deptno, AVG(e.sal)
    FROM        emp e, dept d
    WHERE       d.deptno = e.deptno
    GROUP BY    d.deptno;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

-------------------------------------------------------------------------------------
| Id  | Operation            | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |              |   507 | 21294 |   141   (3)| 00:00:01 |
|   1 |  NESTED LOOPS        |              |   507 | 21294 |   141   (3)| 00:00:01 |
|   2 |   VIEW               | VW_GBC_5     |   508 | 19812 |   141   (3)| 00:00:01 |
|   3 |    HASH GROUP BY     |              |   508 |  3048 |   141   (3)| 00:00:01 |
|   4 |     TABLE ACCESS FULL| EMP          | 50111 |   293K|   139   (1)| 00:00:01 |
|*  5 |   INDEX UNIQUE SCAN  | SYS_C0063105 |     1 |     3 |     0   (0)| 00:00:01 |
-------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("D"."DEPTNO"="ITEM_1")

*/

EXPLAIN PLAN FOR
    SELECT      /*+ NO_USE_HASH(e d) */ d.deptno, AVG(e.sal)
    FROM        emp e, dept d
    WHERE       d.deptno = e.deptno
    GROUP BY    d.deptno;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

-------------------------------------------------------------------------------------
| Id  | Operation            | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |              |   507 | 21294 |   141   (3)| 00:00:01 |
|   1 |  NESTED LOOPS        |              |   507 | 21294 |   141   (3)| 00:00:01 |
|   2 |   VIEW               | VW_GBC_5     |   508 | 19812 |   141   (3)| 00:00:01 |
|   3 |    HASH GROUP BY     |              |   508 |  3048 |   141   (3)| 00:00:01 |
|   4 |     TABLE ACCESS FULL| EMP          | 50111 |   293K|   139   (1)| 00:00:01 |
|*  5 |   INDEX UNIQUE SCAN  | SYS_C0063105 |     1 |     3 |     0   (0)| 00:00:01 |
-------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("D"."DEPTNO"="ITEM_1")

*/