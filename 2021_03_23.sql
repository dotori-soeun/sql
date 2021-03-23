OUTER JOIN 을 보통 어디에서 쓰냐하면 [월별실적]
            반도체     핸드폰     냉장고
2021년 1월 : 500       300        400    
2021년 2월 : 0           0          0 
2021년 3월 : 500       300        400 
.
.
.
2021년 12월 : 500       300        400 

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
    AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');
--> NVL을 써서 NULL값을 예쁘게 만들어보자    
SELECT buy_date, NVL(buy_prod, 0), prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
    AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');    
    

OUTERJOIN2,3]-사진. 좋은 문제라고는 볼 수 없지만 실무에서는 나오는 사례
buy_date 컬럼이 null인 항목이 안나오도록 쿼리 작성
SELECT NVL(buy_date,TO_DATE(:yyyymmdd, 'YYYY/MM/DD')) buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
    AND buy_date(+) = TO_DATE(:yyyymmdd, 'YYYY/MM/DD'); 
--> buy_date를 TO_DATE(:yyyymmdd, 'YYYY/MM/DD')로 치환해버림   
--> NVL(buy_date, TO_DATE(:yyyymmdd, 'YYYY/MM/DD'))이렇게도 가능
--> 근데 buy_date가 비트윈 조건에 걸려있거나 하면 둘다 이런거 불가
--> 완전 하드 코딩


OUTERJOIN4]-사진. 이런유형 좀 제대로 더 복습
-- 조인에 실패해도 나와야하는 데이터가 어떤건지 알자(레프트 아웃일지 라이트 아웃일지)
cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
애음하지 않는 제품도 조회되도록
(고객은 cid = 1인 고객만 나오도록 제한, null처리)

SELECT *
FROM cycle;

SELECT *
FROM product;

--쌤풀이 시작    
SELECT c.pid, pnm, cid, day, cnt
FROM  product p LEFT OUTER JOIN cycle c  ON (p.pid = c.pid
    AND cid = 1);
-- 일단 1번 고객이 안먹는 제품들도 다 나왔음
SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p LEFT OUTER JOIN cycle c  ON (p.pid = c.pid
    AND cid = :cid);    
-- 최종쌤풀이 안시
SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
  FROM product p,cycle c 
WHERE p.pid = c.pid(+)
   AND cid(+) = :cid;
-- 최종썜풀이 오라클 변환 : 아우터 조인 변환할 때 WHERE절 (+) 붙이는 곳 잘 보고 잘 생각하고 잘 이해하기
  
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
  AND c.cid(+) = p.:cid
  AND ct.cid = c.:cid(+)

WHERE, GROUP BY(그룹핑), JOIN : 개념정리 잘하시길 바랍니다.

JOIN 
카테고리
문법에 따라 : 안시/ 벤더사의 오라클
논리적 형태에 따라 : SELF JOIN(동일한 테이블 간의 조인), 
    NON-EQUI-JOIN(나중에 이걸 할줄아냐에 따라 작업속도차이날 수있고 아예 작업 못할 수도!!!!!!
        (연결 조건이 이퀄이 아닌 것 - 예제로 급여등급 풀었었음. 비트윈앤드써서 연결했었음) <==> EQUI-JOIN
연결조건 성공 실패에 따라 조회여부 결정 : OUTERJOIN 
        <==> INNER JOIN(연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인. 아우터가 아니면 전부 이너조인
        INNER JOIN이라고 키워드 써도 되긴하는데 굳이...?)        


CROSS JOIN
 . 별도의 연결 조건이 없는 조인
 . 묻지마 조인
 . 두 테이블의 행간 연결가능한 모든 경우의 수로 연결 
    ==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한 값과 같은 행이 반환된다.
 . 데이터를 보여줄 때보다 보여주기 위한 중간 과정에서 쓸 때가 가끔있다.  
 . 보통 데이터 복제를 위해 사용
-- 크로스 조인 예제
SELECT *
FROM emp, dept; -- 오라클
SELECT *
FROM emp CROSS JOIN dept; -- 안시
-- 그럼 emp의 행 하나가 dept의 모든행과 연결됨
-- 행의 수 : 두테이블 행의 곱

CROSS JOIN 1]
customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 조회되도록 쿼리 작성
SELECT *
FROM customer, product; -- 오라클
SELECT *
FROM customer CROSS JOIN product; -- 안시

===============================================================================================
한번 끊고 갈 타이밍 :  <<그룹함수, 아우터조인, ROWNUM >> 꼭 복습하기

SELECT storecategory
FROM burgerstore
WHERE sido = '대전'
GROUP BY storecategory;

-- 대전 중구의 버거지수 구하기
수식 : 도시발전지수 : (kfc + 맥도날드 + 버거킹) / 롯데리아

SELECT *
FROM burgerstore
WHERE sido = '대전'
  AND sigungu = '중구';
  
(1+3+2) / 3 = 2  

대전 중구 2
SELECT sido, sigungu, 도시발전지수
FROM burgerstore
WHERE sido = '대전'
  AND sigungu = '중구';

SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
FROM burgerstore
WHERE sido = '대전'
  AND sigungu = '중구'
GROUP BY STORECATEGORY

SELECT sum(b.count)
FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
FROM burgerstore
WHERE sido = '대전'
  AND sigungu = '중구'
GROUP BY STORECATEGORY) b;

SELECT sum(b.count) x
FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
    FROM burgerstore
    WHERE sido = '대전'
    AND sigungu = '중구'
    GROUP BY STORECATEGORY) b
WHERE STORECATEGORY IN ('MACDONALD', 'BURGER KING', 'KFC') X;

SELECT b.count y
FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
    FROM burgerstore
    WHERE sido = '대전'
    AND sigungu = '중구'
    GROUP BY STORECATEGORY) b
WHERE STORECATEGORY IN 'LOTTERIA' Y;

(SELECT x/y 도시발전지수
FROM (SELECT sum(b.count) x
    FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
        FROM burgerstore
        WHERE sido = '대전'
        AND sigungu = '중구'
        GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN ('MACDONALD', 'BURGER KING', 'KFC')) X,    
    (SELECT b.count y
    FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
        FROM burgerstore
        WHERE sido = '대전'
        AND sigungu = '중구'
        GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN 'LOTTERIA') Y) dosi


SELECT DISTINCT sido, sigungu, 도시발전지수
FROM burgerstore, (SELECT x/y 도시발전지수
    FROM (SELECT sum(b.count) x
     FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
         FROM burgerstore
         WHERE sido = '대전'
            AND sigungu = '중구'
            GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN ('MACDONALD', 'BURGER KING', 'KFC')) X,    
    (SELECT b.count y
    FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
        FROM burgerstore
        WHERE sido = '대전'
        AND sigungu = '중구'
        GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN 'LOTTERIA') Y) dosi
WHERE sido = '대전'
  AND sigungu = '중구';

===============================================================================================
--테이블을 1번만 읽고 끝내는 방법
--행을 컬럼으로 변경(엑셀에서 PIVOT)
SELECT sido, sigungu, storecategory
FROM burgerstore;

SELECT sido, sigungu, storecategory, 
    storecategory가 BURGER KING이면 1, 0 ,
    storecategory가 KFC이면 1, 0 ,
    storecategory가 MACDONALD이면 1, 0 ,
    storecategory가 LOTTERIA이면 1, 0 
FROM burgerstore;
-- 조건분기

SELECT sido, sigungu, storecategory, 
    CASE
        WHEN storecategory = 'BURGER KING' THEN 1
        ELSE 0
    END bk    
FROM burgerstore;
-- CASE절 : 너무 길어서

SELECT sido, sigungu, storecategory, 
    DECODE(storecategory, 'BURGER KING', 1, 0) bk,
    DECODE(storecategory, 'KFC', 1, 0) kfc,
    DECODE(storecategory, 'MACDONALD', 1, 0) mac,
    DECODE(storecategory, 'LOTTERIA', 1, 0) lt
FROM burgerstore;
-- DECODE

SELECT sido, sigungu, 
    DECODE(storecategory, 'BURGER KING', 1, 0) bk,
    DECODE(storecategory, 'KFC', 1, 0) kfc,
    DECODE(storecategory, 'MACDONALD', 1, 0) mac,
    DECODE(storecategory, 'LOTTERIA', 1, 0) lt
FROM burgerstore
ORDER BY sido, sigungu;
-- 정렬

SELECT sido, sigungu, 
    SUM (DECODE(storecategory, 'BURGER KING', 1, 0)) bk,
    SUM (DECODE(storecategory, 'KFC', 1, 0)) kfc,
    SUM (DECODE(storecategory, 'MACDONALD', 1, 0)) mac,
    SUM (DECODE(storecategory, 'LOTTERIA', 1, 0)) lt
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;
-- 그룹바이 : 그룹바이에 나오지 않은 컬럼들은 그룹함수가 적용되어야 한다.

SELECT sido, sigungu, 
    (SUM (DECODE(storecategory, 'BURGER KING', 1, 0)) bk +
    SUM (DECODE(storecategory, 'KFC', 1, 0)) kfc +
    SUM (DECODE(storecategory, 'MACDONALD', 1, 0)) ) mac /
    SUM (DECODE(storecategory, 'LOTTERIA', 1, 0)) lt
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;
-- 그냥 이대로 하면 에러. 나누는 수가 0이면 에러니까

SELECT sido, sigungu, 
    ROUND(SUM (DECODE(storecategory, 'BURGER KING', 1, 0)) +
    SUM(DECODE(storecategory, 'KFC', 1, 0))  +
    SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) ) /
    DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)), 0, 1, SUM(DECODE(storecategory, 'LOTTERIA', 1, 0))), 2)idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;
-- 마무리는 쌤 필기 보고 하기 - 사진으로 찍어둠

========================================================================================================
그다음 한 시간 시험 . 쌤 채점 후 나중에 돌려주신다심