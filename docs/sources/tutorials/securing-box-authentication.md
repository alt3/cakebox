# Introduction

By default your box uses the SSH keys provided by Vagrant to secure
authentication/logins. If you would like to optimize login protection
you can follow these instructions to replace the Vagrant keys with your own
personal key pair.

## 1. Generate Your Key Pair

Run the following commands on your local machine to generate a 2048 bit RSA
key pair:

> **Note:** using a passphrase is optional but we strongly recommend
> using one!

```bash
cd ~/.ssh
ssh-keygen -t rsa -C cakebox-authentication
# enter file name 'cakebox_rsa'
# enter a passphrase
```

If things went well you should now have two files:

- a private key named ``cakebox_rsa``
- a public key named ``cakebox_rsa.pub``

## 2. Configure Your Box

Configure your box to use the new keys for all SSH
authentication requests by updating the ``security`` section in your
``Cakebox.yaml`` file. On Mac/Linux it should resemble:

```yaml
security:
  box_public_key: ~/.ssh/cakebox_rsa.pub
  box_private_key: ~/.ssh/cakebox_rsa
```

On Windows it should look similar to this:

```yaml
security:
  box_public_key: /Users/your-name/.ssh/cakebox_rsa.pub
  box_private_key: /Users/your-name/.ssh/cakebox_rsa
```

## 3. Enable Your Key Pair

Restart your box to start using the new key pair. Make 100% sure that the
paths specified in step 2 are correct before running this command or
you will lock yourself out of your box... forever!

```bash
vagrant reload --provision
```

If things went well you should:

- see the following message during startup: ``Replacing insecure Vagrant ssh key``
- be asked for your passphrase when logging in (if you
    chose to use a passprhrase in step 1)

## Putty Users (Windows)

Putty does not support the OpenSSH format. Therefore Putty users
MUST create a third key in ``.ppk`` format named ``cakebox_rsa.ppk``. This is done by converting
the private key generated in step 2.

1. Start [Puttygen](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
2. Press Load to open the File Explorer
3. Change the dropdown to 'All files' and select your ``cakebox_rsa`` private key
4. Enter the passphrase used when creating the key pair
5. Change the Key Comment field to *cakebox-authentication*
6. Save the key as ``~/.ssh/cakebox_rsa.ppk`` by pressing Save Private Key

You now have a .ppk key to be used in your Putty cakebox connection properties.
