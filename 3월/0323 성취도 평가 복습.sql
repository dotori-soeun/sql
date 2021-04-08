0323 성취도 평가 오답정리


1번문제] 파일 시스템에 비해 데이터 베이스 관리 시스템이 갖는 장점은 무엇인가
DBMS : 데이터 중복 방지, 백업/복구, 보안/공유, SQL표준에 따른 프로그램 비종속
데이터베이스 시스템의 장점
-- ▶ 데이터 중복 최소화
-- ▶ 데이터 공유
-- ▶ 일관성, 무결성, 보안성 유지
-- ▶ 최신의 데이터 유지
-- ▶ 데이터의 표준화 가능
-- ▶ 데이터의 논리적, 물리적 독립성
-- ▶ 용이한 데이터 접근
-- ▶ 데이터 저장 공간 절약


2번문제] 트랜잭션이란 무엇인지 
트랜잭션 : 여러 단계의 과정을 하나의 작업 행위로 묶는 단위 
--  트랜잭션(Transaction)은 데이터베이스의 상태를 변환시키는 하나의 논리적 기능을 수행하기 위한 작업의 단위 
--  또는 한꺼번에 모두 수행되어야 할 일련의 연산들을 의미한다.


3번문제] 트랜잭션의 원자성
트랜잭션 원자성 : ALL or NOTHING 작업전체가 실행되거나 안되거나 
--트랜잭션의 특징 : 원자성 (Atomicity)/ 일관성 (Consistency)/ 독립성 (Isolation)/ 지속성 (Durability)
--  원자성은 트랜잭션이 데이터베이스에 모두 반영되던가, 아니면 전혀 반영되지 않아야 한다는 것이다.  
--    트랜잭션은 사람이 설계한 논리적인 작업 단위로서, 일처리는 작업단위 별로 이루어 져야 사람이 다루는데 무리가 없다.
--    만약 트랜잭션 단위로 데이터가 처리되지 않는다면, 설계한 사람은 데이터 처리 시스템을 이해하기 힘들 뿐만 아니라, 
--    오작동 했을시 원인을 찾기가 매우 힘들어질것이다.
--  일관성은 트랜잭션의 작업 처리 결과가 항상 일관성이 있어야 한다는 것이다. 
--    트랜잭션이 진행되는 동안에 데이터베이스가 변경 되더라도 업데이트된 데이터베이스로 트랜잭션이 진행되는것이 아니라,
--    처음에 트랜잭션을 진행 하기 위해 참조한 데이터베이스로 진행된다. 
--    이렇게 함으로써 각 사용자는 일관성 있는 데이터를 볼 수 있는 것이다.
--  독립성은 둘 이상의 트랜잭션이 동시에 실행되고 있을 경우 어떤 하나의 트랜잭션이라도, 
--    다른 트랜잭션의 연산에 끼어들 수 없다는 점을 가리킨다.
--    하나의 특정 트랜잭션이 완료될때까지, 다른 트랜잭션이 특정 트랜잭션의 결과를 참조할 수 없다.
--  지속성은 트랜잭션이 성공적으로 완료됬을 경우, 결과는 영구적으로 반영되어야 한다는 점이다.


4번문제] 다음 SQL을 비교 연산자를 사용하여 작성
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 30;
--SELECT *
--FROM emp
--WHERE 10 <= deptno AND deptno <= 30;
--틀린 이유 : 부등호를 잘못 썼고, 마지막에 30을 10으로 씀


5번문제] NULL값이란 무엇인지
값을 모르거나 값이 없는 것
--NULL 값은 아직 정의되지 않은 값으로 0 또는 공백과 다르다.


6번문제] 다음 SQL의 실행결과
SELECT 'TEST1' alias1,
       'TEST2' AS alias2,
       'TEST3' AS "alias3"
FROM dual;       
'TEST' 문자열 리터럴 -> 값
DUAL 테이블의 특징 : 행이 하나 컬럼이 하나
별칭 더블 코테이션 "" 을 쓰는 경우 : 1.소문자로 하고싶거나,("" 안쓰면 전부 대문자로 치환이 된다)
                                 2.별칭에 공백이 있을때
답 : ALIAS1 / ALIAS2 / alias3
     TEST1 / TEST2 / TEST3


7번문제] 다음 SQL의 실행결과
SELECT 'TEST1' || dummy
FROM dual;
|| : 문자열 결합연산자 (또는 CONCAT)
'TEST1'은 문자열
dummy는 문자열이 아님. dual테이블에 있는 컬럼 이름 (참고로 값은 X)
--자바의 OR가 ||
--자바의 AND는 &&

답 : 'TEST1'||DUMMY
     TEST1X

SELECT *
FROM dual;


8번문제] 오라클에서 테이블의 컬럼명과 데이터 타입, null 허용 여부를 확인 할 수 있는 명령어
-- 문제를 잘읽어라. 메타인지 : 내가 뭘 모르는지 인식하고 있는가 
DESC -- 여기서는 디스크라이브!! 내림차 정렬의 DESC와 헷갈리지 말자


9번문제] 다음 SQL은 정상적으로 동작하는 SQL이지만 문제가 있는 SQL이다. 
문제점을 서술하고 올바르게 SQL을 수정하시오
SELECT *
FROM emp
WHERE TO_CHAR(hiredate, 'YYYYMMDD')
      BETWEEN '19800101' AND '19821231'
정답지
SELECT *
FROM emp
WHERE hiredate
      BETWEEN TO_DATE('19800101', 'YYYYMMDD') AND TO_DATE('19821231', 'YYYYMMDD')
--틀린이유 : 엔코아 / 테이블 컬럼을 가공하지 말아라 -> BETWEEN에서 둘다 TO_DATE적용


10번문제] 다음 SQL을 실행했을 때 조회되는 행의 개수를 각각 구하고, 
3개의 값을 곱한 결과를 기술
 1. SELECT * FROM emp;
 2. SELECT * FROM dual;
 3. SELECT * FROM emp WHERE 1 = 1 OR 1!=1;
정답 : 14*1*14 = 196
--WHERE 절은 행을 제한하는 조건
-- + WHERE 절에 기술한 조건을 참으로 만족을 하면 그 행이 그대로 나온다
--     SELECT * FROM emp WHERE 1!=1; -> 거짓이라서 아무런 행도 안나옴


11번문제] emp 테이블의 모든 컬럼 명을 서술하시오
empno, ename, job, mgr, hiredate, sal, comm, deptno


12번문제] 다음 SQL을 IN 연산자를 사용하지 않는 형태로 변경하시오
SELECT *
FROM emp
WHERE deptno IN (10,20);
--IN 을 외우려고 하지말고 논리적으로 생각을 해라, 연산자를 많이 강조하셨음
--'10' 이렇게 문자열처리를 해도 돌아는 가지만 올바른 케이스는 아님
정답
SELECT *
FROM emp
WHERE deptno = 10
      OR deptno = 20;


13번문제] emp테이블에서 ename컬럼의 값이 S로 시작하고, 중간에 T가 반드시 존재하며 H로 끝나는 이름을 갖거나
소속 부서번호(deptno)가 15번이 아닌 부서에 속하는 직원을 찾는 SELECT쿼리를 작성하시오
SELECT *
FROM emp
WHERE ename LIKE 'S%T%H'
    OR deptno != 15;
-- 틀린 이유 : 문자열표기 할거면 '' 꼭 해야 인식


14번문제] emp테이블의 데이터를 mgr 컬럼 기준으로 내림차순 정렬하는 SELECT쿼리를 작성하시오
SELECT *
FROM emp
ORDER BY mgr DESC;
-- 내림차순 정렬은 DESC! 반드시 컬럼명 뒤에 쓴다!!!


15번문제] (14번의 문제와 이어진 문제) 담당업무가 PRESIDENT인 직원 KING의 mgr 값은 NULL이다.
14번에서 작성한 SQL을 실행할 경우 직원 KING은 몇 번째 행에 위치하는지 적으시오
-- NULL을 어떻게 생각하냐 가장 큰 값으로 볼건지 작은 값으로 볼건지
정답 : 맨 위 (가장 큰 값이 되는 거임)


16번문제] 다음 SQL이 의미하는바
SELECT *
FROM emp
ORDER BY ename DESC, mgr;
ename으로 내림차순으로 정렬을 하는데 만일 ename컬럼의 값이 같은 행(들)이 있다면
ename이 같은 행(들)은 mgr로 다시 오름차순 정렬을 하라
--내 정답
--emp 테이블의 모든 데이터를 ename의 내림차순으로 정렬하고 순위가 같은 값이 있다면
--그 안에서 mgr의 오름차순으로 2차정렬하라


17번문제] ROWNUM이란 무엇인지, 특징 및 유의점
ROWNUM : 행 번호 부여하는 것
중요한 것은 ORDER BY 절 보다 SELECT 절이 먼저 실행되니까 
사용하려면 정렬이 된 상태에서 ROWNUM을 부여해야지 우리가 원하는 형태로 나온다. 그래서 인라인뷰를 사용해야한다
-- 길게 썼는데 애매한 말들이 있어서 부분점수를 맞은 것 같다. 핵심을 정확하게 이해할 것!


18번문제] emp 테이블에서 사원 리스트를 입사일자 오름차순 기준으로 페이징 처리 하려고 한다.
페이지 사이즈(:pageSize)와 페이지 번호(:page)를 바인드 변수로 사용하여 SELECT쿼리를 작성하시오
(단 입사일자가 같은 경우 직원의 이름을 오름차순 정렬한 순서로 우선순위를 부여한다.)
--페이징. 굉장히 중요한 내용 : 손코딩으로 쓸 수 있게끔
SELECT *
FROM
    (SELECT ROWNUM num, e.*
     FROM
        (SELECT *
        FROM emp
        ORDER BY hiredate, ename) e)
WHERE num BETWEEN (:page - 1)*:pageSize+1 AND :pageSize * :page
-- (:page-1)*:pageSize+1 ~ :pageSize * :page 


19번문제] 다음 문자열 3개를 CONCAT 함수를 이용하여 문자열 결합하고 
결과를 dual 테이블을 이용하여 조회하는 SELECT쿼리
 1. Hello   2. ,    3.World
정답
SELECT CONCAT('Hello', CONCAT(',', 'World'))
FROM dual;


20번문제] 현재 일자가 속한 달의 마지막 일자에서 55일 뒤(미래)의 일자를 
날짜 타입으로 구하는 SELECT 쿼리를 dual 테이블을 통해 작성하시오 

SELECT LAST_DAY(SYSDATE)+55 time
FROM dual;
-- LAST_DATE => LAST_DAY
-- 시간에 조급해하지말고 문제를 잘 읽을 것

SELECT LAST_DAY(TO_DATE(TO_CHAR(SYSDATE,'YYYY/MM/DD')))+55 no_time
FROM dual;
-- 시분초 날리기

SELECT LAST_DAY(TO_DATE(TO_CHAR(SYSDATE,'YYYY/MM/DD'), 'YYYY/MM/DD'))+55 no_time
FROM dual;
-- TO_DATE 때 'YYYY/MM/DD'안해도 되긴되네