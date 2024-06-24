/*
  PL/SQL : PROCEDURAL LANGUAGE EXTENSION TO SQL
  
  오라클 자체에 내장되어 있는 절차적 언어
  SQL 문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여
  SQL의 단점을 보완함
  
  다수의 SQL문을 한번에 실행 가능(BLOCK 구조)
  
   - 구조
      [DECLARE SECTION] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
      [EXECUTE SECTION] : BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
      [EXCEPTION SECTION] : EXCEPTION으로 시작, 예외 발생 시 해결하기 위한 구문 기술
*/

-- 화면에 출력하기
SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
  DECLARE 선언부
    변수, 상수 선언하는 공간(선언과 동시 초기화도 가능)
    일반 타입 변수, 레퍼런스 타입 변수, ROW 타입 변수
    
      1) 일반 타입 변수 선언 및 초기화
        [FORMAT]
        [VARIABLE_NAME] [VARIABLE_TYPE] [ := VALUE ]
*/

DECLARE
  EID NUMBER;
  ENAME VARCHAR2(20);
  PI CONSTANT NUMBER := 3.14;

BEGIN
  EID := 600;
  ENAME := '임수정';
  
  DBMS_OUTPUT.PUT_LINE(EID);
  DBMS_OUTPUT.PUT_LINE('EID:'||EID);
  DBMS_OUTPUT.PUT_LINE(ENAME);
  DBMS_OUTPUT.PUT_LINE('ENAME:'||ENAME);
  DBMS_OUTPUT.PUT_LINE(PI);
  DBMS_OUTPUT.PUT_LINE('PI:'||PI);
END;
/

-- 사용자로부터 입력받아서 출력
DECLARE
  EID NUMBER;
  ENAME VARCHAR2(20);
  PI CONSTANT NUMBER := 3.141592;
  
BEGIN
  EID := &번호;
  ENAME := '&이름';
  
  DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
  DBMS_OUTPUT.PUT_LINE('ENAME : '|| ENAME);
  DBMS_OUTPUT.PUT_LINE('PI : '|| PI);
END;
/


-------------------------------------------------------------------------------------
/*
  레퍼런스 타입 변수 선언 및 초기화
    : 어떤 테이블의 어떤 컬럼의 데이터 타입을 참조하여 그 타입으로 지정
*/
DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  SAL EMPLOYEE.SALARY%TYPE;
    
BEGIN
  -- 사번이 200번인 사원의 사번, 이름, 급여를 조회해서 각 변수에 대입
  SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
  FROM EMPLOYEE
  WHERE EMP_ID = 200;
  
  DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
  DBMS_OUTPUT.PUT_LINE('ENAME : '|| ENAME);
  DBMS_OUTPUT.PUT_LINE('SAL : '|| SAL);
END;
/


DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  EDEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
  SAL EMPLOYEE.SALARY%TYPE;
    
BEGIN
  EID := &번호;
  ENAME := '&이름';
  EDEPT_CODE := '&부서코드';
  
  INSERT INTO EMP_01 VALUES(EID, ENAME, EDEPT_CODE);
  COMMIT;
END;
/


--------------------실습문제------------------------
DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  JCODE EMPLOYEE.JOB_CODE%TYPE;
  SAL EMPLOYEE.SALARY%TYPE;
  DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
  
BEGIN
  SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
  FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
  WHERE EMP_ID = &사번;
  
  DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
  DBMS_OUTPUT.PUT_LINE('ENAME : '|| ENAME);
  DBMS_OUTPUT.PUT_LINE('JCODE : '|| JCODE);
  DBMS_OUTPUT.PUT_LINE('SAL : '|| SAL);
  DBMS_OUTPUT.PUT_LINE('DTITLE : '|| DTITLE);
END;
/


---------------------------------------------------------------
/*
  ROW 타입의 변수
    : 어떤 테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 함수
    
  [FORMAT]
    [VAR_NAME] [TABLE_NAME]%ROWTYPE
*/
SET SERVEROUTPUT ON;

DECLARE
  E EMPLOYEE%ROWTYPE;
  
BEGIN
  SELECT *
  INTO E
  FROM EMPLOYEE
  WHERE EMP_ID = &사번;

  DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
  DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));
  
END;
/

DECLARE
  E EMPLOYEE%ROWTYPE;

BEGIN
  SELECT EMP_NAME, SALARY, BONUS    --  ROWTYPE 사용 시 무조건 모든 것(*)을 쿼리해와야 함
  INTO E
  FROM EMPLOYEE
  WHERE EMP_ID = &사번;
  
  DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
  DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));

END;
/


---------------------------------------------------------------
/*
  실행부
    
    <조건부>
      1) IF [조건식] THEN [실행내용] END IF;
*/
-- 사번을 입력받아 사번, 이름, 급여, 보너스(%) 출력
-- 단, 보너스를 받지 않는 사원은 '보너스를 지급받지 않는 사원입니다.' 으로 표시
DECLARE
  E EMPLOYEE%ROWTYPE;
  
BEGIN
  SELECT *
  INTO E
  FROM EMPLOYEE
  WHERE EMP_ID = &사번;
  
  DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
  IF E.BONUS IS NULL THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
  ELSIF E.BONUS IS NOT NULL THEN DBMS_OUTPUT.PUT_LINE('보너스 : '|| E.BONUS * 100 || '%');
  END IF;
END;
/

-------------------------------------실습문제--------------------------------------------
/*
  레퍼런스변수 : EID, ENAME, DTITLE, NCODE
    참조 컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    
  일반 변수 : TEAM
  
  실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
      단, NCODE값이 KO일 경우, TEAM 변수에 '국내팀'
                   KO가 아닐 경우, TEAM 변수에 '해외팀'
  
  출력 : 사번, 이름, 부서명, 소속
*/
DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
  NCODE LOCATION.NATIONAL_CODE%TYPE;
  TEAM VARCHAR2(10) := 'D';
  
BEGIN
  SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
  INTO EID, ENAME, DTITLE, NCODE
  FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D
      ON E.DEPT_CODE = D.DEPT_ID
    LEFT JOIN LOCATION L
      ON D.LOCATION_ID = L.LOCAL_CODE
  WHERE EMP_ID = &사번;
  
  IF NCODE = 'KO' THEN TEAM := '국내팀';
  ELSE TEAM := '해외팀';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(EID ||', '|| ENAME||', '|| DTITLE ||', '|| TEAM);
  
END;
/
-- IF ELSE-IF
DECLARE
  SCORE NUMBER;
  GRADE CHAR(1);

BEGIN
  SCORE := &점수;
  IF SCORE >= 90 THEN GRADE := 'A';
  ELSIF SCORE >= 80 THEN GRADE := 'B';
  ELSIF SCORE >= 70 THEN GRADE := 'C';
  ELSIF SCORE >= 60 THEN GRADE := 'D';
  ELSE GRADE := 'F';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('점수는 ' || SCORE || '점 이고, 학점은' || GRADE || '입니다.');
END;
/


-------------------------------------실습문제--------------------------------------------
/*
  사용자로부터 사번을 입력바당 사원의 급여를 조회화여 SAL변수에 저장
  500만 이상이면 고급,
  300~499만이면 중급
  나머지는 초급
*/

/*
  CASE WHEN THEN
  
  [FORMAT]
  CASE
    WHEN 1 THEN 1`
    WHEN 2 THEN 2`
    ELSE 3`
  END [AS ALIAS];
*/
-- 사용자로부터 사번을 입력받아 DEPT_CODE를 조회해서
-- DEPT_CODE 가 D1이면 인사관리부 - 이런 식으로 작성
--DECLARE
--  EID EMPLOYEE.EMP_ID%TYPE;
--  DCODE EMPLOYEE.DEPT_CODE%TYPE;
--  DNAME DEPARTMENT.DEPT_TITLE%TYPE;
--
--BEGIN
--  SELECT EMP_ID, DEPT_CODE, DEPT_TITLE
--  INTO EID, DCODE, DNAME
--  FROM EMPLOYEE E
--    JOIN DEPARTMENT D
--    ;
--------------------------------------------------------
/*
  FOR LOOP
*/
BEGIN
  FOR I IN 1..5
  LOOP
    DBMS_OUTPUT.PUT_LINE(I);
  END LOOP;
END;
/

BEGIN
  FOR I IN REVERSE 1..5
  LOOP
    DBMS_OUTPUT.PUT_LINE(I);
  END LOOP;
END;
/

CREATE TABLE TEST(
  TNO NUMBER PRIMARY KEY,
  TDATE DATE
);

CREATE SEQUENCE SEQ_TNO;

BEGIN
  FOR I IN 1..100
  LOOP
    INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
  END LOOP;
END;
/
SELECT * FROM TEST;


-----------------------------------------------------------------------------
DECLARE
  N NUMBER := 1;
  
BEGIN
  WHILE N < 6
  LOOP
    DBMS_OUTPUT.PUT_LINE(N);
    N := N+1;
  END LOOP;
END;
/


----------------------------------------------------------------------------
/*
  EXCEPTION
    예외처리부
    
  [FORMAT]
    EXCEPTION
      WHEN [EXCEPTION_NAME1] THEN [DO_STH1];
      WHEN [EXCEPTION_NAME2] THEN [DO_STH2];
      WHEN [OTHER_EXCEPTION_NAME] THEN [DO_OTHER_STH];
      
    * 시스템 예외 - ORACLE에서 미리 정의
      - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우
      - TOO_MANY_ROWS : SELECT한 결과가 여러 행일 경우
      - ZERO_DIVIDE : 0으로 나눌 때
      - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 경우
*/

-- ZERO_DIVIDE
DECLARE
  RESULT NUMBER;
BEGIN
  RESULT := 10/&숫자;
  DBMS_OUTPUT.PUT_LINE(RESULT);
EXCEPTION
  WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
END;
/

-- DUP_VAL_ON_INDEX
BEGIN
  UPDATE EMPLOYEE
    SET EMP_ID = &사번
  WHERE EMP_NAME = '김새로';
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('중복된 값을 넣을 수 없습니다.');
END;
/


-- 사수번호를 입력바당 사수로 갖고 있는 사원 정보 출력
DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
  SELECT EMP_ID, EMP_NAME
  INTO EID, ENAME
  FROM EMPLOYEE
  WHERE MANAGER_ID = &사수사번;

  DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME);

EXCEPTION
  WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('다중 행이 출력되었습니다.');
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
END;
/
CREATE TABLE EMP_YEARSAL(
  EROW NUMBER PRIMARY KEY,
  EID NUMBER,
  ENAME VARCHAR2(20),
  EYEARSAL NUMBER
);
DROP TABLE EMP_YEARSAL;

CREATE SEQUENCE EMP_SNO;

DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  ESAL EMPLOYEE.SALARY%TYPE;
  EBONUS EMPLOYEE.BONUS%TYPE;
  EROW NUMBER;
  EYEARSAL NUMBER := 0;
  
BEGIN
  FOR TEMP IN (SELECT EMP_SNO.NEXTVAL AS IDX, EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0) AS BONUS FROM EMPLOYEE)
  LOOP
    EROW := TEMP.IDX;
    EID := TEMP.EMP_ID;
    ENAME := TEMP.EMP_NAME;
    EYEARSAL := TEMP.SALARY * (1 + TEMP.BONUS) * 12;
    
    INSERT INTO EMP_YEARSAL VALUES(EROW, EID, ENAME, EYEARSAL);
    END LOOP;
END;
/

SELECT * FROM EMP_YEARSAL;


BEGIN
  FOR DAN IN 2..9
  LOOP
    FOR SU IN 1..9
    LOOP
      IF MOD(DAN,2) = 0 THEN
      DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN*SU);
      END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END;
/



BEGIN
  FOR DAN IN 1..4
  LOOP
    FOR SU IN 1..9
    LOOP
      DBMS_OUTPUT.PUT_LINE(DAN*2 || ' * ' || SU || ' = ' || DAN*2*SU);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END;
/
