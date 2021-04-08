과제

문제] 2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의 삭제여부컬럼 (MEM_DELETE)의 값을 
    'Y'로 변경하는 프로시져를 작성하시오 -> VARCHAR2(1)
    
    UPDATE MEMBER
    SET MEM_DELETE = 'Y'
    WHERE MEM_ID NOT IN (SELECT CART_MEMBER FROM CART)
    
    1. 프로시져명 : PROC_MEM_DEL
    2. 매개변수 : 멤버번호
    3. 처리내용 : 해당 멤버번호에 대한 삭제여부컬럼(MEM_DELETE) UPDATE

--[프로시저생성]    
 CREATE OR REPLACE PROCEDURE PROC_MEM_DEL(P_ID IN MEMBER.MEM_ID%TYPE)
 IS
 BEGIN
   UPDATE MEMBER
   SET MEM_DELETE = 'Y'
   WHERE MEM_ID = P_ID
   AND MEM_ID NOT IN (SELECT CART_MEMBER FROM CART);
 END;  
 
 
--[프로시저 실행 1 : 직접 인수 넣음] 
 EXECUTE PROC_MEM_DEL('n001');
 
 
--[프로시저 실행 2 : 임의 블록으로 프로시저 호출 및 커서로 인수찾아서 루프돌림] 
DECLARE
  CURSOR CUR_MEM_DEL
  IS
    SELECT MEM_ID
    FROM MEMBER
    WHERE NOT EXISTS (SELECT CART_MEMBER FROM CART WHERE MEM_ID = CART_MEMBER); 
BEGIN
  FOR REC01 IN CUR_MEM_DEL LOOP
    PROC_MEM_DEL(REC01.MEM_ID);
  END LOOP;
END;
근데 이렇게 하면 한줄밖에 안나오는디
어차피 한명이라서 괜찮긴 했는디


--[프로시저 실행 3 : 만약 2명 이상일때는????]  이거 맞나????
내가 하고 싶은것 : 셀렉트로 조건 맞게 검색하고 프로시저 호출해서
                한줄식 프로시저에 인수로 넣어서 프로시저가 돌아가게 하고 싶다
                그리고 값이 없으면 알아서 종료되게끔
                자바에서 배열길이만큼 돌리는 것처럼 셀렉트해서 나오는 행의 갯수에 맞게끔 돌아가게???
DECLARE
  V_CODE MEMBER.MEM_ID%TYPE  
  CURSOR CUR_MEM_DEL 
  IS
    SELECT MEM_ID
    FROM MEMBER
    WHERE NOT EXISTS (SELECT CART_MEMBER FROM CART WHERE MEM_ID = CART_MEMBER); 
BEGIN
  FOR REC_DEL IN CUR_MEM_DEL LOOP
    SELECT MEM_ID INTO V_CODE
    FROM MEMBER
    WHERE MEM_ID NOT IN (SELECT CART_MEMBER FROM CART); 
    PROC_MEM_DEL(V_CODE);
    END LOOP; 
END;
-- 조건을 위에 아래 둘다 쓰는 건가??? 왜 이렇게 해야만하지???


INSERT INTO member (MEM_ID) VALUES ('y001');
아씨... 추가좀해서 해볼랬는데 완전 귀찮게 낫널이네



  
ROLLBACK

UPDATE MEMBER
SET MEM_DELETE = 'Y'
WHERE MEM_ID NOT IN (SELECT CART_MEMBER FROM CART)

SELECT MEM_ID, MEM_NAME, MEM_DELETE
FROM MEMBER
WHERE MEM_ID NOT IN (SELECT CART_MEMBER FROM CART)  

SELECT MEM_ID, MEM_NAME, MEM_DELETE
FROM MEMBER
WHERE NOT EXISTS (SELECT CART_MEMBER FROM CART WHERE MEM_ID = CART_MEMBER); 
-- n001	탁원재 null
SELECT MEM_ID FROM MEMBER
-- 24행
SELECT CART_MEMBER FROM CART GROUP BY CART_MEMBER
-- 23행  