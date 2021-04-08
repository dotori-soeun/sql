<SELECT 1 : prod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요>
SELECT *
FROM prod;

<SELECT 2 : buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요>
SELECT buyer_id, buyer_name
FROM buyer;

<SELECT 3 : cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요>
SELECT *
FROM cart;

<SELECT 4 : member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요>
SELECT mem_id, mem_pass, mem_name
FROM member;

컬럼정보를 보는 방법
1. SELECT*==>컬럼의 이름을 알 수 있다
2. SQL DEVELOPER의 테이블 객체를 클릭하여 정보확인
3. DESC 테이블명; -> DESC emp (describe 설명하다)

SQL 숫자, 날짜타입에 대해 가능한 연산자
일반적인 사칙연산 :  + 더하기, - 빼기, * 곱하기, / 나누기
우선순위 연산자 : () 우선순위변경

NOT NULL : null값이 있어서는 안댐 (Null값 비허용)

데이터타입=유형 (DATA TYPE) 
NUMBER(7,2) - 전체자리가7, 소수자리2라는 뜻
VARCHAR2(10) - 10바이트 이내

empno : number ;
empno + 10 ==> expression(표현) : 컬럼정보가 아닌것들 전부 다
그냥 10을 쓰면 : 10으로 통일하겠다는 뜻
hiredate + 10 ==> 10일수 만큼 미래로 (날짜관련 연산은 더하기와 뺄셈만 가능, 나눗셈곱셈 불가)

SELECT empno + 10
FROM emp;

SELECT empno, empno + 10
FROM emp;

SELECT empno, empno + 10, 10
FROM emp;

가공을 하더라도 데이터값이 변경되지 않음
(cf. update 기존 값을 변경하는 명령문)

SELECT empno, empno + 10, 10,
       hiredate, hiredate + 10       
FROM emp;

SELECT empno empnumber, empno + 10 emp_plus, 10,
       hiredate, hiredate + 10       
FROM emp;
==>[alias]는 문자임. 컬럼명을 바꿔주는 문자 : 컬럼 | expression [AS] [별칭명]
   "" 땀땀 표현하면 띄어쓰기 표현도 가능
SELECT empno empnumber, empno + 10 [AS] emp_plus, 10,
       hiredate, hiredate + 10       
FROM emp;

SELECT empno empno, empno + 10 emp_plus
FROM emp; // -->이것도 실행이 됨(ALSAS관련 시험에 나올 예정)

NULL : 아직 모르는 값, 0과 NULL은 다르다
       **** NULL을 포함한 연산은 결과가 항상 NULL**** 
       ==> 나중에 NULL값을 다른 값으로 치환해주는 함수를 배울거임
SELECT ename, sal, comm, sal+comm, comm+100
FROM emp;

column alias (실습 select2)
<SELECT 1 : prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하세요>
(단 prod_id -> id, prod_name -> name으로 컬럼 별칭을 지정)
SELECT prod_id id, prod_name name
FROM prod;

<SELECT 2 : lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하세요> // L임!
(단 lprod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)
SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

<SELECT 3 : buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하세요>
(단 buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


3교시
literal : 값 자체
literal 표기법 : 값을 표현하는 방법

java 정수 값을 어떻게 표현할까?(10) 
-> int a = 10;
-> float f = 10f;
-> long l = 10L;
-> string s = "Hello World";

SQL문자표기는 ''으로 함 땀땀이 아니고 땀 : 땀땀하면 오류
* | {컬럼 | 표현식 [AS] [ALIAS],....}
SELECT empno, 10, 'Hello World'
FROM emp; 


문자열 연산
java : String msg "Hello" + ",World";

오라클 SQL에서 문자열 연산은 수직바 2개 ||
SELECT empno + 10, ename || ',World'
FROM emp;

DESC emp;

SELECT empno + 10, ename || 'Hello' || ',World',
       CONCAT(ename, ',World') 
-->concat : 문자열 2개를 결합해주는 함수 / 결합할 두개의 문자열을 입력받아 결합하고 결합된 문자열을 반환해준다.
FROM emp;

DESC USERS;

예제 1 -> 접두어 넣어보기 -> 아이디 : brown ,아이디 : apeach
SELECT '아이디 : '||userid
FROM users;
SELECT CONCAT('아이디 : ', userid)
FROM users;

SELECT table_name
FROM user_tables;
--> 실행된이유 : 오라클에서 내부적으로 관리하는 테이블이라서

예제 2 -> 문자열 2개 이상 결합 실습
SELECT 'SELECT' || ' * FROM ' || table_name || ';'
FROM user_tables;
SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT', ' * FROM '), CONCAT(table_name, ';'))
FROM user_tables;
SELECT CONCAT(CONCAT('SELECT * FROM ', table_name),';') 
FROM user_tables;


WHERE절(조건절) 조건연산자
= 같은 값
!=,<> 다른 값
> 클때
>= 크거나 같을때
< 작을때
<= 작거나 같을때

--부서번호가 10번인 직원들만 조회 -> 부서번호 : deptno
SELECT *
FROM emp
WHERE deptno=10; 

--users테이블에서 userid 컬럼의 값이 brown인 사용자만 조회 -> brown은 문자니까 ''꼭!! 문자열표기 지키기!!
-->그리고 데이터는 대소문자 가리니까 지켜주기!!!(키워드는 상관없음!)
--***SQL키워드는 대소문자를 가리지 않지만 데이터값은 대소문자를 가린다.
SELECT *
FROM users
WHERE userid = 'brown';

--emp테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회 -> ~보다 크다는 ~를 포함하지 않는다~
SELECT *
FROM emp
WHERE deptno > 20;

--emp테이블에서 부서번호가 20번 부서에 속하지 않은 모든직원 조회
SELECT *
FROM emp
WHERE deptno != 20;

WHERE : "기술한 조건을 참(TRUE)"으로 만족하는 행들만 조회한다.(FILTER)
SELECT *
FROM emp
WHERE 1=1; --> 항상 참인 조건을 쓰면 모든 행이 다 나와버림
SELECT *
FROM emp
WHERE 1=2; --> 항상 거짓인 조건을 쓰면 다 안나옴


SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= ???????????? ; 81년 3월 1일 날짜 값을 표기하는 방법...을 모르니까
--그렇다면....???
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '81/03/01';
-- 오라클에서 날짜표기는 문자처럼 해본다???!!!
-- 1983(4자리)나, -(대쉬), 연월일이 아닌 월일연처럼 순서가 다르다면? -> 문제가 될 수 있기때문에
-- 이렇게 쿼리를 작성하는 것은 쪼끔 위험하다! (연 RR=YYYY , 시간HH 분MI....등등)

RR 값이 0~49이면 표기 : 19 -> 실제값 2019
   값이 50~99이면 표기 :59 -> 실제값 1959
   
YYYY를 쓰면 현재 서버의 날짜 연도를 쓴다. 연도는 4자리로 쓰는 것이 좋다! 쌤의 권유!   

문자열을 날짜 타입으로 변환하는 방법
TO_DATE('날짜 문자열', 날짜 문자열의 포맷팅) --> 날짜 타입의 값으로 돌려줌
예시 TO_DATE('1981/03/01', 'YYYY/MM/DD')

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD');
--쿼리가 길어지긴 했으나 이게 훨씬 안전하다!!