# Authentication

Your box uses one of two authentication methods to secure SSH logins to your box:

+ [Insecure Authentication](#insecure-authentication): using the **very** insecure Vagrant ssh key pair (default)

+ [Secure Authentication](#secure-authentication): using a self-generated ssh key pair

> **Note:** SSH password authentication has been disabled to prevent password cracking

## Insecure Authentication

Your box is preconfigured to use the
[insecure Vagrant ssh key pair](https://github.com/mitchellh/vagrant/tree/master/keys)
for login authentication to provide you with convenient instant access to your
box. However, since anyone can use this publicly available key to make a
passwordless connection to your box and be granted root access this is highly
insecure and leaves your box open to the world.

> **Note:** obviously this will only be a problem if your box is (network)
> accessible

## Secure Authentication

Enabling secure SSH authentication is a simple two step process:

1. Generating a SSH authentication key pair ([described here](configuration/ssh-certificates/#creating-the-key-pair))
2. Enabling it in your Cakebox.yaml configuration file ([described here](configuration/cakebox-yml/#security))

## Using Vagrant SSH

If you don't want to use an external ssh client you can login to your box
directly from the command line using the native Vagrant
[ssh command](https://docs.vagrantup.com/v2/cli/ssh.html).

```bash
cd cakebox
vagrant ssh
```

## Using Native SSH

Native SSH is available on Mac, Linux and the Git Bash.

Login to your box by running this on your local machine:

```bash
ssh vagrant@10.33.10.10
```

> **Note:** SSH Agent forwarded keys will be detect automatically.

## Using Putty (Windows)

Windows users should use Putty to login to their box remotely as this
will ensure SSH Agent Forwarding will also functioning as expected.

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
