**과제**
emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요 
(LIKE연산자를 사용하지 않고!!)
-->data type에 대해서 고민해보면서 풀어보자
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;
===============================================================

과제확인 쌤의 풀이

-- WHERE의 조건에 SUBSTR도 있었음. LIKE의 다른표현(자바에서 SubString)

-- 잘 풀은 사람
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;
   OR empno BETWEEN 780 AND 789;
   OR empno = 78;