EXPLAIN PLAN FOR
    SELECT      e1.ename, e1.empno, e1.sal, e2.ename, e2.empno, e2.sal
    FROM        emp e1, emp e2
    WHERE       e1.ename <> e2.ename AND e1.sal < e2.sal
    AND         e1.job = 'PHILOSOPHER' AND e2.job = 'ENGINEER';

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

-----------------------------------------------------------------------------
| Id  | Operation            | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |      | 12664 |   742K|   279   (2)| 00:00:01 |
|   1 |  MERGE JOIN          |      | 12664 |   742K|   279   (2)| 00:00:01 |
|   2 |   SORT JOIN          |      |     5 |   150 |   139   (1)| 00:00:01 |
|*  3 |    TABLE ACCESS FULL | EMP  |     5 |   150 |   138   (0)| 00:00:01 |
|*  4 |   FILTER             |      |       |       |            |          |
|*  5 |    SORT JOIN         |      |  5078 |   148K|   140   (2)| 00:00:01 |
|*  6 |     TABLE ACCESS FULL| EMP  |  5078 |   148K|   138   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter("E1"."JOB"='PHILOSOPHER')
   4 - filter("E1"."ENAME"<>"E2"."ENAME")
   5 - access("E1"."SAL"<"E2"."SAL")
       filter("E1"."SAL"<"E2"."SAL")
   6 - filter("E2"."JOB"='ENGINEER')

*/

CREATE INDEX emp_index ON emp(job);

EXPLAIN PLAN FOR
    SELECT      e1.ename, e1.empno, e1.sal, e2.ename, e2.empno, e2.sal
    FROM        emp e1, emp e2
    WHERE       e1.ename <> e2.ename AND e1.sal < e2.sal
    AND         e1.job = 'PHILOSOPHER' AND e2.job = 'ENGINEER';

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

---------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |           | 12664 |   742K|   143   (3)| 00:00:01 |
|   1 |  MERGE JOIN                           |           | 12664 |   742K|   143   (3)| 00:00:01 |
|   2 |   SORT JOIN                           |           |     5 |   150 |     3  (34)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| EMP       |     5 |   150 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN                  | EMP_INDEX |     5 |       |     1   (0)| 00:00:01 |
|*  5 |   FILTER                              |           |       |       |            |          |
|*  6 |    SORT JOIN                          |           |  5078 |   148K|   140   (2)| 00:00:01 |
|*  7 |     TABLE ACCESS FULL                 | EMP       |  5078 |   148K|   138   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("E1"."JOB"='PHILOSOPHER')
   5 - filter("E1"."ENAME"<>"E2"."ENAME")
   6 - access("E1"."SAL"<"E2"."SAL")
       filter("E1"."SAL"<"E2"."SAL")
   7 - filter("E2"."JOB"='ENGINEER')

*/

DROP INDEX emp_index;