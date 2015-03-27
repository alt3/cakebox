
## Dashboard Certificate Warning

> **Note:** only applicabe if you have enabled https in your Cakebkox.yaml

When connecting to your Cakebox Dashboard using HTTPS your browser will warn
you that the SSL certificate can not be trusted. This is **expected behavior**
caused by the fact that we are using a self-signed certificate that your
browser cannot validate.

Until the mechanism to replace the default cakebox certificate is implemented
you can safely ignore the warning.

+ **Firefox**: press the ``Add Exception`` button, then press
``Confirm Security Exception``.
+ **Chrome**: press the ``Advanced`` link, then press
``Proceed to cakebox (unsafe)``
+ **Internet Explorer**: press the ``Continue to this website (not recommended)`` link.

## Clear text passwords

You might see the following message when connecting to your box.

> *Text will be echoed in the clear. Please install the HighLine or Termios libraries to suppress echoed text.*

This is [expected behavior](https://github.com/mitchellh/vagrant/issues/3122)
when:

- you have protected your box with a self-generated ssh key pair
- you are using Vagrant ssh to connect to your box
- your SSH Agent is not forwarding the private key of your self-generated key
pair

Either accept it or load your key into your SSH Agent.


## Slow shared folders

Placeholder for NFS / Rsync
