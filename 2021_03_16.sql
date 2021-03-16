--<1교시>
연산자 우선순위 : 일반수학과  마찬가지로 괄호()를 통해 우선순위를 변경할 수 있다.
1. 산술연산자
2. 문자열결합
3. 비교연산
4. IS, [NOT] NULL,LIKE, [NOT] IN
5. [NOT] BETWEEN
6. NOT
7. AND
8. OR
--AND가 OR보다 우선순위가 높다. : 헷갈리면 ()를 사용하여 우선순위를 조정하자
--보통 AND, OR이 같이 나오는 경우는 없음

SELECT *
FROM emp
WHERE ename = 'SMITH' OR ename = 'ALLEN' AND job = 'SALESMAN'
--> ename = 'SMITH' OR ename = ('ALLEN' AND job = 'SALESMAN')
--> 직원의 이름이 ALLEN 이면서 job이 SALESMAN 이거나, 직원의 이름이 SMITH인 직원정보를 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN'
--> 직원이름이 ALLEN 이거나 SMITH 이면서 job이 SALESMAN인 직원을 조회 

emp테이블에서
1. job이 SALESMAN이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate >= TO_DATE('1981-06-01','YYYY-MM-DD');
-->'78%' : 문자열로 인식을 시키는 거니까 '' 꼭 해줘야한다
-->우선순위때문에 AND쪽에 괄호를 포함하던 안하던 결과는 똑같다
===============================================================
--<2교시>
* 데이터 정렬 : TABLE 객체에는 데이터를 저장/조회시 '순서를 보장하지 않음'
    - 보편적으로 데이터가 입력된 순서대로 조회됨
    - 데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다
    - 데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음
 -- 블록 : DBMS에서 조회, 저장의 기본이 되는 단위. 보통 8kb    
 -- DBMS와 RDBMS는 거의 동의어 -> RDBMS는 집합에서 따옴 -> 집합에는 순서가 없다
 -- 우리나라 개발자 커뮤니티 okky.kr 예전에 okjsp -> jsp(java server page)

*데이터정렬 (ORDER BY)
* ORDER BY
    - ASC : 오름차순 (기본)
    - DESC : 내림차순

데이터 정렬이 필요한 이유는?
1. table 객체는 순서를 보장하지 않는다
    -> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다.
2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다
    -> 게시판의 게시글은 보편적으로 가장 최신글이 처음에 나오고, 가장 오래된 글이 맨 밑에 있다.
    
SQL 에서 정렬 : ORDER BY : SELECT-> FROM -> [WHERE] -> ORDER BY -->WHERE절은 있을 수도 있고 없을 수도 있다.
정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 별칭 [정렬순서]
정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)

SELECT *
FROM emp
ORDER BY ename;

1->2->....->100 : 오름차순 ( ASC => DEFAULT )
100->99....->1  : 내림차순 ( DESC => 명시해야함 )

SELECT *
FROM emp
ORDER BY ename DESC;

정렬을 하다보면 한가지 기준으로만 정렬하지 않을 수도 있다.
--1차 : job으로 정렬
SELECT *
FROM emp
ORDER BY job;
--2차 : job으로 정렬 후 급여로 재정렬 (job이 같다면 그 데이터 들을 sal순으로 재정렬)
SELECT *
FROM emp
ORDER BY job, sal;
--3차 : 각각 개별적으로 정렬 기준을 줄 수 있다
SELECT *
FROM emp
ORDER BY job DESC, sal ASC;

정렬 :  컬럼명이 아니라 select 절의 컬럼 순서(index)
-->컬럼의 순서는 왼쪽부터 첫번째, 두번재....
-->쌤은 이걸 추천하지 않음. 수정하면 또 변경되고 원하는 결과가 안 나올 수 있기 때문에
-->그냥 알아들으라고 알려주심
SELECT ename, empno, job, mgr
FROM emp
ORDER BY 2;
-->두번째 컬럼 기준으로 정렬한다는 쿼리
SELECT ename, empno, job, mgr AS m
FROM emp
ORDER BY m;
-->ALIAS를 썼을 때는 ALIAS 명칭으로 정렬하는 것도 가능


dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM dept;

SELECT *
FROM dept
ORDER BY deptno;

dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM dept
ORDER BY loc DESC;
===============================================================
--<3교시>
emp테이블에서 상여(comm)정보가 있는 사람들만 조회하고,
상여(comm)를 많이 받는 사람이 먼저 조회되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요
(상여가 0인 사람은 상여가 없는 것으로 간주)
SELECT *
FROM emp
WHERE comm > 0 
ORDER BY comm DESC , empno DESC;
--> 마지막 조건까지 잘 확인하자! 문제에 답이 있다
SELECT *
FROM emp
WHERE comm IS NOT NULL
  AND comm != 0
ORDER BY comm DESC , empno DESC;

emp테이블에서 관리자가 있는 사람들만 조회하고,
직군(job)순으로 오름차순 정렬하고,
직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE mgr IS NOT NULL --> != NULL 이런거 안댐
ORDER BY job ASC, empno DESC;

emp테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람 중
--> deptno = 10 OR deptno = 30
--> deptnp IN (10,30) : ''필요없음
급여(sal)가 1500이 넘는 사람들만 조회하고 
이름으로 내림차순 정렬되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE deptno IN (10,30)
  AND sal>1500 --> 조건을 추가할 때는 ,이 아니라 [AND 줄바꿈]!! 
ORDER BY ename DESC;


--정렬을 실무에서 쓰는 경우
페이징 처리 : 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을 때
            원하는 페이지의 데이터만 가져오는 방법
(1. 400건을 다 조회하고 필요한 20건만 사용하는 방법 --> 전체조회(400)
 2. 400건의 데이터 중 원하는 페이지의 20건만 조회 --> 페이징 처리(20)
페이징 처리(게시글) ==> 정렬 기준이 무엇인가 [정렬의 기준]
                    (일반적으로는 게시글의 작성일시 역순)
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈

--백그라운드 지식 <ROWNUM, 인라인뷰, ALIAS>
ROWNUM : 행번호를 부여하는 특수키워드(오라클에서만 제공) 
    -->ROWNUMBER의 약자. 가상컬럼. 오라클에서만 제공
  SELECT ROWNUM, empno,ename
  FROM emp;
    * 제약사항
        ROWNUM은 WHERE 절에서도 사용가능하다 --1부터 있는 형태로만
         단 ROWNUM의 사용을 1부터 사용하는 경우에만 사용가능
         WHERE ROWNUM BETWEEN 1 AND 5 ==> 가능
         WHERE ROWNUM BETWEEN 6 AND 10 ==> 불가능
         WHERE ROWNUM = 1; ==> 가능 
         WHERE ROWNUM = 2; ==> 불가능
         WHERE ROWNUM < [=] 10; ==> 가능 -- WHERE ROWNUM < 10;
         WHERE ROWNUM > [=] 10; ==> 불가능
전체 데이터 : 14건
페이지 사이즈 : 5건
1번째 페이지 : 1~5
  SELECT ROWNUM, empno,ename
  FROM emp
  WHERE ROWNUM BETWEEN 1 AND 5;
2번째 페이지 : 6~10
  SELECT ROWNUM, empno,ename
  FROM emp
  WHERE ROWNUM BETWEEN 6 AND 10; --> 불가
3번째 페이지 : 11~15(14)
  SELECT ROWNUM, empno,ename
  FROM emp
  WHERE ROWNUM BETWEEN 11 AND 15; --> 불가
  --> 불가하긴해도 설명 : 실제데이터 14까지밖에없지만 쿼리는 저렇게 짜는게 맞음!
  
SQL 절은 다음의 순서로 실행된다
 FROM => WHERE => SELECT => ORDER BY
 ORDER BY와 ROWNUM을 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않는다
 (SELECT 절이 먼저 실행되므로 ROWNUM이 부여된 상태에서 ORDER BY 절에 의해 정렬된다
  
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;
--> ROWNUM 이 정렬하면서 꼬인것처럼 보임 : 여기서는 ROWNUM 부여하고 그담에 정렬한 거기 때문에 
--> 정렬된 기준으로 페이징 처리를 해야하는데... 어떡하지 => 그래서 필요한게 인라인뷰!
    --SQL실행순서 : FROM => SELECT => ORDERBY


인라인뷰와 ALIAS
(SELECT empno, ename
FROM emp); --> 문자가 긴 테이블처럼 인식하게 할 수 있다

SELECT *
FROM (SELECT empno, ename
      FROM emp); --> 문자가 긴 테이블처럼 인식하게 할 수 있다
      
SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename);
--> 정렬이 된 상태에서 ROWNUM이 부여될 수 있도록     

SELECT *
FROM (SELECT ROWNUM, empno, ename
      FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename));
--> 6번부터 10번을 조회하기 위해 또 한 번 감쌈

SELECT *
FROM (SELECT ROWNUM rn, empno, ename  
      FROM (SELECT empno, ename         
            FROM emp
            ORDER BY ename))
WHERE rm BETWEEN 6 AND 10;
-->ROWNUM에 ALIAS부여 : 더이상 ROWNUM이 아니라 컬럼명으로 인식하게 하기위함
-->ROWNUM으로 쓰면 1번부터해야하니까

--SELECT ename
--FROM (SELECT empno, ename
--      FROM emp); --> 나중에 배울 '뷰'는 이런 셀렉트 쿼리~
===============================================================
--<4교시>
pageSize : 5건
1. page : rn BETWEEN 1 AND 5;
2. page : rn BETWEEN 6 AND 10;
3. page : rn BETWEEN 11 AND 15;
n. page : rn BETWEEN [(n-1)*pageSize} + 1] AND n*pageSize;
{(n-1)*pageSize} + 1 ==> n*pageSize-(pageSize-1) = n*pageSize-pageSize+1

SELECT *
FROM (SELECT ROWNUM rn, empno, ename  
      FROM (SELECT empno, ename         
            FROM emp
            ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize;
--이걸 실행하면 바인더가 뜸 : 바인더에서 ENTER치면 인식 못함
-- [:] 이게 변수되는 거임


emp테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요
(정렬없이 진행,화면처럼)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;


ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요
SELECT *
FROM(SELECT ROWNUM rn,  empno, ename
     FROM emp)
WHERE rn BETWEEN 11 AND 20;


emp테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 
11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요 (rn, empno, ename)--> 다시 풀어보기 틀렸음
SELECT *
FROM
 (SELECT *
    FROM(SELECT ROWNUM rn,  empno, ename
         FROM emp)
    ORDER BY ename ASC;)
WHERE rn BETWEEN 11 AND 20


<한정자>
SELECT ROWNUM, *
FROM emp;
-->이대로는 에러 : *이외에 다른 문자가 오려면 *이 어디서부터 오는지 체크해줘야함
SELECT ROWNUM, emp.* -->한정자
FROM emp;

--한정자로 SELECT ROWNUM, emp.empno
--이렇게 해줄 수도 있음 (컬럼명에 영향이 가지 않음)


<테이블 ANLAS> --> 나중에 조인배울때 emp e, emp m 이런식으로 한번에 나열해서 쓰기도 함
-->마찬가지로 인라인 뷰에도 적용가능//인라인뷰도 하나의 테이블로 보니까
FROM emp e;
-->emp라고 하기 번거로워서 e라고 하고 싶어서
