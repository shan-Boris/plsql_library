-- Найти список книг которые не могут быть выданы читателю домой

SELECT 
    TITLE, 
    LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER
FROM AMOUNT_OF_BOOK AB 
    JOIN BOOK B 
        ON (B.ID = AB.ID_BOOK)
    JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER)
WHERE STORE <= 1 -- не выдается последняя книга
AND (SELECT 
        AGE
    FROM CLIENT
    WHERE FIRST_NAME = 'Валерия'
        AND LAST_NAME = 'Фадеева') >= B.AGE_LIMIT -- не выдается по возрастному цензу
AND (SELECT 
        RATING
    FROM CLIENT
WHERE FIRST_NAME = 'Валерия'
        AND LAST_NAME = 'Фадеева') > 0 -- не выдается клиентам с 0 рейтингом
GROUP BY TITLE, PUBLISHER;