--������ ������ �� �������� ������������ � ������ ���. ������ - ��������� PL/SQL ����.

DECLARE
    CLIENT_ID$          NUMBER;
    FIRST_NAME$         CLIENT.FIRST_NAME%TYPE;
    LAST_NAME$          CLIENT.LAST_NAME%TYPE;
    FATHER_NAME$        CLIENT.FATHER_NAME%TYPE;
    BIRTHDAY$           CLIENT.BIRTHDAY%TYPE;
    EMPLOYEE$           CLIENT.EMPLOYEE%TYPE;
    RATING$             CLIENT.RATING%TYPE;

BEGIN
-- �������� ������ � �������
    FIRST_NAME$ := '���';
    LAST_NAME$ := '�������';
    FATHER_NAME$ := '��������';
    BIRTHDAY$ := TO_DATE('15/5/2025', 'dd/mm/yyyy');
    EMPLOYEE$ := '';
    RATING$ := 5;



-- ��������� ������� ������ � ������� ������� ��������� ���������� � ������������
    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
        FIRST_NAME$,
        LAST_NAME$,
        FATHER_NAME$,
        BIRTHDAY$,
        EMPLOYEE$,
        RATING$
    )
    RETURNING ID INTO CLIENT_ID$;

    INSERT INTO CARD_CHANGE_TIME (
        ID,
        CREATE_CARD
    ) VALUES (
        CLIENT_ID$,
        TO_DATE(SYSDATE, 'dd/mm/yyyy')
    );

    DBMS_OUTPUT.put_line ('������ ������������ ����� �� ' || FIRST_NAME$ || ' ' || LAST_NAME$ || ' ' || FATHER_NAME$);

EXCEPTION
    WHEN PROGRAM_ERROR THEN
        DBMS_OUTPUT.put_line ('���������� ������ pl/sql');
    WHEN OTHERS THEN
        IF SQLCODE = '-1400' THEN
            DBMS_OUTPUT.put_line ('���������� �� ��� ������ ��� �������� ������������');
        END IF; 
        DBMS_OUTPUT.put_line ('������������ ����� �� ������');
        DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);


END;


