EXPLAIN PLAN FOR
    SELECT      *
    FROM        emp e, dept d
    WHERE       e.deptno = d.deptno
    AND         e.sal NOT IN    (SELECT     hisal
                                 FROM       salgrade
                                 WHERE      hisal > 500 AND hisal < 1900);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

--------------------------------------------------------------------------------------
| Id  | Operation                 | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT          |          | 32433 |  2185K|   145   (1)| 00:00:01 |
|*  1 |  HASH JOIN                |          | 32433 |  2185K|   145   (1)| 00:00:01 |
|   2 |   TABLE ACCESS FULL       | DEPT     |   507 | 10647 |     3   (0)| 00:00:01 |
|*  3 |   HASH JOIN RIGHT ANTI SNA|          | 32497 |  1523K|   142   (1)| 00:00:01 |
|*  4 |    TABLE ACCESS FULL      | SALGRADE |   862 |  2586 |     3   (0)| 00:00:01 |
|   5 |    TABLE ACCESS FULL      | EMP      | 50111 |  2202K|   139   (1)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPTNO"="D"."DEPTNO")
   3 - access("E"."SAL"="HISAL")
   4 - filter("HISAL">500 AND "HISAL"<1900)

*/

CREATE INDEX salgrade_index ON salgrade(hisal);

EXPLAIN PLAN FOR
    SELECT      *
    FROM        emp e, dept d
    WHERE       e.deptno = d.deptno
    AND         e.sal NOT IN    (SELECT     hisal
                                 FROM       salgrade
                                 WHERE      hisal > 500 AND hisal < 1900);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

--------------------------------------------------------------------------------------------
| Id  | Operation                 | Name           | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT          |                | 32433 |  2185K|   145   (1)| 00:00:01 |
|*  1 |  HASH JOIN                |                | 32433 |  2185K|   145   (1)| 00:00:01 |
|   2 |   TABLE ACCESS FULL       | DEPT           |   507 | 10647 |     3   (0)| 00:00:01 |
|*  3 |   HASH JOIN RIGHT ANTI SNA|                | 32497 |  1523K|   142   (1)| 00:00:01 |
|*  4 |    INDEX FAST FULL SCAN   | SALGRADE_INDEX |   862 |  2586 |     3   (0)| 00:00:01 |
|   5 |    TABLE ACCESS FULL      | EMP            | 50111 |  2202K|   139   (1)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPTNO"="D"."DEPTNO")
   3 - access("E"."SAL"="HISAL")
   4 - filter("HISAL">500 AND "HISAL"<1900)

*/

DROP INDEX salgrade_index;