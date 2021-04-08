emp테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 
11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요 (rn, empno, ename)

--1. emp테이블 사원정보
SELECT *
FROM emp;

--2. 이름컬럼으로 오름차순 적용(empno, ename)
SELECT empno, ename
FROM emp
ORDER BY ename ASC;

--3. ROWNUM 붙이기
SELECT ROWNUM rn, empno, ename
FROM(SELECT empno, ename
    FROM emp
    ORDER BY ename ASC);
    -- 인라인 뷰에 이름 붙이기
    SELECT ROWNUM rn, empno, ename
      FROM (SELECT empno, ename
              FROM emp
             ORDER BY ename ASC) a;
    
--4. 3결과에서 11~14번째 행만 조회  
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
     From(SELECT empno, ename
            From emp
        ORDER BY ename ASC))
WHERE rn BETWEEN 11 AND 15;       

--*인라인뷰를 ALIAS를 붙이는 것 까진 되는데 그걸 활용하는 것까진 못하는 것 같다.
--*어쨌든 천천히해서 안보고 풀었으니까 만족 

--*아하. 인라인뷰 ALIAS활용하려면 그 수식안에 들어가있으면 되는구나!!