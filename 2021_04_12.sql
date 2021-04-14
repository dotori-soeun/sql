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
 
 
문장단위 트리거 -> 잘 안씀. 

=======================================================================================================================

문장단위 트리거 예) 상품분류 테이블에 자료를 삽입하시오. 자료 삽입 후
'상품분류코드가 추가 되었습니다'라는 메시지를 트리거를 이용하여 출력하시오
    [자료]
LPROD_ID    15
LPROD_GU    'P801'
LPROD_NM    '신선식품'
    
    [트리거 생성]
CREATE OR REPLACE TRIGGER TG_LPROD_INSERT
AFTER INSERT ON LPROD
BEGIN
DBMS_OUTPUT.PUT_LINE('상품분류코드가 추가 되었습니다');
END;
    -- 비긴엔드 블록이 실제 트리거 내용
    -- FOR EACH ROW가 생략 되어있어서 이건 문장 단위 트리거

    [이벤트]
INSERT INTO LPROD VALUES(15, 'P801', '우리식품');

SELECT * FROM LPROD; -- 이게 새로고침과 같은 역할. 두 개를 동시에 실행해야 한다

=======================================================================================================================
사용예) 매입테이블에서 2005년 4월16일 상품'P101000001'을 매입한 다음 재고수량을 UPDATE하시오

    ->[매입정보]
1. 상품코드 'P101000001'
2. 날짜 '2005-04-16'
3. 매입수량 5개
4. 매입단가 210000

    [트리거 생성]
CREATE OR REPLACE TRIGGER TG_REMAIN_UPDATE -- 리메인 테이블을 업데이트 하는 트리거이다 
-- TG + 대상테이블 + 그 테이블에서 이뤄질 작업
AFTER INSERT OR UPDATE OR DELETE ON BUYPROD -- (BUYPROD)에 / 삽입 또는 갱신 또는 삭제 가 발생된 이후에 
FOR EACH ROW
BEGIN
  UPDATE REMAIN SET(REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (
    SELECT REMAIN_I+:NEW.BUY_QTY, REMAIN_J_99+:NEW.BUY_QTY, '20050416'
    FROM REMAIN
    WHERE REMAIN_YEAR = '2005'
    AND REMAIN_DATE = TO_DATE('20050416')
    AND PROD_ID=:NEW.BUY_PROD)
WHERE REMAIN_YEAR = '2005'
 AND PROD_ID=:NEW.BUY_PROD;
END;

INSERT INTO BUYPROD VALUES(TO_DATE('20050416'), 'P101000001', 5, 210000);       
SELECT * FROM REMAIN;

=======================================================================================================================

** 트리거
  - 데이터의 무결성 제약을 강화
  - 트리거 내부에는 트랜젝션 제어문(COMMIT, ROLLBACK, SAVEPOINT 등)을 사용할 수 없음
  - 트리거 내부에 사용되는 PROCEDURE, FUNCTION 에서도 트랜젝션 제어문을 사용할 수 없음
  - LONG, LONG RAW 등의 변수 선언 사용할 수 없음
  
** 트리거 의사레코드
  1) :NEW = INSERT, UPDATE에서 사용
            데이터가 삽입(갱신)될 때 새롭게 들어오는 자료
            DELETE 시에는 모두 NULL 로 SETTING
  2) :OLD = DELETE, UPDATE에서 사용
            데이터가 삽입(갱신)될 때 이미 존재하고 있던 자료
            INSERT 시에는 모두 NULL 로 SETTING

** 트리거 함수
  - 트리거를 유발시킨 DML을 구별하기 위해 사용
  -------------------------------------------------------------
  함수               의미
  -------------------------------------------------------------
  INSERTING         트리거의 EVENT가  INSERT이면 참(TRUE) 반환
  UPDATING          트리거의 EVENT가  UPDATE이면 참(TRUE) 반환
  DELETING          트리거의 EVENT가  DELETE이면 참(TRUE) 반환  
  
  
사용예) 장바구니 테이블에 신규 판매자료가 삽입될 때 재고를 처리하는 트리거를 작성하시오  
    [트리거 생성]
CREATE OR REPLACE TRIGGER TG_REMAIN_CART_UPDATE
  AFTER INSERT OR UPDATE OR DELETE ON CART
  FOR EACH ROW
DECLARE
  V_QTY CART.CART_QTY%TYPE;
  V_PROD PROD.PROD_ID%TYPE;
BEGIN
  IF INSERTING THEN
    V_QTY:=:NEW.CART_QTY;
    V_PROD:=:NEW.CART_PROD;
  ELSIF UPDATING THEN
    V_QTY:=NEW.CART_QTY - :OLD.CART_QTY;
    V_PROD:=:NEW.CART_PROD;
  ELSE 
    V_QTY:=:OLD.CART_QTY;
    V_PROD:=:OLD.CART_PROD;
  END IF;
  UPDATE REMAIN SET REMAIN_O = REMAIN_O + V_QTY,
                    REMAIN_J_99 = REMAIN_J_99 - V_QTY,
                    REMAIN_DATE = SYSDATE
                WHERE REMAIN_YEAR = '2005'
                AND PROD_ID = V_PROD;
  DBMS_OUTPUT.PUT_LINE(V_PROD||'상품 재고수량 변동 : ');              
END;
-- 뭐라고 하는지 하나도 모르겠고 스스로 혼란을 만들고 있어서 내 정신건강에도 좋지 않아서 수업을 듣지 않음  
  
  
    [문제]
'f001'회원이 오늘 상품'P202000001'을 15개 구매했을때 
이 정보를 cart 테이블에 저장한 후 재고수불 테이블과 회원테이블(마일리지)를 변경하는 트리거를 작성하세요





















  
