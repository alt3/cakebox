## Alpha

We are currently in alpha so things may break. Help us improve by
[reporting problems](https://github.com/alt3/cakebox/issues).

## Requirements

+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 4.0 or higher
+ [Vagrant](https://www.vagrantup.com/downloads.html) 1.6.0 or higher
+ a machine with at least 4GB of memory and 2 CPUs

**Windows users**:

+ are strongly advised to use the
[Git Bash](http://git-scm.com/downloads) for documented commands
+ may need to [enable hardware virtualization](https://www.thomas-krenn.com/en/wiki/Activating_the_Intel_VT_Virtualization_Feature)
(VT-x)


## What do you get?

A 64-bit virtual machine running [Ubuntu 14.04.1 LTS](https://wiki.ubuntu.com/LTS)
with a lot of useful [software and features](features/).

## Installation

To launch your box for the first time:

```bash
git clone https://github.com/alt3/cakebox.git
cd cakebox
cp Cakebox.yaml.default Cakebox.yaml
vagrant up
```

> **Note:** the initial download of the (~2GB) box image could take some time
> so please be patient.

Once provisioning has completed you can:

- login to your Virtual Machine by using the ``vagrant ssh`` command
- login to your Cakebox Dashboard by browsing to ``http://10.33.10.10``

## What's next?

Now that your box is up-and-running you might consider:

+ [creating your first website](tutorials/creating-your-first-website)
+ [updating your hosts file](usage/hosts-file)
+ [checking the credentials page](additional/credentials) (for usernames and passwords)
+ [experimenting with the ``cakebox commands``](usage/cakebox-commands)
+ [customizing your cakebox](usage/cakebox-yaml)
+ [hardening box logins](tutorials/hardening-box-authentication)
+ [connecting your Github SSH key](tutorials/connecting-your-github-ssh-key) (so you can use private repositories)
