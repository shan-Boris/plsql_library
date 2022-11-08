-- Написать запрос поиска всех книг заданного автора (вывести наименование книг, жанра, возрастное ограничение и ФИО автора)



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