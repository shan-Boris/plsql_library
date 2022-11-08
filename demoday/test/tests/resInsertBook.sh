RESULT=$(node js/resInsertBook.js)
if [ $RESULT -ge 33 ]
then
exit 0
else
exit 1
fi