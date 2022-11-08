    ./test.sh 
    if [ $? -eq 0 ]
    then
        git add ../demoday.sql
        git commit -m"$1"
        git push
        echo "OK"
    else
        echo "FAIL"
    fi
