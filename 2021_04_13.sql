패키지(Package)
 - 논리적 연관성이 있는 PL/SQL타입, 변수, 상수, 함수, 프로시져 등의 항목들을 묶어 놓은 것
 - 모듈화, 캡슐화 기능 제공
 - 관련성 있는 서브프로그램 집합으로 disk I/O 이 줄어서 효율적임


1. PACKAGE 구조
 - 선언부와 본문부로 구성
 
 
 1) 선언부
  . 패키지에 포함 될 변수, 프로시져, 함수 등을 선언
  
  (사용형식)
CREATE [OR REPLACE] PACKAGE 패키지명
IS|AS
  TYPE 구문;
  상수[변수] 선언문;
  커서;
  함수|프로시져 프로토타입
            :
END 패키지명;            

패키지의 선언부에서는 프로토타입만 나옴 -> 헤드부분만
마치 자바 메소드의 : 접근지정자+메서드명+(매개변수LIST) -> PROTOTYPE

선언부와 바디부를 떼어놓는 이유 ->  ㅅㅂ

선언부라서 비긴 블록이 없어 -> 비긴블록은 실행영역


 2) 본문부
  . 선언부에서 정의한 서브프로그램의 구현 담당

  (사용형식)
CREATE [OR REPLACE] PACKAGE BODY 패키지명
IS|AS
  상수, 커서, 변수선언;
  
  FUNCTION 함수명(매개변수LIST)
    RETURN 타입명
  BEGIN
    PL/SQL 명령(들);
    RETURN expr;
  END 함수명;
          :
END 패키지명;

================================================================================

사용예) 상품테이블에 신규 상품을 등록하는 업무를 패키지로 구성하시오
1. 이 제품이 어느 분류에 속하는지, 분류코드를 먼저 알기
2. 분류코드를 알았으면 분류코드 내의 상품코드를 알았으면 가장 큰 수의 분류코드를 만들고
어쩌고 저쩌고 총 4가지 작업
    분류코드확인 -> 상품코드생성 -> 상품테이블에 등록 -> 재고수불테이블 등록

    패키지 선언부
CREATE OR REPLACE PACKAGE PROD_NEWITEM_PKG
IS
    V_PROD_LGU LPROD.LPROD_GU%TYPE;
    
    -- 분류코드 생성
    FUNCTION FN_INSERT_LPROD(
      P_GU IN LPROD.LPROD_GU%TYPE,
      P_NM IN LPROD.LPROD_NM%TYPE)
      RETURN LPROD.LPROD_GU%TYPE;
    -- 상품코드 생성 및 상품 등록
    PROCEDURE PROC_CREATE_PROD_ID(
      P_GU IN LPROD.LPROD_GU%TYPE, -- 분류코드
      P_NAME IN PROD.PROD_NAME%TYPE,
      P_BUYER IN PROD.PROD_BUYER%TYPE, 
      P_COST IN NUMBER,
      P_PRICE IN NUMBER, 
      P_SALE IN NUMBER, 
      P_OUTLINE IN PROD.PROD_OUTLINE%TYPE, 
      P_IMG IN PROD.PROD_IMG%TYPE, 
      P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE, 
      P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE);
    -- 재고수불테이블 삽입  
    PROCEDURE PROC_INSERT_REMAIN(
      P_YEAR IN CHAR,
      P_ID IN PROD.PROD_ID%TYPE,
      P_AMT NUMBER);

END PROD_NEWITEM_PKG;      
    
    
    패키지 본문부 생성
CREATE OR REPLACE PACKAGE BODY PROD_NEWITEM_PKG
IS
    V_LPROD_GU LPROD.LPROD_GU%TYPE;
    V_PROD_ID PROD.PROD_ID%TUPE
    
    FUNCTION FN_INSERT_LPROD(
      P_GU IN LPROD.LPROD_GU%TYPE,
      P_NM IN LPROD.LPROD_NM%TYPE)
      RETURN LPROD.LPROD_GU%TYPE;
    IS
      V_ID NUMBER := 0;
    BEGIN
      SELECT MAX(LPROD_ID)+1 INTO V_ID
        FROM LPROD;
      P_LPROD_GU := P_GU;  
      INSERT INTO LPROD
        VALUES(V_ID, P_GU, P_NM);
      RETURN P_GU;  
    END;
    -- 상품코드 생성 및 상품 등록
    PROCEDURE PROC_CREATE_PROD_ID(
      P_GU IN LPROD.LPROD_GU%TYPE, -- 분류코드
      P_NAME IN PROD.PROD_NAME%TYPE,
      P_BUYER IN PROD.PROD_BUYER%TYPE, 
      P_COST IN NUMBER,
      P_PRICE IN NUMBER, 
      P_SALE IN NUMBER, 
      P_OUTLINE IN PROD.PROD_OUTLINE%TYPE, 
      P_IMG IN PROD.PROD_IMG%TYPE, 
      P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE, 
      P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE,
      P_ID OUT PROD.PROD_ID%TYPE); -- 시발 생성부에서도 또 바꼈나보네
    IS
    V_PID PROD.PROD_ID%TYPE -- 위에서 뭘 지웠는데.. 뭘 존나 맨날 오락가락해
    BEGIN
    
    
    END;
    -- 재고수불테이블 삽입  
    PROCEDURE PROC_INSERT_REMAIN(
      P_YEAR IN CHAR,
      P_ID IN PROD.PROD_ID%TYPE,
      P_AMT NUMBER)
    IS
    BEGIN
    
    END;
END PROD_NEWITEM_PKG;

아이고 시발 존나 오락가락해서 나도 헷갈려서 돌아버리겠다
BEGIN END 안에를 알아서 채워보라는데ㅋㅋㅋㅋㅋㅋㅋㅋ


입고상품의 분류코드 P202인 경우 상품코드
SELECT MAX(PROD_ID) MNUM
FROM PROD
WHERE PROD_LGU = 'P202';

SELECT 'P'||TO_CHAR(SUBSTR(A.MNUM,2)+1) -- 왜 TO_CHAR를 썼는지 잘 보기
FROM
(SELECT MAX(PROD_ID) MNUM
FROM PROD
WHERE PROD_LGU = 'P202') A;


    실행
예를 들어 문구류 했을 때! 분류코드가 있는 경우와 없는 경우 따로따로 만들어야함

1) 신규 분류코드를 사용하는 경우
DECLARE
  V_LGU LPROD.LPROD_GU%TYPE;
  V_PID PROD.PROD_ID%TYPE;
BEGIN
  V_LGU := PROD_NEWITEM_PKG.FN_INSERT_LPROD('P701', '농축산물') -- 함수가 분류코드와 분류명을 가져가라
  PROD_NEWITEM_PKG.PROC_CREATE_PROD_ID(V_LGU, '소시지', 'P20101', 
                            10000, 13000, 11000, ' ', ' ', 0, 0, V_PID);
  PROD_NEWITEM_PKG.PROC_INSERT_REMAIN(V_PID, 10);                            
END;

UPDATE 사원 SET 직급 = '과장' WHERE (사원 = '홍영선'), 
(과장 = '홍영선')(사원 = '김형석')
COMMIT
rollback




































 