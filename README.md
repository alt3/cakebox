[![Documentation Status](https://readthedocs.org/projects/cakebox/badge)](https://cakebox.readthedocs.org)

# Cakebox

Homestead on Steroids!

## Requirements

+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 4.0 or higher
+ [Vagrant](https://www.vagrantup.com/downloads.htmlhttps://www.virtualbox.org/wiki/Downloads) 6.0 or higher

## Installation

```bash
git clone https://github.com/alt3/cakebox.git
cd cakebox
vagrant up
```

> **Note:** the initial download of the (~2GB) box image could take some time
> so please be patient.

Once provisioning has completed you are ready to:

- [Create your first website](http://cakebox.readthedocs.org/en/latest/tutorials/creating-your-first-website/).
- Login to your Virtual Machine using the ``vagrant ssh`` command
- Login to your Cakebox Dashboard by browsing to [https://10.33.10.10](https://10.33.10.10)

> **Note:** accept the
> [certificate warning](http://cakebox.readthedocs.org/en/latest/known-limitations/#dashboard-certificate-warning)
> shown when browsing to the Cakebox Dashboard.

## Documentation

Full documentation [found here](http://cakebox.readthedocs.org/en/latest/).


## Features

### Command Line Provisioning

Provision applications, databases and virtual hosts directly from the command
line:

```bash
# Automatically configured framework skeleton applications
$ cakebox application add mycake3.app
$ cakebox application add mycake2.app --majorversion 2
$ cakebox application add mylaravel.app --framework laravel

# Git and Composer applications (both public and private)
$ cakebox application add mypublic.app --source http://github.com/your-name/repository
$ cakebox application add myprivate.app --source git@github.com:your-name/repository.git
$ cakebox application add myyii.app --source yiisoft/yii2-app-basic

# Databases and virtual hosts
$ cakebox database add holiday2015
$ cakebox site add idea.com /var/www/some-idea
```

### Management Dashboard

Comes with a dashboard for your convenience.

![Cakebox Dashboard](docs/sources/img/cakebox-dashboard.png)
