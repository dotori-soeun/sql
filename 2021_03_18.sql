<1교시>
ROUND TRUNC : 날짜에도 적용가능하다. 날짜를 반올림하거나 절삭하는 것이 가능하다 --자주쓰는 기능은 아님

날짜관련함수
- MONTHS_BETWEEN
- ADD_MONTHS     
- NEXT_DAY
- LAST DAY 

<MONTHS_BETWEEN> : 두 일자 사이에 띄워져 있는 개월수. 데이터 타입의 인자가 두 개가 들어감 -> 얘만 날짜가 아닌 숫자를 반환!!
        -- MONTHS_BETWEEN(start date, end date)
        -- 개월수가 딱 떨어지지 않으면 소수점으로 표현됨. 일반적으로 소수점은 버리거나 반올림하여 사용한다.        
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:mi:ss') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) month_between
FROM emp; 

<ADD_MONTHS> : 꽤 쓰는 기능. 어떤 날짜로부터 ~뒤에 날짜가 몇일인가 이런식. date로부터 x개월 뒤의 날짜
        -- ADD_MONTHS(date, number(더할 개월 수))
        -- 달마다 날짜 수가 달라서 계산하기가 쉽지 않아서 오라클에서 제공하게 된 함수
SELECT ename, ADD_MONTHS(SYSDATE, 5) ADD_MONTHS1,
       ADD_MONTHS(TO_DATE('2021-02-15', 'YYYY-MM-DD'), 5) ADD_MONTHS2 
FROM emp;
-- 여기서 5가 아닌 -5하면 5개월 이전의 날짜

-- 오늘날짜를 문자로 바꿨다가 다시 날짜로 하면 쓸데없이 길어지는 시분초를 날려버릴 수 있다.(장점)
-- 시분초까지 있어버리면 그런 세세한 부분들에서 놓치는 부분이 많아 조회못하는 부분이 많을 수도 있기 때문에

SELECT TO_DATE('2021','YYYY')
FROM dual;
--서버의 현재시간의 월 : 날짜는 자동적으로 1일로 맞춰짐
SELECT TO_DATE('2021'||'0505','YYYYMMDD')
FROM dual;
--5월5로 하고 싶으면 이런식으로
--시간까지 고려해서 23:59:59 이런걸 강제로 붙일 수 있다.

<NEXT_DAY> : 이것도 꽤씀. date 이후의 가장 첫번째 주간 일자에 해당하는 date를 반환 (weekday, 주간일자)
--        지정된 요일의 돌아오는 날짜가 언제인지계산해준다
--        NEXT_DAY(date(날짜), '요일' or number(숫자))
--        일요일은 1, 월요일은 2, 화 : 3, 수 : 4, 목 : 5, 금 : 6
SELECT hiredate, NEXT_DAY(hiredate, '수요일'), NEXT_DAY(hiredate, 4)
FROM emp;

SELECT SYSDATE, NEXT_DAY(SYSDATE, '일요일'), NEXT_DAY(SYSDATE, 1)
FROM dual;

SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:mi:ss') hiredate,
       NEXT_DAY(SYSDATE , 2) NEXT_DAY
FROM emp;

<LAST_DAY> : 가장 자주 쓰는 기능. date가 속한 월의 마지막 일자를 date로 반환
SELECT LAST_DAY(SYSDATE) LAST_DAY 
FROM dual;

--LAST_DAY는 있으나 FIRST_DAY는 없다. 매월 첫날은 1일로 정해져 있으니까
SYSDATE를 이용하여 SYSDATE가 속한 월의 첫번째 날짜 구하기
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD') FIRST_DAY
FROM emp;
-- SYSDATE를 이용해서 년월까지 문자로 구하기 + || '01'을 결합
-- 문자열 결합은 수직바 두 개 ||

실습
파라미터로 yyyymm형식의 문자열을 사용하여 해당 년월에 해당하는 일자 수를 구해보세요
(ex : yyyymm = 201912)
yyyymm = 201912 -> 31
yyyymm = 201911 -> 30
yyyymm = 201602 -> 29

SELECT :yyyymm  --여기서부터 시작
FROM dual;
--일단 이걸 돌려서 바인드 변수의 값에 입력한다

SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') DT  
FROM dual;

--SQL타입 현재 3가지 (숫자, 문자, 날짜)
형변환
 . 명시적 형변환
    TO_DATE, TO_CHAR, TO_NUMBER
 . 묵시적 형변환

SELECT*
FROM emp
WHERE TO_CHAR(empno)= '7369';

=======================================================================
 <2교시>

SQL 실행계획 읽는법 --SQLD시험 단골문제
1. 위에서 아래로
2. 단, 들여쓰기 되어있을 경우(자식노드) 자식노드부터 읽는다.

형변환 NUMBER
    -- TO_NUMBER(문자값)
    -- NUMBER -> CHARACTER : 잘 안씀. 이미 자바에서 이렇게 변환해주는 모듈이 있다
 - FORMAT
    9 : 숫자
    0 : 강제로 0표시
    , : 1000자리 표시
    . : 소수점
    L : 화폐단위(사용자 지역)
    $ : 달러 화폐 표시
    
    
NULL 처리 함수 : 4가지    
<NVL>(expr1, expr2) : 인자가 2개. 인자 자리에 컬럼도 올 수 있다. 
    -expr1이 NULL 값이 아니면 expr1을 사용하고,
     expr1dl NULL 값이라면 expr2로 대체해서 사용한다 
     -- null값이 포함된 인자와 연산했을 때 값이 있어도 null로 표현되는 것을 방지하기 위해
--자바식 표현 
 if( expr1 == null)     
    System.out.println(expr2)
 else     
    System.out.println(expr1)
 
 emp테이블에서 comm 컬럼의 값이 NULL일 경우 0으로 대체 해서 조회하기
 SELECT empno, comm, NVL(comm, 0)
 FROM emp;

 SELECT empno, sal,  sal + comm
 FROM emp;
    -- NULL이 포함된 값과 그냥 연산하면 값이 있어도 NULL이 나온다 
 SELECT empno, sal, comm,
        sal + NVL(comm, 0) nvl_sal_comm,
        NVL(sal+comm, 0) nal_sal_comm2
 FROM emp;
    

<NVL2>(expr1, expr2, expr3)
if(expr1 != null)
    System.out.println(expr2);
else
    System.out.println(expr3);

comm이 null이 아니면 sal+comm을 반환,
comm이 null이면 sal을 반환
SELECT empno, sal, comm, 
       NVL2(comm, sal+com, sal) NVL2,
       sal + NVL(comm, 0) NVL
FROM  emp;


NULLIF(expr1, expr2) : 정말 잘 안씀
if(expr1 == expr2)
    System.out.println(null);
else
    System.out.println(expr1);

SELECT empno, sal, NULLIF(sal, 1250)
FROM emp;


COALESCE(expr1, expr2, expr3,.....) 인자의 갯수가 정해져있지 않다.
인자들 중에 가장 먼저 등장하는 null이 아닌 인자를 반환
재귀함수??
if(expr1 != null)
    System.out.println(expr1);
else
    COALESCE(expr2, expr3,.....);
    if(expr2 != null)
         System.out.println(expr2);
    else
         COALESCE(expr3,.....);

SELECT empno, sal, comm, COALESCE(
FROM emp



다음과 같이 조회되도록 쿼리를 작성하세요 ( 사진)
(nvl, nvl2, coalesce)
SELECT empno, ename, mgr, 
       NVL(mgr, 9999) mgr_N, 
       NVL2(mgr, mgr, 9999) mgr_N1, 
       coalesce(mgr, 9999) mgr_N2
FROM emp;
 
=======================================================================
 <3교시>
다음과 같이 조회되도록 쿼리를 작성하세요 ( 사진)
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) N_REG_DT
FROM users
WHERE userid IN ('cony', 'sally', 'james', 'moon');


조건분기
1. CASE 절 --(자바의 if와 비슷)
    CASE expr1 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값    => if
    CASE expr2 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값2   => else if
    CASE expr3 비교식(참거짓을 판단 할 수 있는 수식) THEN 사용할 값3   => else if
    ELSE 사용할 값4                                                => else
    END -- 꼭 END로 끝날 것
  직원들의 급여를 인상하려고 한다.
  job이 SALESMAN 이면 현재 급여에서 5%를 인상
  job이 MANAGER 이면 현재 급여에서 10%를 인상
  job이 PRESIDENT 이면 현재 급여에서 20%를 인상
  그 이외의 직군은 현재 급여를 유지
  
  SELECT ename, job, sal, 인상된 급여
  FROM emp;
  
  SELECT ename, job, sal,
         CASE
             WHEN job = 'SALESMAN' THEN sal * 1.05
             WHEN job = 'MANAGER' THEN sal * 1.10
             WHEN job = 'PRESIDENT' THEN sal * 1.20
             ELSE sal * 1.0 --(그냥 sal만 써도 됨)
         END SAL_BONUS   
  FROM emp;
 -- ELSE sal * 1.0 -> (그냥 sal만 써도 됨)
 -- 그냥 조회하면 컬럼명이 겁나 김
 -- WHEN SAL > 2000 THEN sal * 1.05 : WHEN절에 참 거짓을 판별할수있는 조건이 오기도 한다.
 
2. DECODE 함수 => COALESCE 함수처럼 가변인자 사용 
-- DECODE는 제한적. 대소비교가 아니라 무조건 동등 (CASE가 더 범용적)
-- 근데 대부분 동등비교라서 거의 DECODE를 더 선호함
DECODE(컬럼, 조건1, 결과1, 조건2, 결과2, 조건3, 결과3..........[, default]) 
  SELECT ename, job, sal, DECODE(job, 
  'SALESMAN', sal*1.05 ,
  'MANAGER', sal*1.10,
  'PRESIDENT', sal*1.20,
  sal * 1.20) sal_bonus_decode
  FROM emp;

쿼리작성실습 - 사진이랑 쌤 필기 다시 적어보고 문제도 다시 풀기
CASE와 DECODE
--DECODE변환 어려우면 줄바꿈하면서 써봐도됨. 실사용에서는 그냥 한줄로 함
SELECT empno, ename, deptno,
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'DDIT'
    END dname
FROM emp;    
--> CASE절 ',' 점 안찍도록 주의!!

SELECT empno, ename, deptno,
    DECODE (deptno,
    10, 'ACCOUNTING',
    20, 'RESEARCH',
    30, 'SALES',
    40, 'OPERATIONS',
    'DDIT') dname
FROM emp;    
--시바 내 대가리 다 빻았나 보내 뚝배기 왜 달고 다님
--그래도 천천히 하니까 됨!! 된다된다!!

쿼리 실습2--> DECODE변환도 해보자
SELECT empno, ename, hiredate, 
    CASE 
        WHEN 
        MOD(TO_CHAR(hiredate,'YYYY'),2) = MOD(TO_CHAR(SYSDATE,'YYYY'),2)
            THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR
FROM emp;
--나머지는 나누는 수보다 커질 수 없다 : 2 => 1,0
--MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2 넘버 변환도 했었는데 
--    그냥 TO CHAR에 MOD계산 해도 알아서 형변환이 된다
--내가 올해랑 비교를 까먹어서 계산에 안챙김 ㅠ
--코드를 자주 수정하지 않게. 자동화. 
SELECT empno, ename, hiredate, 
   DECODE (MOD(TO_CHAR(hiredate,'YYYY'),2),
         MOD(TO_CHAR(SYSDATE,'YYYY'),2),'건강검진 대상자',
        '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM emp;   
 
=======================================================================
 <4교시>
쿼리 실습2의 디코드 변환하자
SELECT empno, ename, hiredate, 
   DECODE (MOD(TO_CHAR(hiredate,'YYYY'),2),
         MOD(TO_CHAR(SYSDATE,'YYYY'),2),'건강검진 대상자',
        '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM emp;  

쿼리 실습3 - 사진 ,디코드 변환해보기
SELECT userid, usernm, reg_dt, 
    CASE 
        WHEN 
        MOD(TO_CHAR(reg_dt,'YYYY'),2) = MOD(TO_CHAR(SYSDATE,'YYYY'),2)
            THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END CONTACT_TO_DOCTOR
FROM users
WHERE userid IN ('brown', 'cony', 'james', 'moon', 'sally'); -- 이거까지하면 진짜 사진하고 같음

SELECT userid, usernm, reg_dt, 
    DECODE(MOD(TO_CHAR(reg_dt,'YYYY'),2), MOD(TO_CHAR(SYSDATE,'YYYY'),2),
           '건강검진 대상자', '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM users
WHERE userid IN ('brown', 'cony', 'james', 'moon', 'sally');


<<GROUP FUNCTION 그룹함수>>
 : 여러행을 그룹으로 하여 하나의 행으로 결과값을 반환하는 함수
 -- 그룹핑 기준이 중요하다. 자기자신이 나오게 되는 경우도 있음
    - AVG : 평균
    - COUNT : 건수 -> 행의 건수를 리턴
    - MAX : 최대값
    - MIN : 최소값
    - SUM : 합
 : WHERE절과 ORDERBY 절 사이에 들어감 // HAVING 도 있음--이건 내일배움
 
 SELECT deptno, 
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
        COUNT(sal), -- 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), -- 그룹핑 된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(*) -- 그룹핑 된 행 건수
 FROM emp
 GROUP BY deptno;
 --> 예전버전에선 그룹으로 묶으면 자동정렬이 되었는데 요즘버전에선 안그러고 있다. 나중가면 또 바뀔수도

SELECT *
FROM emp;

 SELECT deptno, empno,
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
        COUNT(sal), -- 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), -- 그룹핑 된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(*) -- 그룹핑 된 행 건수
 FROM emp
 GROUP BY deptno;
 --> 이건 오류가 맞음. 부서번호로 그룹화 됐는데 사원번호는 그룹화 되어있지 않으니까
 --> GROUP BY 절에 나온 컬럼이 SELECT절에 그룹함수가 적용되지 않은 채로 기술되면 에러
 --> 이걸 해결하려면 SELECT의 empno를 GROUP BY로 옮긴다 : 그러면 14개행이 나옴.. 자기자신
 --           또는 empno에 MAX(empno) 처럼 그룹함수를 적용시킨다
SELECT deptno, COUNT(*), MAX(sal), ROUND(AVG(SAL),2), SUM(sal)
FROM emp;
--> 이것도 같은 맥락으로 에러
--> 그룹바이절이 없긴해도 SELECT에 모두 다 그룹함수로 나와있기때문에 deptno에도 그룹함수를 적용하면 해결
예외사항
 SELECT deptno, 'TEST',
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
        COUNT(sal), -- 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), -- 그룹핑 된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(*) -- 그룹핑 된 행 건수
 FROM emp
 GROUP BY deptno;
-- TEST는 고정된 값. 상수라서 문제가 없다. 다 TEST로 나오니까
-- TEST말고 100이라는 다른 고정된 값을 입력해도 된다

 SELECT deptno,
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
        COUNT(sal), -- 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), -- 그룹핑 된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(*), -- 그룹핑 된 행 건수
        SUM(comm) -- 원래 NULL값을 포함한 연산의 결과는 NULL인데 그룹함수에선 무시가 된다
                 -- SUM(NVL(comm, 0)) 이런처리를 하지 않아도 된다
                 -- NVL(SUM(comm), 0) 이것과 바로 위의 함수 차이 알기
 FROM emp
 GROUP BY deptno;

전체직원의 수 
SELECT COUNT(*), MAX(sal), ROUND(AVG(SAL),2), SUM(sal)
FROM emp;
--> GROUP BY를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다

 SELECT deptno,
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
        COUNT(sal), -- 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), -- 그룹핑 된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(*), -- 그룹핑 된 행 건수
        SUM(comm) -- 원래 NULL값을 포함한 연산의 결과는 NULL인데 그룹함수에선 무시가 된다
                 -- SUM(NVL(comm, 0)) 이런처리를 하지 않아도 된다
                 -- NVL(SUM(comm), 0) 이것과 바로 위의 함수 차이 알기
 FROM emp
 WHERE LOWER(ename) = 'smith' --이건 가능 근데 여기에 COUNT(*) >=4 같은 그룹함수를 쓰면오류
 GROUP BY deptno;
 
 SELECT deptno,
        MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), 
        COUNT(sal), -- 그룹핑된 행중에 sal 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(mgr), -- 그룹핑 된 행중에 mgr 컬럼의 값이 NULL이 아닌 행의 건수
        COUNT(*), -- 그룹핑 된 행 건수
        SUM(comm) -- 원래 NULL값을 포함한 연산의 결과는 NULL인데 그룹함수에선 무시가 된다
                 -- SUM(NVL(comm, 0)) 이런처리를 하지 않아도 된다
                 -- NVL(SUM(comm), 0) 이것과 바로 위의 함수 차이 알기
 FROM emp
 GROUP BY deptno
 HAVING COUNT(*) >=4
 

 그룹함수에서 null컬럼은 계산에서 제외된다.
 group by 절에 작성된 컬럼 이외의 컬럼이 select 절에 올 수 없다.
 where 절에 그룹 함수를 조건으로 사용할 수 없다.
  - having 절 사용
    - where sum(sal) > 3000 (이건 안됨)
    - having sum(sal) > 3000 (이건 됨)
    
    
 그룹함수 실습 1
 
 SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
 FROM emp;
 
 특이한 경우 아니면 COUNT는 * 와 함께 쓰는 것이 일반적이다
 
 그룹함수 실습 2
 
 SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
 FROM emp
 GROUP BY deptno;