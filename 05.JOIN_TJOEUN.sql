/*
  - JOIN
  
  => 관계형 데이터베이스는 테이블간의 관계를 맺을 수 있다
  
  오라클 전용 구문, ANSI 기준이 있음
  
                    [JOIN 용어 정리]
  -------------------------------------------------------------------------------------
          오라클 전용         |         ANSI 표준                                        
  -------------------------------------------------------------------------------------
          등가 조인           |         내부 조인(INNER JOIN) -> JOIN USING | ON         
        EQUAL JOIN          |         자연 조인(NATURAL JOIN) -> JOIN USING             
  -------------------------------------------------------------------------------------
          포괄 조인           |         왼쪽 외부 조인(LEFT OUTER JOIN)                   
      LEFT OUTER JOIN        |         오른쪽 외부 조인(RIGHT OUTER JOIN)                
      RIGHT OUTER JOIN       |         전체 외부 조인(FULL OUTER JOIN)                   
  -------------------------------------------------------------------------------------
          자체 조인           |         JOIN ON                                         
        비 등가 조인          |                                                         
  -------------------------------------------------------------------------------------
        카테시안 곱          |           교차 조인(CROSS JOIN)                            
  -------------------------------------------------------------------------------------
*/

---------------------------------------------------------------------------------------
/*
  - 등가 조인
*/
SELECT EMP_ID, EMP_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID;

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
/*
  >> ANSI 구문
    - FROM절에 기준이 되는 테이블을 하나만 기술
    - JOIN할 테이블을 기술, 매칭할 COLUMN을 기술
    - JOIN USING(같은경우) | JOIN ON(다른경우)
*/
SELECT EMP_ID, EMP_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E 
  JOIN DEPARTMENT D
  ON (DEPT_CODE = DEPT_ID);

SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
  JOIN JOB J
--  USING(JOB_CODE);
  ON(E.JOB_CODE = J.JOB_CODE);

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND J.JOB_NAME = '대리';
  
---------------------------------------------------------------------------------------
-- 1.
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NVL(BONUS, 0)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
  AND DEPT_TITLE = '인사관리부';
  
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NVL(BONUS, 0)
FROM EMPLOYEE E
  JOIN DEPARTMENT D
  ON E.DEPT_CODE = D.DEPT_ID
WHERE DEPT_TITLE = '인사관리부';

-- 2.
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;

SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT D
  JOIN LOCATION L
  ON D.LOCATION_ID = L.LOCAL_CODE;
  
-- 3.
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
  AND BONUS IS NOT NULL;
  
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E
  JOIN DEPARTMENT D
  ON E.DEPT_CODE = D.DEPT_ID
WHERE BONUS IS NOT NULL;

-- 4.
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
  AND DEPT_TITLE NOT IN ('총무부');

SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE E
  JOIN DEPARTMENT D
  ON E.DEPT_CODE = D.DEPT_ID
WHERE DEPT_TITLE NOT IN ('총무부');

---------------------------------------------------------------------------------------
/*
  - 포괄 조인 / 외부 조인
    - 두 테이블간의 JOIN 시 일치하지 않는 행도 포함시켜 조회
*/
-- 사원명, 부서명, 급여, 연봉(보너스 제외)
-- --> 왼쪽테이블을 기준으로 오른쪽 테이블의 데이터를 연결
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 AS 연봉
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 AS 연봉
FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D
  ON E.DEPT_CODE = D.DEPT_ID;

-- --> 오른쪽테이블을 기준으로 왼쪽 테이블의 데이터를 연결
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 AS 연봉
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 AS 연봉
FROM EMPLOYEE E
  RIGHT JOIN DEPARTMENT D
  ON E.DEPT_CODE = D.DEPT_ID;
  
-- --> 두 테이블을 기준으로 모든 데이터를 연결
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 AS 연봉
FROM EMPLOYEE E
  FULL JOIN DEPARTMENT D
  ON E.DEPT_CODE = D.DEPT_ID;
  
---------------------------------------------------------------------------------------
/*
  - 비등가 조인
    - 매칭시킬 컬럼에 대한 조건식 작성 시 '='를 사용하지 않는 JOIN문
*/
-- 사원명, 급여, 급여레벨 조회
SELECT EMP_NAME, SALARY, SAL_LEVEL 
FROM EMPLOYEE
  JOIN SAL_GRADE
  ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
  
SELECT EMP_NAME, SALARY, SAL_LEVEL 
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;


---------------------------------------------------------------------------------------
/*
  - SELF JOIN
    - 같은 테이블을 다시 한번 조인하는 경우
*/
-- 사번, 사원명, 부서, 사수 정보 조회
-- --> ANSI 구문
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, A.MANAGER_ID, B.EMP_NAME AS MANAGER_NAME, B.DEPT_CODE AS MANAGER_DEPT_CODE
FROM EMPLOYEE A
  JOIN EMPLOYEE B
  ON A.MANAGER_ID IN B.EMP_ID;
-- 전체사원 조회
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, A.MANAGER_ID, B.EMP_NAME AS MANAGER_NAME, B.DEPT_CODE AS MANAGER_DEPT_CODE
FROM EMPLOYEE A
  LEFT JOIN EMPLOYEE B
  ON A.MANAGER_ID IN B.EMP_ID;
  
-- --> ORACLE 구문
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, A.MANAGER_ID, B.EMP_NAME AS MANAGER_NAME, B.DEPT_CODE AS MANAGER_DEPT_CODE
FROM EMPLOYEE A, EMPLOYEE B
WHERE A.MANAGER_ID IN B.EMP_ID(+);
-- 전체사원 조회  
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, A.MANAGER_ID, B.EMP_NAME AS MANAGER_NAME, B.DEPT_CODE AS MANAGER_DEPT_CODE
FROM EMPLOYEE A, EMPLOYEE B
WHERE A.MANAGER_ID IN B.EMP_ID(+);


---------------------------------------------------------------------------------------
/*
  - 다중 조인
    - 2개 이상의 테이블을 조인하는 경우
*/
-- 사번, 사원명, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, NATIONAL_NAME, LOCAL_NAME
FROM EMPLOYEE E
  JOIN DEPARTMENT D
    ON E.DEPT_CODE = D.DEPT_ID
  JOIN JOB J
    ON E.JOB_CODE = J.JOB_CODE
  JOIN LOCATION L
    ON D.LOCATION_ID = L.LOCAL_CODE
  JOIN NATIONAL N
    ON L.NATIONAL_CODE = N.NATIONAL_CODE;
  
SELECT EMP_NAME, SALARY, SAL_LEVEL 
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;


--------------------------실습문제------------------------------
-- 1.
-- ORACLE
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE(+)
  AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
ORDER BY 1;
-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D
    ON E.DEPT_CODE = D.DEPT_ID
  LEFT JOIN LOCATION L
    ON D.LOCATION_ID = L.LOCAL_CODE
  LEFT JOIN NATIONAL N
    ON L.NATIONAL_CODE = N.NATIONAL_CODE
ORDER BY 1;

-- 2.
-- ORACLE
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SG.SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE SG
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND E.JOB_CODE = J.JOB_CODE(+)
  AND D.LOCATION_ID = L.LOCAL_CODE(+)
  AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
  AND E.SALARY BETWEEN SG.MIN_SAL AND SG.MAX_SAL(+)
ORDER BY 1;
-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D
    ON E.DEPT_CODE = D.DEPT_ID
  LEFT JOIN JOB J
    ON E.JOB_CODE = J.JOB_CODE
  LEFT JOIN LOCATION L
    ON D.LOCATION_ID = L.LOCAL_CODE
  LEFT JOIN NATIONAL N
    ON L.NATIONAL_CODE = N.NATIONAL_CODE
  LEFT JOIN SAL_GRADE SG
    ON E.SALARY BETWEEN MIN_SAL AND MAX_SAL
ORDER BY 1;