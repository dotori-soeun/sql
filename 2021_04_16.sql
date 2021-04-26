-- 학생
CREATE TABLE "STUDENT" (
	"STU_NO"         VARCHAR2(10)  NOT NULL, -- 학번(학생번호)
	"STU_NAME"       VARCHAR2(30)  NULL,     -- 이름
	"STU_USER_ID"    VARCHAR2(30)  NULL,     -- 아이디
	"STU_PASSWORD"   VARCHAR2(30)  NULL,     -- 비밀번호
	"STU_GRADE"      NUMBER(1)     NULL,     -- 학년
	"MAJOR_NO"       VARCHAR2(10)  NULL,     -- 학과번호
	"STU_BIRTH_DATE" DATE          NULL,     -- 생년월일
	"STU_ADDR"       VARCHAR2(200) NULL      -- 주소
);

-- 학생 기본키
CREATE UNIQUE INDEX "PK_STUDENT"
	ON "STUDENT" ( -- 학생
		"STU_NO" ASC -- 학번(학생번호)
	);

-- 학생
ALTER TABLE "STUDENT"
	ADD
		CONSTRAINT "PK_STUDENT" -- 학생 기본키
		PRIMARY KEY (
			"STU_NO" -- 학번(학생번호)
		);

-- 교직원(행정, 교수)
CREATE TABLE "UNIV_EMP" (
	"EMP_NO"         VARCHAR2(10)  NOT NULL, -- 사번(교직원번호)
	"DEPT_NO"        NUMBER(5)     NOT NULL, -- 부서번호
	"EMP_NAME"       VARCHAR2(30)  NULL,     -- 이름
	"EMP_USER_ID"    VARCHAR2(30)  NULL,     -- 아이디
	"EMP_PASSWORD"   VARCHAR2(30)  NULL,     -- 비밀번호
	"EMP_BIRTH_DATE" DATE          NULL,     -- 생년월일
	"EMP_ADDR"       VARCHAR2(200) NULL      -- 주소
);

-- 교직원(행정, 교수) 기본키
CREATE UNIQUE INDEX "PK_UNIV_EMP"
	ON "UNIV_EMP" ( -- 교직원(행정, 교수)
		"EMP_NO" ASC -- 사번(교직원번호)
	);

-- 교직원(행정, 교수)
ALTER TABLE "UNIV_EMP"
	ADD
		CONSTRAINT "PK_UNIV_EMP" -- 교직원(행정, 교수) 기본키
		PRIMARY KEY (
			"EMP_NO" -- 사번(교직원번호)
		);

-- 과목
CREATE TABLE "SUBJECT" (
	"SUB_NO"     VARCHAR2(20)  NOT NULL, -- 과목번호
	"SUB_NAME"   VARCHAR2(100) NULL,     -- 과목명
	"SUB_CREDIT" NUMBER        NULL      -- 학점
);

-- 과목 기본키
CREATE UNIQUE INDEX "PK_SUBJECT"
	ON "SUBJECT" ( -- 과목
		"SUB_NO" ASC -- 과목번호
	);

-- 과목
ALTER TABLE "SUBJECT"
	ADD
		CONSTRAINT "PK_SUBJECT" -- 과목 기본키
		PRIMARY KEY (
			"SUB_NO" -- 과목번호
		);

-- 강의실
CREATE TABLE "LEC_ROOM" (
	"BUILD_NO" VARCHAR2(10) NOT NULL, -- 건물번호
	"ROOM_NO"  NUMBER       NOT NULL  -- 호실
);

-- 강의실 기본키
CREATE UNIQUE INDEX "PK_LEC_ROOM"
	ON "LEC_ROOM" ( -- 강의실
		"BUILD_NO" ASC, -- 건물번호
		"ROOM_NO"  ASC  -- 호실
	);

-- 강의실
ALTER TABLE "LEC_ROOM"
	ADD
		CONSTRAINT "PK_LEC_ROOM" -- 강의실 기본키
		PRIMARY KEY (
			"BUILD_NO", -- 건물번호
			"ROOM_NO"   -- 호실
		);

-- 수강신청
CREATE TABLE "TABLE5" (
	"LEC_NO" VARCHAR2(30) NOT NULL, -- 강의번호
	"STU_NO" VARCHAR2(10) NOT NULL  -- 학번(학생번호)
);

-- 수강신청 기본키
CREATE UNIQUE INDEX "PK_TABLE5"
	ON "TABLE5" ( -- 수강신청
		"LEC_NO" ASC, -- 강의번호
		"STU_NO" ASC  -- 학번(학생번호)
	);

-- 수강신청
ALTER TABLE "TABLE5"
	ADD
		CONSTRAINT "PK_TABLE5" -- 수강신청 기본키
		PRIMARY KEY (
			"LEC_NO", -- 강의번호
			"STU_NO"  -- 학번(학생번호)
		);

-- 강의
CREATE TABLE "LECTURE" (
	"LEC_NO"    VARCHAR2(30) NOT NULL, -- 강의번호
	"SUB_NO"    VARCHAR2(20) NOT NULL, -- 과목번호
	"EMP_NO"    VARCHAR2(10) NOT NULL, -- 사번(교직원번호)
	"BUILD_NO"  VARCHAR2(10) NULL,     -- 건물번호
	"ROOM_NO"   NUMBER       NULL,     -- 호실
	"TIME_NO"   CHAR(1)      NULL,     -- 시간코드
	"LEC_CAP"   NUMBER       NULL,     -- 수용인원
	"LEC_STATE" CHAR(1)      NULL      -- 상태(Y/N)
);

-- 강의 기본키
CREATE UNIQUE INDEX "PK_LECTURE"
	ON "LECTURE" ( -- 강의
		"LEC_NO" ASC -- 강의번호
	);

-- 강의
ALTER TABLE "LECTURE"
	ADD
		CONSTRAINT "PK_LECTURE" -- 강의 기본키
		PRIMARY KEY (
			"LEC_NO" -- 강의번호
		);

-- 성적
CREATE TABLE "LEC_SCORE" (
	"REGI_NO"   VARCHAR2(30) NOT NULL, -- 수강신청완료번호
	"LEC_SCORE" NUMBER       NULL,     -- 점수
	"RATE"      CHAR(1)      NULL      -- 등급
);

-- 성적 기본키
CREATE UNIQUE INDEX "PK_LEC_SCORE"
	ON "LEC_SCORE" ( -- 성적
		"REGI_NO" ASC -- 수강신청완료번호
	);

-- 성적
ALTER TABLE "LEC_SCORE"
	ADD
		CONSTRAINT "PK_LEC_SCORE" -- 성적 기본키
		PRIMARY KEY (
			"REGI_NO" -- 수강신청완료번호
		);

-- 강의평가
CREATE TABLE "LEC_JUDGE" (
	"REGI_NO"     VARCHAR2(30)   NOT NULL, -- 수강신청완료번호
	"COMMENT"     VARCHAR2(2000) NULL,     -- 코멘트
	"JUDGE_SCORE" CHAR(1)        NULL      -- 점수
);

-- 강의평가 기본키
CREATE UNIQUE INDEX "PK_LEC_JUDGE"
	ON "LEC_JUDGE" ( -- 강의평가
		"REGI_NO" ASC -- 수강신청완료번호
	);

-- 강의평가
ALTER TABLE "LEC_JUDGE"
	ADD
		CONSTRAINT "PK_LEC_JUDGE" -- 강의평가 기본키
		PRIMARY KEY (
			"REGI_NO" -- 수강신청완료번호
		);

-- 전체_공지
CREATE TABLE "UNIV_NOTICE" (
	"NOTICE_NO" NUMBER         NOT NULL, -- 글번호
	"TITLE"     VARCHAR2(100)  NULL,     -- 제목
	"CONTENTS"  VARCHAR2(2000) NULL,     -- 내용
	"EMP_NO"    VARCHAR2(10)   NULL,     -- 사번(교직원번호)
	"DATE"      DATE           NULL      -- 날짜
);

-- 전체_공지 기본키
CREATE UNIQUE INDEX "PK_UNIV_NOTICE"
	ON "UNIV_NOTICE" ( -- 전체_공지
		"NOTICE_NO" ASC -- 글번호
	);

-- 전체_공지
ALTER TABLE "UNIV_NOTICE"
	ADD
		CONSTRAINT "PK_UNIV_NOTICE" -- 전체_공지 기본키
		PRIMARY KEY (
			"NOTICE_NO" -- 글번호
		);

-- 전공
CREATE TABLE "TABLE10" (
	"COL2" <데이터 타입 없음> NOT NULL, -- 전공번호
	"COL"  <데이터 타입 없음> NULL      -- 전공이름
);

-- 전공 기본키
CREATE UNIQUE INDEX "PK_TABLE10"
	ON "TABLE10" ( -- 전공
		"COL2" ASC -- 전공번호
	);

-- 전공
ALTER TABLE "TABLE10"
	ADD
		CONSTRAINT "PK_TABLE10" -- 전공 기본키
		PRIMARY KEY (
			"COL2" -- 전공번호
		);

-- 부서(행정부,교수부)
CREATE TABLE "UNIV_DEPT" (
	"DEPT_NO"   NUMBER(5)    NOT NULL, -- 부서번호
	"DEPT_NAME" VARCHAR2(10) NULL      -- 부서명
);

-- 부서(행정부,교수부) 기본키
CREATE UNIQUE INDEX "PK_UNIV_DEPT"
	ON "UNIV_DEPT" ( -- 부서(행정부,교수부)
		"DEPT_NO" ASC -- 부서번호
	);

-- 부서(행정부,교수부)
ALTER TABLE "UNIV_DEPT"
	ADD
		CONSTRAINT "PK_UNIV_DEPT" -- 부서(행정부,교수부) 기본키
		PRIMARY KEY (
			"DEPT_NO" -- 부서번호
		);

-- 과목별_공지
CREATE TABLE "SUB_NOTICE" (
	"LEC_NO"    VARCHAR2(30)   NOT NULL, -- 강의번호
	"NOTICE_NO" NUMBER         NOT NULL, -- 글번호
	"TITLE"     VARCHAR2(100)  NULL,     -- 제목
	"CONTENTS"  VARCHAR2(2000) NULL,     -- 내용
	"DATE"      DATE           NULL      -- 날짜
);

-- 과목별_공지 기본키
CREATE UNIQUE INDEX "PK_SUB_NOTICE"
	ON "SUB_NOTICE" ( -- 과목별_공지
		"NOTICE_NO" ASC -- 글번호
	);

-- 과목별_공지
ALTER TABLE "SUB_NOTICE"
	ADD
		CONSTRAINT "PK_SUB_NOTICE" -- 과목별_공지 기본키
		PRIMARY KEY (
			"NOTICE_NO" -- 글번호
		);

-- 최종수강신청(결제내역)
CREATE TABLE "FINAL_REGI" (
	"REGI_NO"  VARCHAR2(30) NOT NULL, -- 수강신청완료번호
	"YEAR"     NUMBER       NOT NULL, -- 년도
	"SEMESTER" CHAR(5)      NOT NULL, -- 학기
	"LEC_NO"   VARCHAR2(30) NOT NULL, -- 강의번호
	"STU_NO"   VARCHAR2(10) NOT NULL  -- 학번(학생번호)
);

-- 최종수강신청(결제내역) 기본키
CREATE UNIQUE INDEX "PK_FINAL_REGI"
	ON "FINAL_REGI" ( -- 최종수강신청(결제내역)
		"REGI_NO" ASC -- 수강신청완료번호
	);

-- 최종수강신청(결제내역)
ALTER TABLE "FINAL_REGI"
	ADD
		CONSTRAINT "PK_FINAL_REGI" -- 최종수강신청(결제내역) 기본키
		PRIMARY KEY (
			"REGI_NO" -- 수강신청완료번호
		);

-- 학과
CREATE TABLE "MAJOR" (
	"MAJOR_NO"   VARCHAR2(10)  NOT NULL, -- 학과번호
	"MAJOR_NAME" VARCHAR2(100) NULL      -- 학과이름
);

-- 학과 기본키
CREATE UNIQUE INDEX "PK_MAJOR"
	ON "MAJOR" ( -- 학과
		"MAJOR_NO" ASC -- 학과번호
	);

-- 학과
ALTER TABLE "MAJOR"
	ADD
		CONSTRAINT "PK_MAJOR" -- 학과 기본키
		PRIMARY KEY (
			"MAJOR_NO" -- 학과번호
		);

-- 교수
CREATE TABLE "TABLE13" (
	"COL"  <데이터 타입 없음> NOT NULL, -- 사번
	"COL2" <데이터 타입 없음> NULL      -- 과목
);

-- 교수 기본키
CREATE UNIQUE INDEX "PK_TABLE13"
	ON "TABLE13" ( -- 교수
		"COL" ASC -- 사번
	);

-- 교수
ALTER TABLE "TABLE13"
	ADD
		CONSTRAINT "PK_TABLE13" -- 교수 기본키
		PRIMARY KEY (
			"COL" -- 사번
		);

-- 강의시간
CREATE TABLE "TABLE14" (
	"COL"  <데이터 타입 없음> NOT NULL, -- 시간코드
	"COL2" <데이터 타입 없음> NULL      -- 시간값
);

-- 강의시간 기본키
CREATE UNIQUE INDEX "PK_TABLE14"
	ON "TABLE14" ( -- 강의시간
		"COL" ASC -- 시간코드
	);

-- 강의시간
ALTER TABLE "TABLE14"
	ADD
		CONSTRAINT "PK_TABLE14" -- 강의시간 기본키
		PRIMARY KEY (
			"COL" -- 시간코드
		);

-- 시간
CREATE TABLE "LEC_TIME" (
	"TIME_NO" CHAR(1)      NOT NULL, -- 시간코드
	"DAY"     VARCHAR2(10) NULL,     -- 요일
	"TIME"    VARCHAR2(10) NULL      -- 시간
);

-- 시간 기본키
CREATE UNIQUE INDEX "PK_LEC_TIME"
	ON "LEC_TIME" ( -- 시간
		"TIME_NO" ASC -- 시간코드
	);

-- 시간
ALTER TABLE "LEC_TIME"
	ADD
		CONSTRAINT "PK_LEC_TIME" -- 시간 기본키
		PRIMARY KEY (
			"TIME_NO" -- 시간코드
		);

-- 새 테이블
CREATE TABLE "TABLE16" (
);

-- 임시수강저장(장바구니)
CREATE TABLE "TEMP_REGI" (
	"LEC_NO" VARCHAR2(30) NOT NULL, -- 강의번호
	"STU_NO" VARCHAR2(10) NOT NULL  -- 학번(학생번호)
);

-- 임시수강저장(장바구니) 기본키
CREATE UNIQUE INDEX "PK_TEMP_REGI"
	ON "TEMP_REGI" ( -- 임시수강저장(장바구니)
		"LEC_NO" ASC, -- 강의번호
		"STU_NO" ASC  -- 학번(학생번호)
	);

-- 임시수강저장(장바구니)
ALTER TABLE "TEMP_REGI"
	ADD
		CONSTRAINT "PK_TEMP_REGI" -- 임시수강저장(장바구니) 기본키
		PRIMARY KEY (
			"LEC_NO", -- 강의번호
			"STU_NO"  -- 학번(학생번호)
		);

-- 학생
ALTER TABLE "STUDENT"
	ADD
		CONSTRAINT "FK_MAJOR_TO_STUDENT" -- 학과 -> 학생
		FOREIGN KEY (
			"MAJOR_NO" -- 학과번호
		)
		REFERENCES "MAJOR" ( -- 학과
			"MAJOR_NO" -- 학과번호
		);

-- 교직원(행정, 교수)
ALTER TABLE "UNIV_EMP"
	ADD
		CONSTRAINT "FK_UNIV_DEPT_TO_UNIV_EMP" -- 부서(행정부,교수부) -> 교직원(행정, 교수)
		FOREIGN KEY (
			"DEPT_NO" -- 부서번호
		)
		REFERENCES "UNIV_DEPT" ( -- 부서(행정부,교수부)
			"DEPT_NO" -- 부서번호
		);

-- 수강신청
ALTER TABLE "TABLE5"
	ADD
		CONSTRAINT "FK_LECTURE_TO_TABLE5" -- 강의 -> 수강신청
		FOREIGN KEY (
			"LEC_NO" -- 강의번호
		)
		REFERENCES "LECTURE" ( -- 강의
			"LEC_NO" -- 강의번호
		);

-- 수강신청
ALTER TABLE "TABLE5"
	ADD
		CONSTRAINT "FK_STUDENT_TO_TABLE5" -- 학생 -> 수강신청
		FOREIGN KEY (
			"STU_NO" -- 학번(학생번호)
		)
		REFERENCES "STUDENT" ( -- 학생
			"STU_NO" -- 학번(학생번호)
		);

-- 강의
ALTER TABLE "LECTURE"
	ADD
		CONSTRAINT "FK_UNIV_EMP_TO_LECTURE" -- 교직원(행정, 교수) -> 강의
		FOREIGN KEY (
			"EMP_NO" -- 사번(교직원번호)
		)
		REFERENCES "UNIV_EMP" ( -- 교직원(행정, 교수)
			"EMP_NO" -- 사번(교직원번호)
		);

-- 강의
ALTER TABLE "LECTURE"
	ADD
		CONSTRAINT "FK_SUBJECT_TO_LECTURE" -- 과목 -> 강의
		FOREIGN KEY (
			"SUB_NO" -- 과목번호
		)
		REFERENCES "SUBJECT" ( -- 과목
			"SUB_NO" -- 과목번호
		);

-- 강의
ALTER TABLE "LECTURE"
	ADD
		CONSTRAINT "FK_LEC_ROOM_TO_LECTURE" -- 강의실 -> 강의
		FOREIGN KEY (
			"BUILD_NO", -- 건물번호
			"ROOM_NO"   -- 호실
		)
		REFERENCES "LEC_ROOM" ( -- 강의실
			"BUILD_NO", -- 건물번호
			"ROOM_NO"   -- 호실
		);

-- 강의
ALTER TABLE "LECTURE"
	ADD
		CONSTRAINT "FK_LEC_TIME_TO_LECTURE" -- 시간 -> 강의
		FOREIGN KEY (
			"TIME_NO" -- 시간코드
		)
		REFERENCES "LEC_TIME" ( -- 시간
			"TIME_NO" -- 시간코드
		);

-- 성적
ALTER TABLE "LEC_SCORE"
	ADD
		CONSTRAINT "FK_FINAL_REGI_TO_LEC_SCORE" -- 최종수강신청(결제내역) -> 성적
		FOREIGN KEY (
			"REGI_NO" -- 수강신청완료번호
		)
		REFERENCES "FINAL_REGI" ( -- 최종수강신청(결제내역)
			"REGI_NO" -- 수강신청완료번호
		);

-- 강의평가
ALTER TABLE "LEC_JUDGE"
	ADD
		CONSTRAINT "FK_FINAL_REGI_TO_LEC_JUDGE" -- 최종수강신청(결제내역) -> 강의평가
		FOREIGN KEY (
			"REGI_NO" -- 수강신청완료번호
		)
		REFERENCES "FINAL_REGI" ( -- 최종수강신청(결제내역)
			"REGI_NO" -- 수강신청완료번호
		);

-- 전체_공지
ALTER TABLE "UNIV_NOTICE"
	ADD
		CONSTRAINT "FK_UNIV_EMP_TO_UNIV_NOTICE" -- 교직원(행정, 교수) -> 전체_공지
		FOREIGN KEY (
			"EMP_NO" -- 사번(교직원번호)
		)
		REFERENCES "UNIV_EMP" ( -- 교직원(행정, 교수)
			"EMP_NO" -- 사번(교직원번호)
		);

-- 과목별_공지
ALTER TABLE "SUB_NOTICE"
	ADD
		CONSTRAINT "FK_LECTURE_TO_SUB_NOTICE" -- 강의 -> 과목별_공지
		FOREIGN KEY (
			"LEC_NO" -- 강의번호
		)
		REFERENCES "LECTURE" ( -- 강의
			"LEC_NO" -- 강의번호
		);

-- 최종수강신청(결제내역)
ALTER TABLE "FINAL_REGI"
	ADD
		CONSTRAINT "FK_LECTURE_TO_FINAL_REGI" -- 강의 -> 최종수강신청(결제내역)
		FOREIGN KEY (
			"LEC_NO" -- 강의번호
		)
		REFERENCES "LECTURE" ( -- 강의
			"LEC_NO" -- 강의번호
		);

-- 최종수강신청(결제내역)
ALTER TABLE "FINAL_REGI"
	ADD
		CONSTRAINT "FK_STUDENT_TO_FINAL_REGI" -- 학생 -> 최종수강신청(결제내역)
		FOREIGN KEY (
			"STU_NO" -- 학번(학생번호)
		)
		REFERENCES "STUDENT" ( -- 학생
			"STU_NO" -- 학번(학생번호)
		);

-- 임시수강저장(장바구니)
ALTER TABLE "TEMP_REGI"
	ADD
		CONSTRAINT "FK_STUDENT_TO_TEMP_REGI" -- 학생 -> 임시수강저장(장바구니)
		FOREIGN KEY (
			"STU_NO" -- 학번(학생번호)
		)
		REFERENCES "STUDENT" ( -- 학생
			"STU_NO" -- 학번(학생번호)
		);

-- 임시수강저장(장바구니)
ALTER TABLE "TEMP_REGI"
	ADD
		CONSTRAINT "FK_LECTURE_TO_TEMP_REGI" -- 강의 -> 임시수강저장(장바구니)
		FOREIGN KEY (
			"LEC_NO" -- 강의번호
		)
		REFERENCES "LECTURE" ( -- 강의
			"LEC_NO" -- 강의번호
		);
         
DROP TABLE TABLE5                