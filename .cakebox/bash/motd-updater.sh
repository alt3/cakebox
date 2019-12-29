#!/usr/bin/env bash

MOTD_TEMPLATE="/cakebox/templates/motd-20-cakebox-banner"
MOTD_TARGET="/etc/update-motd.d/20-cakebox-banner"

printf %63s |tr " " "-"
printf '\n'
printf "Updating motd\n"
printf %63s |tr " " "-"
printf '\n'

# Do nothing if template and target are identical
if cmp -s "$MOTD_TEMPLATE" "$MOTD_TARGET" ; then
	echo "* Skipping: motd is already up-to-date"
	exit 0
fi

# Replace existing motd with template
echo "* Replacing motd"
OUTPUT=$(cp "$MOTD_TEMPLATE" "$MOTD_TARGET")
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: non-zero cp exit code ($EXITCODE)"
	exit 1
fi

# Update motd
echo "* Effectuating new motd"
run-parts /etc/update-motd.d/

# Provisioning feedback
echo "MOTD update completed successfully!"
