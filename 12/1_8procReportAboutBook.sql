-- Создай метод, возвращающий отчет об инвентаризации в разрезе каждой книги (Когда поступила на склад, когда и кто её брал и вернул, когда была утрачена).

CREATE OR REPLACE PROCEDURE REPORT_ABOUT_EXEMPLAR (
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

-- проверка существования экземпляра в базе
    SELECT 
        COUNT(ID)
    INTO COUNT_EXEMPLAR$
    FROM EXEMPLAR 
    WHERE ID = ID_EXEMPLAR$;
    IF COUNT_EXEMPLAR$ = 0 THEN
        RAISE E_INVALID_EXEMPLAR$;
    END IF;

-- выбираем данные о поступлении в библиотеку и об утрате
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

    DBMS_OUTPUT.put_line ('Данные о поступлении в библиотеку и об утрате экземпляра ' || ID_EXEMPLAR$);
    DBMS_OUTPUT.put_line (' ');
    DBMS_OUTPUT.put_line ('Название: ' || TITLE$);
    DBMS_OUTPUT.put_line ('Авторы: ' || AUTHOR$);
    DBMS_OUTPUT.put_line ('Издательство' || PUBL$);
    DBMS_OUTPUT.put_line ('Поступила' || DATE_AR$);
    DBMS_OUTPUT.put_line ('Убыла' || DATE_LEAV$);
    DBMS_OUTPUT.PUT_LINE(' ');


    OPEN TAKE_RETURN_EXEMPLAR FOR
-- выбираем данные о том когда и кто её брал и вернул
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

    DBMS_OUTPUT.put_line ('Данные о том когда и кто её брал и вернул');
    DBMS_OUTPUT.put_line (' ');
    LOOP
        FETCH TAKE_RETURN_EXEMPLAR INTO CLIENT$, TAKE$, RETURN_B$;
        EXIT WHEN TAKE_RETURN_EXEMPLAR%NOTFOUND;
        DBMS_OUTPUT.put_line ('Клиент - ' || CLIENT$);
        DBMS_OUTPUT.put_line ('Взял - ' || TAKE$);
        DBMS_OUTPUT.put_line ('Вернул - ' || RETURN_B$);
        DBMS_OUTPUT.PUT_LINE('-----    -------');
    END LOOP;


EXCEPTION
    WHEN E_INVALID_EXEMPLAR$ THEN
        DBMS_OUTPUT.put_line ('Такого экземпляра не существует');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
END;

