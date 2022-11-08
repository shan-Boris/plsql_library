-- ����� ��� ��������� �������
CREATE OR REPLACE PACKAGE REPORT_PKG
    IS
    -- �������� ����� �� ����
    PROCEDURE TOOK_BOOKS_A_DAY (
        DAY$                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    );

    -- ����������� ����� �� ������������ ����.
    PROCEDURE RETURN_BOOKS_A_DAY (
        DAY$                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    );

    -- ����� �� �������������� � ������� ������ ����� (����� ��������� �� �����, ����� � ��� � ���� � ������, ����� ���� ��������).
    PROCEDURE REPORT_ABOUT_EXEMPLAR (
        ID_EXEMPLAR$                IN NUMBER
    );

END;
/

CREATE OR REPLACE PACKAGE BODY REPORT_PKG
    IS

    PROCEDURE TOOK_BOOKS_A_DAY (
        DAY$                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    )
    IS
        V_OBJ               JSON_OBJECT_T;
        V_ARR               JSON_ARRAY_T;
        COUNTER_BOOK$       NUMBER; 

    BEGIN

        V_ARR := JSON_ARRAY_T('[]');
        V_OBJ := JSON_OBJECT_T('{}');
        COUNTER_BOOK$ := 1; --�������������� ������� ���-�� �������� ����

        FOR I IN (
            SELECT 
                TITLE, 
                LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR,
                PUBLISHER,
                E.ID AS EXEMPL
            FROM LOG_DELIVERY_RETURN_BOOK DRB 
                JOIN EXEMPLAR E
                    ON E.ID = DRB.ID_EXEMPLAR
                JOIN BOOK B 
                    ON (B.ID = E.ID_BOOK)
                LEFT JOIN AUTHOR_WROTE_BOOK AWB 
                    ON (AWB.ID_BOOK = B.ID)
                LEFT JOIN AUTHOR A 
                    ON(A.ID = AWB.ID_AUTHOR)
                LEFT JOIN PUBLISHER P 
                    ON (P.ID = B.ID_PUBLISHER) 
            WHERE TAKE_BOOK = DAY$
            GROUP BY TITLE, PUBLISHER, E.ID
        )
        LOOP
            V_ARR.APPEND(
                JSON_OBJECT_T('
                {"' || COUNTER_BOOK$ || '":{"��������":"' || I.TITLE || '",
                                            "������":"' || I.AUTHOR || '",
                                            "������������":"' || I.PUBLISHER || '",
                                            "� ����������":' || I.EXEMPL || '}}'));
            COUNTER_BOOK$ := COUNTER_BOOK$ + 1;   
        END LOOP;

        V_OBJ.PUT('�������� ����� �� ' || DAY$, V_ARR);
        DBMS_OUTPUT.PUT_LINE(V_OBJ.STRINGIFY);

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = '-1861' THEN
                DBMS_OUTPUT.put_line ('�������� ����');
            ELSE
                DBMS_OUTPUT.put_line ('������');
                DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
                DBMS_OUTPUT.put_line (SQLERRM);
            END IF;
    END;

    PROCEDURE RETURN_BOOKS_A_DAY (
        DAY$                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    )
    IS
        RCE                  SYS_REFCURSOR;
        TITLE$               BOOK.TITLE%TYPE;
        AUTHOR$              VARCHAR2(1000);
        PUBL$                VARCHAR2(1000);
    BEGIN

        OPEN RCE FOR
        SELECT 
            TITLE, 
            LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
            PUBLISHER 
        FROM LOG_DELIVERY_RETURN_BOOK DRB 
            JOIN EXEMPLAR E
                ON E.ID = DRB.ID_EXEMPLAR
            JOIN BOOK B 
                ON (B.ID = E.ID_BOOK)
            LEFT JOIN AUTHOR_WROTE_BOOK AWB 
                ON (AWB.ID_BOOK = B.ID)
            LEFT JOIN AUTHOR A 
                ON(A.ID = AWB.ID_AUTHOR)
            LEFT JOIN PUBLISHER P 
                ON (P.ID = B.ID_PUBLISHER) 
        WHERE RETURN_BOOK = DAY$
        GROUP BY TITLE, PUBLISHER;

        DBMS_OUTPUT.put_line ('����������� ����� �� ' || DAY$);
        DBMS_OUTPUT.put_line (' ');
        DBMS_OUTPUT.put_line ('��������' || '     ' || '������' || '     ' || '������������');
        LOOP
            FETCH RCE INTO TITLE$, AUTHOR$, PUBL$;
            EXIT WHEN RCE%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(TITLE$ || '     ' || AUTHOR$ || '     ' || PUBL$);
            DBMS_OUTPUT.PUT_LINE('-----    -------');
        END LOOP;

    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = '-1861' THEN
            DBMS_OUTPUT.put_line ('�������� ����');
        ELSE
            DBMS_OUTPUT.put_line ('������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
        END IF;
    END;

    PROCEDURE REPORT_ABOUT_EXEMPLAR (
        ID_EXEMPLAR$                IN NUMBER
    )
    IS
        TAKE_RETURN_EXEMPLAR    SYS_REFCURSOR;
        E_INVALID_EXEMPLAR$     EXCEPTION;
        COUNT_EXEMPLAR$         NUMBER;
        CLIENT$                 VARCHAR2(500);
        TAKE$                   DATE;
        RETURN_B$               DATE;
        TITLE$                  VARCHAR2(500);
        AUTHOR$                 VARCHAR2(500);
        PUBL$                   VARCHAR2(500);
        DATE_AR$                DATE;
        DATE_LEAV$              DATE;
    BEGIN

    -- �������� ������������� ���������� � ����
        SELECT 
            COUNT(ID)
        INTO COUNT_EXEMPLAR$
        FROM EXEMPLAR 
        WHERE ID = ID_EXEMPLAR$;
        IF COUNT_EXEMPLAR$ = 0 THEN
            RAISE E_INVALID_EXEMPLAR$;
        END IF;

    -- �������� ������ � ����������� � ���������� � �� ������
        SELECT
            TITLE, 
            LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
            PUBLISHER,
            ADB.ENTERED,
            ADB.LEAV
        INTO
            TITLE$,
            AUTHOR$,
            PUBL$,
            DATE_AR$,
            DATE_LEAV$
        FROM LOG_ADD_DELETE_BOOK ADB
            JOIN EXEMPLAR E
                ON ADB.ID_EXEMPLAR = E.ID
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            LEFT JOIN AUTHOR_WROTE_BOOK AWB
                ON AWB.ID_BOOK = B.ID
            LEFT JOIN AUTHOR A
                ON A.ID = AWB.ID_AUTHOR
            LEFT JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
            WHERE ID_EXEMPLAR = ID_EXEMPLAR$
            GROUP BY TITLE, PUBLISHER, ADB.ENTERED, ADB.LEAV;

        DBMS_OUTPUT.put_line ('������ � ����������� � ���������� � �� ������ ���������� ' || ID_EXEMPLAR$);
        DBMS_OUTPUT.put_line (' ');
        DBMS_OUTPUT.put_line ('��������: ' || TITLE$);
        DBMS_OUTPUT.put_line ('������: ' || AUTHOR$);
        DBMS_OUTPUT.put_line ('������������: ' || PUBL$);
        DBMS_OUTPUT.put_line ('���������: ' || DATE_AR$);
        DBMS_OUTPUT.put_line ('�����: ' || DATE_LEAV$);
        DBMS_OUTPUT.PUT_LINE(' ');


        OPEN TAKE_RETURN_EXEMPLAR FOR
    -- �������� ������ � ��� ����� � ��� � ���� � ������
        SELECT
            C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT,
            TAKE_BOOK,
            RETURN_BOOK 
        FROM LOG_DELIVERY_RETURN_BOOK DRB
            JOIN EXEMPLAR E
                ON DRB.ID_EXEMPLAR = E.ID
            JOIN CLIENT C
                ON C.ID = DRB.ID_CLIENT
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            LEFT JOIN AUTHOR_WROTE_BOOK AWB
                ON AWB.ID_BOOK = B.ID
            LEFT JOIN AUTHOR A
                ON A.ID = AWB.ID_AUTHOR
            LEFT JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
            WHERE ID_EXEMPLAR = ID_EXEMPLAR$;

        DBMS_OUTPUT.put_line ('������ � ��� ����� � ��� � ���� � ������');
        DBMS_OUTPUT.put_line (' ');
        LOOP
            FETCH TAKE_RETURN_EXEMPLAR INTO CLIENT$, TAKE$, RETURN_B$;
            EXIT WHEN TAKE_RETURN_EXEMPLAR%NOTFOUND;
            DBMS_OUTPUT.put_line ('������ - ' || CLIENT$);
            DBMS_OUTPUT.put_line ('���� - ' || TAKE$);
            DBMS_OUTPUT.put_line ('������ - ' || RETURN_B$);
            DBMS_OUTPUT.PUT_LINE('-----    -------');
        END LOOP;


    EXCEPTION
        WHEN E_INVALID_EXEMPLAR$ THEN
            DBMS_OUTPUT.put_line ('������ ���������� �� ����������');
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
    END;

END;