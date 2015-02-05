# Introduction

Your box supports ssh logins using (only) one of the following SSH connection methods:

+ [Insecure Connections](#insecure-connections): using the **very** insecure Vagrant ssh key pair (default)

+ [Secure Connections](#secure-connections): using a self-generated ssh key pair

> **Note:** SSH password authentication is disabled to prevent password cracking

## Insecure Connections

Your box is preconfigured to use the
[insecure Vagrant ssh key pair](https://github.com/mitchellh/vagrant/tree/master/keys)
which gives you instant access to your box without first having to configure
your own pair.

Why is it called insecure? Anyone using this (known to the world) key can make
a passwordless connection to your box and be granted root access, no questions
asked.

> **Note:** obviously this is only a problem if your box is (network) accessible

## Secure Connections

@todo

## Using Vagrant SSH

If you don't want to use an external ssh client you can login to your box
directly from the command line using the native Vagrant
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

Windows users should use Putty to make remote connections to their box as this
will ensure that SSH Agent Forwarding will also function as expected.

### Connection Configuration

1. Start Putty
2. Set hostname ``cakebox`` or IP address ``10.33.10.10``
3. Select Connection > Data and set ``vagrant`` as the auto-login username
4. Select Connection > SSH > Auth
5. Press Browse to either select:
    - the insecure ``vagrant_private_key.ppk`` file (found in the cakebox root
folder)
    - your personally generated secure ``*.pkk`` file
6. Select Session and press Save to save your configuration
7. Press Open to login to your box
