#!/usr/bin/env bash

EXECUTABLE="/usr/local/bin/multibackup"
CONFIG_LOCAL="/cakebox/.multibackup.conf"
CONFIG_BOX="/home/vagrant/.multibackup.conf"
CRON_FILE="/etc/cron.d/backup-liveconfig"

printf %63s |tr " " "-"
printf '\n'
printf "Checking automated backups\n"
printf %63s |tr " " "-"
printf '\n'

# Do nothing if the multibackup executable already exists
if [ -f "$EXECUTABLE" ]; then
	echo "* Skipping: multibackup executable already exists"
	exit 0
fi

# Install tar-multibackup as described at https://github.com/frdmn/tar-multibackup
echo "* Installing multibackup"
cd /usr/local/src
git clone https://github.com/frdmn/tar-multibackup.git
ln -sf /usr/local/src/tar-multibackup/multibackup /usr/local/bin/multibackup

# Upload cakebox-specific config file that will backup:
# - nginx sites
# - nginx conf files
# - last known uploaded files
# - all databases (percona/mysql hot backup)
echo "* Placing default configuration file"
OUTPUT=$(cp "$CONFIG_LOCAL" "$CONFIG_BOX")
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: non-zero cp exit code ($EXITCODE)"
	exit 1
fi

# Set file permissions on config file to vagrant user
echo "* Setting configuration file permissions"
OUTPUT=$(sudo chown vagrant:vagrant "$CONFIG_BOX" -R 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: non-zero chown exit code ($EXITCODE)"
	exit 1
fi

# Create daily cron (runs at 5:00 AM)
echo "* Creating daily cron job"
echo '0 5 * * *        root        CONFIG=/home/vagrant/.multibackup.conf /usr/local/bin/multibackup &>/dev/null' > "$CRON_FILE"

# Provisioning feedback
echo "Installation completed successfully!"
