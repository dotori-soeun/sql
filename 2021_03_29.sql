EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
-- XPLAN : 실행계획
-- DBMS_XPLAN : 패키지. 폴더의 개념


SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

job, ename 컬럼으로 구성된 IDX_emp_03 인덱스 삭제

CREATE 객체타입(INDEX, TABLE, 시퀀스) 객체명(내가 붙이고 싶은 이름 = 자바 변수 선언과 비슷) ON~~()
DROP 객체타입 객체명;

DROP INDEX idx_emp_03;

CREATE INDEX idx_emp_04 ON emp (ename, job);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4077983371
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
Note
-----
   - dynamic sampling used for this statement (level=2)
   
============================================================================================
<<한가지 테이블에서만 끝나는게 아닌 실행계획>>

SELECT ROWID, dept.*
FROM dept;

CREATE INDEX idx_dept_01 ON dept (deptno);

emp
 1. table full access
 2. idx_emp_01
 3. idx_emp_02
 4. idx_emp_04
 
dept
 1. table full access
 2. idx_dept_01

emp (4) => dept (2)  : 8
dept (2) => emp (4)  : 8

16가지
접근방법 * 테이블^개수

조인 들어가면서 실행계획 더 복잡해진다. 각자 참조해야할 것들과 방향성이 발생
조인이 늘어날 수록 선택의 갯수가 많아져서

오라클이 오판을 할 수도 있는 가능성 때문에 '아마도'라는 말을 써서 표현하심 

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno=dept.deptno
 AND emp.empno = 7788
 
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 951379666
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    63 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    63 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    33 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DEPT_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    30 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
Note
-----
   - dynamic sampling used for this statement (level=2)

유니크 옵션을 쓰지 않아서 RANGE.(중복될 수 있는 옵션이라서)

응답성 : OLTP (Online Transaction Processing) --> 우리가 오라클을 쓰는 이유
퍼포먼스 : OLAP (Online Analysis Processing)
          - 은행이자 계산
   
순서 4 3 5 2 6 1 0 -- 실행계획 순서는 이제 좀 읽을 수 있는듯   

인덱스에서 위치를 바로 찾을 수 있는 이유 ? 정렬이 되어있어서
->그래서 복합칼럼 인덱스의 컬럼 순서가 중요하다

==============================================================================================

Index Access
 . 소수의 데이터를 조회할 때 유리(응답속도가 필요할 때) -- why? dbms의 메커니즘
   . Index를 사용하는 Input/Output Single Block I/O
 . 다량의 데이터를 인덱스로 접근할 경우 속도가 느리다(2~3000건)
 -- 테이블의 전체건수의 15%면 빠르다는 것은 건수가 얼마나 많을지를 고려하지 않은것
 -- 맥시멈(2~3000건) 이라는 말이 더 정확하다
   
Table Access 
 . 테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
   . I/O 기준이 multi block
   
웹개발자라면 웹시스템을 만드는데에 인덱스를 안 쓰는 경우가 없다.   

*********DDL ( 테이블에 인덱스가 많다면)*************

테이블의 빈공간을 찾아 데이터를 입력한다

인덱스의 구성 컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장

인덱스는 B*트리 구조이고, root node 부터 leaf node 까지의 depth가 항상 같도록 밸런스를 유지한다

즉 데이터 입력으로 밸런스가 무너질경우 밸런스를 맞추는 추가 작업이 필요

2-4까지의 과정을 각 인덱스 별로 반복한다



인덱스가 많아 질 경우 위 과정이 인덱스 개수 만큼 반복 되기 때문에 UPDATE, INSERT, DELETE 시 부하가 커진다

인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시 부하가 생긴다

테이블에 과도한 수의 인덱스를 생성하는 것은 바람직 하지 않음

하나의 쿼리를 위한 인덱스 설계는 쉬움

시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계하는 것이 힘듬
===================================================================================================
쿼리 잘 분석해서 WHERE절에서 어떤 조건으로 많이 나오는지 잘 보고 인덱스를 생성하자
WHERE절에 쓰이는 패턴
어떤 컬럼이 앞에 와야 인덱스를 더 적게 읽을 수 있는가 항상 생각하자
지금 당장 말고 나중에 일을 할 때

루트 
  - 우하향 트리 : 큰값만 들어오면 오른쪽으로만해서 생겨남. DEPTH 차이가 남
  어느순간 변화
  - 벨런스드 트리 : ROOT 부터 가장 밑에 LEAF 노드까지 DEPTH를 균일하게 맞춰준다.
  
********과제!!!! : 하고 싶은 사람만!! 쿼리 주시니까 쿼리 분석해서 최적의 인덱스 만들어보기(사진)  

===================================================================================================
<<달력만들기>>
주어진 것 : 년월 6자리 문자열 ex - 202103
만들 것 : 해당 년월에 해당하는 달력(7칸 짜리 테이블

응용기술이 많다. 이거만 제대로 할 줄 알면 실무에서 쿼리 때문에 걱정할 일 많이 없을 것
 - 데이터의 행을 열로 바꾸는 기술 : 도시발전 지수에서
 - 레포트 쿼리(사용현황 같은 것)에서 활용할 수 있는 예제 연습
 
주차 : IW
주간요일 : D

쿼리 단순화를 위해 인라인뷰를 쓴다

--(LEVEL은 1부터 시작)
SELECT *
FROM dual
CONNECT BY LEVEL <= 10;
:데이터가 10건이 나옴


SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= 10;
그럼 레벨이 해당 연월의 마지막 날짜만큼 필요하다


'202103' ==> 31

SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= 31;


SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')
FROM dual
--라스트 데이는 인자가 하나


SELECT SYSDATE + LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


SELECT TO_DATE(:YYYYMM, 'YYYYMM') + LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');


SELECT dt, d, iw
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD');)


SELECT dt, d, iw,
        DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon, 
        DECODE(d, 3, dt) tue, DECODE(d, 4, dt) wed,
        DECODE(d, 5, dt) thu, DECODE(d, 6, dt) fri,
        DECODE(d, 7, dt) sat       
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'));


SELECT  iw,
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
        MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,
        MIN( DECODE(d, 7, dt)) sat       
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY iw
ORDER BY iw;
-- 일요일이 한칸씩 올라감 iw의 포맷때문. 한 주의 시작을 월요일부터로 봐서 그럼
-- MAX보다는 MIN의 알고리즘이 더 효율적이라 하심


SELECT  /*DECODE(d, 1, iw+1, iw),*/
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
        MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,
        MIN(DECODE(d, 7, dt)) sat       
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
-- 일요일에는 주차를 하나더 하고 아닐때는 주차를 그냥 씀


-------------------------------------------------------------------------------------------------
201912로 했을때 문제 발생 --> 주차를 다시 살리고 보자 : iw 로 그룹바이를 할 수 없다. 국제 표준때문
SELECT  DECODE(d, 1, iw+1, iw),
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon, 
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
        MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,
        MIN(DECODE(d, 7, dt)) sat       
FROM
(SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
--> 그러면 어떻게 하면 달력이 정상적으로 보일 수 있을까?
1주차 라면 마지막에 붙인다? 그럼 새해가 시작하면 이상해질 것 같고

******* 달력만들기 안보고 스스로 다시 할 줄 알아야 한다.******************

====================================================================================================
<계층쿼리>
-- CONNECT BY LEVEL 도 계층쿼리의 일종
계층쿼리 - 조직도, BOM(Bill Of Material), 게시판(답변형 게시판)
        - 데이터의 상하 관계를 나타내는 쿼
        
사용방법 : 1. 시작위치를 설정
          2. 행과 행의 연결 조건을 기술


SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839;
/*START WITH mgr IS NULL;*/

PRIOR - 이전의, 사전의, 이미 읽은 데이터 // 컬럼에 붙는 개념
이미 읽은 데이터        앞으로 읽어야 할 데이터
KING의 사번 = mgr 컬럼의 값이 KING의 사번인 사원
empno = mgr

SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839
CONNECT BY 내가 읽은 행의 사번과 = 앞으로 읽을 행의 MGR컬럼;

SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

SELECT empno, ename, mgr
FROM emp
START WITH empno = 7566
CONNECT BY PRIOR empno = mgr;

SELECT empno, ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;


SELECT LPAD('TEST', 1*10, '*')
FROM dual;

SELECT LPAD('TEST', 1*10)
FROM dual;

SELECT empno, LPAD(' ', (LEVEL-1)*4)||ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;
/*CONNECT BY mgr = PRIOR empno;*/
--


계층쿼리 방향에 따른 분류
상향식 : 최하위 노드(leaf node)에서 자신의 부모를 방문하는 형태
하향식 : 최상위 노드(root)에서 모든 자식 노드를 방문하는 형태

상향식 쿼리 SMITH부터 시작하여 노드의 부모를 따라가는 계층형쿼리 작성
SELECT empno, LPAD(' ', (LEVEL-1)*4)||ename ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;
-- CONNECT BY SMITH의 mgr컬럼값 = 앞으로 읽을 행 empno
======================================================================================================
<계층쿼리 실습> 실습파일 dept_h 실행

SELECT *
FROM dept_h;

최상위 노드부터 리프 노드까지 탐색하는 계층쿼리 작성
(LPAD를 이용한 시각적 표현까지 포함)

SELECT deptcd, LPAD(' ', (LEVEL-1)*3)||deptnm deptnm, p_deptcd, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;
--이거는 왜 안됐지?? : 답알아냄!! 문자를 '' 표기해주지 않아서!

SELECT deptcd, LPAD(' ', (LEVEL-1)*3)||deptnm deptnm, p_deptcd, LEVEL
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;
//PSUEDO CODE-가상코드-슈도코드
CONNECT BY 현재행의 deptcd = 앞으로 읽을 행의 p_deptcd


<계층쿼리 실습2> 정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '정보시스템부'
CONNECT BY PRIOR deptcd = p_deptcd;
-- START WITH deptcd = dept0_02

<계층쿼리 실습3> 디자인 팀에서 시작하는 상향식 계층 쿼리를 작성하세요
SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

------------------------------------------------------------------------------
실습파일 계층형쿼리 복습 실행
<계층쿼리 실습4>
SELECT *
FROM h_sum;

DESC h_sum
--0이 문자로 나옴
01 = 1 숫자였으면 그냥 1

SELECT LPAD(' ', (LEVEL-1)*4)||s_id s_id, value
FROM h_sum
START WITH ps_id IS NULL
CONNECT BY PRIOR s_id = ps_id
-- START WITH s_id = '0'
-- START WITH s_id = 0 : 그냥 일케 하면 둘 중 하나 형변환. 근데 왼쪽을 가공하면 안댐. SQL칠거지악!!