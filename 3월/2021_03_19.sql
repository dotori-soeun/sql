실습 -3 : 그룹바이&조건분기 사진

실습 4 : 사진
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_YYYYMM, COUNT(*cnt)
FROM emp 
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');
--핵심이 emp 테이블에 없는 정보를 갖고 가공해야한다.

실습 5 : 사진
SELECT TO_CHAR(hiredate, 'YYYY') hire_YYYY, COUNT(*cnt)
FROM emp 
GROUP BY TO_CHAR(hiredate, 'YYYY');

실습 6 : 
회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리작성(dept테이블)
SELECT COUNT(*)
FROM dept;

실습 7 :
직원이 속한 부서의 개수를 조회(emp테이블)
--코드의 변화 없이 데이터가 바뀌어도 올바른 답이 나올 수 있도록
--어떻게 CNT 3 이 나올 수 있는 거지???? --> 인라인뷰를 활용
SELECT COUNT(*) CNT
FROM(SELECT deptno
    FROM emp
    GROUP BY deptno);
    
===============================================================================
데이터를 확장(결합)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION(합집합), MINUS(차집합), INTERSECT(교집합))

JOIN -- 3번째 난관
-- 나중에 쿼리를 짜게 되면 JOIN이 없는 쿼리는 거의 없다. 엄청 중요!
-- 이젠 FROM절에 테이블을 한 개 쓰는 게 아님. 분산된 데이터
-- 왜 분산을 시켰을까 : 하나의 테이블에 데이터가 있으면 중복되는 데이터가 있을 수 있다. 
 - RDBMS 중복을 최소화 하는 형태의 데이터 베이스
 - 다른 테이블과 결합하여 데이터를 조회
 
JOIN의 형태 두가지
1. 표준SQL => ANSI SQL -- ANSI는 그냥 단체 이름
2. 비표준SQL - DBMS를 만드는 회사에서 만든 고유의 SQL문법

-- 컴퓨터 상식 : ECMA - 자바스크립트 언어의 표준을 정해놓은 단체
 
 - 중복을 최소화 하는 RDBMS방식으로 설계한 경우
 - emp테이블에는 부서코드만 존재, 부서정보를 담은 dept테이블 별도로 생성
 - emp테이블과 dept테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다
 
ANSI : SQL - 조인방법 세부적으로 나뉘어져 있음
ORACLE : SQL - 조인방법 하나

    
ANSL - NATURAL JOIN
    . 조인하고자 하는 테이블의 연결 컬럼명(타입도 동일)이 동일한 경우(emp.deptno, dept.deptno)
    . 연결 컬럼의 값이 동일할 때 (=) 컬럼이 확장된다.
 
SELECT *
FROM emp NATURAL JOIN dept;

SELECT ename, dname
FROM emp NATURAL JOIN dept;

한정자
SELECT emp.empno, emp.ename, deptno
FROM emp NATURAL JOIN dept;
 -- dept no 한정자를 쓰지 않음 NATURAL JOIN에서는 그럼
 
ORACLE join :
1. FROM절에 조인할 테이블을 (,)콤마로 구분하여 나열
2. WHERE 조인할 테이블의 연결 조건을 기술
    -- WHERE 행에대한 제한 , 두테이블에 대한 연결조건
SELECT *
FROM emp, dept
WHERE deptno = deptno;
-- 여기에선 에러가 남 
-- column ambiguously defined : 컬럼이 애매하게 정의가 되어있다.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- 그래서 이렇게 하면 조회 잘 됨 . 오라클 조인은 다 저런식. 한정자 써서
-- 위의 조인과 차이는 컬럼 순서가 좀 바뀌고 부서번호가 두 번 등장함

7369 SMITH, 7902 FORD -- 상사 사번만 알고 이름을 몰라서 알고 싶을때 
SELECT *
FROM emp, emp
WHERE emp.mgr = emp.empno;
-- 또 오류가 남. 이럴때는 테이블 별칭을 써야 한다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno; 
-- KING은 조인에 실패. 위의 매니저가 NULL값이라
 
 
===============================================================================
 
ANSI SQL : JOIN WITH USING -- 내추럴조인과 비슷하나 잘 안쓰는 방법 중 하나
조인 하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두 개 이상인 상황에서
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용한다.

SELECT *
FROM emp JOIN dept USING(deptno);
-- 위에서 내추럴 조인 했던 겄과 결과 동일
SELECT emp.deptno
FROM emp JOIN dept USING(deptno);
-- 얘도 한정자 쓰면 오류남
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- 오라클 조인으로 변경하는 거는 내추럴 조인때랑 똑같음


-- 위에서 배운 안시 조인들을 커버할 수 있는 녀석
JOIN WITH ON : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
조인컬럼 조건을 개발자가 임의로 지정 -- 컬럼 명이 같이 않아도 된다.

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);
-- 오라클 문법으로 하는건 위에랑 다 똑같음. ON절에 기술한 거를 오라클에서는 WHERE절에 기술한다.

사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 :  JOIN WITH ON 을 이용하여 쿼리 작성
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름 :  JOIN WITH ON 을 이용하여 쿼리 작성
단 사원의 번호가 7369에서 7698인 사원들만 조회 -- 조건이 생기면 WHERE절에 기술
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;    
--오라클로 바꾸면
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno
    AND e.empno BETWEEN 7369 AND 7698; 
    
실행계획
조인을 하면 읽어야할 테이블이 두 개 이상이 될 수 있어서
컴퓨터는 한번에 하나를 빠르게 하니까
먼저 기술했다고 해서 그걸 먼저 읽지 않는다. 경험이 많이 없는 사람은 예측이 거의 불가(자바랑 차이점임)

OPTIMIZER 최적화기
옛날거 : RULL BASE OPTIMIZER(1~15)
요즘거 : COST BASE OPTIMIZER

더닝 크루거 이펙트 


논리적인 조인 형태
1. SELF JOIN : 조인 테이블이 같은 경우
    - 계층구조(직원의 상사와 또 그 상사의 상사 이런거)
2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인  -- 이걸 잘 이해하는게 중요하다
    -- 당연히 이퀄조인보단 덜쓰이지만 쓰이긴 쓰인다.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- 이건 이퀄(=) 조건
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;
 -- 예를 들면 이런거 , 이럴경우 조인 여러번// 이거 시험에 나온딩~~

=================================================================================== 

SELECT *
FROM salgrade;
-- salcrade를 이용하여 직원이 급여 등급 구하기 --> 이런거 연습할 때 엑셀에 데이터 붙여놓고 생각을 좀 해보면 쉽다고 하심
-- empno, ename, sal, 급여등급// 나 이거 풀어냈음! 잇힝~><
-- ansi, oracl 두 문법 다 도전해보세요!
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;
--오라클 문법
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal; 
--안시 내추럴 조인

--emp.sal >= salgrade.losal
--AND
--emp.sal <= salgrade.hisal

실습 조인0 : 사진
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

SELECT empno, ename, deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- 오라클에서 일케 하면 에러임! 차라리 deptno를 빼면 조회는 됨!!
-- 내추럴 조인은 될 수 도?? 실험해보까???
SELECT empno, ename, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- 나머지는 근본이 명확하니까 한정자 안 붙여도 답이 나오긴함


실습 조인 1 : 사진
-- 행을 제한한다. 조건절에 추가임
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND d.deptno in (10, 30);


실습 조인 2 : 
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.sal>2500
ORDER BY d.deptno;    


실습 조인 3
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND sal > 2500
    AND empno > 7600
ORDER BY d.deptno;  


실습 조인 4 한 번 더 다시 풀어보기!
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND sal > 2500
    AND empno > 7600
    AND dname = 'RESEARCH'
ORDER BY d.deptno;  
-- d.deptno = 20으로 하든가


===========================================================================================
-- 리눅스 : 윈도우 같은 OS이름
-- 윈도우에 리눅스를 프로그램처럼 설치하고 그 위에 오라클을 설치
    --이 방식의 단점은 윈도우에 직접 오라클을 설치했을 때보다 느리다.
    --하지만 언제든지 빠르게 설치 삭제 할 수 있다.

가상화가 도입 된 이유
    - 물리적인 컴퓨터는 동시에 하나의 OS만 실행 가능
    - 성능이 좋은 컴퓨터(서버)라도 하드웨어 자원의 활용이 낮음 :  15~20%
    - 서비스를 위해서는 여러개의 서버가 필요
        .서버(하드웨어)는 비싸다
    - 구매해도 설치 및 물리적인 장소가 필요

가상화를 통한 활용도 향상
    -> 통장 쪼개기 처럼 성능 좋은 서버를 논리적으로 잘게 나눈다.
    -> 하나의 OS에 여러개의 OS를 설치할 수 있는 방법 => 가상화
    : 하드웨어 자원의 활용율을 70~80%까지 높일 수 있다.
    
Virtual Box : 다른 OS를 설치할 수 있도록 도와주는 오라클에서 만든 무료프로그램.
    -- 가끔 안되는 피시가 있을 수 있다.-> 윈도우보안프로그램 또는 다른 프로그램과 충돌    
설치하면서 계속 yesyes하면 됨

오라클VM을 확장에 추가

오라클 디벨로퍼데이 오라클 리눅스가설치되어있고 그 위에 오라클이 설치되어있음. 파일은 조금 큼

파일에서 가져오기 하고 디벨로퍼데이 가져오기

서버는 눈에 안보이는 상태로 쓰기때문에
최대화 하지 말아라. 창 크기 조절하지 말아라. 절대절대!!!

안되면 최신버전으로 업데이트해보라. 기존거 있어도 덮어쓰니까.

아이디 oracle 비번 oracle

윈도우 추가 가능 [머신] -> [새로만들기] -> [종류] 이렇게

========================================================================================
또는 Docker 
게스트 OS가 없이 빠르게해준다.
도커를 쓰면 오퍼레이팅 시스템이 리눅스, 도커는 윈도우 추가기능을 포기함 - 근데 큰 문제가 되지는 않음
    --도커 허브(hub.docker.com) : 가져다 쓰기만 하면됨/ 도커에서 실행 가능한 이미지를 올려놓은 사이트

도커 쓸라면 시몬스??? 바이오스?? 뭔가 설정이 있어야 한다.

=======================================================================================
exerd 인스톨러 : 유사 이클립스 

