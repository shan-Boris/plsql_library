-- Функция по проверке может ли читатель взять книгу (кейсы: плохой рейтинг у читателя, читатель уже взял эту книгу, книга не подходит по возрасту и т.д.)

CREATE OR REPLACE FUNCTION CHECK_READER (
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
-- проверка существования клиента в базе
    SELECT 
        COUNT(ID)
    INTO COUNT_CLIENT$
    FROM CLIENT 
    WHERE ID = ID_CLIENT$;
    IF COUNT_CLIENT$ = 0 THEN
        RAISE E_INVALID_CLIENT$;
    END IF;

-- проверка существования книги
    SELECT 
        COUNT(ID)
    INTO COUNT_BOOK$
    FROM BOOK 
    WHERE TITLE = TITLE$;
    IF COUNT_BOOK$ = 0 THEN
        RAISE E_INVALID_BOOK$;
    END IF;

-- узнаем сколько есть экземпляров на складе
    SELECT
        COUNT(TITLE)
    INTO COUNT_E_ON_STORE$
    FROM EXEMPLAR E
        JOIN BOOK B
            ON B.ID = E.ID_BOOK
    WHERE TITLE = TITLE$
        AND ON_STORE = 1;

-- узнаем взял ли уже эту книгу
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
         
-- узнаем рейтинг клиента
    SELECT
        RATING
    INTO RATING$
    FROM CLIENT C
    WHERE C.ID = ID_CLIENT$;
    
-- узнаем возрастной ценз книги
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
            (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY$)) --проверяем прохождение возрастного ценза
        THEN RESULT$ := 1;
    END IF;

-- выводим информацию почему нельзя взять книгу
    IF RESULT$ = 0
    THEN
        IF COUNT_E_ON_STORE$ <= 1
        THEN DBMS_OUTPUT.put_line ('Нет экземпляра для выдачи');
        END IF;
        IF ALREADY_TOOK_BOOK$ != 0
        THEN DBMS_OUTPUT.put_line ('Уже такую книгу взял');
        END IF;
        IF RATING$ = 0
        THEN DBMS_OUTPUT.put_line ('Клиент в черном списке');
        END IF;
        IF AGE_LIMIT$ > 
                (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY$))
        THEN DBMS_OUTPUT.put_line ('Клиент не дорос до этой книги');
        END IF;
    END IF;

    RETURN RESULT$;
EXCEPTION
    WHEN E_INVALID_CLIENT$ THEN
        DBMS_OUTPUT.put_line ('Такого клиента не существует');
        RETURN RESULT$;
    WHEN E_INVALID_BOOK$ THEN
        DBMS_OUTPUT.put_line ('Такой книги не существует');
        RETURN RESULT$;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
        RETURN RESULT$;
END;



