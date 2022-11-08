--создание пользователя и выдачи чит. билета

CREATE OR REPLACE FUNCTION CREATE_CLIENT (
    FIRST_NAME$         IN CLIENT.FIRST_NAME%TYPE,
    LAST_NAME$          IN CLIENT.LAST_NAME%TYPE,
    FATHER_NAME$        IN CLIENT.FATHER_NAME%TYPE,
    BIRTHDAY$           IN CLIENT.BIRTHDAY%TYPE,
    EMPLOYEE$           IN CLIENT.EMPLOYEE%TYPE,
    RATING$             IN CLIENT.RATING%TYPE)
RETURN NUMBER IS
    CLIENT_ID$  NUMBER;
BEGIN

-- заполняем таблицу клиент и таблицу времени изменения информации о пользователе
    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
        FIRST_NAME$,
        LAST_NAME$,
        FATHER_NAME$,
        BIRTHDAY$,
        EMPLOYEE$,
        RATING$
    )
    RETURNING ID INTO CLIENT_ID$;

    INSERT INTO CARD_CHANGE_TIME (
        ID,
        CREATE_CARD
    ) VALUES (
        CLIENT_ID$,
        TO_DATE(SYSDATE, 'dd/mm/yyyy')
    );

    DBMS_OUTPUT.put_line ('Создан читательский билет на ' || FIRST_NAME$ || ' ' || LAST_NAME$ || ' ' || FATHER_NAME$);
    RETURN CLIENT_ID$;
EXCEPTION
    WHEN PROGRAM_ERROR THEN
        DBMS_OUTPUT.put_line ('Внутренняя ошибка pl/sql');
        RETURN 0;
    WHEN OTHERS THEN
        IF SQLCODE = '-1400' THEN
            DBMS_OUTPUT.put_line ('Полученные не все данные для создания пользователя');
        END IF; 
        DBMS_OUTPUT.put_line ('Читательский билет не создан');
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
        RETURN 0;

END;

