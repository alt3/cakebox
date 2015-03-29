# Introduction

Your box comes with the following database servers:

+ [Percona MySQL](http://www.percona.com/software/percona-server/)
+ [PostgreSQL](http://www.postgresql.org/)
+ [MongoDB](https://www.mongodb.org/)

> **Note:** the Cakebox Commands only support MySQL at this moment.

## Connection From Local Machine

To connect to the MySQL service from your local machine:

+ start your local MySQL client tool
+ make a connection to ``10.33.10.10:3306`` or ``cakebox:3306``
+ log in with user ``vagrant`` and password ``vagrant``

> **Note:** you might consider using
>  [Sequel Pro](https://github.com/sequelpro/sequelpro),
> [MySQL Workbench](http://dev.mysql.com/downloads/workbench/)
> or [phpMyAdmin](http://www.phpmyadmin.net/).

## Connection Inside Virtual Machine

To connect to the MySQL service from within your box use the ``mysql`` command
with either:

+ the ``root`` user with password ``secret`` (access to all databases)
+ the ``cakebox`` user with password ``secret`` (per-database access)
+ the user and password specified while creating the database

Command line examples:

```bash
mysql -u root -p
mysql -u cakebox -p
mysql -u my-user -p
```

## Installing phpMyAdmin

These instructions provide you with two easy methods to
add [phpMyAdmin](http://www.phpmyadmin.net/home_page/index.php) to your box using:

+ **Command Line**: non-persistent manual installation
+ **Cakebox.yaml**: persistent provisioned installation

> **Note:** just replace ``cakebox.phpmyadmin`` if you prefer a different url.

### Command Line

1. On your local machine update your [hosts file](usage/hosts-file/) to include
``10.33.10.10    cakebox.phpmyadmin``
2. Inside your box run ``cakebox package add phpmyadmin``
3. Inside your box run ``cakebox vhost add cakebox.phpmyadmin /usr/share/phpmyadmin``
4. On your local machine browse to ``http://cakebox.phpmyadmin``
5. Log in with user ``root`` and password ``secret``

### Cakebox.yaml

Update the [Cakebox.yaml](usage/cakebox-yaml/) file on your local machine to
include:

```yaml
vhosts:
  - url: cakebox.phpmyadmin
    webroot: /usr/share/phpmyadmin

extra:
  - apt_packages:
    - phpmyadmin
```

On your local machine:

1. Update your [hosts file](usage/hosts-file/) to include
``10.33.10.10    cakebox.phpmyadmin``
2. Apply the changes by running ``vagrant reload --provision``
3. Browse to ``http://cakebox.phpmyadmin``
4. Log in with user ``root`` and password ``secret``
