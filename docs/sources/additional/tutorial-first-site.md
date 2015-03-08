# Introduction

Follow these instructions to create your first website:

- using a fresh copy of CakePHP 3.x
- called ``mycake3.app``
- with Nginx virtual host
- with two databases (one for testing purposes)

## 1. Login to your Virtual Machine

Make sure that you are in the ``cakebox`` folder on your local machine before
running:

```bash
vagrant ssh
```

## 2. Provision the website

Inside your Virtual Machine run:

```bash
cakebox application add mycake3.app
```

## 3. Update your hosts file

Open the ``hosts`` file on your local machine so you can tell your
local system where to find the new website:

- On Mac OS-X systems: ``/private/etc/hosts``
- On Linux systems: ``/etc/hosts``
- On Windows systems: ``c:\windows\system32\drivers\etc\hosts``

> **Note:** Windows users MUST run Notepad as an Administrator (right
> mouse button on c:\windows\notepad.exe) and then use the File > Open menu
> options to open the hosts file or they won't be able to save the updated file.

Add the following line and save the updated file.

```
10.33.10.10     mycake3.app
```

You might want to test if your update was
successful by running ``ping mycake3.app`` on your local machine. On Mac/Linux
the output should look similar to:

```
PING mycake3.app (10.33.10.10) 56(84) bytes of data.
64 bytes from mycake3.app (10.33.10.10): icmp_seq=1 ttl=64 time=0.016 ms
64 bytes from mycake3.app (10.33.10.10): icmp_seq=2 ttl=64 time=0.022 ms
64 bytes from mycake3.app (10.33.10.10): icmp_seq=3 ttl=64 time=0.022 ms
```

On Windows it should look like this:

```
Pinging mycake3.app [10.33.10.10] with 32 bytes of data:
Reply from 10.33.10.10: bytes=32 time=1ms TTL=64
Reply from 10.33.10.10: bytes=32 time<1ms TTL=64
Reply from 10.33.10.10: bytes=32 time<1ms TTL=64
```

## 4. Done!

That's all there's to it. You can now open the browser on your local system and
browse to ``http://mycake3.app``. If things went well you should see something
similar to this:

![Cakebox Overview](img/fresh-install-cake3.png)

## Editing Code

You can use the editor on your local machine to update the (php) source files
used by the new website.

Just take a look inside the ``cakebox/Apps``
folder on your local machine. If things went well you should see a subfolder
named ``mycake3.app`` containing all source files. Launch your local editor and
make some changes.

Changes to local files are automatically synchronized to your box so if you
refresh the web page you should see your changes applied.

## Closing Note

Remember that you can provision as many applications as you like. They will all
run parallel inside your box so feel free to create another website to get
comfortable with the process.

Run ``cakebox application add --help`` to display a list of supported options
if you want to provision a different website variation.
