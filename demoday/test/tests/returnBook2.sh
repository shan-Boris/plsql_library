RESULT=$(node js/returnBook.js)
# echo "$RESULT"
OUT='Такую книгу не брал'
diff <(echo "$RESULT") <(echo "$OUT")