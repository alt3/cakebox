## Beta

We are currently in beta so things may break. Help us fix them by
[reporting a problem](https://github.com/alt3/cakebox/issues).

> **Note:** untested on Mac/Linux, help wanted!

## Requirements


+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads) version 4.0 or higher
+ [Vagrant](https://www.vagrantup.com/downloads.htmlhttps://www.virtualbox.org/wiki/Downloads) version 6.0 or higher

## Windows users

Windows users need additional software to unlock all functionality:

+ [Git Bash](http://git-scm.com/downloads)
+ [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
+ [Pageant](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) (for private git repositories)

> **Note:** documented instructions assume you are using the Git Bash.

## Installation

```bash
git clone git@github.com:alt3/cakebox.git
```

## Launching your box

Run these commands to launch your box for the first time. Once provisioning has
finished either login to your box using SSH or visit the Cakebox Dashboard at
``https://10.33.10.10``.

```bash
cd cakebox
vagrant up
```

> **Note:** the initial download of the (~2GB) box image could take some time
> so please be patient.

## Box architecture

To give you a less abstract idea of what you've just launched:

![Cakebox Overview](img/cakebox-overview.png)

> **Note:** the Basebox Build Process is shown for completeness only.

## What's next?

Now that your box is up-and-running you might want to:

+ take a good look at the ``Cakebox.yaml`` file (described [here](configuration/cakebox-yaml.md))
+ experiment with the ``cakebox`` shell commands
+ check the credentials page for usernames and passwords (described [here](additional/credentials.md))
