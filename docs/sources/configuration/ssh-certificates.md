# Introduction

Since the internet is already filled with information about
[generating SSH key pairs](https://help.github.com/articles/generating-ssh-keys/)
this chapter will simply focus on generating a key pair to replace the
insecure vagrant box login authentication key.

## Generating the Key Pair

You will generate a 2048 bit RSA key pair ready to use for your box with:

- a private key named ``cakebox_rsa``
- a public key named ``cakebox_rsa.pub``

> **Note:** your box supports certificate passphrases and we strongly recommend
> using one!


```bash
cd ~/.ssh
ssh-keygen -t rsa -C cakebox-authentication
# enter file name 'cakebox_rsa'
# enter a passphrase
```

Now configure your box to use this new pair for
authentication by updating the ``security`` section in your ``Cakebox.yaml``
file ([described here](configuration/cakebox-yml/#security)).


## Windows Users

Windows users will need to convert the private authentication key to ``.ppk``
format or they won't be able to connect to their box using Putty.

1. Start Puttygen
2. Press Load to open the File Explorer
3. Change the dropdown to 'All files' and select your ``cakebox_rsa`` private key
4. Enter the passphrase used when creating the key pair
5. Change the Key Comment field to *cakebox-authentication*
6. Save the key as ``~/.ssh/cakebox_rsa.ppk`` by pressing Save Private Key
