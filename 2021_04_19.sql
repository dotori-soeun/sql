INSERT INTO major VALUES('a10', '정보통신과');
INSERT INTO major VALUES('b10', '항공서비스학과');
INSERT INTO major VALUES('c10', '환경소재공학과');

INSERT INTO student VALUES('s001', '김한기', 's001', 'java', 3, 'b10', TO_DATE(19920415, 'yyyymmdd'), '대전 대덕구');
INSERT INTO student VALUES('s002', '이용석', 's002', 'java', 3, 'c10', TO_DATE(19900728, 'yyyymmdd'), '대전 중구');
INSERT INTO student VALUES('s003', '최소은', 's003', 'java', 3, 'a10', TO_DATE(19930605, 'yyyymmdd'), '대전 동구');

INSERT INTO UNIV_DEPT VALUES(10, '행정부');
INSERT INTO UNIV_DEPT VALUES(20, '교수부');

INSERT INTO univ_emp VALUES('e001', 10, '김행정', 'e001', 'java', TO_DATE(19701212, 'yyyymmdd'), '경기도 행정시');
INSERT INTO univ_emp VALUES('e002', 20, '김승섭', 'e002', 'java', TO_DATE(19870419, 'yyyymmdd'), '대전시 중구');
INSERT INTO univ_emp VALUES('e003', 20, '하재관', 'e003', 'java', TO_DATE(19650419, 'yyyymmdd'), '청주시 흥덕구');

INSERT INTO UNIV_NOTICE  VALUES(1, '입학을 축하합니다', '제곧내', 'e001', SYSDATE);
INSERT INTO UNIV_NOTICE  VALUES(2, '입사를 축하합니다', '제곧내', 'e001', SYSDATE);

INSERT INTO SUBJECT VALUES('sub001', 'oracle의 이해', 3);
INSERT INTO SUBJECT VALUES('sub002', '쉽게 배우는 자바', 3);
INSERT INTO SUBJECT VALUES('sub003', '기내식', 3);

INSERT INTO LEC_TIME VALUES('A', '월수금', '오전');
INSERT INTO LEC_TIME VALUES('B', '월수금', '오후');
INSERT INTO LEC_TIME VALUES('C', '화목토', '오전');
INSERT INTO LEC_TIME VALUES('D', '화목토', '오후');

INSERT INTO LEC_ROOM VALUES('bud001', 101);
INSERT INTO LEC_ROOM VALUES('bud001', 201);
INSERT INTO LEC_ROOM VALUES('bud002', 101);
INSERT INTO LEC_ROOM VALUES('bud002', 201);

INSERT INTO LECTURE VALUES('202101sub001', 'sub001', 'e003', 'bud001', 101, 'A', 20, 'Y');
INSERT INTO LECTURE VALUES('202101sub002', 'sub002', 'e002', 'bud001', 101, 'B', 20, 'Y');
INSERT INTO LECTURE VALUES('202101sub003', 'sub003', 'e002', 'bud002', 201, 'C', 20, 'Y');

INSERT INTO SUB_NOTICE  VALUES('202101sub001', 1, 'oracle의 이해_개강일 안내', '4월부터 개강합니다', SYSDATE);
INSERT INTO SUB_NOTICE  VALUES('202101sub002', 2, '자바 미리 설치해서 오세요', '노트북사세요', SYSDATE);


COMMIT




TO_CHAR(sysdate,'yyyymmdd') || '00001'

전체 MAX

2021041900001
2021041900002

20210420

sysydate끼리 비교를 먼저하고 
if substr(1,8) = sysdate
같다고 하면 맥스로 해서 ++1
다르다고 하면 
0302~0305

INSERT INTO final_regi VALUES('2021041900001', '202101sub001', 2021, '1학기', 's001');
INSERT INTO final_regi VALUES('2021041900001', '202101sub002', 2021, '1학기', 's001');
INSERT INTO final_regi VALUES('2021041900001', '202101sub003', 2021, '1학기', 's001');

INSERT INTO LEC_JUDGE VALUES('2021041900001', '202101sub001', '테스트데이터입니다', 'A');
INSERT INTO LEC_JUDGE VALUES('2021041900001', '202101sub002', '테스트데이터입니다', 'B');
INSERT INTO LEC_JUDGE VALUES('2021041900001', '202101sub003', '테스트데이터입니다', 'C');

INSERT INTO LEC_SCORE VALUES('2021041900001', '202101sub001', 95, 'A');
INSERT INTO LEC_SCORE VALUES('2021041900001', '202101sub002', 87, 'B');
INSERT INTO LEC_SCORE VALUES('2021041900001', '202101sub003', 65, 'D');





commit

DROP TABLE TEMP_REGI

alter table final_regi add primary key(lec_no)

ALTER TABLE final_regi DROP PRIMARY KEY

DROP INDEX PK_FINAL_REGI


DROP TABLE final_regi;

DROP TABLE lec_judge;

DROP TABLE lec_score;

-- 최종수강신청(결제내역)
CREATE TABLE "FINAL_REGI" (
	"REGI_NO"  VARCHAR2(30) NOT NULL, -- 수강신청완료번호
	"LEC_NO"   VARCHAR2(30) NOT NULL, -- 강의번호
	"YEAR"     NUMBER       NOT NULL, -- 년도
	"SEMESTER" CHAR(5)      NOT NULL, -- 학기
	"STU_NO"   VARCHAR2(10) NOT NULL  -- 학번(학생번호)
);

-- 최종수강신청(결제내역) 기본키
CREATE UNIQUE INDEX "PK_FINAL_REGI"
	ON "FINAL_REGI" ( -- 최종수강신청(결제내역)
		"REGI_NO" ASC, -- 수강신청완료번호
		"LEC_NO"  ASC  -- 강의번호
	);

-- 최종수강신청(결제내역)
ALTER TABLE "FINAL_REGI"
	ADD
		CONSTRAINT "PK_FINAL_REGI" -- 최종수강신청(결제내역) 기본키
		PRIMARY KEY (
			"REGI_NO", -- 수강신청완료번호
			"LEC_NO"   -- 강의번호
		);
        

-- 강의평가
CREATE TABLE "LEC_JUDGE" (
	"REGI_NO"     VARCHAR2(30)   NOT NULL, -- 수강신청완료번호
	"LEC_NO"      VARCHAR2(30)   NOT NULL, -- 강의번호
	"COMMENT"     VARCHAR2(2000) NULL,     -- 코멘트
	"JUDGE_SCORE" CHAR(1)        NULL      -- 점수
);

-- 강의평가 기본키
CREATE UNIQUE INDEX "PK_LEC_JUDGE"
	ON "LEC_JUDGE" ( -- 강의평가
		"REGI_NO" ASC, -- 수강신청완료번호
		"LEC_NO"  ASC  -- 강의번호
	);

-- 강의평가
ALTER TABLE "LEC_JUDGE"
	ADD
		CONSTRAINT "PK_LEC_JUDGE" -- 강의평가 기본키
		PRIMARY KEY (
			"REGI_NO", -- 수강신청완료번호
			"LEC_NO"   -- 강의번호
		);
        

-- 성적
CREATE TABLE "LEC_SCORE" (
	"REGI_NO"   VARCHAR2(30) NOT NULL, -- 수강신청완료번호
	"LEC_NO"    VARCHAR2(30) NOT NULL, -- 강의번호
	"LEC_SCORE" NUMBER       NULL,     -- 점수
	"RATE"      CHAR(1)      NULL      -- 등급
);

-- 성적 기본키
CREATE UNIQUE INDEX "PK_LEC_SCORE"
	ON "LEC_SCORE" ( -- 성적
		"REGI_NO" ASC, -- 수강신청완료번호
		"LEC_NO"  ASC  -- 강의번호
	);

-- 성적
ALTER TABLE "LEC_SCORE"
	ADD
		CONSTRAINT "PK_LEC_SCORE" -- 성적 기본키
		PRIMARY KEY (
			"REGI_NO", -- 수강신청완료번호
			"LEC_NO"   -- 강의번호
		);        
        
-- 소감 : 중간에 테이블 바껴서 추가삭제 했을경우 테이블간 관계가 제대로 되지 않았다.
-- 기본키 중도에 변경하기 ( 기본키 1개였다가 복합으로 하기)  -> 쉽지 않다. 안되는 것 같다.

DROP TABLE FINAL_REGI;
DROP TABLE lec_JUDGE;
DROP TABLE LEC_ROOM;
DROP TABLE LEC_SCORE;
DROP TABLE LEC_TIME;
DROP TABLE LECTURE;
DROP TABLE MAJOR;
DROP TABLE STUDENT;
DROP TABLE SUB_NOTICE;
DROP TABLE SUBJECT;
DROP TABLE UNIV_DEPT;
DROP TABLE UNIV_EMP;
DROP TABLE UNIV_NOTICE;
DROP TABLE








LEC_NO
SUB_NO
EMP_NO
BUILD_NO
ROOM_NO
TIME_NO
LEC_CAP
LEC_STATE

sub001
sub002
sub003


INSERT INTO  VALUES('', '')
INSERT INTO  VALUES('', '')
INSERT INTO  VALUES('', '')