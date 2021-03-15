2021-03-21복습
--row 14개, col 8개 <emp테이블>
조건에 맞는 데이터 조회 : WHERE 절 - ; 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다(FILTER); // !=,<> 다른 값 ;
literal : 값 자체
literal 표기법 : 값을 표현하는 방법
SQL문자표기는 ''으로 함 땀땀이 아니고 땀 : 땀땀하면 오류
* | {컬럼 | 표현식 [AS] [ALIAS],....}
오라클 SQL에서 문자열 연산은 수직바 2개 ||
-->concat : 문자열 2개를 결합해주는 함수 / 결합할 두개의 문자열을 입력받아 결합하고 결합된 문자열을 반환해준다.
문자열을 날짜 타입으로 변환하는 방법
TO_DATE('날짜 문자열', 날짜 문자열의 포맷팅) --> 날짜 타입의 값으로 돌려줌
예시 TO_DATE('1981/03/01', 'YYYY/MM/DD') , TO_DATE('81/03/01', 'YY/MM/DD')

===============================================================
--1교시

--입사일자가 1982년 1월 1일 이후인 모든 직원 조회하는 SELECT쿼리를 작성하세요
SELECT *
FROM emp
WHERE hiredate>'82/01/01';

SELECT *
FROM emp
WHERE hiredate > TO_DATE('1982/01/01', 'YYYY/MM/DD');
WHERE hiredate > TO_DATE('1982-01001', 'YYYY-MM-DD')
WHERE hiredate > TO_DATE('19820101', 'YYYYMMDD')
-->연도를 2자리만 82라고 하고 YY라고 하면 그 앞의 천과 백자리의 연도를 현재연도로 인식하기 때문에 2082라고 해석하여 값이 안나올 수 있음
-->(YY 두개만 쓰면 값과 관계없이 현재서버날짜의 년도 앞 두자리를 사용)
-->82년 1월1일이후 : 날짜를 비교해야하는 것 -> 오라클에서는 날짜의 대소 비교가 가능
--> a>=b  ==  b<=a


WHERE절에서 사용 가능한 연산자
(비교 = 같은 값, !=,<> 다른 값, > 클때, >= 크거나 같을때, < 작을때, <= 작거나 같을때)

+ : a+b : 2항연산자 ;
a++ ==> a=a+1 , ++a ==> a=a+1  : 단항연산자 ;

===============================================================

--<2교시>
BETWEEN AND : 3항연산자;
비교대상 BETWEEN 비교대상의 허용 시작값 AND 비교대상의 허용 종료값

true AND true ==> true
true AND false ==> false

true OR false ==> true

ex : 부서번호가 10번에서 20번 사이에 속한 직원들만 조회
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20

emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
    sal >= 1000 AND
    sal =< 2000
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000

SELECT *
FROM emp
WHERE sal >= 1000 
AND sal =< 2000;
--두 조건을 동시에 만족해야하니까 ( 안돌아가 왜??)  

SELECT *
FROM emp
WHERE sal >= 1000 
  AND sal =< 2000
  AND deptno = 10;
--3조건 동시만족 ( 안돌아가 왜??)

emp테이블에서 입사 일자가 1982년 1월1일 이후부터 1983년 1월1일 이전인 사원의 ename, hire 데이터를 조회하는 쿼리를 작성하시오
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN '1982/01/02' AND '1982/12/31';

-->오답노트
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE ('1982/01/01','YYYY-MM-DD') AND TO_DATE ('1983/01/01','YYYY-MM-DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE ('1982/01/01','YYYY-MM-DD') 
  AND hiredate <= TO_DATE ('1983/01/01','YYYY-MM-DD');

BETWEEN AND : 포함(이상,이하)
              초과, 미만의 개념을 적용하려면 비교연산자를 사용해야 한다.


IN 연산자 --> 굳이 따지면 2항연산자
대상자 IN(대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3)
deptno IN (10, 20) ==> deptno값이 10이나 20번이면 TRUE;

SELECT *
FROM emp
WHERE deptno IN (10, 20) ;

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   
SELECT *
FROM emp
WHERE 10 IN (10, 20) ;
-->10은 10과 같거나(TRUE OR) 10은 20과 같다(FALSE) ==> TRUE


users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회하시오
SELECT *
FROM users
WHERE userid IN ('brown', 'cony', 'sally') ;
-->오답정리 : 우선 문자는 작은따옴표를 붙여야 인식가능 그렇지 않으면 컬럼명으로 판단해버림!!!, 그리고 괄호!

1)
SELECT *
FROM users;
-->오답정리 :  열명을 모르면 일단 전체검색
2)
SELECT *
FROM users
WHERE userid = 'brown' ;
-->SQL의 키워드는 대소문자를 가리지 않으나, 데이터는 대소문자를 가림
3) userid = 'brown' 이거나 userid = 'cony' 이거나 userid = 'sally'이거나
SELECT *
FROM users
WHERE userid = 'brown' OR userid = 'cony' OR userid = 'sally';

4) ***ALIAS, IN***
SELECT userid AS 아이디, usernm AS 이름, alias AS 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

===============================================================

--<3교시>---
LIKE 연산자 : 문자열 매칭 조회 --> 2항연산
게시글 : 제목 검색, 내용검색
       제목에 [맥북에어]가 들어가있는 게시글만 조회
테이블 : 게시글
제목 컬럼 : 제목
SELECT *
FROM 게시글
WHERE 제목 Like '%맥북에어%';
-->제목에 있거나 내용에 있거나
SELECT *
FROM 게시글
WHERE 제목 Like '%맥북에어%'
   OR 내용 Like '%맥북에어%';
TRUE OR TRUE -> TRUE / TRUE OR FALSE -> TRUE 
/ FALSE OR TRUE -> TRUE / FALSE OR FALSE -> FALSE
TRUE AND TRUE -> TRUE / TRUE AND FALSE -> FALSE 
/ FALSE AND TRUE -> FALSE / FALSE AND FALSE -> FALSE 
   
마스킹문자 : %,_
% : 0개 이상의 문자 --> c% 첫글자가 C인것
_ : 1개의 문자

userid가 c로 시작하는 모든 사용자
SELECT *
FROM users
WHERE userid Like 'c%';

userid가 c로 시작하면서 c 이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid Like 'c___';       

**userid에 l이 들어가는 모든 사용자 조회**
SELECT *
FROM users
WHERE userid Like '%l%';

member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
-->우선 내가 가진 테이블에서 member가 있는지 먼저 확인, 전체데이터도 조회해보기
-->성이 신씨인 사람 : mem_name의 첫글자가 신이고 뒤에는 뭐가 와도 상관없다
SELECT mem_id, mem_name
FROM member
WHERE mem_name Like '신%';

member 테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오
SELECT mem_id, mem_name
FROM member
WHERE mem_name Like '%이%';


IS, IS NOT (NULL 비교)
emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
SELECT *
FROM emp
WHERE comm = NULL;
--> 쿼리가 실행은 되나 원하는 결과가 나오지 않음. NULL은 동등비교 연산자를 사용할 수 없다.
SELECT *
FROM emp
WHERE comm IS NULL;

SELECT *
FROM emp
WHERE comm IS NOT NULL;
-->NULL이 아닌 사람

emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NULL;
-->mgr=0 이렇게 하면 안댐! 0이랑 null은 다르다!


BETWEEN AND, IN, LIKE, IS

논리 연산자 AND, OR, NOT
AND : 두 가지 조건을 동시에 만족시키는지 확인할 때
     조건1 AND 조건2
OR : 두 가지 조건 중 하나라도 만족 시키는지 확인할 때
     조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
     mgr IS NULL :mgr 컬럼의 값이 NULL인 사람만 조회
     mgr IS NOT NULL :mgr 컬럼의 값이 NULL이 아닌 사람만 조회
     
emp 테이블에서 mgr 사번이 7698이면서 --> mgr컬럼임. 사번이 아니고 , 이면서=AND
sal값이 1000보다 큰 직원만 조회:
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000;
--> 조건의 순서를 바꾼다고 결과가 달라지진 않는다. 집합이기 때문에 -> 조건의 순서는 결과와 무관하다  
SELECT *
FROM emp
WHERE mgr = 7698
  OR sal > 1000; 
--> OR=~거나, 또는

AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다
     IS NOT, NOT IN, NOT LIKE

--직원의 부서번호가 30번이 아닌 직원들

SELECT *
FROM emp
WHERE deptno !=30;

SELECT *
FROM emp
WHERE deptno NOT IN (30);
-->NOT IN : 포함되지 않는다


SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';
-->LIKE 패턴을 부정형으로 쓰는 건 드물다.


NOT IN 연산자 사용시 주의점 : 비교값중에 NULL이 포함되면 데이터가 조회되지 않는다.!! 시험!!

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);--> mgr = 7698 OR mgr = 7839 OR mgr = NULL
--> mgr이 NULL인 사람이 조회되지 않음 : NULL은 '='와 쓰이지 않는다.
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);-->!(mgr = 7698 OR mgr = 7839 OR mgr = NULL)
==> mgr != 7698 AND mgr != 7839 AND mgr != NULL --> TRUE FALSE 의미가 없음 AND FALSE
--> 값이 나오지 않음 : OR의 부정은 AND가 된다. IN은 '=' 여러 개를 OR연산(이거나)이나, 
--> NOT IN은 AND연산(이면서).

SELECT *
FROM emp
WHERE mgr IN (SELECT deptno 
              FROM emp) --> 서브쿼리 값에서 NULL이 나오는 것도 주의!!!!!!!
===============================================================

--<4교시>

emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE job IN ('SALESMAN') --> job is 'SALESMAN'은 오류나옴(NULL missing) --> IS는 NULL과 함께
  AND hiredate > TO_DATE ('1981/06/01','YYYY-MM-DD');

SELECT *
FROM emp
WHERE job = 'SALESMAN' --> 좀 더 단순하게 생각해보자
  AND hiredate >= TO_DATE ('1981/06/01','YYYY-MM-DD');--> 이후 : 시작값포함!
  

emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요  
SELECT *
FROM emp
WHERE deptno != 10 --> deptno NOT IN (10)
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
  
LIKE에서 마스킹문자 안쓰면 오라클에서 '=' 이퀄로 치환함-> 그래서 실행은 됨

emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요
(부서는 10, 20, 30 만 있다고 가정하고 IN 연산자를 사용)
SELECT *
FROM emp
WHERE deptno NOT IN (10) 
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD')
  AND deptno IN (10, 20, 30);
--> NOT IN을 쓰라는 말이 없었음. 내가 문제이해잘못함  
SELECT *
FROM emp
WHERE deptno IN (20, 30); --> deptno NOT IN (10)
  AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'); 
  
emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월1일 이후인 직원의 정보를 다음과 같이 조회하세요  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE ('1981/06/01','YYYY-MM-DD');

emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요   
-->풀면좋고 못풀어도 괜찮다, 푸는방법 여러가지
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno = '78%';
   
SELECT *
FROM emp
WHERE job = 'SALESMAN' --> 여기까진 맞음
   OR empno LIKE '78%'; --> 마스킹문자는 LIKE랑 사용!! =이 아님!
--> empno컬럼이 숫자로 이루어졌는데 암묵적으로 숫자를 문자로 형변환  

**과제**
emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요 
(LIKE연산자를 사용하지 않고!!)
-->data type에 대해서 고민해보면서 풀어보자
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;
   