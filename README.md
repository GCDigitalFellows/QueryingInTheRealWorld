# QueryingInTheRealWorld
Database II: Querying in the Real World

## Setup

We will use [Docker]() to create a development environment by utilizing [docker-compose](https://docs.docker.com/compose/wordpress/). The provided `docker-compose.yml` file specifies all the necessary software and data that needs to be installed for this workshop. The installed software includes a web server with [Wordpress](https://wordpress.org/) and [PHPMyAdmin](https://www.phpmyadmin.net/) and a database server with [MariaDB](https://mariadb.org/), a fully compatible replacemend for [MySQL](http://www.mysql.com/). The Docker installation will create a database with the name `qitrw`, populated with [sample data](https://github.com/poststatus/wptest).

## The Wordpress Database Schema

The [initial database](https://codex.wordpress.org/Database_Description) created by a Wordpress install...

![](https://codex.wordpress.org/images/2/25/WP4.4.2-ERD.png)


## The Zotero SQLite Database

One of the first applications I installed when I started graduate school was [Zotero](zotero.org). I use it pretty much every day, importing in articles and books I am finding through my research, annotating these items as I read them, and exporting bibliographies for papers I write. Over time, like many other graduate students, I have amassed a quite large Zotero library. Though hidden from plain sight, the Zotero application uses a database to store that library in an efficient and robust way. Without that database, it would be very easy to corrupt your library or a simple search for an author or a tag would be painfully slow. 

Fortunately for someone familiar with querying databases, we can access [the Zotero database without much headache](https://www.zotero.org/support/dev/client_coding/direct_sqlite_database_access) since Zotero uses [SQLite](https://www.sqlite.org/), a popular open source database engine used on [pretty much any computer or phone](https://www.sqlite.org/mostdeployed.html) you use daily.

The [Zotero Client Data Model](https://www.zotero.org/support/dev/data_model) is quite complex. We will focus on only a subset of the tables in this workshop. For those interested, you can examine the [full list of relationships](http://zomark.github.io/zotero-marc/schema/trunk/relationships.html) for the current data model.

In preparation for the workshop, first locate your [Zotero data directory](https://www.zotero.org/support/zotero_data). Because I use Zotero Standalone on a Windows computer, mine is located in:

```
C:\Users\tahir\AppData\Roaming\Zotero\Zotero\Profiles\cud5bmqj.default\zotero
```

Once you have found your data directory, make a copy of the `zotero.sqlite` file and store it in another folder, like on your Desktop. This is to avoid the possibility that in accessing the database we might change it unwittingly and create many hours of headaches for ourselves later.

If you attended [the first database workshop](https://digitalfellows.commons.gc.cuny.edu/2016/04/08/fun-times-with-sqlite-or-a-beginners-tutorial-to-data-management-and-databases-with-sql/) you will have already installed SQLiteStudio. For those who did not, you will want to [download SQLiteStudio](http://sqlitestudio.pl/?act=download) as we will use this application to access the Zotero SQLite database.