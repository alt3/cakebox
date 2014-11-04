Cakebox
=======

One Box, All Cakes.

# Notes

- filemode caching will log everything (including errors() to /var/log/app ==> not recommended, better use Redis or Memcached

# TODO

### General

- warn if no Cakebox.yaml is found? (load default settings first?)
- set correct permissions on generated sites (tmp, vagrant?!?)
- remove existing sites, databases, apps?
- enable aliases (serve-database)
- add bash colouring scheme?

### serve-site


### serve-database

- enable
- add optional username parameter
- add optional password parameter

### serve-app

- make idempotent: only run composer if the app is not present yet
