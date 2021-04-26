SELECT * FROM FINAL_REGI;

SELECT * FROM LECTURE;

SELECT * FROM LECTURE
WHERE LEC_NO NOT IN(
SELECT LEC_NO FROM FINAL_REGI
WHERE STU_NO = 's003'
AND (SELECT MAX(SUBSTR(LEC_NO,1,4)) a FROM FINAL_REGI) = 2021);


SELECT LEC_NO 강의코드, SUB_NAME 강의명, EMP_NAME 담당교수,
		BUILD_NO||'동 '||ROOM_NO||'호' 장소,
		DAY||' '||TIME 강의시간, LEC_CAP 인원, LEC_STATE 개강여부
FROM LECTURE l, SUBJECT s, UNIV_EMP e, LEC_TIME t
WHERE l.SUB_NO = s.SUB_NO
AND l.EMP_NO = e.EMP_NO
AND l.TIME_NO = t.TIME_NO
AND LEC_NO = '202101sub002';

-- 강의현재인원구하기
SELECT LEC_NO 강의코드, count(*) 현재인원 
FROM FINAL_REGI
GROUP BY LEC_NO
HAVING LEC_NO = '202101sub002';

SELECT LEC_NO 강의코드, SUB_NAME 강의명, EMP_NAME 담당교수,
		BUILD_NO||'동 '||ROOM_NO||'호' 장소,
		DAY||' '||TIME 강의시간, LEC_CAP 인원, LEC_STATE 개강여부
FROM LECTURE l, SUBJECT s, UNIV_EMP e, LEC_TIME t
WHERE l.SUB_NO = s.SUB_NO
AND l.EMP_NO = e.EMP_NO
AND l.TIME_NO = t.TIME_NO
AND LEC_NO = '202101sub002';



SELECT LEC_NO 강의코드, SUB_NAME 강의명, EMP_NAME 담당교수, 현재인원, LEC_CAP 최대인원, SUB_CREDIT 학점
FROM LECTURE l, SUBJECT s, UNIV_EMP e,
(SELECT LEC_NO 강의코드, count(*) 현재인원 
FROM FINAL_REGI
GROUP BY LEC_NO) f
--HAVING LEC_NO = '202101sub002'
WHERE l.SUB_NO = s.SUB_NO 
AND l.EMP_NO = e.EMP_NO 
AND f.강의코드 = l.LEC_NO
ORDER BY 강의코드;


--수강신청 가능한 전체강의 뷰
SELECT LEC_NO 강의코드, SUB_NAME 강의명, EMP_NAME 담당교수, 현재인원, LEC_CAP 최대인원, SUB_CREDIT 학점, l.LEC_STATE 개강여부
FROM LECTURE l, SUBJECT s, UNIV_EMP e,
(SELECT LEC_NO 강의코드, count(*) 현재인원 
FROM FINAL_REGI
GROUP BY LEC_NO) f
WHERE l.SUB_NO = s.SUB_NO 
AND l.EMP_NO = e.EMP_NO 
AND f.강의코드 = l.LEC_NO
AND 현재인원 < LEC_CAP
AND LEC_STATE = 'Y'
ORDER BY 강의코드;

--전체강의뷰
CREATE OR REPLACE VIEW V_01 AS
SELECT LEC_NO 강의코드, SUB_NAME 강의명, EMP_NAME 담당교수, NVL(현재인원, 0) 현재인원, LEC_CAP 최대인원, SUB_CREDIT 학점,
    BUILD_NO||'동 '||ROOM_NO||'호' 장소, DAY||' '||TIME 강의시간,  l.LEC_STATE 개강여부
FROM LECTURE l, SUBJECT s, UNIV_EMP e,
(SELECT LEC_NO 강의코드, count(*) 현재인원 
FROM FINAL_REGI
GROUP BY LEC_NO) f, LEC_TIME t
WHERE l.SUB_NO = s.SUB_NO 
AND l.EMP_NO = e.EMP_NO 
AND f.강의코드(+) = l.LEC_NO
AND l.TIME_NO = t.TIME_NO
ORDER BY 강의코드;
-- null값이 뜨는 곳, 즉 값이 없는 쪽 조인조건에 (+)를 붙여주고, SELECT절에서 NULL값이 안나오도록 NVL처리

SELECT 강의코드, 강의명, 담당교수, 현재인원, 최대인원, 학점, 장소, 강의시간, 개강여부 FROM V_01;

SELECT f.lec_no 강의코드 
FROM final_regi f
WHERE stu_no = 's002'
AND SUBSTR(regi_no, 1, 4) = '2021'
AND lec_no = '202101sub002'


SELECT 강의코드, 강의명, 최대인원-현재인원 신청가능인원
FROM V_01
WHERE 강의코드 = '202101sub002'

if 신청가능인원==0

UPDATE STUDENT SET MAX_CREDIT = 18




-- 최대신청가능학점
SELECT STU_NO 학번, STU_NAME 이름, MAX_CREDIT 최대신청가능학점
FROM STUDENT
WHERE STU_NO = 's001'

-- 강의별 학점
SELECT LEC_NO 강의코드, SUB_NAME 강의명, SUB_CREDIT 학점 
FROM SUBJECT s, LECTURE l
WHERE s.SUB_NO = l.SUB_NO

-- 학생별 강의
SELECT LEC_NO 강의코드 FROM FINAL_REGI
WHERE STU_NO = 's001' 

-- 전체 학생별 신청강의와 학점
CREATE OR REPLACE VIEW V_02 AS
SELECT f.STU_NO 학번, STU_NAME 이름, f.LEC_NO 강의코드, SUB_NAME 강의명, SUB_CREDIT 학점
FROM SUBJECT s, LECTURE l, FINAL_REGI f, STUDENT t
WHERE s.SUB_NO = l.SUB_NO
AND l.LEC_NO = f.LEC_NO
AND t.STU_NO = f.STU_NO
AND t.STU_NO = 's002';

-- 학생별 현재 신청학점
SELECT SUM(학점) FROM V_02
GROUP BY 학번 HAVING 학번 = 's002'

SELECT MAX_CREDIT 최대신청가능학점 FROM STUDENT
WHERE STU_NO = 's001'

SELECT * FROM V_02

SELECT DISTINCT 최대신청가능학점 - SUM(학점) OVER(PARTITION BY 학번) 남은학점
FROM V_02
WHERE 학번 = 's003'
-- 이렇게 하면 아직 신청 안한사람 즉 남은 학점이 만점인 사람이 안나옴

SELECT 최대신청가능학점-현재학점 잔여학점
FROM
(SELECT MAX_CREDIT 최대신청가능학점 FROM STUDENT WHERE STU_NO = 's002') a,
(SELECT SUM(학점) 현재학점 FROM V_02 GROUP BY 학번 HAVING 학번 = 's002') b





GROUP BY 학번 HAVING 학번 = 's001'


WHERE 학번 = 's001'

-- 전체 학생별 신청강의와 학점
SELECT NVL(SUM(학점),0) 신청학점 FROM 
(SELECT f.STU_NO 학번, f.LEC_NO 강의코드, SUB_NAME 강의명, SUB_CREDIT 학점
FROM SUBJECT s, LECTURE l, FINAL_REGI f
WHERE s.SUB_NO = l.SUB_NO
AND l.LEC_NO = f.LEC_NO
AND f.STU_NO = 's002')
;

delete v_02


update Student set MAX_CREDIT = 6
WHERE STU_NO = 's003'


SELECT * FROM FINAL_REGI


--최종수강신청지우기
delete FROM LEC_JUDGE
WHERE SUBSTR(regi_no,5,4) = '0421'

delete FROM LEC_SCORE
WHERE SUBSTR(regi_no,5,4) = '0421'

delete FROM final_regi
WHERE SUBSTR(regi_no,5,4) = '0421'

commit



SELECT NOTICE_NO 글번호, sub.LEC_NO 강의코드, 강의명, TITLE 제목,
    CONTENTS 내용, NOTICE_DATE 작성일자 
    FROM sub_notice sub,
	(SELECT lec_no 강의코드, sub_name 강의명
	FROM subject s, lecture l
	WHERE l.sub_no = s.sub_no) a
    WHERE sub.lec_no = a.강의코드
    
    
    
SELECT 강의코드, 강의명, NVL(LEC_COMMENT, '미작성') 코멘트, NVL(JUDGE_SCORE, '미작성') 등급, 강의상태
				FROM LEC_JUDGE j,
				(SELECT lec_no 강의코드, sub_name 강의명, lec_state 강의상태 
				FROM subject s, lecture l
				WHERE l.sub_no = s.sub_no) a
				WHERE j.lec_no = a.강의코드
				AND lec_no IN (SELECT lec_no FROM final_regi WHERE stu_no = 's001')  
                AND 강의상태 = 'Y';
                
                
ALTER TABLE LECTURE					
ADD CONSTRAINT EMPLOYEES_DEPARTMENT_ID_FK FOREIGN KEY(department_id)					
REFERENCES LEC_ROOM(BUILD_NO, ROOM_NO)					
ON DELETE CASCADE;					                
                
                
                ORA-02292: integrity constraint (PROJECTER.FK_LEC_ROOM_TO_LECTURE) violated - child record found	
                
                
CREATE OR REPLACE TRIGGER oracle_trigger

   BEFORE

   INSERT ON LEC_ROOM

   REFERENCING NEW TABLE AS LECTURE

   FOR EACH ROW

   WHEN new_trigger.점수 = ''

   BEGIN

         SET new_table.점수 = '0';

   END;                
                
                
                
                
                