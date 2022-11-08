RESULT=$(node js/createClient.js)
# echo "$RESULT"
OUT='Создан читательский билет на Имя Фамилия Отчество'
diff <(echo "$RESULT") <(echo "$OUT")