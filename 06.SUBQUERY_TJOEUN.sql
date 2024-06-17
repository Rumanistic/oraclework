/*
  - SUBQUERY
    하나의 SQL에 포함된 또 다른 SQL
    
    MAIN SQL의 보조 역할
*/
-- 김정보와 같은 부서의 사원
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (
  SELECT DEPT_CODE
  FROM EMPLOYEE
  WHERE EMP_NAME = '김정보'
);

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
  SELECT CEIL(AVG(SALARY))
  FROM EMPLOYEE
);

--------------------------------------------------------------------
/*
  - 단일 행 서브쿼리 : 서브쿼리의 조회 결과값이 1개일 때 (1행 1열)
  - 다중 행 서브쿼리 : 서브쿼리의 조회 결과값이 여러 행일 때 (다중행 1열)
  - 다중 열 서브쿼리 : 서브쿼리의 조회 결과값이 1행 여러 열일 때(1행 다중열)
  - 다중 행 다중 열 서브쿼리 : 서브쿼리의 조회 결과값이 여러 행 여러 열일 때(다중행 다중열)
    >> 서브쿼리의 종류에 따라 연산자가 달라짐
*/

/* 
  단일 행 서브쿼리 : 일반 비교연산자 사용 가능
*/
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (
  SELECT CEIL(AVG(SALARY))
  FROM EMPLOYEE
);

SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (
  SELECT MIN(SALARY)
  FROM EMPLOYEE
);

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
  SELECT SALARY
  FROM EMPLOYEE
  WHERE EMP_NAME = '박정보'
);

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
  AND SALARY > (
  SELECT SALARY
  FROM EMPLOYEE
  WHERE EMP_NAME = '박정보'
);

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D
    ON E.DEPT_CODE = D.DEPT_ID
WHERE SALARY > (
  SELECT SALARY
  FROM EMPLOYEE
  WHERE EMP_NAME = '박정보'
);

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
  AND DEPT_CODE = (
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '왕정보')
  AND EMP_NAME <> '왕정보';
  
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
  SELECT MAX(SUM(SALARY))
  FROM EMPLOYEE
  GROUP BY DEPT_CODE
);

/* 
  다중 행 서브쿼리
    - 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 반환
      > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
      < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
      
      비교대상 > ANY(값1, 값2, 값3)
      
      비교대상 < ANY(값1, 값2, 값3)
*/
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (
  SELECT JOB_CODE
  FROM EMPLOYEE
  WHERE EMP_NAME IN ('조정연','전지연')
);

---------------------------------------------------------------------------------
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
  AND SALARY > (
    SELECT MIN(SALARY)
    FROM EMPLOYEE E
      JOIN JOB J
        ON E.JOB_CODE = J.JOB_CODE
    WHERE J.JOB_NAME = '과장'
);

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
  JOIN JOB J
    USING(JOB_CODE)
WHERE JOB_CODE = 'J6'
  AND SALARY > ANY(
    SELECT SALARY
    FROM EMPLOYEE E
      JOIN JOB J
        ON E.JOB_CODE = J.JOB_CODE
    WHERE J.JOB_NAME = '과장'
);