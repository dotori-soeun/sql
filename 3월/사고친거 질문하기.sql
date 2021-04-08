cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제품 중
cid = 2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요


SELECT pid
FROM cycle
WHERE cid = 2 
AND pid IN
(SELECT pid
FROM cycle
WHERE cid = 1) 

SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid
            FROM cycle
            WHERE cid =2)
            
customer, cycle, product 테이블을 이용하여  실습 6에 고객명과 제품명을 넣어 주는 것
SELECT cnm, pnm, cycle.*
FROM cycle, customer, product
WHERE cycle.cid = customer.cid
  AND cycle.pid = product.pid
  AND cycle.cid = 1
  AND cycle.pid IN (SELECT pid
            FROM cycle
            WHERE cid =2)
            
SELECT ct.cnm, c.*, p.pnm
FROM cycle c, product p, customer ct
WHERE c.cid = 1
  AND c.cid = ct.cid
  AND c.pid = p.pid
  AND c.pid IN (SELECT pid FROM cycle WHERE cid = 2)            


SELECT *
FROM cycle, customer, product
WHERE cycle.cid = 1
  AND cycle.cid = customer.cid
  AND cycle.pid = product.pid
  AND pid IN (SELECT pid 
              FROM cycle
              WHERE cid = 2); 

SELECT * FROM dept

ALTER TABLE dept ADD ("cap" VARCHAR2(13))

update dept SET loc = 'LA'
WHERE deptno = 10

update dept SET loc = 'NEW YORK'
WHERE deptno = 10
ROLLBACK

ALTER TABLE dept drop COLUMN "cap"

