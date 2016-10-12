# Database Part 2: Querying In The Real World

Created and presented by Tahir Butt <tahir.butt@gmail.com> on October 13, 2016.

## Motivation: Pay attention to the database behind the curtain

[![](https://img.youtube.com/vi/-RQxD4Ff7dY/0.jpg)](https://www.youtube.com/watch?v=-RQxD4Ff7dY)

In this workshop, we will channel the spirit of [Toto](https://en.wikipedia.org/wiki/Terry_(dog)), the dog from the much beloved [The Wizard of Oz](https://en.wikipedia.org/wiki/The_Wizard_of_Oz_(1939_film)) when he pulls back the curtain on the "Great Oz" to reveal an elderly man operating a machine. When discovered, the unmasked wizard hopelessly instructs his visitors to "Pay no attention to that man behind the curtain!" 

Our task in this workshop is to do as Toto did before us, at least in the context of our computers. As you will learn through this workshop, the magic behind much of the software you use daily, often without considering the machines hidden from view, depend crucially on databases. Having pulled aside the curtain, we will begin to ask our computers questions we might not have previously been able to articulate, even to ourselves. The mechanics and logic you will learn in this workshop pertain to relational databases, one of many kinds of databases, though still the most important to many of our desktop and web applications. 

The guiding principle behind relational databases is simple, but powerful: they allow us to structure our data so as to avoid duplicating the same information. This is accomplished by organizing similar kinds of data into separate tables and by linking these tables together with relationships. The term *schema* refers to the collection of tables and relationships we create in a database. We could spend a whole workshop on how to create an efficient and robust database schema. Instead, we will take as a starting point the schemas used by popular software applications: Wordpress and Zotero. For now, the introduction provided by the first database workshop will be sufficient to get going. And like in the first workshop, we will communicate with relational databases by using a Structured Query Language (SQL). We will learn about the mechanics of selecting data from a single table as well as joining multiple tables in order to gather structured data together. We will also explore how to summarize the data we gather, a skill useful for creating reports and analyses of patterns in our data.

<!--
Ask better questions of databases. Experitise in the syntax is less important than the kind of questions we can ask once we appreciate the structure of a relational database. Make concrete our vague questions. Move from big thinking to the weeds.
-->

## Preparation

Participants in the workshop are asked to have completed the following steps on their own laptops before the workshop. If you have any difficulties, please arrive 15 minutes before the workshop so issues can be sorted out.

1. If you attended [the first database workshop](https://digitalfellows.commons.gc.cuny.edu/2016/04/08/fun-times-with-sqlite-or-a-beginners-tutorial-to-data-management-and-databases-with-sql/) you will have already installed SQLiteStudio. For those who did not, you will want to download and install [SQLiteStudio](http://sqlitestudio.pl/?act=download).
2. If you are not already an active Zotero user, download [Zotero Standalone](https://www.zotero.org/download/), create a new account, begin adding some books and articles you have read or cited recently. If you are an EndNote user, you can easily [import into Zotero](https://www.zotero.org/support/kb/importing_records_from_endnote) your records.
3. Optional: If you are comfortable with the command line, ports, and AWS, then you can try out the steps in the optional section at the end of this document. In preparation for that, download [Docker for Windows](https://download.docker.com/win/stable/InstallDocker.msi) or [Docker for Mac](https://download.docker.com/mac/stable/Docker.dmg) and follow the steps for installing on [Windows](https://docs.docker.com/docker-for-windows/#/step-1-install-docker-for-windows) or on [Mac](https://docs.docker.com/docker-for-mac/#/step-1-install-and-run-docker-for-mac). Also, download the [QueryingInTheRealWorld](https://github.com/GCDigitalFellows/QueryingInTheRealWorld) repository.
4. And remember: bring your laptop.

If you are interested in the optional step, great! If not, no sweat! We will have a shared Wordpress server for the workshop that anyone who does not want to follow the optional step will be able to use.

## Wordpress Database

The following diagram is a simplified representation of the components of a Wordpress server:

![](wordpress-server-diagram.png)

The blue colored clients represent the normal interaction we will have had with a Wordpress server. We communicate with the Wordpress web server (a combination of Apache and PHP) using our web browsers. If we create a post or edit a category, those and any other changes are made by updating a MySQL database that the Wordpress web server has access to. Today we will get to play the red colored client and connect directly to the database to ask questions we might not be readily able to from the Wordpress administration dashboard.

The [database](https://codex.wordpress.org/Database_Description) created by a fresh Wordpress install already has numerous tables that are connected through the use of the primary keys in each table. While the [full diagram](https://codex.wordpress.org/images/2/25/WP4.4.2-ERD.png) of the schema is useful for reference purposes, we will focus here on three tables: `wp_users`, `wp_posts`, and `wp_comments`. I have copied here the relevant statements, simplified for our purposes, from the `bootstrap/db/00-load.sql` in the workshop repository.

```sql
CREATE TABLE `wp_users` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `user_login` varchar(60) ... NOT NULL DEFAULT '',
  `user_pass` varchar(255) ... NOT NULL DEFAULT '',
  `user_nicename` varchar(50) ... NOT NULL DEFAULT '',
  `user_email` varchar(100) ... NOT NULL DEFAULT '',
  `user_url` varchar(100) ... NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) ... NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) ... NOT NULL DEFAULT ''
) ...;

CREATE TABLE `wp_posts` (
  `ID` bigint(20) UNSIGNED NOT NULL,
  `post_author` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext ... NOT NULL,
  `post_title` text ... NOT NULL,
  `post_excerpt` text ... NOT NULL,
  `post_status` varchar(20) ... NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) ... NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) ... NOT NULL DEFAULT 'open',
  `post_password` varchar(20) ... NOT NULL DEFAULT '',
  `post_name` varchar(200) ... NOT NULL DEFAULT '',
  `to_ping` text ... NOT NULL,
  `pinged` text ... NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext ... NOT NULL,
  `post_parent` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `guid` varchar(255) ... NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) ... NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) ... NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0'
) ...;

CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) UNSIGNED NOT NULL,
  `comment_post_ID` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `comment_author` tinytext ... NOT NULL,
  `comment_author_email` varchar(100) ... NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) ... NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) ... NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text ... NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT '0',
  `comment_approved` varchar(20) ... NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) ... NOT NULL DEFAULT '',
  `comment_type` varchar(20) ... NOT NULL DEFAULT '',
  `comment_parent` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0'
) ...;
```

Take note of the first column specified for each table. In each, we find an `ID` column that has the type `bigint(20)` (the `UNSIGNED` indicating that only positive numbers will be used) and which must always have a value (hence the use of `NOT NULL` without a default value, as is the case with other columns). Whenever a new record is added to any of these tables, a new ID is used so as to not conflict with an already existing record in the same table. The way databases prevent multiple records from having unique values for a column is through the use of "primary keys" and an "incrementing" number which in the case of a Wordpress database are specified by the following statements:

```sql
ALTER TABLE `wp_users`
  ADD PRIMARY KEY (`ID`),
  ...;

ALTER TABLE `wp_users`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

ALTER TABLE `wp_posts`
  ADD PRIMARY KEY (`ID`),
  ...;

ALTER TABLE `wp_posts`
  MODIFY `ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1265;

ALTER TABLE `wp_comments`
  ADD PRIMARY KEY (`comment_ID`),
  ...;

ALTER TABLE `wp_comments`
  MODIFY `comment_ID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
```

For now we can ignore the `ADD KEY` statements, which define the indexed columns of a database table. Instead, notice that after creating each table, each table is altered such that a `PRIMARY KEY` is added to each `ID` and that column is further modified to have the `AUTO_INCREMENT` option such that whenever a new record is added a new, unique value is inserted into the table. The primary keys are thus defined for `wp_users.ID`, `wp_posts.ID`, and `wp_comments.comment_ID`.

But you might have also noticed that `wp_posts` and `wp_comments` have other columns of type `bigint(20) UNSIGNED` but are not primary keys. Instead of primary keys, these other `_ID` columns enable our tables to relate to one another: `wp_posts.post_author` and `wp_comments.comment_author` contain the value of the appropriate `wp_users.ID` who created the post or comment; `wp_comments.comment_post_ID` contain the value of the appropriate `wp_post.ID` for which the comment was created.

Having mapped these relationships, we are now ready to ask questions of our data using SQL. If you are using your own Docker environment, open your web browser to [http://localhost:8080](http://localhost:8080) to load up the PHPMyAdmin web application. Connect using the following information:

![](phpmyadmin-login.png)

If you are not using your own Docker, replace `localhost` and `db` with the IP provided at the beginning of the workshop.

## Zotero Database

One of the first applications many of us install when we start graduate school is [Zotero](zotero.org). I use it pretty much every day, importing in articles and books I find through my research, annotating items as I read them, and exporting bibliographies for papers I write. Over time, I, like many others, have amassed a large Zotero library. 

Though hidden from plain sight, the Zotero application uses a database to store that library in an efficient and robust way. Without that database, it would be very easy to corrupt your library as made changes or a simple search for an author or a tag across our library would be painfully slow. Fortunately for someone familiar with querying databases, the Zotero database can be [accessed without much headache](https://www.zotero.org/support/dev/client_coding/direct_sqlite_database_access) since Zotero uses [SQLite](https://www.sqlite.org/), a popular open source database engine used on [pretty much any computer or phone](https://www.sqlite.org/mostdeployed.html) you use daily. 

But before we proceed, a warning: the [Zotero Client Data Model](https://www.zotero.org/support/dev/data_model) is quite complex. Don't get discourged. Like with Wordpress, we will focus on only a subset of the tables. And as before, for those interested, you can examine the [full Zotero data model](http://zomark.github.io/zotero-marc/schema/trunk/relationships.html) at your leisure. 

In order to pracipate in the Zotero workshop exercises, you need to locate your [Zotero data directory](https://www.zotero.org/support/zotero_data). Because I use Zotero Standalone on a Windows computer, mine is located in:

```
C:\Users\tahir\AppData\Roaming\Zotero\Zotero\Profiles\cud5bmqj.default\zotero
```

You can find your folder by using clicking 'Preferences' in the 'Tools' menu drop-down. From there, select 'Advanced', then the 'Files and Folders' tab. Click the 'Show Data Directory' button in the 'Data Directory Location' section. This will bring open Finder (on OS X) or File Explorer (on Windows) with the directory where the `zotero.sqlite` file is stored.

Once you have found your data directory, make a copy of the `zotero.sqlite` file and store it in another folder, like on your Desktop. This step is to avoid the possibility that in accessing the database we might change it unwittingly and create many hours of headaches for ourselves later. After this workshop, you can delete the copy in your Downloads directory safely.

We will focus on `items`, `itemData`, `fields`, and `itemDataValues`.

```sql
CREATE TABLE items (
    itemID INTEGER PRIMARY KEY,
    itemTypeID INT NOT NULL,
    dateAdded TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dateModified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    clientDateModified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    libraryID INT,
    key TEXT NOT NULL,
    UNIQUE (libraryID, key),
    FOREIGN KEY (libraryID) REFERENCES libraries(libraryID)
);
CREATE TABLE itemData (
    itemID INT,
    fieldID INT,
    valueID,
    PRIMARY KEY (itemID, fieldID),
    FOREIGN KEY (itemID) REFERENCES items(itemID) ON DELETE CASCADE,
    FOREIGN KEY (fieldID) REFERENCES fieldsCombined(fieldID),
    FOREIGN KEY (valueID) REFERENCES itemDataValues(valueID)
);
CREATE TABLE fields (
    fieldID INTEGER PRIMARY KEY,
    fieldName TEXT,
    fieldFormatID INT,
    FOREIGN KEY (fieldFormatID) REFERENCES fieldFormats(fieldFormatID)
);
CREATE TABLE itemDataValues (
    valueID INTEGER PRIMARY KEY,
    value UNIQUE
);
```

Unlike the Wordpress database, the relationships among tables are specified with `FOREIGN KEY (column) REFERENCES other_table(column)` in the Zotero database. The details of how relationships are implemented are not important for our purposes. However, the above statements to clearly establish how tables connect.

All you need to do now is start SQLiteStudio and create a new database connection for the copied sqlite file:

![](sqlitestudio-connection-example.png)

## Optional: Docker environment

The following instructions are for only those going ahead with the optional step. 

We use [Docker](http://www.docker.com/) to create our own Wordpress server. Docker is an amazing piece of software that simplifies running software like web servers and databases. In our case, Docker allows us to create a safe environment to play in without effecting the normal behavior of our own computers. 

The provided `docker-compose.yml` file for [docker-compose](https://docs.docker.com/compose/wordpress/) specifies all the necessary software and data that needs to be installed for this workshop. The installed software includes a web server with [Wordpress](https://wordpress.org/) and [PHPMyAdmin](https://www.phpmyadmin.net/) configured and links both to a [MySQL](http://www.mysql.com/) database server using [MariaDB](https://mariadb.org/), a fully compatible replacement for MySQL. The `docker-compose` command will also populate the `qitrw` database we will use for Wordpress with [sample data](https://github.com/poststatus/wptest) based on test data created for Wordpress theme and plugin developer.

In order to deploy the Docker environment, open a terminal, change directory to the workshop repository, and execute `docker-compose up -d`. This will download the necessary images and configure the environment. You can test it out by going to http://localhost/ in a web browser, which should bring up the Wordpress demo site. When you are done with playing with the environment, execute `docker-compose down` from the command line in the same directory as before. To completely clean up after yourself, also execute `docker volume rm $(docker volume ls -qf dangling=true)` to delete the disk volumes created by Docker for the services we deploy.

To deploy the environment to AWS, execute (exporting your AWS credentials first):

```
docker-machine create -d amazonec2 --amazonec2-access-key $AWS_ACCESS_KEY_ID  --amazonec2-secret-key $AWS_SECRET_ACCESS_KEY --amazonec2-region us-west-2 qitrw20161013
``` 

Then execute `docker-machine env qitrw20161013` for instructions on setting up Docker. In my case, on a Windows computer, I had to execute:

```
& docker-machine env qitrw20161013 | Invoke-Expression
```

On a Mac, you would execute:

```
eval $(docker-machine env qitrw20161013)
```

Open up the ports 8080 in order that anyone at the GC can access PHPMyAdmin running on that port:

```
aws ec2 authorize-security-group-ingress --group-id [SUBNET FOR qitrw20161013] --protocol tcp --port 8080 --cidr 146.96.0.0/16
```