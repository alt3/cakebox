#!/usr/bin/env bash

# Convenience variables
PUBLIC_KEY_PATH=$1
AUTHORIZED_KEYS=/home/vagrant/.ssh/authorized_keys

printf %63s |tr " " "-"
printf '\n'
printf "Hardening SSH Authentication\n"
printf %63s |tr " " "-"
printf '\n'

# Do nothing if custom public key is already present in authorized_keys
if diff "$AUTHORIZED_KEYS" "$PUBLIC_KEY_PATH" >/dev/null ; then
	echo "* Skipping: SSH logins already require your personal SSH key"
	exit 0
fi

# Still here, verify public key is valid before applying to prevent locking out user
echo "* Validating your public key"
OUTPUT=$(ssh-keygen -l -f "$PUBLIC_KEY_PATH" 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: your public key dit not pass validation, make sure it is in OpenSSH format"
	exit 1
fi

# add public key to authorized_keys
echo "* Enabling your public key"
cat "$PUBLIC_KEY_PATH" > "$AUTHORIZED_KEYS"

# Vagrant provisioning feedback
echo "* Awesome... SSH logins now require your personal SSH key"
