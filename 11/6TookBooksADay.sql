-- ������ �����, ������������ ������� �������� ���� �� ������������ ����.

DECLARE
    RCE                  SYS_REFCURSOR;
    DAY$                LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE;

BEGIN
-- �������� ������ � �������
    DAY$ := TO_DATE('10/120/2022', 'dd/mm/yyyy');

    OPEN RCE FOR
    SELECT 
        TITLE, 
        LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
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
    WHERE TAKE_BOOK = DAY$
    GROUP BY TITLE, PUBLISHER;

    DBMS_SQL.RETURN_RESULT(RCE);

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

