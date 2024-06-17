/*
    <함수 FUNCTION>
    전달된 COLUMN값을 읽어들여 함수를 실행한 결과를 반환
    
    - 단일 행 함수 : N개의 값을 읽어들임 -> N개의 결과를 반환 (매 행마다 실행)
    - 그룹 함수 : N개의 값을 읽어들임 -> 1개의 결과를 반환 (모든 행을 받아서 실행)
    
      >> SELECT절에 단일 행 함수와 그룹 함수를 같이 사용할 수 없음
      >> 사용 가능 위치 : SELECT절, WHERE절, HAVING절, ORDER BY절
*/

-----------------------------------단일 행 함수------------------------------------


--==============================================================================--
--                                문자 처리 함수                                 --
--==============================================================================--
/*
    LENGTH / LENGTHB => NUMBER로 반환
    
    LENGTH(COLUMN | 'VARCHAR') : 해당 문자열의 글자 수 반환
    LENGTHB(COLUMN | 'VARCHAR') : 해당 문자열의 BYTE수 반환
      * 한글의 경우 XE버전 기준 : 1글자당 3BYTE
                  EE버전 기준 : 1글자당 2BYTE
      * 그 외 : 1글자당 1BYTE
*/
SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;
----------------------------------------------------------------------------------
/*
    - INSTR : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환 (NUMBER)
      * ORACLE에서 INDEX는 1부터 시작, 찾을 문자가 없으면 0 반환
      
    [표현법]
    INSTR(COLUMN | 'VARCHAR', 'VARCHAR_TO_SEARCH', [OPTION: START_POSITION, [TIMES] ] )
      * START_POSITION : 1(순차접근) | -1(역순접근)
      * TIMES : 찾을 문자열이 몇번째에 있는지 (EX - 1 : 처음 일치하는 | 2 : 두번째로 일치하는 | 3 : 3번째로 일치하는)
*/
SELECT INSTR('JAVASCRIPT_JAVA_ORACLE', 'JAVA')
FROM DUAL;

SELECT INSTR('JAVASCRIPT_JAVA_ORACLE', 'JAVA', -1)
FROM DUAL;

SELECT INSTR('JAVASCRIPT_JAVA_ORACLE', 'JAVA', -1, 2)
FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '_') "UNDERSCORE_POS", INSTR(EMAIL, '@') "AT_SIGN_POS"
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - SUBSTR
      
    [표현법]
    SUBSTR(COLUMN | 'VARCHAR', POSITION, [OPTION: LENGTH] )
      * POSITION : 문자열을 추출할 시작 위치
      * LENGTH : 추출할 문자의 길이
*/
SELECT SUBSTR('ORACLEHTMLCSS', 7) 
FROM DUAL;

SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) 
FROM DUAL;

SELECT SUBSTR('ORACLEHTMLCSS', -7) 
FROM DUAL;

-- EMPLOYEE에서 주민번호에서 성별만 추출
SELECT EMP_NAME 이름, EMP_NO 주민번호, SUBSTR(EMP_NO, 8, 1), 
  CASE
    WHEN SUBSTR(EMP_NO, 8, 1) IN(2, 4) THEN '여'
    WHEN SUBSTR(EMP_NO, 8, 1) IN(1, 3) THEN '남'
  END AS 성별
FROM EMPLOYEE;

SELECT EMP_ID 사원번호, EMP_NAME 이름, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

SELECT EMP_ID 사원번호, EMP_NAME 이름, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3')
ORDER BY 1;

SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL,'@') - 1) AS ID
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - LPAD / RPAD : 문자열 조회 시 통일감있게 하기 위해 사용(RETURN : CHAR)
      
    [표현법]
    [LPAD|RPAD]('VARCHAR', RETURN_VARCHAR_LENGTH, [ADD_CHAR(DEFAULT BLANK)] )
      * 왼쪽, 혹은 오른쪽에 원하는 길이만큼 문자열을 덧붙여서 반환
*/
SELECT EMP_NAME, LENGTH(EMAIL), LPAD(EMAIL, 24)
FROM EMPLOYEE;

SELECT EMP_NAME, LENGTH(EMAIL), RPAD(EMAIL, 24, '#')
FROM EMPLOYEE;

-- EMPLOYEE에서 사번, 사원명, 주민번호를 출력, 단 주민번호는 뒷부분을 한자리만 표시하고 마스킹 처리한다
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') + 1), 14, '*') AS 주민번호
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 나머지를 반환
    - TRIM : LTRIM과 RTRIM을 동시에 수행
      
    [표현법]
    [LTRIM|RTRIM]('VARCHAR', [OPTION: REMOVE_CHAR(DEFAULT BLANK)] )
      * 왼쪽, 혹은 오른쪽에 원하는 길이만큼 문자열을 덧붙여서 반환
    TRIM([OPTION: LEADING | TRAILING | BOTH] REMOVE_CHAR FROM 'VARCHAR')
      * TRIM에서는 한 문자로만 제거 가능
*/
SELECT LTRIM('            TJOEUN           ')|| 'HAKWON'
FROM DUAL;

SELECT RTRIM('            TJOEUN           ')|| 'HAKWON'
FROM DUAL;

SELECT TRIM('            TJOEUN           ')|| 'HAKWON'
FROM DUAL;

SELECT LTRIM('JAVA JAVASCRIPT', 'JAVA')
FROM DUAL;

-- TRIM에서 제거하고자 하는 문자는 각 문자와 일치하는 모든 문자를 제거; A, S, D, F
-- 그 외의 문자가 나올 시 출력
SELECT LTRIM('ASFASDFASDFAWQRA', 'ASDF')
FROM DUAL;

SELECT EMP_NAME, RTRIM(EMP_NAME, '정보')
FROM EMPLOYEE;

-- DEFAULT는 양쪽 다
SELECT TRIM(' ' FROM '            TJOEUN           ')|| 'HAKWON'
FROM DUAL;
SELECT TRIM(LEADING ' ' FROM '            TJOEUN           ')|| 'HAKWON'
FROM DUAL;
SELECT TRIM(TRAILING ' ' FROM '            TJOEUN           ')|| 'HAKWON'
FROM DUAL;

----------------------------------------------------------------------------------
/*
    - LOWER / UPPER / INITCAP : 문자열을 [소 / 대 / 앞글자만 대]문자로 변환
      
    [표현법]
    [LOWER | UPPER | INITCAP]('VARCHAR')
*/
SELECT LOWER('jAVA jAVAsCRIPT oRACLE')
FROM DUAL;
SELECT UPPER('jAVA jAVAsCRIPT oRACLE')
FROM DUAL;
SELECT INITCAP('jAVA jAVAsCRIPT oRACLE')
FROM DUAL;

SELECT UPPER(EMAIL)
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - CONCAT : 문자열 두개를 하나로 합친 후 반환
      
    [표현법]
    CONCAT('VARCHAR1', 'VARCHAR2')
*/
SELECT CONCAT('ORACLE', ' 배우기')
FROM DUAL;

----------------------------------------------------------------------------------
/*
    - REPLACE : 문자열에서 특정 문자를 새로운 문자로 치환
      
    [표현법]
    REPLACE('VARCHAR', 'FROM_VARCHAR', 'TO_VARCHAR')
*/
SELECT EMAIL, REPLACE(EMAIL, 'tjoeun.or.kr', 'naver.com')
FROM EMPLOYEE;


----------------------------------------------------------------------------------
--==============================================================================--
--                                숫자 처리 함수                                 --
--==============================================================================--
/*
    - ABS : 절대값 반환
      
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-6) FROM DUAL;

----------------------------------------------------------------------------------
/*
    - MOD : 두 수를 나눈 나머지 반환
      
    [표현법]
    MOD(NUMBER, TARGET_NUMBER)
*/
SELECT MOD(6, 4) FROM DUAL;

----------------------------------------------------------------------------------
/*
    - ROUND : 반올림한 결과 반환
      
    [표현법]
    ROUND(NUMBER, [POSITION])
*/
SELECT ROUND(123.4567) FROM DUAL;
SELECT ROUND(123.4567, 2) FROM DUAL;

----------------------------------------------------------------------------------
/*
    - CEIL : 올림한 결과 반환
      
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.4567) FROM DUAL;
SELECT CEIL(-123.4567) FROM DUAL;

----------------------------------------------------------------------------------
/*
    - TRUNC : 내림한 결과 반환
      
    [표현법]
    TRUNC(NUMBER, [POSITION])
*/
SELECT TRUNC(123.4567) FROM DUAL;
SELECT TRUNC(-123.4567, 2) FROM DUAL;


----------------------------------------------------------------------------------
--==============================================================================--
--                                날짜 처리 함수                                 --
--==============================================================================--
----------------------------------------------------------------------------------
/*
    - MONTHS_BETWEEN : 날짜 사이의 개월 수를 반환
      
    [표현법]
    MONTHS_BETWEEN(FROM_DATETIME, TO_DATETIME)
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE "근무일수"
FROM EMPLOYEE;
SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE - HIRE_DATE) "근무일수"
FROM EMPLOYEE;
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "근무개월수"
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - ADD_MONTHS : 특정 날짜에 해당 숫자만큼 개월수를 더해서 반환
      
    [표현법]
    ADD_MONTHS(DATETIME, NUMBER)
*/
SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL;

SELECT EMP_NAME 사원명, HIRE_DATE 입사일, ADD_MONTHS(HIRE_DATE, 6) "정직원 전환일"
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - NEXT_DAY : 특정 날짜 이후의 가장 가까운 해당 요일의 날짜를 반환
      
    [표현법]
    NEXT_DAY(DATETIME, DATE['VARCHAR' | NUMBER])
*/

SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;

--ALTER SESSION SET NLS_LANGUAGE = AMERICAN; --> 시스템 언어를 영어로 변경, 날짜형식이나 콘솔 출력 내용 등에 해당됨
--ALTER SESSION SET NLS_LANGUAGE = KOREAN; --> 한국어로 변경 

----------------------------------------------------------------------------------
/*
    - LAST_DAY : 해당 월의 마지막 날짜를 반환
      
    [표현법]
    LAST_DAY(DATETIME)
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

----------------------------------------------------------------------------------
/*
    - EXTRACT : 특정 날짜로부터 년도|월|일 값을 추출하여 반환
      
    [표현법]
    EXTRACT([YEAR | MONTH | DAY] FROM DATETIME)
*/
SELECT EXTRACT(DAY FROM SYSDATE) FROM DUAL;

SELECT EMP_NAME AS 사원명
  , EXTRACT(YEAR FROM HIRE_DATE) AS 입사년도
  , EXTRACT(MONTH FROM HIRE_DATE) AS 입사월
  , EXTRACT(DAY FROM HIRE_DATE) AS 입사일
FROM EMPLOYEE
ORDER BY 입사년도, 입사월, 입사일, 사원명;



--==============================================================================--
--                                                        형 변환 함수                                                                   --
--==============================================================================--
----------------------------------------------------------------------------------
/*
    - TO_CHAR : 숫자 | 날짜 타입의 데이터를 문자열로 변환
              반환 결과를 특정 형식에 맞게 출력 가능
      
    [표현법]
    TO_CHAR(NUMBER|DATETIME, [FORMAT])
*/

/*
  TO_CHAR : NUMBER
    [FORMAT]
      * 9 : 해당 자리의 숫자를 의미
        => 해당 자리에 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
      * 0 : 해당 자리의 숫자를 의미
        => 해당 자리에 값이 없을 경우 0으로 표시, 숫자의 길이를 고정적으로 표시할 때 사용
      * [PREFIX|SUFFIX] 'L' : LOCAL(지역) --> 지역의 화폐 단위가 나옴
      * FM : 
*/
-- TO_CHAR로 형변환 해도 수식계산하면 자동으로 NUMBER로 변환됨
SELECT TO_CHAR(1234, '999999') AS "999999", TO_CHAR(1234, '000,000L') AS "000000" FROM DUAL;
SELECT EMP_NAME, TO_CHAR(SALARY, '99,999,999,999L'), TO_CHAR(SALARY*12, '99,999,999,999L')
FROM EMPLOYEE
ORDER BY 3 DESC, 1 ASC;

SELECT TO_CHAR(12.3546, 'FM9999999.9999999999'), TO_CHAR(12.3546, 'FM9990.99') FROM DUAL;
SELECT TO_CHAR(0.10000, 'FM999.99999999') FROM DUAL;

/*
  TO_CHAR : DATETIME
    [FORMAT]
      * AM|PM : 현재 시간에 따라 오전/오후 출력
      * AM|PM HH:MI:SS : 12시간 형식으로 표시
      * HH24:MI:SS : 24시간 형식으로 표시
      * YYYY-MM-DD DAY : "4자리 연도-월-일 요일" 형식으로 표시
      * YY : 무조건 20XX 년도를 표시
      * RR : 50보다 크면 19XX년도, 작으면 20XX년도 표시
*/
SELECT TO_CHAR(SYSDATE, 'AM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM', 'NLS_DATE_LANGUAGE=AMERICAN') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON YYYY"년"') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD') FROM DUAL;

SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'DL')
FROM EMPLOYEE
ORDER BY EMP_ID;

SELECT TO_CHAR(HIRE_DATE, 'YYYY'),
  TO_CHAR(HIRE_DATE, 'YY'),
  TO_CHAR(HIRE_DATE, 'RRRR'),
  TO_CHAR(HIRE_DATE, 'RR'),
  TO_CHAR(HIRE_DATE, 'YEAR')
FROM EMPLOYEE;

-- 환경설정 : 도구 -> 환경설정 -> 데이터베이스 -> NLS -> DATE FORMAT : RRRR/MM/DD로 변경 
SELECT TO_DATE('981213', 'RR/MM/DD')
  , TO_DATE('981213', 'YY/MM/DD')
  , TO_DATE('221213', 'RR/MM/DD')
  , TO_DATE('221213', 'YY/MM/DD') FROM DUAL;
  
SELECT TO_CHAR(SYSDATE, 'MM') AS "월 숫자만"
  , TO_CHAR(SYSDATE, 'MON') AS "N월_A"
  , TO_CHAR(SYSDATE, 'MONTH') AS "N월_B"
  , TO_CHAR(SYSDATE, 'RM') AS "로마자" FROM DUAL;
  
SELECT TO_CHAR(SYSDATE, 'DDD') AS 연단위
  , TO_CHAR(SYSDATE, 'DD') AS 월단위
  , TO_CHAR(SYSDATE, 'D') AS 주단위 FROM DUAL;
  
/*
  TO_DATE : 숫자나 문자를 날짜타입으로 변환
  
  [FORMAT]
  TO_DATE(NUMBER|DATETIME, [FORMAT])
    * AM|PM : 현재 시간에 따라 오전/오후 출력
    * AM|PM HH:MI:SS : 12시간 형식으로 표시
    * HH24:MI:SS : 24시간 형식으로 표시
    * YYYY-MM-DD DAY : "4자리 연도-월-일 요일" 형식으로 표시
    * YY : 무조건 20XX 년도를 표시
    * RR : 50보다 크면 19XX년도, 작으면 20XX년도 표시
*/
SELECT TO_DATE(20240613) FROM DUAL;
SELECT TO_DATE(240613) FROM DUAL;

-- 날짜로 변경할 숫자를 넣을 때 맨 앞이 0일 경우 LITERAL 에러가 발생
SELECT TO_DATE(20010610) FROM DUAL;
SELECT TO_DATE('001213') FROM DUAL;

-- TO_DATE를 년월일 시분초 형식으로 출력 시 시분초 부분이 보이지 않을 경우, TO_CHAR로 표시 형변환
SELECT TO_CHAR(TO_DATE('070723 020814', 'YYMMDD HHMISS'), 'YY-MM-DD HH:MI:SS') FROM DUAL;

/*
  - TO_NUMBER : 문자를 숫자 타입으로 반환
  
  [FORMAT]
    TO_NUMBER('VARCHAR' [FORMAT])
*/
SELECT TO_NUMBER('1328135987') FROM DUAL;

SELECT TO_NUMBER('10005000') FROM DUAL;

--==============================================================================--
--                              NULL 처리 함수                                   --
--==============================================================================--
----------------------------------------------------------------------------------
/*
    - NVL : NULL일 경우 반환할 값 지정
      
    [FORMAT]
    NVL(COLUMN, IF_IS_NULL_THEN)
*/
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS 연봉, (SALARY *(1 + NVL(BONUS, 0))) * 12 AS 연봉1
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음') AS DEPT_CODE
FROM EMPLOYEE;

/*
    - NVL2 : NULL일 경우, NULL이 아닐 경우 반환할 값 지정
      
    [FORMAT]
    NVL2(COLUMN, IF_IS_NOT_NULL_THEN, IF_IS_NULL_THEN)
*/
SELECT EMP_NAME, SALARY, BONUS, SALARY*NVL2(BONUS, 0.5, 0.1)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음', '부서없음')
FROM EMPLOYEE;

/*
    - NULLiF : 두 대상을 비교해서 일치하면 NULL, 일치하지 않으면 1 반환
      
    [FORMAT]
    NUMIF(TARGET_A, TARGET_B)
*/


--==============================================================================--
--                              NULL 처리 함수                                   --
--==============================================================================--
----------------------------------------------------------------------------------
/*
  - DECODE(COLUMN|CALCULATION|FUNCTION, CASE1, RETRUN1, CASE2, RETURN2..., ELSE[IN_NO_CONDITIONS])
  
*/
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1) , '1', '남', '2', '여', '3', '남', '4', '여') AS 성별
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, JOB_CODE, DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) NEW_SALARY
FROM EMPLOYEE;


/*
  - CASE 
        WHEN CONDITION1 THEN RESULT1
        WHEN CONDITION2 THEN RESULT2
        ELSE RESULT3
    END [AS ALIAS]
*/
SELECT EMP_NAME, SALARY,
      CASE
        WHEN SALARY >= 5000000 THEN '고급'
        WHEN SALARY >= 3500000 THEN '중급'
        ELSE '초급'
      END AS 급수
FROM EMPLOYEE;


--==============================================================================--
--                                GROUP 함수                                    --
--==============================================================================--
/*
  - SUM(COLUMN) : 컬럼들의 값의 합계
*/
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

SELECT SUM(SALARY * (NVL2(BONUS, BONUS, 0)+1) * 12) 연봉
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';


/*
  - AVG(COLUMN) : 컬럼들의 값의 평균
*/
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

/*
  - MIN|MAX(COLUMN) : 컬럼들의 값의 최소/최대값
*/
SELECT MIN(SALARY), MAX(SALARY)
FROM EMPLOYEE;

/*
  - COUNT(COLUMN) : 컬럼들의 값의 평균
  
  [FORMAT]
    COUNT(*|COLUMN|DISTINCT COLUMN)
*/
-- 모든 라인
SELECT COUNT(*)
FROM EMPLOYEE;

-- NULL 제외
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 중복 제외
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

SELECT COUNT(EMP_NAME)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

SELECT DEPT_CODE, COUNT(*) AS "부서인원수"
FROM EMPLOYEE 
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE;

------------------------------------------   종합문제
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME, TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'RR')||'년' AS 생년, 
  TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'MM')||'월' AS 생월, 
  TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'DD')||'일' AS 생일
FROM EMPLOYEE;

-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME AS 사원명, RPAD(SUBSTR(EMP_NO, 1, 7), 14, '*') AS 주민번호
FROM EMPLOYEE;

-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME AS 사원명, ABS(FLOOR(HIRE_DATE - SYSDATE)) AS "근무일수1", ABS(FLOOR(SYSDATE - HIRE_DATE)) AS "근무일수2"
FROM EMPLOYEE;

-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT * 
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = 1;

-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(HIRE_DATE, 'RRRR')) >= 20;
-- MONTHS_BETWEEN(SYSDATE, HIRE_DATE) > 20*12;  가 더 편함

-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME 사원명, TO_CHAR(SALARY, 'L999,999,999') 급여
FROM EMPLOYEE;
-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME AS 직원명, DEPT_CODE AS 부서코드,
  (TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'RRRR')||'년 '||
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'MM')||'월 '||
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'DD')||'일') AS 생년월일, 
    TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RR/MM/DD'), 'RRRR') AS 나이
FROM EMPLOYEE;
-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
SELECT EMP_ID AS 사번, EMP_NAME AS 직원명, DEPT_CODE AS 부서코드,
  CASE
    WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
  END AS 총무부
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE;
-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_NAME, 
  SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') - 1) AS EMP_NO_FIRST, 
  SUBSTR(EMP_NO, INSTR(EMP_NO, '-') + 1, 14) AS EMP_NO_LAST,
  TO_NUMBER(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') - 1)) + TO_NUMBER(SUBSTR(EMP_NO, INSTR(EMP_NO, '-') + 1, 14)) AS EMP_NO_SUM
FROM EMPLOYEE;
-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM(SALARY * NVL(1 + BONUS, 1) * 12) AS "연봉 합"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2002년, 2003년, 2004      *** 다시 확인해볼것 ***
SELECT COUNT(*) AS "전체 직원 수",
  SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2001' THEN 1 ELSE 0 END) AS "2001년",
  SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2002' THEN 1 ELSE 0 END) AS "2002년",
  SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2003' THEN 1 ELSE 0 END) AS "2003년",
  SUM(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = '2004' THEN 1 ELSE 0 END) AS "2004년"
FROM EMPLOYEE;