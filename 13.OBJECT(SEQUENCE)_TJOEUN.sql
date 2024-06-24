/*
  SEQUENCE
    자동으로 번호를 발생시키는 역할을 하는 객체
    정수값을 순차적으로 일정 값씩 증가시키면서 생성해줌
    
    EX) 회원번호, 사원번호, 게시글번호
*/

/*
  1. 시퀀스 객체생성 방법
    [FORMAT]
      CREATE SEQUENCE 시퀀스명
      [START WITH START_NUM(DEFAULT '1')]           << 초기값
      [INCREMENT BY INCREASE_NUM(DEFAULT '1')]      << 증가값
      [MAXVALUE MAX_NUM]                            << 최대 값 지정, 기본값 엄청 큼
      [MINVALUE MIN_NUM]                            << 최소 값 지정
      [CYCLE|NOCYCLE(DEFAULT)]                      << 순환 여부 설정
      [CACHE(DEFAULT)|NOCACHE]                      << 캐시메모리 사용 여부
      
      * 캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                    매번 호출될 때마다 새롭게 번호를 생성하는게 아니라
                    캐시메모리 공간에 미리 생성된 번호를 가져다 쓸 수 있음(속도가 빨라짐)
                    접속 해제 시 캐시메모리에 로드된 데이터 날아감
  
    테이블 : TB_
    뷰 : VW_
    시퀀스 : SEQ_
    트리거 : TRG_
*/
-- 시퀀스 생성
CREATE SEQUENCE SEQ_TEST;

SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 500
INCREMENT BY 5
MAXVALUE 510
NOCYCLE
NOCACHE;

/*
  시퀀스 사용
    [SEQUENCE_NAME].CURRVAL : 현재 시퀀스의 값(마지막으로 성공한 NEXT_VALUE의 값이 됨
    [SEQUENCE_NAME].NEXTVAL : 시퀀스값에 일정한 값을 증가시켜서 발생된 값
*/
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- NEXTVAL을 단 한번도 수행하지 않은 이상 CURRVAL을 사용할 수 없음
-- 마지막으로 성공적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;

/*
  시퀀스 구조 변경
  ALTER SEQUENCE [SEQUENCE_NAME]
  [INCREMENT BY INCREASE_NUM]
  [MAXVALUE MAX_NUM]
  [MINVALUE MIN_NUM]
  [CYCLE|NOCYCLE]
  [CACHE [BYTE_SIZE]|NOCACHE]
    * START WITH는 변경 불가!
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 600;

SELECT SEQ_EMPNO.NEXTVAL, SEQ_EMPNO.CURRVAL FROM DUAL;

/*
  시퀀스 삭제
  DROP SEQUENCE [SEQUENCE_NAME]
*/
DROP SEQUENCE SEQ_EMPNO;


------------------------------------------------------------
/*
  실제 적용
*/
CREATE SEQUENCE SEQ_EID
START WITH 401
NOCACHE;

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '남길석', '001213-3415122', 'J7', SYSDATE);
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
        VALUES(SEQ_EID.NEXTVAL, '송미영', '001213-4415122', 'J6', SYSDATE);

SELECT * FROM EMPLOYEE;