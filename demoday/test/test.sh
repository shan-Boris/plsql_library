testsIsFail=0
for file in tests/*.sh
do
    echo -n "$file "
    $file > /dev/null

    if [ $? -eq 0 ]
    then
        echo "SUCCESS"
    else
        echo "FAIL"
        testsIsFail=1
    fi

done

exit $testsIsFail