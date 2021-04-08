-- 대전 중구 버거지수
SELECT DISTINCT sido 시도, sigungu 시군구, dosi.도시발전지수
FROM burgerstore, (SELECT x/y 도시발전지수
    FROM (SELECT sum(b.count) x
     FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
         FROM burgerstore
         WHERE sido = '대전'
            AND sigungu = '중구'
            GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN ('MACDONALD', 'BURGER KING', 'KFC')) X,    
    (SELECT b.count y
    FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
        FROM burgerstore
        WHERE sido = '대전'
        AND sigungu = '중구'
        GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN 'LOTTERIA') Y) dosibal
WHERE sido = '대전'
  AND sigungu = '중구';
  

--DISTINCT가 필요하다는 것은 98% 쿼리를 잘못짰다는 것.
--큰 방향은 괜찮으나 수정 필요
--불필요, 복잡한 부분 많음
--WHERE절이 안으로 들어갈 수 있는 부분 있음



  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
-- 전국 버거지수 도 해보자
SELECT DISTINCT sido 시도, sigungu 시군구, dosi.도시발전지수
FROM burgerstore, (SELECT x/y 도시발전지수
    FROM (SELECT sum(b.count) x
     FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
           GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN ('MACDONALD', 'BURGER KING', 'KFC')) X,    
    (SELECT b.count y
    FROM (SELECT STORECATEGORY, count(burgerstore.STORECATEGORY) count
        FROM burgerstore
        WHERE sido = '대전'
        AND sigungu = '중구'
        GROUP BY STORECATEGORY) b
    WHERE STORECATEGORY IN 'LOTTERIA') Y) dosi
WHERE sido = '대전'
  AND sigungu = '중구'; 
  
SELECT STORECATEGORY, count(burgerstore.STORECATEGORY)
GROUP BY STORECATEGORY  