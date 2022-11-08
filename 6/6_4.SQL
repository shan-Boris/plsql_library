-- Найти ТОП 5 самых популярных книг (по кол-ву выдачи)

SELECT *
FROM (
    SELECT 
        TITLE, 
        COUNT(B.ID) AS "Выдано раз",
        RANK() OVER (ORDER BY (COUNT(B.ID)) DESC) AS rank
    FROM BOOK B 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON (B.ID = DRB.ID_BOOK)
    GROUP BY TITLE)
WHERE rank <= 5;
