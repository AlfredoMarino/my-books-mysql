# MyBooksMySQL

![my-books-image](doc/my_books_logo.png)

This is the definition of the my-books-mysql image, which is the database of the My books project, a MySQL database with tables, and some preloaded data ready to be used by the other applications of the My books ecosystem.

If you want to make a backup of your database and include this data in the image, run this command and push to github

```sh
$ docker exec [CONTAINER ID] /usr/bin/mysqldump -u aamv --password=aamv --no-tablespaces --extended-insert=FALSE --add-drop-table mybooksdb > scripts/mybooksdb-backup.sql
```