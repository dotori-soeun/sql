0323과제 확인
<과제> 4번 과제 바탕으로 고객이름 컬럼 추가하기  
테이블을 3개 써야한다. 커스터머 테이블 추가임. 안시, 오라클 둘다 해보기
SELECT *
FROM customer ct
-- 안시
SELECT cnm, p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p LEFT OUTER JOIN cycle c  ON (p.pid = c.pid
    AND cid = :cid)
    LEFT OUTER JOIN customer ct ON (ct.cid = c.cid)
-- 오라클변환 왤케 어렵지????   왜 자꾸 오류가 나지?? 
SELECT cnm, p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p, cycle c, customer ct
WHERE p.pid = c.pid(+)
  AND c.cid = ct.cid(+)
  AND cid = :cid

SELECT  cnm, a.*
FROM customer ct, (SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
                FROM  product p, cycle c  
                WHERE p.pid = c.pid(+)
                AND c.cid(+) = :cid) a
WHERE ct.cid = :cid   
-- 쌤 설명 오라클변환 p,c를 인라인뷰하고 나머지를 그냥 조인
    
    
WinMerge  --> 비교툴 : 양쪽에 놓고 위에 새로고침
=================================================================================================
서브 실습 6] -- 다시 풀기 완료
cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제품 중
cid = 2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요
<정답>
SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid FROM cycle WHERE cid = 2)

서브 실습 7] -- 완전 틀림. 안나옴. 꼭 다시풀기 --> 스프레드 시트 그려보면서 연습
customer, cycle, product 테이블을 이용하여  실습 6에 고객명과 제품명을 넣어 주는 것
SELECT cnm, pnm, cycle.*
FROM cycle, customer, product
WHERE cycle.cid = customer.cid
  AND cycle.pid = product.pid
  AND cycle.cid = 1
  AND cycle.pid IN (SELECT pid
            FROM cycle
            WHERE cid =2)

=================================================================================================
함수때 유의해야할 것과 연산자 유의해야 할 것은 다르다.
함수때는 1. 함수 이름을 보고 얘가 뭐하는 함수인지 그리고 2. 어떤 인자가 필요할 것인지 잘 생각해보라 하심, 
연산자는 항상 "몇항인지" 잘 고민해봐라. 대다수는 2항 연산

EXISTS 서브쿼리 연산자 : 단항
[NOT] IN :  WHERE 컬럼 | EXPRESSION [NOT] IN (값1, 값2, 값3....)
        => IN : 서브 쿼리의 결과값을 메인 쿼리에 대입하여 조건 비교 후 결과를 출력한다.
        => IN쿼리 -> 메인쿼리
[NOT] EXISTS : WHERE [NOT] EXISTS (서브쿼리)
        ==> 서브쿼리 실행결과로 조회되는 행이 ***하나라도***있으면 TRUE, 없으면 FALSE
        EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 둘 다 사용가능하지만
        행을 제한하기 위해서 상호 연관 서브쿼리와 사용되는 경우가 일반적이다.
        => 메인쿼리의 결과값을 서브 쿼리에 대입하여 조건 비교 후 결과를 출력한다
        => 메인쿼리 -> EXISTS쿼리
        
        IN 연산자보다 유리한점
        서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더 이상 진행하지 않고 효율적으로 일을 끊어버린다.
        서브쿼리 데이터가 1000건이라 하더라도 10번째 행에서 EXISTS연산을 만족하는 행을 발견하면 나머지 990건 정도의 데이터는 확인 안한다.

-- 매니저가 존재하는 직원(서브쿼리를 사용하지 않고)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
-- 매니저가 존재하는 직원(서브쿼리를 사용하고)
SELECT *
FROM emp e
WHERE EXISTS (SELECT empno
              FROM emp m
              WHERE e.mgr = m.empno)
-- EXISTS사용법 좀 더 찬찬히 살펴보기              

EXISTS연산자와 함께 사용되는 서브쿼리의 SELECT절에는 관습적으로 X를 많이 쓴다.
서브쿼리가 참인지만 중요. 값은 안중요
--엔코아 칠거지악 확인해보기


서브 실습 9]
cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS연산자를 이용하여 작성

SELECT *
FROM product p
WHERE [NOT] EXISTS (
SELECT 'X'
FROM cycle c
WHERE cid = 1
AND p.pid= c.pid);

-- EXISTS 개념 자체를 받아들이기가 힘든듯

=================================================================================================
데이터를 확장하는 2가지 방법
1. 조인JOIN : 열(col)을 확장 -> 양 옆
2. 집합연산 : 행(row)를 확장 -> 위 아래 : 위 아래 집합의 col 개수와 타입이 일치해야한다.
                    : 컬럼갯수가 안 맞으면 가짜 컬럼 만들면 됨 -> NULL은 아무 타입과 같이 쓸 수 있다.

<<집합연산>> : 쿼리와 쿼리 사이에 쓰면 됨. 단 위의 쿼리를 ;로 끊지 않도록 조심~~

UNION : {a, b} U {a, c} = {a, a, b, c} ==> {a, b, c}
수학에서 이야기하는 일반적인 합집합
UNION : 합집합, 두개의 SELECT 결과를 하나로 합친다, 단 중복되는 데이터는 중복을 제거한다
      ==> 수학적 집합 개념과 동일


UNION ALL : {a, b} U {a, c} = {a, a, b, c}
중복을 허용하는 합집합
UNION ALL : 중복을 허용하는 합집합
            중복 제거 로직이 없기 때문에 (UNION 연산에 비해) 속도가 빠르다
            합집합 하려는 집합간 중복이 없다는 것을 알고 있을 경우 UNION 연산자 보다 UNION ALL 연산자가 유리하다
         
            
INTERSECT : (교집합) 두개의 집합중 중복되는 부분만 조회            

MINUS : (차집합) 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환
=================================================================================================
교환 법칙
A U B == B U A (UNION, UNION ALL)
A ^ B == B ^ A : 교집합임
A - B != B - A  => 집합의 순서에 따라 결과가 달라질 수 있다 [주의]

집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다
    그래서 양쪽에 ALIAS를 다 쓸 필요가 없음
2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다
   . 개별 집합에 ORDER BY를 사용한 경우 에러 ( 중간에 쓰면 에러라는거임)
     단 ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능 --> 근데 일반적인 경우는 잘 사용하지 않는다.
3. 중복된 제거 된다 (예외 UNION ALL)     
[4. 9i 이전버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다
    이후버전  ==> 정렬을 보장하지 않음 ]
    
=================================================================================================
DML
    . SELECT 
    . 데이터 신규 입력 : INSERT
    . 기존 데이터 수정 : UPDATE
    . 기존 데이터 삭제 : DELETE

INSERT 문법
INSERT INTO 테이블명 [({column,})] VALUES ({value, })

INSERT INTO 테이블명 (컬러명1, 컬럼명2, 컬럼명3....)
             VALUES (값1, 값2, 값3....)

만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 '컬럼명'은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);   

컬럼 순서 보기 : 1. DESC 테이블명
               2. 테이블 에서 찍어보기
세로로 나오긴하는데 컬럼 순서 번호 보면 된다.           
DESC dept;
DESC emp;
!!그냥 조회되어서 질의결과 나오는 거에선 컬럼명의 순서를 바꿀 수 있으니까 DESC 에서 나오는 순서가 맞는 순서

INSERT INTO emp (empno, ename, job) VALUES ('9999','brown', 'RANGER');

SELECT  *   FROM emp

--!!같은 INSERT 문을 두 번 이상 실행 시켰을 때 중복 안하게 하려면 추가적인 설정이 필요하다
--!! 또한 NOT NULL 이라고 되어있는 컬럼은 INSERT INTO 컬럼명 작성시 꼭 써야 한다!!!
--보통 그냥 빈칸으로 두면 NULL 이라고 나오긴함

INSERT INTO emp (empno, ename, job, hiredate, sal, comm)
        VALUES ('9998','sally', 'RANGER', TO_DATE('2021-03-24', 'YYYY-MM-DD'), 1000, NULL);


여러 건을 한 번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리
-- 셀렉트 쿼리로 만들어 낼 수 있는 데이터라면 한번에 INSERT하는게 빠르다


INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual 

SELECT * FROM dept

SELECT * FROM emp


**정리**
INSERT방법 : 1. 값 하나씩 넣기
            2. SELECT 쿼리로 통째로 넣기

=================================================================================================
UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경

UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2, 컬럼명3=값3.....
WHERE ;

WHERE 절이 누락 되었는지 확인
WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행

ROLLBACK 은 취소 COMMIT 은 확정
지금까지 한 DML들 전부 하나로 묶어서 트랜잭션이라 한다.
그 트랜잭션에 대한 제어 명령어

무료인 MY SQL이나 마리아는 기본설정이 오토커밋.
그러니까 난리난리 날 수 있다. 기본설정 해제하거나
UPDATE시에 반드시 WHERE 절 누락 되었는지 확인하자!!!!
쌤의 일화~... 어쨌든 나도 실수 하게 되겠지만... 제발 수습 가능한 정도이길


부서번호 99번 부서정보를 부서명 = 대덕IT, loc = 영민빌딩

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩' WHERE deptno = 99

내일은 => 공유드라이브에서 보기 
