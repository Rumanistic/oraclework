/*
  - GROUP BY절
    그룹기준을 제시할 수 있는 구문(해당 그룹별로 여러 그룹으로 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/
SELECT SUM(SALARY)
FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원의 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

SELECT JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

SELECT JOB_CODE, COUNT(CASE WHEN BONUS IS NOT NULL THEN 1 END) AS BONUS, 
  SUM(SALARY), ROUND(AVG(SALARY)), MIN(SALARY), MAX(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

SELECT SUBSTR(EMP_NO, 8, 1), COUNT(*) FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1)
ORDER BY 1;

SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE 
GROUP BY DEPT_CODE, JOB_CODE;

/*
  - HAVING절
*/
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

/*
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000
GROUP BY DEPT_CODE;
*/
SELECT DEPT_CODE, CEIL(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

SELECT DEPT_CODE, SUM(BONUS), COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- HAVING COUNT(BONUS) = 0; COUNT 기준으로 갯수가 0일 때
-- HAVING SUM(BONUS) IS NULL; SUM 기준으로 모든 값이 NULL이라 더한 값이 NULL일 때
/*
  실행 순서
    1. FROM
    2. ON
    3. JOIN
    4. WHERE
    5. GROUP BY
    6. HAVING
    7. SELECT
    8. DISTINCT
    9. ORDER BY
*/
---------------------------------------------------------------------
/*
  집계 함수 : 그룹별 산출된 결과 값에 중간집계를 계산해주는 함수
    ROLLUP : 컬럼 1을 가지고 다시 중계집계를 내는 함수
    CUBE : 컬럼 1을 가지고 중간집계를 내고, 컬럼 2를 가지고도 중간집계를 냄
  [FORMAT]
    [ROLLUP|CUBE](COLUMN1, COLUMN2)
*/
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;

--================================================================--
--                          집합 함수
--================================================================--
/*
  - SET OPERATION
    여러개의 QUERY를 하나의 QUERY로 만드는 연산자
    
    - UNION : OR | 합집합(두 QUERY의 결과값을 더하고(ROW를 이어붙이고), 중복되는 값은 한번만 조회)
    - INTERSECT : AND | 교집합(중복된 결과만 조회)
    - UNION ALL : 합집합 + 교집합(중복된 값이 2번 출력될 수 있다)
    - MINUS : 차집합(선행 QUERY 결과값 - 후행 QUERY 결과값)
*/
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
