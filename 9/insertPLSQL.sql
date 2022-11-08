
DECLARE
    ANY_ROWS_FOUND NUMBER;
    PUBLISHER$     PUBLISHER.PUBLISHER%TYPE;
    BOOKID$        BOOK.ID%TYPE;
    TYPE BOOK_TYPES IS VARRAY(8) OF BOOK_TYPE.TYPE%TYPE;
    TYPES$         BOOK_TYPES := BOOK_TYPES('Книга', 'Журнал', 'Газета');
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
 -- добавляем типы печатных материалов если их нет в базу
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
    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Манн';
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
        'Книга радости. Как быть счастливым в меняющемся мире',
        'Два великих духовных лидера. Пять дней. Один вечный вопрос.В апреле 2015 года два самых радостных человека на свете - лауреаты Нобелевской премии Далай-лама и архиепископ Туту - встретились в Дхарамсале, чтобы отметить восьмидесятый день рождения Его Святейшества, оглянуться на прожитые годы, полные непростых испытаний, и найти ответ на вечный вопрос: как найти радость в жизни, когда нас обуревают повседневные невзгоды - от недовольства дорожными пробками до страха, что мы не сможем обеспечить семью, от злости на тех, кто несправедливо с нами обошелся, до горя утраты любимого человека, от опустошенности, которую приносит тяжелая болезнь, до бездны отчаяния, приходящей со смертью?Диалоги велись в течение недели. Духовные мастера обсуждали препятствия, которые мешают нам радоваться жизни, подробно проговаривали негативные эмоции, их воздействие на человека и...',
        2002,
        13,
        1638,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('человека', 'Два', 'найти', 'вечный');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Религии мира');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Дуглас');
    A_LAST_NAMES$ := A_LAST_NAME('Абрамс');
    A_FATHER_NAMES$ := A_FATHER_NAME('Туту');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Лабиринт';
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
        'Приключения Тома Сойера',
        '"Приключения Тома Сойера", одно из самых популярных произведений знаменитого американского писателя Марка Твена, рассказывает о жизни в маленьком городке на Миссисипи в 30-40-х годахХ1Х века. Как признавался сам автор, большинство приключений, описанных в этой книге, происходило на самом деле - с ним самим или его школьными товарищами. И хотя с тех пор прошло уже почти два столетия, проделки Тома по-прежнему вызывают улыбку и сочувствие, причем не только у юных читателей. Недаром Марк Твен заявлял, что своей книгой он хотел бы напомнить взрослым, какими они были когда-то, что думали и чувствовали и какие удивительные события с ними случались.Книга с классическими иллюстрациями Анатолия Иткина.Для детей 8-12 лет.',
        2020,
        3,
        1162,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Лабиринт' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Тома', 'Приключения', 'самых', 'Сойера');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Приключения', 'Детективы');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Марк');
    A_LAST_NAMES$ := A_LAST_NAME('Твен');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Феникс';
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
        'Урри Вульф и похититель собак. История юного изобретателя',
        'Не обязательно быть взрослым, чтобы совершать открытия. Урри Вульф - мальчик-изобретатель - знает это абсолютно точно. Больше всего на свете Урри мечтает построить скоростной космический корабль, чтобы путь на Луну и обратно занимал не больше часа. А на Луну ему нужно попасть непременно. Ведь там его ждёт папа.Сумеет ли Урри воплотить свою мечту? Или трудности, с которыми он столкнётся, заставят его отступить? Поживём - увидим. А пока ему предстоит помочь приятельнице Фэбби найти пропавшего щенка. Для этой цели Урри создаёт робопса со сверхострым нюхом, микровошь для прослушивания и авточерепаху "ПРЫТЬ", которые помогут отыскать пропажу. Вообще Урри глубоко убеждён, что в скором будущем мир будет заселён роботами. Машины будут лечить людей, защищать Землю от столкновения с метеоритами, а нанороботы бороться с вирусами. Его смелые мысли у одних вызывают смех, у др...',
        2021,
        5,
        633,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Феникс' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Урри', 'больше', 'Луну', 'взрослым');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Приключения', 'Детективы');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Евгения');
    A_LAST_NAMES$ := A_LAST_NAME('Высокосная');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Текст';
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
        '1984',
        'Прошло всего три года после окончания Второй мировой войны, когда Джордж Оруэлл (1903-1950) написал самое знаменитое свое произведение - роман-антиутопию "1984". Многое из того, о чем писал Джордж Оруэлл, покажется вам до безумия знакомым. Некоторые исследователи считают, что ни один западный читатель не постигнет суть "1984" так глубоко, как человек родом из Советского Союза.Война - это мирСвобода - это рабствоНезнание - силаКто управляет прошлым, тот управляет будущим; кто управляет настоящим, тот управляет прошлым. Действительность не есть нечто внешнее. Действительность существует в человеческом сознании и больше нигде.Когда любишь кого-то, ты его любишь, и, если ничего больше не можешь ему дать, ты все-таки даешь ему любовь…Джордж Оруэлл',
        2020,
        14,
        344,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Текст' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('управляет', 'Оруэлл', 'прошлым', 'Действительность');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('зарубежная проза');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джордж');
    A_LAST_NAMES$ := A_LAST_NAME('Оруэлл');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Эксмо';
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
        '1984',
        'Джордж Оруэлл — один из самых читаемых в мире авторов и очень противоречивая персона своего времени. Родился в Бенгалии, учился в Итоне, работал в полиции, на радио и в букинистическом магазине, воевал в Испании и писал книги. Ярый противник коммунизма и защитник демократического социализма, Оруэлл устроил бунт против общества, к которому так стремился, но в котором чувствовал себя абсолютно чужим.  В книге представлены четыре разных произведения Оруэлла: ранние романы «Дни в Бирме» и «Дочь священника», а также принесшие мировую известность сатирическая повесть-притча «Скотный двор» и антиутопия «1984».  Первый роман Оруэлла «Дни в Бирме» основан на его опыте работы в колониальной полиции Бирмы в 1920-е годы и вызвал горячие споры из-за резкого изображения колониального общества. «Дочь священника» знакомит с совершенно иным Оруэллом — мастером психологического ре...',
        2012,
        14,
        844,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('общества', 'полиции', 'Оруэлл', 'Оруэлл');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('зарубежная проза');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джордж');
    A_LAST_NAMES$ := A_LAST_NAME('Оруэлл');
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

    -- добавляем экземпляры книг на склад в библиотеку
    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Антология';
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
        '1984',
        'Джордж Оруэлл (1903-1950) всем своим творчеством протестовал против тоталитарного общественного устройства. Эта тема в силу исторических причин была актуальна в литературе первой половины XX века, но не утратила своей злободневности и в наши дни. Роман-антиутопия "1984" (1949) рисует тоталитарный Лондон будущего - крупный город Океании, которая находится в беспрерывном состоянии войны с двумя другими мировыми сверхдержавами. В обществе принята жесткая социальная иерархия, большинство граждан живут в нищете и под непрекращающимся контролем Полиции мыслей. Главный герой Уинстон Смит многие годы выдает себя за добропорядочного чиновника, разделяющего общепринятые политические идеалы. Но внезапно вспыхнувшее чувство к коллеге Джулии переворачивает его жизнь: приносит недолгое счастье, но и ставит вне рамок закона.',
        2021,
        14,
        391,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Антология' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Джордж', 'Оруэлл', 'творчеством', 'протестовал');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('зарубежная проза');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джордж');
    A_LAST_NAMES$ := A_LAST_NAME('Оруэлл');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Каро';
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
        '1984',
        'Роман "1984" - вершина творчества Джорджа Оруэлла. В нем показано общество, в котором люди четко разделены на классы: верхний, привилегированный, партийная верхушка; средний, не имеющий права ни на что, находящийся под постоянным прицелом телекамер и подслушивающих устройств, лишенный общения и эмоций, делающий механическую работу по регулярному переписыванию истории, обделенный во всем; низший - как бы пролетариат. В этом обществе искореняется любая мысль; человек живет в страхе наказания, которое неизбежно последует за любую провинность. Такое общество уничтожает в человеке все человеческое. Чтобы человек меньше думал, примитивизируется язык, переписываются книги и газеты, поощряется доносительство, предательство - даже своих близких. Не остается ничего святого и, соответственно, ничего, для чего хотелось бы жить. Этот роман - захватывающее, но страшное повеств...',
        2016,
        14,
        281,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Каро' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('человек', 'общество', 'роман', 'ничего');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('зарубежная проза');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джордж');
    A_LAST_NAMES$ := A_LAST_NAME('Оруэлл');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'АСТ';
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
        '1984',
        'Своеобразный антипод второй великой антиутопии XX века - "О дивный новый мир" Олдоса Хаксли. Что, в сущности, страшнее: доведенное до абсурда "общество потребления" - или доведенное до абсолюта "общество идеи"? По Оруэллу, нет и не может быть ничего ужаснее тотальной несвободы...Каждый день Уинстон Смит переписывает историю в соответствии с новой линией Министерства Правды. С каждой ложью, которую он переносит на бумагу, Уинстон всё больше ненавидит Партию, которая не интересуется ничем кроме власти, и которая не терпит инакомыслия. Но чем больше Уинстон старается думать иначе, тем сложнее ему становится избежать ареста, ведь Большой Брат всегда следит за тобой…
',
        2008,
        16,
        269,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'АСТ' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Уинстон', 'общество', 'больше', 'антипод');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('фантастика');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джордж');
    A_LAST_NAMES$ := A_LAST_NAME('Оруэлл');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Эксмо';
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
        'Гибель Богов-2. Душа Бога. Том 1',
        'Упорядоченное гибнет. Хаос рвёт его на части, Дальние обращают миры в мёртвые кристаллы. Гремит величайшая из битв, Рагнарёк, где все сражаются против всех в тщетной попытке прожить лишний день. Гибнут герои и защитники, а умершие, напротив, возвращаются к жизни. Из небытия выныривает тень величайшего оружия - трёх магических Мечей, Алмазного, Деревянного и Меча Людей. Только кому они понадобились в дни всеобщей погибели? Кто и зачем собрал в недрах Межреальности немёртвую Армаду? Куда ведёт золотой луч, путь, пройти по которому сможет лишь один? И зачем девочка Рандгрид бьётся изо всех сил с гигантским змеем - ведь в Рагнарёке нельзя победить!Или всё-таки можно?..',
        2020,
        15,
        1450,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('зачем', 'Упорядоченное', 'Хаос', 'гибнет');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('фантастика');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Ник');
    A_LAST_NAMES$ := A_LAST_NAME('Перумов');
    A_FATHER_NAMES$ := A_FATHER_NAME('Даниилович');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Феникс';
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
        'Гибель Богов-2. Душа Бога. Том 2',
        'Самое масштабное эпическое полотно в отечественной фантастике. Цикл, ставший классикой русского фэнтези. Один из самых больших литературных русскоязычных фэндомов. Всё это - "Гибель Богов" Ника Перумова! История, начатая больше тридцати лет назад, подошла к своему завершению. Мы узнаем, что случилось со всеми героями саги, смертными и бессмертными, уцелела ли Вселенная Упорядоченного и вышел ли кто-нибудь победителем в схватке вселенских сил.В день, когда заканчиваются все пути, открываются все двери и находятся ответы на все вопросы. В день Рагнарёка, истинной гибели богов.',
        2023,
        14,
        1431,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Феникс' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Богов', 'день', 'масштабное', 'Самое');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Героическое отечественное фэнтези');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Ник');
    A_LAST_NAMES$ := A_LAST_NAME('Перумов');
    A_FATHER_NAMES$ := A_FATHER_NAME('Даниилович');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Волчок';
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
        'Каскадерки идут до конца',
        'Девочки такие разные: Кирка занимается спортом, а Варя играет на пианино, Кирка прыгает выше всех и бегает быстрее, зато Варя умеет выдумывать новые интересные слова. Одинаковые у них только причёски и царапины на коленках. Но для дружбы на всю жизнь этого мало. Нужно общее дело, чтоб не расставаться до самой старости! Например, снимать кино. В главной роли, конечно, Кирка - ловкая, смелая, настоящая каскадёрка! А Варя - сценарист и оператор.Но кино приходится забросить, когда с одной из девочек случается беда… а подруга приходит ей на помощь. Нельзя бросать дружбу на полпути. Каскадёрки никогда не сдаются!Анна Анисимова - автор детских книг, лауреат премии Маршака и финалист премии Крапивина. В издательстве "Волчок" выходили её книги "Гутя" и "Кедровый слоник".Для детей среднего школьного возраста.',
        2007,
        3,
        308,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Волчок' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Кирка', 'Варя', 'кино', 'премии');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Повести и рассказы о детях');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Анна', 'Ник');
    A_LAST_NAMES$ := A_LAST_NAME('Анисимова', 'Перумов');
    A_FATHER_NAMES$ := A_FATHER_NAME('Павловна', 'Даниилович');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Пять четвертей';
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
        'Василькин Д. Седьмой отряд',
        'Долгожданные каникулы наконец наступили, и выпускник третьего класса Дима Василькин впервые едет в летний лагерь. Будем откровенны: сама поездка ему была не очень интересна - наш герой просто готовил сюрприз лучшему другу. Как удивился бы Костик, обнаружив, что они проведут лето вместе! Только вот судьба преподносит свои сюрпризы!.. Кажется, каникулы безнадёжно испорчены. Или всё-таки нет?..Виктория Ледерман давно знакома читателям как классик современной детской литературы и лауреат множества премий, среди которых - "Книгуру", Корнейчуковская, Крапивинская, "Алиса", посвящённая памяти Кира Булычёва. Герои книг Виктории Ледерман - мальчишки и девчонки, которые попадают в самые необычайные обстоятельства, позволяющие им не только проверить свою дружбу на прочность, но и лучше узнать себя.Для младшего и среднего школьного возраста.',
        2020,
        3,
        720,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Пять четвертей' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('каникулы', 'Ледерман', 'наконец', 'Долгожданные');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Повести и рассказы о детях');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Виктория', 'Анна');
    A_LAST_NAMES$ := A_LAST_NAME('Ледерман', 'Анисимова');
    A_FATHER_NAMES$ := A_FATHER_NAME('Валерьевна', 'Павловна');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
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
        'Проза бродячих псов. Том 1',
        'Мальчика по имени Ацуси Накадзима выгоняют из сиротского приюта, и так он оказывается в Иокогаме без денег и крыши над головой. Ацуси в таком отчаянии, что решается ограбить первого встречного. Однако сердце у него доброе, и вместо ограбления он спасает жизнь тонущему человеку, которого видит в реке. Этим человеком оказывается некто Осаму Дадзай — эксцентричный сотрудник так называемого Вооруженного детективного агентства. В данный момент он и его товарищи ищут загадочного тигра-людоеда, наводящего страх на жителей округи. Ацуси и сам натерпелся от этого тигра, поэтому соглашается помочь Дадзаю в поисках. Вскоре он знакомится с другими сотрудниками агентства, где каждый другого чуднее.',
        2021,
        5,
        628,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'XL Media' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Ацуси', 'оказывается', 'агентства', 'имени');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Манга');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Кафка', 'Анна');
    A_LAST_NAMES$ := A_LAST_NAME('Асагири', 'Анисимова');
    A_FATHER_NAMES$ := A_FATHER_NAME('Харукава', 'Павловна');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
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
        'Проза бродячих псов. Том 2',
        'Кёка Идзуми воспротивилась приказу мафии и едва не погибла по собственной вине. Ацуси Накадзима спас ее да еще тофу накормил - все ради того, чтобы выведать ценные сведения… Только мир и покой продлились недолго: Акутагава разработал коварный план похищения Ацуси. Тем временем перед закованным в цепи Дадзаем предстал бывший товарищ-мафиози, а теперь его недруг - Тюя Накахара. Дадзай Осаму против Тюи Накахары, Рюноскэ Акутагава против Ацуси Накадзимы… К чему приведет крупный конфликт между вооруженными детективами и мафией?',
        2021,
        5,
        628,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'XL Media' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Ацуси', 'Акутагава', 'против', 'Идзуми');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Манга');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Кафка');
    A_LAST_NAMES$ := A_LAST_NAME('Асагири');
    A_FATHER_NAMES$ := A_FATHER_NAME('Харукава');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Олимп-Бизнес';
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
        'Нет, спасибо, я просто смотрю. Как посетителя превратить в покупателя',
        'Гарри Фридман - мастер розничной торговли и обучения в этой области. Книга "Нет, спасибо, я просто смотрю" о розничной торговле. Уникальность Г. Фридмана и его книги заключается именно в непревзойденной способности превращать потенциальных покупателей в тех, кто действительно покупает, а также учить этому других. Используя юмор, сопричастность и свой огромный опыт, он рассказывает о том, как достичь вершин мастерства в обслуживании покупателей и стать самым успешным продавцом. Вы узнаете, как преодолеть сопротивление покупателя, как выяснить, что он хочет, как заставить его сделать не только основную, но и дополнительную покупку. Приемы, описанные в этой книге, позволят вам значительно ускорить продвижение по служебной лестнице.',
        2021,
        3,
        767,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Олимп-Бизнес' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('розничной', 'покупателей', 'Фридман', 'Гарри');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Техники продаж');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Гарри', 'Кафка');
    A_LAST_NAMES$ := A_LAST_NAME('Фридман', 'Асагири');
    A_FATHER_NAMES$ := A_FATHER_NAME('Дж.', 'Харукава');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Манн';
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
        '45 татуировок продавана. Правила для тех, кто продаёт и управляет продажами',
        'О книгеНовые 45 татуировок из продавцового прошлого Максима Батырева - как в роли рядового менеджера по продажам, так и в роли руководителя: успехи, неудачи, выводы из них.Одна из самых непростых и в то же время интересных профессий - это профессия человека, который ежедневно, ежечасно и ежеминутно защищает интересы организации, проводя коммерческие переговоры с её потенциальными заказчиками и будущими партнерами.Максим Батырев уверен: все, чего он достиг в своей профессиональной деятельности, он достиг благодаря работе в продажах. Продажи учат защищать свои интересы, выступать публично, вести переговоры с клиентами, делать своими руками презентации, внятно формулировать свои мысли и многому другому.Продажи делают людей сильными.Если вы научитесь продавать товары с не самой очевидной выгодой на одном из самых высококонкурентных рынков, то вам по плечу будут практ...',
        2021,
        3,
        1461,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('интересы', 'самых', 'роли', 'переговоры');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Техники продаж');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Максим', 'Кафка');
    A_LAST_NAMES$ := A_LAST_NAME('Батырев', 'Асагири');
    A_FATHER_NAMES$ := A_FATHER_NAME('Валерьевич', 'Харукава');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Дискурс';
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
        '11 исследований о жизни на Земле. Рождественские лекции Королевского института Великобритании',
        'Этот сборник лекций Королевского института посвящен исследованиям разнообразных организмов, которые могут приоткрыть тайну возникновения жизни на Земле. Еще сотню лет назад ученые с помощью рисунков пытались воссоздать, как выглядели динозавры, а сегодня представление о вымерших рептилиях кардинально изменилось. Уже в начале прошлого века исследователи предупреждали об угрозе очередного массового вымирания видов. Тогда же была озвучена идея экосистем, в которых органично взаимодействуют различные обитатели нашей планеты: растения, рыбы, животные, насекомые. Они общаются друг с другом и природной средой, посылают сигналы об опасности и умеют защищаться, а некоторые поражают своим пением, как, например, горбатые киты. В XXI веке наука подтверждает: от сложных и хрупких взаимосвязей между животными и растениями во многом зависят и люди.',
        2008,
        0,
        376,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Дискурс' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('сборник', 'лекций', 'Королевского', 'института');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Концепции современного естествознания');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Хелен');
    A_LAST_NAMES$ := A_LAST_NAME('Скейлз');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Портал';
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
        'Не приспособлен к жизни. Человеческая эволюция против современного мира',
        'Люди выкованы естественным отбором и отточены эволюцией. Они идеально приспособлены для мира… которого больше не существует. Но почему же так получилось? Разъяснит ситуацию Адам Харт - биолог, профессор Университета Глостершира, популяризатор науки, соавтор научно-популярных фильмов BBC. Мы не адаптированы к сегодняшней жизни по многим причинам. Благодаря этой книге вы не только сможете понять их, узнав больше об истории человечества, генетике, биогеографии, биохимии, половом отборе, психологии, социологии, но и найдете ответы на вопросы: - является ли ожирение, от которого страдают миллионы людей, результатом эволюции или дело в наследственной лени? - почему в высокотехнологичном, безопасном и очень удобном современном мире мы испытываем больше стресса, чем наши первобытные предки? - как повлияют на человечество новые технологии? - и почему, говоря о собственном...',
        2021,
        0,
        616,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Портал' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('больше', 'почему', 'выкованы', 'Люди');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Другие биологические науки');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Адам', 'Хелен');
    A_LAST_NAMES$ := A_LAST_NAME('Харт', 'Скейлз');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Аркадия';
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
        'Цветочная сеть',
        'Посреди пекинской зимы, в последние дни правления Дэн Сяопина, сын посла США в Китае найден мертвым: его тело погребено в замерзшем озере.Примерно в то же время на борту корабля с нелегальными мигрантами, дрейфующего у берегов Южной Калифорнии, помощник прокурора Дэвид Старк обнаруживает страшный груз: труп "красного принца" - наследника политической элиты КНР.Власти обеих стран подозревают, что убийства связаны между собой, и соглашаются на беспрецедентный шаг: несмотря на политические разногласия, объединить усилия по расследованию преступлений. Теперь Дэвиду Старку предстоит работать вместе с Лю Хулань - пекинской красной принцессой, инспектором Министерства общественной безопасности.',
        2020,
        18,
        370,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Аркадия' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('пекинской', 'Посреди', 'последние', 'зимы');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Детективы');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Лиза', 'Хелен');
    A_LAST_NAMES$ := A_LAST_NAME('Си', 'Скейлз');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Фантом Пресс';
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
        'Черные кувшинки',
        'Девочка, любящая рисовать, невероятно красивая школьная учительница и старуха, которая видит все... В деревушке Живерни у реки найдено тело ребенка. Лоренс Серенак не так давно выпустился из полицейской школы, и это его первое расследование. Подозреваемых у него хоть отбавляй. Но главное - преступление очень похоже на давнее, случившееся в 1937 году. Может, они как-то связаны? Только старуха с совиным взглядом знает это. Только старуха знает, что история может повториться и девочка, что любит рисовать, и красавица-учительница в огромной опасности..."Черные кувшинки" - один из лучших романов Мишеля Бюсси.',
        2021,
        18,
        728,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Фантом Пресс' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('старуха', 'Девочка', 'знает', 'любящая');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Детективы');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Мишель', 'Хелен');
    A_LAST_NAMES$ := A_LAST_NAME('Бюсси', 'Скейлз');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Манн';
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
        'Клуб убийств по четвергам',
        'О книгеЧетверо престарелых героев...Первое серьезное дело для женщины-полицейского...Жестокое убийство...Добро пожаловать в клуб "Убийства по четвергам"!В доме престарелых, расположенном среди мирных сельских пейзажей, четверо друзей еженедельно встречаются в комнате для отдыха, чтобы обсудить нераскрытые преступления. Они называют себя "Клуб убийств по четвергам". Элизабет, Джойс, Ибрагим и Рон уже разменяли восьмой десяток, но у них все еще есть кое-какие трюки в запасе. Когда местного строителя находят мертвым, а рядом с телом обнаруживается таинственная фотография, "Клуб убийств по четвергам" внезапно получает первое настоящее дело. Вскоре количество трупов начинает расти. Сможет ли наша необычная команда поймать убийцу, пока не стало слишком поздно?Об автореРичард Томас Осман (родился 28 ноября 1970 года) - английский телеведущий, продюсер, комик и писатель, наиболее из...',
        2021,
        18,
        798,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('клуб', 'четвергам', 'Первое', 'убийств');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Детективы');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Ричард');
    A_LAST_NAMES$ := A_LAST_NAME('Осман');
    A_FATHER_NAMES$ := A_FATHER_NAME('Томас');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Эксмо';
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
        'Красный дракон',
        'Мы все безумцы или, может быть, это мир вокруг нас сошел с ума? Доктор Ганнибал Лектер, легендарный убийца-каннибал, попав за решетку, становится консультантом и союзником ФБР. Несомненно, Ганнибал Лектер - маньяк, но он и философ, и блестящий психиатр. Его мучает скука и отсутствие "интересных" книг в тюремной библиотеке. Зайдя в тупик в расследовании дела серийного убийцы, прозванного Красным Драконом, ФБР обращается к доктору Лектеру. Ведь только маньяк может понять маньяка. И Ганнибал Лектер принимает предложение. Для него важно доказать, что он умнее преступника, которого ищет ФБР.',
        2019,
        14,
        650,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('ФБР', 'Лектер', 'Ганнибал', 'маньяк');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Детективы');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Томас');
    A_LAST_NAMES$ := A_LAST_NAME('Харрис');
    A_FATHER_NAMES$ := A_FATHER_NAME('Энтони');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Аркадия';
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
        'Гомункул. Приключения Лэнгдона Сент-Ива',
        'Джеймс Блэйлок, знаменитый американский фантаст и лауреат множества престижных премий, положил начало движению стимпанка в литературе. Его роман "Гомункул" - настоящая жемчужина этого жанра: абсурдистская "черная комедия", в которой атмосфера, обычаи и технологии Викторианской эпохи соседствуют с таинствами древней магии, загадками далекого космоса и захватывающими приключениями в духе Жюля Верна и Герберта Уэллса. "Гомункул" - первое из цикла произведений, повествующих об удивительных похождениях профессора Лэнгдона Сент-Ива, ученого-изобретателя, большого охотника до всяческих диковин и джентльмена до мозга костей. Роман Блэйлока удостоен Премии им. Филипа К. Дика. Впервые на русском языке.',
        2022,
        10,
        827,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Аркадия' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('роман', 'Гомункул', 'Блэйлок', 'Джеймс');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Фантастический зарубежный боевик');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джеймс', 'Томас');
    A_LAST_NAMES$ := A_LAST_NAME('Блэйлок', 'Харрис');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', 'Энтони');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
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
        'Тень',
        'Финал первой трилогии MATERIA PRIMA. Чем закончится последняя схватка с неумолимым противником?Срок мирного договора между Варшавской республикой, Российской и Германской империями подходит к концу. Новое наступление на Варшаву неминуемо. Лидер Кинжальщиков смертельно болен, и предстоят выборы преемника.Граф Самарин оставил военную карьеру, но теперь вовлечен в придворные интриги. Алхимик Рудницкий берется расследовать ритуальные убийства и, как обычно, разматывает клубок, ведущий к Проклятым.Библейская легенда о нефилимах подтверждается, но Рудницкий и предположить не мог, что это коснется и его лично."Materia Prima по-прежнему один из самых крутых сериалов в польском фэнтези за последние годы, давайте не будем забывать об этом". - taniaksiazka.pl"Действие стремительное, скучать невозможно". - Empic.pl"Это отличная книга, сочетающая в себе фэнтези, исторический ...',
        2021,
        13,
        586,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'fanzon' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Рудницкий', 'фэнтези');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Героическое зарубежное фэнтези');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Адам', 'Томас');
    A_LAST_NAMES$ := A_LAST_NAME('Пшехшта', 'Харрис');
    A_FATHER_NAMES$ := A_FATHER_NAME(' ', 'Энтони');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Эксмо';
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
        'Час Быка',
        '"В "Часе Быка" я представил планету, на которую переселилась группа землян, они повторяют пионерское завоевание запада Америки, но на гораздо более высокой технической основе. Неимоверно ускоренный рост населения и капиталистическое хозяйствование привели к истощению планеты и массовой смертности от голода и болезней. Государственный строй на ограбленной планете, естественно, должен быть олигархическим. Чтобы построить модель подобного государства, я продолжил в будущее те тенденции гангстерского фашиствующего монополизма, какие зарождаются сейчас в Америке и некоторых других странах, пытающихся сохранить "свободу" частного предпринимательства на густой националистической основе.  Понятно, что не наука и техника отдаленного будущего или странные цивилизации безмерно далеких миров сделались целью моего романа. Люди будущей Земли, выращенные многовековым существова...',
        2022,
        3,
        295,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('основе', 'Часе', 'представил', 'Быка');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('фантастика');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Иван');
    A_LAST_NAMES$ := A_LAST_NAME('Ефремов');
    A_FATHER_NAMES$ := A_FATHER_NAME('Антонович');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'АСТ';
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
        'Понедельник начинается в субботу',
        'В этот том вошел знаменитый роман братьев Стругацких  «Понедельник начинается в субботу» — буквально раздерганная на цитаты история веселых, остроумных сотрудников таинственного института НИИЧАВО, где вполне всерьез занимаются исследованием магии и волшебства.',
        2019,
        10,
        467,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'АСТ' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('вошел', 'знаменитый', 'роман', 'братьев');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('фантастика');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Аркадий');
    A_LAST_NAMES$ := A_LAST_NAME('Стругацкий');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Феникс';
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
        'Париж - всегда отличная идея!',
        'Новый роман автора бестселлеров The New York Times Джен МакКинли "Париж - всегда отличная идея!" назван лучшей книгой лета 2020 по версии Popsugar.Главная героиня книги, Челси, осознает, что последний раз была счастлива, влюблена и наслаждалась жизнью, когда жила год за границей. Вдохновившись теплыми и радостными воспоминаниями, Челси разыскивает Колина в Ирландии, Жан-Клода во Франции и Марчеллино в Италии в надежде, что один из этих трех мужчин, похитивших ее сердце много лет назад, на самом деле и был любовью всей ее жизни. В поисках себя и мужчины свой мечты Челси встречается лицом к лицу со своими страхами, прощается с иллюзиями и наконец находит свою любовь там, где никогда бы не подумала ее искать.',
        2005,
        8,
        845,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Феникс' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Челси', 'Новый', 'автора', 'роман');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Современный сентиментальный роман');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джен');
    A_LAST_NAMES$ := A_LAST_NAME('МакКинли');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Эксмо';
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
        'Все твои совершенства',
        'Любимый автор пользователей TikTok, более 610 миллионов упоминаний. "Трудно признать, что браку пришел конец, когда любовь еще не ушла. Люди привыкли считать, что брак заканчивается только с утратой любви. Когда на место счастья приходит злость.  Но мы с Грэмом не злимся друг на друга. Мы просто стали другими.  Мы с Грэмом так давно смотрим в противоположные стороны, что я даже не могу вспомнить, какие у него глаза, когда он внутри меня.  Зато уверена, что он помнит, как выглядит каждый волосок на моем затылке, когда я отворачиваюсь от него по ночам".  Совершенной любви Куинн и Грэмма угрожает их несовершенный брак.  Они познакомились при сложных обстоятельствах. Драматичное, но красивое начало. Сейчас же близится конец. Что может спасти их отношения?  Куинн уверена, что должна забеременеть. Но ее уверенность становится и тем, что ведет их брак к концу.  Сколько ...',
        2015,
        13,
        600,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('брак', 'любви', 'уверена', 'Грэмом');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Современный сентиментальный роман');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Колин');
    A_LAST_NAMES$ := A_LAST_NAME('Гувер');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
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
        'Глядя на море',
        'Франсуаза Бурден - одна из ведущих авторов европейского "эмоционального романа".  Во Франции ее книги разошлись общим тиражом более 8 млн экземпляров.  "Le Figaro" охарактеризовала Франсуазу Бурден как одного из шести популярнейших авторов страны.  В мире романы Франсуазы представлены на 15 иностранных языках.     "Трогательный роман, прочно обосновавшийся на вершине книжных рейтингов". - France Info  "Франсуаза Бурден завораживает своим писательским талантом". - L Obs  "Романтичная оптимистка Франсуаза Бурден готова показать нам лучшее в мужчинах". - Le Parisien   Больше всего на свете Матье любит свой успешный книжный магазин, где проводит дни, а порой и ночи. Он все сильнее отдаляется от Тесс, которая, в свою очередь, больше всего на свете любит его.  Действие разворачивается в портовом городе, в Нормандии, где соленый воздух свободы пропитал все улицы. Тесс ...',
        2014,
        3,
        564,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Inspiria' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('Бурден', 'Франсуаза', 'авторов', 'больше');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Современный сентиментальный роман');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Франсуаза');
    A_LAST_NAMES$ := A_LAST_NAME('Бурден');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
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
        'Пандора',
        'Дебютный роман британской писательницы Сьюзен Стокс-Чепмен — идеальное сочетание георгианской Англии и греческой мифологии. Международный бестселлер, права на издание выкуплены в 15 странах.  Лондон, 1799 год. Дора Блейк, начинающая художница-ювелир, живет со своей ручной сорокой в лавке древностей. Ныне место принадлежит ее дяде и находится в упадке, но в былые времена магазинчик родителей Доры был очень известным благодаря широкому ассортименту подлинных произведений искусства. Появление пифоса — загадочной древнегреческой вазы — и скрываемые им секреты меняют жизнь девушки: она видит шанс вернуть магазин и избавиться от гнета дяди. Однако заинтересованных в пифосе оказывается слишком много: кто-то благодаря ему может проложить дорогу в академическое будущее, другой — потешить самолюбие, а третий — сполна удовлетворить жажду денег. Что за тайны скрывает древняя находка и к...',
        2009,
        15,
        796,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Inspiria' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('благодаря', 'Дебютный', 'британской', 'роман');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Исторический роман');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Сьюзен');
    A_LAST_NAMES$ := A_LAST_NAME('Стокс-Чепмен');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Эксмо';
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
        'Шоколад',
        'Сонное спокойствие маленького французского городка нарушено приездом молодой женщины Вианн и ее дочери. Они появились вместе с шумным и ярким карнавальным шествием, а когда карнавал закончился, его светлая радость осталась в глазах Вианн, открывшей здесь свой Шоколадный магазин. Каким-то чудесным образом она узнает о сокровенных желаниях жителей городка и предлагает каждому именно такое шоколадное лакомство, которое заставляет его вновь почувствовать вкус к жизни."Шоколад" - это история о доброте и терпимости, о противостоянии невинных соблазнов и закоснелой праведности. Одноименный голливудский фильм режиссера Лассе Халлстрёма (с Жюльетт Бинош, Джонни Деппом и Джуди Денч в главных ролях) был номинирован на "Оскар" в пяти категориях и на "Золотой глобус" - в четырех.',
        2020,
        15,
        369,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
    TAGS$ := BOOK_TAGS('городка', 'Вианн', 'спокойствие', 'Сонное');
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Современная зарубежная проза');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Джоанн');
    A_LAST_NAMES$ := A_LAST_NAME('Харрис');
    A_FATHER_NAMES$ := A_FATHER_NAME('Энтони');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Манн';
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
        'Игромания',
        'Выпуск 01.19',
        2019,
        3,
        163,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Журнал')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Развлекательная литература');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Дуглас');
    A_LAST_NAMES$ := A_LAST_NAME('Абрамс');
    A_FATHER_NAMES$ := A_FATHER_NAME('Туту');
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

    -- добавляем экземпляры книг на склад в библиотеку
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

    -- добавляем издательство если его еще в базе нет
    PUBLISHER$ := 'Манн';
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
        'Буревестник',
        'Выпуск 04.14',
        2014,
        3,
        20,
        ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
        (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Газета')
    );

    -- добавляем тэги которых нет в базе в таблицу тэги 
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
        -- добавляем связь тэг - книга
        INSERT INTO BOOK_HAVE_TAG(
            ID_TAG,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM TAG WHERE TAG = TAGS$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем жанры которых нет в базе в таблицу жанров 
    GENRES$ := BOOK_GENRES('Развлекательная литература');
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

        -- добавляем связь жанр - книга
        INSERT INTO BOOK_HAVE_GENRE(
            ID_GENRE,
            ID_BOOK
        ) VALUES (
            (SELECT ID FROM GENRE WHERE GENRE = GENRES$(I)),
            BOOKID$
        );
    END LOOP;

    -- добавляем авторов которых нет в базе в таблицу авторов 
    A_FIRST_NAMES$ := A_FIRST_NAME('Дуглас');
    A_LAST_NAMES$ := A_LAST_NAME('Абрамс');
    A_FATHER_NAMES$ := A_FATHER_NAME('Туту');
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

    -- добавляем экземпляры книг на склад в библиотеку
    FOR I IN 1..17 LOOP
        INSERT INTO EXEMPLAR (
            ID_BOOK,
            ON_STORE
        ) VALUES (
            BOOKID$,
            1
        );   
    END LOOP;

 -- добавляем рейтинги

    FOR I IN 0..10 LOOP
        INSERT INTO RATING (
            RATING
        ) VALUES (
            I
        );
    END LOOP;
----------------------------------
-- добавляем клиентов

INSERT INTO CLIENT (
        FIRST_NAME,
        LAST_NAME,
        FATHER_NAME,
        BIRTHDAY,
        EMPLOYEE,
        RATING
    ) VALUES (
    'Дина',
    'Евдокимова',
    'Евсеевна',
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
    'Валерия',
    'Фадеева',
    'Михаиловна',
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
    'Зара',
    'Елисеева',
    'Тимофеевна',
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
    'Полина',
    'Кириллова',
    'Геннадьевна',
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
    'Илона',
    'Самойлова',
    'Альвиановна',
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
    'Изабелла',
    'Симонова',
    'Натановна',
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
    'Северина',
    'Петрова',
    'Даниловна',
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
    'Августина',
    'Маслова',
    'Давидовна',
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
    'Олеся',
    'Осипова',
    'Альвиановна',
    TO_DATE('2002/5/01', 'yyyy/mm/dd'),
    'Библиотекарь',
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
    'Венера',
    'Сазонова',
    'Евгеньевна',
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
    'Аверьян',
    'Фокин',
    'Пётрович',
    TO_DATE('1998/5/01', 'yyyy/mm/dd'),
    'Библиотекарь',
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
    'Игорь',
    'Петров',
    'Мартынович',
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
    'Герман',
    'Гаврилов',
    'Петрович',
    TO_DATE('1994/5/01', 'yyyy/mm/dd'),
    'Библиотекарь',
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
    'Василий',
    'Ефимов',
    'Серапионович',
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
    'Клим',
    'Рябов',
    'Павлович',
    TO_DATE('1990/5/01', 'yyyy/mm/dd'),
    'Директор',
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
    'Лазарь',
    'Маслов',
    'Мартынович',
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
    'Богдан',
    'Соколов',
    'Ярославович',
    TO_DATE('1986/5/01', 'yyyy/mm/dd'),
    'Библиотекарь',
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
    'Болеслав',
    'Лапин',
    'Леонидович',
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
    'Остап',
    'Карпов',
    'Христофорович',
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
    'Савелий',
    'Селиверстов',
    'Мэлорович',
    TO_DATE('1980/5/01', 'yyyy/mm/dd'),
    NULL,
    10
);
-- заполняем журнал выдачи/возврата


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