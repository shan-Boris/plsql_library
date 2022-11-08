-- Выдача книги читателю

CREATE OR REPLACE FUNCTION DELIVERY_BOOK (
    ID_CLIENT$          IN CLIENT.ID%TYPE,
    TITLE$              IN BOOK.TITLE%TYPE,
    PUBLISHER$          IN PUBLISHER.PUBLISHER%TYPE
)
RETURN NUMBER 
IS
    ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;

BEGIN

--находим экземпляр книги для выдачи
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


-- заполняем данные в журнал выдачи
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

-- меняем местоположение книги
    UPDATE EXEMPLAR
        SET ON_STORE = 0,
            ON_HOME = 1
    WHERE ID = ID_EXEMPLAR$;


    DBMS_OUTPUT.put_line (TITLE$ || ' выдана, экземпляр №' || ID_EXEMPLAR$);
    RETURN ID_EXEMPLAR$;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line ('Нет экземпляра для выдачи');
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
        RETURN 0;
END;
