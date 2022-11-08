-- Запрос который покажет может ли читатель почитать/получить желаемую книгу

-- Нельзя взять последнюю книгу, нельзя взять книгу если должен сдать другую и просрочен срок сдачи, нельзя взять книгу и почитать если в черном списке(рейтинг=0)

SELECT 
    TITLE, 
    LISTAGG(FIRST_NAME||' '||LAST_NAME||' '||FATHER_NAME, '; ') AS AUTHOR, 
    PUBLISHER, 
    CASE WHEN (STORE > 1 AND 
            (SELECT 
                COUNT((SYSDATE - DRB.TAKE_BOOK - 14))
            FROM LOG_DELIVERY_RETURN_BOOK DRB 
                JOIN CLIENT C 
                    ON (C.ID = DRB.ID_CLIENT)
            WHERE DRB.RETURN_BOOK IS NULL 
                AND ROUND(SYSDATE - DRB.TAKE_BOOK) > 14
                AND C.FIRST_NAME = 'Олеся' 
                AND C.LAST_NAME = 'Осипова') = 0) 
        THEN 'YES' 
        ELSE 'NO' 
    END Можно_взять_домой ,
    CASE WHEN STORE >= 1 
        THEN 'YES' 
        ELSE 'NO' 
    END Можно_читать
FROM AMOUNT_OF_BOOK AB 
    JOIN BOOK B 
        ON (B.ID = AB.ID_BOOK)
    JOIN AUTHOR_WROTE_BOOK AWB 
        ON (AWB.ID_BOOK = B.ID)
    JOIN AUTHOR A 
        ON(A.ID = AWB.ID_AUTHOR)
    JOIN PUBLISHER P 
        ON (P.ID = B.ID_PUBLISHER) 
WHERE STORE >=  1 
    AND TITLE = 'Все твои совершенства'
    AND B.AGE_LIMIT < (
        SELECT 
            AGE 
        FROM CLIENT C 
        WHERE C.FIRST_NAME = 'Олеся' 
            AND C.LAST_NAME = 'Осипова'
            AND C.RATING <> 0)
GROUP BY TITLE, PUBLISHER, STORE;


