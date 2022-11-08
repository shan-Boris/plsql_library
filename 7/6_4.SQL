-- Найти ТОП 5 самых популярных книг (по кол-ву выдачи)

SELECT 
    * 
FROM TOP_BOOKS
WHERE rank <= 5;