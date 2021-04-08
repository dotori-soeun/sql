<<뷰 객체>>

지금까지 우리가 쓴 게 익명 뷰
(자바에도 이름 없는 클래스가 있다 : Java 익명 클래스(Anonymous Class) 익명 클래스 , 
                                익명 객체 는 말 그대로 익명 즉 이름이 없는 객체 입니다.)
                                
서브쿼리가 길다는 것은 뎁스가 길다는 것 -> 그러면 수행시간이 오래걸린다
수행시간 : 데이터 Access 하는데 제일 시간 많이 쓴다.

결과를 보관하고 재사용할 수 있다면? 시간이 줄어든다!

---------------------------------------------------------------------------------------------

View는 Table과 유사한 객체이다
View는 기존의 테이블이나 다른 View 객체를 통하여 새로운 SELECT문의 결과를 테이블처럼 사용한다.(가상테이블)
    View는 SELECT문에 귀속되는 것이 아니고, 독립적으로 테이블처럼 존재
View를 이용하는 경우
    필요한 정보가 한 개의 테이블에 있지 않고, 여러 개의 테이블에 분산되어 있는 경우
    테이블에 들어있는 자료의 일부분만 필요하고 자료의 전체 row나 column이 필요하지 않은 경우
    특정 자료에 대한 접근을 제한하고자 할 경우(보안)

예를 들어 굉장히 중요한 테이블이라 -> 사용자에게 전체 공개 할 수 없을 때, 일부 범위만 오픈!
    -> 테이블 자체로는 이 기능이 없으니 뷰를 이용한다.
    
뷰 : 오라클 객체들 중 하나 : 그래서 만들때 CREATE, 삭제할 때 DROP

오라클의 객체들에는 {동의어객체, 시퀀스, 인덱스객체}등이 있다
동의어 : synonym
시퀀스 : 예를들어 1씩 자동 증가 또는 감소 되는 것을 시퀀스로 만들 수 있다
    - 오라클에서는 시퀀스도 독립적인 개체로 인식
    (다른 DBMS는 속성으로 자동 1씩 증가되게 가능하나 이는 테이블에 종속되는 것이다)
인덱스 : 목차처럼 빨리 찾을 수 있게. 찾기의 효율성을 증가시키기 위해 파일로 만들어짐
    - 해싱기법(자료를 찾기 위한 기법)을 이용해서 인덱스가 만들어짐
    https://middleware.tistory.com/entry/%EC%9D%B8%EB%8D%B1%EC%8A%A4Index%EC%99%80-%ED%95%B4%EC%8B%B1Hashing
    - 검색 이진트리 : 정렬!!!!! // 왼쪽은 부모보다 작게 오른쪽은 부모보다 크게
    - 찾는 건 되게 빠른데 유지보수(업데이트 등 수정)하는데 시간이 걸리니까 많이 만든다고 다는 아님
--인덱스까지 다 하면 PLSQL로 들어간다심

---------------------------------------------------------------------------------------------
    
- TABLE과 유사한 기능 제공
- 보안, QUERY 실행의 효율성, TABLE의 은닉성을 위하여 사용
  (사용형식)
  CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름[(컬럼LIST)]
  AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]
    
  - 'OR REPLACE' : 뷰가 존재하면 대치되고 없으면 신규로 생성
  - 'FORCE_NOFORCE' : 원본 테이블이 존재하지 않아도 뷰를 생성(FORCE), 생성불가(NOFORCE)
  - '컬럼LIST' : 생성된 뷰의 컬럼명들을 ',' 콤마로 기술하면 된다
  - 'WITH CHECK OPTION' : SELECT문의 WHERE절(조건절)에 위배되는 DML명령 실행 거부
  - 'WITH READ ONLY' : 읽기전용 뷰 생성

---------------------------------------------------------------------------------------------
테이블은 반드시 1개 이상의 '열'로 이뤄져야 한다. 하지만 행은 1도 없어도 됨
맨 위의 제목들을 "스키마" 라고 한다. -> 구조
---------------------------------------------------------------------------------------------
뷰를 만들 때 테이블 제목 그대로 쓰고 싶으면 [(컬럼LIST)] 기술 안 해도 된다.

뷰를 수정하면 원본이 수정되고, 원본이 수정되면 뷰가 수정됨
그렇게 못하게 하기 위해 'WITH READ ONLY'
--> 'WITH READ ONLY', 'WITH CHECK OPTION' 이 두 개는 성격상 동시에 쓸 수 없다.

뷰 이름을 나타내는 방법 -> 일반적으로 v_ : 뷰라는 것을 알려줌
---------------------------------------------------------------------------------------------
자바의 특성, 특징. 영어단어 1개로 요약한다면??
REUSE 재사용 : 상속, 다형성등
    반드시 저장되어서 다시 불러서 쓰는 것
    저장하려면 '이름'이 있어야 한다. 이름이 없다는 건 저장이 안된 것이다.

SQL의 단점을 해결하는게 PLSQL
(변수, 반복문, 조건문, 배열 등)
---------------------------------------------------------------------------------------------
 
사용 예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오

SELECT *
FROM member;

SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
FROM member
WHERE mem_mileage>=3000;
    
=> 뷰생성
 CREATE OR REPLACE VIEW V_MEMBER01
 AS
  SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
  FROM member
  WHERE mem_mileage>=3000;

-- insufficient privileges : 권한부족    
시스템 계정에서 -> GRANT DBA TO DOTORI;
이러고도 안대면 접속만 해제했다가 다시 들어와보면 댐

SELECT * FROM V_MEMBER01;

(신용환 회원의 자료 검색)
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE mem_id = 'c001'; -- C가 대문자이면 안 됨. 진짜 데이터는 소문자라서

SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE UPPER(mem_id) = 'C001';
-- 좌변에 UPPER를 써서 대문자로 바꿔버림// 근데 가급적 좌변 가공하지 말랬는디

---------------------------------------------------------------------------------------------
UPDATE 구문 : 
UPDATE 변경시킬 테이블명 또는 뷰의 이름
SET 컬럼명 = 바꿀값
WHERE 행을 제한할 조건
---------------------------------------------------------------------------------------------

(MEMBER테이블에서 신용환의 마일리지를 10000으로 변경)
UPDATE member
SET mem_mileage = 10000
WHERE mem_id = 'c001';
-- 또는 mem_name = '신용환'

(뷰V_MEMBER01에서 신용환의 마일리지를 500으로 변경)
UPDATE V_MEMBER01
SET 마일리지 = 500
WHERE 회원번호 = 'c001';
-- 또는 회원명 = '신용환'
-- 뷰에서 컬럼명 바꿨으면 바뀐 컬럼명대로 써야 할 것

SELECT * FROM V_MEMBER01;
-- 여기에서 신용환 없어짐. 3000이상 마일리지라는 조건에 부합하지 않아서 빠짐

ROLLBACK;


=> WITH CHECK OPTION 사용 VIEW생성

 CREATE OR REPLACE VIEW V_MEMBER01(mid, mname, mjob, mile)
 AS
  SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
  FROM member
  WHERE mem_mileage>=3000
  WITH CHECK OPTION;
-- OR REPLACE 옵션으로 똑같은 이름은 덮어씀 

SELECT * FROM V_MEMBER01;


(뷰V_MEMBER01에서 신용환의 마일리지를 2000으로 변경)
UPDATE V_MEMBER01
SET mile = 2000
WHERE mid = 'c001';
-- ORA-01402: view WITH CHECK OPTION where-clause violation
-- WITH CHECK OPTION : 뷰를 만든 조건에 위배가 되기 때문

(테이블MEMBER에서 신용환의 마일리지를 2000으로 변경)
UPDATE MEMBER
SET mem_mileage = 2000
WHERE mem_id = 'c001';
-- 이거는 된다. 뷰의 존재와 상관없이 원본테이블의 정보는 삭제,삽입,조회,수정 되어야 한다.

SELECT * FROM V_MEMBER01;
-- 여기서 신용환 빠짐. 뷰의 생성조건과 맞지 않으니까



=> WITH READ ONLY 사용 VIEW생성

 CREATE OR REPLACE VIEW V_MEMBER01(mid, mname, mjob, mile)
 AS
  SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
  FROM member
  WHERE mem_mileage >= 3000
  WITH READ ONLY;

rollback;
-- 롤백을 했는데 신용환씨 2000 그대로임
-- 프리빌리지때 디벨로퍼 계정을 나갔다가 들어와서 자동커밋되어서 그럼

SELECT * FROM V_MEMBER01;


(뷰V_MEMBER01에서 오철희의 마일리지를 5700으로 변경)
UPDATE V_MEMBER01
SET mile = 5700
WHERE mname = '오철희';
-- ORA-42399: cannot perform a DML operation on a read-only view
-- WITH READ ONLY 옵션이 되어 조작어 인서트 딜리트 업데이트 제한
-- 셀렉트 문만 가능 (조회만 가능)


=> WITH READ ONLY, WITH CHECK OPTION 동시사용 VIEW생성

 CREATE OR REPLACE VIEW V_MEMBER01(mid, mname, mjob, mile)
 AS
  SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
  FROM member
  WHERE mem_mileage >= 3000
  WITH READ ONLY
  WITH CHECK OPTION;
-- ORA-00933: SQL command not properly ended
-- 둘중에 하나만 써라

---------------------------------------------------------------------------------------------
VIEW의 컬럼명이 부여되는 방식 3가지
1. CREATE문의 컬럼명(컬럼리스트)
2. 별칭(SELECT)
3. 둘 다 없으면 구냥 테이블의 컬럼명 대로

원본은 맘대로 변경가능하나 복사본은 그렇게 못하게 하려면
WITH READ ONLY
================================================================================================
오라클 집에가서 보는 법
1. 메모장에 텍스트로 저장해서 집에 있는 디벨로퍼에 복붙(가장 원시적인 방법)
2. 임포트 익스포트

오라클을 깔면 기본으로 있는 3가지 계정
hr, scott, system
system제외한 두 개는 오라클에서 연습용으로 제공해주는 것
hr 계정이 첨에는 활성화 안되어있으니까 활성화 시켜야 한다.
https://mainia.tistory.com/2663
---------------------------------------------------------------------------------------------

expall dmp파일 d드라이브에 놓고 cmd켜서
Microsoft Windows [Version 10.0.18363.1440]
(c) 2019 Microsoft Corporation. All rights reserved.

C:\Users\PC-06>d:

D:\>imp DOTORI/java file=expall.dmp ignore=y grants=y indexes=y rows=y full=y

Import: Release 11.2.0.2.0 - Production on 목 4월 1 11:39:27 2021

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.


Connected to: Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

Export file created by EXPORT:V11.02.00 via conventional path

Warning: the objects were exported by ORA_USER, not by you

import done in KO16MSWIN949 character set and AL16UTF16 NCHAR character set
import server uses AL32UTF8 character set (possible charset conversion)
. importing ORA_USER's objects into DOTORI
. importing ORA_USER's objects into DOTORI
. . importing table                     "CHANNELS"          5 rows imported
. . importing table                    "COUNTRIES"         23 rows imported
. . importing table                    "CUSTOMERS"      55500 rows imported
. . importing table                  "DEPARTMENTS"         27 rows imported
. . importing table                    "EMPLOYEES"        107 rows imported
. . importing table                  "JOB_HISTORY"         10 rows imported
. . importing table                         "JOBS"         19 rows imported
. . importing table              "KOR_LOAN_STATUS"        238 rows imported
. . importing table                     "PRODUCTS"         72 rows imported
Import terminated successfully without warnings.

D:\>
================================================================================================

hr계정dml departments테이블을 조회하려면
1. 직접hr계정으로 가서
select *
FROM departments
2. SELECT hr.departments.department_id, department_name
    FROM hr.departments;
-- 원래는 계정명 테이블명 컬럼명 이렇게 써야하는데 그동안 생략 했음.
-- SELECT department_id, department_name : 이렇게 hr.departments. 생략해도 된다심

================================================================================================
문제] HR계정의 사원테이블(employees, 오라클에서 제공해주는 테이블임)에서 50번 부서에 속한 사원 중 
    급여가 5000이상인 사원의 사원번호, 사원명, 입사일, 급여를 읽기 전용 뷰로 생성하시오.
    뷰 이름 : v_emp_sal01 , 컬럼명은 원본테이블의 컬럼명을 사용
    뷰가 생성된 후 뷰와 테이블을 이용하여 해당 사원의 사원번호, 사원명, 직무명, 급여를 출력하는 쿼리작성 
-- 뷰 만들고 테이블 두 개와 뷰 1개가 조인 되어야함

    SELECT * FROM employees
    SELECT * FROM departments
    
    SELECT employee_id, emp_name, hire_date, salary
    FROM employees
    WHERE salary > 5000
    AND department_id = 50

 CREATE OR REPLACE VIEW v_emp_sal01
 AS
    SELECT employee_id, emp_name, hire_date, salary
    FROM employees
    WHERE salary > 5000
    AND department_id = 50
 WITH READ ONLY;
 
-- 남의 계정의 테이블을 끌어다가 뷰를 만들 수 없다. 해당 계정에 가서 뷰 만들기

    SELECT * FROM employees
    SELECT * FROM jobs
    
    SELECT * FROM v_emp_sal01
    
    SELECT employee_id, emp_name, hire_date, salary, job_title
    FROM employees e, jobs j
    WHERE e.job_id = j.job_id
        AND salary > 5000
        AND department_id = 50
    
    SELECT e.employee_id 사원번호, e.emp_name 사원명, j.job_title 직무명, v.salary 급여
    FROM employees e, jobs j, v_emp_sal01 v
    WHERE e.job_id = j.job_id
      AND e.employee_id = v.employee_id;
        
-- ORA-00920: invalid relational operator 관계연산자가 부적합하다  
------------------------------------------------------------------------------------------------
--hr계정 끌어와서 synonym??? 그리고 사원명 성과 이름을 || 로 문자열 합치기

================================================================================================
▶ PL/SQL (Procedural Language extension to SQL)
 - SQL을 확장한 절차적 언어(Procedural Language)이다. 
 - 관계형 데이터베이스에서 사용되는 Oracle의 표준 데이터 엑세스 언어로, 
    프로시저 생성자를 SQL과 완벽하게 통합한다.
 - 유저 프로세스가 PL/SQL 블록을 보내면, 
    서버 프로세서는 PL/SQL Engine에서 해당 블록을 받고 SQL과 Procedural를 나눠서 
    SQL은 SQL Statement Executer로 보낸다.
 - PL/SQL 프로그램의 종류는 크게 Procedure, Function, Trigger 로 나뉘어 진다.
 - 오라클에서 지원하는 프로그래밍 언어의 특성을 수용하여 
    SQL에서는 사용할수없는 절차적 프로그래밍 기능을 가지고 있어 SQL의 단점을 보완하였다.


▶ 장점
 - 프로시저 생성자와 SQL의 통합
 - 성능 향상 : 잘 만들어진 PL/SQL 명령문이라는 가정하에 좋아진다.
 - 모듈식 프로그램 개발 가능 : 논리적인 작업 을 진행하는 여러 명령어들을 하나의 블록을 만들 수 있다.
 - 이식성이 좋다
 - 예외 처리 가능

 => 또한 SQL의 다음 단점을 해결 가능하다.
1) 변수가 없다.
2) 한번에 하나의 명령문만 사용 가능하기 떄문에 트래픽이 상대적으로 증가한다.
3) 제어문이 사용 불가. (IF, LOOP)
4) 예외처리가 없다. 등등


▶ 기본 특징
 - 블록 단위의 실행을 제공한다. 이를 위해 BEGIN과 END;를 사용한다. 그리고 마지막 라인에 /를 입력하면 해당 블록이 실행된다.
 - 변수, 상수 등을 선언하여 SQL과 절차형 언어에서 사용
 - 변수의 선언은 DECLARE절에서만 가능하다. 그리고 BEGIN 섹션에서 새 값이 할당될 수 있다.
 - IF문을 사용하여 조건에 따라 문장들을 분기 가능
 - LOOP문을 사용하여 일련의 문장을 반복 가능
 - 커서를 사용하여 여러 행을 검색 및 처리
 - [ PL/SQL에서 사용 가능한 SQL은 Query, DML, TCL이다. ]
   DDL (CREATE, DROP, ALTER, TRUNCATE …), DCL (GRANT, REVOKE) 명령어는 동적 SQL을 이용할 때만 사용 가능하다.
 - [ PL/SQL의 SELECT문은 해당 SELECT의 결과를 PL/SQL Engine으로 보낸다. ]
    이를 캐치하기 위한 변수를 DECLARE해야 하고, INTO절을 꼭 선언하여 넣을 변수를 꼭 표현해주어야하고
    SELECT 문장은 반드시 한 개의 행이 검색되어야 한다.
    그리고 이를 INTO절을 꼭 사용해야한다. 또한 검색되는 행이 없으면 문제가 발생한다.


DECLARE (선언부) PL/SQL에서 사용하는 모든 변수나 상수를 선언하는 부분으로서 DECLARE로 시작
    => 변수/상수/커서 등 을 선언 
    옵션
BEGIN (실행부) 절차적 형식으로 SQL문을 실행할수있도록 절차적 언어의 요소인
    제어문, 반복문, 함수 정의 등 로직을 기술할수있는 부분이며 BEGIN으로 시작
    필수
EXCEPTION (예외 처리부) PL/SQL문이 실행되는 중에 에러가 발생할수있는데 이를 예외 사항이라고 한다.
            이러한 예외 사항이 발생했을때 이를 해결하기 위한 문장을 기술할수있는 부분 
            옵션
END (실행문 종료)	
    필수


▶ PL/SQL Block의 종류
1) 익명 블록 : 이름이 없는 PL/SQL Block을 말한다.
2) 이름 있는 블록 : DB의 객체로 저장되는 블록이 있다.
 - 프로시저 : 리턴 값을 하나 이상 가질 수 있는 프로그램을 말한다.
 - 함수 : 리턴 값을 반드시 반환해야 하는 프로그램을 말한다.
 - 패키지 : 하나 이상의 프로시저, 함수, 변수, 예외 등의 묶음을 말한다.
 - 트리거 : 지정된 이벤트가 발생하면 자동으로 실행되는 PL/SQL 블록이다.


▶ PL/SQL 프로그램의 작성 요령
 - PL/SQL블록 내에서는 한문장이 종료할때마다 세미콜론(;)을 사용하여 한문장이 끝났다는것을 명시
 - END 뒤에 세미콜론( ; )을 사용하여 하나의 블록이 끝났다는 것을 명시
 - 단일행주석은 -- 이고 여러행 주석은 /* */입니다.
 - 쿼리문을 수행하기 위해서 '/'가 반드시 입력되어야 하며, PL/SQL 블록은 행에 '/'가 있으면 종결된것으로 간주.
[참고] 오라클에서 화면 출력을 위해서는 PUT_LINE이란 프로시저를 이용 
 - DBMS_OUTPUT.PUT_LINE(출력할 내용) 같이 사용. 
 - 위 프로시저를 사용하여 출력되는 내용을 화면에 보여주기 위해서는 환경 변수 SERVEROUTPUT(디폴트값이 OFF이므로) ON으로 변경.
    - SET serveroutput ON
-- 메시지 출력하기 예시
SET serveroutput ON
BEGIN 
    dbms_output.put_line('God Dman!!');
END;
결과 - God Damn!!


▶ 변수 선언
 - 블록내에서 변수를 사용하려면 선언부(DECLARE)에서 선언해야하며 변수명 다음에 데이터 타입을 기술해야 한다.
 - 문법
identifier [CONSTANT] datatype [NOT NULL] 
[:=|DEFAULT expression];

identifier       변수명(식별자)
CONSTANT    상수로 지정 (초기치를 반드시 할당해야함)
datatype       자료형을 기술
NOT NULL     값을 반드시 포함
expression     Literal, 다른 변수, 연산자나 함수를 포함하는 표현식
 
 - 문법으로만 보면 이해가 어렵다..
    * 예시) DECLARE 변수이름 데이터타입;
    	ex) DECLARE NAME VARCHAR2(10);

      DECLARE 변수이름 데이터타입 :=값;
        ex) DECLARE NAME VARCHAR2(10) := '갓댐';

      DECLARE 변수이름 데이터타입 DEFAULT 기본값;
    	ex) DECLARE NAME VARCHAR2(10) DEFAULT '갓대미';

* 변수를 한번에 여러개 선언방법
   DECLARE 
	NAME    VARCHAR2(20);
	AGE      NUMBER(2); 
	GENDER VARCHAR(50)   DEFAULT '남';

* 변수선언하여 사용방법
	ex)
	DECLARE NAME VARCHAR2(20) := '이효리';
	BEGIN
		DBMS_OUTPUT.put_Line('이효리'|| NAME); -- 출력
	END;

* 변수 Type을 선언할때 꼭 명시적으로 작성하지 않고 사용하는 방법도 있다.

1. %ROWTYPE
 - 해당 테이블이나 뷰의 컬럼 속성을 그대로 들고 오는 형태이다. 
 - 사용방법 : 변수명 테이블이름%ROWTYPE
ex)
DECLARE 
	DATA EMP%ROWTYPE;
BEGIN
	SELECT 	* INTO DATA 
	FROM 	EMP 
	WHERE 	EMPNO = '1234';
	DBMS_OUTPUT.PUT_LINE(DATA.ENAME ||','||DATA.DEPTNO);
END;

2. %TYPE
 - 해당 테이블의 컬럼 속성을 지정하여 그대로 들고 오는 형태이다.
 - 사용방법 : 변수명 테이블이름.컬럼명%TYPE
ex)
DECLARE 
	V_ENAME  EMP.ENAME%TYPE;
	V_DEPTNO EMP.DEPTNO%TYPE;
BEGIN
	SELECT 	ENAME, DEPTNO INTO V_ENAME, V_DEPTNO
	FROM 	EMP 
	WHERE 	EMPNO = '1234';
	DBMS_OUTPUT.PUT_LINE(V_ENAME ||','||V_DEPTNO);
END;


▶ 변수 대입 방법
* 명시적인 값 대입
 - 변수값을 저장하기 위해서는 := 를 사용한다.
 - := 의 좌측에는 변수를 , 우측에는 값을 기술
   identifier := expression;

* SELECT 문을 이용하여 값 대입
 - 기존 SELECT 문과는 다르게 INTO절이 추가 된다.
   INTO절에는 조회 결과 값을 저장할 변수를 기술. select 문은 INTO절에 의해 하나의 행만을 저장 가능
 - 문법
SELECT 	select_list
INTO 	{variable_name1[,variable_name2,..]|record_name}
FROM 	table_name
WHERE 	condition;

※ SELECT 다음에 기술한 컬럼은 INTO 절에 있는 변수와 1:1로 대응해야하기 때문에 
    개수와 데이터 타입, 길이를 일치시켜야함

출처: https://goddaehee.tistory.com/99 [갓대희의 작은공간]

================================================================================================

커서 (CURSOR)
[정의]
 - SQL 커서는 Oracle 서버에서 할당한 전용 메모리 영역에 대한 포인터이다.
 - 질의의 결과로 얻어진 여러 행이 저장된 메모리상의 위치.
 - 커서는 SELECT 문의 결과 집합을 처리하는데 사용된다.

[종류]
1) 암시적 커서 (Implicit Cursor)
1.1) 정의
 - 오라클 DB에서 실행되는 모든 SQL문장은 암시적인 커서가 생성되며, 커서 속성을 사용 할 수 있다.
 - 모든 DML과 PL/SQL SELECT문에 대해 선언됨
 - 암시적인 커서는 오라클이나 PL/SQL실행 메커니즘에 의해 처리되는 SQL문장이 처리되는 곳에 대한 익명의 주소이다.
 - Oracle 서버에서 SQL문을 처리하기 위해 내부적으로 생성하고 관리한다.
 - 암시적 커서는 SQL 문이 실행되는 순간 자동으로 OPEN과 CLOSE를 실행 한다.
 - SQL 커서 속성을 사용하면 SQL문의 결과를 테스트할 수 있다.
1.2) 암시적 커서 속성
 - SQL%FOUND     : 해당 SQL문에 의해 반환된 총 행수가 1개 이상일 경우TRUE (BOOLEAN)
 - SQL%NOTFOUND : 해당 SQL문에 의해 반환된 총 행수가 없을 경우 TRUE (BOOLEAN)
 - SQL%ISOPEN     : 항상 FALSE, 암시적 커서가 열려 있는지의 여부 검색( PL/SQL은 실행 후 바로 묵시적 커서를 닫기 때문에 항상 상 false)
 - SQL%ROWCOUNT : 해당 SQL문에 의해 반환된 총 행수, 가장 최근 수행된 SQL문에 의해 영향을 받은 행의 갯수(정수)

[사용 예제]
EX) 
SET SERVEROUTPUT ON;
DECLARE
    BEGIN
    DELETE FROM emp WHERE DEPTNO = 10;
    DBMS_OUTPUT.PUT_LINE('처리 건수 : ' || TO_CHAR(SQL%ROWCOUNT)|| '건');
    END;
-- 결과 
처리 건수 : 21건
PL/SQL 처리가 정상적으로 완료되었습니다.


2) 명시적 커서 (Explicit Cursor)
2.1) 정의
 - 프로그래머에 의해 선언되며 이름 있는 커서.
2.2) 명시적 커서 속성
   - %ROWCOUNT : 현재까지 반환된 모든 행의 수를 출력
   - %FOUND : FETCH한 데이터가 행을 반환하면 TRUE
   - %NOTFOUND : FETCH한 데이터가 행을 반환하지 않으면 TRUE (LOOP를 종료할 시점을 찾는다)
   - %ISOPEN : 커서가 OPEN되어있으면 TRUE
2.3) 문법
 - DECLARE를 통해서 명명된 SQL 영역을 생성
 - OPEN을 이용하여 결과 행 집합을 식별
 - FETCH를 통해서 현재 행을 변수에 로드 (이를 현재 행이 없을 때까지 수행할 수 있다)
 - CLOSE를 통해서 결과 행 집합을 해제

DECLARE
	CURSOR [커서이름] IS [SELECT 구문];
BEGIN
	OPEN [커서이름];
	FETCH [커서이름] INTO [로컬변수];
	CLOSE [커서이름];
END;

OPEN(커서열기)
 - OPEN문을 사용하여 커서를 연다.
 - 커서안의 검색이 실행되며 아무런 데이터행을 추출하지 못해도 에러가 발생하지 않는다
FETCH(커서패치)
 - 현재 데이터 행을 OUTPUT변수에 반환한다
 - 커서의 SELECT문의 컬럼의 수와 OUTPUT변수의 수가 동일해야 한다 
 - 커서 컬럼의 변수타입과 OUTPUT변수의 데이터 타입도 역시 동일해야 한다
 - 커서는 한 라인씩 데이터를 FETCH한다
 - 문법 : FETCH cursor_name INTO variable1, variable2;
CLOSE(커서닫기)
 - 사용을 마친 커서는 반드시 닫아주어야 한다
 - 필요시 커서를 다시 열 수 있다
 - 커서를 닫은 상태에서 FETCH는 불가능하다
 - 문법 : CLOSE cursor_name;

[사용 예제]
EX) 커서 사용 예제1
SET SERVEROUTPUT ON;
DECLARE
    CURSOR emp_cur -- 커서정의
    IS
    SELECT * FROM emp WHERE DEPTNO = 10;
    emp_rec emp%ROWTYPE; -- 변수정의
BEGIN
    OPEN emp_cur;
    LOOP -- 반복
    FETCH emp_cur INTO emp_rec; -- 하나씩 변수에 넣기
    EXIT  WHEN emp_cur%NOTFOUND; -- 더이상 없으면 끝내기
        DMBS_OUTPUT.PUT_LINE(emp_rec.empno || ' ' || emp_rec.name); -- 출력
    END LOOP;
    CLOSE emp_cur;
END;

EX) 커서 사용 예제2
SET SERVEROUTPUT ON;
DECLARE
    ID_LIST SYS_REFCURSOR; -- 커서정의
    I_ID VARCHAR2(100); -- 변수정의
BEGIN
    OPEN ID_LIST;
    FOR
        SELECT USER_ID FROM MY_USER WHERE 조건;
    LOOP -- 반복
    FETCH ID_LIST INTO I_ID; -- 하나씩 변수에 넣기
    EXIT  WHEN ID_LIST%NOTFOUND; -- 더이상 없으면 끝내기
        DMBS_OUTPUT.PUT_LINE(I_ID); -- 출력
    END LOOP;
    CLOSE ID_LIST;
END;

EX) 커서 사용 예제3
SET SERVEROUTPUT ON;
DECLARE
    CURSOR ID_LIST IS
    SELECT 'GOD' AS USER_ID FROM DUAL;
BEGIN
    FOR TEST_CURSOR IN ID_LIST
    LOOP
        DBMS_OUTPUT.putline(TEST_CURSOR.USER_ID);
    END LOOP;
END;


[명시적 커서 FOR LOOP]
가장 내가 많이 사용하는 방법이다.
서브쿼리를 활용하여 CURSUR FOR LOOP를 사용하면 CURSOR를 선언할 필요도 없어진다.
난 거의 이방법 밖에 안쓰고, 다른방법은 사실 사용하는 법도 잊어 버렸다.

명시적 커서 FOR LOOP를 사용하면 
FOR LOOP가 자동적으로 커서를 OPEN해주며, 행이 없을 때까지 FETCH해주고, CLOSE해준다.
또한 ROWTYPE에 해당하는 변수를 따로 DECLARE할 필요가 없다. 
이는 암시적으로 선언되기 때문이다.
물론, 이 암시적 카운터는 FOR LOOP안에서만 사용할 수 있다.
그리고 이 커서의 데이터 타입(컬럼 데이터 타입의 집합)도 %ROWTYPE 앞으로 이용할 수 있다.

EX) 예제3을 "명시적 커서 FOR LOOP" 방식으로 변경 해보았다.
SET SERVEROUTPUT ON;
DECLARE
BEGIN
    FOR ID_LIST IN 
    (
        SELECT 'GOD' AS USER_ID FROM DUAL
    )
    LOOP
    DBMS_OUTPUT.putline(ID_LIST.USER_ID);
END LOOP;
END;

※ CURSOR FOR LOOP은 내부적으로 처리되는 데이터의 양, I/O 측면에서 훨씬 효율적이기 때문에,
    가급적 이를 사용하는 것이 좋다.

출처: https://goddaehee.tistory.com/117 [갓대희의 작은공간]

================================================================================================

-- 이제 조인을 안 쓰고 커서(cursur?) SQL명령에 의해서 영향받은 행들의 집합
-- 셀렉트 문의 커서는 커서와 뷰가 같아야 한다.
익명커서
명시적커서 - 오픈시키고 나서 행하나하나 꺼내서 읽을 수 있다. - 읽어오는 걸 패치(fetch)라고 한다.
    패치사이클???

================================================================================================    
패치사이클이라는 말은 PC (프로그램카운터) 구조와 연관 된 것 같다
    
CPU는 내부적으로 다음 것들로 구성되어 있습니다.
ALU : 연산장치
CU : 제어장치
Register : 임시기억 장치
Cache : 캐시메모리

CPU의 동작은 간단하게 4단계로 나누어 집니다.
1.처리해야 할 데이터를 주기억 장치로 부터 읽어와 레지스터에 저장한다.
2. 제어장치는 명령어를 ALU로 전달한다.
3. ALU는 전달된 읽어와서 레지스터에 저장한 데이터에 명령어를 실행하고 그 결과를 다른 레지스터에 저장한다.
4. 결과값을 다시 주기억 장치로 보내어 주기억 장치에 저장한다.

​CPU의 레지스터에는 종류가 여러개 있는데 
그중에는 일반적인 범용 레지스터(General Register)와 
특수 레지스터(Program Counter, Instruction Register등등)이 있습니다.
​특히 PC와 IR은 제어장치에 존재합니다.
​프로그램 카운터 (PC)  는 다음에 실행할 명령어의 주소를 저장하고 있습니다.

프로그램의 실행 구조(Fetch Execute Cycle)는 다음과 같습니다.
1. 다음에 실행할 명령어를 주기억 장치로 부터 읽어들인다. (Fetch)
2. 명령어를 디코드(해석) 한다. (Decode)
3. 피연산자 Operand를 주기억 장치로 부터 읽어온다. (Operand)
4. 명령어를 실행한다. (Execute)

1번 과정을 자세히 설명하자면 다음과 같다. 
다음에 실행할 명령어의 주소는 프로그램 카운터(PC)에 저장이 되어있다. 
따라서 PC에 저장되어 있는 주소로 가서 명령어를 읽어들여 명령어 레지스터(IR)에 저장한다. 
그리고 프로그램 카운터(PC)의 값을 증가시킨다.

2번 과정은 0과 1로 이루어진 명령어를 해석하는 과정으로 디코딩을 한다. 
디코딩은 인코딩하기 전으로 정보를 되돌리는 과정으로 
위의 과정에서는 3비트로 이루어진 2진코드를 2의 n승개의 정보로 바꿔주는 논리회로이다. 
이는 다수의 입력신호로 하나의 출력값을 얻으므로 일종의 멀티플렉서라고도 할 수 있겠다. 
이 과정을 통해 제어장치가 무슨 명령어를 해야할지 결정하게 된다. 
이때 각 기계 마다 Instruction set이 다르므로 
컴퓨터는 오직 그 장치의 언어로 표현된 명령어만 실행이 가능하다.

================================================================================================    
create synonym departments for hr.departments;
-- 동의어 쓰는 쿼리

동의어란 다음 용도로 사용되는 데이터베이스 개체입니다.
- 로컬 서버나 원격 서버에 있을 수 있는 기본 개체로 참조되는 다른 데이터베이스 개체의 대체 이름을 제공합니다.
- 기본 개체의 이름이나 위치의 변경으로부터 클라이언트 애플리케이션을 보호하는 추상적 계층을 제공합니다.

데이터베이스 객체에 대한 소유권은 해당 객체를 생성한 사용자가 가진다. 
따라서 다른 사용자가 소유한 객체에 접근하기 위해서는 소유자로부터 접근권한을 부여 받아야 한다.
그리고 다른 사용자가 소유한 객체를 조회할 때에는 소유자의 ID를 객체 이름 앞에 지정해야 한다.
예를 들어, emp 테이블의 소유자가 scott이고, 
어떤 사용자가 scott로부터 접근권한을 부여 받아 emp 테이블을 조회하려면 
scott.emp와 같이 소유자 ID를 테이블 이름 앞에 지정해야 한다.
하지만 객체를 조회할 때마다 객체의 소유자를 일일이 지정하는 방법은 매우 번거로운 일이다.
시노님은 하나의 객체에 대해 다른 이름을 정의하는 방법이다.

예를 들어, scott 소유의 scott.emp 테이블에 대해 arirnag이라는 동의어를 정의할 경우, 
질의어에서 scott.emp라는 긴 이름 대신에 arirang라는 간단한 이름으로 scott.emp 테이블을 조회할 수 있다.
동의어는 SQL 문에서 사용하는 테이블이나 컬럼의 별명과 유사한 개념이다. 
하지만 별명은 해당 SQL 문 내에서만 사용할 수 있지만, 시노님은 데이터베이스 전체에서 사용할 수 있는 객체이다.

시노님의 종류
• private 시노님(개인 시노님)는 특정 schema에서 생성되고 단지 그것을 갖는 schema에 의해 접근할 수 있다.
• public 시노님(공용 시노님)는 PUBLIC schema에 의해 소유되며 데이터베이스 내의 모든 schema는 그것을 참조한다.

    종류	        소유      	접근
private 시노님	owner	owner가 접근 제한
public 시노님	public schema	모든 사용자

시노님의 생성
시노님 생성도 다른 객체 생성과 마찬가지로 create 문을 사용하여 만든다.
【형식】
	CREATE [PUBLIC] SYNONYM [schema.]synonym명
  	FOR [schema.]object명;
• 디폴트는 private 시노님이다.
• PUBLIC 시노님은 모든 사용자가 접근 가능한 시노님을 생성한다.
• PUBLIC 시노님은 모든 사용자가 접근 가능하기 때문에 생성 및 삭제는 오직 DBA만이 할 수 있다.
그러므로 public 시노님의 생성은 다음과 같은 단계를 통해서만 생성할 수 있다.

PUBLIC 시노님의 생성 순서
1) SYSTEM 권한으로 접속한다.
2) PUBLIC 옵션을 사용하여 시노님을 생성한다.
3) 생성된 시노님에 대해 객체 소유자로 접속한다.
4) 시노님에 권한을 부여한다.

시노님의 삭제
• private 시노님은 생성자 스스로 삭제할 수 있다.
• public 시노님은 DBA만이 삭제할 수 있다.(public 시노님 생성과 삭제는 DBA만 가능)
【형식】
	DROP [PUBLIC] SYNONYM synonym명;

시노님 정보조회
all_synonyms	모든 시노님 정보   SQL> select count(*) from all_synonyms;
user_synonyms	사용자가 만든 시노님 정보  SQL> select * from user_synonyms;