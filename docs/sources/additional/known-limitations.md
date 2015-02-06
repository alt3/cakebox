
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

Placeholder
