# Introduction

These instructions provide you with three different methods to
log in to your box using SSH.

## 1. Using The Vagrant SSH Client

Vagrant comes with it's own SSH client which allows you to log in to your box
directly from the command line without the need for any additional SSH client
software. To log in to your box make sure that you are in the ``cakebox`` root
folder on your local machine before running:

```bash
vagrant ssh
```

## 2. Using a Command Line SSH Client

To log in to your box using the SSH clients that come integrated with Mac, Linux
and the Git Bash run the following command anywhere on your local system:

```bash
ssh vagrant@10.33.10.10
```

> **Note:** if you have updated your local hosts file you can also run
> ``ssh vagrant@cakebox``
## 3. Using Putty (Windows)

Windows users are encouraged to use
[Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) as
their preferred SSH client as this will simplify their workflow and
guarantee that all cakebox functionality will function as expected.

> **Note:** Make sure that you have created the cakebox_rsa.ppk key as
> [described here](tutorials/hardening-box-authentication/#putty-users-windows).

To create a Putty connection configuration for your box:

1. Start Putty
2. Set hostname to IP address ``10.33.10.10`` (or ``cakebox`` if you have updated your hosts file)
3. Select Connection > Data and set ``vagrant`` as the auto-login username
4. Select Connection > SSH > Auth
5. Press Browse to select your ``cakebox_rsa.ppk`` file
6. Select Session
7. Press Save to save your configuration
8. Press Open to login to your box

> **Note:** Next time simply connect to your box by double clicking the connection.
