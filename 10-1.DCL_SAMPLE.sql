CREATE TABLE SAMPLE(
  ID NUMBER,
  PWD VARCHAR2(30)
);

INSERT INTO SAMPLE VALUES(1, 'pass01');

SELECT * FROM SAMPLE;

SELECT * FROM TJOEUN.EMPLOYEE;
INSERT INTO TJOEUN.EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
  VALUES (400, '홍길동', '231224-4123123', 'J2');

COMMIT;