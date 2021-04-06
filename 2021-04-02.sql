SEQUENCE 객체
 - 자동으로 증가되는 값을 반환할 수 있는 객체
 - 테이블에 독립적(다수의 테이블에서 동시 참조 가능)
 - 기본키로 설정할 적당한 컬럼이 존재하지 않는 경우 자동으로 증가되는 컬럼의 속성으로 자주 사용됨
    (사용형식)
 CREATE SEQUENCE 시퀀스명 
 [START WITH n][INCREMENT BY n][MAXVALUE n | NOMAXVALUE]
 [MINVALUE n | NOMINVALUE][CYCLE | NOCYCLE][CACHE n | NOCACHE][ORDER | NOORDER]
 . START WITH n : 시작값, 생략하면 MINVALUE
 . INCREMENT BY n : 증감값 생략시 1로 간주
 . MAXVALUE n : 사용하는 최대값, default는 NOMAXVALUE이고 10^27까지 사용
 . MINVALUE n : 사용하는 최대값, default는 NOMINVALUE이고 1
 . CYCLE :최대(최소)까지 도달한 후 다시 시작할 것인지 여부, default는 NOCYCLE
 . CACHE n : 생성할 값을 캐시에 미리 만들어 사용 default는 CACHE 20 임
 . ORDER : 정의된대로 시퀀스 생성 강제 default는 NOORDER
 
** 시퀀스객체 의사(Pseudo Column)컬럼
 1. 시퀀스명.NEXTVAL : '시퀀스'가 다음 값 반환
 2. 시퀀스명.CURRVAL : '시퀀스'가 현재 값 반환
 -- 시퀀스가 생성되고 해당 세션의 첫 번째 명령은 반드시 시퀀스명.NEXTVAL이어야 함
 
 사용예)LPROD 테이블에 다음 자료를 삽입하시요(단, 시퀀스를 이용하시오)
   [자료]
   LPROD_ID : 10번부터
   LPROD_GU : p501,  p502,  p503  
   LPROD_NM : 농산물, 수산물, 임산물 
  
  1)시퀀스 생성
  CREATE SEQUENCE SEQ_LPROD
  START WITH 10;
  
  SELECT SEQ_LPROD.CURRVAL FROM DUAL; 
  -- 이거는 오류가 납니다
  
  2)자료삽입
  INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'p501', '농산물');
  
  SELECT * FROM LPROD;
  
  INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'p502', '수산물');
  INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'p503', '임산물');
  
  두 행을 한 번에 넣으려면???
  CURRVAL로 삽입을 하면 어케돼지???
  -- 이거 두 개는 내가 알아서 해보자
 
 사용예) 오늘이 2005년 7월 28일인 경우 'm001'회원이 제품 'P201000004'을 5개 구입했을 때
        CART 테이블에 해당 자료를 삽입하는 쿼리를 작성하시오
        -- 먼저 날짜를 2005년 7월 28일로 변경 후 작성할 것
  SELECT * FROM CART 
  트리거
  cart_no : 200507280005 이거를 자동으로 만드려면!
  윈도우에서 날짜를 20050728로 변경하고 -> SYSDATE 쓰기 위해서 
  SELECT TO_CHAR(SYSDATE, 'yyyymmdd') FROM DUAL;
  -- 쌤컴이 변경이 왜 안될까?? 도커를 써서?????ㅇㅇ그렇다
  -- SELECT TO_CHAR(TO_DATE('20050728'),'YYYYMMDD')
  -> 왜 앞에 TO_CHAR로 한 번 더 감으셨을까??
  
  SELECT TO_CHAR(SYSDATE, 'yyyymmdd')||MAX(SUBSTR(CART_NO,9))+1
  FROM CART;
  
  SELECT TO_CHAR(MAX(CART_NO)+1) FROM CART;
  -- TO_ CHAR은 인자가 하나여도 됐었던가???
  
  SELECT 100 + '1' FROM dual;
  
    ------------------------------------------------------------------
    갑자기 카트 넘버 생성 다시???
    
  1) 순번확인  
  SELECT MAX(SUBSTR(CART_NO,9)) FROM CART;  
  
  2) 시퀀스 생성
  CREATE SEQUENCE SEQ_CART
  START WITH 5;
  
  SELECT * FROM CART
  
  INSERT INTO CART(CART_MEMBER, CART_NO, CART_PROD, CART_QTY)
    VALUES('m001',(TO_CHAR(SYSDATE, 'YYYYMMDD')||
    TRIM(TO_CHAR(SEQ_CART.NEXTVAL, '00000'))), 'P20100004', 5);
명령의 79 행에서 시작하는 중 오류 발생 -
  INSERT INTO CART(CART_MEMBER, CART_NO, CART_PROD, CART_QTY)
    VALUES('m001',(TO_CHAR(SYSDATE, 'YYYYMMDD')||
    TRIM(TO_CHAR(SEQ_CART.NEXTVAL, '00000'))), 'P20100004', 5)
오류 보고 -
ORA-02291: integrity constraint (DOTORI.FR_CART_PROD) violated - parent key not found
-- 오류남 ......아휴 모르겠다 시발

** 시퀀스가 사용되는 곳
  . SELECT문의 SELECT절(서브쿼리는 제외)
  . INSERT문의 SELECT절(서브쿼리), VALUES절
  . UPDATE문의 SET절


** 시퀀스의 사용이 제한되는 곳
    . SELECT, DELETE, UPDATE문에서 사용되는 Subquery
    . VIEW를 대상으로 사용하는 쿼리
    . DISTINCT가 사용된 SELECT절
    . GROUP BY/ ORDER BY 가 사용된 SELECT문
    . 집합연산자(UNION,MINUS,INTERSECT)가 사용된 SELECT문
    . SELECT문의 WHERE절

===========================================================================================

SYNONYM 객체
 - 동의어 의미
 - 오라클에서 생성된 객체에 별도의 이름을 부여
 - 긴 이름의 객체를 쉽게 사용하기 위한 용도로 주로 사용

 (사용형식)
 CREATE [OR REPLACE] SYNONYM 동의어 이름
 FOR 객체명;
 - '객체'에 별도의 이름인 '동의어 이름'을 부여
  
 (사용예)
 HR계정의 REGIONS 테이블의 내용을 조회
 SELECT HR.REGIONS.REGION_ID AS 지역코드,
        HR.REGIONS.REGION_NAME AS 지역명 
 FROM HR.REGIONS;

 (테이블 별칭을 사용한 경우)
 SELECT a.REGION_ID AS 지역코드,
        a.REGION_NAME AS 지역명 
 FROM HR.REGIONS a;

 (동의어를 사용한 경우)
 CREATE OR REPLACE SYNONYM REG FOR HR.REGIONS;
 
 SELECT a.REGION_ID AS 지역코드,
        a.REGION_NAME AS 지역명 
   FROM REG a;

===========================================================================================

INDEX 객체
 - 데이터 검색 효율을 증대 시키기 위한 도구
 - DBMS의 부하를 줄여 전체 성능향상
 - 별도의 추가공간과 INDEX FILE을 위한 PROCESS가 요구됨
 
 1) 인덱스가 요구되는 곳
  - 자주 검색되는 컬럼
  - 기본키(자동 인덱스 생성)와 외래키
  - SORT,GROUP의 기본 컬럼
  - JOIN 조건에 사용되는 컬럼
 2) 인덱스가 불필요한 곳
  - 컬럼의 도메인이 적은 경우(성별, 나이 등)
  - 검색조건으로 사용했으나 데이터의 대부분이 반환되는 경우
  - SELECT보다 DML명령의 효율성이 중요한 경우
  
비교법 
비비교법 해싱 해시코드 클래스의 주소값계산

인덱스는 해싱기법이 적용됨

이름과 그 나머지 데이터가 저장된 주소

PK로 시작하는 인덱스가 자동 인덱스

 3) 인덱스의 종류
  (1)Unique
    - 중복값을 허용하지 않는 인덱스
    - NULL 값을 가질 수 있으나 이것도 중복해서는 안됨
    - 기본키, 외래키 인덱스가 이에 해당
  (2) Non Unique
    - 중복 값을 허용하는 인덱스
  (3) Normal Index
    - default Index
    - 트리 구조로 구성(동일 검색 횟수 보장)
    - 컬럼값과 ROWID(물리적 주소)를 기반으로 저장
  (4) Function-Based Normal Index
    - 조건절에 사용되는 함수를 이용한 인덱스
  (5) Bitmap Index
    - ROWID와 컬럼 값을 이진으로 변환하여 이를 조합한 값을 기반으로 저장
    - 추가, 삭제, 수정이 빈번히 발생되는 경우 비효율적
    
SELECT * FROM employees
WHERE department_id is null;

SELECT * FROM employees
WHERE job_id = 'AD_PRES'
