
-- ТОП 10 самых популярных книг (по кол-ву выдачи)
CREATE OR REPLACE VIEW TOP_BOOKS AS
    SELECT 
        TITLE, 
        COUNT(B.ID) AS "Выдано раз",
        RANK() OVER (ORDER BY (COUNT(B.ID)) DESC) AS rank
    FROM BOOK B 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON (B.ID = DRB.ID_BOOK)
    GROUP BY TITLE;
    

-- SELECT 
--     * 
-- FROM TOP_BOOKS
-- WHERE rank <= 10;

-- ТОП 10 самых читающих пользователей (за заданный период)
CREATE OR REPLACE VIEW TOP_READERS AS
    SELECT 
        LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME AS CLIENT, 
        COUNT(C.ID) AS "Читал(a) раз",
        RANK() OVER (ORDER BY (COUNT(C.ID)) DESC) AS rank
    FROM CLIENT C 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON (C.ID = DRB.ID_CLIENT)
    WHERE DRB.TAKE_BOOK BETWEEN TO_DATE('2022/5/01', 'yyyy/mm/dd') AND TO_DATE('2022/8/01', 'yyyy/mm/dd')
    GROUP BY LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME;


-- SELECT 
--     * 
-- FROM TOP_READERS
-- WHERE rank <= 10;


-- Все книги, которые читатель может почитать/получить
-- Нельзя взять последнюю книгу, нельзя взять книгу если должен сдать другую и просрочен срок сдачи, нельзя взять книгу и почитать если в черном списке(рейтинг=0)

CREATE OR REPLACE VIEW AVAILABLE_BOOKS_FOR_CLIENT AS       
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
        AND B.AGE_LIMIT < (
            SELECT 
                AGE 
            FROM CLIENT C 
            WHERE C.FIRST_NAME = 'Олеся' 
                AND C.LAST_NAME = 'Осипова'
                AND C.RATING <> 0)
    GROUP BY TITLE, PUBLISHER, STORE;      

-- SELECT  
--     * 
-- FROM AVAILABLE_BOOKS_FOR_CLIENT
-- WHERE TITLE = 'Понедельник начинается в субботу'

