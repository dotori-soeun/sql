SELECT * FROM FINAL_REGI;

SELECT MAX(SUBSTR(REGI_NO,1,8)) FROM FINAL_REGI;
--already
SELECT TO_CHAR(SYSDATE, 'yyyymmdd') FROM dual;
--nnew

--IF already equals nnew
INSERT INTO FINAL_REGI VALUES((SELECT MAX(REGI_NO)+1 FROM FINAL_REGI),
                                ?, (SELECT MAX(SUBSTR(LEC_NO, 1, 4)) FROM LECTURE), '1학기', ? );
--else
INSERT INTO FINAL_REGI VALUES((TO_CHAR(SYSDATE, 'yyyymmdd') FROM dual)||'00001',
                                ?, (SELECT MAX(SUBSTR(LEC_NO, 1, 4)) FROM LECTURE), '1학기', ? );
                                
?,?
강의코드, 로그인아이디

강의코드는 한 번만 부여되면 되는데....


YEAR값도 위의 강의코드에서 자르면 더 좋을 것 같은데

SELECT TO_CHAR(SYSDATE, 'yyyymmdd')||'00001' 강의코드 FROM DUAL;

SELECT MAX(SUBSTR(LEC_NO, 1, 4)) FROM LECTURE;
-- 강의 목록의 가장 최신 연도
SELECT TO_CHAR(SYSDATE, 'yyyy') 연도 FROM DUAL;
-- 올해의 연도

SELECT MAX(REGI_NO)+1 FROM FINAL_REGI;


-- 중복신청 못하게 하려면??
SELECT LEC_NO FROM FINAL_REGI WHERE STU_NO = 's001';
SELECT LEC_NO FROM FINAL_REGI WHERE STU_NO = ?; -- ? = 로그인 아이디
--여기에서 존재한다면 신청 해당강의 신청불가



Exception in thread "main" java.lang.NumberFormatException: For input string: "202101sub001"
	at java.lang.NumberFormatException.forInputString(Unknown Source)
	at java.lang.Integer.parseInt(Unknown Source)
	at java.lang.Integer.parseInt(Unknown Source)
	at util.ScanUtil.nextInt(ScanUtil.java:14)
	at service.StudentService.lectureInfo(StudentService.java:83)
	at controller.Controller.start(Controller.java:25)
	at controller.Controller.main(Controller.java:12)

SELECT regi_no 수강신청번호, f.lec_no 강의코드, sub_name 강의명, EMP_NAME 담당교수,
	BUILD_NO||'동 '||ROOM_NO||'호' 장소,  DAY||' '||TIME 강의시간, LEC_CAP 인원, LEC_STATE 개강여부
FROM final_regi f, LECTURE l, SUBJECT s, UNIV_EMP e, LEC_TIME t
WHERE  l.SUB_NO = s.SUB_NO
	 AND l.EMP_NO = e.EMP_NO
	 AND l.TIME_NO = t.TIME_NO
	AND f.lec_no = l.lec_no
	AND f.stu_no ='s002';
    
INSERT INTO LEC_SCORE(regi_no, lec_no)
SELECT regi_no, lec_no 
FROM final_regi
WHERE REGI_NO IN (SELECT MAX(REGI_NO) FROM FINAL_REGI);

INSERT INTO LEC_JUDGE(regi_no, lec_no)
SELECT regi_no, lec_no 
FROM final_regi
WHERE REGI_NO IN (SELECT MAX(REGI_NO) FROM FINAL_REGI);

SELECT * FROM LEC_SCORE
SELECT * FROM LEC_JUDGE


rollback

SELECT * FROM final_regi
WHERE STU_NO = 's003'

DELETE FROM final_regi WHERE year = 202

DELETE FROM final_regi WHERE SUBSTR(regi_no, 1, 8) = '20210420'

DELETE FROM final_regi WHERE STU_NO = 's003';

SELECT * FROM LEC_JUDGE
SELECT * FROM LEC_SCORE

DELETE FROM LEC_JUDGE WHERE SUBSTR(regi_no, 1, 8) = '20210420'
DELETE FROM LEC_SCORE WHERE SUBSTR(regi_no, 1, 8) = '20210420'

WHERE STU_NO = 's003'


commit

SELECT SUBSTR(regi_no, 1, 8) FROM final_regi


SELECT * FROM LEC_SCORE
SELECT * FROM final_regi
SELECT * FROM LECTURE
SELECT * FROM SUBJECT
SELECT * FROM UNIV_EMP

SELECT f.lec_no 강의코드, s.sub_name 강의명, e.EMP_NAME 담당교수, lec_score 점수, rate 등급
FROM final_regi f, SUBJECT s, UNIV_EMP e, LEC_SCORE c, LECTURE l
WHERE  l.SUB_NO = s.SUB_NO
AND l.EMP_NO = e.EMP_NO
AND c.lec_no = l.lec_no
AND f.regi_no = c.regi_no
AND f.stu_no ='s003';

SELECT 
FROM 

성적에 있어야 할 것
강의코드 강의명 점수 등급

SELECT 강의코드, 강의명, NVL(lec_score, 0) 점수, NVL(rate, '미작성') 등급
FROM lec_score sc, 
(SELECT lec_no 강의코드, sub_name 강의명 
FROM subject s, lecture l
WHERE l.sub_no = s.sub_no) a
WHERE sc.lec_no = a.강의코드
AND regi_no IN (SELECT regi_no FROM final_regi WHERE stu_no = 's003');




강의평가에 있어야 할 것
강의코드 강의명 코멘트 등급
SELECT 강의코드, 강의명, NVL(LEC_COMMENT, '미작성') 코멘트, NVL(JUDGE_SCORE, '미작성') 등급 
FROM LEC_JUDGE j,
(SELECT lec_no 강의코드, sub_name 강의명 
FROM subject s, lecture l
WHERE l.sub_no = s.sub_no) a
WHERE j.lec_no = a.강의코드
AND REGI_NO IN (SELECT regi_no FROM final_regi WHERE stu_no = 's003');


UPDATE LEC_JUDGE 
SET LEC_COMMENT = '방가방가',
JUDGE_SCORE = 'A'
WHERE REGI_NO IN (SELECT regi_no FROM final_regi WHERE stu_no = 's003')
AND LEC_NO = '202101sub001';

SELECT * FROM LEC_JUDGE
WHERE REGI_NO IN (SELECT regi_no FROM final_regi WHERE stu_no = 's003')
AND LEC_NO = '202101sub001';

rollback


WHERE lec_no IN (SELECT lec_no FROM final_regi WHERE stu_no = 's003'))),
WHERE 

WHERE regi_no IN (SELECT regi_no FROM final_regi WHERE stu_no = 's003')

(SELECT sub_name 강의명 FROM subject 
WHERE sub_no IN 
(SELECT sub_no FROM lecture 
WHERE lec_no IN (SELECT lec_no FROM final_regi WHERE stu_no = 's003'))) a,



SELECT sub_name 강의명 FROM subject
WHERE sub_no IN (SELECT sub_no FROM lecture)



(SELECT emp_name 담당교수 FROM univ_emp
WHERE emp_no IN 
(SELECT emp_no FROM lecture 
WHERE lec_no IN (SELECT lec_no FROM final_regi WHERE stu_no = 's003'))) b
WHERE 

SELECT regi_no 수강번호, lec_no 강의번호 FROM final_regi WHERE stu_no = 's003' 



SELECT NOTICE_NO 글번호, sub.LEC_NO 강의코드, 강의명, TITLE 제목, CONTENTS 내용, NOTICE_DATE 날짜 
FROM sub_notice sub,
(SELECT lec_no 강의코드, sub_name 강의명 
FROM subject s, lecture l
WHERE l.sub_no = s.sub_no) a
WHERE sub.lec_no = a.강의코드





WHERE lec_no = 
LEC_NO
NOTICE_NO
TITLE
CONTENTS
NOTICE_DATE


SELECT * FROM univ_notice

NOTICE_NO
TITLE
CONTENTS
EMP_NO
NOTICE_DATE


SELECT NOTICE_NO 글번호, TITLE 제목, CONTENTS 내용, EMP_NAME 작성자, NOTICE_DATE 작성일자
FROM UNIV_NOTICE n, UNIV_EMP e
WHERE e.emp_NO = n.emp_no

SELECT * FROM UNIV_EMP

SELECT * FROM STUDENT WHERE STU_NO = 's003'


SELECT stu_no "학번=아이디", stu_name 이름, stu_grade||'학년' 학년, major_name 전공, 
        stu_birth_date 생년월일, stu_addr 주소
FROM STUDENT s, MAJOR m  
WHERE STU_NO = 's003'
AND m.MAJOR_NO = s.MAJOR_NO

UPDATE STUDENT
SET STU_PASSWORD = ?
WHERE STU_NO = ?

UPDATE STUDENT
SET STU_PASSWORD = 'java'
WHERE STU_NO = 's003'

SELECT stu_no "학번=아이디", stu_name 이름, stu_grade||'학년' 학년, major_name 전공,
TO_DATE(TO_CHAR(stu_birth_date, 'yyyy-mm-dd')) 생년월일, stu_addr 주소
FROM STUDENT s, MAJOR m
WHERE STU_NO = 's001'
AND m.MAJOR_NO = s.MAJOR_NO

commit

SELECT

SELECT f.lec_no 강의코드 FROM final_regi f
WHERE stu_no = 's003'
AND SUBSTR(regi_no, 1, 4) = '2021'
AND lec_no = '202101sub002'



SELECT f.lec_no 강의코드 FROM final_regi f"
				+ " WHERE stu_no = ?"
				+ " AND SUBSTR(regi_no, 1, 4) = ?"
				+ " AND lec_no = ?
DECODE를 써서 학기를 뿌려주는 방법
또는 CASE문 
01~06 이면 1학기 /  0



SELECT TO_CHAR(SYSDATE, 'yyyymmdd') nnew, TO_CHAR(SYSDATE, 'mm')+1 FROM dual;

DECODE(A, B, '1', null) ::  A 가 B 일 경우 '1'을, 아닐 경우 null(생략 가능)


SELECT TO_CHAR(SYSDATE, 'yyyymmdd') nnew, 
    decode(TO_CHAR(SYSDATE, 'mm'), 01<=to_NUMBER(TO_CHAR(SYSDATE, 'mm'))<=06,'1학기', '2학기') FROM dual;
-- 오류

SELECT TO_CHAR(SYSDATE, 'yyyymmdd') nnew, 
    decode(TO_CHAR(SYSDATE, 'mm'), 04 ,'1학기', '2학기') FROM dual;

-- 구간별 학기 부여    
SELECT TO_CHAR(SYSDATE, 'yyyymmdd') 날짜,
CASE when TO_CHAR(SYSDATE, 'mm') between 3 and 6 then '1학기'
when TO_CHAR(SYSDATE, 'mm') between 7 and 8 then '3학기_계절학기'
when TO_CHAR(SYSDATE, 'mm') between 9 and 12 then '2학기'
when TO_CHAR(SYSDATE, 'mm') between 1 and 2 then '4학기_계절학기'
end 학기
FROM dual


SELECT 07,
CASE when 07 between 3 and 6 then '1학기'
when 07 between 7 and 8 then '3학기_계절학기'
when 07 between 9 and 12 then '2학기'
when 07 between 1 and 2 then '4학기_계절학기'
end 학기
FROM dual

