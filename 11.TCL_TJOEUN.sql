/*
  TCL (TRANSACTION CONTROL LANGUAGE)
  
  TRANSACTION이란
    - 데이터베이스의 논리적 연산단위
    - 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
      DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                                    존재하지 않는다면 트랜잭션을 생성해서 처리
      COMMIT 하기 전까지의 변경사항들을 하나의 트랜잭션에 담아둠
    - 트랜잭션의 대상이 되는 SQL문 : INSERT, UPDATE, DELETE
      
      트랜잭션 확정, 저장 : COMMIT
        COMMIT 명령어 실행 시 트랜잭션에 담겨있는 변경사항들을 실 DB에 반영 후 트랜잭션 삭제
      트랜잭션 취소 : ROLLBACK
        ROLLBACK 명령어 실행 시 트랜잭션에 담겨있는 변경사항들을 취소 후 트랜잭션 삭제(마지막 COMMIT 시점으로 돌아감)
      임시 저장 : SAVEPOINT
        ROLLBACK과 유사하지만, COMMIT 이후로 임시 저장한 시점(SAVEPOINT)으로 돌아감(SAVEPOINT 이후 트랜잭션 내용은 삭제됨)
*/
SELECT * FROM EMP_01;

-- 사원이 207번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 207;
ROLLBACK;

INSERT INTO EMP_01
VALUES(500, '김갑주', '인사관리부', NULL);
COMMIT;

-- 사원이 200, 201, 202번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (200, 201, 202);

-- 임시 저장 시점 SP 생성
SAVEPOINT SP;

INSERT INTO EMP_01
VALUES(501, '이세종', '총무부');

DELETE FROM EMP_01
WHERE EMP_ID = 220;

-- 임시 저장 시점(SP)까지만 롤백
ROLLBACK TO SP;

SELECT * FROM EMP_01 ORDER BY EMP_ID;

COMMIT;

-------------------------------------------------------------------
/*
  자동으로 COMMIT되는 경우
    - 정상 종료 시
    - DCL, DDL문이 수행된 경우
    
  자동으로 ROLLBACK되는 경우
    - 비정상 종료 시
*/
DELETE FROM EMP_01
WHERE EMP_ID = 222;

DELETE FROM EMP_01
WHERE EMP_ID = 500;

CREATE TABLE TEST(
  TID NUMBER
);
ROLLBACK;

SELECT * FROM EMP_01;