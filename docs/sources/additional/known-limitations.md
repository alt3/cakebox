
## Clear text passwords

When your box is protected with a personal ssh key pair you might see the
following message when starting your box:

    Text will be echoed in the clear. Please install the HighLine or Termios libraries to suppress echoed text.

Load the private key of your generated ssh pair and try again.

```bash
ssh-add -l /path/to/your/private/key
```

## Slow shared folders

Placeholder
