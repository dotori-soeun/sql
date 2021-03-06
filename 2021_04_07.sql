<<반복문>>
  - 개발언어의 반복문와 같은 기능 제공
  - loop, while, for 문
 1)LOOP 문 
  . 반복문의 기본 구조
  . JAVA의 DO문과 유사한 구조
  . 기본적으로 무한 루프 구조
  (사용형식)
  LOOP
    반복처리문(들);
    [EXIT WHEN 조건;]
  END LOOP;
   - 'EXIT WHEN 조건' : '조건'이 참인 경우 반복문의 범위를 벗어남
-- 컴퓨터를 켜면 바로 나오는 운영체제가 무한루프. 그리고 게임프로그램도 무한루프로 돌리는 거임
-- 자바에서 반복문 탈출문이 break 
-- 와일문은 조건이 맞으면 반복, 루프문은 조건이 맞으면 탈출

사용예) 구구단의 7단을 출력
DECLARE
  V_CNT NUMBER := 1;  -- 곱해지는값. 승수. 초기값을 0으로 놓을지 1로 놓을지도 잘 판단
  V_RES NUMBER := 0;  -- 넘버로 초기화 되어지는 변수는 반드시 초기화를 시켜야한다를 잊지마~
BEGIN
  LOOP
    V_RES := 7 * V_CNT;
    DBMS_OUTPUT.PUT_LINE(7||'*'||V_CNT||'='||V_RES); -- 이게 원래 엑싯 앞에있었다가 1곱하기가 안나와서 여기루 이사옴
    V_CNT := V_CNT + 1; -- CNT가 9보다 클때 탈출하면 댐. 같을때 아님!
    EXIT WHEN V_CNT > 9;
  END LOOP;  
END;  
 
사용예)1-50사이의 피보나치수를 구하여 출력하시오
    FIBONACCI NUMBER : 첫번째와 두번째 수가 1,1로 주어지고 
            세번째 수부터 전 두 수의 합이 현재수가 되는 수열 -> 검색 알고리즘에 사용
DECLARE
  V_PNUM NUMBER := 1; --전수
  V_PPNUM NUMBER := 1; --전전수
  V_CURRNUM NUMBER := 0; --현재수
  V_RES VARCHAR(100);
BEGIN
  V_RES := V_PPNUM||', '||V_PNUM;
  LOOP
    V_CURRNUM := V_PPNUM + V_PNUM;
    EXIT WHEN V_CURRNUM >= 50;
    V_RES := V_RES||', '||V_CURRNUM;
    V_PPNUM := V_PNUM; -- 사실상 이 줄이랑
    V_PNUM := V_CURRNUM; -- 이 밑줄 순서 중요하다
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('1~50사이의 피보나치수 : '||V_RES);
END;

===========================================================================================

 2)WHILE 문
  . 개발언어의 WHILE 문과 같은 기능
  . 조건을 미리 체크하여 조건이 참인 경우에만 반복 처리
  (사용형식)
  WHILE 조건 
    LOOP
      반복처리문(들);
    END LOOP;    

사용예) 첫날엔 100원, 둘째날부터는 전날의 2배씩 저축할 경우 
        최초로 100만원을 넘는 날과 저축한 금액을 구하시오
DECLARE --변수가 몇개가 필요할까 먼저 고민해보자
  V_DAYS NUMBER := 0; --날짜 
  V_AMT NUMBER := 100; --날짜별 저축할 금액(그날그날 저금할 액수). 첫날에 100원이라 100으로 초기화
  V_SUM NUMBER := 0; --저축한 금액 전체 합계
BEGIN
  WHILE V_SUM < 1000000 LOOP
    V_SUM := V_SUM + V_AMT; -- V_SUM 에 대입할 수식
    V_DAYS := V_DAYS + 1; -- 날짜를 1로 초기화시켰다면 하루빼야혀. 무튼 그렇디야
    v_AMT := V_AMT * 2;
  END LOOP; 
  DBMS_OUTPUT.PUT_LINE('날수 : '||V_DAYS);
  DBMS_OUTPUT.PUT_LINE('저축액수 : '||V_SUM);
END; 

-- 만일 커서를 같이 사용하는 와일문이라면! 조심해야할 점이 발생되는데 예시를 통해 알아보자
-- 커서를 쓴다면 와일문을 쓸 때 조심해야해요
사용예) 회원테이블(MEMBER)에서 마일리지가 3000이상인 회원들을 찾아 
        그들이 2005년 5월 구매한 횟수와 구매금액합계를 구하시오(커서사용)
        (출력 : 회원번호, 회원명, 구매횟수, 구매금액합계) -- 커서 쓰면 쉽게 할 수 있다
        -- 커서로 구현해야할 부분이 뭘까 : 회원번호, 회원명을 딱 뽑아
        -- 그럼 페치하고 그때 회원번호를 갖고 매출테이블에가서 해당 날짜중에 그 사람이 구매한 횟수와 구매금액 합계를 구하면 댐
        
        
        <루프문을 써서 커서를 실행해보자> 
DECLARE
  V_MID MEMBER.MEM_ID%TYPE; -- 회원번호
  V_MNAME MEMBER.MEM_NAME%TYPE; -- 회원명
  -- 쌤의 팁! 프로그램 매 줄마다 주석을 달아라
  V_CNT NUMBER := 0; -- 구매횟수
  V_AMT NUMBER := 0; -- 구매금액 합계
  
  CURSOR CUR_CART_AMT 
  IS
    SELECT MEM_ID, MEM_NAME
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000; -- 왜 나는 6개 나오지?? 아 지난번에 바뀐거???
BEGIN
  OPEN CUR_CART_AMT;
  
  LOOP
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    EXIT WHEN CUR_CART_AMT%NOTFOUND; -- 데이터 없으면 조건탈출
    
    SELECT SUM(A.CART_QTY * B.PROD_PRICE), COUNT(A.CART_PROD)
        INTO V_AMT, V_CNT -- 여기두 인투
    FROM CART A, PROD B
    WHERE A.CART_PROD = B.PROD_ID -- 조인조건
    AND A.CART_MEMBER = V_MID -- 조인조건
    AND SUBSTR(A.CART_NO,1,6) = '200505'; -- CART_NO의 첫번째에서 6째글짜가 날짜
    
    DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');
    END LOOP; 
    CLOSE CUR_CART_AMT;
END;  
-- 루프를 사용했을땐 루프안에서 전부다 반복처리
        
        
        <와일문을 써서 커서를 실행해보자>
DECLARE
  V_MID MEMBER.MEM_ID%TYPE; -- 회원번호
  V_MNAME MEMBER.MEM_NAME%TYPE; -- 회원명
  -- 쌤의 팁! 프로그램 매 줄마다 주석을 달아라
  V_CNT NUMBER := 0; -- 구매횟수
  V_AMT NUMBER := 0; -- 구매금액 합계
  
  CURSOR CUR_CART_AMT 
  IS
    SELECT MEM_ID, MEM_NAME
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000; -- 왜 나는 6개 나오지?? 아 지난번에 바뀐거???
BEGIN
  OPEN CUR_CART_AMT;
  FETCH CUR_CART_AMT INTO V_MID, V_MNAME; -- 와일에서는 펫치가 WHILE밖에 있어야햐
  WHILE CUR_CART_AMT%FOUND LOOP -- 오픈만 해놓고 값을 안읽어서 실패
   -- FETCH CUR_CART_AMT INTO V_MID, V_MNAME; -- 이 위치에선 이제 필요 없슴
    --EXIT WHEN CUR_CART_AMT%NOTFOUND; -- 데이터 없으면 조건탈출 / 이게 여기선 필요 없음
    
    SELECT SUM(A.CART_QTY * B.PROD_PRICE), COUNT(A.CART_PROD)
        INTO V_AMT, V_CNT -- 여기두 인투
    FROM CART A, PROD B
    WHERE A.CART_PROD = B.PROD_ID -- 조인조건
    AND A.CART_MEMBER = V_MID -- 조인조건
    AND SUBSTR(A.CART_NO,1,6) = '200505'; -- CART_NO의 첫번째에서 6째글짜가 날짜
    
    DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    END LOOP; 
    CLOSE CUR_CART_AMT;
END;
--프로시저는되는데 값이 안나옴
--와일문에서 커서를 쓸때는 패치가 루프밖에 하나 : 그래야 와일문에서 조건처리를 해주니까
--그리구 루프 바로 끝나기 전에 또 하나
--패치의 갯수나 위치가 루프문때랑 또 달라짐
        
=========================================================================================== 
   
 3)FOR 문   
  . 반복횟수를 알고 있거나 횟수가 중요한 경우 사용
  (사용형식-1 : 일반적 FOR)
  FOR 인덱스 IN [REVERSE] 최소값..최대값 
  -- 인덱스는 변수로 설정할 필요가 없음. 시스템에서 알아서 만들어준다. // 자바에서는 int i 이렇게 선언함
  -- 무튼 그래서 디클레어에서 인덱스 설정할 필요 없슴
  -- 리버스 : 역으로 -> 역순으로 회전시킬때
  -- 무조건 1증가 1감소밖에 안댐. // 자바는 증가값의 폭 결정 가능 i++ 
  -- 반드시 .. 이로케 점 두 개가 나와야해
  LOOP
    반복처리문(들);
  END LOOP;  
  
  (사용형식-2 : CURSOR 에 사용하는 FOR(커서와 같이 사용되는 FOR))
  FOR 레코드명 IN 커서명|(커서 선언문)
  -- '레코드명'은 시스템에서 자동으로 설정
  -- 커서 컬럼 참조형식 : 레코드명.커서컬럼명
  -- 커서명 대신 커서 선언문(선언부에 존재했던)이 INLINE형식으로 기술할 수 있음
  -- FOR문을 사용하는 경우 커서의 OPEN, FETCH, CLOSE문은 생략함. 그리구 변수 선언도 안해도 댐
    -- 그래서 커서는 포문과 궁합이 가장 좋다
  LOOP
    반복처리문(들);
  END LOOP;
  


사용예<일반적 FOR>) 구구단의 7단을 FOR 문을 이용하여 구성 
 
DECLARE
--  V_CNT NUMBER := 1; --승수(1~9)// FOR I IN 1..9 LOOP때문에 이 행이 필요 없어짐
  V_RES NUMBER := 0; --결과값 . 사실 이것두 안쓸 수 있다 그럼 밑에 V_RES 대입도 주석. 
                     -- 구냥 나중에 출력때 V_RES자리에  7*I 로 넣으면 댐
BEGIN
  FOR I IN 1..9 LOOP
    V_RES := 7*I;    
    DBMS_OUTPUT.PUT_LINE(7||'*'||I||' = '||V_RES);
  END LOOP;  
END;


사용예<CURSOR 에 사용하는 FOR>) 구구단의 7단을 FOR 문을 이용하여 구성 
 
DECLARE
--  V_CNT NUMBER := 1; --승수(1~9)// FOR I IN 1..9 LOOP때문에 이 행이 필요 없어짐
  V_RES NUMBER := 0; --결과값 . 사실 이것두 안쓸 수 있다 그럼 밑에 V_RES 대입도 주석. 
                     -- 구냥 나중에 출력때 V_RES자리에  7*I 로 넣으면 댐
BEGIN
  FOR I IN 1..9 LOOP
    V_RES := 7*I;    
    DBMS_OUTPUT.PUT_LINE(7||'*'||I||' = '||V_RES);
  END LOOP;  
END;


사용예<CURSOR 에 사용하는 FOR>)
DECLARE
  V_CNT NUMBER := 0; -- 구매횟수
  V_AMT NUMBER := 0; -- 구매금액 합계
  
  CURSOR CUR_CART_AMT 
  IS
    SELECT MEM_ID, MEM_NAME
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000; -- 왜 나는 6개 나오지?? 아 지난번에 바뀐거???
BEGIN
  FOR REC_CART IN CUR_CART_AMT LOOP
    SELECT SUM(A.CART_QTY * B.PROD_PRICE), COUNT(A.CART_PROD)
        INTO V_AMT, V_CNT -- 여기두 인투
    FROM CART A, PROD B
    WHERE A.CART_PROD = B.PROD_ID -- 조인조건
    AND A.CART_MEMBER=REC_CART.MEM_ID
    AND SUBSTR(A.CART_NO,1,6) = '200505'; -- CART_NO의 첫번째에서 6째글짜가 날짜
    
    DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||' => '||V_AMT||'('||V_CNT||')');
    END LOOP; 
END;


사용예<더 간략화 해보자 CURSOR 에 사용하는 FOR : FOR 문에서 인라인커서를 사용하는 경우>) 
DECLARE
  V_CNT NUMBER := 0; -- 구매횟수
  V_AMT NUMBER := 0; -- 구매금액 합계
BEGIN
  FOR REC_CART IN (SELECT MEM_ID, MEM_NAME
                     FROM MEMBER
                    WHERE MEM_MILEAGE >= 3000)
  LOOP 
    SELECT SUM(A.CART_QTY * B.PROD_PRICE), COUNT(A.CART_PROD)
        INTO V_AMT, V_CNT -- 여기두 인투
    FROM CART A, PROD B
    WHERE A.CART_PROD = B.PROD_ID -- 조인조건
    AND A.CART_MEMBER=REC_CART.MEM_ID
    AND SUBSTR(A.CART_NO,1,6) = '200505'; -- CART_NO의 첫번째에서 6째글짜가 날짜
    DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||' => '||V_AMT||'('||V_CNT||')');
    END LOOP; 
END;

=========================================================================================== 

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
 --데이터타입자리에는 데이터타입만 가져오기. 크기지정은 절대 안댄단다~~
 -- CREATE절에 ; 안붙는단다
 
 ** 다음 조건에 맞는 재고수불 테이블을 생성하시오
 1. 테이블명 : REMAIN
 2. 컬럼
 ------------------------------------------
    컬럼명     데이터타입       제약사항
 ------------------------------------------
 REMAIN_YEAR    CHAR(4)         PK
 PROD_ID        VARCHAR2(10)    PK & FK
 REMAIN_J_00    NUMBER(5)       DEFAULT 0   --기초입고
 REMAIN_I       NUMBER(5)       DEFAULT 0   --입고수량  
 REMAIN_O       NUMBER(5)       DEFAULT 0   --출고수량
 REMAIN_J_99    NUMBER(5)       DEFAULT 0   --기말재고
 REMAIN_DATE    DATE            DEFAULT SYSDATE    --처리일자
 
 CREATE TABLE REMAIN
    (REMAIN_YEAR CHAR(4) NOT NULL,
     PROD_ID VARCHAR2(10) NOT NULL, 
     REMAIN_J_00 NUMBER(5) DEFAULT 0,
     REMAIN_I NUMBER(5) DEFAULT 0,
     REMAIN_O NUMBER(5) DEFAULT 0,
     REMAIN_J_99 NUMBER(5) DEFAULT 0,
     REMAIN_DATE DATE DEFAULT SYSDATE,
     
     CONSTRAINT PK_REMAIN PRIMARY KEY (REMAIN_YEAR, PROD_ID),
     CONSTRAINT FK_REMAIN FOREIGN KEY (PROD_ID)
        REFERENCES PROD(PROD_ID));
     
**테이블 생성명령
 CREATE TABLE 테이블명(
   컬럼명1 데이터타입[(크기)] [NOT NULL][DEFAULT 값|수식] [,]
   컬럼명2 데이터타입[(크기)] [NOT NULL][DEFAULT 값|수식] [,]
                          :
   컬럼명n 데이터타입[(크기)] [NOT NULL][DEFAULT 값|수식] [,]
 
   CONSTRAINT 기본키설정명 PRIMARY KEY (컬럼명1[, 컬럼명2,....])[,] 
   CONSTRAINT 외래키설정명1 FOREIGN KEY (컬럼명1[, 컬럼명2,....]) 
                    -- 복수의 컬럼명이 한 번에 기술되어지는 경우는 한 테이블에서 복수개를 가져오는 것
     REFERENCES 테이블명1(컬럼명1[, 컬럼명2,...])[,]
   
   CONSTRAINT 외래키설정명n FOREIGN KEY (컬럼명1[, 컬럼명2,....])
     REFERENCES 테이블명n(컬럼명1[, 컬럼명2,...]));
 
  
 CREATE TABLE REMAIN
    (REMAIN_YEAR CHAR(4),-- 기본키는 NOT NULL,안써도 댐. 자동으로 NOT NULL
     PROD_ID VARCHAR2(10),-- NOT NULL, 
     REMAIN_J_00 NUMBER(5) DEFAULT 0,
     REMAIN_I NUMBER(5) DEFAULT 0,
     REMAIN_O NUMBER(5) DEFAULT 0,
     REMAIN_J_99 NUMBER(5) DEFAULT 0,
     REMAIN_DATE DATE, -- 한번 디폴트를 주지 말아보자 DEFAULT SYSDATE,
     
     CONSTRAINT PK_REMAIN PRIMARY KEY (REMAIN_YEAR, PROD_ID),
     CONSTRAINT FK_REMAIN_PROD FOREIGN KEY (PROD_ID)
        REFERENCES PROD(PROD_ID));
  
        
***생성한 REMAIN 테이블에 기초자료를 넣어보자        
기초 재고 : 영업 시작전 재고
기말 재고 : 기초재고 + 입고 + 출고 
-- 지금 기술한 기초와 기말은 하루 기준
적정재고량 : 평균 판매량 * 130%
적정재고량이 총재고량 보다 많다
코스트 매입가 / 프라이스 판매가/ 세일 할인가

기초재고를 프로퍼스톡으로 한다심
년도 : 2005
상품코드 : 상품테이블의 상품코드
기초재고 : 상품테이블의 적정재고량(PROD_PROPERSTOCK)
입고수량/출고수량 : 없음
처리일자 : 2004/12/31

인서트 서브쿼리로 넣어보자
INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
SELECT '2005', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('20041231')
FROM PROD;
-- 인서트 서브쿼리 : 괄호 안쓰고 밸류스도 안씀        
SELECT * FROM REMAIN;        
-- REMAIN_YEAR 1년만 쓸게 아니니까. 햇수마다 상품코드 중복이 될 수 있어서        
        
근데 보통 고객이 결재를 완료하는 순간마다 재고표조정을 한다        
       

프로시저와 펑션으로 이 테이블을 조정해보고
나중에 트리거로 시점별로 재고파악까지~