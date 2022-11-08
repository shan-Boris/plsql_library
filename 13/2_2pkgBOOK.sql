-- ����� ��� ������ � �������
CREATE OR REPLACE PACKAGE BOOK_PKG
IS
    TYPE A_FIRST_NAME IS VARRAY (100) OF VARCHAR2(1000);
    TYPE A_LAST_NAME IS VARRAY (100) OF VARCHAR2(1000);
    TYPE A_FATHER_NAME IS VARRAY (100) OF VARCHAR2(1000);

    -- ���������� �����
    FUNCTION CREATE_BOOK (
        AMOUNT_BOOKS$           IN NUMBER,
        PUBLISHER$              IN PUBLISHER.PUBLISHER%TYPE,
        TITLE$                  IN BOOK.TITLE%TYPE,
        SUMMARY$                IN BOOK.SUMMARY%TYPE,
        YEAR_OF_PUBLICATION$    IN BOOK.YEAR_OF_PUBLICATION%TYPE,
        AGE_LIMIT$              IN BOOK.AGE_LIMIT%TYPE,
        PRICE$                  IN BOOK.PRICE%TYPE,
        BOOK_TYPE$              IN BOOK_TYPE.TYPE%TYPE,
        A_FIRST_NAMES$          IN A_FIRST_NAME,
        A_LAST_NAMES$           IN A_LAST_NAME,
        A_FATHER_NAMES$         IN A_FATHER_NAME
    )
    RETURN NUMBER;

    -- �������� ��������
    FUNCTION CHECK_READER (
        ID_CLIENT$        IN  CLIENT.ID%TYPE,
        TITLE$            IN  BOOK.TITLE%TYPE
    )
    RETURN NUMBER; 

    -- ������ ����� ��������
    FUNCTION DELIVERY_BOOK (
        ID_CLIENT$          IN CLIENT.ID%TYPE,
        TITLE$              IN BOOK.TITLE%TYPE,
        PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER; 

    -- ������ ����� � ��������� ��������
    FUNCTION GET_BOOK (
        ID_CLIENT$          IN CLIENT.ID%TYPE,
        TITLE$              IN BOOK.TITLE%TYPE,
        PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER; 

    -- ������� ����� ���������.
    PROCEDURE RETURN_BOOK (
        ID_CLIENT$          IN CLIENT.ID%TYPE,
        TITLE$              IN BOOK.TITLE%TYPE,
        PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE,
        RATE_FROM_CLIENT$   IN NUMBER
    );

-- �������� ���������� ������������ � ��
    FUNCTION PUBLISHER_IS_NEW(
        PUBL          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- �������� ���������� ������ � ��
    FUNCTION AUTHOR_IS_NEW(
        FIRSTNAME          IN VARCHAR2,
        LASTNAME           IN VARCHAR2,
        FATHERNAME         IN VARCHAR2
    )
    RETURN NUMBER;

--����� ���������� ����� ��� ������
    FUNCTION GET_FREE_EXEMPLAR (
        TITLE$           IN  BOOK.TITLE%TYPE,
        PUBLISHER$       IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

--����� ���������� ����� ������� ���� ������
    FUNCTION GET_EXEMPLAR_OF_CLIENT(
        TITLE$                  IN BOOK.TITLE%TYPE, 
        PUBLISHER$              IN PUBLISHER.PUBLISHER%TYPE, 
        ID_CLIENT$              IN CLIENT.ID%TYPE 
    )
    RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY BOOK_PKG
IS

    FUNCTION PUBLISHER_IS_NEW(
        PUBL       IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER
    IS
        ANY_ROWS_FOUND          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            PUBLISHER
        WHERE
            PUBLISHER = PUBL;
        IF ANY_ROWS_FOUND = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;

    FUNCTION AUTHOR_IS_NEW(
        FIRSTNAME          IN VARCHAR2,
        LASTNAME           IN VARCHAR2,
        FATHERNAME         IN VARCHAR2
    )
    RETURN NUMBER
    IS
        ANY_ROWS_FOUND          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            AUTHOR
        WHERE
            FIRST_NAME = FIRSTNAME AND LAST_NAME = LASTNAME 
            AND FATHER_NAME = FATHERNAME;
        IF ANY_ROWS_FOUND = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;


    FUNCTION CREATE_BOOK (
        AMOUNT_BOOKS$           IN NUMBER,
        PUBLISHER$              IN PUBLISHER.PUBLISHER%TYPE,
        TITLE$                  IN BOOK.TITLE%TYPE,
        SUMMARY$                IN BOOK.SUMMARY%TYPE,
        YEAR_OF_PUBLICATION$    IN BOOK.YEAR_OF_PUBLICATION%TYPE,
        AGE_LIMIT$              IN BOOK.AGE_LIMIT%TYPE,
        PRICE$                  IN BOOK.PRICE%TYPE,
        BOOK_TYPE$              IN BOOK_TYPE.TYPE%TYPE,
        A_FIRST_NAMES$          IN A_FIRST_NAME,
        A_LAST_NAMES$           IN A_LAST_NAME,
        A_FATHER_NAMES$         IN A_FATHER_NAME)

    RETURN NUMBER 
    IS
        ANY_ROWS_FOUND          NUMBER;
        EXEMPLAR_ID$            NUMBER;
        BOOKID$                 NUMBER;
    BEGIN

    -- ��������� ������������ ���� ��� ��� � ���� ���
        IF PUBLISHER_IS_NEW(PUBLISHER$) = 1
            THEN 
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
            IF AUTHOR_IS_NEW(A_FIRST_NAMES$(I), A_LAST_NAMES$(I), A_FATHER_NAMES$(I)) = 1
                THEN
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
        RETURN BOOKID$;
    EXCEPTION
        WHEN SUBSCRIPT_BEYOND_COUNT THEN
            DBMS_OUTPUT.put_line ('����� �� ��������� � ����������');
            DBMS_OUTPUT.put_line ('����������� �������� ������ �� �������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('����� �� ��������� � ����������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            RETURN 0;



    END;

    FUNCTION CHECK_READER (
        ID_CLIENT$        IN  CLIENT.ID%TYPE,
        TITLE$            IN  BOOK.TITLE%TYPE
    )
    RETURN NUMBER 
    IS
        RESULT$             NUMBER;
        E_INVALID_CLIENT$   EXCEPTION;
        E_INVALID_BOOK$     EXCEPTION;
        COUNT_CLIENT$       NUMBER;
        COUNT_BOOK$         NUMBER;
        COUNT_E_ON_STORE$   NUMBER;
        ALREADY_TOOK_BOOK$  NUMBER;
        RATING$             NUMBER;
        AGE_LIMIT$          NUMBER;
        BIRTHDAY$           DATE;

    BEGIN

        RESULT$ := 0;
    -- �������� ������������� ������� � ����
        SELECT 
            COUNT(ID)
        INTO COUNT_CLIENT$
        FROM CLIENT 
        WHERE ID = ID_CLIENT$;
        IF COUNT_CLIENT$ = 0 THEN
            RAISE E_INVALID_CLIENT$;
        END IF;

    -- �������� ������������� �����
        SELECT 
            COUNT(ID)
        INTO COUNT_BOOK$
        FROM BOOK 
        WHERE TITLE = TITLE$;
        IF COUNT_BOOK$ = 0 THEN
            RAISE E_INVALID_BOOK$;
        END IF;

    -- ������ ������� ���� ����������� �� ������
        SELECT
            COUNT(TITLE)
        INTO COUNT_E_ON_STORE$
        FROM EXEMPLAR E
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
        WHERE TITLE = TITLE$
            AND ON_STORE = 1;

    -- ������ ���� �� ��� ��� �����
        SELECT 
            COUNT(TITLE)
        INTO ALREADY_TOOK_BOOK$
        FROM LOG_DELIVERY_RETURN_BOOK DRB
            JOIN CLIENT C 
                ON (C.ID = DRB.ID_CLIENT)
            JOIN EXEMPLAR E
                ON E.ID = DRB.ID_EXEMPLAR
            JOIN BOOK B
                ON (B.ID = E.ID_BOOK)
        WHERE DRB.RETURN_BOOK IS NULL
            AND C.ID = ID_CLIENT$
            AND B.TITLE = TITLE$;
            
    -- ������ ������� �������
        SELECT
            RATING
        INTO RATING$
        FROM CLIENT C
        WHERE C.ID = ID_CLIENT$;
        
    -- ������ ���������� ���� �����
        SELECT
            AGE_LIMIT
        INTO AGE_LIMIT$
        FROM BOOK B
        WHERE B.TITLE = TITLE$;

        SELECT
            BIRTHDAY
        INTO BIRTHDAY$
        FROM CLIENT
        WHERE ID = ID_CLIENT$;


        IF COUNT_E_ON_STORE$ > 1 
            AND ALREADY_TOOK_BOOK$ = 0
            AND RATING$ != 0
            AND AGE_LIMIT$ <= 
                (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY$)) --��������� ����������� ����������� �����
            THEN RESULT$ := 1;
        END IF;

    -- ������� ���������� ������ ������ ����� �����
        IF RESULT$ = 0
        THEN
            IF COUNT_E_ON_STORE$ <= 1
            THEN DBMS_OUTPUT.put_line ('��� ���������� ��� ������');
            END IF;
            IF ALREADY_TOOK_BOOK$ != 0
            THEN DBMS_OUTPUT.put_line ('��� ����� ����� ����');
            END IF;
            IF RATING$ = 0
            THEN DBMS_OUTPUT.put_line ('������ � ������ ������');
            END IF;
            IF AGE_LIMIT$ > 
                    (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY$))
            THEN DBMS_OUTPUT.put_line ('������ �� ����� �� ���� �����');
            END IF;
        END IF;

        RETURN RESULT$;
    EXCEPTION
        WHEN E_INVALID_CLIENT$ THEN
            DBMS_OUTPUT.put_line ('������ ������� �� ����������');
            RETURN RESULT$;
        WHEN E_INVALID_BOOK$ THEN
            DBMS_OUTPUT.put_line ('����� ����� �� ����������');
            RETURN RESULT$;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            RETURN RESULT$;
    END;

    FUNCTION GET_FREE_EXEMPLAR (
        TITLE$           IN  BOOK.TITLE%TYPE,
        PUBLISHER$       IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER
    IS
        ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;
    BEGIN
        SELECT 
            E.ID
        INTO    
            ID_EXEMPLAR$
        FROM EXEMPLAR E
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
        WHERE TITLE = TITLE$
            AND PUBLISHER = PUBLISHER$
            AND ON_STORE = 1
        FETCH FIRST 1 ROWS ONLY;
    RETURN ID_EXEMPLAR$;
    END;

    FUNCTION GET_EXEMPLAR_OF_CLIENT(
        TITLE$                  IN BOOK.TITLE%TYPE, 
        PUBLISHER$              IN PUBLISHER.PUBLISHER%TYPE, 
        ID_CLIENT$              IN CLIENT.ID%TYPE 
    )
    RETURN NUMBER
    IS
        ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;

    BEGIN
        SELECT 
            E.ID
        INTO    
            ID_EXEMPLAR$
        FROM EXEMPLAR E
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
            JOIN LOG_DELIVERY_RETURN_BOOK DRB
                ON DRB.ID_EXEMPLAR = E.ID
            JOIN CLIENT C
                ON C.ID = DRB.ID_CLIENT
        WHERE TITLE = TITLE$
            AND P.PUBLISHER = PUBLISHER$
            AND C.ID = ID_CLIENT$
            AND DRB.RETURN_BOOK IS NULL;
        RETURN ID_EXEMPLAR$;
    END;

    FUNCTION DELIVERY_BOOK (
        ID_CLIENT$          IN CLIENT.ID%TYPE,
        TITLE$              IN BOOK.TITLE%TYPE,
        PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER 
    IS
        ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;

    BEGIN

    --������� ��������� ����� ��� ������
    ID_EXEMPLAR$ := GET_FREE_EXEMPLAR(TITLE$, PUBLISHER$);

    -- ��������� ������ � ������ ������
        EXECUTE IMMEDIATE
            q'[INSERT INTO LOG_DELIVERY_RETURN_BOOK (
                TAKE_BOOK,
                ID_CLIENT,
                ID_EXEMPLAR
            ) VALUES (
            TO_DATE(SYSDATE, 'dd/mm/yyyy'),]' 
            || ID_CLIENT$ || ',' 
            || ID_EXEMPLAR$ 
            || ')';

    -- ������ �������������� �����
        UPDATE EXEMPLAR
            SET ON_STORE = 0,
                ON_HOME = 1
        WHERE ID = ID_EXEMPLAR$;


        DBMS_OUTPUT.put_line (TITLE$ || ' ������, ��������� �' || ID_EXEMPLAR$);
        RETURN ID_EXEMPLAR$;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line ('��� ���������� ��� ������');
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            RETURN 0;
    END;

    FUNCTION GET_BOOK (
        ID_CLIENT$          IN CLIENT.ID%TYPE,
        TITLE$              IN BOOK.TITLE%TYPE,
        PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER
    IS
        DELIVERY_EXEMPLAR_ID$   NUMBER;
    BEGIN
        IF CHECK_READER(ID_CLIENT$  => ID_CLIENT$,
                        TITLE$  => TITLE$) = 1 
        THEN DELIVERY_EXEMPLAR_ID$ := DELIVERY_BOOK(
                            ID_CLIENT$  => ID_CLIENT$,
                            TITLE$  => TITLE$,
                            PUBLISHER$  => PUBLISHER$
                            );
        ELSE DBMS_OUTPUT.put_line ('������ ������ �����');
            DELIVERY_EXEMPLAR_ID$ := 0;

    END IF;
    RETURN DELIVERY_EXEMPLAR_ID$;
    END;

    PROCEDURE RETURN_BOOK (
        ID_CLIENT$          IN CLIENT.ID%TYPE,
        TITLE$              IN BOOK.TITLE%TYPE,
        PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE,
        RATE_FROM_CLIENT$   IN NUMBER
    )
    IS
        ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;
    BEGIN

    --������� ��������� ����� ������� ���� ������
        ID_EXEMPLAR$ := GET_EXEMPLAR_OF_CLIENT(TITLE$, PUBLISHER$, ID_CLIENT$);

    -- ��������� ������ � ������ ������ � ��������
        UPDATE LOG_DELIVERY_RETURN_BOOK DRB
            SET RETURN_BOOK = TO_DATE(SYSDATE, 'dd/mm/yyyy'),
                RATING_BOOK = RATE_FROM_CLIENT$
        WHERE ID_CLIENT = ID_CLIENT$
                AND ID_EXEMPLAR = ID_EXEMPLAR$;


    -- ������ �������������� �����
        UPDATE EXEMPLAR
            SET ON_STORE = 1,
                ON_HOME = 0
        WHERE ID = ID_EXEMPLAR$;


        DBMS_OUTPUT.put_line (TITLE$ || ' ����������, ��������� �' || ID_EXEMPLAR$);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line ('����� ����� �� ����');
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);

    END;
END;

