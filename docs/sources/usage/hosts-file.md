# Introduction

The webserver inside your virtual machine depends on valid records in the
``hosts`` file on your local machine to determine which application/URL to
serve. Please note that:

+ these records are **not inserted automatically**, you will have to add them manually
+ all cakebox related entries use the same IP address.

## Cakebox Record

You are strongly advised to create a record in your local hosts file that
corresponds to the hostname specified in your ``Cakebox.yaml`` file. This way
you will be able to connect to your box by name.

```
10.33.10.10  cakebox
```

> **Note:** just replace cakebox if you are using a different hostname.

## Adding Records

Add new records by opening the ``hosts`` file on your local machine for editing:

- On Mac OS-X systems: ``/private/etc/hosts``
- On Linux systems: ``/etc/hosts``
- On Windows systems: ``c:\windows\system32\drivers\etc\hosts``

> **Note:** Windows users MUST run Notepad as an Administrator (right
> mouse button on c:\windows\notepad.exe) and then use the File > Open menu
> options to open the hosts file or they won't be able to save the updated file.

Now either add a single record per line:

```
10.33.10.10  cakebox
10.33.10.10  mycake2.app
10.33.10.10  mycake3.app
```

Or use multiple records per line:

```
10.33.10.10    cakebox        mycake2.app    mycake3.app
10.33.10.10    mylaravel.app  my-other.app   etc.app
```

## Testing Records

You might want to test if your hosts file update was
successful by running ``ping your-new-record`` on your local machine. On Mac/Linux
the output should look similar to:

```
PING my-new-record (10.33.10.10) 56(84) bytes of data.
64 bytes from my-new-record (10.33.10.10): icmp_seq=1 ttl=64 time=0.016 ms
64 bytes from my-new-record (10.33.10.10): icmp_seq=2 ttl=64 time=0.022 ms
64 bytes from my-new-record (10.33.10.10): icmp_seq=3 ttl=64 time=0.022 ms
```

On Windows it should look like this:

```
Pinging my-new-record [10.33.10.10] with 32 bytes of data:
Reply from 10.33.10.10: bytes=32 time=1ms TTL=64
Reply from 10.33.10.10: bytes=32 time<1ms TTL=64
Reply from 10.33.10.10: bytes=32 time<1ms TTL=64
```
