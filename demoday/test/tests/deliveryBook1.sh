RESULT=$(node js/deliveryBook.js)
# OUT='Приключения Тома Сойера выдана, экземпляр'
# diff <(echo "$RESULT") <(echo "$OUT")
diff <(echo "$RESULT") <(echo "$RESULT" | awk '/^Приключения Тома Сойера выдана, экземпляр №[0-9]{0,4}$/{print $0}')
