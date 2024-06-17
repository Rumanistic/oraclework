/*
  DDL: 데이터 정의 언어
    오라클에서 제공하는 객체를 만들고(CREATE)
    구조를 변경하거나(ALTER)
    구조를 삭제하는(DROP) 언어
    즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
    
    - 오라클에서 객체(구조): 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 패키지(PACKAGE)
                          트리거(TRIGGER), 프로시저(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
*/
--=========================================================================================================
/*
  CREATE : 객체를 생성하는 예약어 
*/
------------------------------------  
/*
  테이블 생성
    - TABLE이란? 행(ROW)과 열(COLUMN)으로 구성되는 가장 기본적인 데이터베이스 객체 
                모든 데이터들은 테이블을 통해 저장됨    
                (표 형태를 DB에서는 TABLE으로 지칭)  
                                                
    [FORMAT]
      CREATE TABLE [TABLE_NAME] (     
        COLUMN_NAME DATA_TYPE(SIZE),  
        ... (NEEDED AS YOU WANT)      
      );
      
      DATA TYPES:
        - CHARACTER : CHAR(SIZE[AS BYTE])|VARCHAR2(SIZE[AS BYTE])               
          > CHAR : MAXIMUM 2000 BYTE, NON-FLEXIBLE SIZE, NON-FLEXIBLE DATA USED 
          > VARCHAR2 : MAXIMUM 4000 BYTE, FLEXIBLE SIZE, FLEXIBLE DATA USED     
        - NUMERIC : NUMBER
        - DATETIME : DATE
*/

-- 회원에 대한 데이터를 담기 위한 테이블 MEMBER 생성
CREATE TABLE MEMBER (
  MEM_NO NUMBER,
  MEM_ID VARCHAR2(20),
  MEM_PWD VARCHAR2(20),
  MEM_NAME VARCHAR2(20),
  GENDER CHAR(1),
  PHONE VARCHAR2(13),
  EMAIL VARCHAR2(50),
  CREATE_DATE DATE
);

SELECT * FROM MEMBER;

-- 사용자가 가지고 있는 테이블 정보
-- 데이터 딕셔너리: 다양한 객체들의 정보를 저장하고 있는 시스템; 테이블 등
-- [참고] USER_TABLES: 사용자가 가지고 있는 테이블의 전반적이 구조를 확인 할 수 있는 시스템 테이블
SELECT * FROM USER_TABLES

-- [참고] USER_TAB_COLUMNS: 사용자가 가지고 있는 테이블의 모든 컬럼의 전반적인 구조를 확인 할 수 있는 시스템 테이블