지금까지 배운 문장들
SELECT
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

오라클이 읽어오는 순서
FROM -> [START WITH] -> WHERE -> GROUP BY -> SELECT -> ORDER BY

가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

WHERE절에 조건을 넣으면 계층쿼리가 완성된 다음에 (WHERE절 적용되어)쿼리가 제한됨
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

CONNECT BY 절에도 조건을 쓸 수 있다. 계층쿼리를 만들면서 애초에 조건을 적용
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND job != 'ANALYST';
-- ANALYST밑에 직원까지 계층이 끊긴다.

같은 조건이라도 어디에 기술했는지에 따라 다르다

===========================================================================

계층 쿼리와 관련된 특수 함수

1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, CONNECT_BY_ROOT(ename) root_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;
    게시판의 경우
    1. 제목
     --- 2. 답글
    2. 제목
     --- 4. 답글
    게시판의 경우 루트가 많다.
    
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, 
        CONNECT_BY_ROOT(ename) root_ename,
        SYS_CONNECT_BY_PATH(ename, '-') path_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, 
        CONNECT_BY_ROOT(ename) root_ename,
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename,
        INSTR('TEST','T'),
        INSTR('TEST','T', 2)
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;
--맨 왼쪽의 쓸데없는 - 을 지우기 위해 LTRIM을 썼음
--기존에 배운 TRIM 다시 떠올려보자 INSTR도

3. CONNECT_BY_ISLEAF : 얘는 특수하게 인자가 없음
    CHILD가 없는 leaf node 여부 0 - false(no leaf node) / 1 - true(leaf node)
-- 메탈리카? No Leaf Clover를 갑자기????? 흠... 
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, 
        CONNECT_BY_ROOT(ename) root_ename,
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename,
        CONNECT_BY_ISLEAF isleaf
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

100개의 쿼리를 작성한다면 10~15정도가 계층쿼리라고 할 수 있겠다심
계층쿼리 특수함수들 3개 한 번에 같이 쓰는 경우 잦으니까 꼭 외워두라심

===========================================================================
실습 파일 중 [게시글 계층형 쿼리 샘플 자료]
SELECT *
FROM board_test;
-- 예시 okky사이트
SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;
-- + 정렬해보니 : 계층구조가 깨져서 보기가 불편~
SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;
-- 계층구조를 유지하면서 정렬해보자 [ORDER siblings BY seq DESC]
SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY seq DESC;
----------------------------------------------------------------------------
시작(ROOT)글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬
-- 이게 우리들이 지금까지 써왔던 일반적인 형태의 게시판

최상위글은 최신순으로 답글은 순차적으로 정렬하려면?

시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);
디스크로 확인하기
DESC board_test;
(그룹번호)gn컬럼에 값추가
UPDATE board_test SET gn=1
WHERE seq IN (1, 9);
UPDATE board_test SET gn=2
WHERE seq IN (2, 3);
UPDATE board_test SET gn=4
WHERE seq NOT IN (1, 2, 3, 9);
커밋
commit;
그룹번호는 큰 순, 시퀀스는 작은순
SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;
그룹번호와 커넥트바이루트와 같았다.  
SELECT gn, CONNECT_BY_ROOT(seq) root_seq,
        seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;
그럼 gn은 굳이 안만들어도 되는가? 아니
ORDERBY 절에 저 특수함수를 사용할 수 없다고 나온다.
그럼 알리아스로 바깥에서 정렬하자 gn을 안쓰고 정렬해보기
SELECT *
FROM
    (SELECT CONNECT_BY_ROOT(seq) root_seq,
            seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq)
ORDER BY root_seq DESC, seq ASC;
조금더 나아가면 여기에서 페이징 처리까지(3/16일 리뷰~)
SELECT *
FROM 
(SELECT ROWNUM rn, a.* 
      FROM (SELECT gn, CONNECT_BY_ROOT(seq) root_seq,
                    seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
            FROM board_test
            START WITH parent_seq IS NULL
            CONNECT BY PRIOR seq = parent_seq
            ORDER siblings BY gn DESC, seq ASC)a)
            WHERE rn BETWEEN 6 AND 10;
-- a의 부분에 내가 페이징 처리 하고 싶은 쿼리를 갖다 넣는다.


쉬는시간에 들어온 질문대로~
SELECT *
FROM
    (SELECT CONNECT_BY_ROOT(seq) root_seq,
            seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq)
ORDER BY root_seq DESC, seq ASC;
--이거는 운이 좋았을 뿐이다.
SELECT *
FROM
    (SELECT CONNECT_BY_ROOT(seq) root_seq,
            seq, parent_seq, LPAD(' ', (LEVEL-1)*4)||title title
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq = parent_seq)
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq    
ORDER siblings BY root_seq DESC, seq ASC;
--쿼리는 최종적으로 이게 맞긴하다
===========================================================================
SELECT MAX(sal)
FROM emp
WHERE deptno=10;
그사람이 누군지를 구하려면??? 서브쿼리로~

SELECT *
FROM emp
WHERE deptno = 10 --이게 추가됐넹
  AND sal = (SELECT MAX(sal)
            FROM emp
            WHERE deptno=10);

<<분석함수(window함수)>>
    
    SQL에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
     . SQL의 약점 보완
     . 이전행의 특정 컬럼을 참조
     . 특정 범위의 행들의 컬럼의 합
     . 특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    . SUM, COUNT, AVG, MAX, MIN
    . RANK, LEAD, LAG ............
    
    
실습1] 부서별 급여별 순위 구하기
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC

SELECT ROWNUM rn, s.*
FROM (SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC) s

SELECT *
FROM
(SELECT ROWNUM rn, s.*
FROM 
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC) s)ss
GROUP BY ss.deptno
로우넘을 부서별로 다시 시작하게끔 하면 될 것 같은데



**쌤풀이** -- 분석함수 RANK 이용법
SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp
ORDER BY deptno, sal DESC;

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

정렬을 하지 않아도 됐었다. 순위를 매기면서 이미 내부에서 정렬 
사진보고 분석함수 해설 필기 추가하기

쿼리도 간단. 그리고 테이블을 1번만 읽고 끝날 수 있다.
----------------------------------------------------------------------------

위의 풀이를 분석함수를 안 쓰고 하려면! 엄청 복잡!
와 복잡해. 한 번 더 보자
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC
1.여기 뒤에 rn이라는 컬럼을 추가하고
2.다른세트로 rn과 rank가 나오게 하는 세트를 만들어서 3.조인
SELECT s.*, ROWNUM rn 
FROM (SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC) s
1.여기 뒤에 rn이라는 컬럼을 추가하고-- 여기까진 내 풀이랑 동일

(SELECT ROWNUM rn
FROM emp)a
(SELECT deptno, COUNT(*)  cnt
FROM emp
GROUP BY deptno
ORDER BY deptno)b

비트윈이에요 rn의 값이 cnt값보다 작거나 같을때까지 연결하면
WHERE a.rn <= b.cnt

SELECT a.rn rank
FROM
    (SELECT ROWNUM rn
    FROM emp)a,
    (SELECT deptno, COUNT(*)  cnt
    FROM emp
    GROUP BY deptno
    ORDER BY deptno)b
WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn;

한번더 인라인뷰
SELECT ROWNUM rn, rank
FROM
(SELECT a.rn rank
FROM
    (SELECT ROWNUM rn
    FROM emp)a,
    (SELECT deptno, COUNT(*)  cnt
    FROM emp
    GROUP BY deptno
    ORDER BY deptno)b
WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn);
2.다른세트로 rn과 rank가 나오게 하는 세트를 만들어서 
-- rank컬럼이 부서별 사원수대로 순번 나오는 느낌 

SELECT a.ename, a.sal, a.deptno, b.rank
FROM 
(SELECT a.*, ROWNUM rn
FROM 
(SELECT ename, sal, deptno
 FROM emp
 ORDER BY deptno, sal DESC) a ) a,

(SELECT ROWNUM rn, rank
FROM 
(SELECT a.rn rank
FROM
    (SELECT ROWNUM rn
     FROM emp) a,
     
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno
     ORDER BY deptno) b
 WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn)) b
WHERE a.rn = b.rn;
3.조인

일단 복잡하고 emp라는 동일한 테이블을 3번이나 읽었다.

===========================================================================
순위 관련된 함수(중복 값을 어떻게 처리하는가)
RANK : 동일 값에 대해 동일 순위를 부여하고, 후순위는 동일값만큼 건너뛴다.
        1등 2명이면 그 다음 순위는 3위
DENSE_RANK : 동일 값에 대해 동일 순위를 부여하고, 후순위는 이어서 부여한다.
        1등 2명이면 그 다음 순위는 2위
ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM 과 비슷)

SELECT ename, sal, deptno, 
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
    DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
    ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

윈도우 함수는 셀렉트절에~
SELECT WINDOW_FUNCTION([인자]) OVER ([PARTITION BY 컬럼] [ORDER BY 컬럼] ([WINDOWING])
FROM ....

PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서의 순서 정하기
WINDOWING : 범위 설정할 때 . 아직은 안배움


실습1]
사원 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하기
급여가 동일할 경우 사번이 빠른사람이 높은 순위가 되도록

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno

SELECT COUNT(*)
FROM emp

SELECT empno, ename, sal, deptno,
    RANK() OVER (ORDER BY sal DESC, empno ASC) sal_rank,
    DENSE_RANK() OVER (ORDER BY sal DESC, empno ASC) sal_dense_rank,
    ROW_NUMBER() OVER (ORDER BY sal DESC, empno ASC) sal_row_number
FROM emp    
-- ORDER BY 조건 두개 붙일라면 콤마
-- 전체사원 순위라서 파티션바이 없음


실습2]
모든 사원에 대해 사원번호 사원이름, 해당사원이 속한 부서의 사원수를 조회하는 쿼리작성
SELECT a.*, cnt
FROM
(SELECT empno, ename, deptno
FROM emp
ORDER BY deptno) a,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE a.deptno = b.deptno;

--쌤풀이
SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

--분석함수로 써보기
SELECT empno, ename, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp
--ORDER BY를 추가로 쓸 필요가 없다.

내일은 다른 그룹함수를 분석함수로 응용해서