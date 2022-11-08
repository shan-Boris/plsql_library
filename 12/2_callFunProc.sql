-- Создай скрипт с набором анонимных блоков, для вызова Ваших процедур и функций.

DECLARE
    CLIENT_ID$              NUMBER;
    BOOK_ID$                NUMBER;
    READER_OK$              NUMBER;
    DELIVERY_EXEMPLAR_ID$   NUMBER;
    

BEGIN

    CLIENT_ID$ := CREATE_CLIENT(
        FIRST_NAME$ => 'Имя', 
        LAST_NAME$ => 'Фамилия', 
        FATHER_NAME$ => 'Отчество', 
        BIRTHDAY$ => TO_DATE('15/5/2020', 'dd/mm/yyyy'), 
        EMPLOYEE$ => '', 
        RATING$ => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');


    BOOK_ID$ := CREATE_BOOK(
        AMOUNT_BOOKS$  => 3,
        PUBLISHER$ => 'Издательство',
        TITLE$ => 'Название',
        SUMMARY$ => 'Содержание',
        YEAR_OF_PUBLICATION$ => 2010,
        AGE_LIMIT$ => 5,
        PRICE$ => 500,
        BOOK_TYPE$ => 'Книга',
        A_FIRST_NAMES$ => A_FIRST_NAME('Мишель', 'Хелен'),
        A_LAST_NAMES$ => A_LAST_NAME('Бюсси', 'Скейлз'),
        A_FATHER_NAMES$ => A_FATHER_NAME(' ', ' ')
        );
    DBMS_OUTPUT.put_line ('--------------------');


    READER_OK$ := CHECK_READER(
        ID_CLIENT$ => 8,
        TITLE$ => 'Пандора'
    );

    IF READER_OK$ = 1 
        THEN DBMS_OUTPUT.put_line ('Можно выдать книгу');
        ELSE DBMS_OUTPUT.put_line ('Нельзя выдать книгу');
    END IF;
    DBMS_OUTPUT.put_line ('--------------------');


    DELIVERY_EXEMPLAR_ID$ := DELIVERY_BOOK(
        ID_CLIENT$ => 18,
        TITLE$ => 'Приключения Тома Сойера',
        PUBLISHER$ => 'Лабиринт'
    );
    DBMS_OUTPUT.put_line ('--------------------');


    RETURN_BOOK(
        ID_CLIENT$ => 18,
        TITLE$ => 'Буревестник',
        PUBLISHER$ => 'Манн',
        RATE_FROM_CLIENT$ => 4
    );
    DBMS_OUTPUT.put_line ('--------------------');


    TOOK_BOOKS_A_DAY(
        DAY$ => TO_DATE('1/12/2022', 'dd/mm/yyyy')
    );
    DBMS_OUTPUT.put_line ('--------------------');
    

    RETURN_BOOKS_A_DAY(
        DAY$ => TO_DATE('10/10/2022', 'dd/mm/yyyy')
    );

    DBMS_OUTPUT.put_line ('--------------------');


    REPORT_ABOUT_EXEMPLAR(
        ID_EXEMPLAR$ => 563
    );

    DBMS_OUTPUT.put_line ('--------------------');

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;

