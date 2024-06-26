/*
  VIEW
    - SELECT문을 저장해줄 수 있는 객체
      자주 쓰이는 긴 SELECT문을 저장해뒀다가 호출할 때 사용
      임시테이블 같은 존재(실제 데이터가 담겨있지 않음 -> 논리 테이블)
*/

-- 한국에서 근무하는 사원의 사번, 사원명, 부서명 급여, 근무국가명
CREATE VIEW VW_EMP_KO AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME 
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
  AND N.NATIONAL_NAME = '한국';
  
SELECT * FROM VW_EMP_KO;
-- 러시아에서 근무하는 사원의 사번, 사원명, 부서명 급여, 근무국가명
CREATE VIEW VW_EMP_RU AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME 
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
  AND N.NATIONAL_NAME = '러시아';
  
-- 일본에서 근무하는 사원의 사번, 사원명, 부서명 급여, 근무국가명
CREATE VIEW VW_EMP_JP AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME 
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
  AND N.NATIONAL_NAME = '일본';

--------------------------------------------------------------
/*
  VIEW 컬럼에 별칭 부여
    - 서브쿼리의 서브쿼리에 함수식, 산술식이 기술되면 반드시 별칭을 부여해줘야함
*/
-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 뷰(VW_EMP_JOB) 생성
-- CREATE OR REPLACE VIEW
CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, 
    EMP_NAME,
    JOB_NAME,
    DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') AS GENDER, 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS WORK_YEAR
  FROM EMPLOYEE E
    JOIN JOB J
      USING (JOB_CODE)
WITH READ ONLY;
/*
CASE
  WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남'
  WHEN SUBSTR(EMP_NO, 8, 1) = 2 THEN '여'
END AS GENDER
*/
SELECT * FROM VW_EMP_JOB;

SELECT 사원명, 근무년수 
FROM VW_EMP_JOB
WHERE 성별 = '여';

SELECT 사원명, 직급명
FROM VW_EMP_JOB
WHERE VW_EMP_JOB.근무년수 >= 30;

DROP VIEW VW_EMP_JOB;

-----------------------------------------------------------------------------------------
/*
  생성된 VIEW를 통해 DML 사용 가능
    VIEW에서 삽입, 수정, 삭제 시 실제 데이터베이스의 데이터도 변경됨
*/
CREATE OR REPLACE VIEW VW_JOB
AS SELECT * FROM JOB;

SELECT * FROM VW_JOB;
SELECT * FROM JOB;

INSERT INTO VW_JOB VALUES('J8', '인턴');

UPDATE VW_JOB
  SET JOB_NAME = '알바'
  WHERE JOB_CODE = 'J8';
  
DELETE FROM VW_JOB
WHERE JOB_CODE = 'J8';

/*
  단, DML 명령어로 조작이 불가능한 경우가 더 많음
    1) 뷰에 정의되어있지 않은 컬럼을 조작하고자 하는 경우
    2) 뷰에 정의되어있는 컬럼 중에 원본 테이블 상에 NOT NULL 제약조건이 지정되어 있는 경우
    3) 산술식 함수식으로 정의되어 있는 경우
    4) 그룹함수나 GROUP BY 절이 포함되어 있는 경우
    5) DISTINCT 구문이 포함되어 있는 경우
    6) JOIN으로 다른 테이블의 데이터가 포함되어 있는 경우
*/

-- 1)
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE FROM JOB;

SELECT * FROM JOB;
SELECT * FROM VW_JOB;

INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES('J8', '인턴');
--DELETE FROM VW_JOB
--WHERE JOB_CODE = 'J8';
SELECT * FROM JOB;

UPDATE VW_JOB
  SET JOB_NAME = '인턴'
  WHERE JOB_CODE = 'J7';
  
-- 2)
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME FROM JOB;

SELECT * FROM VW_JOB;

INSERT INTO VW_JOB VALUES('인턴');

ROLLBACK;
-- DELETE할 때 부모테이블을 VIEW로 만들었다면 외래키 제약조건도 따져야 한다

-- 3)
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
    FROM EMPLOYEE;

INSERT INTO VW_EMP_SAL VALUES(300, '김상진', 3000000, 36000000);

UPDATE VW_EMP_SAL
  SET 연봉 = 20000000
  WHERE EMP_ID = 214;

-- 원본 테이블에 있는 데이터는 가능
UPDATE VW_EMP_SAL
  SET SALARY = 20000000
  WHERE EMP_ID = 214;

ROLLBACK;

-- 4)
CREATE OR REPLACE VIEW VW_GROUP_DEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, CEIL(AVG(SALARY)) 평균
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
INSERT INTO VW_GROUP_DEPT VALUES('D3', 8000000, 4000000);

-- 5)
CREATE OR REPLACE VIEW VW_JOB
AS SELECT DISTINCT JOB_CODE FROM EMPLOYEE;
SELECT * FROM VW_JOB;

INSERT INTO VW_JOB VALUES('J8');

UPDATE VW_JOB
  SET JOB_CODE = 'J8'
  WHERE JOB_CODE = 'J2';
  
  
-- 6)
CREATE OR REPLACE VIEW VW_JOIN
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    
INSERT INTO VW_JOIN VALUES(600, '황미연', '회계관리부');

UPDATE VW_JOIN
  SET EMP_NAME = '김새로'
  WHERE EMP_ID = 201;
  
UPDATE VW_JOIN
  SET DEPT_TITLE = '인사관리부'
  WHERE EMP_ID = 201;
  

--------------------------------------------------------------------------------
/*
  VIEW 옵션
  
  [FORMAT]
    CREATE [OR REPLACE] [FORCE|NONFORCE] VIEW [VIEW_NAME]
    AS (SUBQUERY)
    [WITH CHECK OPTION]
    [WITH READ ONLY]
  
    1) OR REPLACE : 기존에 동일한 뷰가 있으면 덮어쓰기, 없으면 생성
    2) FORCE|NONFORCE
      > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성됨
      > NONFORCE : 서브쿼리에 기술된 테이블이 존재해야 뷰가 생성됨 (DEFAULT)
    3) WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML을 가능하도록 함
    4) WITH READ ONLY : 뷰를 조회만 가능하게 생성(DML문 수행 불가)
*/

-- 2)
CREATE OR REPLACE FORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM IT;

INSERT INTO VW_EMP VALUES(1, 'NAME', 'CONTENT');
-- 실제 뷰를 사용하려면 IT라는 테이블이 존재해야함
CREATE TABLE IT(
  TCODE NUMBER,
  TNAME VARCHAR2(30),
  TCONTENT VARCHAR2(100)
);

-- 3)
-- WITH를 사용하지 않았을 때
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000;
    
UPDATE VW_EMP
  SET SALARY = 3000000
WHERE EMP_ID = 204;

SELECT * FROM VW_EMP;

-- WITH를 사용할 때
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000
    WITH CHECK OPTION;
    
UPDATE VW_EMP
  SET SALARY = 2000000
WHERE EMP_ID = 204;

SELECT * FROM VW_EMP;

-- 4) WITH READ ONLY
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
WITH READ ONLY;

DELETE FROM VW_EMP WHERE EMP_ID = 204;