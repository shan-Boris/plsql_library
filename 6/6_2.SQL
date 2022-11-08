-- Написать запрос поиска всех книг изданных определенным издательством (позже/ранее заданной даты - вывести наименование книг, жанра, возрастное ограничение, ФИО автора и издательство)


SELECT 
    TITLE, 
    LISTAGG(GENRE, '; ') AS GENRES, 
    AGE_LIMIT, 
    LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHORS, 
    PUBLISHER
FROM AUTHOR A 
    JOIN AUTHOR_WROTE_BOOK AWB
        ON (A.ID = AWB.ID_AUTHOR)
    RIGHT JOIN BOOK B
        ON (B.ID =AWB.ID_BOOK)
    LEFT JOIN BOOK_HAVE_GENRE BHG
        ON (B.ID = BHG.ID_BOOK)
    LEFT JOIN GENRE G
        ON (BHG.ID_GENRE = G.ID)
    JOIN PUBLISHER P
        ON (P.ID = B.ID_PUBLISHER)
WHERE P.PUBLISHER = 'Манн' AND B.YEAR_OF_PUBLICATION > 2000
GROUP BY TITLE, AGE_LIMIT,PUBLISHER;

