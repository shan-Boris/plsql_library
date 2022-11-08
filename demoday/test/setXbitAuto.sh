for file in tests/*
    do
    isFileUntracked=$(git status $file | grep "Untracked files" | wc -l)

    if [ $isFileUntracked -eq 1 ]
    then
        echo "$file"
        git add $file
        git update-index --chmod=+x $file
        git commit -m"add new $file"
        git push
    fi

    done