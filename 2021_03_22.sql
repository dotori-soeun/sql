지난주에 배운 가상화. 요즘에는 버쳐보다는 도커
도커 자체가 리눅스 역할을 해준다. 개발용으로 마리아나 마이에스큐엘 DB가 필요할때 요즘엔 도커
시작할때 F2나 DELETE키 -> F7 Advanced Mode -> 어드벤스드 -> CPU컨피규레이션 -> 인텔버쳘리제이션 테크놀로지 -> 여기에서 활성화 시키고
빠져나가는 거 F10 : 저장하고 빠져나감
이렇게 재부팅하면 자동으로 도커가 실행
도커자체가 리눅스면 마리아, 마이에스큐엘도 리눅스용 설치?????
도커 우클릭-> 대쉬보드
이미지를 다운받고 이미지 바탕으로 서비스를 만드는 것
oracleinanutshell/oracle-xe-11g
docker pull oracleinanutshell/oracle-xe-11g
docker run -d -p 1522:1521 --name oracle_docker oracleinanutshell/oracle-xe-11g

디버깅 : 셀프로 공부 꼭해보자

퍼스펙티브 변환 : ctrl F8
최대화 : ctrl M (콘솔 뷰도 마찬가지)
F12 : 어디에 있던간에 에디터뷰로 이동
ctrl pgup,pqdn : 페이지 이동
F3 : 변수, 메소드 등의 유래
Alt + 왼, 오 화살표 : 뒤로가기 앞으로 가기. 웹과 동일 
ctrl + W : 탭 닫기
ctrl + shift + w : 다 닫힘
양쪽 화살표 모양의 [링크 윗 에디터]하면 내가 지금 보는 뷰가 어느폴더 어디에 있는지 나옴
파일이름은 아는데 어딨는지 모를때 : 오픈 리소스 : ctrl + shift + r //  마스킹 문자로도 가능 - 파일이름 다 몰라도 됨
F4, F5 물리모드 논리 모드


 http://exerd.com/update
 이클립스 exerd 업데이트
 https://m.blog.naver.com/PostView.nhn?blogId=thdusdl910&logNo=221234366227&proxyReferer=https:%2F%2Fwww.google.com%2F
============================================================================================================================
JOIN실습1 : erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여 다음과 같은 결과가 나오는 쿼리를 작성해보세요
select lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE lprod.lprod_gu = prod.prod_lgu;

JOIN실습 2 : erd 다이어그램을 참고하여 buyer, prod테이블을 조인하여 buyer별 담당하는 제품정보를 다음과 같은 결과가 나오도록
쿼리를 작성해보세요
SELECT *
FROM buyer;

SELECT *
FROM prod;

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer
ORDER BY prod.prod_id;
-- 결과 인출이 50개 행이라고 나와있지만 ctrl + end 누르면 끝까지 다보임
-- 인출된 행이 50개 나오면 그 이상일 가능성이 있다.

JOIN실습 3 : erd 다이어그램을 참고하여 memner, cart, prod테이블을 조인하여 
회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요(3개이상 테이블 결합)
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM cart, prod, member
WHERE member.mem_id = cart.cart_member
    AND cart.cart_prod = prod.prod_id;
-- WHERE절 조건 추가시에는 (,)이 아닌 AND로 조건을 추가한다.
-- 조인할 때에는 프롬절에 조인할 테이블을 나열 
-- WHERE절에 조인할 퀄럼을 모델링에서 확인
-- 테이블마다 동일한 퀄럼명이 없으면 한정자 안 써도 된당

-->Ansi로 작성해보기
FROM member JOIN cart ON (....)
    JOIN 다른테이블 ON
    
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty    
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
    JOIN prod ON (cart.cart_prod = prod.prod_id);
    
=================================================================================================
--SQL테이블 추가 
--코드 -> 노트패드로 열기 -> 전체선택-> SQL새창 열기 -> 복붙 -> 전체선택 후 ctrl enter -> 
--마지막 commit; -> 다시 컨트롤 엔터
=================================================================================================
JOIN실습 4  pdf파일에 있음(4~7)
customer, cycle 테이블을 조인하여 (고객명이 brown, sally), 정렬무관
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND CNM IN ('brown' , 'sally');
    
JOIN실습 5 : customer, cycle, product 테이블 조인 (고객명이 brown, sally), 정렬무관   
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND CNM in ('brown' , 'sally');
-- 조인이 헷갈리면 엑셀로 그려보고, 색깔로도 칠해보세요    

JOIN실습 6  customer, cycle, product 테이블 조인 -> 못풀음. 다시
& 애음 요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid  
    GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;    
-- 5번에서 파생 , 5번의 1~4의 퀄럼이 같은 것을 한행으로 묶겠다 -> 이걸로 그룹바이!!!!
-- 조인문의 그룹바이랑 그룹함수 적용법을 잘 몰라서 틀린듯

JOIN실습 7  customer, product 테이블 조인 -> 못풀음. 다시
& 제품별, 개수의 합과 제품명
SELECT  cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm;
-- 6번의 파생
-- 조인문의 그룹바이랑 그룹함수 적용법
=================================================================================================
-- hr계정은 오라클기본으로깔림, 계정허용되어있는지 확인하기
-- SYSTEM계정으로 진행한 것
SELECT
    *
FROM dba_users;

ALTER USER hr ACCOUNT UNLOCK;

ALTER USER hr IDENTIFIED BY java;
-- 그담에 접속정보 hr 추가함
과제 : hr 계정으로 실습 8~13
=================================================================================================
INNER JOIN 연결조건에 성공한 데이타가 나오는 것 -- 지금까지 한 것

OUTER JOIN : 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
-- 기준을 정해줘야 한다
LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
    테이블1 LEFT OUTER JOIN 테이블2
    ==테이블2 RIGHT OUTER JOIN 테이블1    
RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
    테이블1 RIGHT OUTER JOIN 테이블2 
FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복 데이터 1개만 남기고 제거
    사용빈도 상당히 떨어짐. 정의에 관해선 나중에
    FULL OUTER 조인은 오라클 SQL문법으로 제공하지 않는다. : (+) 양쪽에 쓸라하면 한쪽에만 쓸수있다고 오류코드나옴


직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join
13건(KING이 안나와도 괜찮음) -- 이전에 했던 자기 테이블끼리의 조인. 꼭 다시 복습하자
SELECT e.ename, m.ename mgr
FROM emp e, emp m
WHERE e.mgr = m.empno;
--ansi
SELECT e.ename, m.ename mgr
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
--Oracle : 누락이 되는 쪽 기준이 되는 쪽( 데이터가 안나오는 쪽)에 (+)을 붙여준다
--OUTER조인으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다. -> WHERE절에서
SELECT e.ename, m.ename mgr
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.ename, m.ename mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
-- KING이 mgr이 없어서 null로 나와서 deptno까지 null로 나와버림
SELECT e.ename, m.ename mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10);
-- m.deptno = 10을 ON절에 써봄(ON 은 조인조건을 기술하는 쪽임)
-- 14행이 나오고 m.ename, m.deptno이 null값으로 나온다
SELECT e.ename, m.ename mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;
-- m.deptno = 10을 WHERE절에 써봄(WHERE절은 행을 제한)
-- 아예 4행만 나옴

SELECT e.ename, m.ename mgr, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND m.deptno(+) = 10;
-- 조인에 실패해도 모든행이 나오게끔
SELECT e.ename, m.ename mgr, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND m.deptno = 10;
-- 아예 4행만 나옴    

안시랑 오라클 중에 내가 편한거 쓰자. 아니면 회사에서 아우터조인방법 알려주기도 할꺼임

SELECT e.ename, m.ename mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
-- left right차이. left가 되면 굳이 right를 할 필요는 없다.
SELECT e.ename, m.ename mgr, m.deptno
FROM emp m LEFT OUTER JOIN emp e ON(e.mgr = m.empno);

SELECT e.ename, m.ename mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
-- 매니저 emp를 기준으로 한다면??
SELECT e.ename, m.ename mgr, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);
-- 후임이 없는 직원들의 행이 따로나온다??? 전체행은 21행이 됨 
-- 누군가의 상사가 아니라서 조인에 실패한 애들도 따로 행으로 나옴
-- 행이 왜 다르게 나올지 충분히 생각해보자. 데이터는 몇건이 나올까 그려보기

================================================================================================
-- FULL OUTER : 이게 오라클 문법으로 없다.
-- 안시랑 벤다(오라클) 100퍼 매치 안되는게 있다고 했었는데 그게 바로 지금 
SELECT e.ename, m.ename mgr
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);
-- 22행이 나온다
SELECT e.ename, m.ename mgr
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
SELECT e.ename, m.ename mgr, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);
-- RIGHT OUTER에다가 중복되지 않는 KING null이 추가 -> KING null 이 Right outer때 안나와서
-- : 14 + 21 - 13 = 22

SELECT e.ename, m.ename mgr
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);
-- 오라클 문법으로는 없다.!!!!!!!!!!



OUTER JOIN 실습 1 -- 오류나오니까 천천히 다시 해보기

SELECT *
FROM buyprod;

SELECT *
FROM prod
WHERE prod_id = 'P202000001';

SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');


모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회, 없을 경우는 null로 표현(안시& 오라클)
-- 안시 => 오라클 변환 신경쓰기 특히 WHERE절에 조건이 추가될때. 
-- 안시
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod 
    ON (buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));
-- 오라클 ( WHERE절 어디에 (+)가 붙는지. FROM절 어디에 (+)가 붇는지
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
    AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');