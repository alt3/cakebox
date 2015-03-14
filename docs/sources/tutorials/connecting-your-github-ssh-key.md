# Introduction

Follow these instructions to forward the Github SSH key on your local machine
to your box so you will be able to use (and provision) private Git
repositories inside your Virtual Machine.

## How It Works

SSH Agent Forwarding allows your box to use SSH keys stored on your local
machine (without having to copy them to your box). This complies with
[security best practices](http://rabexc.org/posts/pitfalls-of-ssh-agents) and
provides you with the best protection available because your private keys will
NEVER leave your local machine.

Summarized:

1. you load a local private key into SSH agent client software on
your local machine
2. the SSH agent on your local machine makes a connection to the box
3. SSH commands on your box can now use loaded keys by querying the
the SSH agent on your local machine

## 1. Load Your SSH Agent

Run these commands on your local machine to load one or more private keys into
your SSH agent:

```bash
eval `ssh-agent`
ssh-add ~/.ssh/cakebox_rsa
ssh-add ~/.ssh/github_rsa
```

## 2. Verify Forwarding

Run ``ssh-add -l`` on your local machine to verify the keys are actually loaded
into your local SSH agent. The result should resemble:

    2048 23:ef:f9:f1:b9:23:0d:9c:56:1c:72:39:c1:6f:43:f3 /home/your-name/.ssh/cakebox_rsa (RSA)
    2048 bc:6d:83:64:g7:55:68:95:e7:2f:b3:50:22:5f:b4:2d /home/your-name/.ssh/github_rsa (RSA)

Now run ``ssh-add -l`` inside your box. If your keys are successfully being
forwarded you will see the exact same fingerprints.

## 3. Test a Private Repository

To make sure everything is set up correctly git clone a private
repository using SSH by:

+ logging in to your Virtual Machine
+ running ``git clone git@github.com:your-name/your-repo.git``
+ using your Github passphrase if asked for

## Putty Users (Windows)

Windows users using Putty MUST use the
[Pageant SSH agent](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
if they want:

+ to have their Github key forwarded and available in their Putty connections
+ to provision private git repositories using the ``Cakebox.yaml`` file

> ** FYI:** provisioning private repositories on Windows without using Pageant
> is simply not possible due to this hard
> [coded limitation](https://github.com/net-ssh/net-ssh/commit/bd61eeab4927e9a68a5217ad9d8c04a99156efb2)
> in the Vagrant software.

> **Note:** because Pageant uses the same codebase as Putty it only handles
> ``.ppk`` files which means you will probably first have to convert your **Github
> key** to .ppk format using the same steps as
> [described here](tutorials/securing-box-authentication/#putty-users-windows)
> .

To load your local Github key into the Pageant SSH agent:

1. Start Pageant
2. Press Add Key and browse to your Github .ppk key
3. Enter your Github passphrase if needed
4. Verify that the fingerprint of your Github key is in the Pageant Key List:

![Pageant Key List](img/pageant-key-list.png)

To verify Putty forwarding is working as expected login to your box using Putty
and run ``ssh-add -l``.  It should list the exact same fingerprint.

> **Note:** because Pageant does not forward keys to existing Putty connections
> you might have to create a new Putty connection to see your key appear.
