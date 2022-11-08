-- Создай метод, возвращающий отчет об инвентаризации в разрезе каждой книги (Когда поступила на склад, когда и кто её брал и вернул, когда была утрачена).

DECLARE
    RC                      SYS_REFCURSOR;
    RCQ                     SYS_REFCURSOR;
    ID_EXEMPLAR$            EXEMPLAR.ID%TYPE;
    E_INVALID_EXEMPLAR$     EXCEPTION;
    COUNT_EXEMPLAR$         NUMBER;

BEGIN
-- получаем данные с клиента
    ID_EXEMPLAR$ := 1500;

-- проверка существования экземпляра в базе
    SELECT 
        COUNT(ID)
    INTO COUNT_EXEMPLAR$
    FROM EXEMPLAR 
    WHERE ID = ID_EXEMPLAR$;
    IF COUNT_EXEMPLAR$ = 0 THEN
        RAISE E_INVALID_EXEMPLAR$;
    END IF;

    OPEN RC FOR
-- выбираем данные о поступлении в библиотеку и об утрате
    SELECT
        TITLE, 
        LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
        PUBLISHER,
        ADB.ENTERED,
        ADB.LEAV 
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

    DBMS_SQL.RETURN_RESULT(RC);

    OPEN RCQ FOR
-- выбираем данные о том когда и кто её брал и вернул
    SELECT
        TITLE, 
        LISTAGG(A.FIRST_NAME||' '||A.LAST_NAME||' '||A.FATHER_NAME, '; ') AS AUTHOR, 
        C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT,
        PUBLISHER,
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
        WHERE ID_EXEMPLAR = ID_EXEMPLAR$
        GROUP BY TITLE, PUBLISHER, TAKE_BOOK, DRB.RETURN_BOOK, C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME;

    DBMS_SQL.RETURN_RESULT(RCQ);

EXCEPTION
    WHEN E_INVALID_EXEMPLAR$ THEN
        DBMS_OUTPUT.put_line ('Такого экземпляра не существует');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
END;

