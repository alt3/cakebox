
## Requirements


+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads) version 4.0 or higher
+ [Vagrant](https://www.vagrantup.com/downloads.htmlhttps://www.virtualbox.org/wiki/Downloads) version 6.0 or higher

> **Windows users** also need [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html),
> Pageant and the [Git Bash](http://git-scm.com/downloads) to unlock all functionality.

## Installation

```bash
git clone git@github.com:alt3/cakebox.git
```

## Launching your box

Start your box for the first time. Once provisioning has
completed either login using SSH or visit the Cakebox Dashboard at
``https://10.33.10.10``.

```bash
cd cakebox
vagrant up
```

> **Note:** the initial download of the (~2GB) box image could take some time
> so please be patient.

## Next steps

Now that your box is up-and-running make sure to:

+ take a good look at the ``Cakebox.yaml`` file (described [here](configuration/cakebox-yaml.md))
+ experiment with the ``cakebox`` shell commands
+ check the credentials page for usernames and passwords (described [here](additional/credentials.md))
