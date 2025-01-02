#!/bin/bash

echo "****************************************************************************************"
echo "Script to save my-books data"
echo "Author: Alfredo Mariño"
echo "Date: 19/07/2022"
echo "****************************************************************************************"
echo

echo "****************************************************************************************"
echo "Finding my-books-database Docker container..."

# Debugging line to check Docker status
echo "Checking Docker status..."
docker ps

# Get the container ID
databaseContainerId=$(docker ps -qf "name=my-books-database")

# Debugging line to check the container ID
if [ -z "$databaseContainerId" ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "ERROR: my-books-database container not found!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit 1
fi

echo "Container ID: $databaseContainerId"
echo

# Backup the database
echo "Creating database backup..."
backupFile="scripts/mybooksdb-backup.sql"
docker exec "$databaseContainerId" /usr/bin/mysqldump -u aamv --password=aamv \
    --no-tablespaces --extended-insert=FALSE --add-drop-table mybooksdb > "$backupFile"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create database backup."
    exit 1
fi

echo "Backup saved to $backupFile"
echo

# Show git differences
echo "Checking git changes..."
git diff

# Confirm if the user wants to proceed
read -p "Do you want to proceed with these changes? (y/n): " proceed
if [ "$proceed" != "y" ]; then
    echo "Aborting commit."
    exit 1
fi

# Commit changes
echo
echo "****************************************************************************************"
read -p "Enter a git commit comment: " commitComment

echo "Staging changes..."
git add .

echo "Checking git status..."
git status

echo "Committing changes..."
git commit -m "$commitComment"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to commit changes."
    exit 1
fi

echo "Pushing changes..."
git push

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to push changes."
    exit 1
fi

echo "****************************************************************************************"
echo "All done!"
