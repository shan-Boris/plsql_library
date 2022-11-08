-- Найти ТОП 5 самых читающих пользователей (за заданный период)
SELECT *
    FROM (
    SELECT 
        LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME AS CLIENT, 
        COUNT(C.ID) AS "Читал(a) раз",
        RANK() OVER (ORDER BY (COUNT(C.ID)) DESC) AS rank
    FROM CLIENT C 
        JOIN LOG_DELIVERY_RETURN_BOOK DRB 
            ON (C.ID = DRB.ID_CLIENT)
    WHERE DRB.TAKE_BOOK BETWEEN TO_DATE('2022/5/01', 'yyyy/mm/dd') AND TO_DATE('2022/8/01', 'yyyy/mm/dd')
    GROUP BY LAST_NAME||' '||FIRST_NAME||' '||FATHER_NAME)
WHERE rank <= 5;
