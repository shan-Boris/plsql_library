--������ ����� �� �������� ����� ����� (����� �����, ����� �������) - ��������� PL/SQL ����.

DECLARE
    ANY_ROWS_FOUND          NUMBER;
    BOOKID$                 NUMBER;
    EXEMPLAR_ID$            NUMBER;
    AMOUNT_BOOKS$           NUMBER;
    PUBLISHER$              PUBLISHER.PUBLISHER%TYPE;
    TITLE$                  BOOK.TITLE%TYPE;
    SUMMARY$                BOOK.SUMMARY%TYPE;
    YEAR_OF_PUBLICATION$    BOOK.YEAR_OF_PUBLICATION%TYPE;
    AGE_LIMIT$              BOOK.AGE_LIMIT%TYPE;
    PRICE$                  BOOK.PRICE%TYPE;
    BOOK_TYPE$              BOOK_TYPE.TYPE%TYPE;
    TYPE A_FIRST_NAME IS VARRAY(100) OF AUTHOR.FIRST_NAME%TYPE;
    A_FIRST_NAMES$          A_FIRST_NAME;
    TYPE A_LAST_NAME IS VARRAY(100) OF AUTHOR.LAST_NAME%TYPE;
    A_LAST_NAMES$           A_LAST_NAME;
    TYPE A_FATHER_NAME IS VARRAY(100) OF AUTHOR.FATHER_NAME%TYPE;
    A_FATHER_NAMES$         A_FATHER_NAME;


BEGIN
-- �������� ������ � �������, �.�. ������� ����� ���� ��������� ��������� ��������� ���� �������
    PUBLISHER$ := '������������';
    TITLE$ := '��������';
    SUMMARY$ := '����������';
    YEAR_OF_PUBLICATION$ := 2010;
    AGE_LIMIT$ := 5;
    PRICE$ := 500;
    AMOUNT_BOOKS$ := 3; -- ������� ����������� ����� ��������
    BOOK_TYPE$ := '�����';
    A_FIRST_NAMES$ := A_FIRST_NAME('������', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('�����', '������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', ' ');


-- ��������� ������������ ���� ��� ��� � ���� ���
    SELECT
        COUNT(*) INTO ANY_ROWS_FOUND
    FROM
        PUBLISHER
    WHERE
        PUBLISHER = PUBLISHER$;
    IF ANY_ROWS_FOUND = 0 THEN
        INSERT INTO PUBLISHER (
            PUBLISHER
        ) VALUES (
            PUBLISHER$
        );
    END IF;

-- �������� id ��� �����
    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

    -- ��������� �����
    INSERT INTO BOOK (
        ID,
        TITLE,
        SUMMARY,
        YEAR_OF_PUBLICATION,
        AGE_LIMIT,
        PRICE,
        ID_PUBLISHER,
        ID_BOOK_TYPE
    ) VALUES (
        BOOKID$,
        TITLE$,
        SUMMARY$,
        YEAR_OF_PUBLICATION$,
        AGE_LIMIT$,
        PRICE$,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = PUBLISHER$ ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = BOOK_TYPE$)
    );

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    FOR I IN 1..A_FIRST_NAMES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            AUTHOR
        WHERE
            FIRST_NAME = A_FIRST_NAMES$(I) AND LAST_NAME = A_LAST_NAMES$(I) 
            AND FATHER_NAME = A_FATHER_NAMES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO AUTHOR (
                FIRST_NAME,
                LAST_NAME,
                FATHER_NAME
            ) VALUES (
                A_FIRST_NAMES$(I),
                A_LAST_NAMES$(I),
                A_FATHER_NAMES$(I)
            );   
        END IF;

        -- ��������� ����� ����� - �����
        INSERT INTO AUTHOR_WROTE_BOOK(
            ID_AUTHOR,
            ID_BOOK
        ) VALUES (
            (SELECT 
                ID 
            FROM AUTHOR 
            WHERE FIRST_NAME = A_FIRST_NAMES$(I) AND LAST_NAME = A_LAST_NAMES$(I) 
                AND FATHER_NAME = A_FATHER_NAMES$(I)),
            BOOKID$
        );
    END LOOP;

        -- ��������� ���������� ���� �� ����� � ���������� � ������� � ������ ������ ����
    FOR I IN 1..AMOUNT_BOOKS$ LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        )
        RETURNING ID INTO EXEMPLAR_ID$; 

        INSERT INTO LOG_ADD_DELETE_BOOK (
            ID_EXEMPLAR,
            ID_PUBLISHER,
            ENTERED
        ) VALUES (
            EXEMPLAR_ID$,
            ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = PUBLISHER$ ),
            TO_DATE(SYSDATE, 'dd/mm/yyyy')
        );
        DBMS_OUTPUT.put_line (TITLE$ || ' ��������� � ����������, ��������� �' || EXEMPLAR_ID$);

    END LOOP;

EXCEPTION
    WHEN SUBSCRIPT_BEYOND_COUNT THEN
        DBMS_OUTPUT.put_line ('����� �� ��������� � ����������');
        DBMS_OUTPUT.put_line ('����������� �������� ������ �� �������');
        DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('����� �� ��������� � ����������');
        DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);

END;


