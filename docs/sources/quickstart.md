
## Requirements


+ [VirtualBox](https://www.virtualbox.org/wiki/Downloads) version 4.0 or higher
+ [Vagrant](https://www.vagrantup.com/downloads.htmlhttps://www.virtualbox.org/wiki/Downloads) version 6.0 or higher

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

To give you a less abstract idea of what you've just launched.

![Cakebox Overview](img/cakebox-overview.png)

## What's next?

Your box is up-and-running so you're all good but you might want to:

+ take a good look at the ``Cakebox.yaml`` file (described [here](configuration/cakebox-yaml.md))
+ experiment with the ``cakebox`` shell commands
+ check the credentials page for usernames and passwords (described [here](additional/credentials.md))
