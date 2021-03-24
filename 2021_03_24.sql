복습반드시 하세요 : WHERE, GROUP BY, JOIN


SMITH가 속한 부서에 있는 직원들을 조회하기?
-- 20번 부서에 속하는 직원들 조회하기 는 하드코딩임(WHERE deptno = 20;)이렇게 쓰지 말라고
1. SMITH가 속한 부서 이름을 알아낸다.
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp 테이블에서 검색한다.
-- 지금까지 배운 것으로 쿼리를 짜려면 두 번 짜야 한다
1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';
2.
SELECT *
FROM emp
WHERE deptno = 20;

(서브쿼리) SUBQUERY를 활용  : 
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
SELECT *
FROM emp
WHERE deptno = (SELECT deptno, ename
                FROM emp
                WHERE ename = 'SMITH');
-- 이거는 WHERE deptno = (20, 'SMITH')  : 실행불가 값과 값들
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');
-- 이거는 WHERE deptno = (20, 30) 
-- 문법과 관련해서 불가. =가 IN으로 대체되면 가능
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');


SUBQUERY : 쿼리의 일부로 사용되는 쿼리 -- 쿼리의 결과를 다른 쿼리에다 가져다 쓰는 것
-- 괄호 안에가 서브쿼리. 그 괄호를 사용하는 쿼리가 메인쿼리
1. 사용위치에 따른 분류
 . SELECT절에서도 사용가능 -> 스칼라 서브 쿼리 ( 스칼라 : 단일의)
    - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
    -- 버거지수 신희철
 . FROM절에서 사용 : 인라인 뷰
 . WHERE절에서 사용 : 서브쿼리
                    . 메인쿼리의 컬럼을 가져다가 사용할 수 있다.
                    . 반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다.

2. 반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
 . 행 - 다중행, 단일행  /  컬럼 - 단일 컬럼, 복수 컬럼 
 . 다중행 단일 컬럼 IN, NOT IN
 . 다중행 복수 컬럼 (pairwise)
 . 단일행 단일 컬럼
 . 단일행 복수 컬럼
    
3. main-sub query의 관계에 따른 분류
 . 상호 연관 서브 쿼리 (correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
    ==> 메인 쿼리가 없으면 서브 쿼리만 독자적으로 실행이 불가능
 . 비상호 연관 서브 쿼리 (non-correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우
    ==> 메인 쿼리가 없어도 서브 쿼리만 실행가능
    
실습1] 평균 급여보다 높은 급여를 받는 직원의 수를 조회
SELECT ROUND(AVG(sal), 2) avg
FROM emp

SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT ROUND(AVG(sal), 2) avg
            FROM emp);
            

실습2] 평균 급여보다 높은 급여를 받는 직원의 정보를 조회            
SELECT *
FROM emp
WHERE sal >= (SELECT ROUND(AVG(sal), 2) avg
            FROM emp);


실습3] SMITH와 WARD사원이 속한 부서의 보든 사원 정보를 조회하는 쿼리를 작성
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                    OR ename = 'WARD');
SELECT m.*
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                FROM emp s
                WHERE s.ename IN ('SMITH', 'WARD'));
                    
<<MULTI ROW 연산자>> 
 IN : = + OR
 비교 연산자 ANY
 비교 연산자 ALL

SELECT *
FROM emp e
WHERE sal < ANY (SELECT s.sal
                 FROM emp s
                 WHERE s.ename IN ('SMITH', 'WARD'));
-- 직원 중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회                
     == > 직원중에 급여값이 1250보다 작은 직원 조회  
SELECT *
FROM emp e
WHERE sal < (SELECT MAX(s.sal)
             FROM emp s
             WHERE s.ename IN ('SMITH', 'WARD'));     
-- 이것과 같다. ANY 는 지금까지 우리가 배운 개념으로 대체 가능 

SELECT *
FROM emp e
WHERE sal < ALL (SELECT s.sal
                 FROM emp s
                 WHERE s.ename IN ('SMITH', 'WARD'));
SELECT *
FROM emp m
WHERE m.sal <(SELECT MIN(s.sal)
             FROM emp s
             WHERE s.ename IN ('SMITH', 'WARD'));
--  직원의 급여가 800보다 작고 1250보다 작은 직원 조회 (이게 ALL대체)
    == > 직원의 급여가 800보다 작은 직원 조회 (조건을 만족하는 직원이 없음

--> 비상호 연관 쿼리 : 서브쿼리만 독자적으로 실행이 가능


SUBQUERY 사용시 주의점 NULL값
IN ()
NOT IN ()

SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno IN (10, 20, NULL);
==> deptno = 10 OR deptno = 20 OR deptno = NULL
                                     FALSE       
--IN은 NULL값이 있어도 실행하는데 문제가 되지 않지만 문제는 NOT IN

SELECT *
FROM emp
WHERE deptno NOT IN (10, 20, NULL);
==> !(deptno = 10 OR deptno = 20 OR deptno = NULL)
    ==> deptno != 10 AND deptno != 20 AND deptno != NULL
                                               FALSE       
-- AND는 모든 연산이 TRUE 여야 값이 나옴

SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp);
-- subquery 실행 결과에 NULL이 있어서 값이 안나옴
-- NOT IN썼는데 값이 안나오면 서브쿼리에 NULL이 있는지 확인
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr,9999)
                    FROM emp);
-- 이건 8개나 나옴 : 직원들 중에 매니저가 아닌 사람// 찬찬히 살펴보자
-- 두번째 시험 문제에 있을 것이다. : 

===============================================================================================

PAIR WISE : 순서쌍 -- 나중에 실무에서는 나오는데 아마 수료 끝날때까지 이거 쓸일 없을 것임. 개념만 잡고가자

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
    AND deptno IN (SELECT deptno
                   FROM emp
                   WHERE empno IN (7499, 7782));    
-- 이건 7건 조회 

-- ALLEN(30, 7698), CLARK(10, 7839)
SELECT ename, mgr, deptno
 FROM emp
WHERE empno IN (7499, 7782);

SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
    AND deptno IN (10, 30);
-- 이건 맨 위의 하드코딩 버전

mgr, deptno
모든 경우의 수 (7698, 10), (7698, 30), (7839, 10), (7839, 30)

요구사항 : ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회
(7698, 30), (7839, 10) 이 경우의 수들을 뽑고 싶을때
SELECT *
FROM emp

SELECT mgr, deptno
FROM emp
WHERE ename IN ('ALLEN', 'CLARK')

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE ename IN ('ALLEN', 'CLARK'))
-- 6건 조회                
-- 7698 논페어에는 나오는데 페어와이즈에는 안나옴
===============================================================================================
DISTINCT
1. 설계가 잘못된 경우
2. 개발자가 sql을 잘 작성하지 못하는 사람인 경우
3. 요구사항이 이상한 경우

<스칼라 서브쿼리> : 잘못배우면 남용하는 사례가 많은데 잘못쓰면 성능에 영향을 미치니 함부로 쓰는 것은 독이된다.
 . SELECT절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리(스칼라 서브쿼리)
    -- <하나의 행 하나의 컬럼> 기억하자
  SELECT empno, ename, SYSDATE
  FROM emp;
  
  SELECT SYSDATE
  FROM dual;
  
  SELECT empno, ename, (SELECT SYSDATE FROM dual)
  FROM emp;
  -- SELECT절에 쓸 때 여러줄로 나눠써도 무방하긴 함
  -- 문법적으로 된다라는 걸 보여주는 억지 예제라고 하심
  -- 여기서 비상호 연관임
  -- 일반적으로는 보통 상호 연관 쿼리를 씀
  
  SELECT empno, ename, (SELECT SYSDATE, SYSDATE FROM dual)
  FROM emp;
  -- 이건 스칼라 서브쿼리의 조건을 충족시키지 못하기 때문에 에러


emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다.
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.

상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다.(방향성)
SELECT empno, ename, deptno,
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) -- 사진보고 이어서

--> 서브쿼리가 메인쿼리의 행 갯수 만큼 실행 
--> 서브쿼리가 많으면 그 많은 서브쿼리수 * 메인쿼리행개수



비상호 연관 서브쿼리는 메인쿼림가 먼저 실행 될 수도 있고 
                    서브쿼리가 먼저 실행 될 수도 있다.
                    ==> 성능측면에서 유리한 쪽으로 오라클이 선택

SELECT *
FROM emp;
===============================================================================================
인라인 뷰  : SELECT QUERY
 . inline : 해당 위치에 직접 기술을 했다 는 의미
 . inline view : 해당 위치에 직접 기술한 view
    view : QUERY (O) ==> view table (x) -- 이건 잘못된 표현임 쿼리가 맞는 표현. 반드시 기억해라
 
SELECT *
FROM
(SELECT deptno, ROUND(AVG(sal), 2) avg_sal
 FROM emp
 GROUP BY deptno)
 
 CREATE VIEW v_emp_sal AS
 SELECT deptno, ROUND(AVG(sal), 2) avg_sal
 FROM emp
 GROUP BY deptno;
 -- 뷰생성

뷰와 테이블 차이 좀 더 알기
뷰를 쓴다고 쿼리가 빨라지는건 아님

===============================================================================================
<상호, 비상호 연관을 시연하기 위한 괜찮은 예제>

아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);
              
직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회              
SELECT *
FROM emp;

SELECT empno, ename, sal, deptno
FROM emp;

20번 부서의 급여평균 (2175)
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;
--이건 모든 부서가 다 나옴. 그러니까 웨어절에서 짜르는게 맞다
SELECT AVG(sal)
FROM emp
WHERE deptno = 20

10번 부서의 급여평균 (2916.666)
SELECT AVG(sal)
FROM emp
WHERE deptno = 10


직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal)
                FROM emp a
                WHERE a.deptno = e.deptno);
--추가 설명
SELECT empno, ename, sal, deptno, a.avg_sal
FROM emp e
WHERE e.sal > (SELECT AVG(sal) avg_sal
                FROM emp a
                WHERE a.deptno = e.deptno);
-- 이거 해보면 에러
-- 셀렉트에 쓸수 있는건 프롬에 나왔던 컬럼들

-- 그사람이 속한 부서의 급여평균 : 서브쿼리 중복이라 비효율적
SELECT empno, ename, sal, deptno,
        (SELECT AVG(sal) avg_sal
        FROM emp a
        WHERE a.deptno = e.deptno)
FROM emp e
WHERE e.sal > (SELECT AVG(sal) avg_sal
                FROM emp a
                WHERE a.deptno = e.deptno)
===============================================================================================
--dept 테이블에 추가 하기
--INSERT는 한 번만 실행해야 함
deptno, dname, loc
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT *
FROM dept

SELECT *
FROM emp

실습4] dept테이블에 직원이 소속되지 않은 부서 구하기
    => 우리가 알 수 있는 건 직원이 속한 부서
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp) 
-- 내가 짠 쿼리랑 쌤쿼리랑 동일


실습5] cycle, product 테이블을 이용하여 cid=1 인 고객이 애음하지 않는 제품을 조회하는 쿼리를 작성하세요
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                FROM cycle
                WHERE CID = 1)
-- 위에랑 동일                
                
사이트 추천 : 프로그래머스 : 코딩테스트 연습 : SQL고득점 KIT, 자바도 이씀                