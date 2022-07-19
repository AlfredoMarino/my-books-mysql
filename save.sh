#!/bin/bash

echo "****************************************************************************************"
echo "Script to save my-books data"
echo "Author: Alfredo Mariño"
echo "Date: 19/07/2022"
echo "****************************************************************************************"
echo

echo "****************************************************************************************"
echo "Finding my-books-database docker container..."
databaseContainerId=$(docker ps -qf "name=my-books-database")

if [ -z "$databaseContainerId" ]
then
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "my-books-database container not found!!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
else

    echo "Backup database from container" $databaseContainerId
    docker exec $databaseContainerId /usr/bin/mysqldump -u aamv --password=aamv --no-tablespaces --extended-insert=FALSE --add-drop-table mybooksdb > scripts/mybooksdb-backup.sql

    echo
    echo "****************************************************************************************"
    read -p "Set a git commit comment:" commitComment

    echo "git add ."
    git add .

    echo "git status"
    git status 

    echo "git commit -m '$commitComment'"
    git commit -m "$commitComment"

    echo "git push"
    git push

fi

