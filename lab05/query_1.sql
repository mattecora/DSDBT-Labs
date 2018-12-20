EXPLAIN PLAN FOR
    SELECT      *
    FROM        emp, dept
    WHERE       emp.deptno = dept.deptno AND emp.job = 'ENGINEER';

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |  5068 |   326K|   141   (0)| 00:00:01 |
|*  1 |  HASH JOIN         |      |  5068 |   326K|   141   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| DEPT |   507 | 10647 |     3   (0)| 00:00:01 |
|*  3 |   TABLE ACCESS FULL| EMP  |  5078 |   223K|   138   (0)| 00:00:01 |
---------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   3 - filter("EMP"."JOB"='ENGINEER')

*/

EXPLAIN PLAN FOR
    SELECT      /*+ FIRST_ROWS(100) */ *
    FROM        emp, dept
    WHERE       emp.deptno = dept.deptno AND emp.job = 'ENGINEER';

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

/*

---------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |   102 |  6732 |     8   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |              |   102 |  6732 |     8   (0)| 00:00:01 |
|   2 |   NESTED LOOPS               |              |   102 |  6732 |     8   (0)| 00:00:01 |
|*  3 |    TABLE ACCESS FULL         | EMP          |   102 |  4590 |     5   (0)| 00:00:01 |
|*  4 |    INDEX UNIQUE SCAN         | SYS_C0063105 |     1 |       |     0   (0)| 00:00:01 |
|   5 |   TABLE ACCESS BY INDEX ROWID| DEPT         |     1 |    21 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter("EMP"."JOB"='ENGINEER')
   4 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")

*/