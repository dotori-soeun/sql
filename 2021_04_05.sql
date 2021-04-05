인덱스 개체
오늘은 노말인덱스부터 만들어본다
(사용형식)
CREATE [UNIQUE|BITMAP] INDEX 인덱스명
ON 테이블명(컬럼명1[,컬럼명2....])[ASC|DESC];

사용예) 상품테이블에서 상품명으로 NORMAL INDEX를 구성하시오
CREATE INDEX IDX_PROD_NAME
ON PROD(PROD_NAME);

사용예) 장바구니 테이블에서 장바구니 번호 중 3번째에서 6글자로 인덱스를 구성하시오
(FUNCTION-BASED NORMAL 인덱스 : 함수기반 인덱스)

SELECT * FROM CART

CREATE INDEX IDX_CART_NO
ON CART(SUBSTR(CART_NO,3,6));

**인덱스의 재구성
 - 데이터 테이블을 다른 테이블 스페이스로 이동시킨 후
 - 자료의 삽입과 삭제 동작 후
(사용형식)
ALTER INDEX 인덱스명 REBUILD; -- 인덱스가 최신의 상태로 갱신됨

===========================================================================================

PL/SQL
 - PROCEDURAL LANGUAGE SQL의 약자
 - 표준 SQL에 절차적 언어의 기능(비교, 반복, 변수 등)이 추가
 - 블록(BLOCK) 구조로 구성
 - 미리 컴파일되어 실행 가능한 상태로 서버에 저장되어 필요시 호출되어 사용됨
 - 모듈화, 캡슐화 기능 제공
 - Anonymous Block, Stored Procedure, User Defined Function,
   Package, Trigger 등으로 구성
   
1. 익명블록
 - pl/sql의 기본 구조
 - 선언부와 실행부로 구성
 (구성형식)
DECLARE
    --선언영역
    --변수, 상수, 커서 선언
BEGIN
    --실행영역
    --BUSINESS LOGIC 처리
    
    [EXCEPTION
      예외처리명령;
    ]
END;
/ -- 책에 이렇게 슬러시 치라고 나오는 경우가 있을 수 있다(SQL PLUS처럼 라인에디터의 경우에만), 디벨로퍼에서는 필요없음

[보기] -> [DBMS출력]

사용예) 키보드로 2~9사이의 값을 입력 받아 그 수에 해당하는 구구단을 작성하시오

ACCEPT P_NUM PROMPT '수 입력(2~9) : '
DECLARE
  V_BASE NUMBER := TO_NUMBER('&P_NUM');
  V_CNT NUMBER := 0;
  V_RES NUMBER := 0;
BEGIN
  LOOP
    V_CNT := V_CNT+1;
    EXIT WHEN V_CNT > 9;
    V_RES := V_BASE*V_CNT;
    
    DBMS_OUTPUT.PUT_LINE(V_BASE||'*'||v_CNT||'*'||V_RES);
  END LOOP;
  
  EXCEPTION WHEN OTHER THEN
    DBMS_OUTPUT.PUT_LINE('예외발생 : '||SQLERRM);
END;    

-- ACCEPT (입력받는 명령) + 변수명 +PROMPT 다음에 나오는게 제목
-- P로 시작은 매개변수 파라미터, V로 시작은 변수 ( 보통 이렇게 쓰임)
-- 변수명 + 데이터타입 := (할당연산자 자바와 헷갈리지 않게!)
-- 참조하기 위해서 & 붙인거임
-- 오라클 초기화 시키지 않으면 무조건 숫자든 문자든 NULL이 들어간다
-- 사칙연산 하기 전엔 무조건 데이터 타입 맞춰주기 / NULL은 숫자로 형변환 안댐니당
-- LOOP ~ END LOOP 가 반복문 {} 이거 못쓰니까, 원칙적으로무한루프, 나갈 수 있는 명령문이 EXIT WHEN
-- DBMS_OUTPUT.PUT_LINE 출력함수 자바에서 Println같은고임
-- EXCEPTION WHEN OTHER THEN (자바의 익셉션 클래스와 같은고, THEN은 구냥 항상 쓰는고)
-- 자바 프린트스택트레이스 : 예외를 출력해주는 메소드 == SQLERRM ( 에스큐엘 에러메시지) : 시스템에서 제공해주는 변수임
여기까지가 익명 블록을 사용하는 방법

===========================================================================================

1) 변수, 상수 선언
 - 실행영역에서 사용할 변수 및 상수 선언
 (1) 변수의 종류
   . SCLAR 변수(스칼라변수) - 하나의 데이터를 저장하는 일반적 변수
   . REFERENCES 변수 - 해당 테이블의 컬럼이나 행에 대응하는 타입과 크기를 참조하는 변수
   . COMPOSITE 변수 - PL/SQL에서 사용하는 배열 변수
     RECODE TYPE
     TABLE TYPE 변수
   . BIND 변수 - 파라미터로 넘겨지는 IN, OUT, INOUT에서 사용되는 변수 RETURN값을 전달받기 위한 변수  
-- 자바에서 크기를 변환가능한거 JCF? 
-- 컴파일언어와 인터프리터언어 -> 자바는 반반치킨
-- 바인딩 : 변수의 값을 저장하는 것
-- 바인드 변수 중 될 수 있으면 INOUT은 사용하지 말아라 권고 사항

 (2) 선언방식
    변수명 [CONSTANT] 데이터타입 [:=초기값]
    -- 상수와 변수가 콘스탄트가 붙느냐 아니냐의 차이만 이따
    변수명 테이블명.컬럼명%TYPE [:=초기값]  
    --> 컬럼참조형 
    변수명 테이블명%ROWTYPE [:=초기값] 
    --> 행참조형
 (3) 데이터 타입    
   - 표준 SQL에서 사용하는 데이터 타입 
   - PLS_INTEGER, BINARY_INTEGER : 2147483647 ~ -2147483648 까지 자료처리
   -- 숫자는 구냥 NUMBER로 쓴다 생각햄
   - BOOLEAN : TRUE, FALSE, NULL 처리 -- 자바에서는 값 두개니까 서로 헷갈리기 없기
   - LONG, LONG RAW : DEPRECATED --(쓸수는 있으나 기능 업데이트 서비스 종료된 것)

예) 장바구니에서 2005년 5월 가장 많은 구매를 한 (구매금액 기준) 회원정보를 조회하시요
    : 회원번호, 회원명, 구매금액합
  
  (표준 SQL 버전) : --쌤은 그룹바이라고하심
  -- 윈도우 함수로 조인해서 할 수 없을까?? 야자시간에 다시???
  -- PL/SQL로는 어떤 쿼리를 보여줄라고 했을까>???
  
  SELECT *
  FROM   
  (SELECT A.CART_MEMBER 회원번호, 
         B.MEM_NAME 회원명, 
         SUM(PROD_PRICE*CART_QTY) 구매금액합
  FROM CART A, MEMBER B, PROD c
  WHERE A.CART_MEMBER = B.MEM_ID
  AND A.CART_PROD = C.PROD_ID
  GROUP BY A.CART_MEMBER, B.MEM_NAME
  ORDER BY 구매금액합 DESC)
  WHERE ROWNUM =1 ; 
  
  SELECT cart_member, cart_prod FROM cart
  SELECT mem_id FROM member
  SELECT prod_id FROM prod
      
  SELECT *
  FROM
  (SELECT cart_member 회원번호 , mem_name 회원명, SUM(prod_price*cart_qty) 구매금액_합 
  FROM cart c, member m, prod p
  WHERE c.cart_member = m.mem_id  AND  c.cart_prod = p.prod_id  
  GROUP BY cart_member, mem_name
  ORDER BY 구매금액_합 DESC)
  WHERE ROWNUM = 1 ;
  
  -- 윈도우 함수 사용이 안댈까--------------------------
  
  
  
  SELECT cart_member 회원번호 , mem_name 회원명, SUM(prod_price*cart_qty) 구매금액_합 
  FROM cart c, member m, prod p
  WHERE c.cart_member = m.mem_id  AND  c.cart_prod = p.prod_id  
  GROUP BY ROLLUP(cart_member, mem_name)
  
  
  SELECT job
     , deptno
     , SUM(sal) 
  FROM emp
 GROUP BY ROLLUP(job, deptno)
 
 
 
 
 DECLARE 
	V_num  cart.cart_member%TYPE;
    V_name   cart.mem_name%TYPE;
    V_event  prod.prod_price*cart.cart_qty%TYPE;

BEGIN
	SELECT 	cart_member, mem_name, prod.prod_price*cart.cart_qty INTO V_num, V_name, V_event
	FROM 	cart, member, prod 
	WHERE 	cart_member = mem_id  AND  cart_prod = prod_id

	DBMS_OUTPUT.PUT_LINE(SUM(event));

END;

plsql도무지 모르겠다 그래서 어떻게 쓰는건데?
 
 
 
  
  