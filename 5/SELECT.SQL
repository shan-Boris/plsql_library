-- Информацию по всем пользователям зарегистрированных в системе;
SELECT * FROM CLIENT;

-- Информацию по всем пользователям относящихся к определенной возрастной группе;
SELECT * FROM CLIENT 
WHERE AGE BETWEEN 10 AND 20;

-- Информацию по конкретному пользователю;
SELECT * FROM CLIENT 
WHERE ID = 5;

-- Информацию по всем печатным материалам;
SELECT * FROM BOOK_TYPE;

-- Информацию по всем печатным материалам относящихся к определенному типу;
SELECT * FROM BOOK
WHERE ID_BOOK_TYPE = (
    SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга'
);

-- Информацию по конкретному печатному материалу;
SELECT * FROM BOOK 
WHERE ID = 15;

-- Информацию по всем жанрам отсортированных в алфавитном порядке;
SELECT * FROM GENRE  
ORDER BY LOWER(GENRE) ;

-- Информацию по всем существующим возрастным ограничениям отсортированных по возрасту в порядке возрастания;
SELECT DISTINCT AGE_LIMIT 
FROM BOOK ORDER BY AGE_LIMIT;

-- Вывести идентификаторы пользователей находящихся в черном списке.
SELECT ID FROM CLIENT
WHERE RATING = 0;

