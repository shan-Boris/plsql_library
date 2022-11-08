
DECLARE
    ANY_ROWS_FOUND NUMBER;
    PUBLISHER$     PUBLISHER.PUBLISHER%TYPE;
    BOOKID$        BOOK.ID%TYPE;
    TYPE BOOK_TYPES IS VARRAY(8) OF BOOK_TYPE.TYPE%TYPE;
    TYPES$         BOOK_TYPES := BOOK_TYPES('�����', '������', '������');
    TYPE BOOK_TAGS IS VARRAY(10) OF TAG.TAG%TYPE;
    TAGS$         BOOK_TAGS;
    TYPE BOOK_GENRES IS VARRAY(10) OF GENRE.GENRE%TYPE;
    GENRES$         BOOK_GENRES;
    TYPE A_FIRST_NAME IS VARRAY(100) OF AUTHOR.FIRST_NAME%TYPE;
    A_FIRST_NAMES$         A_FIRST_NAME;
    TYPE A_LAST_NAME IS VARRAY(100) OF AUTHOR.LAST_NAME%TYPE;
    A_LAST_NAMES$         A_LAST_NAME;
    TYPE A_FATHER_NAME IS VARRAY(100) OF AUTHOR.FATHER_NAME%TYPE;
    A_FATHER_NAMES$         A_FATHER_NAME;

BEGIN
 -- ��������� ���� �������� ���������� ���� �� ��� � ����
    FOR I IN 1..TYPES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            BOOK_TYPE
        WHERE
            TYPE = TYPES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO BOOK_TYPE (
                TYPE
            ) VALUES (
                TYPES$(I)
            );
        END IF;
    END LOOP;
    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����� �������. ��� ���� ���������� � ���������� ����',
        '��� ������� �������� ������. ���� ����. ���� ������ ������.� ������ 2015 ���� ��� ����� ��������� �������� �� ����� - �������� ����������� ������ �����-���� � ����������� ���� - ����������� � ����������, ����� �������� ������������� ���� �������� ��� ������������, ���������� �� �������� ����, ������ ��������� ���������, � ����� ����� �� ������ ������: ��� ����� ������� � �����, ����� ��� ��������� ������������ �������� - �� ������������ ��������� �������� �� ������, ��� �� �� ������ ���������� �����, �� ������ �� ���, ��� ������������� � ���� ��������, �� ���� ������ �������� ��������, �� ��������������, ������� �������� ������� �������, �� ������ ��������, ���������� �� �������?������� ������ � ������� ������. �������� ������� ��������� �����������, ������� ������ ��� ���������� �����, �������� ������������� ���������� ������, �� ����������� �� �������� �...',
        2002,
        13,
        1638,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('��������', '���', '�����', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������� ����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '��������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����������� ���� ������',
        '"����������� ���� ������", ���� �� ����� ���������� ������������ ����������� ������������� �������� ����� �����, ������������ � ����� � ��������� ������� �� ��������� � 30-40-� ������1� ����. ��� ����������� ��� �����, ����������� �����������, ��������� � ���� �����, ����������� �� ����� ���� - � ��� ����� ��� ��� ��������� ����������. � ���� � ��� ��� ������ ��� ����� ��� ��������, �������� ���� ��-�������� �������� ������ � ����������, ������ �� ������ � ���� ���������. ������� ���� ���� �������, ��� ����� ������ �� ����� �� ��������� ��������, ������ ��� ���� �����-��, ��� ������ � ����������� � ����� ������������ ������� � ���� ���������.����� � ������������� ������������� �������� ������.��� ����� 8-12 ���.',
        2020,
        3,
        1162,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '��������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('����', '�����������', '�����', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('�����������', '���������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����');
    A_LAST_NAMES$ := A_LAST_NAME('����');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..1 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '���� ����� � ���������� �����. ������� ����� ������������',
        '�� ����������� ���� ��������, ����� ��������� ��������. ���� ����� - �������-������������ - ����� ��� ��������� �����. ������ ����� �� ����� ���� ������� ��������� ���������� ����������� �������, ����� ���� �� ���� � ������� ������� �� ������ ����. � �� ���� ��� ����� ������� ����������. ���� ��� ��� ��� ����.������ �� ���� ��������� ���� �����? ��� ���������, � �������� �� ���������, �������� ��� ���������? ������ - ������. � ���� ��� ��������� ������ ������������ ����� ����� ���������� �����. ��� ���� ���� ���� ������ ������� �� ����������� �����, ��������� ��� ������������� � ������������ "�����", ������� ������� �������� �������. ������ ���� ������� ������, ��� � ������ ������� ��� ����� ������ ��������. ������ ����� ������ �����, �������� ����� �� ������������ � �����������, � ���������� �������� � ��������. ��� ������ ����� � ����� �������� ����, � ��...',
        2021,
        5,
        633,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('����', '������', '����', '��������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('�����������', '���������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�������');
    A_LAST_NAMES$ := A_LAST_NAME('����������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '1984',
        '������ ����� ��� ���� ����� ��������� ������ ������� �����, ����� ������ ������ (1903-1950) ������� ����� ���������� ���� ������������ - �����-���������� "1984". ������ �� ����, � ��� ����� ������ ������, ��������� ��� �� ������� ��������. ��������� ������������� �������, ��� �� ���� �������� �������� �� ��������� ���� "1984" ��� �������, ��� ������� ����� �� ���������� �����.����� - ��� ���������� - ��� ��������������� - ������� ��������� �������, ��� ��������� �������; ��� ��������� ���������, ��� ��������� �������. ���������������� �� ���� ����� �������. ���������������� ���������� � ������������ �������� � ������ �����.����� ������ ����-��, �� ��� ������, �, ���� ������ ������ �� ������ ��� ����, �� ���-���� ����� ��� ������������� ������',
        2020,
        14,
        344,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('���������', '������', '�������', '����������������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '1984',
        '������ ������ � ���� �� ����� �������� � ���� ������� � ����� �������������� ������� ������ �������. ������� � ��������, ������ � �����, ������� � �������, �� ����� � � ��������������� ��������, ������ � ������� � ����� �����. ���� ��������� ���������� � �������� ���������������� ����������, ������ ������� ���� ������ ��������, � �������� ��� ���������, �� � ������� ���������� ���� ��������� �����.  � ����� ������������ ������ ������ ������������ �������: ������ ������ ���� � ����� � ����� ����������, � ����� ��������� ������� ����������� ������������ �������-������ �������� ���� � ���������� �1984�.  ������ ����� ������� ���� � ����� ������� �� ��� ����� ������ � ������������ ������� ����� � 1920-� ���� � ������ ������� ����� ��-�� ������� ����������� ������������� ��������. ����� ���������� �������� � ���������� ���� �������� � �������� ���������������� ��...',
        2012,
        14,
        844,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('��������', '�������', '������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '���������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '1984',
        '������ ������ (1903-1950) ���� ����� ����������� ����������� ������ ������������� ������������� ����������. ��� ���� � ���� ������������ ������ ���� ��������� � ���������� ������ �������� XX ����, �� �� �������� ����� �������������� � � ���� ���. �����-���������� "1984" (1949) ������ ������������ ������ �������� - ������� ����� �������, ������� ��������� � ������������ ��������� ����� � ����� ������� �������� ��������������. � �������� ������� ������� ���������� ��������, ����������� ������� ����� � ������ � ��� ���������������� ��������� ������� ������. ������� ����� ������� ���� ������ ���� ������ ���� �� ���������������� ���������, ������������ ������������ ������������ ������. �� �������� ����������� ������� � ������� ������ �������������� ��� �����: �������� �������� �������, �� � ������ ��� ����� ������.',
        2021,
        14,
        391,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '���������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('������', '������', '�����������', '�����������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '1984',
        '����� "1984" - ������� ���������� ������� �������. � ��� �������� ��������, � ������� ���� ����� ��������� �� ������: �������, �����������������, ��������� ��������; �������, �� ������� ����� �� �� ���, ����������� ��� ���������� �������� ��������� � �������������� ���������, �������� ������� � ������, �������� ������������ ������ �� ����������� ������������� �������, ���������� �� ����; ������ - ��� �� �����������. � ���� �������� ������������ ����� �����; ������� ����� � ������ ���������, ������� ��������� ��������� �� ����� �����������. ����� �������� ���������� � �������� ��� ������������. ����� ������� ������ �����, ����������������� ����, �������������� ����� � ������, ���������� ��������������, ������������� - ���� ����� �������. �� �������� ������ ������� �, ��������������, ������, ��� ���� �������� �� ����. ���� ����� - �������������, �� �������� �������...',
        2016,
        14,
        281,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�������', '��������', '�����', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '���';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '1984',
        '������������ ������� ������ ������� ���������� XX ���� - "� ������ ����� ���" ������ ������. ���, � ��������, ��������: ���������� �� ������� "�������� �����������" - ��� ���������� �� �������� "�������� ����"? �� �������, ��� � �� ����� ���� ������ ������� ��������� ���������...������ ���� ������� ���� ������������ ������� � ������������ � ����� ������ ������������ ������. � ������ �����, ������� �� ��������� �� ������, ������� �� ������ ��������� ������, ������� �� ������������ ����� ����� ������, � ������� �� ������ �����������. �� ��� ������ ������� ��������� ������ �����, ��� ������� ��� ���������� �������� ������, ���� ������� ���� ������ ������ �� �����
',
        2008,
        16,
        269,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '���' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�������', '��������', '������', '�������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '������ �����-2. ���� ����. ��� 1',
        '������������� ������. ���� ��� ��� �� �����, ������� �������� ���� � ������ ���������. ������ ���������� �� ����, �������, ��� ��� ��������� ������ ���� � ������� ������� ������� ������ ����. ������ ����� � ���������, � �������, ��������, ������������ � �����. �� ������� ���������� ���� ����������� ������ - ��� ���������� �����, ���������, ����������� � ���� �����. ������ ���� ��� ������������ � ��� �������� ��������? ��� � ����� ������ � ������ ������������� �������� ������? ���� ���� ������� ���, ����, ������ �� �������� ������ ���� ����? � ����� ������� �������� ������ ��� ���� ��� � ���������� ����� - ���� � �������� ������ ��������!��� ��-���� �����?..',
        2020,
        15,
        1450,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '�������������', '����', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('���');
    A_LAST_NAMES$ := A_LAST_NAME('�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '������ �����-2. ���� ����. ��� 2',
        '����� ���������� ��������� ������� � ������������� ����������. ����, ������� ��������� �������� �������. ���� �� ����� ������� ������������ ������������� ��������. �� ��� - "������ �����" ���� ��������! �������, ������� ������ �������� ��� �����, ������� � ������ ����������. �� ������, ��� ��������� �� ����� ������� ����, ��������� � ������������, ������� �� ��������� �������������� � ����� �� ���-������ ����������� � ������� ���������� ���.� ����, ����� ������������� ��� ����, ����������� ��� ����� � ��������� ������ �� ��� �������. � ���� ��������, �������� ������ �����.',
        2023,
        14,
        1431,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '����', '����������', '�����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������� ������������� �������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('���');
    A_LAST_NAMES$ := A_LAST_NAME('�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '���������� ���� �� �����',
        '������� ����� ������: ����� ���������� �������, � ���� ������ �� �������, ����� ������� ���� ���� � ������ �������, ���� ���� ����� ���������� ����� ���������� �����. ���������� � ��� ������ �������� � �������� �� ��������. �� ��� ������ �� ��� ����� ����� ����. ����� ����� ����, ���� �� ������������ �� ����� ��������! ��������, ������� ����. � ������� ����, �������, ����� - ������, ������, ��������� ���������! � ���� - ��������� � ��������.�� ���� ���������� ���������, ����� � ����� �� ������� ��������� ����� � ������� �������� �� �� ������. ������ ������� ������ �� �������. ��������� ������� �� �������!���� ��������� - ����� ������� ����, ������� ������ ������� � �������� ������ ���������. � ������������ "������" �������� � ����� "����" � "�������� ������".��� ����� �������� ��������� ��������.',
        2007,
        3,
        308,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '����', '����', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������� � �������� � �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����', '���');
    A_LAST_NAMES$ := A_LAST_NAME('���������', '�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('��������', '����������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '���� ���������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '��������� �. ������� �����',
        '������������ �������� ������� ���������, � ��������� �������� ������ ���� ��������� ������� ���� � ������ ������. ����� ����������: ���� ������� ��� ���� �� ����� ��������� - ��� ����� ������ ������� ������� ������� �����. ��� �������� �� ������, ���������, ��� ��� �������� ���� ������! ������ ��� ������ ����������� ���� ��������!.. �������, �������� ��������� ���������. ��� ��-���� ���?..�������� �������� ����� ������� ��������� ��� ������� ����������� ������� ���������� � ������� ��������� ������, ����� ������� - "�������", ���������������, ������������, "�����", ����������� ������ ���� ��������. ����� ���� �������� �������� - ��������� � ��������, ������� �������� � ����� ����������� ��������������, ����������� �� �� ������ ��������� ���� ������ �� ���������, �� � ����� ������ ����.��� �������� � �������� ��������� ��������.',
        2020,
        3,
        720,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '���� ���������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('��������', '��������', '�������', '������������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������� � �������� � �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('��������', '����');
    A_LAST_NAMES$ := A_LAST_NAME('��������', '���������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����������', '��������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := 'XL Media';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����� �������� ����. ��� 1',
        '�������� �� ����� ����� ��������� �������� �� ���������� ������, � ��� �� ����������� � �������� ��� ����� � ����� ��� �������. ����� � ����� ��������, ��� �������� �������� ������� ����������. ������ ������ � ���� ������, � ������ ���������� �� ������� ����� �������� ��������, �������� ����� � ����. ���� ��������� ����������� ����� ����� ������ � ������������� ��������� ��� ����������� ������������ ������������ ���������. � ������ ������ �� � ��� �������� ���� ����������� �����-�������, ���������� ����� �� ������� ������. ����� � ��� ���������� �� ����� �����, ������� ����������� ������ ������ � �������. ������ �� ���������� � ������� ������������ ���������, ��� ������ ������� ������.',
        2021,
        5,
        628,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'XL Media' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '�����������', '���������', '�����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('�����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�����', '����');
    A_LAST_NAMES$ := A_LAST_NAME('�������', '���������');
    A_FATHER_NAMES$ := A_FATHER_NAME('��������', '��������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := 'XL Media';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����� �������� ����. ��� 2',
        'ʸ�� ������ �������������� ������� ����� � ���� �� ������� �� ����������� ����. ����� ��������� ���� �� �� ��� ���� �������� - ��� ���� ����, ����� �������� ������ ��������� ������ ��� � ����� ���������� �������: ��������� ���������� �������� ���� ��������� �����. ��� �������� ����� ���������� � ���� ������� �������� ������ �������-�������, � ������ ��� ������ - ��� ��������. ������ ����� ������ ��� ��������, ������� ��������� ������ ����� ���������� � ���� �������� ������� �������� ����� ������������ ����������� � ������?',
        2021,
        5,
        628,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'XL Media' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '���������', '������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('�����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�����');
    A_LAST_NAMES$ := A_LAST_NAME('�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('��������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����-������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '���, �������, � ������ ������. ��� ���������� ���������� � ����������',
        '����� ������� - ������ ��������� �������� � �������� � ���� �������. ����� "���, �������, � ������ ������" � ��������� ��������. ������������ �. �������� � ��� ����� ����������� ������ � ��������������� ����������� ���������� ������������� ����������� � ���, ��� ������������� ��������, � ����� ����� ����� ������. ��������� ����, �������������� � ���� �������� ����, �� ������������ � ���, ��� ������� ������ ���������� � ������������ ����������� � ����� ����� �������� ���������. �� �������, ��� ���������� ������������� ����������, ��� ��������, ��� �� �����, ��� ��������� ��� ������� �� ������ ��������, �� � �������������� �������. ������, ��������� � ���� �����, �������� ��� ����������� �������� ����������� �� ��������� ��������.',
        2021,
        3,
        767,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����-������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('���������', '�����������', '�������', '�����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������� ������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�����', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('�������', '�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('��.', '��������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '45 ���������� ���������. ������� ��� ���, ��� ������ � ��������� ���������',
        '� ���������� 45 ���������� �� ������������ �������� ������� �������� - ��� � ���� �������� ��������� �� ��������, ��� � � ���� ������������: ������, �������, ������ �� ���.���� �� ����� ��������� � � �� �� ����� ���������� ��������� - ��� ��������� ��������, ������� ���������, �������� � ���������� �������� �������� �����������, ������� ������������ ���������� � � �������������� ����������� � �������� ����������.������ ������� ������: ���, ���� �� ������ � ����� ���������������� ������������, �� ������ ��������� ������ � ��������. ������� ���� �������� ���� ��������, ��������� ��������, ����� ���������� � ���������, ������ ������ ������ �����������, ������ ������������� ���� ����� � ������� �������.������� ������ ����� ��������.���� �� ��������� ��������� ������ � �� ����� ��������� ������� �� ����� �� ����� ������������������ ������, �� ��� �� ����� ����� �����...',
        2021,
        3,
        1461,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('��������', '�����', '����', '����������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������� ������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('�������', '�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����������', '��������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '11 ������������ � ����� �� �����. �������������� ������ ������������ ��������� ��������������',
        '���� ������� ������ ������������ ��������� �������� ������������� ������������� ����������, ������� ����� ���������� ����� ������������� ����� �� �����. ��� ����� ��� ����� ������ � ������� �������� �������� ����������, ��� ��������� ���������, � ������� ������������� � �������� ��������� ����������� ����������. ��� � ������ �������� ���� ������������� ������������� �� ������ ���������� ��������� ��������� �����. ����� �� ���� �������� ���� ���������, � ������� ��������� ��������������� ��������� ��������� ����� �������: ��������, ����, ��������, ���������. ��� �������� ���� � ������ � ��������� ������, �������� ������� �� ��������� � ����� ����������, � ��������� �������� ����� ������, ���, ��������, �������� ����. � XXI ���� ����� ������������: �� ������� � ������� ������������ ����� ��������� � ���������� �� ������ ������� � ����.',
        2008,
        0,
        376,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�������', '������', '������������', '���������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('��������� ������������ ��������������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�����');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '�� ������������ � �����. ������������ �������� ������ ������������ ����',
        '���� �������� ������������ ������� � �������� ���������. ��� �������� ������������� ��� ����� �������� ������ �� ����������. �� ������ �� ��� ����������? ��������� �������� ���� ���� - ������, ��������� ������������ �����������, ������������� �����, ������� ������-���������� ������� BBC. �� �� ������������ � ����������� ����� �� ������ ��������. ��������� ���� ����� �� �� ������ ������� ������ ��, ����� ������ �� ������� ������������, ��������, ������������, ��������, ������� ������, ����������, ����������, �� � ������� ������ �� �������: - �������� �� ��������, �� �������� �������� �������� �����, ����������� �������� ��� ���� � �������������� ����? - ������ � �������������������, ���������� � ����� ������� ����������� ���� �� ���������� ������ �������, ��� ���� ����������� ������? - ��� �������� �� ������������ ����� ����������? - � ������, ������ � �����������...',
        2021,
        0,
        616,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('������', '������', '��������', '����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������ ������������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('����', '������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', ' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '��������� ����',
        '������� ��������� ����, � ��������� ��� ��������� ��� �������, ��� ����� ��� � ����� ������ �������: ��� ���� ��������� � ��������� �����.�������� � �� �� ����� �� ����� ������� � ������������ ����������, ����������� � ������� ����� ����������, �������� ��������� ����� ����� ������������ �������� ����: ���� "�������� ������" - ���������� ������������ ����� ���.������ ����� ����� �����������, ��� �������� ������� ����� �����, � ����������� �� ��������������� ���: �������� �� ������������ �����������, ���������� ������ �� ������������� ������������. ������ ������ ������ ��������� �������� ������ � �� ������ - ��������� ������� ����������, ����������� ������������ ������������ ������������.',
        2020,
        18,
        370,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('���������', '�������', '���������', '����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('��', '������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', ' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '������ �����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '������ ��������',
        '�������, ������� ��������, ���������� �������� �������� ����������� � �������, ������� ����� ���... � ��������� ������� � ���� ������� ���� �������. ������ ������� �� ��� ����� ���������� �� ����������� �����, � ��� ��� ������ �������������. ������������� � ���� ���� ��������. �� ������� - ������������ ����� ������ �� ������, ����������� � 1937 ����. �����, ��� ���-�� �������? ������ ������� � ������� �������� ����� ���. ������ ������� �����, ��� ������� ����� ����������� � �������, ��� ����� ��������, � ���������-����������� � �������� ���������..."������ ��������" - ���� �� ������ ������� ������ �����.',
        2021,
        18,
        728,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '������ �����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�������', '�������', '�����', '�������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('�����', '������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', ' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '���� ������� �� ���������',
        '� ������������ ����������� ������...������ ��������� ���� ��� �������-������������...�������� ��������...����� ���������� � ���� "�������� �� ���������"!� ���� �����������, ������������� ����� ������ �������� ��������, ������� ������ ����������� ����������� � ������� ��� ������, ����� �������� ����������� ������������. ��� �������� ���� "���� ������� �� ���������". ��������, �����, ������� � ��� ��� ��������� ������� �������, �� � ��� ��� ��� ���� ���-����� ����� � ������. ����� �������� ��������� ������� �������, � ����� � ����� �������������� ������������ ����������, "���� ������� �� ���������" �������� �������� ������ ��������� ����. ������ ���������� ������ �������� �����. ������ �� ���� ��������� ������� ������� ������, ���� �� ����� ������� ������?�� ������������ ����� ����� (������� 28 ������ 1970 ����) - ���������� �����������, ��������, ����� � ��������, �������� ��...',
        2021,
        18,
        798,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('����', '���������', '������', '�������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('�����');
    A_FATHER_NAMES$ := A_FATHER_NAME('�����');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '������� ������',
        '�� ��� ������� ���, ����� ����, ��� ��� ������ ��� ����� � ���? ������ �������� ������, ����������� ������-��������, ����� �� �������, ���������� ������������� � ��������� ���. ����������, �������� ������ - ������, �� �� � �������, � ��������� ��������. ��� ������ ����� � ���������� "����������" ���� � �������� ����������. ����� � ����� � ������������� ���� ��������� ������, ����������� ������� ��������, ��� ���������� � ������� �������. ���� ������ ������ ����� ������ �������. � �������� ������ ��������� �����������. ��� ���� ����� ��������, ��� �� ����� �����������, �������� ���� ���.',
        2019,
        14,
        650,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('���', '������', '��������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('���������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�����');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME('������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '��������. ����������� �������� ����-���',
        '������ �������, ���������� ������������ ������� � ������� ��������� ���������� ������, ������� ������ �������� ��������� � ����������. ��� ����� "��������" - ��������� ��������� ����� �����: ������������� "������ �������", � ������� ���������, ������ � ���������� ������������� ����� ����������� � ���������� ������� �����, ��������� �������� ������� � �������������� ������������� � ���� ���� ����� � �������� ������. "��������" - ������ �� ����� ������������, ������������ �� ������������ ����������� ���������� �������� ����-���, �������-������������, �������� �������� �� ��������� ������� � ����������� �� ����� ������. ����� �������� �������� ������ ��. ������ �. ����. ������� �� ������� �����.',
        2022,
        10,
        827,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '��������', '�������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('�������������� ���������� ������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('�������', '������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', '������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := 'fanzon';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����',
        '����� ������ �������� MATERIA PRIMA. ��� ���������� ��������� ������� � ���������� �����������?���� ������� �������� ����� ���������� �����������, ���������� � ���������� ��������� �������� � �����. ����� ����������� �� ������� ���������. ����� ������������ ���������� �����, � ��������� ������ ���������.���� ������� ������� ������� �������, �� ������ �������� � ���������� �������. ������� ��������� ������� ������������ ���������� �������� �, ��� ������, ����������� ������, ������� � ���������.���������� ������� � ��������� ��������������, �� ��������� � ������������ �� ���, ��� ��� �������� � ��� �����."Materia Prima ��-�������� ���� �� ����� ������ �������� � �������� ������� �� ��������� ����, ������� �� ����� �������� �� ����". - taniaksiazka.pl"�������� �������������, ������� ����������". - Empic.pl"��� �������� �����, ���������� � ���� �������, ������������ ...',
        2021,
        13,
        586,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'fanzon' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('���������', '�������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������� ���������� �������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����', '�����');
    A_LAST_NAMES$ := A_LAST_NAME('�������', '������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', '������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '��� ����',
        '"� "���� ����" � ���������� �������, �� ������� ������������ ������ ������, ��� ��������� ���������� ���������� ������ �������, �� �� ������� ����� ������� ����������� ������. ���������� ���������� ���� ��������� � ����������������� �������������� ������� � ��������� ������� � �������� ���������� �� ������ � ��������. ��������������� ����� �� ����������� �������, �����������, ������ ���� ��������������. ����� ��������� ������ ��������� �����������, � ��������� � ������� �� ��������� ������������� ������������� �����������, ����� ����������� ������ � ������� � ��������� ������ �������, ���������� ��������� "�������" �������� ������������������� �� ������ ������������������ ������.  �������, ��� �� ����� � ������� ����������� �������� ��� �������� ����������� �������� ������� ����� ��������� ����� ����� ������. ���� ������� �����, ���������� ������������ ����������...',
        2022,
        3,
        295,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('������', '����', '����������', '����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����');
    A_LAST_NAMES$ := A_LAST_NAME('�������');
    A_FATHER_NAMES$ := A_FATHER_NAME('���������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '���';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����������� ���������� � �������',
        '� ���� ��� ����� ���������� ����� ������� ����������  ������������ ���������� � ������� � ��������� ������������ �� ������ ������� �������, ���������� ����������� ������������� ��������� �������, ��� ������ ������� ���������� ������������� ����� � ����������.',
        2019,
        10,
        467,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '���' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '����������', '�����', '�������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�������');
    A_LAST_NAMES$ := A_LAST_NAME('����������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '������';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����� - ������ �������� ����!',
        '����� ����� ������ ������������ The New York Times ���� �������� "����� - ������ �������� ����!" ������ ������ ������ ���� 2020 �� ������ Popsugar.������� ������� �����, �����, ��������, ��� ��������� ��� ���� ���������, �������� � ������������ ������, ����� ���� ��� �� ��������. ������������� ������� � ���������� ��������������, ����� ����������� ������ � ��������, ���-����� �� ������� � ���������� � ������ � �������, ��� ���� �� ���� ���� ������, ���������� �� ������ ����� ��� �����, �� ����� ���� � ��� ������� ���� �� �����. � ������� ���� � ������� ���� ����� ����� ����������� ����� � ���� �� ������ ��������, ��������� � ��������� � ������� ������� ���� ������ ���, ��� ������� �� �� �������� �� ������.',
        2005,
        8,
        845,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '������' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�����', '�����', '������', '�����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������� ��������������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('����');
    A_LAST_NAMES$ := A_LAST_NAME('��������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '��� ���� ������������',
        '������� ����� ������������� TikTok, ����� 610 ��������� ����������. "������ ��������, ��� ����� ������ �����, ����� ������ ��� �� ����. ���� �������� �������, ��� ���� ������������� ������ � ������� �����. ����� �� ����� ������� �������� ������.  �� �� � ������ �� ������ ���� �� �����. �� ������ ����� �������.  �� � ������ ��� ����� ������� � ��������������� �������, ��� � ���� �� ���� ���������, ����� � ���� �����, ����� �� ������ ����.  ���� �������, ��� �� ������, ��� �������� ������ ������� �� ���� �������, ����� � ������������� �� ���� �� �����".  ����������� ����� ����� � ������ �������� �� ������������� ����.  ��� ������������� ��� ������� ���������������. �����������, �� �������� ������. ������ �� �������� �����. ��� ����� ������ �� ���������?  ����� �������, ��� ������ ������������. �� �� ����������� ���������� � ���, ��� ����� �� ���� � �����.  ������� ...',
        2015,
        13,
        600,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('����', '�����', '�������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������� ��������������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('�����');
    A_LAST_NAMES$ := A_LAST_NAME('�����');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := 'Inspiria';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '����� �� ����',
        '��������� ������ - ���� �� ������� ������� ������������ "�������������� ������".  �� ������� �� ����� ��������� ����� ������� ����� 8 ��� �����������.  "Le Figaro" ���������������� ��������� ������ ��� ������ �� ����� ������������� ������� ������.  � ���� ������ ��������� ������������ �� 15 ����������� ������.     "������������ �����, ������ �������������� �� ������� ������� ���������". - France Info  "��������� ������ ������������ ����� ������������ ��������". - L Obs  "����������� ���������� ��������� ������ ������ �������� ��� ������ � ��������". - Le Parisien   ������ ����� �� ����� ����� ����� ���� �������� ������� �������, ��� �������� ���, � ����� � ����. �� ��� ������� ���������� �� ����, �������, � ���� �������, ������ ����� �� ����� ����� ���.  �������� ��������������� � �������� ������, � ���������, ��� ������� ������ ������� �������� ��� �����. ���� ...',
        2014,
        3,
        564,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Inspiria' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('������', '���������', '�������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������� ��������������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('���������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := 'Inspiria';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '�������',
        '�������� ����� ���������� ������������ ������ �����-������ � ��������� ��������� ������������ ������ � ��������� ���������. ������������� ����������, ����� �� ������� ��������� � 15 �������.  ������, 1799 ���. ���� �����, ���������� ���������-������, ����� �� ����� ������ ������� � ����� ����������. ���� ����� ����������� �� ���� � ��������� � ������, �� � ����� ������� ���������� ��������� ���� ��� ����� ��������� ��������� �������� ������������ ��������� ������������ ���������. ��������� ������ � ���������� ��������������� ���� � � ���������� �� ������� ������ ����� �������: ��� ����� ���� ������� ������� � ���������� �� ����� ����. ������ ���������������� � ������ ����������� ������� �����: ���-�� ��������� ��� ����� ��������� ������ � ������������� �������, ������ � �������� ���������, � ������ � ������ ������������� ����� �����. ��� �� ����� �������� ������� ������� � �...',
        2009,
        15,
        796,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Inspiria' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('���������', '��������', '����������', '�����');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('������������ �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('�����-������');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '�����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '�������',
        '������ ����������� ���������� ������������ ������� �������� �������� ������� ������� ����� � �� ������. ��� ��������� ������ � ������ � ����� ������������ ��������, � ����� �������� ����������, ��� ������� ������� �������� � ������ �����, ��������� ����� ���� ���������� �������. �����-�� �������� ������� ��� ������ � ����������� �������� ������� ������� � ���������� ������� ������ ����� ���������� ���������, ������� ���������� ��� ����� ������������� ���� � �����."�������" - ��� ������� � ������� � ����������, � �������������� �������� ��������� � ���������� �����������. ����������� ������������ ����� ��������� ����� ��������� (� ������� �����, ������ ������ � ����� ���� � ������� �����) ��� ����������� �� "�����" � ���� ���������� � �� "������� ������" - � �������.',
        2020,
        15,
        369,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '�����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '�����')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS('�������', '�����', '�����������', '������');
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('����������� ���������� �����');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME('������');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '���������',
        '������ 01.19',
        2019,
        3,
        163,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '������')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS();
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('��������������� ����������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

----------------------------------

    -- ��������� ������������ ���� ��� ��� � ���� ���
    PUBLISHER$ := '����';
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

    BOOKID$ := BOOK_ID_SEQ.NEXTVAL;

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
        BOOKID$,
        '�����������',
        '������ 04.14',
        2014,
        3,
        20,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = '����' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = '������')
    );

    -- ��������� ���� ������� ��� � ���� � ������� ���� 
    TAGS$ := BOOK_TAGS();
    FOR I IN 1..TAGS$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            TAG
        WHERE
            TAG = TAGS$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO TAG (
                TAG
            ) VALUES (
                TAGS$(I)
            );

        END IF;
        -- ��������� ����� ��� - �����
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ����� ������� ��� � ���� � ������� ������ 
    GENRES$ := BOOK_GENRES('��������������� ����������');
    FOR I IN 1..GENRES$.COUNT LOOP
        SELECT
            COUNT(*) INTO ANY_ROWS_FOUND
        FROM
            GENRE
        WHERE
            GENRE = GENRES$(I);
        IF ANY_ROWS_FOUND = 0 THEN
            INSERT INTO GENRE (
                GENRE
            ) VALUES (
                GENRES$(I)
            );   
        END IF;

        -- ��������� ����� ���� - �����
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- ��������� ������� ������� ��� � ���� � ������� ������� 
    A_FIRST_NAMES$ := A_FIRST_NAME('������');
    A_LAST_NAMES$ := A_LAST_NAME('������');
    A_FATHER_NAMES$ := A_FATHER_NAME('����');
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

        -- ��������� ����� ����� - �����
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

    -- ��������� ���������� ���� �� ����� � ����������
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

 -- ��������� ��������

    FOR I IN 0..10 LOOP
        INSERT INTO RATING (
            RATING
        ) VALUES (
            I
        );
    END LOOP;
----------------------------------
-- ��������� ��������

INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '����',
    '����������',
    '��������',
    TO_DATE('2018/5/01', 'yyyy/mm/dd'), 
    NULL,
    6
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�������',
    '�������',
    '����������',
    TO_DATE('2016/5/01', 'yyyy/mm/dd'),
    NULL,
    7
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '����',
    '��������',
    '����������',
    TO_DATE('2014/5/01', 'yyyy/mm/dd'),
    NULL,
    5
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '������',
    '���������',
    '�����������',
    TO_DATE('2012/5/01', 'yyyy/mm/dd'),
    NULL,
    6
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�����',
    '���������',
    '�����������',
    TO_DATE('2010/5/01', 'yyyy/mm/dd'),
    NULL,
    4
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '��������',
    '��������',
    '���������',
    TO_DATE('2008/5/01', 'yyyy/mm/dd'),
    NULL,
    5
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '��������',
    '�������',
    '���������',
    TO_DATE('2006/5/01', 'yyyy/mm/dd'),
    NULL,
    6
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '���������',
    '�������',
    '���������',
    TO_DATE('2004/5/01', 'yyyy/mm/dd'),
    NULL,
    7
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�����',
    '�������',
    '�����������',
    TO_DATE('2002/5/01', 'yyyy/mm/dd'),
    '������������',
    8
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '������',
    '��������',
    '����������',
    TO_DATE('2000/5/01', 'yyyy/mm/dd'),
    NULL,
    5
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�������',
    '�����',
    'ϸ������',
    TO_DATE('1998/5/01', 'yyyy/mm/dd'),
    '������������',
    5
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�����',
    '������',
    '����������',
    TO_DATE('1996/5/01', 'yyyy/mm/dd'),
    NULL,
    0
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '������',
    '��������',
    '��������',
    TO_DATE('1994/5/01', 'yyyy/mm/dd'),
    '������������',
    6
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�������',
    '������',
    '������������',
    TO_DATE('1992/5/01', 'yyyy/mm/dd'),
    NULL,
    0
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '����',
    '�����',
    '��������',
    TO_DATE('1990/5/01', 'yyyy/mm/dd'),
    '��������',
    7
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '������',
    '������',
    '����������',
    TO_DATE('1988/5/01', 'yyyy/mm/dd'),
    NULL,
    8
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '������',
    '�������',
    '�����������',
    TO_DATE('1986/5/01', 'yyyy/mm/dd'),
    '������������',
    8
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '��������',
    '�����',
    '����������',
    TO_DATE('1984/5/01', 'yyyy/mm/dd'),
    NULL,
    9
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�����',
    '������',
    '�������������',
    TO_DATE('1982/5/01', 'yyyy/mm/dd'),
    NULL,
    9
);

-----------------------------------------$

    INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    '�������',
    '�����������',
    '���������',
    TO_DATE('1980/5/01', 'yyyy/mm/dd'),
    NULL,
    10
);
-- ��������� ������ ������/��������


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