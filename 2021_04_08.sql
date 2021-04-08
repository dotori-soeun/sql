펑션과 프로슈져의 가장 큰 차이는 반환값이 있는가 -> 리턴문에 의해 되돌려지는게 있는지
프로시져는 반환값이 없으니까

저장프로시져(Stored Procedure : Procedure)
 - 특정 결과를 산출하기 위한 코드의 집합(모듈)
 - 반환값이 없음
 - 컴파일되어 서버에 보관(실행속도를 증가, 은닉성, 보안성)
 (사용형식)
 CREATE [OR REPLACE] PROCEDURE 프로시져명[( -- ->프로시져명은 보통PROC_ 하고 시작한다. 
   매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
   매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
                            :
   매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr])]
 AS | IS
    선언영역;
 BEGIN
    실행영역;
 END;
 
 --실제로 많이 쓰는것 : 프로시져 펑션 트리거 패키지 -> 익명블록을 기반으로 하고 있다(반복문이 루프문을 기반하듯이)
 --값을 반환하지 않는게 프로시져 : 자바의 보이드와 같다
 --값을 반환하는 것은 펑션 -> 셀렉트문에서 호출해서 실행가능(웨어절, 셀렉트절)
 --프로시져는 반환값이 없으니까 독립적으로 실행시켜야한다. <<펑션이랑 위치 완전히 다르니까>>
 --매개변수 값을 프로시져에게 가져오고(IN) 내보내고(OUT)/ 인아웃은 있지만 될수있으면 쓰지말라고 오라클 권고
 --데이터타입자리에는 데이터타입만 가져오기. 크기지정은 절대 안댄단다~~ 조심~~ ->필요하면 디폴트 지정은 가능 
 -- CREATE절에 ; 안붙는단다
 
 
 <테이블 컬럼명 변경>
ALTER TABLE 테이블명
  RENAME COLUMN 변경대상컬럼명 TO 변경컬럼명;
ex) TEMP 테이블의 ABC를 QAZ라는 컬럼명으로 변경
  ALTER TABLE TEMP
    RENAME COLUMN ABC TO QAZ;
    
 <테이블 컬럼 데이터타입(크기) 변경>    
ALTER TABLE 테이블명
  MODIFY 컬럼명 데이터타입(크기)
ex) TEMP 테이블의 ABC컬럼을 NUMBER(10)으로 변경하는 경우
  ALTER TABLE TEMP
    MODIFY ABC NUMBER(10);
    -- 해당 컬럼의 내용을 모두 지워야 변경가능

===========================================================================================     
 
 사용예) 오늘이 2005년 1월 31일이라고 가정하고 오늘까지 발생된 상품입고 정보를 이용하여
    재고 수불테이블을 update하는 프로시져를 생성하시오
    1. 프로시져명 : PROC_REMAIN_IN
    2. 매개변수 : 상품코드, 매입수량
    3. 처리내용 : 해당 상품코드에 대한 입고수량, 현재고수량, 날짜 UPDATE
    
** 1. 2005년 상품별 매입수량 집계 -- 프로시져 밖에서 처리
      -- 셀렉트, 그룹바이절 & 커서(하나씩 뽑아서 프로시져한테 줘야하니까)
   2. 1의 결과 각 행을 PROCEDURE에 전달
   3. PROCEDURE에서 재고 수불테이블 UPDATE


(PROCEDURE 생성) 
 CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN(
   P_CODE IN PROD.PROD_ID%TYPE,
    -- 매개변수를 보통 아규먼트 또는 파라미터라고 하니까 여기선 파라미터의 P를 앞에 둔다
    -- 매개변수를 선언할 때도 참조형 데이터를 쓸 수 있다
    -- 매개변수 명 뒤에 IN을 생략하면 다 IN으로 처리됨
   P_CNT IN NUMBER)
    -- 매개변수 이름 뒤에 괄호열고 크기쓰면 오류입니다
 IS
 -- 이 안에서는 변수 상수 커서 선언(비긴앤드 안에서 쓰는 지역변수를 쓴다)
 BEGIN
   UPDATE REMAIN
   SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) 
        = (SELECT REMAIN_I+P_CNT, REMAIN_J_99+P_CNT, TO_DATE('20050131')
            FROM REMAIN
            WHERE REMAIN_YEAR = '2005'
            AND PROD_ID = P_CODE)
   WHERE REMAIN_YEAR = '2005'
   AND PROD_ID = P_CODE;
 END;
 
 
(PROCEDURE 실행명령)
  EXEC|EXECUTE 프로시져명[(매개변수 list)];
  - 단, 익명블록 등 또 다른 프로시져나 함수에서 프로시져 호출시 'EXEC|EXECUTE'는 생략해야한다.
  
(2005년 1월 상품별 매입집계)
SELECT BUY_PROD BCODE, SUM(BUY_QTY) BAMT
FROM BUYPROD
WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
GROUP BY BUY_PROD;
 
(익명블록 작성)
DECLARE
  CURSOR CUR_BUY_AMT
  IS
    SELECT BUY_PROD BCODE, SUM(BUY_QTY) BAMT
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
    GROUP BY BUY_PROD;
BEGIN
  FOR REC01 IN CUR_BUY_AMT LOOP
    PROC_REMAIN_IN(REC01.BCODE, REC01.BAMT);
    -- 셀렉트 구문을 수행했을때 나오는 첫줄의 이름이 REC01
    -- 첫줄에는 비코드라는 컬럼과 비에이엠티라는 컬럼이 있으니까
  END LOOP;
END;
 
**REMAIN 테이블의 내용을 VIEW로 구성 -- 검증을 하기 위함
CREATE OR REPLACE VIEW V_REMAIN01
AS
  SELECT * FROM REMAIN;
 
SELECT * FROM V_REMAIN01; 
SELECT * FROM V_REMAIN02; 

CREATE OR REPLACE VIEW V_REMAIN02
AS
  SELECT * FROM REMAIN;

===========================================================================================
 
사용예) 회원아이디를 입력받아 그 회원의 이름, 주소와 직업을 반환하는 프로시져를 작성하시오
-- 프로시져는 매개변수를 통해서 반환되어질 수는 있음
-- 프로시져가 리턴문을 통한 반환이 없다는 거임
    1. 프로시져명 : PROC_MEM_INFO
    2. 매개변수 : 입력용 : 회원아이디 1개
                 출력용 : 회원의 이름, 주소와 직업 3개
                 
(프로시져 생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_INFO(
  P_ID IN MEMBER.MEM_ID%TYPE,
  P_NAME OUT MEMBER.MEM_NAME%TYPE,
  P_ADDR OUT VARCHAR2, 
    -- MEMBER.MEM_ADD1, MEMBER.MEM_ADD2 이러케 두 개니까 구냥 바챠타입으로 해버림
  P_JOB OUT MEMBER.MEM_JOB%TYPE)
AS
BEGIN
    SELECT MEM_NAME, MEM_ADD1||' '||MEM_ADD2, MEM_JOB
    INTO P_NAME, P_ADDR, P_JOB -- 우에 셀렉트에 있는값이 들어감
    FROM MEMBER
    WHERE MEM_ID = P_ID;
END;


(실행)
ACCEPT PID PROMPT '회원아이디 : '
DECLARE
  V_NAME MEMBER.MEM_NAME%TYPE;
  V_ADDR VARCHAR2(200);
  V_JOB MEMBER.MEM_JOB%TYPE;
BEGIN
  PROC_MEM_INFO('&PID', V_NAME, V_ADDR, V_JOB);
  DBMS_OUTPUT.PUT_LINE('회원아이디 : '||'&PID');
  DBMS_OUTPUT.PUT_LINE('회원이름 : '||V_NAME);
  DBMS_OUTPUT.PUT_LINE('주소 : '||V_ADDR);
  DBMS_OUTPUT.PUT_LINE('직업 : '||V_JOB);
END;  
 
===========================================================================================
문제] 년도를 입력 받아 해당 년도에 구매를 가장 많이 한 회원의 이름과 구매액을 반환하는 프로시저를 작성
    1. 프로시져명 : PROC_MEM_PTOP
    2. 매개변수 : 입력용 : 년도(1개)
                 출력용 : 회원명, 구매액(2개)
 
CREATE OR REPLACE PROCEDURE PROC_MEM_PTOP(
  P_YEAR IN CHAR,  -- 타입을 그냥 CHAR로 해도 된다 VARCHAR2도 괜춘. 어차피 그냥 받으면 댑니다
  P_NAME OUT MEMBER.MEM_NAME%TYPE,
  P_PRICE OUT VARCHAR2) -- 구매금액은 숫자니까 VARCHAR2 대신 NUMBER써줘도 댐
AS
BEGIN
    SELECT a.MNAME, a.구매
    -- 여기서 *를 쓰면 안대는게 컬럼값 하나씩 지정해서 넣어줘야하니까
    INTO P_NAME, P_PRICE
    FROM (SELECT MEMBER.MEM_NAME MNAME, SUM(CART.CART_QTY*PROD.PROD_PRICE) 구매
         FROM CART, PROD, MEMBER
         WHERE PROD_ID = CART_PROD
         AND CART_MEMBER = MEM_ID
         AND SUBSTR(CART_NO,1,4) = P_YEAR 
         -- 서브스트링과 피 이어가 이리로 옴 , 들어온 자료를 여기서 비교
         GROUP BY MEMBER.MEM_NAME
         ORDER BY 구매 DESC) a -- 여기 오더바이절에 셀렉트절 컬럼 순서 번호 써도 댐. 구매 같은 경우 3
    WHERE ROWNUM = 1 ;  
END; 
-- 추가로 알게된 것 : 연산자를 알리아스로 쓰지말자 . 예시 YEAR같은거
-- MAX안에 SUM을 쓸 수 없으니 내림차 정렬해서 ROWNUM 한고야

--SELECT SUBSTR(CART_NO,1,4)
--FROM CART
-- 
--SELECT CART.CART_MEMBER, SUM(CART.CART_QTY*PROD.PROD_PRICE) 구매
--FROM CART, PROD
--WHERE PROD_ID = CART_PROD
--GROUP BY CART.CART_MEMBER
--ORDER BY 구매 DESC
--
--MEMBER.MEM_ID
--
--    SELECT SUBSTR(CART_NO,1,4) YEAR , MEMBER.MEM_NAME, SUM(CART.CART_QTY*PROD.PROD_PRICE) 구매
--    FROM CART, PROD, MEMBER
--    WHERE PROD_ID = CART_PROD
--    AND CART_MEMBER = MEM_ID
--    GROUP BY SUBSTR(CART_NO,1,4), MEMBER.MEM_NAME   

ACCEPT PID PROMPT '연도 : '
DECLARE
  V_NAME MEMBER.MEM_NAME%TYPE;
  V_PRICE VARCHAR2(200); -- 실행하는데서는 크기 지정해줘야 대나보네
  -- VARCHAR2  말고 NUMBER인 경우 크기를 지정 안해도 상관은 없으나 반드시 초기화는 시켜줄 것
  -- V_PRICE NUMBER := 0; 
BEGIN
  PROC_MEM_PTOP('&PID', V_NAME, V_PRICE); -- 블럭에서 하나의 프로슈져를 호출할때 EXEC | EXECUTE 이거 생략한다.
  DBMS_OUTPUT.PUT_LINE('연도 : '||'&PID');
  DBMS_OUTPUT.PUT_LINE('최대구매회원 : '||V_NAME);
  DBMS_OUTPUT.PUT_LINE('구매가격합계 : '||V_PRICE);
  -- 구매금액을 NUMBER로 했다면 출력할때 TO_CHAR(V_PRICE, '99,999,999')해줘도 된다
END; 

===========================================================================================

문제] 2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의 삭제여부컬럼 (MEM_DELETE)의 값을 
    'Y'로 변경하는 프로시져를 작성하시오 -> VARCHAR2(1)
    
 CREATE OR REPLACE PROCEDURE PROC_MEM_DEL(
   P_ID IN MEMBER.MEM_ID%TYPE)
--   ,P_NAME IN MEMBER.MEM_NAME%TYPE)
 IS
 -- 이 안에서는 변수 상수 커서 선언(비긴앤드 안에서 쓰는 지역변수를 쓴다)
 BEGIN
   UPDATE MEMBER
   SET MEM_DELETE = 'Y'
   WHERE MEM_ID NOT IN (SELECT CART_MEMBER FROM CART)
   AND MEM_ID = P_ID;
 END;    
 
  EXECUTE PROC_MEM_DEL(P_ID); --- 이걸루 실행안대나??? 익명블록 만들어야해???
  
  
  
DECLARE
  CURSOR CUR_MEM_DEL
  IS
    SELECT BUY_PROD BCODE, SUM(BUY_QTY) BAMT
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
    GROUP BY BUY_PROD;
BEGIN
  FOR REC01 IN CUR_BUY_AMT LOOP
    PROC_REMAIN_IN(REC01.BCODE, REC01.BAMT);
    -- 셀렉트 구문을 수행했을때 나오는 첫줄의 이름이 REC01
    -- 첫줄에는 비코드라는 컬럼과 비에이엠티라는 컬럼이 있으니까
  END LOOP;
END;  
  
 
     
SELECT MEM_ID, MEM_NAME, MEM_DELETE
FROM MEMBER
WHERE MEM_ID NOT IN (SELECT CART_MEMBER FROM CART)

만일 여러명이라면 커서에서 생성해서 루프로 하나씩 읽어서 멤버테이블하고 비교한다
값을 변경 -> 업데이트
