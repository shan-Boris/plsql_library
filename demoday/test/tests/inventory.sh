RESULT=$(node js/inventory.js)
# echo "$RESULT"
OUT='Данные о поступлении в библиотеку и об утрате экземпляра 100
 
Название: 1984
Авторы: Джордж Оруэлл  
Издательство: Эксмо
Поступила: 14-OCT-22
Убыла: 
 
Данные о том когда и кто её брал и вернул
 '
diff <(echo "$RESULT") <(echo "$OUT")