Cakebox
=======

One Box, All Cakes.

# Notes

- filemode caching will log everything (including errors() to /var/log/app ==> not recommended, better use Redis or Memcached

# TODO

### General

- IMPORTANT: install cakebox-command during provisioning (git clone + composer), install cakebox-command repo as vagrant once repo goes public
- new: enable Vagrantfile.rb environment variables
- bug: add ruby file-detector to Cakebox.yaml.examples
- new: warn if no Cakebox.yaml is found? (load default settings first?), == new: check -e Cakebox.yaml in Vagrantfile
- bug: cakephp3 test-database configuration uses prod-settings ==> depends on decent bash argument parsing
- new ReadTheDocs
- bug: foc3 template broken ==> looks in wrong dir for bootstrap.php (https://github.com/FriendsOfCake/app-template/issues/58)

### Maybe
- remote (Git hosted?) Cakebox.yaml

# DOCS
- describe vagrant_private_key.pkk
- keep your .yaml !
