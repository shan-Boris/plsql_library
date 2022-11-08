----------------------------------------
--            ���������
-- �������� ������ � ������������� - 12
-- �������� ������� - 194 (��������� ���������� ��� ���������� ��)
-- ��������� ����� � �� - 1236
-- ��������� ������� ���������, ��������� �������� - 1806
-- ��������� ������ ������-������� ���� - 2026
-- ������� ������� - 2976
--����� �������� �������� � ������� - 3253
-----------------------------------

-- �������� ������ � �������������
BEGIN

EXECUTE IMMEDIATE 'CREATE TABLE RATING (
        RATING NUMBER(3, 1) NOT NULL,
        STIMULATION VARCHAR2(100) DEFAULT NULL,
    CONSTRAINT RATING_PK PRIMARY KEY (RATING)
)'; -- �������� �����������/���������



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
)'; -- �������� ������ ��������(���, �������, ���������(���� �������� ����������), �������(0 - ������ ������))

EXECUTE IMMEDIATE 'CREATE INDEX CLIENT_FIO_ID_IDX ON CLIENT(LAST_NAME, FIRST_NAME, ID)';


EXECUTE IMMEDIATE 'CREATE TABLE CARD_CHANGE_TIME (
        ID INTEGER,
        CREATE_CARD DATE NOT NULL,
        CHANGE_CARD DATE,
        DELETE_CARD DATE,
    CONSTRAINT CARD_CHANGE_TIME_PK PRIMARY KEY (ID)
)'; -- �������� ����� ��������/���������/�������� ������������� ������

EXECUTE IMMEDIATE 'CREATE TABLE PUBLISHER (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        PUBLISHER VARCHAR2(100) NOT NULL,
    CONSTRAINT PUBLISHER_PK PRIMARY KEY (ID)
)'; -- �������� �������� ������������

EXECUTE IMMEDIATE 'CREATE TABLE BOOK_TYPE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        TYPE VARCHAR2(50) NOT NULL,
    CONSTRAINT BOOK_TYPE_PK PRIMARY KEY (ID)
)';-- �������� ��� ��������� ���������

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
)';-- �������� ������ �������� ����������

EXECUTE IMMEDIATE '
    CREATE SEQUENCE BOOK_ID_SEQ 
    INCREMENT BY 1 
    START WITH 1
    MAXVALUE 99999
    NOCACHE
    NOCYCLE'; -- ����������������� ��� ������� BOOK

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
)';-- �������� ���������� �������� ���������� � �� ���������������

EXECUTE IMMEDIATE 'CREATE TABLE LOG_READING_ROOM (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_CLIENT INTEGER,
        ARRIVE DATE NOT NULL,
        LEAVING DATE,
        ID_EXEMPLAR INTEGER,
    CONSTRAINT LOG_READING_ROOM_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_CLIENT_LOG_READING_ROOM FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT(ID),
    CONSTRAINT FK_ID_EXEMPLAR_LOG_READING_ROOM FOREIGN KEY (ID_EXEMPLAR) REFERENCES EXEMPLAR(ID)
)'; -- ������ ����������� ���������� ����

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
)'; -- ������ ������/������ ����������, ��� �������� �������� ����������� �������� ���������

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
)'; -- ������ ������/�������� ���������

EXECUTE IMMEDIATE 'CREATE TABLE TAG (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        TAG VARCHAR2(50) NOT NULL,
    CONSTRAINT TAG_PK PRIMARY KEY (ID)
)'; -- �������� ����


EXECUTE IMMEDIATE 'CREATE TABLE BOOK_HAVE_TAG (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_TAG INTEGER,
        ID_BOOK INTEGER,
    CONSTRAINT BOOK_HAVE_TAG_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_BOOK_HAVE_TAG FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID),
    CONSTRAINT FK_ID_TAG_BOOK_HAVE_TAG FOREIGN KEY (ID_TAG) REFERENCES TAG(ID)
)';-- ����� ����� - ���

EXECUTE IMMEDIATE 'CREATE TABLE AUTHOR (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        FIRST_NAME VARCHAR2(50) NOT NULL,
        LAST_NAME VARCHAR2(50) NOT NULL,
        FATHER_NAME VARCHAR2(50),
    CONSTRAINT AUTHOR_PK PRIMARY KEY (ID)
)'; -- �������� ������ �������

EXECUTE IMMEDIATE 'CREATE INDEX AUTHOR_FIO_ID_IDX ON AUTHOR(LAST_NAME, FIRST_NAME, ID)';


EXECUTE IMMEDIATE 'CREATE TABLE AUTHOR_WROTE_BOOK (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_AUTHOR INTEGER,
        ID_BOOK INTEGER,
    CONSTRAINT AUTHOR_WROTE_BOOK_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_AUTHOR_WROTE_BOOK FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID),
    CONSTRAINT FK_ID_AUTHOR_AUTHOR_WROTE_BOOK FOREIGN KEY (ID_AUTHOR) REFERENCES AUTHOR(ID)
)'; -- ����� ����� - �����

EXECUTE IMMEDIATE 'CREATE TABLE GENRE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        GENRE VARCHAR2(350) NOT NULL,
    CONSTRAINT GENRE_PK PRIMARY KEY (ID)
)'; -- �������� �����

EXECUTE IMMEDIATE 'CREATE TABLE BOOK_HAVE_GENRE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_GENRE INTEGER,
        ID_BOOK INTEGER,
    CONSTRAINT BOOK_HAVE_GENRE_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_BOOK_BOOK_HAVE_GENRE FOREIGN KEY (ID_BOOK) REFERENCES BOOK(ID),
    CONSTRAINT FK_ID_GENRE_BOOK_HAVE_GENRE FOREIGN KEY (ID_GENRE) REFERENCES GENRE(ID)
)'; -- ����� ����� - ����

EXECUTE IMMEDIATE 'CREATE TABLE PREFERENCE (
        ID INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
        ID_GENRE INTEGER,
        ID_CLIENT INTEGER,
    CONSTRAINT PREFERENCE_PK PRIMARY KEY (ID),
    CONSTRAINT FK_ID_CLIENT_PREFERENCE FOREIGN KEY (ID_CLIENT) REFERENCES CLIENT(ID),
    CONSTRAINT FK_ID_GENRE_PREFERENCE FOREIGN KEY (ID_GENRE) REFERENCES GENRE(ID)
)'; -- �������� ������� ����� ��������

END;
/


-- ����� ��� ������ � �������
CREATE OR REPLACE PACKAGE book_pkg
IS
    TYPE a_first_name IS VARRAY (100) OF VARCHAR2(100);
    TYPE a_last_name IS VARRAY (100) OF VARCHAR2(100);
    TYPE a_father_name IS VARRAY (100) OF VARCHAR2(100);
    TYPE tag IS VARRAY (100) OF VARCHAR2(100);
    TYPE genre IS VARRAY (100) OF VARCHAR2(100);

-- ���������� �����
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

-- �������� ���������� ������������ � ��
    FUNCTION publisher_is_new(
        publ          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- �������� ���������� ���� ��������� ��������� � ��
    FUNCTION book_type_is_new(
        book_type       IN BOOK_TYPE.TYPE%TYPE
    )
    RETURN NUMBER;

-- �������� ���������� ������ � ��
    FUNCTION author_is_new(
        firstname          IN VARCHAR2,
        lastname           IN VARCHAR2,
        fathername         IN VARCHAR2
    )
    RETURN NUMBER;

-- �������� ���������� ���� � ��
    FUNCTION tag_is_new(
        tag$          IN VARCHAR2
    )
    RETURN NUMBER;

-- �������� ���������� ����� � ��
    FUNCTION genre_is_new(
        genre$          IN VARCHAR2
    )
    RETURN NUMBER;

-- �������� �������� �� ����������� ��������� �����
    FUNCTION check_reader_for_book (
        client_id        IN  CLIENT.ID%TYPE,
        titleBook        IN  BOOK.TITLE%TYPE,
        issuere          IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- ����� ��������� ��������� ��� ������ �����
    FUNCTION get_free_exemplar (
        title        IN  BOOK.TITLE%TYPE,
        issuer       IN  PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- ������ ����� �������
    FUNCTION delivery_book (
        id_client          IN CLIENT.ID%TYPE,
        title              IN BOOK.TITLE%TYPE,
        issuer          IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER; 

-- ������ ����� ���� ������ ������ �������� �� ������������ �����
    FUNCTION get_book (
        id_client$          IN CLIENT.ID%TYPE,
        title$              IN BOOK.TITLE%TYPE,
        issuer$             IN PUBLISHER.PUBLISHER%TYPE
    )
    RETURN NUMBER;

-- ����� ���������, ������� ���� ������
    FUNCTION find_exemplar_of_client(
        title$                  IN BOOK.TITLE%TYPE, 
        publisher$              IN PUBLISHER.PUBLISHER%TYPE, 
        id_client$              IN CLIENT.ID%TYPE 
    )
    RETURN NUMBER;
-- ������� ����� � ����������
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

-- ��������� ������������ ���� ��� ��� � ���� ���
        IF publisher_is_new(issuer) = 1
            THEN 
                INSERT INTO PUBLISHER (
                    PUBLISHER
                ) VALUES (
                    issuer
                );
                COMMIT;
        END IF;

-- ��������� ��� ��������� ���� ��� ��� � ���� ���
        IF book_type_is_new(book_type) = 1
            THEN 
                INSERT INTO BOOK_TYPE (
                    TYPE
                ) VALUES (
                    book_type
                );
                COMMIT;
        END IF;

-- �������� id ��� �����
        bookid := BOOK_ID_SEQ.NEXTVAL;

-- ��������� �����
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
-- ��������� ������� � ���� ��� ��� � ���� �� ���������
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

            -- ��������� ����� ����� - �����
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

-- ��������� ���������� ���� �� ����� � ���������� � ������� � ������ ������ ����
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
            DBMS_OUTPUT.put_line (title || ' ��������� � ����������, ��������� �' || exemplar_id);

        END LOOP;

-- ��������� ���� � ���� ��� ��� � ���� �� ���������
        FOR I IN 1..tags.COUNT LOOP
            IF tag_is_new(tags(I)) = 1
                THEN
                    INSERT INTO TAG (
                        TAG
                    ) VALUES (
                        tags(I)
                    );  
            END IF;

-- ��������� ����� ��� - �����
            INSERT INTO BOOK_HAVE_TAG(
                ID_TAG,
                ID_BOOK
            ) VALUES (
                (SELECT ID FROM TAG WHERE TAG = tags(I)),
                bookid
            );
        END LOOP;

-- ��������� ����� � ���� ��� ��� � ���� �� ���������
        FOR I IN 1..genres.COUNT LOOP
            IF genre_is_new(genres(I)) = 1
                THEN
                    INSERT INTO GENRE (
                        GENRE       
                    ) VALUES (
                        genres(I)
                    );  
            END IF;

-- ��������� ����� ���� - �����
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
            DBMS_OUTPUT.put_line ('����� �� ��������� � ����������');
            DBMS_OUTPUT.put_line ('����������� �������� ������ �� �������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('����� �� ��������� � ����������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
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
    -- �������� ������������� ������� � ����
        SELECT 
            COUNT(ID)
        INTO count_client
        FROM CLIENT 
        WHERE ID = client_id;
        IF count_client = 0 THEN
            RAISE e_invalid_client;
        END IF;

    -- �������� ������������� �����
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

    -- ������ ������� ���� ����������� �� ������
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

    -- ������ ���� �� ��� ��� �����
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

    -- ������ ������� �������
        SELECT
            RATING
        INTO rating
        FROM CLIENT C
        WHERE C.ID = client_id;
        
    -- ������ ���������� ���� �����
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
                (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birthday)) --��������� ����������� ����������� �����
            THEN resulting := 1;
        END IF;

    -- ������� ���������� ������ ������ ����� �����
        IF resulting = 0
        THEN
            IF count_e_on_store <= 1
            THEN DBMS_OUTPUT.put_line ('��� ���������� ��� ������');
            END IF;
            IF already_took_book != 0
            THEN DBMS_OUTPUT.put_line ('��� ����� ����� ����');
            END IF;
            IF rating = 0
            THEN DBMS_OUTPUT.put_line ('������ � ������ ������');
            END IF;
            IF age_limit > 
                    (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM birthday))
            THEN DBMS_OUTPUT.put_line ('������ �� ����� �� ���� �����');
            END IF;
        END IF;

        RETURN resulting;
    EXCEPTION
        WHEN e_invalid_client THEN
            DBMS_OUTPUT.put_line ('������ ������� �� ����������');
            RETURN resulting;
        WHEN e_invalid_book THEN
            DBMS_OUTPUT.put_line ('����� ����� ��� � ����������');
            RETURN resulting;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
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

    --������� ��������� ����� ��� ������
    id_exemplar := get_free_exemplar(title => title, 
                                    issuer => issuer);

    -- ��������� ������ � ������ ������
        INSERT INTO LOG_DELIVERY_RETURN_BOOK (
            TAKE_BOOK,
            ID_CLIENT,
            ID_EXEMPLAR
        ) VALUES (
            TO_DATE(SYSDATE, 'dd/mm/yyyy'), 
            id_client,
            id_exemplar 
        );

    -- ������ �������������� �����
        UPDATE EXEMPLAR
            SET ON_STORE = 0,
                ON_HOME = 1
        WHERE ID = id_exemplar;

    COMMIT;
        DBMS_OUTPUT.put_line (title || ' ������, ��������� �' || id_exemplar);
        RETURN id_exemplar;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line ('��� ���������� ��� ������');
            ROLLBACK;
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
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
        ELSE DBMS_OUTPUT.put_line ('������ ������ �����');
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

    --������� ��������� ����� ������� ���� ������
        id_exemplar$ := find_exemplar_of_client(title$, publisher$, id_client$);

  
    -- ��������� ������ � ������ ������ � ��������
        UPDATE LOG_DELIVERY_RETURN_BOOK DRB
            SET RETURN_BOOK = TO_DATE(SYSDATE, 'dd/mm/yyyy'),
                RATING_BOOK = rate_from_client$
        WHERE ID_CLIENT = id_client$
                AND ID_EXEMPLAR = id_exemplar$;


    -- ������ �������������� �����
        UPDATE EXEMPLAR
            SET ON_STORE = 1,
                ON_HOME = 0
        WHERE ID = id_exemplar$;
        COMMIT;

        DBMS_OUTPUT.put_line (title$ || ' ����������, ��������� �' || id_exemplar$);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line ('����� ����� �� ����');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            ROLLBACK;
    END;

END;
/


-- ����� ��� ������ � ���������
CREATE OR REPLACE PACKAGE client_pkg
IS

--�������� ������������ � ������ ���. ������
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


    -- ��������� ������� ������ � ������� ������� ��������� ���������� � ������������
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
        DBMS_OUTPUT.put_line ('������ ������������ ����� �� ' || first_name || ' ' || last_name || ' ' || father_name);
        RETURN client_id;
    EXCEPTION
        WHEN PROGRAM_ERROR THEN
            DBMS_OUTPUT.put_line ('���������� ������ pl/sql');
            ROLLBACK;
            RETURN 0;
        WHEN OTHERS THEN
            IF SQLCODE = '-1400' THEN
                DBMS_OUTPUT.put_line ('���������� �� ��� ������ ��� �������� ������������');
            END IF; 
            DBMS_OUTPUT.put_line ('������������ ����� �� ������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
            ROLLBACK;
            RETURN 0;

    END;
END;
/


-- ����� ��� ��������� �������
CREATE OR REPLACE PACKAGE report_pkg
    IS
-- ��������� ������ � �������� ������ �� ���� � json �������
    PROCEDURE took_books_a_day_json (
        p_day                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    );

-- ��������� ������ � ����������� ������ �� ����
    PROCEDURE return_books_a_day (
        p_day                IN LOG_DELIVERY_RETURN_BOOK.TAKE_BOOK%TYPE
    );
    
-- ��������� ������� ������ �� �������������� � ������� ������ ����� (����� ��������� �� �����, ����� � ��� � ���� � ������, ����� ���� ��������).
    PROCEDURE inventory;

-- ����� �� �������������� �����(����� ��������� �� �����, ����� � ��� � ���� � ������, ����� ���� ��������).
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
        p_counter := 1; --�������������� ������� ���-�� �������� ����

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
                {"' || p_counter || '":{"��������":"' || I.TITLE || '",
                                            "������":"' || I.AUTHOR || '",
                                            "������������":"' || I.PUBLISHER || '",
                                            "� ����������":' || I.EXEMPL || '}}'));
            p_counter := p_counter + 1;   
        END LOOP;

        p_obj.PUT('�������� ����� �� ' || p_day, p_arr);
        DBMS_OUTPUT.PUT_LINE(p_obj.STRINGIFY);

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = '-1861' THEN
                DBMS_OUTPUT.put_line ('�������� ����');
            ELSE
                DBMS_OUTPUT.put_line ('������');
                DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
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

        DBMS_OUTPUT.put_line ('����������� ����� �� ' || p_day);
        DBMS_OUTPUT.put_line (' ');
        DBMS_OUTPUT.put_line ('��������' || '     ' || '������' || '     ' || '������������');
        LOOP
            FETCH p_rc INTO p_title, p_author, p_publ;
            EXIT WHEN p_rc%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(p_title || '     ' || p_author || '     ' || p_publ);
            DBMS_OUTPUT.PUT_LINE('-----    -------');
        END LOOP;

    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = '-1861' THEN
            DBMS_OUTPUT.put_line ('�������� ����');
        ELSE
            DBMS_OUTPUT.put_line ('������');
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
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
    -- �������� ������������� ���������� � ����
        SELECT 
            COUNT(ID)
        INTO p_count_exemplar
        FROM EXEMPLAR 
        WHERE ID = p_id_exemplar;
        IF p_count_exemplar = 0 THEN
            RAISE e_invalid_exemplar;
        END IF;

    -- �������� ������������� ���������� � ������� ������� ������
        SELECT 
            COUNT(ID)
        INTO p_count_exemplar
        FROM LOG_ADD_DELETE_BOOK ADB
        WHERE ADB.ID_EXEMPLAR = p_id_exemplar;
        IF p_count_exemplar != 0 THEN
        -- �������� ������ � ����������� � ���������� � �� ������
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
-- �������� ������ � �����
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

        DBMS_OUTPUT.put_line ('������ � ����������� � ���������� � �� ������ ���������� ' || p_id_exemplar);
        DBMS_OUTPUT.put_line (' ');
        DBMS_OUTPUT.put_line ('��������: ' || p_title);
        DBMS_OUTPUT.put_line ('������: ' || p_author);
        DBMS_OUTPUT.put_line ('������������: ' || p_publ);
        DBMS_OUTPUT.put_line ('���������: ' || p_date_ar);
        DBMS_OUTPUT.put_line ('�����: ' || p_date_leav);
        DBMS_OUTPUT.PUT_LINE(' ');

        OPEN p_take_return_exemplar FOR
    -- �������� ������ � ��� ����� � ��� � ���� � ������
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

        DBMS_OUTPUT.put_line ('������ � ��� ����� � ��� � ���� � ������');
        DBMS_OUTPUT.put_line (' ');
        LOOP
            FETCH p_take_return_exemplar INTO p_client, p_take, p_return_b;
            EXIT WHEN p_take_return_exemplar%NOTFOUND;
            DBMS_OUTPUT.put_line ('������ - ' || p_client);
            DBMS_OUTPUT.put_line ('���� - ' || p_take);
            DBMS_OUTPUT.put_line ('������ - ' || p_return_b);
            DBMS_OUTPUT.PUT_LINE('-----    -------');
        END LOOP;

    EXCEPTION
        WHEN e_invalid_exemplar THEN
            DBMS_OUTPUT.put_line ('������ ���������� �� ����������');
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('��� ������ - ' || SQLCODE);
            DBMS_OUTPUT.put_line (SQLERRM);
    END;

    PROCEDURE inventory
    IS
        p_test_take_return_exemplar    SYS_REFCURSOR;
        p_test_exmp                  NUMBER;
    BEGIN
    
        OPEN p_test_take_return_exemplar FOR
            SELECT ID FROM EXEMPLAR ORDER BY ID;
-- �������� ����� ��� ������� ���������� � ����������
        LOOP
            FETCH p_test_take_return_exemplar INTO p_test_exmp;
            EXIT WHEN p_test_take_return_exemplar%NOTFOUND;
            inventory_of_one(p_test_exmp);
            DBMS_OUTPUT.put_line ('++++++++++++++++++');
        END LOOP;

    END;

END;
/


-- ��������� �����
DECLARE
    BOOK_ID$                NUMBER;
BEGIN

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '����',
        title => '����� �������. ��� ���� ���������� � ���������� ����',
        summary => '��� ������� �������� ������. ���� ����. ���� ������ ������.� ������ 2015 ���� ��� ����� ��������� �������� �� ����� - �������� ����������� ������ �����-���� � ����������� ���� - ����������� � ����������, ����� �������� ������������� ���� �������� ��� ������������, ���������� �� �������� ����, ������ ��������� ���������, � ����� ����� �� ������ ������: ��� ����� ������� � �����, ����� ��� ��������� ������������ �������� - �� ������������ ��������� �������� �� ������, ��� �� �� ������ ���������� �����, �� ������ �� ���, ��� ������������� � ���� ��������, �� ���� ������ �������� ��������, �� ��������������, ������� �������� ������� �������, �� ������ ��������, ���������� �� �������?������� ������ � ������� ������. �������� ������� ��������� �����������, ������� ������ ��� ���������� �����, �������� ������������� ���������� ������, �� ����������� �� �������� �...',
        year_of_publication => 2002,
        age_limit => 13,
        price => 1638,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('��������', '���', '�����', '������'),
        genres => book_pkg.genre('������� ����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 44,
        issuer => '����',
        title => '���� ������� �� ���������',
        summary => '� ������������ ����������� ������...������ ��������� ���� ��� �������-������������...�������� ��������...����� ���������� � ���� "�������� �� ���������"!� ���� �����������, ������������� ����� ������ �������� ��������, ������� ������ ����������� ����������� � ������� ��� ������, ����� �������� ����������� ������������. ��� �������� ���� "���� ������� �� ���������". ��������, �����, ������� � ��� ��� ��������� ������� �������, �� � ��� ��� ��� ���� ���-����� ����� � ������. ����� �������� ��������� ������� �������, � ����� � ����� �������������� ������������ ����������, "���� ������� �� ���������" �������� �������� ������ ��������� ����. ������ ���������� ������ �������� �����. ������ �� ���� ��������� ������� ������� ������, ���� �� ����� ������� ������?�� ������������ ����� ����� (������� 28 ������ 1970 ����) - ���������� �����������, ��������, ����� � ��������, �������� ��...',
        year_of_publication => 2021,
        age_limit => 18,
        price => 798,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('�����'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('����', '���������', '������', '�������'),
        genres => book_pkg.genre('���������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 4,
        issuer => '��������',
        title => '����������� ���� ������',
        summary => '"����������� ���� ������", ���� �� ����� ���������� ������������ ����������� ������������� �������� ����� �����, ������������ � ����� � ��������� ������� �� ��������� � 30-40-� ������1� ����. ��� ����������� ��� �����, ����������� �����������, ��������� � ���� �����, ����������� �� ����� ���� - � ��� ����� ��� ��� ��������� ����������. � ���� � ��� ��� ������ ��� ����� ��� ��������, �������� ���� ��-�������� �������� ������ � ����������, ������ �� ������ � ���� ���������. ������� ���� ���� �������, ��� ����� ������ �� ����� �� ��������� ��������, ������ ��� ���� �����-��, ��� ������ � ����������� � ����� ������������ ������� � ���� ���������.����� � ������������� ������������� �������� ������.��� ����� 8-12 ���.',
        year_of_publication => 2020,
        age_limit => 3,
        price => 1162,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����'),
        a_last_names => book_pkg.a_last_name('����'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('����', '�����������', '�����', '������'),
        genres => book_pkg.genre('�����������', '���������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 6,
        issuer => '������',
        title => '���� ����� � ���������� �����. ������� ����� ������������',
        summary => '�� ����������� ���� ��������, ����� ��������� ��������. ���� ����� - �������-������������ - ����� ��� ��������� �����. ������ ����� �� ����� ���� ������� ��������� ���������� ����������� �������, ����� ���� �� ���� � ������� ������� �� ������ ����. � �� ���� ��� ����� ������� ����������. ���� ��� ��� ��� ����.������ �� ���� ��������� ���� �����? ��� ���������, � �������� �� ���������, �������� ��� ���������? ������ - ������. � ���� ��� ��������� ������ ������������ ����� ����� ���������� �����. ��� ���� ���� ���� ������ ������� �� ����������� �����, ��������� ��� ������������� � ������������ "�����", ������� ������� �������� �������. ������ ���� ������� ������, ��� � ������ ������� ��� ����� ������ ��������. ������ ����� ������ �����, �������� ����� �� ������������ � �����������, � ���������� �������� � ��������. ��� ������ ����� � ����� �������� ����, � ��...',
        year_of_publication => 2021,
        age_limit => 5,
        price => 633,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�������'),
        a_last_names => book_pkg.a_last_name('����������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('����', '������', '����', '��������'),
        genres => book_pkg.genre('�����������', '���������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 24,
        issuer => '�����',
        title => '1984',
        summary => '������ ����� ��� ���� ����� ��������� ������ ������� �����, ����� ������ ������ (1903-1950) ������� ����� ���������� ���� ������������ - �����-���������� "1984". ������ �� ����, � ��� ����� ������ ������, ��������� ��� �� ������� ��������. ��������� ������������� �������, ��� �� ���� �������� �������� �� ��������� ���� "1984" ��� �������, ��� ������� ����� �� ���������� �����.����� - ��� ���������� - ��� ��������������� - ������� ��������� �������, ��� ��������� �������; ��� ��������� ���������, ��� ��������� �������. ���������������� �� ���� ����� �������. ���������������� ���������� � ������������ �������� � ������ �����.����� ������ ����-��, �� ��� ������, �, ���� ������ ������ �� ������ ��� ����, �� ���-���� ����� ��� ������������� ������',
        year_of_publication => 2020,
        age_limit => 14,
        price => 344,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('���������', '������', '�������', '����������������'),
        genres => book_pkg.genre('���������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 66,
        issuer => '�����',
        title => '1984',
        summary => '������ ������ � ���� �� ����� �������� � ���� ������� � ����� �������������� ������� ������ �������. ������� � ��������, ������ � �����, ������� � �������, �� ����� � � ��������������� ��������, ������ � ������� � ����� �����. ���� ��������� ���������� � �������� ���������������� ����������, ������ ������� ���� ������ ��������, � �������� ��� ���������, �� � ������� ���������� ���� ��������� �����.  � ����� ������������ ������ ������ ������������ �������: ������ ������ ���� � ����� � ����� ����������, � ����� ��������� ������� ����������� ������������ �������-������ �������� ���� � ���������� �1984�.  ������ ����� ������� ���� � ����� ������� �� ��� ����� ������ � ������������ ������� ����� � 1920-� ���� � ������ ������� ����� ��-�� ������� ����������� ������������� ��������. ����� ���������� �������� � ���������� ���� �������� � �������� ���������������� ��...',
        year_of_publication => 2012,
        age_limit => 14,
        price => 844,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('��������', '�������', '������', '������'),
        genres => book_pkg.genre('���������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 33,
        issuer => '���������',
        title => '1984',
        summary => '������ ������ (1903-1950) ���� ����� ����������� ����������� ������ ������������� ������������� ����������. ��� ���� � ���� ������������ ������ ���� ��������� � ���������� ������ �������� XX ����, �� �� �������� ����� �������������� � � ���� ���. �����-���������� "1984" (1949) ������ ������������ ������ �������� - ������� ����� �������, ������� ��������� � ������������ ��������� ����� � ����� ������� �������� ��������������. � �������� ������� ������� ���������� ��������, ����������� ������� ����� � ������ � ��� ���������������� ��������� ������� ������. ������� ����� ������� ���� ������ ���� ������ ���� �� ���������������� ���������, ������������ ������������ ������������ ������. �� �������� ����������� ������� � ������� ������ �������������� ��� �����: �������� �������� �������, �� � ������ ��� ����� ������.',
        year_of_publication => 2021,
        age_limit => 14,
        price => 391,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('������', '������', '�����������', '�����������'),
        genres => book_pkg.genre('���������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 17,
        issuer => '����',
        title => '1984',
        summary => '����� "1984" - ������� ���������� ������� �������. � ��� �������� ��������, � ������� ���� ����� ��������� �� ������: �������, �����������������, ��������� ��������; �������, �� ������� ����� �� �� ���, ����������� ��� ���������� �������� ��������� � �������������� ���������, �������� ������� � ������, �������� ������������ ������ �� ����������� ������������� �������, ���������� �� ����; ������ - ��� �� �����������. � ���� �������� ������������ ����� �����; ������� ����� � ������ ���������, ������� ��������� ��������� �� ����� �����������. ����� �������� ���������� � �������� ��� ������������. ����� ������� ������ �����, ����������������� ����, �������������� ����� � ������, ���������� ��������������, ������������� - ���� ����� �������. �� �������� ������ ������� �, ��������������, ������, ��� ���� �������� �� ����. ���� ����� - �������������, �� �������� �������...',
        year_of_publication => 2016,
        age_limit => 14,
        price => 281,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�������', '��������', '�����', '������'),
        genres => book_pkg.genre('���������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '���',
        title => '1984',
        summary => '������������ ������� ������ ������� ���������� XX ���� - "� ������ ����� ���" ������ ������. ���, � ��������, ��������: ���������� �� ������� "�������� �����������" - ��� ���������� �� �������� "�������� ����"? �� �������, ��� � �� ����� ���� ������ ������� ��������� ���������...������ ���� ������� ���� ������������ ������� � ������������ � ����� ������ ������������ ������. � ������ �����, ������� �� ��������� �� ������, ������� �� ������ ��������� ������, ������� �� ������������ ����� ����� ������, � ������� �� ������ �����������. �� ��� ������ ������� ��������� ������ �����, ��� ������� ��� ���������� �������� ������, ���� ������� ���� ������ ������ �� �����
    ',
        year_of_publication => 2008,
        age_limit => 16,
        price => 269,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�������', '��������', '������', '�������'),
        genres => book_pkg.genre('����������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '�����',
        title => '������ �����-2. ���� ����. ��� 1',
        summary => '������������� ������. ���� ��� ��� �� �����, ������� �������� ���� � ������ ���������. ������ ���������� �� ����, �������, ��� ��� ��������� ������ ���� � ������� ������� ������� ������ ����. ������ ����� � ���������, � �������, ��������, ������������ � �����. �� ������� ���������� ���� ����������� ������ - ��� ���������� �����, ���������, ����������� � ���� �����. ������ ���� ��� ������������ � ��� �������� ��������? ��� � ����� ������ � ������ ������������� �������� ������? ���� ���� ������� ���, ����, ������ �� �������� ������ ���� ����? � ����� ������� �������� ������ ��� ���� ��� � ���������� ����� - ���� � �������� ������ ��������!��� ��-���� �����?..',
        year_of_publication => 2020,
        age_limit => 15,
        price => 1450,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('���'),
        a_last_names => book_pkg.a_last_name('�������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�����', '�������������', '����', '������'),
        genres => book_pkg.genre('����������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 10,
        issuer => '������',
        title => '������ �����-2. ���� ����. ��� 2',
        summary => '����� ���������� ��������� ������� � ������������� ����������. ����, ������� ��������� �������� �������. ���� �� ����� ������� ������������ ������������� ��������. �� ��� - "������ �����" ���� ��������! �������, ������� ������ �������� ��� �����, ������� � ������ ����������. �� ������, ��� ��������� �� ����� ������� ����, ��������� � ������������, ������� �� ��������� �������������� � ����� �� ���-������ ����������� � ������� ���������� ���.� ����, ����� ������������� ��� ����, ����������� ��� ����� � ��������� ������ �� ��� �������. � ���� ��������, �������� ������ �����.',
        year_of_publication => 2023,
        age_limit => 14,
        price => 1431,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('���'),
        a_last_names => book_pkg.a_last_name('�������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�����', '����', '����������', '�����'),
        genres => book_pkg.genre('����������� ������������� �������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 34,
        issuer => '������',
        title => '���������� ���� �� �����',
        summary => '������� ����� ������: ����� ���������� �������, � ���� ������ �� �������, ����� ������� ���� ���� � ������ �������, ���� ���� ����� ���������� ����� ���������� �����. ���������� � ��� ������ �������� � �������� �� ��������. �� ��� ������ �� ��� ����� ����� ����. ����� ����� ����, ���� �� ������������ �� ����� ��������! ��������, ������� ����. � ������� ����, �������, ����� - ������, ������, ��������� ���������! � ���� - ��������� � ��������.�� ���� ���������� ���������, ����� � ����� �� ������� ��������� ����� � ������� �������� �� �� ������. ������ ������� ������ �� �������. ��������� ������� �� �������!���� ��������� - ����� ������� ����, ������� ������ ������� � �������� ������ ���������. � ������������ "������" �������� � ����� "����" � "�������� ������".��� ����� �������� ��������� ��������.',
        year_of_publication => 2007,
        age_limit => 3,
        price => 308,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����', '���'),
        a_last_names => book_pkg.a_last_name('���������', '�������'),
        a_father_names => book_pkg.a_father_name('����������', ' '),
        tags => book_pkg.tag('�����', '����', '����', '������'),
        genres => book_pkg.genre('������� � �������� � �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '���� ���������',
        title => '��������� �. ������� �����',
        summary => '������������ �������� ������� ���������, � ��������� �������� ������ ���� ��������� ������� ���� � ������ ������. ����� ����������: ���� ������� ��� ���� �� ����� ��������� - ��� ����� ������ ������� ������� ������� �����. ��� �������� �� ������, ���������, ��� ��� �������� ���� ������! ������ ��� ������ ����������� ���� ��������!.. �������, �������� ��������� ���������. ��� ��-���� ���?..�������� �������� ����� ������� ��������� ��� ������� ����������� ������� ���������� � ������� ��������� ������, ����� ������� - "�������", ���������������, ������������, "�����", ����������� ������ ���� ��������. ����� ���� �������� �������� - ��������� � ��������, ������� �������� � ����� ����������� ��������������, ����������� �� �� ������ ��������� ���� ������ �� ���������, �� � ����� ������ ����.��� �������� � �������� ��������� ��������.',
        year_of_publication => 2020,
        age_limit => 3,
        price => 720,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('��������', '����'),
        a_last_names => book_pkg.a_last_name('��������', '���������'),
        a_father_names => book_pkg.a_father_name(' ', '����������'),
        tags => book_pkg.tag('��������', '��������', '�������', '������������'),
        genres => book_pkg.genre('������� � �������� � �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 55,
        issuer => 'XL Media',
        title => '����� �������� ����. ��� 1',
        summary => '�������� �� ����� ����� ��������� �������� �� ���������� ������, � ��� �� ����������� � �������� ��� ����� � ����� ��� �������. ����� � ����� ��������, ��� �������� �������� ������� ����������. ������ ������ � ���� ������, � ������ ���������� �� ������� ����� �������� ��������, �������� ����� � ����. ���� ��������� ����������� ����� ����� ������ � ������������� ��������� ��� ����������� ������������ ������������ ���������. � ������ ������ �� � ��� �������� ���� ����������� �����-�������, ���������� ����� �� ������� ������. ����� � ��� ���������� �� ����� �����, ������� ����������� ������ ������ � �������. ������ �� ���������� � ������� ������������ ���������, ��� ������ ������� ������.',
        year_of_publication => 2021,
        age_limit => 5,
        price => 628,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�����', '����'),
        a_last_names => book_pkg.a_last_name('�������', '���������'),
        a_father_names => book_pkg.a_father_name(' ', '����������'),
        tags => book_pkg.tag('�����', '�����������', '���������', '�����'),
        genres => book_pkg.genre('�����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 5,
        issuer => 'XL Media',
        title => '����� �������� ����. ��� 2',
        summary => 'ʸ�� ������ �������������� ������� ����� � ���� �� ������� �� ����������� ����. ����� ��������� ���� �� �� ��� ���� �������� - ��� ���� ����, ����� �������� ������ ��������� ������ ��� � ����� ���������� �������: ��������� ���������� �������� ���� ��������� �����. ��� �������� ����� ���������� � ���� ������� �������� ������ �������-�������, � ������ ��� ������ - ��� ��������. ������ ����� ������ ��� ��������, ������� ��������� ������ ����� ���������� � ���� �������� ������� �������� ����� ������������ ����������� � ������?',
        year_of_publication => 2021,
        age_limit => 5,
        price => 628,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�����'),
        a_last_names => book_pkg.a_last_name('�������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�����', '���������', '������', '������'),
        genres => book_pkg.genre('�����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 5,
        issuer => '�����-������',
        title => '���, �������, � ������ ������. ��� ���������� ���������� � ����������',
        summary => '����� ������� - ������ ��������� �������� � �������� � ���� �������. ����� "���, �������, � ������ ������" � ��������� ��������. ������������ �. �������� � ��� ����� ����������� ������ � ��������������� ����������� ���������� ������������� ����������� � ���, ��� ������������� ��������, � ����� ����� ����� ������. ��������� ����, �������������� � ���� �������� ����, �� ������������ � ���, ��� ������� ������ ���������� � ������������ ����������� � ����� ����� �������� ���������. �� �������, ��� ���������� ������������� ����������, ��� ��������, ��� �� �����, ��� ��������� ��� ������� �� ������ ��������, �� � �������������� �������. ������, ��������� � ���� �����, �������� ��� ����������� �������� ����������� �� ��������� ��������.',
        year_of_publication => 2021,
        age_limit => 3,
        price => 767,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�����', '�����'),
        a_last_names => book_pkg.a_last_name('�������', '�������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('���������', '�����������', '�������', '�����'),
        genres => book_pkg.genre('������� ������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 124,
        issuer => '����',
        title => '45 ���������� ���������. ������� ��� ���, ��� ������ � ��������� ���������',
        summary => '� ���������� 45 ���������� �� ������������ �������� ������� �������� - ��� � ���� �������� ��������� �� ��������, ��� � � ���� ������������: ������, �������, ������ �� ���.���� �� ����� ��������� � � �� �� ����� ���������� ��������� - ��� ��������� ��������, ������� ���������, �������� � ���������� �������� �������� �����������, ������� ������������ ���������� � � �������������� ����������� � �������� ����������.������ ������� ������: ���, ���� �� ������ � ����� ���������������� ������������, �� ������ ��������� ������ � ��������. ������� ���� �������� ���� ��������, ��������� ��������, ����� ���������� � ���������, ������ ������ ������ �����������, ������ ������������� ���� ����� � ������� �������.������� ������ ����� ��������.���� �� ��������� ��������� ������ � �� ����� ��������� ������� �� ����� �� ����� ������������������ ������, �� ��� �� ����� ����� �����...',
        year_of_publication => 2021,
        age_limit => 3,
        price => 1461,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������', '�����'),
        a_last_names => book_pkg.a_last_name('�������', '�������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('��������', '�����', '����', '����������'),
        genres => book_pkg.genre('������� ������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 44,
        issuer => '�������',
        title => '11 ������������ � ����� �� �����. �������������� ������ ������������ ��������� ��������������',
        summary => '���� ������� ������ ������������ ��������� �������� ������������� ������������� ����������, ������� ����� ���������� ����� ������������� ����� �� �����. ��� ����� ��� ����� ������ � ������� �������� �������� ����������, ��� ��������� ���������, � ������� ������������� � �������� ��������� ����������� ����������. ��� � ������ �������� ���� ������������� ������������� �� ������ ���������� ��������� ��������� �����. ����� �� ���� �������� ���� ���������, � ������� ��������� ��������������� ��������� ��������� ����� �������: ��������, ����, ��������, ���������. ��� �������� ���� � ������ � ��������� ������, �������� ������� �� ��������� � ����� ����������, � ��������� �������� ����� ������, ���, ��������, �������� ����. � XXI ���� ����� ������������: �� ������� � ������� ������������ ����� ��������� � ���������� �� ������ ������� � ����.',
        year_of_publication => 2008,
        age_limit => 0,
        price => 376,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�����'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�������', '������', '������������', '���������'),
        genres => book_pkg.genre('��������� ������������ ��������������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 11,
        issuer => '������',
        title => '�� ������������ � �����. ������������ �������� ������ ������������ ����',
        summary => '���� �������� ������������ ������� � �������� ���������. ��� �������� ������������� ��� ����� �������� ������ �� ����������. �� ������ �� ��� ����������? ��������� �������� ���� ���� - ������, ��������� ������������ �����������, ������������� �����, ������� ������-���������� ������� BBC. �� �� ������������ � ����������� ����� �� ������ ��������. ��������� ���� ����� �� �� ������ ������� ������ ��, ����� ������ �� ������� ������������, ��������, ������������, ��������, ������� ������, ����������, ����������, �� � ������� ������ �� �������: - �������� �� ��������, �� �������� �������� �������� �����, ����������� �������� ��� ���� � �������������� ����? - ������ � �������������������, ���������� � ����� ������� ����������� ���� �� ���������� ������ �������, ��� ���� ����������� ������? - ��� �������� �� ������������ ����� ����������? - � ������, ������ � �����������...',
        year_of_publication => 2021,
        age_limit => 0,
        price => 616,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����', '�����'),
        a_last_names => book_pkg.a_last_name('����', '������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('������', '������', '��������', '����'),
        genres => book_pkg.genre('������ ������������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 16,
        issuer => '�������',
        title => '��������� ����',
        summary => '������� ��������� ����, � ��������� ��� ��������� ��� �������, ��� ����� ��� � ����� ������ �������: ��� ���� ��������� � ��������� �����.�������� � �� �� ����� �� ����� ������� � ������������ ����������, ����������� � ������� ����� ����������, �������� ��������� ����� ����� ������������ �������� ����: ���� "�������� ������" - ���������� ������������ ����� ���.������ ����� ����� �����������, ��� �������� ������� ����� �����, � ����������� �� ��������������� ���: �������� �� ������������ �����������, ���������� ������ �� ������������� ������������. ������ ������ ������ ��������� �������� ������ � �� ������ - ��������� ������� ����������, ����������� ������������ ������������ ������������.',
        year_of_publication => 2020,
        age_limit => 18,
        price => 370,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����', '�����'),
        a_last_names => book_pkg.a_last_name('��', '������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('���������', '�������', '���������', '����'),
        genres => book_pkg.genre('���������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '������ �����',
        title => '������ ��������',
        summary => '�������, ������� ��������, ���������� �������� �������� ����������� � �������, ������� ����� ���... � ��������� ������� � ���� ������� ���� �������. ������ ������� �� ��� ����� ���������� �� ����������� �����, � ��� ��� ������ �������������. ������������� � ���� ���� ��������. �� ������� - ������������ ����� ������ �� ������, ����������� � 1937 ����. �����, ��� ���-�� �������? ������ ������� � ������� �������� ����� ���. ������ ������� �����, ��� ������� ����� ����������� � �������, ��� ����� ��������, � ���������-����������� � �������� ���������..."������ ��������" - ���� �� ������ ������� ������ �����.',
        year_of_publication => 2021,
        age_limit => 18,
        price => 728,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������', '�����'),
        a_last_names => book_pkg.a_last_name('�����', '������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('�������', '�������', '�����', '�������'),
        genres => book_pkg.genre('���������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 19,
        issuer => '�����',
        title => '������� ������',
        summary => '�� ��� ������� ���, ����� ����, ��� ��� ������ ��� ����� � ���? ������ �������� ������, ����������� ������-��������, ����� �� �������, ���������� ������������� � ��������� ���. ����������, �������� ������ - ������, �� �� � �������, � ��������� ��������. ��� ������ ����� � ���������� "����������" ���� � �������� ����������. ����� � ����� � ������������� ���� ��������� ������, ����������� ������� ��������, ��� ���������� � ������� �������. ���� ������ ������ ����� ������ �������. � �������� ������ ��������� �����������. ��� ���� ����� ��������, ��� �� ����� �����������, �������� ���� ���.',
        year_of_publication => 2019,
        age_limit => 14,
        price => 650,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�����'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('���', '������', '��������', '������'),
        genres => book_pkg.genre('���������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '�������',
        title => '��������. ����������� �������� ����-���',
        summary => '������ �������, ���������� ������������ ������� � ������� ��������� ���������� ������, ������� ������ �������� ��������� � ����������. ��� ����� "��������" - ��������� ��������� ����� �����: ������������� "������ �������", � ������� ���������, ������ � ���������� ������������� ����� ����������� � ���������� ������� �����, ��������� �������� ������� � �������������� ������������� � ���� ���� ����� � �������� ������. "��������" - ������ �� ����� ������������, ������������ �� ������������ ����������� ���������� �������� ����-���, �������-������������, �������� �������� �� ��������� ������� � ����������� �� ����� ������. ����� �������� �������� ������ ��. ������ �. ����. ������� �� ������� �����.',
        year_of_publication => 2022,
        age_limit => 10,
        price => 827,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������', '�����'),
        a_last_names => book_pkg.a_last_name('�������', '������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('�����', '��������', '�������', '������'),
        genres => book_pkg.genre('�������������� ���������� ������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 22,
        issuer => 'fanzon',
        title => '����',
        summary => '����� ������ �������� MATERIA PRIMA. ��� ���������� ��������� ������� � ���������� �����������?���� ������� �������� ����� ���������� �����������, ���������� � ���������� ��������� �������� � �����. ����� ����������� �� ������� ���������. ����� ������������ ���������� �����, � ��������� ������ ���������.���� ������� ������� ������� �������, �� ������ �������� � ���������� �������. ������� ��������� ������� ������������ ���������� �������� �, ��� ������, ����������� ������, ������� � ���������.���������� ������� � ��������� ��������������, �� ��������� � ������������ �� ���, ��� ��� �������� � ��� �����."Materia Prima ��-�������� ���� �� ����� ������ �������� � �������� ������� �� ��������� ����, ������� �� ����� �������� �� ����". - taniaksiazka.pl"�������� �������������, ������� ����������". - Empic.pl"��� �������� �����, ���������� � ���� �������, ������������ ...',
        year_of_publication => 2021,
        age_limit => 13,
        price => 586,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����', '�����'),
        a_last_names => book_pkg.a_last_name('�������', '������'),
        a_father_names => book_pkg.a_father_name(' ', ' '),
        tags => book_pkg.tag('���������', '�������'),
        genres => book_pkg.genre('����������� ���������� �������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '�����',
        title => '��� ����',
        summary => '"� "���� ����" � ���������� �������, �� ������� ������������ ������ ������, ��� ��������� ���������� ���������� ������ �������, �� �� ������� ����� ������� ����������� ������. ���������� ���������� ���� ��������� � ����������������� �������������� ������� � ��������� ������� � �������� ���������� �� ������ � ��������. ��������������� ����� �� ����������� �������, �����������, ������ ���� ��������������. ����� ��������� ������ ��������� �����������, � ��������� � ������� �� ��������� ������������� ������������� �����������, ����� ����������� ������ � ������� � ��������� ������ �������, ���������� ��������� "�������" �������� ������������������� �� ������ ������������������ ������.  �������, ��� �� ����� � ������� ����������� �������� ��� �������� ����������� �������� ������� ����� ��������� ����� ����� ������. ���� ������� �����, ���������� ������������ ����������...',
        year_of_publication => 2022,
        age_limit => 3,
        price => 295,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����'),
        a_last_names => book_pkg.a_last_name('�������'),
        a_father_names => book_pkg.a_father_name('�����������'),
        tags => book_pkg.tag('������', '����', '����������', '����'),
        genres => book_pkg.genre('����������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 74,
        issuer => '���',
        title => '����������� ���������� � �������',
        summary => '� ���� ��� ����� ���������� ����� ������� ����������  ������������ ���������� � ������� � ��������� ������������ �� ������ ������� �������, ���������� ����������� ������������� ��������� �������, ��� ������ ������� ���������� ������������� ����� � ����������.',
        year_of_publication => 2019,
        age_limit => 10,
        price => 467,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�������'),
        a_last_names => book_pkg.a_last_name('����������'),
        a_father_names => book_pkg.a_father_name('����������'),
        tags => book_pkg.tag('�����', '����������', '�����', '�������'),
        genres => book_pkg.genre('����������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => '������',
        title => '����� - ������ �������� ����!',
        summary => '����� ����� ������ ������������ The New York Times ���� �������� "����� - ������ �������� ����!" ������ ������ ������ ���� 2020 �� ������ Popsugar.������� ������� �����, �����, ��������, ��� ��������� ��� ���� ���������, �������� � ������������ ������, ����� ���� ��� �� ��������. ������������� ������� � ���������� ��������������, ����� ����������� ������ � ��������, ���-����� �� ������� � ���������� � ������ � �������, ��� ���� �� ���� ���� ������, ���������� �� ������ ����� ��� �����, �� ����� ���� � ��� ������� ���� �� �����. � ������� ���� � ������� ���� ����� ����� ����������� ����� � ���� �� ������ ��������, ��������� � ��������� � ������� ������� ���� ������ ���, ��� ������� �� �� �������� �� ������.',
        year_of_publication => 2005,
        age_limit => 8,
        price => 845,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('����'),
        a_last_names => book_pkg.a_last_name('��������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�����', '�����', '������', '�����'),
        genres => book_pkg.genre('����������� ��������������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 64,
        issuer => '�����',
        title => '��� ���� ������������',
        summary => '������� ����� ������������� TikTok, ����� 610 ��������� ����������. "������ ��������, ��� ����� ������ �����, ����� ������ ��� �� ����. ���� �������� �������, ��� ���� ������������� ������ � ������� �����. ����� �� ����� ������� �������� ������.  �� �� � ������ �� ������ ���� �� �����. �� ������ ����� �������.  �� � ������ ��� ����� ������� � ��������������� �������, ��� � ���� �� ���� ���������, ����� � ���� �����, ����� �� ������ ����.  ���� �������, ��� �� ������, ��� �������� ������ ������� �� ���� �������, ����� � ������������� �� ���� �� �����".  ����������� ����� ����� � ������ �������� �� ������������� ����.  ��� ������������� ��� ������� ���������������. �����������, �� �������� ������. ������ �� �������� �����. ��� ����� ������ �� ���������?  ����� �������, ��� ������ ������������. �� �� ����������� ���������� � ���, ��� ����� �� ���� � �����.  ������� ...',
        year_of_publication => 2015,
        age_limit => 13,
        price => 600,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('�����'),
        a_last_names => book_pkg.a_last_name('�����'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('����', '�����', '�������', '������'),
        genres => book_pkg.genre('����������� ��������������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Inspiria',
        title => '����� �� ����',
        summary => '��������� ������ - ���� �� ������� ������� ������������ "�������������� ������".  �� ������� �� ����� ��������� ����� ������� ����� 8 ��� �����������.  "Le Figaro" ���������������� ��������� ������ ��� ������ �� ����� ������������� ������� ������.  � ���� ������ ��������� ������������ �� 15 ����������� ������.     "������������ �����, ������ �������������� �� ������� ������� ���������". - France Info  "��������� ������ ������������ ����� ������������ ��������". - L Obs  "����������� ���������� ��������� ������ ������ �������� ��� ������ � ��������". - Le Parisien   ������ ����� �� ����� ����� ����� ���� �������� ������� �������, ��� �������� ���, � ����� � ����. �� ��� ������� ���������� �� ����, �������, � ���� �������, ������ ����� �� ����� ����� ���.  �������� ��������������� � �������� ������, � ���������, ��� ������� ������ ������� �������� ��� �����. ���� ...',
        year_of_publication => 2014,
        age_limit => 3,
        price => 564,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('���������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('������', '���������', '�������', '������'),
        genres => book_pkg.genre('����������� ��������������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 14,
        issuer => 'Inspiria',
        title => '�������',
        summary => '�������� ����� ���������� ������������ ������ �����-������ � ��������� ��������� ������������ ������ � ��������� ���������. ������������� ����������, ����� �� ������� ��������� � 15 �������.  ������, 1799 ���. ���� �����, ���������� ���������-������, ����� �� ����� ������ ������� � ����� ����������. ���� ����� ����������� �� ���� � ��������� � ������, �� � ����� ������� ���������� ��������� ���� ��� ����� ��������� ��������� �������� ������������ ��������� ������������ ���������. ��������� ������ � ���������� ��������������� ���� � � ���������� �� ������� ������ ����� �������: ��� ����� ���� ������� ������� � ���������� �� ����� ����. ������ ���������������� � ������ ����������� ������� �����: ���-�� ��������� ��� ����� ��������� ������ � ������������� �������, ������ � �������� ���������, � ������ � ������ ������������� ����� �����. ��� �� ����� �������� ������� ������� � �...',
        year_of_publication => 2009,
        age_limit => 15,
        price => 796,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('�����-������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('���������', '��������', '����������', '�����'),
        genres => book_pkg.genre('������������ �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 12,
        issuer => '�����',
        title => '�������',
        summary => '������ ����������� ���������� ������������ ������� �������� �������� ������� ������� ����� � �� ������. ��� ��������� ������ � ������ � ����� ������������ ��������, � ����� �������� ����������, ��� ������� ������� �������� � ������ �����, ��������� ����� ���� ���������� �������. �����-�� �������� ������� ��� ������ � ����������� �������� ������� ������� � ���������� ������� ������ ����� ���������� ���������, ������� ���������� ��� ����� ������������� ���� � �����."�������" - ��� ������� � ������� � ����������, � �������������� �������� ��������� � ���������� �����������. ����������� ������������ ����� ��������� ����� ��������� (� ������� �����, ������ ������ � ����� ���� � ������� �����) ��� ����������� �� "�����" � ���� ���������� � �� "������� ������" - � �������.',
        year_of_publication => 2020,
        age_limit => 15,
        price => 369,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('�������', '�����', '�����������', '������'),
        genres => book_pkg.genre('����������� ���������� �����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 16,
        issuer => '����',
        title => '���������',
        summary => '������ 01.19',
        year_of_publication => 2019,
        age_limit => 3,
        price => 163,
        book_type => '������',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag(),
        genres => book_pkg.genre('��������������� ����������')
        );
    DBMS_OUTPUT.put_line ('--------------------');

    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 16,
        issuer => '����',
        title => '�����������',
        summary => '������ 04.14',
        year_of_publication => 2014,
        age_limit => 3,
        price => 20,
        book_type => '������',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag(),
        genres => book_pkg.genre('��������������� ����������')
        );
    DBMS_OUTPUT.put_line ('--------------------');
END;
/


 -- ��������� ������� ���������
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


-- ��������� ��������
DECLARE
    CLIENT_ID$                NUMBER;
BEGIN
    CLIENT_ID$ := client_pkg.create_client(
        first_name => '����', 
        last_name => '����������', 
        father_name => '��������', 
        birthday => TO_DATE('1/1/1980', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 0
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�������', 
        last_name => '�������', 
        father_name => '����������', 
        birthday => TO_DATE('2/2/1982', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 1
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '����', 
        last_name => '��������', 
        father_name => '����������', 
        birthday => TO_DATE('3/3/1984', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 2
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '������', 
        last_name => '���������', 
        father_name => '�����������', 
        birthday => TO_DATE('4/4/1986', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 3
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�����', 
        last_name => '���������', 
        father_name => '�����������', 
        birthday => TO_DATE('5/5/1988', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 4
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '��������', 
        last_name => '��������', 
        father_name => '���������', 
        birthday => TO_DATE('6/6/1990', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '��������', 
        last_name => '�������', 
        father_name => '���������', 
        birthday => TO_DATE('7/7/1992', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 6
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '���������', 
        last_name => '�������', 
        father_name => '���������', 
        birthday => TO_DATE('8/8/1994', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 7
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�����', 
        last_name => '�������', 
        father_name => '�����������', 
        birthday => TO_DATE('9/9/1996', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 8
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '������', 
        last_name => '��������', 
        father_name => '����������', 
        birthday => TO_DATE('10/10/1998', 'dd/mm/yyyy'), 
        employee => '������������', 
        rating => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�������', 
        last_name => '�����', 
        father_name => 'ϸ������', 
        birthday => TO_DATE('11/11/2000', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�����', 
        last_name => '������', 
        father_name => '����������', 
        birthday => TO_DATE('12/12/2002', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 6
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '������', 
        last_name => '��������', 
        father_name => '��������', 
        birthday => TO_DATE('13/2/2004', 'dd/mm/yyyy'), 
        employee => '������������', 
        rating => 6
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�������', 
        last_name => '������', 
        father_name => '������������', 
        birthday => TO_DATE('14/3/2006', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 7
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '����', 
        last_name => '�����', 
        father_name => '��������', 
        birthday => TO_DATE('15/4/2008', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 7
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '������', 
        last_name => '������', 
        father_name => '����������', 
        birthday => TO_DATE('16/5/2010', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 8
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '������', 
        last_name => '�������', 
        father_name => '�����������', 
        birthday => TO_DATE('17/6/2012', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 8
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '��������', 
        last_name => '�����', 
        father_name => '����������', 
        birthday => TO_DATE('18/7/2014', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 9
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�����', 
        last_name => '������', 
        father_name => '�������������', 
        birthday => TO_DATE('19/8/2016', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 9
        );
    DBMS_OUTPUT.put_line ('--------------------');

    CLIENT_ID$ := client_pkg.create_client(
        first_name => '�������', 
        last_name => '�����������', 
        father_name => '���������', 
        birthday => TO_DATE('20/9/2018', 'dd/mm/yyyy'), 
        employee => '', 
        rating => 10
        );
    DBMS_OUTPUT.put_line ('--------------------');
END;
/


-- ��������� ������ ������-������� ���� ��������, �.�. ����� ������� ������� ��� �������� � ������� ������,
-- ��� �������������� ������ ������� ������� book_pkg.get_book(), ���������� sysdate � ����� ������ � ���������� �������� 
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
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
    --������ �������������� ����������
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = 158;
END;
/


-- ������� �������
-- 1.�������� ������ ������ ���� ���� ��������� ������ (������� ������������ ����, �����, ���������� ����������� � ��� ������)
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
WHERE A.LAST_NAME = '������'
GROUP BY TITLE, FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME;
/

-- 2.�������� ������ ������ ���� ���� �������� ������������ ������������� (�����/����� �������� ���� - ������� ������������ ����, �����, ���������� �����������, ��� ������ � ������������)
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
WHERE P.PUBLISHER = '����' AND B.YEAR_OF_PUBLICATION > 2000
GROUP BY TITLE, AGE_LIMIT, PUBLISHER;
/

-- 3.����� ����� �� �������� ��������� (�� �����, �� �����, �� ������, �� �����������)
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
WHERE A.LAST_NAME = '������'
    AND B.AGE_LIMIT < 20
    AND T.TAG = '��������'
GROUP BY TITLE;
/

-- 4.����� ��� 5 ����� ���������� ���� (�� ���-�� ������)
SELECT *
FROM (
    SELECT 
        TITLE, 
        COUNT(B.ID) AS "������ ���",
        RANK() OVER (ORDER BY (COUNT(B.ID)) DESC) AS rank
    FROM BOOK B
        JOIN EXEMPLAR E
            ON E.ID_BOOK = B.ID 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON E.ID = DRB.ID_EXEMPLAR
    GROUP BY TITLE)
WHERE rank <= 5;
/

-- 5.����� ��� 5 ����� �������� ������������� (�� �������� ������)
SELECT *
    FROM (
    SELECT 
        LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME AS CLIENT, 
        COUNT(C.ID) AS "�����(a) ���",
        RANK() OVER (ORDER BY (COUNT(C.ID)) DESC) AS rank
    FROM CLIENT C 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON (C.ID = DRB.ID_CLIENT)
    WHERE DRB.TAKE_BOOK BETWEEN TO_DATE('2022/5/01', 'yyyy/mm/dd') AND TO_DATE('2022/8/01', 'yyyy/mm/dd')
    GROUP BY LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME)
WHERE rank <= 5;
/

-- 6.����� ������ ���� ������� �� ����� ���� ������ �������� ����� 
    SELECT 
    TITLE, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER,
    COUNT(B.ID) AS "�������� �� ������"
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
                WHERE CLIENT.ID = 10)) <= B.AGE_LIMIT -- �� �������� �� ����������� �����
    OR (SELECT 
            RATING
        FROM CLIENT
    WHERE ID = 10) = 0 -- �� �������� � ��������� 0
GROUP BY TITLE, PUBLISHER
UNION
SELECT *
    FROM(
    SELECT 
    TITLE, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER,
    COUNT(B.ID) AS "�������� �� ������"
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
WHERE "�������� �� ������" <= 1;
/

-- 7.������ ������� ������� ����� �� �������� ��������/�������� �������� �����
-- ������ ����� ��������� �����, ������ ����� ����� ���� ������ ����� ������ � ��������� ���� �����, ������ ����� ����� � �������� ���� � ������ ������(�������=0)
SELECT 
    TITLE, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER,
    CASE WHEN ((SELECT
                    COUNT(TITLE)
                FROM EXEMPLAR E
                    JOIN BOOK B
                        ON B.ID = E.ID_BOOK
                WHERE TITLE = '��� ���� ������������' 
                    AND ON_STORE = 1) > 1 -- ���� ����� �� ���������
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
                    AND B.TITLE = '��� ���� ������������') = 0 -- ���� ��� �� ���� ��� �����
            AND (SELECT
                    RATING
                FROM CLIENT C
                WHERE C.ID = 10) != 0 -- ���� ������� != 0
            AND (SELECT
                    AGE_LIMIT
                FROM BOOK B
                WHERE B.TITLE = '��� ���� ������������') <= (
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
                        WHERE ID = 10))) -- ���� ��������� ���������� ����
    )
        THEN 'YES' 
        ELSE 'NO' 
    END �����_�����_�����
FROM BOOK B 
    JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER) 
    JOIN EXEMPLAR E
        ON E.ID_BOOK = B.ID
WHERE TITLE = '��� ���� ������������'
GROUP BY TITLE, PUBLISHER;
/

-- 8.������� ������ ������������ ���� � �� ���������� �� ������ ���������
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

-- 9.������� ������ ��������������� ��������� (���� ������ 2� ���������)
SELECT C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT, 
    COUNT (C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME) AS ���������
FROM LOG_DELIVERY_RETURN_BOOK DRB 
    JOIN CLIENT C 
        ON (C.ID = DRB.ID_CLIENT)
WHERE DRB.RETURN_BOOK IS NULL 
    AND ROUND(SYSDATE - DRB.TAKE_BOOK) > 14
    OR ROUND(DRB.RETURN_BOOK - DRB.TAKE_BOOK) > 14
GROUP BY C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME, RATING
HAVING COUNT (C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME) > 2;
/

-- 10.����� ����� ������� �� ����� �����������
SELECT  
    C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT, 
    B.TITLE AS "��������� �����������",  
    B2.TITLE AS "������������"
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


--����� �������� �������� � �������
DECLARE
    CLIENT_ID$              NUMBER;
    BOOK_ID$                NUMBER;
    DELIVERY_EXEMPLAR_ID$   NUMBER;
BEGIN
-- ���������� �������
    CLIENT_ID$ := client_pkg.create_client(
            first_name => '���', 
            last_name => '�������', 
            father_name => '��������', 
            birthday => TO_DATE('1/1/1980', 'dd/mm/yyyy'), 
            employee => '', 
            rating => 5
            );
    DBMS_OUTPUT.put_line ('--------------------');

--���������� �����
    BOOK_ID$ := book_pkg.create_book(
        amount_books  => 5,
        issuer => '������������',
        title => '��������',
        summary => '����������',
        year_of_publication => 2022,
        age_limit => 13,
        price => 1638,
        book_type => '�����',
        a_first_names => book_pkg.a_first_name('������'),
        a_last_names => book_pkg.a_last_name('������'),
        a_father_names => book_pkg.a_father_name(' '),
        tags => book_pkg.tag('��������'),
        genres => book_pkg.genre('����')
        );
    DBMS_OUTPUT.put_line ('--------------------');

--������ �����
    DELIVERY_EXEMPLAR_ID$ := book_pkg.get_book(
        id_client$ => 11,
        title$ => '��������',
        issuer$ => '������������'
    );
    DBMS_OUTPUT.put_line ('--------------------');

--������� �����
    book_pkg.return_book(
        id_client$ => 11,
        title$ => '��������',
        publisher$ => '������������',
        rate_from_client$ => 5
    );
    DBMS_OUTPUT.put_line ('--------------------'); 

--��������� ������ � �������� ������ �� ����
    report_pkg.took_books_a_day_json(
        p_day => TO_DATE('1/12/2022', 'dd/mm/yyyy')
        );
    DBMS_OUTPUT.put_line ('--------------------'); 

--��������� ������ � ������������ ������ �� ����
    report_pkg.return_books_a_day(
        p_day => TO_DATE('15/3/2022', 'dd/mm/yyyy')
    );
    DBMS_OUTPUT.put_line ('--------------------'); 

--��������� ������ �� ��������������
    report_pkg.inventory();
    DBMS_OUTPUT.put_line ('--------------------'); 

--��������� ������� ������ ����������
    report_pkg.inventory_of_one(
        p_id_exemplar => 337
    );
    DBMS_OUTPUT.put_line ('--------------------'); 

END;

