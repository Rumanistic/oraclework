/*
    ' ' 홑따옴표 : 문자열
    " " 쌍따옴표 : 컬럼명
*/

/*
    <SELECT>
    데이터 조회 시 사용
    
    >> RESULT SET : SELECT 구문을 통해서 조회된 결과물
    
    [표현법]
    SELECT [COLUMN_NAME], [COLUMN_NAME], ....
    FROM [TABLE_NAME];
*/

-- EMPLOYEE 테이블의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;

SELECT *
FROM JOB;

-- EMPLOYEE 테이블에서 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- DEPARTMENT 테이블에서 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

------------------실습문제------------------
-- 1. JOB 테이블에 직급명만 조회
SELECT JOB_NAME AS "직급명"
FROM JOB;

-- 2. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT *
FROM DEPARTMENT;

-- 3. DEPARTMENT 테이블의 부서코드, 부서명만 조회
SELECT DEPT_ID AS "부서코드", DEPT_TITLE AS "부서명"
FROM DEPARTMENT;

-- 4. EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME AS "사원명", EMAIL AS "이메일", PHONE AS "전화번호", HIRE_DATE AS "입사일", SALARY AS "급여"
FROM EMPLOYEE;

-------------------------------------------------------------------------
SELECT J.JOB_NAME, E.*
FROM EMPLOYEE E
INNER JOIN JOB J
ON J.JOB_CODE = E.JOB_CODE;
-------------------------------------------------------------------------
/*
    <COLUMN 값을 통한 산술연산>
    SELECT절의 컬럼명 작성부분에 산술연산 기술 가능
*/
-- EMPLOYEE 테이블에서 사원명, 사원의 연봉(SALARY * 12) 조회
SELECT EMP_NAME AS "사원명", (SALARY * 12) AS "연봉"
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스
SELECT EMP_NAME AS "사원명", SALARY AS "급여", BONUS AS "보너스"
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉
SELECT EMP_NAME AS "사원명", SALARY AS "급여", BONUS AS "보너스"
    , (SALARY * 12) AS "연봉", ((SALARY + (SALARY*BONUS)) * 12) AS "보너스 포함 연봉"
FROM EMPLOYEE;
    --> NULL 이 포함된 컬럼에 산술연산 시 결과는 전부 NULL; 별도로 처리해줘야 함

-- EMPLOYEE 테이블의 사원명, 입사일, 오늘까지의 근무일수(오늘날짜 - 입사일)
-- DATE형태끼리도 연산 가능 : 결과값은 일단위
SELECT EMP_NAME 사원명, HIRE_DATE AS "입사일", ROUND(SYSDATE - HIRE_DATE) AS "근무일수"
FROM EMPLOYEE;
    --> 오늘날짜의 초단위까지 값이 처리되기 때문에 소수점 단위로 나옴
-------------------------------------------------------------------------
/*
    <COLUMN 명에 별칭 지정하기>
    산술 연산 시 컬럼명에 산술에 들어간 수식대로 표현됨
    
    [표현법]
    [COLUMN_NAME] (AS(ALIAS)있어도 되고 없어도 되고) [COLUMN ALIAS] <-- 한글도 됨!
    [COLUMN_NAME] "[COLUMN ALIAS INCLUDE !@#$%^ ~]"
        ㄴ--> 특수문자 혹은 공백이 포함되면 쌍따옴표로 감싸줘야함!
*/
-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉(원), 보너스를 포함한 연봉: 총 연봉 별칭 부여
SELECT EMP_NAME "사원명", SALARY "급여", BONUS "보너스"
    , (SALARY * 12) "연봉(원)", ((SALARY + (SALARY*BONUS)) * 12) "총 연봉"
FROM EMPLOYEE;

-------------------------------------------------------------------------
/*
    <LITERAL>
    임의로 지정한 문자열 ('')
    
    SELECT 절에 LITERAL을 넣으면 마치 테이블에 존재하는 데이터처럼 조회 가능
*/
-- EMPLOYEE 사번, 사원명, 급여 조회 - 컬럼을 하나 만들어 급여 옆에 원을 출력
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM EMPLOYEE;

/*
    <연결 연산자 : ||>
    여러 컬럼값을 마치 하나의 컬럼값인것처럼 연결하거나, 컬럼값과 리터럴을 연결 할 수 있음
*/
-- EMPLOYEE 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

SELECT EMP_NAME || '님의 월급은 ' || SALARY || '원 입니다' AS OUTPUT
FROM EMPLOYEE;

-- EMPLOYEE 사번, 사원명, 급여 조회 - 급여에 원을 붙여서 출력
SELECT EMP_ID, EMP_NAME, SALARY || '원' AS 급여
FROM EMPLOYEE;


-- EMPLOYEE 부서코드 중복 제거 저회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- EMPLOYEE 직급코드 중복 제거 저회
SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE;

-------------------------------------------------------------------------
/*
    <WHERE 절>
    조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회 시
    WHERE절에 조건식을 사용
    
    [표현법]
    SELECT [COLUMN_NAME], ...
    FROM [TABLE_NAME]
    WHERE [QUERY RULE]
    
    - 비교 연산자
    >, <, >=, <=    --> 대소 비교
    =               --> 같다
    !=, ^=, <>      --> 같지 않다
*/
-- EMPLOYEE에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드 조회
SELECT EMP_NAME, SALARY, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원들의 사원명, 이메일, 부서코드 조회
SELECT EMP_NAME, EMAIL, DEPT_CODE 
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D1';
--WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE에서 급여가 400만 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 4000000;

-- EMPLOYEE에서 재직중인 사원의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE ENT_YN = 'N';


------------------실습문제------------------
-- 1. 급여가 300만 이상인 사원들의 사원명, 급여, 입사일, (연봉) 조회
SELECT EMP_NAME 사원명, SALARY 급여, HIRE_DATE 입사일, SALARY*12 AS 연봉
FROM EMPLOYEE
WHERE SALARY >= 3000000;
-- 2. 연봉이 5000만 이상인 사원들의 사원명, 급여, (연봉), 부서코드 조회
SELECT EMP_NAME 사원명, SALARY 급여, SALARY*12 AS 연봉, DEPT_CODE 부서코드
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;
-- 3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, (퇴사여부) 조회
SELECT EMP_NO 사번, EMP_NAME 사원명, JOB_CODE 직급코드, ENT_YN 퇴사여부
FROM EMPLOYEE
WHERE JOB_CODE <> 'J3';

-- EMPLOYEE에서 부서코드가 'D9'이면서 급여가 500만 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NO, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'
    AND SALARY >= 5000000;

-- EMPLOYEE에서 부서코드가 'D9'이거나 급여가 300만 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NO, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'
    OR SALARY >= 3000000;
    
-- EMPLOYEE에서 급여가 350만 이상 600만원 이하인 사원들의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_NO, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-------------------------------------------------------------------------
/*
    <BETWEEN AND>
    
    [표현법]
    WHERE [COLUMN] BETWEEN [EXPRESSION_A] AND [EXPRESSION_B]
*/
-- 입사일이 2000년 이전에 들어온 사원의 모든 컬럼을 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '1990/01/01' AND '1999/12/31';

-------------------------------------------------------------------------
/*
    <LIKE>
    비교하고자 하는 컬럼값이 내가 제시한 특정 패턴에 일치하는 경우 조회
    
    [표현법]
    WHERE [COLUMN] LIKE '[EXPRESSION_A]'
        WILDCARD: '%'(0글자 이상), '_'(1글자 고정)
        
        LIKE 'A%' --> A로 시작하는 모든 문자열
        LIKE '%A' --> A로 끝나는 모든 문자열
        LIKE '%A%' --> A가 포함된 모든 문자열
        
        LIKE 'A_' --> A로 시작하며 언더스코어 개수 만큼 문자가 존재하는 모든 문자열
        LIKE '_A' --> A로 끝나며 언더스코어 개수 만큼 문자가 존재하는 모든 문자열
        LIKE '_A_' --> A를 포함하며 언더스코어 개수 만큼 문자가 존재하는 모든 문자열
*/
SELECT EMP_NAME, SALARY, HIRE_DATE 
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

SELECT EMP_NAME, EMAIL, HIRE_DATE 
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

SELECT EMP_NAME, EMAIL, HIRE_DATE 
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- '&' 앰퍼샌드 기호는 이스케이프 문자로 쓰지 마라
SELECT EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '%\_%' ESCAPE '\';


------------------실습문제------------------
-- 1. EMPLOYEE에서 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';
-- 2. EMPLOYEE에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
-- 3. EMPLOYEE에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%'
    AND SALARY >= 2400000;
-- 4. DEPARTMENT에서 해외영업부인 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%부';

-------------------------------------------------------------------------
/*
    <IS NULL / NOT NULL>
    컬럼값에 NULL이 있을 경우 NULL값 비교에 사용하는 연산자    
*/
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL
    AND BONUS IS NOT NULL;

SELECT EMP_NAME, SALARY, BONUS, 
    CASE
        WHEN BONUS IS NULL THEN SALARY * 12
        WHEN BONUS IS NOT NULL THEN (SALARY + SALARY * BONUS) * 12
    END AS 연봉
FROM EMPLOYEE;

-------------------------------------------------------------------------
/*
    <IN / NOT IN>
    IN : 지정한 조건 값에 해당하는 값이 컬럼에 존재할 경우 조회
    NOT IN : 지정한 조건 값에 해당하지 않는 모든 값을 조회
*/
-- EMPLOYEE에서 부서코드가 D5, D6, D8인 사원들의 서원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D8');

-------------------------------------------------------------------------
/*
    <연산자 우선순위>
    1. ( )
    2. 산술연산자
    3. 연결연산자
    4. 비교연산자
    5. IS NULL / LIKE 'PATTERNS' / IN
    6. BETWEEN A AND B
    7. NOT
    8. AND
    9. OR
*/
-- *** AND가 OR보다 순위가 높다
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J7' 
  OR JOB_CODE = 'J2' 
  AND SALARY >= 2000000;

------------------실습문제------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수번호, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL
  AND DEPT_CODE IS NULL;
-- 2. 연봉(보너스포함X)이 3000만 이상이고 보너스를 받지 않은 사원들의 사번, 사원명, 연봉, 보너스 조회
SELECT EMP_ID, EMP_NAME, (SALARY * 12) AS 연봉, BONUS
FROM EMPLOYEE
WHERE SALARY * 12 >= 30000000
  AND BONUS IS NULL;
-- 3. 입사일이 95/01/01 이상이고, 부서배치를 받은 사원들의 사번, 사원명, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01'
  AND DEPT_CODE IS NOT NULL;
-- 4. 급여가 200만 이상 500만 이하이고 입사일이 01/01/01 이상이고 보너스를 받지 않는 사원들의 
--    사번, 사원명, 급여, 입사일, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000
  AND HIRE_DATE >= '01/01/01'
  AND BONUS IS NULL;
-- 5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 사번, 사원명, 급여, 보너스 포함 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY, (SALARY + (SALARY * BONUS)) * 12 AS "총 연봉"
FROM EMPLOYEE
WHERE (SALARY + (SALARY * BONUS)) * 12 IS NOT NULL
  AND EMP_NAME LIKE '%하%';
  
  -------------------------------------------------------------------------
/*
    <ORDER BY 절>
    
    [표현법]
    ORDER BY [COLUMN_NAME | COLUMN_NUMBER | ALIAS] [ASC | DESC] [NULLS FIRST(DESC DEFAULT) | LAST(ASC DEFAULT)]
*/
SELECT *
FROM EMPLOYEE
ORDER BY BONUS ASC NULLS FIRST, 2 ASC;


SELECT EMP_NAME, SALARY * 12 연봉
FROM EMPLOYEE
ORDER BY 연봉 DESC;
-- 1. FROM절 TABLE을 모두 가져옴
-- 2. SELECT절의 COLUMN 데이터를 조회함
-- 3. ORDER BY절의 정렬 기준으로 데이터를 출력함

------------------------------- 종합 문제 ----------------------------------
-- 1. JOB테이블에서 JOB 테이블의 모든 정보 조회
SELECT * 
FROM JOB;
-- 2. JOB테이블에서 JOB 테이블의 직급 이름 조회
SELECT JOB_NAME "직급 이름"
FROM JOB;
-- 3. DEPARTMENT테이블에서 DEPARTMENT 테이블의 모든 정보 조회
SELECT *
FROM DEPARTMENT;
-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;
-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;
-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
SELECT EMP_NAME 이름, SALARY * 12 AS "연봉"
  , (SALARY + SALARY * BONUS)*12 AS "총 수령액"
  , (SALARY + SALARY * BONUS)*12 - (SALARY * 12 * 0.03) AS "실 수령액"
FROM EMPLOYEE;
-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE JOB_CODE = 'J1';
-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
SELECT EMP_NAME, SALARY, (SALARY + SALARY * BONUS)*12 - (SALARY * 12 * 0.03) AS "실 수령액", HIRE_DATE
FROM EMPLOYEE
WHERE (SALARY + SALARY * BONUS)*12 - (SALARY * 12 * 0.03) >= 50000000;
-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000
  AND JOB_CODE = 'J2';
-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5')
  AND HIRE_DATE < '2002/01/01';
-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '1990/01/01' AND '2001/01/01';
-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';
-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '____\_%' ESCAPE '\'
  AND DEPT_CODE IN('D9', 'D6')
  AND HIRE_DATE BETWEEN '1990/01/01' AND '2000/12/01'
  AND SALARY >= 2700000;