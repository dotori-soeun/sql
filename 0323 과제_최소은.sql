<실습 4>
SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p LEFT OUTER JOIN cycle c  ON (p.pid = c.pid
    AND cid = :cid);    
-- 최종쌤풀이 안시
SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
  FROM product p,cycle c 
WHERE p.pid = c.pid(+)
   AND cid(+) = :cid;


<실습 5>
<과제> 4번 과제 바탕으로 고객이름 컬럼 추가하기  
테이블을 3개 써야한다. 커스터머 테이블 추가임. 안시, 오라클 둘다 해보기
SELECT *
FROM customer ct
-- 안시
SELECT cnm, p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p LEFT OUTER JOIN cycle c  ON (p.pid = c.pid
    AND cid = :cid)
    LEFT OUTER JOIN customer ct ON (ct.cid = c.cid)
-- 오라클변환 왤케 어렵지????   왜 자꾸 오류가 나지?? 
SELECT cnm, p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM  product p, cycle c, customer ct
WHERE p.pid = c.pid(+)
  AND c.cid = ct.cid(+)
  AND cid = :cid

SELECT  cnm, a.*
FROM customer ct, (SELECT p.*, :cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
                FROM  product p, cycle c  
                WHERE p.pid = c.pid(+)
                AND c.cid(+) = :cid) a
WHERE ct.cid = :cid   
-- 쌤 설명 오라클변환 p,c를 인라인뷰하고 나머지를 그냥 조인
    
    
WinMerge  --> 비교툴 : 양쪽에 놓고 위에 새로고침    
    