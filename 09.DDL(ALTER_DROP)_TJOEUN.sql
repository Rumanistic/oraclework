/*
  ALTER
    객체를 변경하는 구문
  
  [FORMAT]
    ALTER TABLE [TABLE_NAME] [CHANGED_STH]
    
  - 변경할 내용
    1) 컬럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제     --> 수정 불가
    3) 컬럼명 / 제약조건명 / 테이블명 변경
*/

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
/*
  1) 컬럼 추가 / 수정 / 삭제
*/
-- 1.1 컬럼 추가
-- ALTER TABLE EMP_01 ADD HYPER NUMBER;

ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';

/*
  1.2 컬럼 수정 (MODIFY)
  
  [FORMAT]
    -- DATA TYPE MODIFY
      MODIFY [COLUMN_NAME] [CHANGE_TO_DATATYPE]
      
    -- DEFAULT DATA MODIFY
      MODIFY [COLUMN_NAME] DEFAULT [CHANGE_DEFAULT_VALUE]
*/
-- DEPT_COPY 테이블의 DEPT_ID의 자료형 변경 --> CHAR(3)
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- DEPT_COPY 테이블의 DEPT_ID 자료형을 NUMBER로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;

-- DEPT_COPY 테이블의 DEPT_TITLE의 자료형을 VARCHAR2(10) 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);

-- DEPT_COPY 테이블의 DEPT_TITLE의 자료형 VARCHAR2(40)으로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40);
-- DEPT_COPY 테이블의 LOCATION_ID의 자료형 VARCHAR2(2)으로 변경
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR2(2);
-- DEPT_COPY 테이블의 LNAME의 기본값을 '미국'으로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';


-- 다중 변경 가능
ALTER TABLE DEPT_COPY
      MODIFY DEPT_TITLE VARCHAR2(40)
      MODIFY LOCATION_ID VARCHAR2(2)
      MODIFY LNAME DEFAULT '미국';
      
/*
  1.3 컬럼 삭제 (DROP COLUMN)
  
  [FORMAT]
    -- DROP COLUMN
      DROP COLUMN [COLUMN_NAME]
*/
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
-- DROP은 다중 삭제가 안됨

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;
-- 테이블에는 최소한 한개 이상의 컬럼이 존재해야 한다
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;  -- 삭제시 오류

/*
  테이블 생성 후 제약조건 추가
  ALTER TABLE [TABLE_NAME] [CHANGES]
    PK : ALTER TABLE [TABLE_NAME] ADD PRIMARY KEY([COLUMN_NAME])
    FK : ALTER TABLE [TABLE_NAME] ADD FOREIGN KEY([MY_COLUMN_NAME) REFERENCES [TABLE_NAME]([COLUMN_NAME])
    UQ : ALTER TABLE [TABLE_NAME] ADD UNIQUE(COLUMN_NAME)
    CK : ALTER TABLE [TABLE_NAME] ADD CHECK(RULE_FOR_COLUMN)
    NN : ALTER TABLE [TABLE_NAME] MODIFY [COLUMN_NAME] NOT NULL
    
    + 제약 조건명을 지정하고자 한다면
      CONSTRAINT [CONST_NAME] [CONSTRAINTS]
  
  > 제약 조건 삭제
    DROP CONSTRAINT [CONSTRAINTS]
    MODIFY [COLUMN_NAME] NULL       --> NOT NULL을 NULL로 바꾼다
*/
TRUNCATE TABLE DEPT_COPY;
DROP TABLE DEPT_COPY;
-- DEPARTMENT 테이블을 복사해서 DEPT_COPY 생성
CREATE TABLE DEPT_COPY
AS SELECT *
    FROM DEPARTMENT
    WHERE 1=0;
-- DEPT_COPY 테이블에 LNAME컬럼 추가
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20);
-- DEPT_COPY 테이블에 제약조건 추가
-- 1) DEPT_ID컬럼에 기본키
ALTER TABLE DEPT_COPY ADD PRIMARY KEY(DEPT_ID);
-- 2) DEPT_TITLE컬럼에 UNIQUE
ALTER TABLE DEPT_COPY ADD UNIQUE(DEPT_TITLE);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID PRIMARY KEY;
ALTER TABLE DEPT_COPY DROP CONSTRAINT SYS_C007471;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
-- 3) LNAME컬럼에 NN
ALTER TABLE DEPT_COPY MODIFY LNAME NOT NULL;

      
/*
  3. 컬럼명 / 제약조건명 / 테이블명 변경
  
  [FORMAT]
    RENAME COLUMN|CONTRAINT|TABLE [FROM] TO [TO]
*/
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 제약조건명 변경
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007469 TO DCOPY_NN;

-- 테이블명 변경
ALTER TABLE DEPT_COPY RENAME TO COPY_DEPT;


-- 테이블 삭제
DROP TABLE COPY_DEPT;


/*
  외래키로 연결되어있는 테이블을 삭제하고싶다!
    1) 자식 테이블을 먼저 지우고, 부모 테이블을 지운다
    2) 부모 테이블만 삭제하는 제약조건도 같이 삭제(외래키 삭제 + 테이블 삭제)
        CASCADE CONSTRAINT;
*/