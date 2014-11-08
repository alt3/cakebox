Cakebox
=======

One Box, All Cakes.

# Notes

- filemode caching will log everything (including errors() to /var/log/app ==> not recommended, better use Redis or Memcached

# TODO

### General

- .gitignore everything except...
- bug: use setfacl for cakephp2 and foc2 (and foc3) /tmp permissions
- bug: add ruby file-detector to Cakebox.yaml.examples
- foc: install suggested Search plugin
- new: warn if no Cakebox.yaml is found? (load default settings first?)
- new: long args so we can shorten cakebox-command (e.g. cakebox-app URL, everything else as argument)
- new: enable Vagrantfile.rb environment variables
- new: check -e Cakebox.yaml in Vagrantfile
- bug: foc3 template broken ==> looks in wrong dir for bootstrap.php (https://github.com/FriendsOfCake/app-template/issues/58)
- bug: cakephp3 test-database configuration uses prod-settings ==> depends on decent bash argument parsing
- bug: add vagrant to /var/log/nginx

### Maybe
- add bash colouring scheme?
- remote (Git hosted?) Cakebox.yaml

# DOCS
- describe vagrant_private_key.pkk
