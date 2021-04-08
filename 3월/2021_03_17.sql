SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename) 
 FROM emp;
지난시간 복습
 - 연산자우선순위 -> AND 와 OR 이 함께 나오면 AND 가 우선
 - AND 조건이 늘어날수록 동시에 만족해야 하는 조건이 많아져 검색 건수가 같거나 줄어들 수 밖에 없다
    늘어날 수는 없다
 - 객체의 특징 : 순서가 없다(집합이라서)
 - 정렬 : ORDER BY
 - 페이징 처리 : INLINE VIEW, ROWNUM, ALIAS/ 
    바인드 변수 ':' ->{(n-1)*pageSize} + 1 ==> n*pageSize-(pageSize-1) = n*pageSize-pageSize+1
 --단어가 시작 될 때 마다 대문자 되는 표기법 : 낙타표기법, 카멜표기법
 
 --시험문제 스포 : 트랜잭션, 낫인, 페이징처리, emp테이블 컬럼 이름까지는 외우라
 
 =======================================================================
 <1교시>
 --이제는 함수(function)에 대해서 -> 자바에서는 메소드
 --메소드를 별도로 빼둘 수도 있다 -> 분리 -> 장점 : 내가 원하는 형태로 변환이 가능, 유지보수하는데 도움됨
 Function -> 필요하면 개발자가 만들 수도 있다.
  Single row function
    단일 행을 기준으로 작업하고, 행당 하나의 결과를 반환
    특정 컬럼의 문자열 길이 : length(ename)
    WHERE 절에서도 사용 가능
  Multi row function --두번째고비 : 개념적으로 받아들이는 것을 힘들어 할 수 있다. -> 다 대 일
    여러 행을 기준으로 작업하고, 행당 하나의 결과를 반환
    그룹함수 : count, sum, avg
    
--이런 연습 해보세요 , 이런 습관을 가져보세요~
함수명을 보고
1. 파라미터가 어떤게 들어갈까? --파라미터 : 인자
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?

--자바 단축 -> sysout 치고 ctrl + space

Character
 - 대소문자
    LOWER : 소문자로 변환해줌 -- 입력값 반환값 모두 문자
    UPPER : 대문자로 변환해줌
    INITCAP : 소문자로 만들어 준 후 첫글자를 대문자로 변환해줌

-- SELECT * | {컬럼 | expression}

 SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename) 
 FROM emp;
    -- 행당 하나의 함수만 쓸 수 있는 건 아님

 SELECT ename, LOWER(ename), LOWER('TEST')
 FROM emp;
    -- 'TEST' ->  문자열 리터럴, 문자열 상수
    
 - 문자열 조작 
    CONCAT : 문자열 두 개 결합하여 결합된 문자 하나를 반환
    SUBSTR : 어떤 문자열의 일부분을 빼오고 싶을 때. 쉽게 생각할 수는 없다. 사용법도 다양
             실무에서 자주 쓰이는
    LENGTH : 문자열의 길이를 받아내는
    
 SELECT ename, LOWER(ename), LOWER('TEST'),
        SUBSTR(ename, 1, 3)    
 FROM emp;   
  --SUBSTR 예시 + (ename, 2) 시작 문자열만 주면 두번째부터 끝까지

 - 문자열 조작   -- 인터넷 좀 더 찾아보고 정리하기
    INSTR
    LPAD|RPAD 
    TRIM
    REPLACE : 치환(문자열 3개 들어감)

 =======================================================================
 <2교시>    
 - DUAL table
    - sys계정에 있는 테이블
    - 누구나 사용 가능
    - DUMMY 컬럼 하나만 존재하며 값은 'x'이며 데이터는 한 행만 존재
    - 사용용도 
        - 데이터와 관련없이
         - 함수 실행
         - 시퀀스 실행
        - merge 문에서 --insert랑 update를 합쳐서 만든 특이한 구문
        - 데이터 복제시(connect by level)
  SELECT *
  FROM dual;
  
  -- SELECT : 컬럼을 나열. 행에 영향을 주지 않음
  -- 행에 영향을 주는 것은 WHERE 절
  
  SELECT LENGTH('TEST')
  FROM emp;
  
  SELECT LENGTH('TEST')
  FROM dual;
    -- 위의 구문을 좀 더 효율적으로 활용하기 위해 아래에서 emp를 dual로 바꿈. 행이 하나니까

 emp 테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원만 조회 -- 행에 제한을 줌
    SELECT *
    FROM emp
    WHERE LENGTH(ename) > 5;
 -- 멀티로우는 WHERE에서 이런거 못함   
  
  SELECT *
  FROM emp
  WHERE LOWER(ename) = 'smith';
 -- 싱글로우가 이런 것들도 가능하다 
 -- 쌤은 이방법 딱히 비추천. 함수의 실행 횟수를 생각해보자. 억단위가 넘어가면 힘들다
    -- 엔코아 개발자가 하지말아야 할 칠거지악에 나옴 -> 테이블 컬럼을 가공하지 말아라
    -- 인덱스 컬럼은 비교되기 전에 변형이 일어나면 인덱스를 사용할 수 없다.
  SELECT *
  FROM emp
  WHERE ename = UPPER('smith'); -- == WHERE ename = 'SMITH';
 -- 싱글로우가 이런 것들도 가능하다    

-- 유명한 데이터 베이스 컨설팅 업체 : 엔코아 -> 지금은 좀 죽음
-- 엔코아 ==> 엔코아_부사장 : b2en ==> b2en 대표컨설턴트 : dbian(스펠링 부정확할수도)
-- 컨설팅회사는 오라클도 버전단위로 공부함. 보통 연차 5년까지는 새벽3시이후에 못잔다고 할 수도

ORACLE 문자열 함수 실습해보기
 SELECT 'HELLO' || ',' || 'WORLD',
        CONCAT('HELLO', CONCAT(',', 'WORLD')) CONCAT,
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
        LENGTH('HELLO, WORLD') LENGTH,
        INSTR('HELLO, WORLD', 'O') INSTR,
        INSTR('HELLO, WORLD', 'O', 6) INSTR2,
        LPAD('HELLO, WORLD', 15, '*') LPAD,
        RPAD('HELLO, WORLD', 15, '*') RPAD,
        REPLACE('HELLO, WORLD' , 'O', 'X') REPLACE,
        TRIM('   HELLO,  WORLD   ') TRIM,
        TRIM('D' FROM 'HELLO,  WORLD') TRIM
 FROM dual;
 
-- LENGTH -> 공백도 문자열이다 
-- INSTR('HELLO, WORLD', 'O', 6) INSTR : 이런 문자열에서 6번째 문자열부터 탐색하라는 뜻
    -- 나중에 계층쿼리 배우면 이런식으로 값을 얻어낼 수 있다.
    -- ('XX회사-개발본부-개발부-개발팀-개발파트)이런데서 잘라내는 위치 계산해서 SUBSTR의 인자로 줌
-- LPAD('HELLO, WORLD', 15, '*') LPAD : 총 15글자로 만들고 싶고 부족한 자리는 '*'로 왼쪽에 채워라는 뜻(패딩)    
-- TRIM : 공백을 제거, 문자열의 앞과, 뒷부분에 있는 공백만. 가운데는 건들지 않음
    -- TRIM('D' FROM 'HELLO,  WORLD') TRIM : 공백 대신 문자열 지정제거도 가능
-- 마지막에 붙은 함수는 ALIAS
-- 외우려고 하지말고 직접실행해보고 인덱스를 뭐로 주는게 맞는지 판단하는식으로 이해하자

=======================================================================
 <3교시>
 - number
  - 숫자 조작
    - ROUND : 반올림
    - TRUNC : 내림
    - MOD : 나눗셈의 나머지 -- 자바의 표기 %랑 헷갈리면 안대용
  
  SELECT MOD(10, 3) --MOD(피제수 제수)
  FROM dual;        
  
  SELECT
  ROUND(105.54, 1) round1, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 반올림
  ROUND(105.55, 1) round2, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 반올림
  ROUND(105.55, 0) round3, -- 소수점이 0 : 반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째자리에서 반올림
  ROUND(105.55, -1) round4 -- 소수점이 0 : 반올림 결과가 두번째 자리(십의 자리)까지 나오도록 : 정수 첫째 (일의 자리)에서 반올림
  ROUND(105.55) round5 -- 소수점이 0 : 반올림 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째자리에서 반올림
  FROM dual;
  
  -- ROUND나 TRUNC 사용법은 같음
  -- 구간선택후 ctrl f 로도 치환은 가능?? 시험해보자
  
  SELECT
  TRUNC(105.54, 1) round1, -- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 절삭
  TRUNC(105.55, 1) round2, -- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 소수점 둘째자리에서 절삭
  TRUNC(105.55, 0) round3, -- 소수점이 0 : 절삭 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째자리에서 절삭
  TRUNC(105.55, -1) round4, -- 소수점이 0 : 절삭 결과가 두번째 자리(십의 자리)까지 나오도록 : 정수 첫째 (일의 자리)에서 절삭
  TRUNC(105.55) round5 -- 소수점이 0 : 절삭 결과가 첫번째 자리(일의 자리)까지 나오도록 : 소수점 첫째자리에서 절삭
  FROM dual;
  
  -- 이클립스 세로 편집 : ALT + Shift + a 하고 구간선택해서 세로로 편집(빠져나올때도 동일)
  
  -- ex : 7499, ALLEN, 1600, 1, 600
  SELECT empno, ename, sal, sal/1000 sal을 1000으로 나눴을 때의 몫, MOD(sal,1000)sal을 1000으로 나눴을 때의 나머지
  FROM emp;
  
   SELECT empno, ename, sal, sal/1000, MOD(sal,1000)
   FROM emp;
    
    SELECT empno, ename, sal, TRUNC(sal/1000), MOD(sal,1000)
    FROM emp;
    -- 몫은 정수부분만 하면 되기 때문에 마무리로 TRUNC를 붙여 준다

    
날짜 <==> 문자
서버의 현재 시간 : SYSDATE
SELECT SYSDATE
FROM dual;
-- 시간이 표현 안되는건 서버의 날짜 설정에서 시간이 없기 때문 -> [환경설정에서 변경가능]
    -- [도구] -> [환경설정] -> [데이터베이스] -> [NLS] -> [날짜형식] : YYYY/MM/DD HH24:MI:SS
-- 오라클에서 인자가 없는 함수는 괄호를 안씀 (자바는 메소드에 인자가 없어도 괄호 - 자바 문법상 그래야함)

SELECT SYSDATE, SYSDATE +1/24, SYSDATE +1/24/60, SYSDATE +1/24/60/60
FROM dual;
-- SYSDATE 연산은 이렇게 단위 설정 가능

date 실습
1. 2019년 12월 31일을 date 형으로 표현
2. 2019년 12월 31일을 date 형으로 표현하고 5일 이전 날짜
3. 현재날짜
4. 현재 날짜에서 3일 전 값

SELECT TO_DATE ('2019-12-31','YYYY-MM-DD')
       TO_DATE ('2019-12-31','YYYY-MM-DD')-5,
       SYSDATE,
       SYSDATE -3
FROM dual;   
-- 제발 투데이트 함수할때 날짜랑 포맷 다 '' 좀......

SELECT TO_DATE ('2019-12-31','YYYY-MM-DD') LASTDAY,
       TO_DATE ('2019-12-31','YYYY-MM-DD')-5 LASTDAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE -3 NOW_BEFORE3
FROM dual; 

TO_DATE : 문자 -> 날짜 : 인자-문자, 문자의 형식
TO_CHAR : 날짜 -> 문자 : 인자-날짜, 문자의 형식
-- 날짜 -> 날짜 는 있을 수 없으니    SELECT TO_DATE(SYSDATE....) -> 이런거 안돼요

-- 개발자가 제일 힘들어하는 일 : 이름짓기(변수명, 메소드명, 클래스명, 파일명, 디렉토리명, 프로젝트코드명 등)
    -- 내가 알아볼 수 있게 길게 해도 된다 특히 변수
    
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
FROM dual;
-- 포맷팅시에 내가 원하는 날짜만 지정해서 뽑을 수 있다 YYYY, YYYY-DD 이런식으로 

=======================================================================
 <4교시>
 -- 유비쿼터스 -> IOT // 벤처 -> 스타트업
 -- 갑자기 비트컴퓨터 얘기가 왜 나왔지?
 -- 결론 : '나는 여기에 왜 왔는가'를 잘 생각하고 행동하자 -> 실행력의 차이
 -- 내가 자바개발에 관심이 있다면 자바로 뭔가를 만들어 봐야한다
 -- 개발 공부는 책 덮고나서 다시 또 직접 혼자서 해봐야한다
 -- 도서추천 : 그릿 Grit  ==> 과제 : 그릿저자 TED강의 보고 느낀점 작성
 -- 채널추천 : 노마드코더  ==> 과제 : 노마드코더, 누구나 코딩을 할수있다? 영상보고 느낀점

NLS : YYYY/MM/DD/ HH24:MI:SS
 - FORMAT -- 외워야한다
  - YYYY : 4자리 년도
  - MM : 2자리 월
  - DD : 2자리 일자
  - D : 주간 일자 (0~6)
  - IW : 주차 (1~53)
  - HH, HH12 : 2자리 (12시간 표현)
  - HH24 : 2자리 시간 (24시간 표현)
  - MI : 2자리 분
  - SS : 2자리 초
-- 주차(IW) : 1~53
-- 주간요일(D) 0부터 일요일, 1-월요일......
 
SELECT TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D')
FROM dual;

-- 자바랑 날짜 포맷팅 형식이 좀 다름 MM, mm

오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년 

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 
       TO_CHAR(SYSDATE, 'YYYY-MM-DD-HH24-MI-SS'),
       TO_CHAR(SYSDATE, 'DD-MM-YYYY')
FROM dual;       

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH, 
       TO_CHAR(SYSDATE, 'YYYY-MM-DD-HH24-MI-SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;  
 
-- TO_CHAR(SYSDATE, 'YYYY-MM-DD')를 또 날짜로 변환할 수 있을까?
    SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
    FROM dual;
        -- 쌉가능. 반대의 경우도 가능

마지막 설명 뭔가 엄청 많이함. 좀 복잡. 뭘 안하면 그냥 SYSDATE로 남는다고
-- '2021-03-17' ==> '2021-03-17 12:41:00'        
    SELECT TO_CHAR(TO_DATE('2021-03-17','YYYY-MM-DD'),'YYYY-MM-DD HH24-MI-SS')
    FROM dual;

-- '날짜 -> 문자 -> 날짜' 또는 그 반대의 경우 빈번하게 일어남. 익숙해지자
SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD')
FROM dual;
--비슷한 패턴
CONCAT('HELLO', CONCAT(',', 'WORLD'))