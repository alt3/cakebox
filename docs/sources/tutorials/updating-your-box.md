# Introduction

Follow these instructions to keep your box up-to-date.

## Self-Update

Your box comes with a built-in self-update mechanism that will update
your Cakebox Dashboard and Console (plus all underlying Composer
libraries) to the most recent version. To update your box run the
following command inside your Virtual Machine:

```bash
cakebox config update
```

It should produce output similar to:

```bash
$ Please wait... this can take a moment
$ Update completed successfully
```

## Virtual Machine Update

Your box uses a cakebox specific [pre-built](https://github.com/alt3/cakebox-builder)
Vagrant Virtual Machine box-image taking all the hard work out of
installing and correctly configuring software like
[Nginx, PHP and MySQL](features/#software).

Unfortunately, Vagrant does not provide a way to update the box-image
of an existing Virtual Machine which means that (optionally) upgrading
to a new cakebox-image will always:

+ require you to create a new/fresh cakebox Virtual Machine
+ lead to **losing all data and configuration** inside your existing
cakebox Virtual Machine

> **Note:** updates to the cakebox box-image will be kept to an absolute minimum.

The good news is that your box was designed with this limitation in mind so
you will be able to re-create an exact copy of your existing Virtual Machine
with all your applications, websites, databases and software as long as you:

+ have used the [Cakebox.yaml](usage/cakebox-yaml/) file to configure your box
+ manually export the MySQL databases in your existing box (will be implemented as a command)

To create a new Virtual Virtual Machine using the new box-image simply:

1. git clone a fresh copy of the cakebox project
2. replace the default Cakebox.yaml with your existing (rich filled) Cakebox.yaml
3. make sure your local SSH agent
[is forwarding your Github key](tutorials/connecting-your-github-ssh-key/)
if you have private Git repositories in your yaml
4. run ``vagrant up``
5. watch your box install and configure all the applications, databases,
and websites that existed on your old box
6. manually place the MySQL databases you have exported from your old box

That's all there's to it. You should now have a new box using
the same SSH keys as before with all websites and databases
up-and-running, exactly as they did on your old Virtual Machine.

> **Note:** please remember that only Cakebox.yaml provisioned entities
> will be re-created. You will obviously still lose your old logfiles,
> temporary files and anything you've changed manually.
