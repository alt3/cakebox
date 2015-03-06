# Introduction

SSH Agent Forwarding allows your box to use SSH keys stored on your local
machine (without having to copy them to your box). This complies with
[security best practices](http://rabexc.org/posts/pitfalls-of-ssh-agents) and
provides you with the best protection available because your private keys will
NEVER leave your local machine.

Summarized:

1. you load a local private key into SSH agent client software on
your local machine
2. the SSH agent on your local machine makes a connection to the box
3. SSH commands on your box can now use loaded keys by querying the
the SSH agent on your local machine

## Using Native SSH

Native SSH agents are only available on Mac, Linux and the Git Bash.

Load one or more private keys by running this on your local machine:

```bash
eval `ssh-agent`
ssh-add ~/.ssh/cakebox_rsa
ssh-add ~/.ssh/github_rsa
```
To verify your keys are loaded locally run ``ssh-add -l`` which should
produce something similar to:

    2048 23:ef:f9:f1:b9:23:0d:9c:56:1c:72:39:c1:6f:43:f3 /home/your-name/.ssh/cakebox_rsa (RSA)
    2048 bc:6d:83:64:g7:55:68:95:e7:2f:b3:50:22:5f:b4:2d /home/your-name/.ssh/github_rsa (RSA)

If forwarding is working running ``ssh-add -l`` on your box should list the
same fingerprints.

> **Note:** on Windows agent forwarding using the Git Bash can ONLY be used for
> the private key used to authenticate you during login. All other keys MUST be
> forwarded using Pageant.

## Using Pageant (Windows)

Windows users [MUST](https://github.com/net-ssh/net-ssh/commit/bd61eeab4927e9a68a5217ad9d8c04a99156efb2)
use Pageant to use SSH Agent Forwarding in remote connections (e.g. for git
cloning private repositories).

Since Pageant uses the same codebase as Putty it only handles ``*.ppk`` files
which means you will have to generate (or convert) a key pair using Putty first
as described here.

To load your private key into the Pageant client on your local machine:

1. Start Pageant
2. Press Add Key and browse to the .ppk file you want forwarded
3. Enter the passphrase used to generate the key (if applicable)
4. You should now see the fingerprint of your key in Pageant Key List

![Pageant Key List](img/pageant-key-list.png)

If forwarding is working running ``ssh-add -l`` on your box should list the
same fingerprints.
