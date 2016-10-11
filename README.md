# QueryingInTheRealWorld
Database II: Querying in the Real World

## Setup

We will use [Docker]() to create a development environment by utilizing [docker-compose](https://docs.docker.com/compose/wordpress/). The provided `docker-compose.yml` file specifies all the necessary software and data that needs to be installed for this workshop. The installed software includes a web server with [Wordpress](https://wordpress.org/) and [PHPMyAdmin](https://www.phpmyadmin.net/) and a database server with [MariaDB](https://mariadb.org/), a fully compatible replacemend for [MySQL](http://www.mysql.com/). The Docker installation will create a database with the name `qitrw`, populated with [sample data](https://github.com/poststatus/wptest).

## The Wordpress Database Schema

The [initial database](https://codex.wordpress.org/Database_Description) created by a Wordpress install...

![](https://codex.wordpress.org/images/2/25/WP4.4.2-ERD.png)

