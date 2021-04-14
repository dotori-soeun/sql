USER DEFINED FUNCTION(FUNCTION)
 - 사용자가 정의한 함수
 - 반환값이 존재 -> 반환값이 있으면 셀렉트문에서 쓸수있다 : 셀렉트절과 웨어절
 - 자주 사용되는 복잡한 Query 등을 모듈화 시켜 컴파일 한 후 호출하여 사용

(사용형식) 
CREATE [OR REPLACE] FUNCTION 함수명[( -- 함수명 보통 FN로 시작한다
    매개변수 [IN|OUT|INOUT] 데이터타입 [{:=|DEFAULT} expr][,] -- 매개변수 정의법은 프로슈져랑 똑같다
                                :    
    매개변수 [IN|OUT|INOUT] 데이터타입 [{:=|DEFAULT} expr])]
    RETURN 데이터타입 -- 리턴되어지는 데이터타입만, 세미콜론이나 데이터크기는 안씀
AS|IS
    선언영역; --변수, 상수, 커서
BEGIN
    실행문;
    RETURN 변수|수식; -- 쿼리가 나온 후 반드시 하나 이상의 리턴문이 나와야 한다
    [EXCEPTION
        예외처리문;]
END;


사용예) 장바구니 테이블에서 2005년 6월 5일 판매된 상품코드를 입력받아 상품명을 출력하는 함수를 작성하시오
    1. 함수명 : FN_PNAME_OUTPUT
    2. 매개변수 : 입력용 : 상품코드
    3. 반환값 : 상품명
(함수 생성)
CREATE OR REPLACE FUNCTION FN_PNAME_OUTPUT(
    P_CODE IN PROD.PROD_ID%TYPE) -- P_CODE는 입력용 매개변수
    RETURN VARCHAR2 -- 리턴문에 일반 변수형 써도 되고 아님 참조형을 써도 된다
IS
    V_PNAME PROD.PROD_NAME%TYPE; -- VARCHAR2 대신 쓴 타입
    -- 이름을 구해서 잠시 집어늘 함수
    -- 평션에서는 변수가 많이 사용됨. 반환값을 변수에 담아서 내니까
BEGIN
    SELECT PROD_NAME INTO V_PNAME
    FROM PROD
    WHERE PROD_ID = P_CODE; --'상품코드가 입력용 매개변수로 받은 코드와 같은' 이라는 조건
    
    RETURN V_PNAME;
END;

(실행)
SELECT CART_MEMBER, FN_PNAME_OUTPUT(CART_PROD)
FROM CART
WHERE CART_NO LIKE '20050605%';
--> 행이 3개 나옴. 함수가 알아서 3번 호출되어짐 : 커서를 안써도 됨 : 이게 프로슈져와의 차이

-- 프로슈져에서 커서를 쓰는 이유 : 실행명령에서 통째로 들어온 값을 하나씩 하나씩 처리하기 위해


=====================================================================================

사용예) 2005년 5월 모든 상품에 대한 매입현황을 조회하시오
    ALIAS는 상품코드, 상품명, 매입수량, 매입금액
--> 펑션이 없다면 무슨 구문을 써야 할까? 조인-> 그중에서 아우터조인-> 일반아우터조인은 못쓴다-> 왜냐하면 일반조건이 껴있어서
--> 그러면 해결할 수 있는 방법 : 1. 안시아우터조인,  2.서브쿼리

    (OUTER JOIN 조인만 갖고 해보기)
-- 문제에서 '모든'이라는 말이 빠지면 조인하나하고(상품명땜에) 그룹바이만 해도 된다. LPROD에 데이터 거진다 이씀
SELECT B.PROD_ID 상품코드, B.PROD_NAME 상품명, SUM(A.BUY_QTY)매입수량, SUM(A.BUY_QTY * B.PROD_COST) 매입금액
FROM BUYPROD A, PROD B -- 부족한 쪽의 상품코드를 쓰면 NULL이 나와
WHERE A.BUY_PROD(+) = B.PROD_ID
  AND A.BUY_DATE BETWEEN '20050501' AND '20050531'
GROUP BY B.PROD_ID, B.PROD_NAME -- 그냥 이렇게 하면 36개밖에 안나와 -> 내부조인결과로 나옴
                                   --> 웨어절의 2번째 조건이 일반조건이라서! --> 그래서 해결하려면 안시조인이나 서브쿼리!     
-- 아우터 조인 주의점!
-- 양쪽이 모두 같은 컬럼을 갖고 있다면 많은 쪽 거를 쓰자
-- 카운트쓸때 *쓰면 안댐. 자료가 없어도 NULL이라도 행으로 보니까 1이 나옴

    (ANSI OUTER JOIN 조인을 써보자)
SELECT B.PROD_ID 상품코드, B.PROD_NAME 상품명, 
       NVL(SUM(A.BUY_QTY), 0) 매입수량, 
       NVL(SUM(A.BUY_QTY * B.PROD_COST), 0) 매입금액
FROM BUYPROD A RIGHT OUTER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID -- ON안에서는 (+)같은거 안씀
  AND A.BUY_DATE BETWEEN '20050501' AND '20050531')
GROUP BY B.PROD_ID, B.PROD_NAME

    (서브쿼리를 써보자)
    -- 날짜를 서브쿼리쪽에 해결하고 메인에는 일반아우터조인으로다가
SELECT BUY_PROD BID, SUM(BUY_QTY) QAMT, SUM(BUY_QTY * BUY_COST) HAMT
FROM BUYPROD
WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
GROUP BY BUY_PROD;
-- 36개의 제품별 판매되어진것만 나오면 된다. 이제 이거랑 PROD랑 아우터 조인시키면 된다
SELECT B.PROD_ID 상품코드, B.PROD_NAME 상품이름, NVL(A.QAMT, 0) 매입수량, NVL(A.HAMT, 0) 매입금액
FROM (SELECT BUY_PROD BID, SUM(BUY_QTY) QAMT, SUM(BUY_QTY * BUY_COST) HAMT
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
        GROUP BY BUY_PROD) A, PROD B
WHERE A.BID(+) = B.PROD_ID; -- 더 적은 쪽에 프라스

    (함수를 써보자 : 생성)
CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2
    -- 리턴해야할게 매입수량과 매입금액 합계인데 함수나 프로슈져는 리턴해주는게 한 개다
    -- 그러면 문자열로 합칠 수 밖에
IS
    V_RES VARCHAR2(100); -- 매입수량과 매입금액을 문자열로 변환하여 기억할 기억공간 -> 결국 이게 반환될 데이타임 
    V_QTY NUMBER := 0; -- 매입수량 합계
    V_AMT NUMBER := 0; -- 매입금액 합계
BEGIN
    SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST) INTO V_QTY, V_AMT
    FROM BUYPROD
    WHERE BUY_PROD = P_CODE
    AND BUY_DATE BETWEEN '20050501' AND '20050531';
    IF V_QTY IS NULL THEN V_RES := '0';
    ELSE
    V_RES := '수량 : '||V_QTY||', '||'구매금액 : '||TO_CHAR(V_AMT, '99,999,999');
    END IF;
    RETURN V_RES;
END;

    (함수를 써보자 : 실행)
SELECT PROD_ID 상품코드, PROD_NAME 상품명, FN_BUYPROD_AMT(PROD_ID) 매입수량과_금액_합계
FROM PROD;

=====================================================================================

문제] 상품코드를 입력받아 2005년도 평균판매횟수, 판매수량 합계, 판매금액 합계를 출력할 수 있는 함수를 작성하시오
    1. 함수명 : FN_CART_QAVG -- 평균판매횟수
               FN_CART_QAMT -- 전체판매수량
               FN_CART_FAMT -- 판매금액 합계
    2. 매개변수 : 입력 : 상품코드, 년도  

CREATE OR REPLACE FUNCTION FN_CART_QAVG(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR CHAR)
    RETURN NUMBER
AS
    V_QAVG NUMBER := 0;
    V_YEAR CHAR(5) := P_YEAR||'%';
BEGIN
    SELECT ROUND(AVG(CART_QTY)) INTO V_QAVG
    FROM CART
    WHERE CART_NO LIKE V_YEAR
    AND CART_PROD = P_CODE;
    
    RETURN V_QAVG;
END;

(실행)
SELECT PROD_ID, PROD_NAME, FN_CART_QAVG(PROD_ID,'2005') FROM PROD

-- 다음 함수 두 개는 여러분이 만들어라


=====================================================================================

문제] 2005년 2~3월 제품별 매입수량을 구하여, 재고 수불 테이블을 UPDATE하세요
    처리일자는 2005년 3월 마지막일임 -- 함수이용
BUYPPROD / REMAIN

    재고 수불테이블을 update하는 함수를 생성하시오
    1. 프로시져명 : PROC_REMAIN_IN
    2. 매개변수 : 상품코드, 매입수량
    3. 처리내용 : 해당 상품코드에 대한 입고수량, 현재고수량, 날짜 UPDATE
    
** 1. 2005년 상품별 매입수량 집계 -- 함수 밖에서 처리
      -- 셀렉트, 그룹바이절 & 함수(하나씩 뽑아서 프로시져한테 줘야하니까)
   2. 1의 결과 각 행을 PROCEDURE에 전달
   3. PROCEDURE에서 재고 수불테이블 UPDATE


( 생성) 
 CREATE OR REPLACE FUNCTION FN_CNT(
   P_CODE IN PROD.PROD_ID%TYPE,
   P_CNT IN NUMBER)
   RETURN NUMBER
 IS
   V_INCNT NUMBER := P_CNT;
 BEGIN
   UPDATE REMAIN
   SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) 
        = (SELECT REMAIN_I+P_CNT, REMAIN_J_99+P_CNT, TO_DATE('20050331')
            FROM REMAIN
            WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = P_CODE)
   WHERE REMAIN_YEAR = '2005'
   AND PROD_ID = P_CODE;
   
   RETURN V_INCNT;
 END;
  
(2005년 2~3월 상품별 매입집계)
SELECT BUY_PROD 상품코드, SUM(BUY_QTY) 매입수량
FROM BUYPROD
WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
GROUP BY BUY_PROD;
 
 
SELECT REMAIN_I, REMAIN_J_99, REMAIN_DATE, FN_CNT(B.상품코드, B.매입수량)
FROM REMAIN, (SELECT BUY_PROD 상품코드, SUM(BUY_QTY) 매입수량 
                FROM BUYPROD
                WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
                GROUP BY BUY_PROD) B
WHERE B.상품코드 = REMAIN.PROD_ID

                SELECT BUY_PROD, SUM(BUY_QTY), FN_CNT(BUY_PROD, SUM(BUY_QTY))
                FROM BUYPROD
                WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
                GROUP BY BUY_PROD

   
DECLARE
  V_CODE BUYPROD.BUY_PROD%TYPE
  V_QTY BUYPROD.BUY_QTY%TYPE
BEGIN
  
END;


-- 존나 짜증나 ㅓㅇㅁ니ㅏ러ㅏㅣㅓㅇㅁ나ㅣㄹ ㅅㅄㅄㅄㅅㅄㅂ아ㅣ허ㅏㅣ러아ㅣㅎㅇㄹ


=====================================================================================

트리거 : 자동화된 모듈이 돌아가는것. 가장 많이 사용한다

TRIGGER
 - 어떤 이벤트가 발생하면 그 이벤트의 발생 전, 후로 자동적으로 시행되는 코드블록(프로시져의 일종)
(사용형식)
CREATE TRIGGER 트리거명
    (trimming)BEFORE|AFTER  (event)INSERT|UPDATE|DELETE
    ON 테이블명
    [FOR EACH ROW] --> 이거 쓸때만 콜론 올드, 콜론 뉴 이거 쓰고 문장단위에 쓰는건 못씀
    [WHEN 조건]
[DECLARE
    변수, 상수, 커서;
]    
BEGIN
    명령문(들); --트리거처리문
    [EXCEPTION
        예외처리문;
    ]    
END;

 . 'trimming' : 트리거처리문 수행 시점(BEFORE : 이벤트 발생전, AFTER : 이벤트 발생후)
 . 'event' : 트리거가 발생될 원인 행위 (OR 로 연경 사용 가능, ex) INSERT OR UPDATE OR DELETE)
 . '테이블명' : 이벤트가 발생되는 테이블이름
 . 'FOR EACH ROW' : 행단위 트리거 발생, 생략되면 문장단위 트리거 발생
 . WHEN 조건 : 행단위 트리거에서만 사용 가능, 이벤트가 발생될 세부조건 추가 설정 --> 우리가 아는 WHEN이 아님

=======================================================================================================================
자바시간에 배운거

-- 혹시나 실수로 삭제 했다면
-- INSERT INTO MEMBER
SELECT sal
FROM emp AS OF TIMESTAMP(SYSTIMESTAMP -  INTERVAL '10' MINUTE)


WHERE MEM_ID = 'a001';

10분전꺼 조회하는 쿼리
