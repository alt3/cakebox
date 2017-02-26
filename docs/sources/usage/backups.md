# Introduction

Cakebox uses [multibackup](https://github.com/frdmn/tar-multibackup) to create daily
backups of critical box files which are then stored on your local machine for
safe keeping.

## Good to know

- backups can be found on your local machine in the `/.cakebox/backups` folder
- backup retention: 90 days
- to manually start the backup run `sudo multibackup` inside your box
- backups are created daily at 5:00 AM. To change:
  - edit `/etc/cron.d/backup-liveconfig` (visit [crontab guru](https://crontab.guru) for help)
  - reload cron by running `sudo service cron reload`

## Configuration

The default configuration file `/home/vagrant/.multibackup.conf` will backup:

- all `app.php` and `.env` configuration files found in /home/vagrant (recursively)
- the full database server with all databases (using [Percona Xtrabackup](https://www.percona.com/software/mysql-database/percona-xtrabackup))
- `/etc/nginx`
- `/home/vagrant/.cakebox`

Additional folders can be added to the backups by specifying them in the configuration file.