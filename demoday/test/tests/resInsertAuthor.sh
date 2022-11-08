RESULT=$(node js/resInsertAuthor.js)
if [ $RESULT -ge 25 ]
then
exit 0
else
exit 1
fi