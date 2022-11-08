

    CREATE OR REPLACE TYPE A_FIRST_NAME IS VARRAY (100) OF VARCHAR2(1000);
    /
    CREATE OR REPLACE TYPE A_LAST_NAME IS VARRAY (100) OF VARCHAR2(1000);
    /
    CREATE OR REPLACE TYPE A_FATHER_NAME IS VARRAY (100) OF VARCHAR2(1000);
    /

CREATE OR REPLACE FUNCTION CREATE_BOOK (
    AMOUNT_BOOKS$           IN NUMBER,
    PUBLISHER$              IN PUBLISHER.PUBLISHER%TYPE,
    TITLE$                  IN BOOK.TITLE%TYPE,
    SUMMARY$                IN BOOK.SUMMARY%TYPE,
    YEAR_OF_PUBLICATION$    IN BOOK.YEAR_OF_PUBLICATION%TYPE,
    AGE_LIMIT$              IN BOOK.AGE_LIMIT%TYPE,
    PRICE$                  IN BOOK.PRICE%TYPE,
    BOOK_TYPE$              IN BOOK_TYPE.TYPE%TYPE,
    A_FIRST_NAMES$          IN A_FIRST_NAME,
    A_LAST_NAMES$           IN A_LAST_NAME,
    A_FATHER_NAMES$         IN A_FATHER_NAME
)

RETURN NUMBER 
IS
    BOOKID$                 NUMBER;
    ANY_ROWS_FOUND          NUMBER;
    EXEMPLAR_ID$            NUMBER;
BEGIN

-- добавляем издательство если его еще в базе нет
    SELECT
        COUNT(*) INTO ANY_ROWS_FOUND
    FROM
        PUBLISHER
    WHERE
        PUBLISHER = PUBLISHER$;
    IF ANY_ROWS_FOUND = 0 THEN
        INSERT INTO PUBLISHER (
            PUBLISHER
        ) VALUES (
            PUBLISHER$
        );
    END IF;

-- получаем id для книги
    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

    -- добавляем книгу
    INSERT INTO BOOK (
        ID,
        TITLE,
        SUMMARY,
        YEAR_OF_PUBLICATION,
        AGE_LIMIT,
        PRICE,
        ID_PUBLISHER,
        ID_BOOK_TYPE
    ) VALUES (
        BOOKID$,
        TITLE$,
        SUMMARY$,
        YEAR_OF_PUBLICATION$,
        AGE_LIMIT$,
        PRICE$,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = PUBLISHER$ ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = BOOK_TYPE$)
    );

    -- добавляем авторов которых нет в базе в таблицу авторов 
    FOR I IN 1..A_FIRST_NAMES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            AUTHOR
        WHERE
            FIRST_NAME = A_FIRST_NAMES$(I) AND LAST_NAME = A_LAST_NAMES$(I) 
            AND FATHER_NAME = A_FATHER_NAMES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO AUTHOR (
                FIRST_NAME,
                LAST_NAME,
                FATHER_NAME
            ) VALUES (
                A_FIRST_NAMES$(I),
                A_LAST_NAMES$(I),
                A_FATHER_NAMES$(I)
            );   
        END IF;

        -- добавляем связь автор - книга
        INSERT INTO AUTHOR_WROTE_BOOK(
            ID_AUTHOR,
            ID_BOOK
        ) VALUES (
            (SELECT 
                ID 
            FROM AUTHOR 
            WHERE FIRST_NAME = A_FIRST_NAMES$(I) AND LAST_NAME = A_LAST_NAMES$(I) 
                AND FATHER_NAME = A_FATHER_NAMES$(I)),
            BOOKID$
        );
    END LOOP;

        -- добавляем экземпляры книг на склад в библиотеку и заносим в журнал приема книг
    FOR I IN 1..AMOUNT_BOOKS$ LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        )
        RETURNING ID INTO EXEMPLAR_ID$; 

        INSERT INTO LOG_ADD_DELETE_BOOK (
            ID_EXEMPLAR,
            ID_PUBLISHER,
            ENTERED
        ) VALUES (
            EXEMPLAR_ID$,
            ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = PUBLISHER$ ),
            TO_DATE(SYSDATE, 'dd/mm/yyyy')
        );
        DBMS_OUTPUT.put_line (TITLE$ || ' добавлена в библиотеку, экземпляр №' || EXEMPLAR_ID$);

    END LOOP;
    RETURN BOOKID$;
EXCEPTION
    WHEN SUBSCRIPT_BEYOND_COUNT THEN
        DBMS_OUTPUT.put_line ('Книга не добавлена в библиотеку');
        DBMS_OUTPUT.put_line ('Неправильно переданы данные об авторах');
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line ('Книга не добавлена в библиотеку');
        DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
        DBMS_OUTPUT.put_line (SQLERRM);
        RETURN 0;
END;

