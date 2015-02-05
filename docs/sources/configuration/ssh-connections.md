# Introduction

To login to your box use one of the following SSH connection methods:

+ [Insecure Connection](#insecure-connection): using the **very** insecure Vagrant ssh key pair (default)

+ [Secure Connection](#secure-connection): using a self-generated ssh key pair

> **Note:** SSH password authentication is disabled to prevent password cracking

## Insecure Connection

Your box is preconfigured to use the
[insecure Vagrant ssh key pair](https://github.com/mitchellh/vagrant/tree/master/keys)
which gives you instant access to your box without first having to configure
your own pair.

Why call it insecure... anyone using this (known to the world) key can make
a passwordless connection to your box and be granted root access, no questions
asked.

> **Note:** obviously this is only a problem if your box is (network) accessible

## Secure Connection

@todo

## Using Vagrant SSH

If you don't want to use an (external) client you can login to your box from
the command line using the native Vagrant
[ssh command](https://docs.vagrantup.com/v2/cli/ssh.html).

```bash
cd cakebox
vagrant ssh
```

## Using Native SSH (Mac/Linux)

```bash
ssh vagrant@10.33.10.10
```

@todo: verify + secure keypair example

## Using Putty (Windows)

Windows users should use Putty for remote connections to their box as this will
ensure that SSH Agent Forwarding will also function as expected.

### Connection Configuration

1. Start Putty
2. Set hostname ``cakebox`` or IP address ``10.33.10.10``
3. Select Connection > Data and set ``vagrant`` as the auto-login username
4. Select Connection > SSH > Auth
5. Press Browse to either select:
    - the insecure ``vagrant_private_key.ppk`` file found
in the cakebox root folder
    - your personally generated secure ``*.pkk`` file
6. Select Session and press Save to save your configuration
7. Press Open to login to your box
