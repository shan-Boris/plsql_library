-- Найти книги по заданным критериям (по жанру, по тегам, по автору, по ограничению)


SELECT 
    TITLE, 
    LISTAGG(GENRE, '; ') AS GENRES, 
    LISTAGG(AGE_LIMIT, '; ') AS AGE_LIMITS, 
    LISTAGG(DISTINCT TAG, ', ') AS TAGS, 
    LISTAGG(DISTINCT FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS FIO
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