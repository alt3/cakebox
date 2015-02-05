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

Why call it insecure? Anybody using this (known to the world) key can make
a passwordless connection to your box and be granted root access, no questions
asked.

> **Note:** obviously this is only a problem if there is (network) access
> to your box

## Secure Connection


## Using Vagrant SSH



## Using Putty



## Using Native SSH

Mac/Linux only.

## SSH Agent Forwarding
