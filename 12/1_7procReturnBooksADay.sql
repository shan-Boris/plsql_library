-- Создай процедуру, возвращающую таблицу вернувшихся книг за определенный день.

CREATE OR REPLACE PROCEDURE RETURN_BOOKS_A_DAY (
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

    DBMS_OUTPUT.put_line ('Вернувшиеся книги за ' || DAY$);
    DBMS_OUTPUT.put_line (' ');
    DBMS_OUTPUT.put_line ('Название' || '     ' || 'Авторы' || '     ' || 'Издательство');
    LOOP
        FETCH RCE INTO TITLE$, AUTHOR$, PUBL$;
        EXIT WHEN RCE%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(TITLE$ || '     ' || AUTHOR$ || '     ' || PUBL$);
        DBMS_OUTPUT.PUT_LINE('-----    -------');
    END LOOP;

EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE = '-1861' THEN
        DBMS_OUTPUT.put_line ('Неверная дата');
    ELSE
        DBMS_OUTPUT.put_line ('Ошибка');
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
    END IF;
END;