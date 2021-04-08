9999사번(empno)을 갖는 brown 직원(ename)을 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
INSERT INTO emp (ename, empno) VALUES ('brown', 9999);
-- 두 개는 동일한 쿼리임

DESC emp
SELECT * FROM emp;

UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리 = 값1, 행1),
                   컬럼명2 = (스칼라 서브쿼리),
                   컬럼명3 = 'TEST'; --값
-- 컬럼명1, 컬럼명2 서로 다른 컬럼에 다른 서브쿼리 입력 가능

9999번 직원의 deptno와 job정보를 SMITH 사원의 deptno, job 정보로 업데이트
UPDATE emp SET deptno = '', job = '' WHERE empno = 9999;

SELECT deptno, job FROM emp WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT job FROM emp WHERE ename = 'SMITH') 
        WHERE empno = 9999;

이런 형태의 쿼리보다 더 좋은 명령어 : MERGE
ROLLBACK
====================================================================================
Exists : 한 번 더 개념 정리 필요
오라클 트랜잭션 시작이 DML 문 부터 시작된다.
    -> 트랜잭션 : 논리적인 일의 단위
    -> 롤백, 커밋은 DML 에서만 사용 가능
 .ALTER : DDL 데이터 데피니션(정의) 랭귀지
    -> 오토커밋. 돌이킬 수 없다.
====================================================================================
DELETE : 기존에 존재하는 데이터를 삭제
    -> 행을 식별하는 수식을 가진 서브쿼리는 전부 WHERE절에 사용가능 
DELETE 테이블명 WHERE 조건; -- 아예 행 지우는 거. 컬럼 정보를 쓸 필요는 없음
DELETE 테이블명: -- 테이블 데이터 전체 다 지우겠다는 거

UPDATE나 DELETE나 둘 다 기존 데이터에 뭔가를 하는 것. 
-> 그래서 WHERE절의 존재가 굉장히 중요

DELETE emp WHERE empno = 9999;

mgr가 7698사번(BLAKE)인 직원들 모두 삭제
SELECT * FROM emp WHERE mgr = 7698
SELECT * FROM emp WHERE empno IN (SELECT empno FROM emp WHERE mgr = 7698)

DELETE emp WHERE empno IN (SELECT empno FROM emp WHERE mgr = 7698)

ROLLBACK;

-----------------------------------------------------------------------------------
DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다
   UNDO(REDO) LOG
-- DML이 일어나면 REDO로그에 쌓인다.   

속도 : 하드디스크 < ssd < RAM < 캐시
 -> 갈수록 빠른것
(컴퓨터 부품에 대해서는 '다나와사이트' -> '조립PC'

디스크 IO를 피할 수 있으면 속도가 빠르다하심

[사용자데이터입력 -> 메모리에 저장]
원래는 이렇게 하고 그 다음 데이터파일에 저장하는 건 한가할 때
 : 원하는 위치에 찾아가서 저장해야 되니까
--> 만약 저장못하고 정전처럼 급하게 꺼지면 리두로그에서 복구 
[사용자데이터입력 -> 메모리에 저장 -> REDO로그]
 REDO로그에 이전 작업 있었음 하는 기록까지만 복구가능

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

그래서 REDO 로그 남기지 않고 삭제 하는법 : 복구 남기지 않고 더 빨리 실행할 수 있다.
그러나 꼭 주의해서 쓰자

로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 :  TRUNCATE
 . DML이 아님(DDL)
 . ROLLBACL이 불가 ( 복구 불가)
 . 주로 테스트 환경에서 사용
-- 돌이킬 수 없으니 우측 상단의 [접속정보] 꼭 제대로 확인부터 

TRUNCATE TABLE 테이블명; 

 CREATE TABLE emp_test AS
 SELECT *
 FROM emp;
 
 ROLLBACK;
 
 SELECT * FROM emp_test;
 
 TRUNCATE TABLE emp_test; 
 
==================================================================================== 
트랜잭션은 보통 게시판 입력을 예시로 든다.
게시글 따로 게시글 첨부파일 따로
====================================================================================  
 <<읽기 일관성>>
 계정을 동일하게 창 2개라면 ???
    DB 입장에서는 서로 다른 사용자가 둘이고 계정만 같다고 판단

한 쪽에서 커밋을 완료하지 않고 계속 작업하면
남은 한 쪽은 원본으로 보임
그 한 쪽 커밋 완료하면 그제야 남은 한쪽이 변경된 거로 보임

"DAP DASP 자격증 카페" -> 커뮤니티카페
 . 기술사 자격증 : 따기 엄청 힘듬 . 최소 경력 7년 있어야 함
 . DAP SQLP 자격증의 단골 시험문제 - > [읽기 일관성]
 -- 단계 임의로 수정하지말고 그냥 쓰라심
 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

 읽기 일관성 레벨(0->3)4단계
 트랜잭션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨(단계)
 
LEVEL 0 : READ UNCOMMITED
    . dirty(변경이 가해졌다) read
    . 커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인가능
    . oracle에서는 지원하지 않음
    

LEVEL 1 : READ COMMITED
    . 대부분의 DBMS 읽기 일관성 설정레벨
    . 커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다.
        커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다.
    
        
LEVEL 2 : Reapeatable Read 반복읽기 
    . 선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하도록 방지
    . 선행 트랜잭션에서 읽었던 데이터를 트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가 나오게끔 유지
    . 신규 입력 데이터에 대해서는 막을 수 없음 : 기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지
        ==> Phantom Read(유령 읽기) - 없던 데이터가 조회되는 현상
    . oracle 에서는 LEVEL2에 대해 공식적으로 지원하지 않으나 FOR UPDATE 구문을 이용하여 효과를 만들어 낼 수 있다.  

SELECT *
FROM emp
FOR UPDATE
 : 일케하면 다른 트랜잭션에서 수정 못하게 할 수 이따~~
 (다른 사용자의) 다른 트랜잭션에서 업데이트 쿼리하면 대기
 언제까지? : 옆의 사용자가 ROLLBACK 이나 COMMIT 할 때 그 때 업데이트 할 수 이따!


LEVEL 3 : Serializable Read 직렬화 읽기
    . 후행 트랜잭션에서 수정, 입력, 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않음
    . 선 : 데이터 조회 (14)
      후 : 신규에 입력 (15)
      선 : 데이터 조회 (14)

레벨 바꾸는 구문
SET TRANSACTION isolation LEVEL SERIALIZABLE;

-> LEVEL3는 신규입력도 막는다.
나중에 시점별 어떤 결과 일지 엑셀로 만들어 주신다심

* 결론은!
    ISOLATION LEVEL 임의수정은 슈퍼 위험!!!
    
오라클 : 멀티버전 데이터 블럭 
    "오라클의 다중 버전 읽기 일관성 모델(Multi-Version Read Consistency Model)은 
    완벽한 문장수준 읽기 일관성을 보장한다."
장점 : 동시성 저하되지 않는다.
단점 : SNAPSHOT TOO OLD
    -- 불필요하게 데이터를 여기저기 많이 읽어야하는 쿼리를 짜면 그 때 경험해볼 수 있다
    
====================================================================================
y = x -> O(n)
y = x^2 -> o(n^2)
-- 루프안에 루프. 가급적 이중루프를 쓰지 않도록

트리 중에 이진트리 (바이너리트리) -> 내가 원하는 데이터를 빠르게 탐색하는게 가능
y = x^(1/2) -> O(logn)

바이너리서치 : 정렬되어있는게 일단 전제조건
중간씩 짤라서 왼쪽 오른쪽 찾는것 반복

[시간복잡도]를 생각해서 계속 루프만이 방법이 아님을 기억하자!
여러가지 써치방법~~~
====================================================================================
<<인덱스>> : 테이블과 같이 존재 = 인덱스만 만들 수는 없다.
 . 눈에 안보여
 . 테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
    ==> 정렬이 되어있다 -> 장점 -> 원하는 데이터를 빠르게 찾을 수 있다
    . 일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
 . ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념
            주소를 통해 해당 행의 위치를 빠르게 접근하는 것이 가능
            데이터가 입력이 될 때 생성 (우리가 만드는게 아니라 오라클이 알아서 값을 만들어줌)

SELECT ROWID, emp.*
FROM emp;

SELECT emp.*
FROM emp
WHERE ROWID = 'AAAE5dAAFAAAACOAAA';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
-- XPLAN : 실행계획
-- DBMS_XPLAN : 패키지. 폴더의 개념

Plan hash value: 3956160932
----------------------------------
| Id  | Operation         | Name |
----------------------------------
|   0 | SELECT STATEMENT  |      |
|*  1 |  TABLE ACCESS FULL| EMP  |
----------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("EMPNO"=7782) 

--TABLE ACCESS FULL : 테이블을 다 읽었다. 비효율적임   
================================================================================
오라클 객체 생성
CREATE 객체 타입(INDEX, TABLE....) 객체명
        int 변수명

인덱스 생성
CREATE [UNIQUE] INDEX  인덱스 이름 ON 테이블명(컬럼1, 컬럼2...);

CREATE UNIQUE INDEX PK_emp ON emp(empno);

인덱스 삭제
DROP INDEX PK_EMP;
=================================================================================
Plan hash value: 2949544139
읽는 순서 2-1-0
 --------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("EMPNO"=7782)
   
--만약에 인덱스에 있는 컬럼값 말고 다른 컬럼으로 조건 정해서 검삭하면 실행계획은???
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal = 2975;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 3956160932
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("SAL"=2975)
Note
-----
   - dynamic sampling used for this statement (level=2)

 : 그냥 테이블을 싹 다 읽어버려야 하는 구만!   
---------------------------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 56244932
1-0 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |    13 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |    13 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
    1 - access("EMPNO"=7782)
 테이블안읽었다. 인덱스만 읽고도 사용자가 원하는 정보를 찾아다 줄 수 있으니까
 
============================================================================

인덱스는 여러 개 만드는 게 가능
유니크 인덱스 VS 그냥 일반 인덱스
차이 : 행끼리 겹치는 것이 있는가, 
        인덱스로 한 건 읽었냐 여러건 읽었냐

** 내가 질문한 내용
 두 개 컬럼을 합쳐서 인덱스했을 때( 복합컬럼) 한 컬럼이 겹치는 것 없이 유니크해도 유니크 인덱스가 될까?
 : 쌉가능~ 유니크 맞음
 + 인덱스 컬럼의 순서를 바꾸면~ : 정렬의 기준이 바뀌는 것이기 때문에 중요한 것이 맞다. (다음주 수업내용이라심)
 
 
DROP INDEX PK_EMP;

CREATE INDEX IDX_emp_01 ON emp (empno);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4208888661
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("EMPNO"=7782)
 Note
-----
   - dynamic sampling used for this statement (level=2)
   
   
[실행계획]읽는 꿀! 팁! 
 ! 액세스 : 거기에 바로 접근
 ! 필터 : 읽고 나서 버렸다.
   

job 컬럼에 인덱스 생성
CREATE INDEX idx_emp_02 ON emp (job);

SELECT job, ROWID
from emp
ORDER BY job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   261 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   261 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("JOB"='MANAGER')
Note
-----
   - dynamic sampling used for this statement (level=2)

   

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'c%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("ENAME" LIKE 'c%') -- 걸른거. 읽고서 버린거
   2 - access("JOB"='MANAGER')
Note
-----
   - dynamic sampling used for this statement (level=2)

=================================================================================

job과 ename컬럼으로 구성해서 인덱스 만들기
CREATE INDEX IDX_EMP_03 ON emp (job, ename);

SELECT job, ename, ROWID
from emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'c%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2549950125
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'c%')
       filter("ENAME" LIKE 'c%')
Note
-----
   - dynamic sampling used for this statement (level=2)


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%c';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 ------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%c')
   2 - access("JOB"='MANAGER')
Note
-----
   - dynamic sampling used for this statement (level=2)
