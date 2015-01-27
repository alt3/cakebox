## Feature list

+ Intuitive command line (re)provisioning of:
    - databases
    - virtual hosts
    - fully configured applications
+ Support for Git hosted applications (public and private)
+ Support for Composer installed applications
+ SSH security done right
+ Highly customizable, Vagrant aware settings
+ Pro tools like Elasticsearch and Logstash
+ Full functionality on Windows too (SSH, etc)
+ A web interface thrown in as a bonus


## Software

Your box runs a 64-bit version of [Ubuntu 14.04.1 LTS](https://wiki.ubuntu.com/LTS)
and comes with a bunch of useful software. Check the ``Virtual Machine`` section
of your Cakebox Dashboard for an actual list.

![Box Software](img/box-software.png)

### Cakebox Commands

Use [CakePHP 3 Console](http://book.cakephp.org/3.0/en/console-and-shells.html)
powered ``cakebox`` shell commands to deploy:

- databases
- websites
- fully configured (public and private) applications

![Cakebox Commands](img/cakebox-commands.png)

> **Pro tip!** These same commands are used by your ``Cakebox.yaml`` file allowing
> you to easily (re)create exact copies of your customized box if ever needed.

### Cakebox Dashboard

Because managing multiple applications just using the command line can soon
become a real bitch we have added a web interface for your conveniece.

![Cakebox Dashboard](img/cakebox-dashboard.png)
