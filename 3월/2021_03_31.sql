집계함수는 사용방법이 동일하다 
그룹함수 뿐만 아니라 분석함수로도 쓸 수 있다.
속도적 이슈가 있으니까 그룹함수로 쓸지 분석함수로 쓸지 잘 생각해서 쓰세요
분석함수로 남발 금지!

윈도우함수실습2]
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg_sal
FROM emp
-- 복습 똑띠 해라 어제 배운거 응용인데 헷갈리면 우째
-- 해당부서의 가장 낮은 급여
SELECT empno, ename, sal, deptno,
    MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp
-- 해당부서의 가장 높은 급여
SELECT empno, ename, sal, deptno, 
    MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp
-- 부서별 직원수
SELECT empno, ename, sal, deptno, 
    COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp
-- 부서별 급여합
SELECT empno, ename, sal, deptno, 
    SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp

===========================================================================

이전행 이후행 > 구냥 수업시간에 정하는 거

다른행의 컬럼값을 가져오기 (어제 배운 주식의 전일대비)
-- 컬럼을 하나 더 갖고 있으면 중복이 발생(RDBMS의 사상과 맞지 않는다)

LAG(col) : 파티션별 윈도우에서 이전 행의 컬럼값
LEAD(col): 파티션별 윈도우에서 이후 행의 컬럼값

자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC;
 -- 분석함수 LEAD 사용! 급여가 같은 사람이 있어서 hiredate정렬 추가
SELECT empno, ename, hiredate, sal,
      LEAD(SAL) OVER (ORDER BY sal DESC, hiredate) 
FROM emp
ORDER BY sal DESC;
 
윈도우 함수 실습5]
SELECT empno, ename, hiredate, sal,
    LAG(sal)OVER(ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

SELECT empno, ename, hiredate, sal,
    LAG(sal)OVER(ORDER BY sal DESC, hiredate) lag_sal
FROM emp
ORDER BY sal DESC;

-- 맨 아래 ORDER BY 절 안써도 결과 동일

윈도우 함수 실습5-1 5에서 분석함수로 쓰지 않고] --> 천천히 풀으니 나옴

SELECT d.empno, d.ename, d.hiredate, d.sal, c.sal lag_sal
FROM
    (SELECT ROWNUM rn, b.*
    FROM
        (SELECT empno, ename, hiredate, sal
        FROM emp
        ORDER BY sal DESC) b) d,
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT empno, ename, hiredate, sal
        FROM emp
        ORDER BY sal DESC)a) c
WHERE d.rn-1 = c.rn(+)        
ORDER BY d.sal DESC, d.hiredate  
 
------------ 쌤풀이

SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal lag_sal
FROM
(SELECT a.*, ROWNUM rn 
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a ) a,
(SELECT a.*, ROWNUM rn 
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a ) b
WHERE a.rn-1 = b.rn(+)
ORDER BY a.sal DESC, a.hiredate 


실습6] window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job), 
급여정보와 담당업무(JOB)별 급여순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요
(급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

SELECT empno, ename, hiredate, job, sal,
    LAG(SAL) OVER (PARTITION BY job  ORDER BY sal DESC, hiredate) lag_sal
FROM emp   

===========================================================================

분석함수 OVER([] [] [])

<LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기>

SELECT empno, ename, hiredate, sal,
    LAG(SAL, 2) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp  

SELECT empno, ename, hiredate, sal,
    LEAD(SAL, 2) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp  


누적합 실습!(실무에서 많이 나오는 주제)] - 윈도우 함수 없이
--힌트 ROWNUM, 범위 조인

SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a


SELECT SUM(sal)
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a ) b
GROUP BY b.sal

---------- 쌤풀이
a.rn>=b.rn

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM
(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) a,
(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) b
WHERE a.rn>=b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno

-- GROUP BY : 꼭 하나의 컬럼만 기준이 되는건 아님
-- 여기서 쓰인기술 : ROWNUM, INLINE VIEW, NON-EQUI-JOIN(조인조건이 = 이 아닌 것 : 범위조인), 그룹함수(GROUP BY)

===========================================================================

분석함수를 써서 해보기(윈도윙)

WINDOWING : 윈도우 함수의 대상이 되는 행을 지정
키워드
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행(LAG)
    -- 바운드가 없이 모든 이전행
    n PRECEDING : 특정 행을 기준으로 n행 이전행(LAG)
CURRENT ROW : 현재행
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행(LEAD)
    n FOLLOWING : 특정 행을 기준으로 n행 이후행(LEAD)

1.
SELECT empno, ename, sal, SUM(sal) OVER () c_sum
FROM emp
ORDER BY sal, empno;
2.
SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp
ORDER BY sal, empno;
3. -- CURRENT ROW 쓰지 않아도 현재까지가 기준행
    -- 하지만 쌤은 길더라도 명확히 써주는 편을 더 권하심
SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
    SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp
ORDER BY sal, empno;

-- 내 기준으로 한행씩 앞뒤행 더하기 --> 하지만 2의 방법을 더 자주씀
SELECT empno, ename, sal, 
    SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp
ORDER BY sal, empno;


윈도우 함수 실습7]-- 윈도우 함수의 모든 문법 다 나옴
사원번호 사원이름, 부서번호, 급여정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을때,
자신의 급여와 선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요(윈도우함수 사용)
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp
ORDER BY sal, empno


<ROWS와 RANGE의 차이>
ROWS : 물리적인 row
RANGE : 논리적인 값의 범위. 같은 값을 하나로 본다.
        -- 아래 예시에서 워드와 마틴의 값이 같아서 1250이라는 값을 하나의 행으로 봄
        -- 논리적이라는 표현을 오라클에서 이렇게 한다.

SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_c_sum,
        SUM(sal) OVER(ORDER BY sal RANGE UNBOUNDED PRECEDING) range_c_sum,
        SUM(sal) OVER(ORDER BY sal) no_win_c_sum,
            -- 윈도우 함수 안 ORDER BY 뒤에 윈도윙을 적용하지 않으면 
            -- RANGE UNBOUNDED PRECEDING이 기본값으로 들어감
        SUM(sal) OVER() no_ord_c_sum
            -- 윈도우 함수 안에 ORDER BY 마저 빼버리니까 전체합계가 나옴
FROM emp
ORDER BY sal, empno;
-- 윈도우함수 중 오더바이 기준에서 empno도 빼버림

==================================================================================
그 외 기타 분석함수
RATIO_TO_REPORT
PERCENT_RANk
CUME_DOST
NTILE
-- 실무에서 자주 쓰는 내용은 아니나 자격증 공부한다면 찾아봐라