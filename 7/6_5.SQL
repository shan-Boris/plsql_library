-- Найти ТОП 5 самых читающих пользователей (за заданный период)

SELECT 
    * 
FROM TOP_READERS
WHERE rank <= 5;
