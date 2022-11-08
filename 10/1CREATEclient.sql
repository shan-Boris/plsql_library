--Создай методы по созданию пользователя и выдачи чит. билета - Анонимный PL/SQL блок.

DECLARE
    CLIENT_ID$          NUMBER;
    FIRST_NAME$         CLIENT.FIRST_NAME%TYPE;
    LAST_NAME$          CLIENT.LAST_NAME%TYPE;
    FATHER_NAME$        CLIENT.FATHER_NAME%TYPE;
    BIRTHDAY$           CLIENT.BIRTHDAY%TYPE;
    EMPLOYEE$           CLIENT.EMPLOYEE%TYPE;
    RATING$             CLIENT.RATING%TYPE;

BEGIN
-- получаем данные с клиента
    FIRST_NAME$ := 'Имя';
    LAST_NAME$ := 'Фамилия';
    FATHER_NAME$ := 'Отчество';
    BIRTHDAY$ := TO_DATE('15/5/2000', 'dd/mm/yyyy');
    EMPLOYEE$ := '';
    RATING$ := 5;

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

END;


