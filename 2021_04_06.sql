예) 장바구니에서 2005년 5월 가장 많은 구매를 한 (구매금액 기준) 회원정보를 조회하시요
    : 회원번호, 회원명, 구매금액합
    
-- 표준 SQL    

SELECT *
  FROM
  (SELECT cart_member 회원번호 , mem_name 회원명, SUM(prod_price*cart_qty) 구매금액_합 
  FROM cart c, member m, prod p
  WHERE c.cart_member = m.mem_id  AND  c.cart_prod = p.prod_id  
  GROUP BY cart_member, mem_name
  ORDER BY 구매금액_합 DESC)
  WHERE ROWNUM = 1 ;

-- 위 쿼리를 뷰로 구성

CREATE OR REPLACE VIEW V_MAXAMT
AS
SELECT *
  FROM
  (SELECT cart_member 회원번호 , mem_name 회원명, SUM(prod_price*cart_qty) 구매금액_합 
  FROM cart c, member m, prod p
  WHERE c.cart_member = m.mem_id  AND  c.cart_prod = p.prod_id  
  GROUP BY cart_member, mem_name
  ORDER BY 구매금액_합 DESC)
  WHERE ROWNUM = 1 ;
  
SELECT * FROM V_MAXAMT;

-- 뷰를 받아서 그대로 출력할 수 있는 블록을 만들어보자

익명블록은 검증용. 이름이 없어서 저장이 안대니까
변수쓰는 걸 연습해보는거임

DECLARE
  --회원번호 회원명 구매금액합을 외부로부터 가져올거임
  V_MID V_MAXAMT.회원번호%TYPE;
  V_NAME V_MAXAMT.회원명%TYPE;
  V_AMT V_MAXAMT.구매금액_합%TYPE;
  --쌍따옴표 해도 되는데 안해도 상관없다
  --쌍따옴표 : 컬럼별칭에 비허용 글자가 사용되어지는경우(공백이거나), 형식지정문자열에서 사용자가 형식지정할때??? 뭔소리???
  V_RES VARCHAR2(100);
  --자동 NULL초기화라서 초기화 시키지 않아도 된다
BEGIN
  SELECT 회원번호, 회원명, 구매금액_합 INTO V_MID, V_NAME, V_AMT
  --PLSQL에서의 SELECT구문은 이제까지의 구문과 다르다
  --SELECT INTO FROM WHERE
  --SELECT 다음의 문구를 INTO 다음에 기술해준 변수에 할당
    FROM V_MAXAMT;
    
  V_RES:=V_MID||', '||V_NAME||', '||TO_CHAR(V_AMT,'99,999,999');  
  
  DBMS_OUTPUT.PUT_LINE(V_RES);
END;  



디클레어와 비긴사이에는 변수 상수 커서
상수는 콘스탄트만 쓰면 된다 / 상수선언시엔 반드시 초기 값이 지정되어져야한다.

(상수사용예)
키보드로 수 하나를 입력 받아 그 값을 반지름으로하는 원의 넓이를 구하시오

ACCEPT P_NUM PROMPT '원의 반지름 : '
DECLARE
  V_RADIUS NUMBER := TO_NUMBER('&P_NUM'); -- 입력값을 숫자로 변환해서 넘버에 대입 
  V_PI CONSTANT NUMBER := 3.1415926; 
  -- 상수값은 딱 한 번만 변수의 역할을 한다. 3.14~~를 PI에 대입
  V_RES NUMBER := 0;
BEGIN
  V_RES := V_RADIUS*V_RADIUS*V_PI; -- ^이 안먹혀서
  DBMS_OUTPUT.PUT_LINE('원의 너비 = '||V_RES);
END;  


===========================================================================================

커서란 무엇인가?[CURSOR] 커서는 뷰와 같은 개념이긴하나 뷰보다 범위가 넓음
뷰는 셀렉트문에서 나온 결과의 집합
커서는 SQL문에서 영향받은 행들의 집합
커서는 왜 필요한가??
익명커서는 임플리싯커서 묵시적커서 -> 오픈되자 마자 클로스 -> 클로스 되면 커서안의 자료에 접근 불가
커서 : 만들기(선언) -> 오픈 -> 커서안의 행들을 읽어와(페치) -> 클로스 : 이 단계들을 여러 행에
-- 그래서 여러행이라면 반복 명령안에 커서가 들어가면댐
-- 커서가 들어가면 조인이나 서브쿼리의 경우를 굉장히 많이 줄일 수 있다.

<커서>

 - 커서는 쿼리문의 영향을 받은 행들의 집합 : -- 보통 셀렉트문에서 영향을 받은 행들의 집합
 - 묵시적커서(IMPLICITE), 명시적(EXPLICIT) 커서로 구분 -- 이제 우리가 배울것은 명시적커서
 - 커서의 선언은 선언부에서 수행
 - 커서의 OPEN, FETCH, CLOSE 는 실행부에서 기술
 
 1)묵시적 커서 -- 이건 이미 그동안 우리가 다 쓰고 왔다심
  . 이름이 없는 커서
  . 항상 CLOSE 상태이기 때문에 커서 내로 접근 불가능
   (커서속성)
   --------------------------------------------
     속성                  의미
   --------------------------------------------
   SQL%ISOPEN           커서가 OPEN되었으면 참(TRUE)반환, 묵시적커서는 항상 FALSE
   SQL%NOTFOUND         커서 내에 읽을 자료가 없으면 참(TRUE)반환     -- 와일문이나 포문에서 탈출조건으로도 사용할 수 있다
   SQL%FOUND            커서 내에 읽을 자료가 남아있으면 참(TRUE)반환 
   SQL%ROWCOUNT         커서 내 자료의 수 반환  -- 커서로 선택되어진 행들의 갯수
   --------------------------------------------
   -- 앞에 SQL붙어있는거는 묵시적커서는 이름이 없으니까
   
 2)명시적 커서
  . 이름이 있는 커서
  . 생성 -> OPEN -> FETCH -> CLOSE 순으로 처리해야함(단, FOR문은 예외)
  -- 포문에서 쓰이면 저 4단계가 하나도 없을 수 있다
  -- 포문에서는 인라인커서를 이용한다. 커서는 포문하고 궁합이 최고
  -- 다중행서브쿼리같은 다중행처리에 커서가 많이 사용된다
    (1) 생성
      (사용형식) -- 이 형식이 디클레어 안에 들어가야 한다.
      CURSOR 커서명 [(매개변수 list)] -- 그리고 오픈문에서 선언부의 매개변수의 값을 지정해준다
      IS
        SELECT 문; 
    사용예) 상품매입테이블(BUYPROD)에서 2005년 3월 상품별 매입현황
        (상품코드, 상품명, 거래처명, 매입수량)을 출력하는 쿼리를 커서를 사용하여 작성하시오   
    -- 상품별 매입현황을 쭉 출력 : 상품코드와 매입수량 -> 상품명과 거래처명을 알 수 있다
    -- 상품명은 PROD테이블, 거래처명은 PROD_BUYER를 통해 BUY테이블에서
    -- PROD가 중매쟁이 역할 : 양쪽을 전부 알고 있다
    -- 만일 조인으로 한다면 조인조건은 (N-1)개가 필요하다 : 예시 테이블 5개라면 조인조건은 4개가 필요하다
    
    (2) OPEN 문 -- 오픈명령은 간단 , 비긴앤드 블록에서 나온다
     - 명시적 커서를 사용하기 전 커서를 OPEN
     -- 반드시 커서 사용전 오픈시켜놔야한다. 오픈하지 않은 커서는 사용할 수 없다
     -- OPEN에서의 매개변수 : 선언문에서 선언된 매개변수에 값이 전달 될 수 있도록
     (사용형식)
     OPEN 커서명[(매개변수 list)];
     
    (3) FETCH 문 -- 리드가 아니고 패치임 주의!!
    -- 패치는 읽어다가 넘겨주는것. 마치 셀렉트절과 비슷하다
     - 커서 내의 자료를 읽어오는 명령
     - 보통 반복문 내에서 사용
     (사용형식)
     FETCH 커서명 INTO 변수명
      . 커서 내의 컬럼값을 INTO 다음에 기술된 변수에 할당

DECLARE
  V_PCODE PROD.PROD_ID%TYPE; -- 이렇게하면 내부적으로 얼만큼의 크기인지는 몰라두 댐. 위치만 알면댄다(테이블과 컬럼명)
  V_PNAME PROD.PROD_NAME%TYPE;
  V_BNAME BUYER.BUYER_NAME%TYPE;
  V_AMT NUMBER:=0; -- 0초기화는 잊지말고 합시다
  
  CURSOR CUR_BUY_INFO IS
  -- 매입현황이라는 이름 CUR_BUY_INFO 
    SELECT BUY_PROD, SUM(BUY_QTY) AMT
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
    -- 날짜타입은 라이크함수 절대 노노!! 반드시 비트윈함수로다가~!!
    -- 마지막 날을 모르겠으면 라스트데이트 LAST_DATE    
    GROUP BY BUY_PROD;

BEGIN
  OPEN CUR_BUY_INFO; -- 커서 오픈완료
  
  LOOP -- 반복명령 : 자바의 do문과 비슷
    FETCH CUR_BUY_INFO INTO V_PCODE, V_AMT;
    EXIT WHEN CUR_BUY_INFO%NOTFOUND;   --여기서 탈출조건 기술
      SELECT PROD_NAME, BUYER_NAME INTO V_PNAME, V_BNAME
      FROM PROD, BUYER
      WHERE PROD_ID = V_PCODE
      AND PROD_BUYER = BUYER_ID;
    DBMS_OUTPUT.PUT_LINE('상품코드 : '||V_PCODE);
    DBMS_OUTPUT.PUT_LINE('상품명 : '||V_PNAME);
    DBMS_OUTPUT.PUT_LINE('거래처명 : '||V_BNAME);
    DBMS_OUTPUT.PUT_LINE('매입수량 : '||V_AMT);
    DBMS_OUTPUT.PUT_LINE('--------------------------'); -- 데코용
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('자료수 : '||CUR_BUY_INFO%ROWCOUNT); -- 자료수 처리는 루프 밖으로 나가는게 좋음
  CLOSE CUR_BUY_INFO; -- 앤드루프하고 항상 이렇게 커서를 닫아줘야한다.

END;

===========================================================================================

사용예) 상품분류코드 'P102'에 속한 상품의 상품명, 매입가격, 마일리지를 출력하는 커서를 작성하시오
-- 이거는 블록을 안쓰고 하는 게 더 빨라요


-- 표준 SQL이라면?
SELECT PROD_NAME 상품명, PROD_COST 매입가격, PROD_MILEAGE 마일리지
FROM PROD
WHERE PROD_LGU='P102';
-- 이게 PLSQL로 가서 출력하려면 한줄만 나온다. 단일행만! 그래서 커서와 반복문을 써야먄 전체 출력가능


-- 만일 커서로 만들어서 블록을 써야한다면??
(익명블록)
ACCEPT P_LCODE PROMPT '분류코드 : ' -- 여기는 세미콜론 붙이는거 아님
DECLARE
  -- 출력되어지는 것을 대부분 변수로 설정
  -- %TYPE 은 참조하십시오~라는 뜻
  V_PNAME PROD.PROD_NAME%TYPE;
  V_COST PROD.PROD_COST%TYPE;
  V_MILE PROD.PROD_MILEAGE%TYPE;
  
  CURSOR CUR_PROD_COST(P_LGU LPROD.LPROD_GU%TYPE) -- 괄호 안에 분류코드를 작성. 매개변수 사용예시 보여주려고 만드심
  IS
    SELECT PROD_NAME, PROD_COST, PROD_MILEAGE
    FROM PROD
    WHERE PROD_LGU=P_LGU;
BEGIN
  -- OPEN CUR_PROD_COST('P102') -- 여기서 매개변수 넘겨줘야 할 값이 나온다
  OPEN CUR_PROD_COST('&P_LCODE'); -- 이건 위의 ACCEPT를 추가했을시 입력받은 거를 커서의 매개변수에 느라고 하는거
  DBMS_OUTPUT.PUT_LINE('상품명       '||'    단가 '||'마일리지');
  DBMS_OUTPUT.PUT_LINE('-----------------------------------');
  LOOP
    FETCH CUR_PROD_COST INTO V_PNAME, V_COST, V_MILE;
    EXIT WHEN CUR_PROD_COST%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(V_PNAME||'  '||V_COST||' '||NVL(V_MILE,0));
  END LOOP;  
  CLOSE CUR_PROD_COST;
END;
    
-- 야자시간 재확인    
    
===========================================================================================

<<조건문 IF>>
 - 개발언어의 조건문(IF문)과 동일 기능 제공

 (사용형식1)
 IF 조건식 THEN -- 자바랑 달리 조건식을 괄호로 묶지 않아도 된다. 반드시 THEN은 나와야 한다.
   명령문1;
 [ELSE
   명령문2;]
 END IF;  
 
 (사용형식2 조건이 여러개 나오는 경우, 병렬식 이프. 아닐땐 다음조건 아닐땐 다음조건 이런식) 
 IF 조건식1 THEN 
   명령문1;
 ELSIF 조건식2 THEN  -- ELSIF 조심!!
   명령문2;
 [ELSIF 조건식3 THEN
   명령문3;
   :
  ELSE
   명령문n;]
 END IF; 

 (사용형식3 조건이 여러개 나오는 경우, 병렬식 이프. 
    -- 네스티드이프. 중첩 이프. 맞으면 다음조건 맞으면 다음조건 이런식) 
 IF 조건식1 THEN 
   명령문1;
   IF 조건식2 THEN 
     명령문2;
   ELSE
     명령문3;
   END IF;
 ELSE
   명령문4;
 END IF;
 
 
사용예) 상품테이블에서 'P201'분류에 속한 상품들의 평균단가를 구하고, 해당 분류에 속한 상품들의 판매단가를 비교하여 
    같으면 '평균가격 상품', 적으면 '평균가격 이하 상품', 많으면 '평균가격 이상 상품'을 비고컬럼에 출력하시오
    (출력은 상품코드, 상품명, 가격, 비고)
  
DECLARE
  V_PCODE PROD.PROD_ID%TYPE;
  V_PNAME PROD.PROD_NAME%TYPE;
  V_PRICE PROD.PROD_PRICE%TYPE;
  V_REMARKS VARCHAR2(50);
  V_AVG_PRICE PROD.PROD_PRICE%TYPE;
BEGIN
  SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
  FROM PROD
  WHERE PROD_LGU = 'P201';
  
  SELECT PROD_ID, PROD_NAME, PROD_PRICE INTO V_PCODE, V_PNAME, V_PRICE
  FROM PROD
  WHERE PROD_LGU = 'P201';-- 그냥 일케 놓으면 1개 밖에 출력이 안대유
END; 
--여기까지 했을 때 오류
01422. 00000 -  "exact fetch returns more than requested number of rows"
-- 패치 되어서 리턴되어진 부분이 1개 이상의 데이터가 변수에 들어간단다
-- 스칼라변수는 오로지 하나의 데이터만 기억하기때문이란다
-- 커서를 쓰면 해결할 수 있단다
*Cause:    The number specified in exact fetch is less than the rows returned.
*Action:   Rewrite the query or change number of rows requested


DECLARE
  V_PCODE PROD.PROD_ID%TYPE;
  V_PNAME PROD.PROD_NAME%TYPE;
  V_PRICE PROD.PROD_PRICE%TYPE;
  V_REMARKS VARCHAR2(50);
  V_AVG_PRICE PROD.PROD_PRICE%TYPE;
  
  CURSOR CUR_PROD_PRICE  --가격을 반환해 주는 커서를 만들자
  IS 
    SELECT PROD_ID, PROD_NAME, PROD_PRICE
    FROM PROD
    WHERE PROD_LGU='P201'; 
BEGIN
  SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
  FROM PROD
  WHERE PROD_LGU = 'P201';
  
  OPEN CUR_PROD_PRICE
  LOOP
    FETCH CUR_PROD_PRICE INTO V_PCODE, V_PNAME, V_PRICE;
    EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
    IF V_PRICE > V_AVG_PRICE THEN
      V_REMARKS:='평균가격 이상 상품';
    ELSIF  V_PRICE < V_AVG_PRICE THEN
      V_REMARKS:='평균가격 이하 상품';
    ELSE
      V_REMARKS:='평균가격 상품';
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_PCODE||', '||V_PNAME||', '||V_PRICE||', 'V_REMARKS);
  END LOOP;  
  CLOSE CUR_PROD_PRICE;
END; 

--내 풀이는 뭐가 틀렸을까??


-- 쌤풀이
DECLARE
  V_PCODE PROD.PROD_ID%TYPE;
  V_PNAME PROD.PROD_NAME%TYPE;
  V_PRICE PROD.PROD_PRICE%TYPE;
  V_REMARKS VARCHAR2(50);
  V_AVG_PRICE PROD.PROD_PRICE%TYPE;
  
  CURSOR CUR_PROD_PRICE
  IS
    SELECT PROD_ID,PROD_NAME,PROD_PRICE
      FROM PROD
     WHERE PROD_LGU='P201'; 
BEGIN
  SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
    FROM PROD
   WHERE PROD_LGU='P201'; 
  
  OPEN  CUR_PROD_PRICE;
  LOOP
    FETCH CUR_PROD_PRICE INTO V_PCODE,V_PNAME,V_PRICE;
    EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
    IF V_PRICE > V_AVG_PRICE THEN
      V_REMARKS:='평균가격 이상 상품';
    ELSIF V_PRICE < V_AVG_PRICE  THEN
      V_REMARKS:='평균가격 이하 상품';
    ELSE
      V_REMARKS:='평균가격 상품';
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_PCODE||', '||V_PNAME||', '||V_PRICE||', '||
                         V_REMARKS);
 END LOOP;
 CLOSE CUR_PROD_PRICE;
END;   


===========================================================================================

<<조건문 CASE>>
 - 자바의 SWITCH CASE 문과 유사기능 제공
 - 다방향 분기 기능 제공
 
 (사용형식1)
 CASE 변수명|수식 
      WHEN 값1 THEN
        명령1;
      WHEN 값2 THEN
        명령2;  
          :
      ELSE -- 마지막은 웬이 아니고 엘스임 기억하기
        명령n;
 END CASE; -- SQL 케이스 문은 브레이크 필요 없음 

 (사용형식2) 
 CASE WHEN 조건식1 THEN
           명령1;
      WHEN 조건식2 THEN
           명령2;
            :
      ELSE
          명령n;
 END CASE;          


--이프문은 조건분기명령 , 이프문은 삼거리, 다중이프는 여러갈래중하나
--
--명령중 제일 강력한 분기명령이 언컨디셔널브랜치 만나면 무조건 분기 무조건가야함 -> 고투 :  자바에서는 쓰지 말어라
--고투 : 시작은 있는데 끝을 몰라 (스파게티 같아서 스파게티코드) -> 스파게티 코드를 만드는 주 원인이 고투
--
--다중분기 : 전기요금, 전화요금, 누진세, 수도요금 계산 등에 쓰입니다
--        물세 : 만약 43톤이면 처음10톤이면 10톤 구간계산, 나머지 10톤은 그다음 10톤 계산 이렇게 쭉쭉


사용예) 수도요금 계산  (여기에 물사용분담금(끌어쓰는거), 부가세 등등등 하면 진짜 수도세 구하는거 나옴)
  물 사용요금
    톤당 단가 / 1~10 : 350원 / 11~20 : 550원 / 21~30 : 900원 / 그이상 : 1500원 /
  하수도 사용료 (물을 쓰면 쓴만큼 하수도 써야하니까)
    사용량 * 450원

26톤 사용시 요금 : 10*350 + 10*550 + 6*900 + 26*450 = 26,100

ACCEPT P_AMOUNT PROMPT '물 사용량 : '
DECLARE 
  V_AMT NUMBER := TO_NUMBER('&P_AMOUNT');
  V_WA1 NUMBER := 0; -- 물사용요금
  V_WA2 NUMBER := 0; -- 하수도 사용요금
  V_HAP NUMBER := 0; -- 요금합계
BEGIN
  CASE WHEN V_AMT BETWEEN 1 AND 10 THEN
        V_WA1:=V_AMT*350;
       WHEN V_AMT BETWEEN 11 AND 20 THEN
        V_WA1:=3500+(V_AMT-10)*550;
       WHEN V_AMT BETWEEN 21 AND 30 THEN
        V_WA1:=3500+5500+(V_AMT-20)*900;
       ELSE 
        V_WA1:=3500+5500+9000+(V_AMT-30)*1500;
  END CASE;
  V_WA2:=V_AMT*450;
  V_HAP:=V_WA1+V_WA2;
  
  DBMS_OUTPUT.PUT_LINE(V_AMT||'톤의 수도요금 : '||V_HAP);
END;  
  