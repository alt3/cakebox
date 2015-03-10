# Introduction

Placeholder for hosts file documentation.

+ cakebox will NOT automatically update your local hosts file
+ manually add the URL after provisioning a new application/website

Hosts file example corresponding to examples used in this documentation:

```
10.33.10.10    cakebox    mycake3.app
```

You might consider a multiline approach if your box hosts a lot of applications:

```
10.33.10.10    cakebox    mycake3.app
10.33.10.10    mylaravel.app     myother.app     etc.app
```

## Windows

Windows users MUST run their editor using Administrator credentials or they
won't be able to save the updated file. When using Notepad to update the hosts
file:

1. Right mouse click c:\windows\notepad.exe
2. Choose ``Run as administrator``
3. Use the File > Open menu options to browse to the hosts file
4. Update and save the file
