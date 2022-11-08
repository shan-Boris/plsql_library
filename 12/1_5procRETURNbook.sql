-- Возврат книги читателем.

CREATE OR REPLACE PROCEDURE RETURN_BOOK (
    ID_CLIENT$          IN CLIENT.ID%TYPE,
    TITLE$              IN BOOK.TITLE%TYPE,
    PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE,
    RATE_FROM_CLIENT$   IN NUMBER
)
IS
    ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;
BEGIN

--находим экземпляр книги которую взял клиент
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

-- обновляем данные в журнал выдачи о возврате
    UPDATE LOG_DELIVERY_RETURN_BOOK DRB
        SET RETURN_BOOK = TO_DATE(SYSDATE, 'dd/mm/yyyy'),
            RATING_BOOK = RATE_FROM_CLIENT$
    WHERE ID_CLIENT = ID_CLIENT$
            AND ID_EXEMPLAR = ID_EXEMPLAR$;


-- меняем местоположение книги
    UPDATE EXEMPLAR
        SET ON_STORE = 1,
            ON_HOME = 0
    WHERE ID = ID_EXEMPLAR$;


    DBMS_OUTPUT.put_line (TITLE$ || ' возвращена, экземпляр №' || ID_EXEMPLAR$);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line ('Такую книгу не брал');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);

END;
