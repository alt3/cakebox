[![Documentation Status](https://readthedocs.org/projects/cakebox/badge)](https://cakebox.readthedocs.org)

# Cakebox

Homestead on Steroids!

```bash
# Instant-up framework applications
$ cakebox application add cake3.app
$ cakebox application add cake2.app --majorversion 2
$ cakebox application add laravel.app --framework laravel

# Public and private git/composer applications
$ cakebox application add public.app --source http://github.com/your-name/repository
$ cakebox application add private.app --source git@github.com:your-name/repository.git
$ cakebox application add yii.app --source yiisoft/yii2-app-basic

# Databases and virtual hosts
$ cakebox database add holiday2015
$ cakebox site add idea.com /var/www/some-idea
```
Comes with a dashboard for your convenience.

![Cakebox Dashboard](docs/sources/img/cakebox-dashboard.png)
