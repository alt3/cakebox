# Introduction

The webserver inside your virtual machine depends on valid entries in the
``hosts`` file on your local machine to determine which application/URL to serve.
These entries are **not inserted automatically**, you will have
to add them manually.

> **Note:** all cakebox related entries will use the same IP address.

## Adding Entries

Add new entries by editing the ``hosts`` file on your local machine:

- On Mac OS-X systems: ``/private/etc/hosts``
- On Linux systems: ``/etc/hosts``
- On Windows systems: ``c:\windows\system32\drivers\etc\hosts``

> **Note:** Windows users MUST run Notepad as an Administrator (right
> mouse button on c:\windows\notepad.exe) and then use the File > Open menu
> options to open the hosts file or they won't be able to save the updated file.

## Examples

Single entry per line:

```
10.33.10.10  cakebox
10.33.10.10  mycake2.app
10.33.10.10  mycake3.app
```

Multiple entries per line:

```
10.33.10.10    cakebox        mycake2.app    mycake3.app
10.33.10.10    mylaravel.app  my-other.app   etc.app
```
