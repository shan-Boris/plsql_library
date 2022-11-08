RESULT=$(node js/returnBook.js)
diff <(echo "$RESULT") <(echo "$RESULT" | awk '/^Приключения Тома Сойера возвращена, экземпляр №[0-9]{0,4}$/{print $0}')
