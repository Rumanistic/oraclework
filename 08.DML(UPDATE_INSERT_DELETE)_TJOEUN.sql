/*
  - DML (DATA MANIPULATION LANGUAGE): 데이터 조작 언어
    : 테이블에 값을 삽입(INSERT)하거나, 수정(UPDATE), 삭제(DELETE)하는 구문
*/
--======================================================================
/*
  - INSERT
    : 테이블에 새로운 ROW를 추가하는 구문
    
  [FORMAT]
    INSERT INTO [TABLE_NAME] VALUES (VAL1, VAL2, VAL3...);
      > 모든 컬럼의 값을 직접 입력
        컬럼의 순서를 지켜서 값을 입력해줘야함
        값의 개수가 부족하면 NOT ENOUGH VALUE 오류
        값의 개수가 많으면 TOO MANY VALUES
*/
INSERT INTO EMPLOYEE_COPY VALUES(300, '김정보', '971122-1231412', 'slapstic@gmail.com', '01011112222', 'D6', 'J4', 3240000, 0.13, 200, SYSDATE, NULL, DEFAULT);

-- 특정 컬럼을 지정해서 삽입
INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE, PHONE) 
  VALUES (301, '이정보', '011223-4123123', DEFAULT, DEFAULT, '01011423345');
  
INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, HIRE_DATE, PHONE) 
  VALUES (302, '이정보', '011223-4123123', DEFAULT, '01011423345');
  
INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, HIRE_DATE, PHONE) 
  VALUES (303, '이정보', '011223-4123123', '01011423345');
  -- EMP_NO의 NULL 오류
  
INSERT 
  INTO EMPLOYEE_COPY
    (
        EMP_ID
      , EMP_NAME
      , EMP_NO
      , JOB_CODE
      , HIRE_DATE
      , PHONE
    ) 
  VALUES 
    (
        301
      , '이정보'
      , '011223-4123123'
      , DEFAULT
      , DEFAULT
      , '01011423345'
    );
    
---------------------------------------------------------
/*
  - SUBQUERY를 사용한 INSERT
    INSERT INTO [TABLE_NAME] (SUBQUERY)
*/
CREATE TABLE EMP_01(
  EMP_ID VARCHAR2(3),
  EMP_NAME VARCHAR2(20),
  DEPT_NAME CHAR(2)
);

INSERT INTO EMP_01 (SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE
                    FROM EMPLOYEE E, DEPARTMENT D
                    WHERE E.DEPT_CODE = D.DEPT_ID(+));
-- TRUNCATE TABLE EMP_01;
SELECT * FROM EMP_01;

-----------------------------------------------------------------------------------------
/*
  - INSERT ALL
    2개 이상의 테이블에 INSERT 할 때 사용하는 서브쿼리가 동일할 경우
    
    [FORMAT]
      INSERT ALL
      INTO [TABLE_NAME_1] VALUES(COLUMN1, ...)
      INTO [TABLE_NAME_2] VALUES(COLUMN1, ...)
        (SUB QUERY)
*/
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1=0;
    
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0;