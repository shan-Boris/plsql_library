-- —оздай метод по проверке может ли читатель вз€ть книгу (кейсы: плохой рейтинг у читател€, читатель уже вз€л эту книгу, книга не подходит по возрасту и т.д.)

DECLARE
    RC                  SYS_REFCURSOR;
    ID_CLIENT$          CLIENT.ID%TYPE;
    TITLE$              BOOK.TITLE%TYPE;
    E_INVALID_CLIENT$   EXCEPTION;
    E_INVALID_BOOK$     EXCEPTION;
    COUNT_CLIENT$       NUMBER;
    COUNT_BOOK$         NUMBER;

BEGIN
-- получаем данные с клиента
    ID_CLIENT$ := 8;
    TITLE$ := 'ѕандора5';

-- проверка существовани€ клиента в базе
    SELECT 
        COUNT(ID)
    INTO COUNT_CLIENT$
    FROM CLIENT 
    WHERE ID = ID_CLIENT$;
    IF COUNT_CLIENT$ = 0 THEN
        RAISE E_INVALID_CLIENT$;
    END IF;

-- проверка существовани€ книги
    SELECT 
        COUNT(ID)
    INTO COUNT_BOOK$
    FROM BOOK 
    WHERE TITLE = TITLE$;
    IF COUNT_BOOK$ = 0 THEN
        RAISE E_INVALID_BOOK$;
    END IF;

    OPEN RC FOR
    SELECT 
        TITLE, 
        LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
        PUBLISHER,
        CASE WHEN ((SELECT
                        COUNT(TITLE)
                    FROM EXEMPLAR E
                        JOIN BOOK B
                            ON B.ID = E.ID_BOOK
                    WHERE TITLE = TITLE$ 
                        AND ON_STORE = 1) > 1 -- если книга не последн€€
                AND (SELECT 
                        COUNT(TITLE)
                    FROM LOG_DELIVERY_RETURN_BOOK DRB
                        JOIN CLIENT C 
                            ON (C.ID = DRB.ID_CLIENT)
                        JOIN EXEMPLAR E
                            ON E.ID = DRB.ID_EXEMPLAR
                        JOIN BOOK B
                            ON (B.ID = E.ID_BOOK)
                    WHERE DRB.RETURN_BOOK IS NULL
                        AND C.ID = ID_CLIENT$
                        AND B.TITLE = TITLE$) = 0 -- если еще не вз€л эту книгу
                AND (SELECT
                        RATING
                    FROM CLIENT C
                    WHERE C.ID = ID_CLIENT$) != 0 -- если рейтинг != 0
                AND (SELECT
                        AGE_LIMIT
                    FROM BOOK B
                    WHERE B.TITLE = TITLE$) <= (
                        EXTRACT(
                            YEAR
                        FROM
                            SYSDATE
                        ) - EXTRACT(
                            YEAR
                        FROM
                            (SELECT
                            BIRTHDAY
                            FROM CLIENT
                            WHERE ID = ID_CLIENT$))) -- если проходишь возрастной ценз
        )
            THEN 'YES' 
            ELSE 'NO' 
        END ћожно_вз€ть_домой
    FROM BOOK B 
        JOIN AUTHOR_WROTE_BOOK AWB 
            ON (AWB.ID_BOOK = B.ID)
        JOIN AUTHOR A 
            ON(A.ID = AWB.ID_AUTHOR)
        JOIN PUBLISHER P 
            ON (P.ID = B.ID_PUBLISHER) 
        JOIN EXEMPLAR E
            ON E.ID_BOOK = B.ID
    WHERE TITLE = TITLE$
    GROUP BY TITLE, PUBLISHER;

    DBMS_SQL.RETURN_RESULT(RC);

EXCEPTION
    WHEN E_INVALID_CLIENT$ THEN
        DBMS_OUTPUT.put_line ('“акого клиента не существует');
    WHEN E_INVALID_BOOK$ THEN
        DBMS_OUTPUT.put_line ('“акой книги не существует');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line (' од ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);

END;
