# Cakebox

Homestead on Steroids!

Documentation [found here](https://cakebox.readthedocs.org/installation).

```bash
# Provision instant-up framework applications
$ cakebox application add cake3.app
$ cakebox application add cake2.app --majorversion 2
$ cakebox application add laravel.app --framework laravel

# Provision (pubic and private) git and composer applications
$ cakebox application add public.app --source http://github.com/your-name/repository
$ cakebox application add private.app --source git@github.com:your-name/repository.git
$ cakebox application add yii.app --source yiisoft/yii2-app-basic

# Provision databases and virtual hosts
$ cakebox database add holiday2015
$ cakebox site add idea.com /var/www/some-idea
```

![Cakebox Dashboard](docs/sources/img/cakebox-dashboard.png)
