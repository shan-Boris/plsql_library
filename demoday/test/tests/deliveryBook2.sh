RESULT=$(node js/deliveryBook.js)
OUT='Уже такую книгу взял
Нельзя выдать книгу'
diff <(echo "$RESULT") <(echo "$OUT")