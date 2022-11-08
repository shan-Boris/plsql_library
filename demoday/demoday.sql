----------------------------------------
--            НАВИГАЦИЯ
-- создание таблиц с ограничениями - 12
-- создание пакетов - 194 (необходим функционал для заполнения бд)
-- добавляем книги в бд - 1236
-- заполняем таблицу рейтингов, добавляем клиентов - 1806
-- заполняем журнал выдачи-возрата книг - 2026
-- сложные запросы - 2976
--вызов пакетных процедур и функций - 3253
-----------------------------------

-- создание таблиц с ограничениями
BEGIN

EXECUTE IMMEDIATE 'CREATE TABLE RATING (
        RATING NUMBER(3, 1) NOT NULL,
        STIMULATION VARCHAR2(100) DEFAULT NULL,
    CONSTRAINT RATING_PK PRIMARY KEY (RATING)
)'; -- содержит ограничения/поощрения



EXECUTE IMMEDIATE 'CREATE TABLE CLIENT (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        FIRST_NAME VARCHAR2(50) NOT NULL,
        LAST_NAME VARCHAR2(50) NOT NULL,
        FATHER_NAME VARCHAR2(50),
        BIRTHDAY DATE NOT NULL,
        EMPLOYEE VARCHAR2(50) DEFAULT NULL,
        RATING NUMBER(3, 1) NOT NULL,
    CONSTRAINT CLIENT_PK PRIMARY KEY (ID),
    CONSTRAINT FK_RATING_CLIENT FOREIGN KEY (RATING) REFERENCES RATING(RATING)
)'; -- содержит данные клиентов(фио, возраст, должность(если работник библиотеки), рейтинг(0 - черный список))

EXECUTE IMMEDIATE 'CREATE INDEX CLIENT_FIO_ID_IDX ON CLIENT(LAST_NAME, FIRST_NAME, ID)';


EXECUTE IMMEDIATE 'CREATE TABLE CARD_CHANGE_TIME (
        ID INTEGER,
        CREATE_CARD DATE NOT NULL,
        CHANGE_CARD DATE,
        DELETE_CARD DATE,
    CONSTRAINT CARD_CHANGE_TIME_PK PRIMARY KEY (ID)
)'; -- содержит время создания/изменения/удаления читательского билета

EXECUTE IMMEDIATE 'CREATE TABLE PUBLISHER (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        PUBLISHER VARCHAR2(100) NOT NULL,
    CONSTRAINT PUBLISHER_PK PRIMARY KEY (ID)
)'; -- содержит название издательства

EXECUTE IMMEDIATE 'CREATE TABLE BOOK_TYPE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        TYPE VARCHAR2(50) NOT NULL,
    CONSTRAINT BOOK_TYPE_PK PRIMARY KEY (ID)
)';-- содержит тип печатного материала

EXECUTE IMMEDIATE 'CREATE TABLE BOOK (
        ID INTEGER,
        TITLE VARCHAR2(300) NOT NULL,
        SUMMARY VARCHAR2(2000),
        YEAR_OF_PUBLICATION INTEGER,
        AGE_LIMIT INTEGER,
        PRICE NUMBER(8, 2),
        ID_PUBLISHER INTEGER,
        ID_BOOK_TYPE INTEGER,
    CONSTRAINT BOOK_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_PUBLISHER_BOOK FOREIGN KEY (ID_PUBLISHER) REFERENCES PUBLISHER(ID),
    CONSTRAINT FK_ID_BOOK_TYPE_BOOK FOREIGN KEY (ID_BOOK_TYPE) REFERENCES BOOK_TYPE(ID)
)';-- содержит данные печатных материалов

EXECUTE IMMEDIATE '
    CREATE SEQUENCE BOOK_ID_SEQ 
    INCREMENT BY 1 
    START WITH 1
    MAXVALUE 99999
    NOCACHE
    NOCYCLE'; -- последовательнось для таблицы BOOK

EXECUTE IMMEDIATE 'CREATE INDEX BOOK_TITLE_ID_IDX ON BOOK(TITLE, ID)';

EXECUTE IMMEDIATE 'CREATE TABLE EXEMPLAR (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_BOOK INTEGER NOT NULL,
        SPECIFIC VARCHAR2(150),
        ON_HOME INTEGER DEFAULT 0,
        ON_STORE INTEGER DEFAULT 0,
        ON_READ_ROOM INTEGER DEFAULT 0,
    CONSTRAINT EXEMPLAR_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_EXEMPLAR FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID)
)';-- содержит экземпляры печатных материалов и их местонахождение

EXECUTE IMMEDIATE 'CREATE TABLE LOG_READING_ROOM (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_CLIENT INTEGER,
        ARRIVE DATE NOT NULL,
        LEAVING DATE,
        ID_EXEMPLAR INTEGER,
    CONSTRAINT LOG_READING_ROOM_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_CLIENT_LOG_READING_ROOM FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT(ID),
    CONSTRAINT FK_ID_EXEMPLAR_LOG_READING_ROOM FOREIGN KEY (ID_EXEMPLAR) REFERENCES EXEMPLAR(ID)
)'; -- журнал посетителей читального зала

EXECUTE IMMEDIATE 'CREATE TABLE LOG_DELIVERY_RETURN_BOOK (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        TAKE_BOOK DATE NOT NULL,
        RETURN_BOOK DATE,
        RATING_BOOK NUMBER(3, 1),
        ID_CLIENT INTEGER,
        ID_EXEMPLAR INTEGER,
    CONSTRAINT LOG_DELIVERY_RETURN_BOOK_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_CLIENT_LOG_DELIVERY_RETURN_BOOK FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT(ID),
    CONSTRAINT FK_ID_EXEMPLAR_LOG_DELIVERY_RETURN_BOOK FOREIGN KEY (ID_EXEMPLAR) REFERENCES EXEMPLAR(ID)
)'; -- журнал приема/выдачи материалов, при возврате возможно выставление рейтинга материалу

EXECUTE IMMEDIATE 'CREATE TABLE LOG_ADD_DELETE_BOOK (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_EXEMPLAR INTEGER,
        ID_CLIENT INTEGER,
        ID_PUBLISHER INTEGER,
        ENTERED DATE NOT NULL,
        LEAV DATE,
        NOTE VARCHAR2(300),
    CONSTRAINT LOG_ADD_DELETE_BOOK_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_CLIENT_LOG_ADD_DELETE_BOOK FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT(ID),
    CONSTRAINT FK_ID_EXEMPLAR_LOG_ADD_DELETE_BOOK FOREIGN KEY (ID_EXEMPLAR) REFERENCES EXEMPLAR(ID),
    CONSTRAINT FK_ID_PUBLISHER_LOG_ADD_DELETE_BOOK FOREIGN KEY (ID_PUBLISHER) REFERENCES PUBLISHER(ID)
)'; -- журнал приема/списания материала

EXECUTE IMMEDIATE 'CREATE TABLE TAG (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        TAG VARCHAR2(50) NOT NULL,
    CONSTRAINT TAG_PK PRIMARY KEY (ID)
)'; -- содержит тэги


EXECUTE IMMEDIATE 'CREATE TABLE BOOK_HAVE_TAG (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_TAG INTEGER,
        ID_BOOK INTEGER,
    CONSTRAINT BOOK_HAVE_TAG_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_BOOK_HAVE_TAG FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID),
    CONSTRAINT FK_ID_TAG_BOOK_HAVE_TAG FOREIGN KEY (ID_TAG) REFERENCES TAG(ID)
)';-- связь книга - тэг

EXECUTE IMMEDIATE 'CREATE TABLE AUTHOR (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        FIRST_NAME VARCHAR2(50) NOT NULL,
        LAST_NAME VARCHAR2(50) NOT NULL,
        FATHER_NAME VARCHAR2(50),
    CONSTRAINT AUTHOR_PK PRIMARY KEY (ID)
)'; -- содержит данные авторов

EXECUTE IMMEDIATE 'CREATE INDEX AUTHOR_FIO_ID_IDX ON AUTHOR(LAST_NAME, FIRST_NAME, ID)';


EXECUTE IMMEDIATE 'CREATE TABLE AUTHOR_WROTE_BOOK (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_AUTHOR INTEGER,
        ID_BOOK INTEGER,
    CONSTRAINT AUTHOR_WROTE_BOOK_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_AUTHOR_WROTE_BOOK FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID),
    CONSTRAINT FK_ID_AUTHOR_AUTHOR_WROTE_BOOK FOREIGN KEY (ID_AUTHOR) REFERENCES AUTHOR(ID)
)'; -- связь автор - книга

EXECUTE IMMEDIATE 'CREATE TABLE GENRE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        GENRE VARCHAR2(350) NOT NULL,
    CONSTRAINT GENRE_PK PRIMARY KEY (ID)
)'; -- содержит жанры

EXECUTE IMMEDIATE 'CREATE TABLE BOOK_HAVE_GENRE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_GENRE INTEGER,
        ID_BOOK INTEGER,
    CONSTRAINT BOOK_HAVE_GENRE_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_BOOK_HAVE_GENRE FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID),
    CONSTRAINT FK_ID_GENRE_BOOK_HAVE_GENRE FOREIGN KEY (ID_GENRE) REFERENCES GENRE(ID)
)'; -- связь книга - жанр

EXECUTE IMMEDIATE 'CREATE TABLE PREFERENCE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_GENRE INTEGER,
        ID_CLIENT INTEGER,
    CONSTRAINT PREFERENCE_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_CLIENT_PREFERENCE FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT(ID),
    CONSTRAINT FK_ID_GENRE_PREFERENCE FOREIGN KEY (ID_GENRE) REFERENCES GENRE(ID)
)'; -- содержит любимые жанры читателя

END;
/


-- пакет для работы с книгами
CREATE OR REPLACE PACKAGE book_pkg
IS
    TYPE a_first_name IS VARRAY (100) OF VARCHAR2(100);
    TYPE a_last_name IS VARRAY (100) OF VARCHAR2(100);
    TYPE a_father_name IS VARRAY (100) OF VARCHAR2(100);
    TYPE tag IS VARRAY (100) OF VARCHAR2(100);
    TYPE genre IS VARRAY (100) OF VARCHAR2(100);

-- добавление книги
    FUNCTION create_book (
        
        amount_books           IN NUMBER,
        issuer                 IN PUBLISHER.PUBLISHER%TYPE,
        title                  IN BOOK.TITLE%TYPE,
        summary                IN BOOK.SUMMARY%TYPE,
        year_of_publication    IN BOOK.YEAR_OF_PUBLICATION%TYPE,
        age_limit              IN BOOK.AGE_LIMIT%TYPE,
        price                  IN BOOK.PRICE%TYPE,
        book_type              IN BOOK_TYPE.TYPE%TYPE,
        a_first_names          IN a_first_name,
        a_last_names           IN a_last_name,
        a_father_names         IN a_father_name,
        tags                   IN tag,
        genres                 IN genre

    )
    RETURN NUMBER;

-- проверка отсутствия издательства в бд
    FUNCTION publisher_is_new(
        publ          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- проверка отсутствия типа печатного материала в бд
    FUNCTION book_type_is_new(
        book_type       IN BOOK_TYPE.TYPE%TYPE
    )
    RETURN NUMBER;

-- проверка отсутствия автора в бд
    FUNCTION author_is_new(
        firstname          IN VARCHAR2,
        lastname           IN VARCHAR2,
        fathername         IN VARCHAR2
    )
    RETURN NUMBER;

-- проверка отсутствия тэга в бд
    FUNCTION tag_is_new(
        tag$          IN VARCHAR2
    )
    RETURN NUMBER;

-- проверка отсутствия жанра в бд
    FUNCTION genre_is_new(
        genre$          IN VARCHAR2
    )
    RETURN NUMBER;

-- проверка читателя на возможность получения книги
    FUNCTION check_reader_for_book (
        client_id        IN  CLIENT.ID%TYPE,
        titleBook        IN  BOOK.TITLE%TYPE,
        issuere          IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- найти свободный экземпляр для выдачи домой
    FUNCTION get_free_exemplar (
        title        IN  BOOK.TITLE%TYPE,
        issuer       IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- выдача книги клиенту
    FUNCTION delivery_book (
        id_client          IN CLIENT.ID%TYPE,
        title              IN BOOK.TITLE%TYPE,
        issuer          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER; 

-- выдать книгу если клиент прошел проверку на соответствие книге
    FUNCTION get_book (
        id_client$          IN CLIENT.ID%TYPE,
        title$              IN BOOK.TITLE%TYPE,
        issuer$             IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- найти экземпляр, который взял клиент
    FUNCTION find_exemplar_of_client(
        title$                  IN BOOK.TITLE%TYPE, 
        publisher$              IN PUBLISHER.PUBLISHER%TYPE, 
        id_client$              IN CLIENT.ID%TYPE 
    )
    RETURN NUMBER;
-- вернуть книгу в библиотеку
    PROCEDURE return_book (
        id_client$          IN CLIENT.ID%TYPE,
        title$              IN BOOK.TITLE%TYPE,
        publisher$          IN PUBLISHER.PUBLISHER%TYPE,
        rate_from_client$   IN NUMBER
    );

END;
/

CREATE OR REPLACE PACKAGE BODY book_pkg
IS

    FUNCTION publisher_is_new(
        publ       IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER
    IS
        any_rows_found          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO any_rows_found
        FROM
            PUBLISHER
        WHERE
            PUBLISHER = publ;
        IF any_rows_found = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;

    FUNCTION book_type_is_new(
        book_type       IN BOOK_TYPE.TYPE%TYPE
    )
    RETURN NUMBER
    IS
        any_rows_found          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO any_rows_found
        FROM
            BOOK_TYPE
        WHERE
            TYPE = book_type;
        IF any_rows_found = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;

    FUNCTION author_is_new(
        firstname          IN VARCHAR2,
        lastname           IN VARCHAR2,
        fathername         IN VARCHAR2
    )
    RETURN NUMBER
    IS
        any_rows_found          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO any_rows_found
        FROM
            AUTHOR
        WHERE
            FIRST_NAME = firstname AND LAST_NAME = lastname 
            AND FATHER_NAME = fathername;
        IF any_rows_found = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;

    FUNCTION tag_is_new(
        tag$          IN VARCHAR2
    )
    RETURN NUMBER
    IS
        any_rows_found          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO any_rows_found
        FROM
            TAG
        WHERE
            TAG = tag$;

        IF any_rows_found = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;
    
    FUNCTION genre_is_new(
        genre$          IN VARCHAR2
    )
    RETURN NUMBER
    IS
        any_rows_found          NUMBER;
    BEGIN
        SELECT
            COUNT(*) INTO any_rows_found
        FROM
            GENRE
        WHERE
            GENRE = genre$;

        IF any_rows_found = 0
            THEN RETURN 1;
            ELSE RETURN 0;
        END IF;
    END;

    FUNCTION create_book (
        amount_books           IN NUMBER,
        issuer                 IN PUBLISHER.PUBLISHER%TYPE,
        title                  IN BOOK.TITLE%TYPE,
        summary                IN BOOK.SUMMARY%TYPE,
        year_of_publication    IN BOOK.YEAR_OF_PUBLICATION%TYPE,
        age_limit              IN BOOK.AGE_LIMIT%TYPE,
        price                  IN BOOK.PRICE%TYPE,
        book_type              IN BOOK_TYPE.TYPE%TYPE,
        a_first_names          IN a_first_name,
        a_last_names           IN a_last_name,
        a_father_names         IN a_father_name,
        tags                   IN tag,
        genres                 IN genre
        )
    RETURN NUMBER 
    IS
        exemplar_id             NUMBER;
        bookid                  NUMBER;
    BEGIN

-- добавляем издательство если его еще в базе нет
        IF publisher_is_new(issuer) = 1
            THEN 
                INSERT INTO PUBLISHER (
                    PUBLISHER
                ) VALUES (
                    issuer
                );
                COMMIT;
        END IF;

-- добавляем тип материала если его еще в базе нет
        IF book_type_is_new(book_type) = 1
            THEN 
                INSERT INTO BOOK_TYPE (
                    TYPE
                ) VALUES (
                    book_type
                );
                COMMIT;
        END IF;

-- получаем id для книги
        bookid := BOOK_ID_SEQ.NEXTVAL;

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
            bookid,
            title,
            summary,
            year_of_publication,
            age_limit,
            price,
            (SELECT ID FROM PUBLISHER WHERE PUBLISHER = issuer),
            (SELECT ID FROM BOOK_TYPE WHERE TYPE = book_type)
        );
        COMMIT;
-- проверяем авторов и если еще нет в базе то добавляем
        FOR I IN 1..a_first_names.COUNT LOOP
            IF author_is_new(a_first_names(I), a_last_names(I), a_father_names(I)) = 1
                THEN
                    INSERT INTO AUTHOR (
                        FIRST_NAME,
                        LAST_NAME,
                        FATHER_NAME
                    ) VALUES (
                        a_first_names(I),
                        a_last_names(I),
                        a_father_names(I)
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
                WHERE FIRST_NAME = a_first_names(I) AND LAST_NAME = a_last_names(I) 
                    AND FATHER_NAME = a_father_names(I)),
                bookid
            );
            COMMIT;
        END LOOP;

-- добавляем экземпляры книг на склад в библиотеку и заносим в журнал приема книг
        FOR I IN 1..amount_books LOOP
            INSERT INTO EXEMPLAR (
                ID_BOOK,
                ON_STORE
            ) VALUES (
                bookid,
                1
            )
            RETURNING ID INTO exemplar_id; 

            INSERT INTO LOG_ADD_DELETE_BOOK (
                ID_EXEMPLAR,
                ID_PUBLISHER,
                ENTERED
            ) VALUES (
                exemplar_id,
                ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = issuer ),
                TO_DATE(SYSDATE, 'dd/mm/yyyy')
            );
            DBMS_OUTPUT.put_line (title || ' добавлена в библиотеку, экземпляр №' || exemplar_id);

        END LOOP;

-- проверяем тэги и если еще нет в базе то добавляем
        FOR I IN 1..tags.COUNT LOOP
            IF tag_is_new(tags(I)) = 1
                THEN
                    INSERT INTO TAG (
                        TAG
                    ) VALUES (
                        tags(I)
                    );  
            END IF;

-- добавляем связь тэг - книга
            INSERT INTO BOOK_HAVE_TAG(
                ID_TAG,
                ID_BOOK
            ) VALUES (
                (SELECT ID FROM TAG WHERE TAG = tags(I)),
                bookid
            );
        END LOOP;

-- проверяем жанры и если еще нет в базе то добавляем
        FOR I IN 1..genres.COUNT LOOP
            IF genre_is_new(genres(I)) = 1
                THEN
                    INSERT INTO GENRE (
                        GENRE       
                    ) VALUES (
                        genres(I)
                    );  
            END IF;

-- добавляем связь жанр - книга
            INSERT INTO BOOK_HAVE_GENRE(
                ID_GENRE,
                ID_BOOK
            ) VALUES (
                (SELECT ID FROM GENRE WHERE GENRE = genres(I)),
                bookid
            );
        END LOOP;

        RETURN bookid;
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

    FUNCTION check_reader_for_book (
        client_id        IN  CLIENT.ID%TYPE,
        titleBook        IN  BOOK.TITLE%TYPE,
        issuere          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER 
    IS
        resulting          NUMBER;
        e_invalid_client   EXCEPTION;
        e_invalid_book     EXCEPTION;
        count_client       NUMBER;
        count_book         NUMBER;
        count_e_on_store   NUMBER;
        already_took_book  NUMBER;
        rating             NUMBER;
        age_limit          NUMBER;
        birthday           DATE;

    BEGIN

        resulting := 0;
    -- проверка существования клиента в базе
        SELECT 
            COUNT(ID)
        INTO count_client
        FROM CLIENT 
        WHERE ID = client_id;
        IF count_client = 0 THEN
            RAISE e_invalid_client;
        END IF;

    -- проверка существования книги
        SELECT 
            COUNT(B.ID)
        INTO count_book
        FROM BOOK B
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
        WHERE TITLE = titleBook
                AND P.PUBLISHER = issuere;
        IF count_book = 0 THEN
            RAISE e_invalid_book;
        END IF;

    -- узнаем сколько есть экземпляров на складе
        SELECT
            COUNT(TITLE)
        INTO count_e_on_store
        FROM EXEMPLAR E
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
        WHERE TITLE = titleBook
              AND P.PUBLISHER = issuere
              AND ON_STORE = 1;

    -- узнаем взял ли уже эту книгу
        SELECT 
            COUNT(*)
        INTO already_took_book
        FROM LOG_DELIVERY_RETURN_BOOK DRB
            JOIN EXEMPLAR E
                ON E.ID = DRB.ID_EXEMPLAR
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
        WHERE rownum = 1
            AND DRB.RETURN_BOOK IS NULL
            AND B.TITLE = titleBook
            AND DRB.ID_CLIENT = client_id;

    -- узнаем рейтинг клиента
        SELECT
            RATING
        INTO rating
        FROM CLIENT C
        WHERE C.ID = client_id;
        
    -- узнаем возрастной ценз книги
        SELECT
            AGE_LIMIT
        INTO age_limit
        FROM BOOK B
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
        WHERE TITLE = titleBook
            AND P.PUBLISHER = issuere;

        SELECT
            BIRTHDAY
        INTO birthday
        FROM CLIENT
        WHERE ID = client_id;


        IF count_e_on_store > 1 
            AND already_took_book = 0
            AND rating != 0
            AND age_limit <= 
                (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birthday)) --проверяем прохождение возрастного ценза
            THEN resulting := 1;
        END IF;

    -- выводим информацию почему нельзя взять книгу
        IF resulting = 0
        THEN
            IF count_e_on_store <= 1
            THEN DBMS_OUTPUT.put_line ('Нет экземпляра для выдачи');
            END IF;
            IF already_took_book != 0
            THEN DBMS_OUTPUT.put_line ('Уже такую книгу взял');
            END IF;
            IF rating = 0
            THEN DBMS_OUTPUT.put_line ('Клиент в черном списке');
            END IF;
            IF age_limit > 
                    (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birthday))
            THEN DBMS_OUTPUT.put_line ('Клиент не дорос до этой книги');
            END IF;
        END IF;

        RETURN resulting;
    EXCEPTION
        WHEN e_invalid_client THEN
            DBMS_OUTPUT.put_line ('Такого клиента не существует');
            RETURN resulting;
        WHEN e_invalid_book THEN
            DBMS_OUTPUT.put_line ('Такой книги нет в библиотеке');
            RETURN resulting;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            RETURN resulting;
    END;

    FUNCTION get_free_exemplar (
        title           IN  BOOK.TITLE%TYPE,
        issuer       IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER
    IS
        id_exemplar        EXEMPLAR.ID%TYPE;
    BEGIN
        SELECT 
            E.ID
        INTO    
            id_exemplar
        FROM EXEMPLAR E
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
        WHERE TITLE = title
            AND PUBLISHER = issuer
            AND ON_STORE = 1
        FETCH FIRST 1 ROWS ONLY;
    RETURN id_exemplar;
    END;

    FUNCTION delivery_book (
        id_client          IN CLIENT.ID%TYPE,
        title              IN BOOK.TITLE%TYPE,
        issuer             IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER 
    IS
        id_exemplar        EXEMPLAR.ID%TYPE;

    BEGIN

    --находим экземпляр книги для выдачи
    id_exemplar := get_free_exemplar(title => title, 
                                    issuer => issuer);

    -- заполняем данные в журнал выдачи
        INSERT INTO LOG_DELIVERY_RETURN_BOOK (
            TAKE_BOOK,
            ID_CLIENT,
            ID_EXEMPLAR
        ) VALUES (
            TO_DATE(SYSDATE, 'dd/mm/yyyy'), 
            id_client,
            id_exemplar 
        );

    -- меняем местоположение книги
        UPDATE EXEMPLAR
            SET ON_STORE = 0,
                ON_HOME = 1
        WHERE ID = id_exemplar;

    COMMIT;
        DBMS_OUTPUT.put_line (title || ' выдана, экземпляр №' || id_exemplar);
        RETURN id_exemplar;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line ('Нет экземпляра для выдачи');
            ROLLBACK;
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            ROLLBACK;
            RETURN 0;
    END;

    FUNCTION get_book (
        id_client$          IN CLIENT.ID%TYPE,
        title$              IN BOOK.TITLE%TYPE,
        issuer$             IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER
    IS
        delivery_exemplar_id   NUMBER;
    BEGIN
        IF check_reader_for_book(client_id => id_client$,
                                    titleBook => title$,                               
                                    issuere => issuer$) = 1 
        THEN delivery_exemplar_id := delivery_book(
                            id_client  => id_client$,
                            title  => title$,
                            issuer  => issuer$
                            );
        ELSE DBMS_OUTPUT.put_line ('Нельзя выдать книгу');
            delivery_exemplar_id := 0;

    END IF;
    RETURN delivery_exemplar_id;
    END;

    FUNCTION find_exemplar_of_client(
        title$                  IN BOOK.TITLE%TYPE, 
        publisher$              IN PUBLISHER.PUBLISHER%TYPE, 
        id_client$              IN CLIENT.ID%TYPE 
    )
    RETURN NUMBER
    IS
        id_exemplar$        EXEMPLAR.ID%TYPE;

    BEGIN
        SELECT 
            E.ID
        INTO    
            id_exemplar$
        FROM EXEMPLAR E
            JOIN BOOK B
                ON B.ID = E.ID_BOOK
            JOIN PUBLISHER P
                ON P.ID = B.ID_PUBLISHER
            JOIN LOG_DELIVERY_RETURN_BOOK DRB
                ON DRB.ID_EXEMPLAR = E.ID
            JOIN CLIENT C
                ON C.ID = DRB.ID_CLIENT
        WHERE TITLE = title$
            AND P.PUBLISHER = publisher$
            AND C.ID = id_client$
            AND DRB.RETURN_BOOK IS NULL;
        RETURN id_exemplar$;
    END;

    PROCEDURE return_book (
        id_client$          IN CLIENT.ID%TYPE,
        title$              IN BOOK.TITLE%TYPE,
        publisher$          IN PUBLISHER.PUBLISHER%TYPE,
        rate_from_client$   IN NUMBER
    )
    IS
        id_exemplar$        EXEMPLAR.ID%TYPE;
    BEGIN

    --находим экземпляр книги которую взял клиент
        id_exemplar$ := find_exemplar_of_client(title$, publisher$, id_client$);

  
    -- обновляем данные в журнал выдачи о возврате
        UPDATE LOG_DELIVERY_RETURN_BOOK DRB
            SET RETURN_BOOK = TO_DATE(SYSDATE, 'dd/mm/yyyy'),
                RATING_BOOK = rate_from_client$
        WHERE ID_CLIENT = id_client$
                AND ID_EXEMPLAR = id_exemplar$;


    -- меняем местоположение книги
        UPDATE EXEMPLAR
            SET ON_STORE = 1,
                ON_HOME = 0
        WHERE ID = id_exemplar$;
        COMMIT;

        DBMS_OUTPUT.put_line (title$ || ' возвращена, экземпляр №' || id_exemplar$);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line ('Такую книгу не брал');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            ROLLBACK;
    END;

END;
/


-- пакет для работы с клиентами
CREATE OR REPLACE PACKAGE client_pkg
IS

--создание пользователя и выдачи чит. билета
    FUNCTION create_client (
        first_name         IN CLIENT.FIRST_NAME%TYPE,
        last_name          IN CLIENT.LAST_NAME%TYPE,
        father_name        IN CLIENT.FATHER_NAME%TYPE,
        birthday           IN CLIENT.BIRTHDAY%TYPE,
        employee           IN CLIENT.EMPLOYEE%TYPE,
        rating             IN CLIENT.RATING%TYPE)
    RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY client_pkg
IS

    FUNCTION create_client (
        first_name         IN CLIENT.FIRST_NAME%TYPE,
        last_name          IN CLIENT.LAST_NAME%TYPE,
        father_name        IN CLIENT.FATHER_NAME%TYPE,
        birthday           IN CLIENT.BIRTHDAY%TYPE,
        employee           IN CLIENT.EMPLOYEE%TYPE,
        rating             IN CLIENT.RATING%TYPE)
    RETURN NUMBER IS
        client_id  NUMBER;
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
            first_name,
            last_name,
            father_name,
            birthday,
            employee,
            rating
        )
        RETURNING ID INTO client_id;

        INSERT INTO CARD_CHANGE_TIME (
            ID,
            CREATE_CARD
        ) VALUES (
            client_id,
            TO_DATE(SYSDATE, 'dd/mm/yyyy')
        );

        COMMIT;
        DBMS_OUTPUT.put_line ('Создан читательский билет на ' || first_name || ' ' || last_name || ' ' || father_name);
        RETURN client_id;
    EXCEPTION
        WHEN PROGRAM_ERROR THEN
            DBMS_OUTPUT.put_line ('Внутренняя ошибка pl/sql');
            ROLLBACK;
            RETURN 0;
        WHEN OTHERS THEN
            IF SQLCODE = '-1400' THEN
                DBMS_OUTPUT.put_line ('Полученные не все данные для создания пользователя');
            END IF; 
            DBMS_OUTPUT.put_line ('Читательский билет не создан');
            DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            ROLLBACK;
            RETURN 0;

    END;
END;
/


-- пакет для получения отчетов
CREATE OR REPLACE PACKAGE report_pkg
    IS
-- получение отчета о выданных книгах за день в json формате
    PROCEDURE took_books_a_day_json (
        p_day                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    );

-- получение отчета о вернувшихся книгах за день
    PROCEDURE return_books_a_day (
        p_day                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    );
    
-- получение полного отчета об инвентаризации в разрезе каждой книги (Когда поступила на склад, когда и кто её брал и вернул, когда была утрачена).
    PROCEDURE inventory;

-- отчет об инвентаризации книги(Когда поступила на склад, когда и кто её брал и вернул, когда была утрачена).
    PROCEDURE inventory_of_one (
        p_id_exemplar                IN NUMBER
    );

END;
/

CREATE OR REPLACE PACKAGE BODY report_pkg
    IS

    PROCEDURE took_books_a_day_json (
        p_day                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    )
    IS
        p_obj               JSON_OBJECT_T;
        p_arr               JSON_ARRAY_T;
        p_counter           NUMBER; 

    BEGIN

        p_arr := JSON_ARRAY_T('[]');
        p_obj := JSON_OBJECT_T('{}');
        p_counter := 1; --инициализируем счетчик кол-ва выданных книг

        FOR I IN (
            SELECT 
                TITLE, 
                LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR,
                PUBLISHER,
                E.ID AS EXEMPL
            FROM LOG_DELIVERY_RETURN_BOOK DRB 
                JOIN EXEMPLAR E
                    ON E.ID = DRB.ID_EXEMPLAR
                JOIN BOOK B 
                    ON (B.ID = E.ID_BOOK)
                LEFT JOIN AUTHOR_WROTE_BOOK AWB 
                    ON (AWB.ID_BOOK = B.ID)
                LEFT JOIN AUTHOR A 
                    ON(A.ID = AWB.ID_AUTHOR)
                LEFT JOIN PUBLISHER P 
                    ON (P.ID = B.ID_PUBLISHER) 
            WHERE TAKE_BOOK = p_day
            GROUP BY TITLE, PUBLISHER, E.ID
        )
        LOOP
            p_arr.APPEND(
                JSON_OBJECT_T('
                {"' || p_counter || '":{"Название":"' || I.TITLE || '",
                                            "Авторы":"' || I.AUTHOR || '",
                                            "Издательство":"' || I.PUBLISHER || '",
                                            "№ Экземпляра":' || I.EXEMPL || '}}'));
            p_counter := p_counter + 1;   
        END LOOP;

        p_obj.PUT('Выданные книги за ' || p_day, p_arr);
        DBMS_OUTPUT.PUT_LINE(p_obj.STRINGIFY);

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = '-1861' THEN
                DBMS_OUTPUT.put_line ('Неверная дата');
            ELSE
                DBMS_OUTPUT.put_line ('Ошибка');
                DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
                DBMS_OUTPUT.put_line (SQLERRM);
            END IF;
    END;


    PROCEDURE return_books_a_day (
        p_day                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    )
    IS
        p_rc                  SYS_REFCURSOR;
        p_title               BOOK.TITLE%TYPE;
        p_author              VARCHAR2(1000);
        p_publ                VARCHAR2(1000);
    BEGIN

        OPEN p_rc FOR
        SELECT 
            TITLE, 
            LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
            PUBLISHER 
        FROM LOG_DELIVERY_RETURN_BOOK DRB 
            JOIN EXEMPLAR E
                ON E.ID = DRB.ID_EXEMPLAR
            JOIN BOOK B 
                ON (B.ID = E.ID_BOOK)
            LEFT JOIN AUTHOR_WROTE_BOOK AWB 
                ON (AWB.ID_BOOK = B.ID)
            LEFT JOIN AUTHOR A 
                ON(A.ID = AWB.ID_AUTHOR)
            LEFT JOIN PUBLISHER P 
                ON (P.ID = B.ID_PUBLISHER) 
        WHERE RETURN_BOOK = p_day
        GROUP BY TITLE, PUBLISHER;

        DBMS_OUTPUT.put_line ('Вернувшиеся книги за ' || p_day);
        DBMS_OUTPUT.put_line (' ');
        DBMS_OUTPUT.put_line ('Название' || '     ' || 'Авторы' || '     ' || 'Издательство');
        LOOP
            FETCH p_rc INTO p_title, p_author, p_publ;
            EXIT WHEN p_rc%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(p_title || '     ' || p_author || '     ' || p_publ);
            DBMS_OUTPUT.PUT_LINE('-----    -------');
        END LOOP;

    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = '-1861' THEN
            DBMS_OUTPUT.put_line ('Неверная дата');
        ELSE
            DBMS_OUTPUT.put_line ('Ошибка');
            DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
        END IF;
    END;

    PROCEDURE inventory_of_one (
        p_id_exemplar                IN NUMBER
    )
    IS
        p_take_return_exemplar    SYS_REFCURSOR;
        e_invalid_exemplar     EXCEPTION;
        p_count_exemplar         NUMBER;
        p_client                 VARCHAR2(500);
        p_take                   DATE;
        p_return_b               DATE;
        p_title                  VARCHAR2(500);
        p_author                 VARCHAR2(500);
        p_publ                   VARCHAR2(500);
        p_date_ar                DATE;
        p_date_leav              DATE;
    BEGIN
    -- проверка существования экземпляра в базе
        SELECT 
            COUNT(ID)
        INTO p_count_exemplar
        FROM EXEMPLAR 
        WHERE ID = p_id_exemplar;
        IF p_count_exemplar = 0 THEN
            RAISE e_invalid_exemplar;
        END IF;

    -- проверка существования экземпляра в журнале приемки выдачи
        SELECT 
            COUNT(ID)
        INTO p_count_exemplar
        FROM LOG_ADD_DELETE_BOOK ADB
        WHERE ADB.ID_EXEMPLAR = p_id_exemplar;
        IF p_count_exemplar != 0 THEN
        -- выбираем данные о поступлении в библиотеку и об утрате
            SELECT
                ADB.ENTERED,
                ADB.LEAV
            INTO
                p_date_ar,
                p_date_leav
            FROM LOG_ADD_DELETE_BOOK ADB
                JOIN EXEMPLAR E
                    ON ADB.ID_EXEMPLAR = E.ID
                WHERE ID_EXEMPLAR = p_id_exemplar;
        END IF;
-- выбираем данные о книге
            SELECT
                TITLE, 
                LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
                PUBLISHER
            INTO
                p_title,
                p_author,
                p_publ
            FROM EXEMPLAR E
                JOIN BOOK B
                    ON B.ID = E.ID_BOOK
                LEFT JOIN AUTHOR_WROTE_BOOK AWB
                    ON AWB.ID_BOOK = B.ID
                LEFT JOIN AUTHOR A
                    ON A.ID = AWB.ID_AUTHOR
                LEFT JOIN PUBLISHER P
                    ON P.ID = B.ID_PUBLISHER
                WHERE E.ID = p_id_exemplar
                GROUP BY TITLE, PUBLISHER;

        DBMS_OUTPUT.put_line ('Данные о поступлении в библиотеку и об утрате экземпляра ' || p_id_exemplar);
        DBMS_OUTPUT.put_line (' ');
        DBMS_OUTPUT.put_line ('Название: ' || p_title);
        DBMS_OUTPUT.put_line ('Авторы: ' || p_author);
        DBMS_OUTPUT.put_line ('Издательство: ' || p_publ);
        DBMS_OUTPUT.put_line ('Поступила: ' || p_date_ar);
        DBMS_OUTPUT.put_line ('Убыла: ' || p_date_leav);
        DBMS_OUTPUT.PUT_LINE(' ');

        OPEN p_take_return_exemplar FOR
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
            WHERE ID_EXEMPLAR = p_id_exemplar;

        DBMS_OUTPUT.put_line ('Данные о том когда и кто её брал и вернул');
        DBMS_OUTPUT.put_line (' ');
        LOOP
            FETCH p_take_return_exemplar INTO p_client, p_take, p_return_b;
            EXIT WHEN p_take_return_exemplar%NOTFOUND;
            DBMS_OUTPUT.put_line ('Клиент - ' || p_client);
            DBMS_OUTPUT.put_line ('Взял - ' || p_take);
            DBMS_OUTPUT.put_line ('Вернул - ' || p_return_b);
            DBMS_OUTPUT.PUT_LINE('-----    -------');
        END LOOP;

    EXCEPTION
        WHEN e_invalid_exemplar THEN
            DBMS_OUTPUT.put_line ('Такого экземпляра не существует');
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('Код ошибки - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
    END;

    PROCEDURE inventory
    IS
        p_test_take_return_exemplar    SYS_REFCURSOR;
        p_test_exmp                  NUMBER;
    BEGIN
    
        OPEN p_test_take_return_exemplar FOR
            SELECT ID FROM EXEMPLAR ORDER BY ID;
-- получаем отчет для каждого экземпляра в библиотеке
        LOOP
            FETCH p_test_take_return_exemplar INTO p_test_exmp;
            EXIT WHEN p_test_take_return_exemplar%NOTFOUND;
            inventory_of_one(p_test_exmp);
            DBMS_OUTPUT.put_line ('++++++++++++++++++');
        END LOOP;

    END;

END;
/


-- добавляем книги
DECLARE
    BOOK_ID$                NUMBER;
BEGIN

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Манн',
        title => 'Книга радости. Как быть счастливым в меняющемся мире',
        summary => 'Два великих духовных лидера. Пять дней. Один вечный вопрос.В апреле 2015 года два самых радостных человека на свете - лауреаты Нобелевской премии Далай-лама и архиепископ Туту - встретились в Дхарамсале, чтобы отметить восьмидесятый день рождения Его Святейшества, оглянуться на прожитые годы, полные непростых испытаний, и найти ответ на вечный вопрос: как найти радость в жизни, когда нас обуревают повседневные невзгоды - от недовольства дорожными пробками до страха, что мы не сможем обеспечить семью, от злости на тех, кто несправедливо с нами обошелся, до горя утраты любимого человека, от опустошенности, которую приносит тяжелая болезнь, до бездны отчаяния, приходящей со смертью?Диалоги велись в течение недели. Духовные мастера обсуждали препятствия, которые мешают нам радоваться жизни, подробно проговаривали негативные эмоции, их воздействие на человека и...',
        year_of_publication => 2002,
        age_limit => 13,
        price => 1638,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Дуглас'),
        a_last_names => book_pkg.a_last_name('Абрамс'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('человека', 'Два', 'найти', 'вечный'),
        genres => book_pkg.genre('Религии мира')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 44,
        issuer => 'Манн',
        title => 'Клуб убийств по четвергам',
        summary => 'О книгеЧетверо престарелых героев...Первое серьезное дело для женщины-полицейского...Жестокое убийство...Добро пожаловать в клуб "Убийства по четвергам"!В доме престарелых, расположенном среди мирных сельских пейзажей, четверо друзей еженедельно встречаются в комнате для отдыха, чтобы обсудить нераскрытые преступления. Они называют себя "Клуб убийств по четвергам". Элизабет, Джойс, Ибрагим и Рон уже разменяли восьмой десяток, но у них все еще есть кое-какие трюки в запасе. Когда местного строителя находят мертвым, а рядом с телом обнаруживается таинственная фотография, "Клуб убийств по четвергам" внезапно получает первое настоящее дело. Вскоре количество трупов начинает расти. Сможет ли наша необычная команда поймать убийцу, пока не стало слишком поздно?Об автореРичард Томас Осман (родился 28 ноября 1970 года) - английский телеведущий, продюсер, комик и писатель, наиболее из...',
        year_of_publication => 2021,
        age_limit => 18,
        price => 798,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Ричард'),
        a_last_names => book_pkg.a_last_name('Осман'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('клуб', 'четвергам', 'Первое', 'убийств'),
        genres => book_pkg.genre('Детективы')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 4,
        issuer => 'Лабиринт',
        title => 'Приключения Тома Сойера',
        summary => '"Приключения Тома Сойера", одно из самых популярных произведений знаменитого американского писателя Марка Твена, рассказывает о жизни в маленьком городке на Миссисипи в 30-40-х годахХ1Х века. Как признавался сам автор, большинство приключений, описанных в этой книге, происходило на самом деле - с ним самим или его школьными товарищами. И хотя с тех пор прошло уже почти два столетия, проделки Тома по-прежнему вызывают улыбку и сочувствие, причем не только у юных читателей. Недаром Марк Твен заявлял, что своей книгой он хотел бы напомнить взрослым, какими они были когда-то, что думали и чувствовали и какие удивительные события с ними случались.Книга с классическими иллюстрациями Анатолия Иткина.Для детей 8-12 лет.',
        year_of_publication => 2020,
        age_limit => 3,
        price => 1162,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Марк'),
        a_last_names => book_pkg.a_last_name('Твен'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Тома', 'Приключения', 'самых', 'Сойера'),
        genres => book_pkg.genre('Приключения', 'Детективы')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 6,
        issuer => 'Феникс',
        title => 'Урри Вульф и похититель собак. История юного изобретателя',
        summary => 'Не обязательно быть взрослым, чтобы совершать открытия. Урри Вульф - мальчик-изобретатель - знает это абсолютно точно. Больше всего на свете Урри мечтает построить скоростной космический корабль, чтобы путь на Луну и обратно занимал не больше часа. А на Луну ему нужно попасть непременно. Ведь там его ждёт папа.Сумеет ли Урри воплотить свою мечту? Или трудности, с которыми он столкнётся, заставят его отступить? Поживём - увидим. А пока ему предстоит помочь приятельнице Фэбби найти пропавшего щенка. Для этой цели Урри создаёт робопса со сверхострым нюхом, микровошь для прослушивания и авточерепаху "ПРЫТЬ", которые помогут отыскать пропажу. Вообще Урри глубоко убеждён, что в скором будущем мир будет заселён роботами. Машины будут лечить людей, защищать Землю от столкновения с метеоритами, а нанороботы бороться с вирусами. Его смелые мысли у одних вызывают смех, у др...',
        year_of_publication => 2021,
        age_limit => 5,
        price => 633,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Евгения'),
        a_last_names => book_pkg.a_last_name('Высокосная'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Урри', 'больше', 'Луну', 'взрослым'),
        genres => book_pkg.genre('Приключения', 'Детективы')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 24,
        issuer => 'Текст',
        title => '1984',
        summary => 'Прошло всего три года после окончания Второй мировой войны, когда Джордж Оруэлл (1903-1950) написал самое знаменитое свое произведение - роман-антиутопию "1984". Многое из того, о чем писал Джордж Оруэлл, покажется вам до безумия знакомым. Некоторые исследователи считают, что ни один западный читатель не постигнет суть "1984" так глубоко, как человек родом из Советского Союза.Война - это мирСвобода - это рабствоНезнание - силаКто управляет прошлым, тот управляет будущим; кто управляет настоящим, тот управляет прошлым. Действительность не есть нечто внешнее. Действительность существует в человеческом сознании и больше нигде.Когда любишь кого-то, ты его любишь, и, если ничего больше не можешь ему дать, ты все-таки даешь ему любовь…Джордж Оруэлл',
        year_of_publication => 2020,
        age_limit => 14,
        price => 344,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джордж'),
        a_last_names => book_pkg.a_last_name('Оруэлл'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('управляет', 'Оруэлл', 'прошлым', 'Действительность'),
        genres => book_pkg.genre('зарубежная проза')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 66,
        issuer => 'Эксмо',
        title => '1984',
        summary => 'Джордж Оруэлл — один из самых читаемых в мире авторов и очень противоречивая персона своего времени. Родился в Бенгалии, учился в Итоне, работал в полиции, на радио и в букинистическом магазине, воевал в Испании и писал книги. Ярый противник коммунизма и защитник демократического социализма, Оруэлл устроил бунт против общества, к которому так стремился, но в котором чувствовал себя абсолютно чужим.  В книге представлены четыре разных произведения Оруэлла: ранние романы «Дни в Бирме» и «Дочь священника», а также принесшие мировую известность сатирическая повесть-притча «Скотный двор» и антиутопия «1984».  Первый роман Оруэлла «Дни в Бирме» основан на его опыте работы в колониальной полиции Бирмы в 1920-е годы и вызвал горячие споры из-за резкого изображения колониального общества. «Дочь священника» знакомит с совершенно иным Оруэллом — мастером психологического ре...',
        year_of_publication => 2012,
        age_limit => 14,
        price => 844,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джордж'),
        a_last_names => book_pkg.a_last_name('Оруэлл'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('общества', 'полиции', 'Оруэлл', 'Оруэлл'),
        genres => book_pkg.genre('зарубежная проза')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 33,
        issuer => 'Антология',
        title => '1984',
        summary => 'Джордж Оруэлл (1903-1950) всем своим творчеством протестовал против тоталитарного общественного устройства. Эта тема в силу исторических причин была актуальна в литературе первой половины XX века, но не утратила своей злободневности и в наши дни. Роман-антиутопия "1984" (1949) рисует тоталитарный Лондон будущего - крупный город Океании, которая находится в беспрерывном состоянии войны с двумя другими мировыми сверхдержавами. В обществе принята жесткая социальная иерархия, большинство граждан живут в нищете и под непрекращающимся контролем Полиции мыслей. Главный герой Уинстон Смит многие годы выдает себя за добропорядочного чиновника, разделяющего общепринятые политические идеалы. Но внезапно вспыхнувшее чувство к коллеге Джулии переворачивает его жизнь: приносит недолгое счастье, но и ставит вне рамок закона.',
        year_of_publication => 2021,
        age_limit => 14,
        price => 391,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джордж'),
        a_last_names => book_pkg.a_last_name('Оруэлл'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Джордж', 'Оруэлл', 'творчеством', 'протестовал'),
        genres => book_pkg.genre('зарубежная проза')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 17,
        issuer => 'Каро',
        title => '1984',
        summary => 'Роман "1984" - вершина творчества Джорджа Оруэлла. В нем показано общество, в котором люди четко разделены на классы: верхний, привилегированный, партийная верхушка; средний, не имеющий права ни на что, находящийся под постоянным прицелом телекамер и подслушивающих устройств, лишенный общения и эмоций, делающий механическую работу по регулярному переписыванию истории, обделенный во всем; низший - как бы пролетариат. В этом обществе искореняется любая мысль; человек живет в страхе наказания, которое неизбежно последует за любую провинность. Такое общество уничтожает в человеке все человеческое. Чтобы человек меньше думал, примитивизируется язык, переписываются книги и газеты, поощряется доносительство, предательство - даже своих близких. Не остается ничего святого и, соответственно, ничего, для чего хотелось бы жить. Этот роман - захватывающее, но страшное повеств...',
        year_of_publication => 2016,
        age_limit => 14,
        price => 281,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джордж'),
        a_last_names => book_pkg.a_last_name('Оруэлл'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('человек', 'общество', 'роман', 'ничего'),
        genres => book_pkg.genre('зарубежная проза')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'АСТ',
        title => '1984',
        summary => 'Своеобразный антипод второй великой антиутопии XX века - "О дивный новый мир" Олдоса Хаксли. Что, в сущности, страшнее: доведенное до абсурда "общество потребления" - или доведенное до абсолюта "общество идеи"? По Оруэллу, нет и не может быть ничего ужаснее тотальной несвободы...Каждый день Уинстон Смит переписывает историю в соответствии с новой линией Министерства Правды. С каждой ложью, которую он переносит на бумагу, Уинстон всё больше ненавидит Партию, которая не интересуется ничем кроме власти, и которая не терпит инакомыслия. Но чем больше Уинстон старается думать иначе, тем сложнее ему становится избежать ареста, ведь Большой Брат всегда следит за тобой…
    ',
        year_of_publication => 2008,
        age_limit => 16,
        price => 269,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джордж'),
        a_last_names => book_pkg.a_last_name('Оруэлл'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Уинстон', 'общество', 'больше', 'антипод'),
        genres => book_pkg.genre('фантастика')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Эксмо',
        title => 'Гибель Богов-2. Душа Бога. Том 1',
        summary => 'Упорядоченное гибнет. Хаос рвёт его на части, Дальние обращают миры в мёртвые кристаллы. Гремит величайшая из битв, Рагнарёк, где все сражаются против всех в тщетной попытке прожить лишний день. Гибнут герои и защитники, а умершие, напротив, возвращаются к жизни. Из небытия выныривает тень величайшего оружия - трёх магических Мечей, Алмазного, Деревянного и Меча Людей. Только кому они понадобились в дни всеобщей погибели? Кто и зачем собрал в недрах Межреальности немёртвую Армаду? Куда ведёт золотой луч, путь, пройти по которому сможет лишь один? И зачем девочка Рандгрид бьётся изо всех сил с гигантским змеем - ведь в Рагнарёке нельзя победить!Или всё-таки можно?..',
        year_of_publication => 2020,
        age_limit => 15,
        price => 1450,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Ник'),
        a_last_names => book_pkg.a_last_name('Перумов'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('зачем', 'Упорядоченное', 'Хаос', 'гибнет'),
        genres => book_pkg.genre('фантастика')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 10,
        issuer => 'Феникс',
        title => 'Гибель Богов-2. Душа Бога. Том 2',
        summary => 'Самое масштабное эпическое полотно в отечественной фантастике. Цикл, ставший классикой русского фэнтези. Один из самых больших литературных русскоязычных фэндомов. Всё это - "Гибель Богов" Ника Перумова! История, начатая больше тридцати лет назад, подошла к своему завершению. Мы узнаем, что случилось со всеми героями саги, смертными и бессмертными, уцелела ли Вселенная Упорядоченного и вышел ли кто-нибудь победителем в схватке вселенских сил.В день, когда заканчиваются все пути, открываются все двери и находятся ответы на все вопросы. В день Рагнарёка, истинной гибели богов.',
        year_of_publication => 2023,
        age_limit => 14,
        price => 1431,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Ник'),
        a_last_names => book_pkg.a_last_name('Перумов'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Богов', 'день', 'масштабное', 'Самое'),
        genres => book_pkg.genre('Героическое отечественное фэнтези')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 34,
        issuer => 'Волчок',
        title => 'Каскадерки идут до конца',
        summary => 'Девочки такие разные: Кирка занимается спортом, а Варя играет на пианино, Кирка прыгает выше всех и бегает быстрее, зато Варя умеет выдумывать новые интересные слова. Одинаковые у них только причёски и царапины на коленках. Но для дружбы на всю жизнь этого мало. Нужно общее дело, чтоб не расставаться до самой старости! Например, снимать кино. В главной роли, конечно, Кирка - ловкая, смелая, настоящая каскадёрка! А Варя - сценарист и оператор.Но кино приходится забросить, когда с одной из девочек случается беда… а подруга приходит ей на помощь. Нельзя бросать дружбу на полпути. Каскадёрки никогда не сдаются!Анна Анисимова - автор детских книг, лауреат премии Маршака и финалист премии Крапивина. В издательстве "Волчок" выходили её книги "Гутя" и "Кедровый слоник".Для детей среднего школьного возраста.',
        year_of_publication => 2007,
        age_limit => 3,
        price => 308,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Анна', 'Ник'),
        a_last_names => book_pkg.a_last_name('Анисимова', 'Перумов'),
        a_father_names => book_pkg.a_father_name('Викторовна', ' '),
        tags => book_pkg.tag('Кирка', 'Варя', 'кино', 'премии'),
        genres => book_pkg.genre('Повести и рассказы о детях')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Пять четвертей',
        title => 'Василькин Д. Седьмой отряд',
        summary => 'Долгожданные каникулы наконец наступили, и выпускник третьего класса Дима Василькин впервые едет в летний лагерь. Будем откровенны: сама поездка ему была не очень интересна - наш герой просто готовил сюрприз лучшему другу. Как удивился бы Костик, обнаружив, что они проведут лето вместе! Только вот судьба преподносит свои сюрпризы!.. Кажется, каникулы безнадёжно испорчены. Или всё-таки нет?..Виктория Ледерман давно знакома читателям как классик современной детской литературы и лауреат множества премий, среди которых - "Книгуру", Корнейчуковская, Крапивинская, "Алиса", посвящённая памяти Кира Булычёва. Герои книг Виктории Ледерман - мальчишки и девчонки, которые попадают в самые необычайные обстоятельства, позволяющие им не только проверить свою дружбу на прочность, но и лучше узнать себя.Для младшего и среднего школьного возраста.',
        year_of_publication => 2020,
        age_limit => 3,
        price => 720,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Виктория', 'Анна'),
        a_last_names => book_pkg.a_last_name('Ледерман', 'Анисимова'),
        a_father_names => book_pkg.a_father_name(' ', 'Викторовна'),
        tags => book_pkg.tag('каникулы', 'Ледерман', 'наконец', 'Долгожданные'),
        genres => book_pkg.genre('Повести и рассказы о детях')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 55,
        issuer => 'XL Media',
        title => 'Проза бродячих псов. Том 1',
        summary => 'Мальчика по имени Ацуси Накадзима выгоняют из сиротского приюта, и так он оказывается в Иокогаме без денег и крыши над головой. Ацуси в таком отчаянии, что решается ограбить первого встречного. Однако сердце у него доброе, и вместо ограбления он спасает жизнь тонущему человеку, которого видит в реке. Этим человеком оказывается некто Осаму Дадзай — эксцентричный сотрудник так называемого Вооруженного детективного агентства. В данный момент он и его товарищи ищут загадочного тигра-людоеда, наводящего страх на жителей округи. Ацуси и сам натерпелся от этого тигра, поэтому соглашается помочь Дадзаю в поисках. Вскоре он знакомится с другими сотрудниками агентства, где каждый другого чуднее.',
        year_of_publication => 2021,
        age_limit => 5,
        price => 628,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Кафка', 'Анна'),
        a_last_names => book_pkg.a_last_name('Асагири', 'Анисимова'),
        a_father_names => book_pkg.a_father_name(' ', 'Викторовна'),
        tags => book_pkg.tag('Ацуси', 'оказывается', 'агентства', 'имени'),
        genres => book_pkg.genre('Манга')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 5,
        issuer => 'XL Media',
        title => 'Проза бродячих псов. Том 2',
        summary => 'Кёка Идзуми воспротивилась приказу мафии и едва не погибла по собственной вине. Ацуси Накадзима спас ее да еще тофу накормил - все ради того, чтобы выведать ценные сведения… Только мир и покой продлились недолго: Акутагава разработал коварный план похищения Ацуси. Тем временем перед закованным в цепи Дадзаем предстал бывший товарищ-мафиози, а теперь его недруг - Тюя Накахара. Дадзай Осаму против Тюи Накахары, Рюноскэ Акутагава против Ацуси Накадзимы… К чему приведет крупный конфликт между вооруженными детективами и мафией?',
        year_of_publication => 2021,
        age_limit => 5,
        price => 628,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Кафка'),
        a_last_names => book_pkg.a_last_name('Асагири'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Ацуси', 'Акутагава', 'против', 'Идзуми'),
        genres => book_pkg.genre('Манга')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 5,
        issuer => 'Олимп-Бизнес',
        title => 'Нет, спасибо, я просто смотрю. Как посетителя превратить в покупателя',
        summary => 'Гарри Фридман - мастер розничной торговли и обучения в этой области. Книга "Нет, спасибо, я просто смотрю" о розничной торговле. Уникальность Г. Фридмана и его книги заключается именно в непревзойденной способности превращать потенциальных покупателей в тех, кто действительно покупает, а также учить этому других. Используя юмор, сопричастность и свой огромный опыт, он рассказывает о том, как достичь вершин мастерства в обслуживании покупателей и стать самым успешным продавцом. Вы узнаете, как преодолеть сопротивление покупателя, как выяснить, что он хочет, как заставить его сделать не только основную, но и дополнительную покупку. Приемы, описанные в этой книге, позволят вам значительно ускорить продвижение по служебной лестнице.',
        year_of_publication => 2021,
        age_limit => 3,
        price => 767,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Гарри', 'Кафка'),
        a_last_names => book_pkg.a_last_name('Фридман', 'Асагири'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('розничной', 'покупателей', 'Фридман', 'Гарри'),
        genres => book_pkg.genre('Техники продаж')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 124,
        issuer => 'Манн',
        title => '45 татуировок продавана. Правила для тех, кто продаёт и управляет продажами',
        summary => 'О книгеНовые 45 татуировок из продавцового прошлого Максима Батырева - как в роли рядового менеджера по продажам, так и в роли руководителя: успехи, неудачи, выводы из них.Одна из самых непростых и в то же время интересных профессий - это профессия человека, который ежедневно, ежечасно и ежеминутно защищает интересы организации, проводя коммерческие переговоры с её потенциальными заказчиками и будущими партнерами.Максим Батырев уверен: все, чего он достиг в своей профессиональной деятельности, он достиг благодаря работе в продажах. Продажи учат защищать свои интересы, выступать публично, вести переговоры с клиентами, делать своими руками презентации, внятно формулировать свои мысли и многому другому.Продажи делают людей сильными.Если вы научитесь продавать товары с не самой очевидной выгодой на одном из самых высококонкурентных рынков, то вам по плечу будут практ...',
        year_of_publication => 2021,
        age_limit => 3,
        price => 1461,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Максим', 'Кафка'),
        a_last_names => book_pkg.a_last_name('Батырев', 'Асагири'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('интересы', 'самых', 'роли', 'переговоры'),
        genres => book_pkg.genre('Техники продаж')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 44,
        issuer => 'Дискурс',
        title => '11 исследований о жизни на Земле. Рождественские лекции Королевского института Великобритании',
        summary => 'Этот сборник лекций Королевского института посвящен исследованиям разнообразных организмов, которые могут приоткрыть тайну возникновения жизни на Земле. Еще сотню лет назад ученые с помощью рисунков пытались воссоздать, как выглядели динозавры, а сегодня представление о вымерших рептилиях кардинально изменилось. Уже в начале прошлого века исследователи предупреждали об угрозе очередного массового вымирания видов. Тогда же была озвучена идея экосистем, в которых органично взаимодействуют различные обитатели нашей планеты: растения, рыбы, животные, насекомые. Они общаются друг с другом и природной средой, посылают сигналы об опасности и умеют защищаться, а некоторые поражают своим пением, как, например, горбатые киты. В XXI веке наука подтверждает: от сложных и хрупких взаимосвязей между животными и растениями во многом зависят и люди.',
        year_of_publication => 2008,
        age_limit => 0,
        price => 376,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Хелен'),
        a_last_names => book_pkg.a_last_name('Скейлз'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('сборник', 'лекций', 'Королевского', 'института'),
        genres => book_pkg.genre('Концепции современного естествознания')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 11,
        issuer => 'Портал',
        title => 'Не приспособлен к жизни. Человеческая эволюция против современного мира',
        summary => 'Люди выкованы естественным отбором и отточены эволюцией. Они идеально приспособлены для мира… которого больше не существует. Но почему же так получилось? Разъяснит ситуацию Адам Харт - биолог, профессор Университета Глостершира, популяризатор науки, соавтор научно-популярных фильмов BBC. Мы не адаптированы к сегодняшней жизни по многим причинам. Благодаря этой книге вы не только сможете понять их, узнав больше об истории человечества, генетике, биогеографии, биохимии, половом отборе, психологии, социологии, но и найдете ответы на вопросы: - является ли ожирение, от которого страдают миллионы людей, результатом эволюции или дело в наследственной лени? - почему в высокотехнологичном, безопасном и очень удобном современном мире мы испытываем больше стресса, чем наши первобытные предки? - как повлияют на человечество новые технологии? - и почему, говоря о собственном...',
        year_of_publication => 2021,
        age_limit => 0,
        price => 616,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Адам', 'Хелен'),
        a_last_names => book_pkg.a_last_name('Харт', 'Скейлз'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('больше', 'почему', 'выкованы', 'Люди'),
        genres => book_pkg.genre('Другие биологические науки')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 16,
        issuer => 'Аркадия',
        title => 'Цветочная сеть',
        summary => 'Посреди пекинской зимы, в последние дни правления Дэн Сяопина, сын посла США в Китае найден мертвым: его тело погребено в замерзшем озере.Примерно в то же время на борту корабля с нелегальными мигрантами, дрейфующего у берегов Южной Калифорнии, помощник прокурора Дэвид Старк обнаруживает страшный груз: труп "красного принца" - наследника политической элиты КНР.Власти обеих стран подозревают, что убийства связаны между собой, и соглашаются на беспрецедентный шаг: несмотря на политические разногласия, объединить усилия по расследованию преступлений. Теперь Дэвиду Старку предстоит работать вместе с Лю Хулань - пекинской красной принцессой, инспектором Министерства общественной безопасности.',
        year_of_publication => 2020,
        age_limit => 18,
        price => 370,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Лиза', 'Хелен'),
        a_last_names => book_pkg.a_last_name('Си', 'Скейлз'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('пекинской', 'Посреди', 'последние', 'зимы'),
        genres => book_pkg.genre('Детективы')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Фантом Пресс',
        title => 'Черные кувшинки',
        summary => 'Девочка, любящая рисовать, невероятно красивая школьная учительница и старуха, которая видит все... В деревушке Живерни у реки найдено тело ребенка. Лоренс Серенак не так давно выпустился из полицейской школы, и это его первое расследование. Подозреваемых у него хоть отбавляй. Но главное - преступление очень похоже на давнее, случившееся в 1937 году. Может, они как-то связаны? Только старуха с совиным взглядом знает это. Только старуха знает, что история может повториться и девочка, что любит рисовать, и красавица-учительница в огромной опасности..."Черные кувшинки" - один из лучших романов Мишеля Бюсси.',
        year_of_publication => 2021,
        age_limit => 18,
        price => 728,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Мишель', 'Хелен'),
        a_last_names => book_pkg.a_last_name('Бюсси', 'Скейлз'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('старуха', 'Девочка', 'знает', 'любящая'),
        genres => book_pkg.genre('Детективы')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 19,
        issuer => 'Эксмо',
        title => 'Красный дракон',
        summary => 'Мы все безумцы или, может быть, это мир вокруг нас сошел с ума? Доктор Ганнибал Лектер, легендарный убийца-каннибал, попав за решетку, становится консультантом и союзником ФБР. Несомненно, Ганнибал Лектер - маньяк, но он и философ, и блестящий психиатр. Его мучает скука и отсутствие "интересных" книг в тюремной библиотеке. Зайдя в тупик в расследовании дела серийного убийцы, прозванного Красным Драконом, ФБР обращается к доктору Лектеру. Ведь только маньяк может понять маньяка. И Ганнибал Лектер принимает предложение. Для него важно доказать, что он умнее преступника, которого ищет ФБР.',
        year_of_publication => 2019,
        age_limit => 14,
        price => 650,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Томас'),
        a_last_names => book_pkg.a_last_name('Харрис'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('ФБР', 'Лектер', 'Ганнибал', 'маньяк'),
        genres => book_pkg.genre('Детективы')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Аркадия',
        title => 'Гомункул. Приключения Лэнгдона Сент-Ива',
        summary => 'Джеймс Блэйлок, знаменитый американский фантаст и лауреат множества престижных премий, положил начало движению стимпанка в литературе. Его роман "Гомункул" - настоящая жемчужина этого жанра: абсурдистская "черная комедия", в которой атмосфера, обычаи и технологии Викторианской эпохи соседствуют с таинствами древней магии, загадками далекого космоса и захватывающими приключениями в духе Жюля Верна и Герберта Уэллса. "Гомункул" - первое из цикла произведений, повествующих об удивительных похождениях профессора Лэнгдона Сент-Ива, ученого-изобретателя, большого охотника до всяческих диковин и джентльмена до мозга костей. Роман Блэйлока удостоен Премии им. Филипа К. Дика. Впервые на русском языке.',
        year_of_publication => 2022,
        age_limit => 10,
        price => 827,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джеймс', 'Томас'),
        a_last_names => book_pkg.a_last_name('Блэйлок', 'Харрис'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('роман', 'Гомункул', 'Блэйлок', 'Джеймс'),
        genres => book_pkg.genre('Фантастический зарубежный боевик')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 22,
        issuer => 'fanzon',
        title => 'Тень',
        summary => 'Финал первой трилогии MATERIA PRIMA. Чем закончится последняя схватка с неумолимым противником?Срок мирного договора между Варшавской республикой, Российской и Германской империями подходит к концу. Новое наступление на Варшаву неминуемо. Лидер Кинжальщиков смертельно болен, и предстоят выборы преемника.Граф Самарин оставил военную карьеру, но теперь вовлечен в придворные интриги. Алхимик Рудницкий берется расследовать ритуальные убийства и, как обычно, разматывает клубок, ведущий к Проклятым.Библейская легенда о нефилимах подтверждается, но Рудницкий и предположить не мог, что это коснется и его лично."Materia Prima по-прежнему один из самых крутых сериалов в польском фэнтези за последние годы, давайте не будем забывать об этом". - taniaksiazka.pl"Действие стремительное, скучать невозможно". - Empic.pl"Это отличная книга, сочетающая в себе фэнтези, исторический ...',
        year_of_publication => 2021,
        age_limit => 13,
        price => 586,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Адам', 'Томас'),
        a_last_names => book_pkg.a_last_name('Пшехшта', 'Харрис'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('Рудницкий', 'фэнтези'),
        genres => book_pkg.genre('Героическое зарубежное фэнтези')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Эксмо',
        title => 'Час Быка',
        summary => '"В "Часе Быка" я представил планету, на которую переселилась группа землян, они повторяют пионерское завоевание запада Америки, но на гораздо более высокой технической основе. Неимоверно ускоренный рост населения и капиталистическое хозяйствование привели к истощению планеты и массовой смертности от голода и болезней. Государственный строй на ограбленной планете, естественно, должен быть олигархическим. Чтобы построить модель подобного государства, я продолжил в будущее те тенденции гангстерского фашиствующего монополизма, какие зарождаются сейчас в Америке и некоторых других странах, пытающихся сохранить "свободу" частного предпринимательства на густой националистической основе.  Понятно, что не наука и техника отдаленного будущего или странные цивилизации безмерно далеких миров сделались целью моего романа. Люди будущей Земли, выращенные многовековым существова...',
        year_of_publication => 2022,
        age_limit => 3,
        price => 295,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Иван'),
        a_last_names => book_pkg.a_last_name('Ефремов'),
        a_father_names => book_pkg.a_father_name('Анатольевич'),
        tags => book_pkg.tag('основе', 'Часе', 'представил', 'Быка'),
        genres => book_pkg.genre('фантастика')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 74,
        issuer => 'АСТ',
        title => 'Понедельник начинается в субботу',
        summary => 'В этот том вошел знаменитый роман братьев Стругацких  «Понедельник начинается в субботу» — буквально раздерганная на цитаты история веселых, остроумных сотрудников таинственного института НИИЧАВО, где вполне всерьез занимаются исследованием магии и волшебства.',
        year_of_publication => 2019,
        age_limit => 10,
        price => 467,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Аркадий'),
        a_last_names => book_pkg.a_last_name('Стругацкий'),
        a_father_names => book_pkg.a_father_name('Максимович'),
        tags => book_pkg.tag('вошел', 'знаменитый', 'роман', 'братьев'),
        genres => book_pkg.genre('фантастика')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Феникс',
        title => 'Париж - всегда отличная идея!',
        summary => 'Новый роман автора бестселлеров The New York Times Джен МакКинли "Париж - всегда отличная идея!" назван лучшей книгой лета 2020 по версии Popsugar.Главная героиня книги, Челси, осознает, что последний раз была счастлива, влюблена и наслаждалась жизнью, когда жила год за границей. Вдохновившись теплыми и радостными воспоминаниями, Челси разыскивает Колина в Ирландии, Жан-Клода во Франции и Марчеллино в Италии в надежде, что один из этих трех мужчин, похитивших ее сердце много лет назад, на самом деле и был любовью всей ее жизни. В поисках себя и мужчины свой мечты Челси встречается лицом к лицу со своими страхами, прощается с иллюзиями и наконец находит свою любовь там, где никогда бы не подумала ее искать.',
        year_of_publication => 2005,
        age_limit => 8,
        price => 845,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джен'),
        a_last_names => book_pkg.a_last_name('МакКинли'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Челси', 'Новый', 'автора', 'роман'),
        genres => book_pkg.genre('Современный сентиментальный роман')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 64,
        issuer => 'Эксмо',
        title => 'Все твои совершенства',
        summary => 'Любимый автор пользователей TikTok, более 610 миллионов упоминаний. "Трудно признать, что браку пришел конец, когда любовь еще не ушла. Люди привыкли считать, что брак заканчивается только с утратой любви. Когда на место счастья приходит злость.  Но мы с Грэмом не злимся друг на друга. Мы просто стали другими.  Мы с Грэмом так давно смотрим в противоположные стороны, что я даже не могу вспомнить, какие у него глаза, когда он внутри меня.  Зато уверена, что он помнит, как выглядит каждый волосок на моем затылке, когда я отворачиваюсь от него по ночам".  Совершенной любви Куинн и Грэмма угрожает их несовершенный брак.  Они познакомились при сложных обстоятельствах. Драматичное, но красивое начало. Сейчас же близится конец. Что может спасти их отношения?  Куинн уверена, что должна забеременеть. Но ее уверенность становится и тем, что ведет их брак к концу.  Сколько ...',
        year_of_publication => 2015,
        age_limit => 13,
        price => 600,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Колин'),
        a_last_names => book_pkg.a_last_name('Гувер'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('брак', 'любви', 'уверена', 'Грэмом'),
        genres => book_pkg.genre('Современный сентиментальный роман')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Inspiria',
        title => 'Глядя на море',
        summary => 'Франсуаза Бурден - одна из ведущих авторов европейского "эмоционального романа".  Во Франции ее книги разошлись общим тиражом более 8 млн экземпляров.  "Le Figaro" охарактеризовала Франсуазу Бурден как одного из шести популярнейших авторов страны.  В мире романы Франсуазы представлены на 15 иностранных языках.     "Трогательный роман, прочно обосновавшийся на вершине книжных рейтингов". - France Info  "Франсуаза Бурден завораживает своим писательским талантом". - L Obs  "Романтичная оптимистка Франсуаза Бурден готова показать нам лучшее в мужчинах". - Le Parisien   Больше всего на свете Матье любит свой успешный книжный магазин, где проводит дни, а порой и ночи. Он все сильнее отдаляется от Тесс, которая, в свою очередь, больше всего на свете любит его.  Действие разворачивается в портовом городе, в Нормандии, где соленый воздух свободы пропитал все улицы. Тесс ...',
        year_of_publication => 2014,
        age_limit => 3,
        price => 564,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Франсуаза'),
        a_last_names => book_pkg.a_last_name('Бурден'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('Бурден', 'Франсуаза', 'авторов', 'больше'),
        genres => book_pkg.genre('Современный сентиментальный роман')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Inspiria',
        title => 'Пандора',
        summary => 'Дебютный роман британской писательницы Сьюзен Стокс-Чепмен — идеальное сочетание георгианской Англии и греческой мифологии. Международный бестселлер, права на издание выкуплены в 15 странах.  Лондон, 1799 год. Дора Блейк, начинающая художница-ювелир, живет со своей ручной сорокой в лавке древностей. Ныне место принадлежит ее дяде и находится в упадке, но в былые времена магазинчик родителей Доры был очень известным благодаря широкому ассортименту подлинных произведений искусства. Появление пифоса — загадочной древнегреческой вазы — и скрываемые им секреты меняют жизнь девушки: она видит шанс вернуть магазин и избавиться от гнета дяди. Однако заинтересованных в пифосе оказывается слишком много: кто-то благодаря ему может проложить дорогу в академическое будущее, другой — потешить самолюбие, а третий — сполна удовлетворить жажду денег. Что за тайны скрывает древняя находка и к...',
        year_of_publication => 2009,
        age_limit => 15,
        price => 796,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Сьюзен'),
        a_last_names => book_pkg.a_last_name('Стокс-Чепмен'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('благодаря', 'Дебютный', 'британской', 'роман'),
        genres => book_pkg.genre('Исторический роман')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 12,
        issuer => 'Эксмо',
        title => 'Шоколад',
        summary => 'Сонное спокойствие маленького французского городка нарушено приездом молодой женщины Вианн и ее дочери. Они появились вместе с шумным и ярким карнавальным шествием, а когда карнавал закончился, его светлая радость осталась в глазах Вианн, открывшей здесь свой Шоколадный магазин. Каким-то чудесным образом она узнает о сокровенных желаниях жителей городка и предлагает каждому именно такое шоколадное лакомство, которое заставляет его вновь почувствовать вкус к жизни."Шоколад" - это история о доброте и терпимости, о противостоянии невинных соблазнов и закоснелой праведности. Одноименный голливудский фильм режиссера Лассе Халлстрёма (с Жюльетт Бинош, Джонни Деппом и Джуди Денч в главных ролях) был номинирован на "Оскар" в пяти категориях и на "Золотой глобус" - в четырех.',
        year_of_publication => 2020,
        age_limit => 15,
        price => 369,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Джоанн'),
        a_last_names => book_pkg.a_last_name('Харрис'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('городка', 'Вианн', 'спокойствие', 'Сонное'),
        genres => book_pkg.genre('Современная зарубежная проза')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 16,
        issuer => 'Манн',
        title => 'Игромания',
        summary => 'Выпуск 01.19',
        year_of_publication => 2019,
        age_limit => 3,
        price => 163,
        book_type => 'Журнал',
        a_first_names => book_pkg.a_first_name('Дуглас'),
        a_last_names => book_pkg.a_last_name('Абрамс'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag(),
        genres => book_pkg.genre('Развлекательная литература')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 16,
        issuer => 'Манн',
        title => 'Буревестник',
        summary => 'Выпуск 04.14',
        year_of_publication => 2014,
        age_limit => 3,
        price => 20,
        book_type => 'Газета',
        a_first_names => book_pkg.a_first_name('Дуглас'),
        a_last_names => book_pkg.a_last_name('Абрамс'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag(),
        genres => book_pkg.genre('Развлекательная литература')
        );
    DBMS_OUTPUT.put_line ('--------------------');
END;
/


 -- заполняем таблицу рейтингов
BEGIN
    FOR I IN 0..10 LOOP
        INSERT INTO RATING (
            RATING
        ) VALUES (
            I
        );
    END LOOP;
END;
/


-- добавляем клиентов
DECLARE
    CLIENT_ID$                NUMBER;
BEGIN
    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Дина', 
        last_name => 'Евдокимова', 
        father_name => 'Евсеевна', 
        birthday => TO_DATE('1/1/1980', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 0
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Валерия', 
        last_name => 'Фадеева', 
        father_name => 'Михаиловна', 
        birthday => TO_DATE('2/2/1982', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 1
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Зара', 
        last_name => 'Елисеева', 
        father_name => 'Тимофеевна', 
        birthday => TO_DATE('3/3/1984', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 2
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Полина', 
        last_name => 'Кириллова', 
        father_name => 'Геннадьевна', 
        birthday => TO_DATE('4/4/1986', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 3
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Илона', 
        last_name => 'Самойлова', 
        father_name => 'Альвиановна', 
        birthday => TO_DATE('5/5/1988', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 4
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Изабелла', 
        last_name => 'Симонова', 
        father_name => 'Натановна', 
        birthday => TO_DATE('6/6/1990', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Северина', 
        last_name => 'Петрова', 
        father_name => 'Даниловна', 
        birthday => TO_DATE('7/7/1992', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 6
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Августина', 
        last_name => 'Маслова', 
        father_name => 'Давидовна', 
        birthday => TO_DATE('8/8/1994', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 7
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Олеся', 
        last_name => 'Осипова', 
        father_name => 'Альвиановна', 
        birthday => TO_DATE('9/9/1996', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 8
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Венера', 
        last_name => 'Сазонова', 
        father_name => 'Евгеньевна', 
        birthday => TO_DATE('10/10/1998', 'dd/mm/yyyy'), 
        employee => 'Библиотекарь', 
        rating => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Аверьян', 
        last_name => 'Фокин', 
        father_name => 'Пётрович', 
        birthday => TO_DATE('11/11/2000', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Игорь', 
        last_name => 'Петров', 
        father_name => 'Мартынович', 
        birthday => TO_DATE('12/12/2002', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 6
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Герман', 
        last_name => 'Гаврилов', 
        father_name => 'Петрович', 
        birthday => TO_DATE('13/2/2004', 'dd/mm/yyyy'), 
        employee => 'Библиотекарь', 
        rating => 6
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Василий', 
        last_name => 'Ефимов', 
        father_name => 'Серапионович', 
        birthday => TO_DATE('14/3/2006', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 7
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Клим', 
        last_name => 'Рябов', 
        father_name => 'Павлович', 
        birthday => TO_DATE('15/4/2008', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 7
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Лазарь', 
        last_name => 'Маслов', 
        father_name => 'Мартынович', 
        birthday => TO_DATE('16/5/2010', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 8
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Богдан', 
        last_name => 'Соколов', 
        father_name => 'Ярославович', 
        birthday => TO_DATE('17/6/2012', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 8
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Болеслав', 
        last_name => 'Лапин', 
        father_name => 'Леонидович', 
        birthday => TO_DATE('18/7/2014', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 9
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Остап', 
        last_name => 'Карпов', 
        father_name => 'Христофорович', 
        birthday => TO_DATE('19/8/2016', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 9
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => 'Савелий', 
        last_name => 'Селиверстов', 
        father_name => 'Мэлорович', 
        birthday => TO_DATE('20/9/2018', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 10
        );
    DBMS_OUTPUT.put_line ('--------------------');
END;
/


-- Заполняем журнал выдачи-возрата книг напрямую, т.к. нужен учебный материл для запросов с разными датами,
-- для действительной выдачи создана функция book_pkg.get_book(), записывает sysdate в время выдачи и производит проверки 
BEGIN
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/28', 'yyyy/mm/dd'),
        10,
        20,
        11);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/7/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/7/12', 'yyyy/mm/dd'),
        7,
        6,
        397);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/16', 'yyyy/mm/dd'),
        3,
        18,
        139);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/17', 'yyyy/mm/dd'),
        4,
        18,
        130);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/10/01', 'yyyy/mm/dd'), 
        9,
        455);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 455;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/11/19', 'yyyy/mm/dd'),
        3,
        2,
        504);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/11/8', 'yyyy/mm/dd'),
        6,
        13,
        170);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/3/01', 'yyyy/mm/dd'), 
        18,
        87);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 87;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/3/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/3/19', 'yyyy/mm/dd'),
        10,
        13,
        337);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/6/25', 'yyyy/mm/dd'),
        3,
        8,
        505);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        7,
        505);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 505;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/10/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/10/9', 'yyyy/mm/dd'),
        9,
        5,
        387);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/4/01', 'yyyy/mm/dd'), 
        14,
        280);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 280;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/9/24', 'yyyy/mm/dd'),
        5,
        18,
        481);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        2,
        70);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 70;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        9,
        270);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 270;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/4/01', 'yyyy/mm/dd'), 
        2,
        285);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 285;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/5', 'yyyy/mm/dd'),
        5,
        12,
        176);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/10/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/10/16', 'yyyy/mm/dd'),
        2,
        16,
        63);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        11,
        60);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 60;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/6/22', 'yyyy/mm/dd'),
        7,
        7,
        540);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/11', 'yyyy/mm/dd'),
        6,
        14,
        150);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/19', 'yyyy/mm/dd'),
        7,
        14,
        500);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/7/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/7/3', 'yyyy/mm/dd'),
        5,
        3,
        336);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/4/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/4/11', 'yyyy/mm/dd'),
        2,
        19,
        463);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/18', 'yyyy/mm/dd'),
        7,
        19,
        171);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/3/01', 'yyyy/mm/dd'), 
        15,
        421);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 421;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/10/01', 'yyyy/mm/dd'), 
        7,
        316);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 316;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/3/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/3/8', 'yyyy/mm/dd'),
        7,
        18,
        519);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/8/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/8/14', 'yyyy/mm/dd'),
        10,
        14,
        390);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/8/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/8/28', 'yyyy/mm/dd'),
        2,
        8,
        151);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/11/7', 'yyyy/mm/dd'),
        9,
        4,
        355);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/6/24', 'yyyy/mm/dd'),
        2,
        9,
        453);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/11', 'yyyy/mm/dd'),
        6,
        6,
        152);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/7/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/7/18', 'yyyy/mm/dd'),
        2,
        18,
        55);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/11/23', 'yyyy/mm/dd'),
        9,
        6,
        187);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/11/3', 'yyyy/mm/dd'),
        3,
        3,
        209);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        8,
        98);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 98;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/26', 'yyyy/mm/dd'),
        3,
        20,
        514);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/2/13', 'yyyy/mm/dd'),
        3,
        11,
        63);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/8/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/8/17', 'yyyy/mm/dd'),
        10,
        10,
        558);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/6/16', 'yyyy/mm/dd'),
        5,
        13,
        320);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/2/25', 'yyyy/mm/dd'),
        10,
        9,
        420);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/9/29', 'yyyy/mm/dd'),
        2,
        19,
        147);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/2/24', 'yyyy/mm/dd'),
        9,
        19,
        40);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/4', 'yyyy/mm/dd'),
        6,
        18,
        381);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/7/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/7/25', 'yyyy/mm/dd'),
        5,
        2,
        244);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        12,
        461);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 461;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/9/16', 'yyyy/mm/dd'),
        10,
        2,
        339);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/4/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/4/29', 'yyyy/mm/dd'),
        2,
        9,
        90);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/6/20', 'yyyy/mm/dd'),
        10,
        14,
        471);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/8/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/8/18', 'yyyy/mm/dd'),
        2,
        2,
        23);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/3/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/3/14', 'yyyy/mm/dd'),
        9,
        12,
        381);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/2/23', 'yyyy/mm/dd'),
        2,
        19,
        290);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/8/01', 'yyyy/mm/dd'), 
        4,
        228);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 228;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/12/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/12/23', 'yyyy/mm/dd'),
        1,
        6,
        377);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        18,
        549);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 549;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/9/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/9/9', 'yyyy/mm/dd'),
        5,
        6,
        51);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/20', 'yyyy/mm/dd'),
        3,
        18,
        92);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        11,
        91);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 91;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/8/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/8/13', 'yyyy/mm/dd'),
        4,
        20,
        344);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/11/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/11/18', 'yyyy/mm/dd'),
        10,
        19,
        468);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/2/24', 'yyyy/mm/dd'),
        2,
        12,
        560);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/6/28', 'yyyy/mm/dd'),
        2,
        15,
        405);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/3/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/3/15', 'yyyy/mm/dd'),
        7,
        16,
        371);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/22', 'yyyy/mm/dd'),
        3,
        20,
        414);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/4/01', 'yyyy/mm/dd'), 
        13,
        10);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 10;

    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/5/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/5/23', 'yyyy/mm/dd'),
        7,
        4,
        366);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/2/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/2/9', 'yyyy/mm/dd'),
        5,
        3,
        95);
    
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/6/01', 'yyyy/mm/dd'), 
        10,
        158);
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 158;
END;
/


-- сложные запросы
-- 1.Написать запрос поиска всех книг заданного автора (вывести наименование книг, жанра, возрастное ограничение и ФИО автора)
SELECT 
    TITLE, 
    LISTAGG(DISTINCT GENRE, '; ') AS GENRES, 
    LISTAGG(DISTINCT AGE_LIMIT, '; ') AS AGE_LIMITS, 
    FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME AS FIO
FROM AUTHOR A 
    LEFT JOIN AUTHOR_WROTE_BOOK AWB
        ON (A.ID = AWB.ID_AUTHOR)
    LEFT JOIN BOOK B
        ON (B.ID =AWB.ID_BOOK)
    LEFT JOIN BOOK_HAVE_GENRE BHG
        ON (B.ID = BHG.ID_BOOK)
    LEFT JOIN GENRE G
        ON (BHG.ID_GENRE = G.ID)
WHERE A.LAST_NAME = 'Абрамс'
GROUP BY TITLE, FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME;
/

-- 2.Написать запрос поиска всех книг изданных определенным издательством (позже/ранее заданной даты - вывести наименование книг, жанра, возрастное ограничение, ФИО автора и издательство)
SELECT 
    B.TITLE, 
    LISTAGG(G.GENRE, '; ') AS GENRES, 
    B.AGE_LIMIT, 
    LISTAGG(A.FIRST_NAME||' '||A.LAST_NAME||' '||A.FATHER_NAME, '; ') AS AUTHORS, 
    PUBLISHER
FROM PUBLISHER P
    JOIN BOOK B
        ON B.ID_PUBLISHER = P.ID
    LEFT JOIN AUTHOR_WROTE_BOOK AWB
        ON B.ID = AWB.ID_BOOK
    LEFT JOIN AUTHOR A 
        ON A.ID = AWB.ID_AUTHOR
    LEFT JOIN BOOK_HAVE_GENRE BHG
        ON B.ID = BHG.ID_BOOK
    LEFT JOIN GENRE G
        ON BHG.ID_GENRE = G.ID
WHERE P.PUBLISHER = 'Манн' AND B.YEAR_OF_PUBLICATION > 2000
GROUP BY TITLE, AGE_LIMIT, PUBLISHER;
/

-- 3.Найти книги по заданным критериям (по жанру, по тегам, по автору, по ограничению)
SELECT 
    B.TITLE, 
    LISTAGG(G.GENRE, '; ') AS GENRES, 
    LISTAGG(B.AGE_LIMIT, '; ') AS AGE_LIMITS, 
    LISTAGG(DISTINCT T.TAG, ', ') AS TAGS, 
    LISTAGG(DISTINCT A.FIRST_NAME||' '||A.LAST_NAME||' '||A.FATHER_NAME, '; ') AS AUTHOR
FROM BOOK_HAVE_TAG BHT 
    JOIN BOOK B 
        ON (B.ID = BHT.ID_BOOK)
    LEFT JOIN BOOK_HAVE_GENRE BHG 
        ON (B.ID = BHG.ID_BOOK)
    LEFT JOIN TAG T 
        ON (T.ID = BHT.ID_TAG)
    LEFT JOIN GENRE G 
        ON (BHG.ID_GENRE = G.ID)
    LEFT JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    LEFT JOIN AUTHOR A 
        ON (A.ID = AWB.ID_AUTHOR)
WHERE A.LAST_NAME = 'Оруэлл'
    AND B.AGE_LIMIT < 20
    AND T.TAG = 'общество'
GROUP BY TITLE;
/

-- 4.Найти ТОП 5 самых популярных книг (по кол-ву выдачи)
SELECT *
FROM (
    SELECT 
        TITLE, 
        COUNT(B.ID) AS "Выдано раз",
        RANK() OVER (ORDER BY (COUNT(B.ID)) DESC) AS rank
    FROM BOOK B
        JOIN EXEMPLAR E
            ON E.ID_BOOK = B.ID 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON E.ID = DRB.ID_EXEMPLAR
    GROUP BY TITLE)
WHERE rank <= 5;
/

-- 5.Найти ТОП 5 самых читающих пользователей (за заданный период)
SELECT *
    FROM (
    SELECT 
        LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME AS CLIENT, 
        COUNT(C.ID) AS "Читал(a) раз",
        RANK() OVER (ORDER BY (COUNT(C.ID)) DESC) AS rank
    FROM CLIENT C 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON (C.ID = DRB.ID_CLIENT)
    WHERE DRB.TAKE_BOOK BETWEEN TO_DATE('2022/5/01', 'yyyy/mm/dd') AND TO_DATE('2022/8/01', 'yyyy/mm/dd')
    GROUP BY LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME)
WHERE rank <= 5;
/

-- 6.Найти список книг которые не могут быть выданы читателю домой 
    SELECT 
    TITLE, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER,
    COUNT(B.ID) AS "Осталось на складе"
FROM EXEMPLAR E 
    JOIN BOOK B 
        ON (B.ID = E.ID_BOOK)
    JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER)
WHERE E.ON_STORE = 1 AND
EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(SELECT
                BIRTHDAY
                FROM CLIENT
                WHERE CLIENT.ID = 10)) <= B.AGE_LIMIT -- не выдается по возрастному цензу
    OR (SELECT 
            RATING
        FROM CLIENT
    WHERE ID = 10) = 0 -- не выдается с рейтингом 0
GROUP BY TITLE, PUBLISHER
UNION
SELECT *
    FROM(
    SELECT 
    TITLE, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER,
    COUNT(B.ID) AS "Осталось на складе"
FROM EXEMPLAR E 
    JOIN BOOK B 
        ON (B.ID = E.ID_BOOK)
    JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER)
WHERE E.ON_STORE = 1 
GROUP BY TITLE, PUBLISHER)
WHERE "Осталось на складе" <= 1;
/

-- 7.Запрос который покажет может ли читатель почитать/получить желаемую книгу
-- Нельзя взять последнюю книгу, нельзя взять книгу если должен сдать другую и просрочен срок сдачи, нельзя взять книгу и почитать если в черном списке(рейтинг=0)
SELECT 
    TITLE, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER,
    CASE WHEN ((SELECT
                    COUNT(TITLE)
                FROM EXEMPLAR E
                    JOIN BOOK B
                        ON B.ID = E.ID_BOOK
                WHERE TITLE = 'Все твои совершенства' 
                    AND ON_STORE = 1) > 1 -- если книга не последняя
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
                    AND C.ID = 10
                    AND B.TITLE = 'Все твои совершенства') = 0 -- если еще не взял эту книгу
            AND (SELECT
                    RATING
                FROM CLIENT C
                WHERE C.ID = 10) != 0 -- если рейтинг != 0
            AND (SELECT
                    AGE_LIMIT
                FROM BOOK B
                WHERE B.TITLE = 'Все твои совершенства') <= (
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
                        WHERE ID = 10))) -- если проходишь возрастной ценз
    )
        THEN 'YES' 
        ELSE 'NO' 
    END Можно_взять_домой
FROM BOOK B 
    JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER) 
    JOIN EXEMPLAR E
        ON E.ID_BOOK = B.ID
WHERE TITLE = 'Все твои совершенства'
GROUP BY TITLE, PUBLISHER;
/

-- 8.Вывести список просроченных книг и их держателей со сроком просрочки
SELECT 
    TITLE, 
    LISTAGG(A.FIRST_NAME||' '||A.LAST_NAME||' '||A.FATHER_NAME, '; ') AS AUTHORS, 
    PUBLISHER, 
    C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT, 
    ROUND(SYSDATE - DRB.TAKE_BOOK - 14)  AS OVERDUE_DAYS
FROM LOG_DELIVERY_RETURN_BOOK DRB
    JOIN EXEMPLAR E
        ON E.ID = DRB.ID_EXEMPLAR
    JOIN BOOK B 
        ON (B.ID = E.ID_BOOK)
    LEFT JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    LEFT JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    LEFT JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER) 
    JOIN CLIENT C 
        ON (C.ID = DRB.ID_CLIENT)
WHERE DRB.RETURN_BOOK IS NULL 
    AND ROUND(SYSDATE - DRB.TAKE_BOOK) > 14
GROUP BY TITLE, PUBLISHER, SYSDATE - DRB.TAKE_BOOK, C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME;
/

-- 9.Вывести список неблагонадежных читателей (если больше 2х просрочек)
SELECT C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT, 
    COUNT (C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME) AS НАРУШЕНИЯ
FROM LOG_DELIVERY_RETURN_BOOK DRB 
    JOIN CLIENT C 
        ON (C.ID = DRB.ID_CLIENT)
WHERE DRB.RETURN_BOOK IS NULL 
    AND ROUND(SYSDATE - DRB.TAKE_BOOK) > 14
    OR ROUND(DRB.RETURN_BOOK - DRB.TAKE_BOOK) > 14
GROUP BY C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME, RATING
HAVING COUNT (C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME) > 2;
/

-- 10.Найти книгу похожую на ранее прочитанную
SELECT  
    C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT, 
    B.TITLE AS "ПОСЛЕДНЯЯ ПРОЧИТАННАЯ",  
    B2.TITLE AS "РЕКОМЕНДАЦИЯ"
FROM LOG_DELIVERY_RETURN_BOOK DRB 
    JOIN CLIENT C 
        ON C.ID = DRB.ID_CLIENT
    JOIN EXEMPLAR E
        ON E.ID = DRB.ID_EXEMPLAR
    JOIN BOOK B 
        ON B.ID = E.ID_BOOK
    JOIN BOOK_HAVE_TAG BHT
        ON B.ID = BHT.ID_BOOK,
    BOOK B2
    JOIN BOOK_HAVE_TAG BHT2
        ON B2.ID = BHT2.ID_BOOK
WHERE DRB.TAKE_BOOK = (
                SELECT 
                    MAX(TAKE_BOOK) 
                FROM LOG_DELIVERY_RETURN_BOOK DRB2 
                WHERE DRB.ID_CLIENT = DRB2.ID_CLIENT
                ) 
    AND B.TITLE <> B2.TITLE
    AND C.ID = 7
    AND BHT.ID_TAG = BHT2.ID_TAG
GROUP BY C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME, B.TITLE, B2.TITLE
ORDER BY C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME
FETCH FIRST 1 ROWS ONLY;
/


--вызов пакетных процедур и функций
DECLARE
    CLIENT_ID$              NUMBER;
    BOOK_ID$                NUMBER;
    DELIVERY_EXEMPLAR_ID$   NUMBER;
BEGIN
-- добавление клиента
    CLIENT_ID$ := client_pkg.create_client(
            first_name => 'Имя', 
            last_name => 'Фамилия', 
            father_name => 'Отчество', 
            birthday => TO_DATE('1/1/1980', 'dd/mm/yyyy'), 
            employee => '', 
            rating => 5
            );
    DBMS_OUTPUT.put_line ('--------------------');

--добавление книги
    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 5,
        issuer => 'Издательство',
        title => 'Название',
        summary => 'Содержание',
        year_of_publication => 2022,
        age_limit => 13,
        price => 1638,
        book_type => 'Книга',
        a_first_names => book_pkg.a_first_name('Дуглас'),
        a_last_names => book_pkg.a_last_name('Абрамс'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('человека'),
        genres => book_pkg.genre('Жанр')
        );
    DBMS_OUTPUT.put_line ('--------------------');

--выдача книги
    DELIVERY_EXEMPLAR_ID$ := book_pkg.get_book(
        id_client$ => 11,
        title$ => 'Название',
        issuer$ => 'Издательство'
    );
    DBMS_OUTPUT.put_line ('--------------------');

--возврат книги
    book_pkg.return_book(
        id_client$ => 11,
        title$ => 'Название',
        publisher$ => 'Издательство',
        rate_from_client$ => 5
    );
    DBMS_OUTPUT.put_line ('--------------------'); 

--получение отчета о выданных книгах за день
    report_pkg.took_books_a_day_json(
        p_day => TO_DATE('1/12/2022', 'dd/mm/yyyy')
        );
    DBMS_OUTPUT.put_line ('--------------------'); 

--получение отчета о возвращенных книгах за день
    report_pkg.return_books_a_day(
        p_day => TO_DATE('15/3/2022', 'dd/mm/yyyy')
    );
    DBMS_OUTPUT.put_line ('--------------------'); 

--получение отчета об инвентаризации
    report_pkg.inventory();
    DBMS_OUTPUT.put_line ('--------------------'); 

--получение истории одного экземпляра
    report_pkg.inventory_of_one(
        p_id_exemplar => 337
    );
    DBMS_OUTPUT.put_line ('--------------------'); 

END;

