EXPLAIN PLAN FOR
    SELECT      dname
    FROM        dept
    WHERE       deptno IN   (SELECT     deptno
                             FROM       emp
                             WHERE      job = 'PHILOSOPHER');

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

-----------------------------------------------------------------------------
| Id  | Operation            | Name | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |      |     5 |   130 |   141   (0)| 00:00:01 |
|*  1 |  HASH JOIN RIGHT SEMI|      |     5 |   130 |   141   (0)| 00:00:01 |
|*  2 |   TABLE ACCESS FULL  | EMP  |     5 |    60 |   138   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL  | DEPT |   507 |  7098 |     3   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("DEPTNO"="DEPTNO")
   2 - filter("JOB"='PHILOSOPHER')

*/

CREATE INDEX emp_index ON emp(job);

EXPLAIN PLAN FOR
    SELECT      dname
    FROM        dept
    WHERE       deptno IN   (SELECT     deptno
                             FROM       emp
                             WHERE      job = 'PHILOSOPHER');

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

--------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |           |     5 |   130 |     5   (0)| 00:00:01 |
|*  1 |  HASH JOIN RIGHT SEMI                |           |     5 |   130 |     5   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID BATCHED| EMP       |     5 |    60 |     2   (0)| 00:00:01 |
|*  3 |    INDEX RANGE SCAN                  | EMP_INDEX |     5 |       |     1   (0)| 00:00:01 |
|   4 |   TABLE ACCESS FULL                  | DEPT      |   507 |  7098 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("DEPTNO"="DEPTNO")
   3 - access("JOB"='PHILOSOPHER')

*/

DROP INDEX emp_index;