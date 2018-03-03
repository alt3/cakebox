#!/usr/bin/env bash

source /cakebox/bash/logger.sh

SCRIPTENTRY

# Convenience variables
KITCHEN_FILE="/cakebox/console/webroot/index.htm"
REPOSITORY="alt3/cakebox-console"
VERSION=$1
TARGET_DIR="/cakebox/console"
DIR_NAME="console"

# Remove /webroot/index.html used by test-kitchen if needed
if [ -f "$KITCHEN_FILE" ]; then
	echo "* Preparing installation directory"
	INFO "* Preparing installation directory"
	rm -rfv "$TARGET_DIR"/*
fi

# Assume application is already installed if the directory exists and isn't empty
if [ -d "$TARGET_DIR" ]; then
	if [ "$( find $TARGET_DIR -mindepth 1 -maxdepth 1 | wc -l )" -ne 0 ]; then
		exit 0
	fi
fi

# Vagrant provisioning feedback
printf %63s |tr " " "-"
printf '\n'
printf "Please wait... installing Cakebox Commands and Dashboard"
INFO "Please wait... installing Cakebox Commands and Dashboard"
printf %63s |tr " " "-"
printf '\n'

# Self-update Composer to prevent out-of-date error breaking installation
echo "* Self-updating Composer"
cd /cakebox
OUTPUT=$(sudo composer self-update 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	DEBUG $OUTPUT
	echo "FATAL: non-zero composer self-update exit code ($EXITCODE)"
	ERROR "FATAL: non-zero composer self-update exit code ($EXITCODE)"
	exit 1
fi

# Update composer cache permissions
echo "* Updating Composer cache permissions"
INFO "* Updating Composer cache permissions"
OUTPUT=$(sudo chown vagrant:vagrant /home/vagrant/.composer -R 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	DEBUG $OUTPUT
	echo "FATAL: non-zero chown exit code ($EXITCODE)"
	ERROR "FATAL: non-zero chown exit code ($EXITCODE)"
	exit 1
fi

# Create the project
echo "* Creating project"
INFO "* Creating project"
cd /cakebox
OUTPUT=$(composer create-project -sdev --no-install --keep-vcs --no-interaction "$REPOSITORY":"$VERSION" "$DIR_NAME" 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	DEBUG $OUTPUT
	echo "FATAL: non-zero composer create-project exit code ($EXITCODE)"
	ERROR "FATAL: non-zero composer create-project exit code ($EXITCODE)"
	exit 1
fi
cd "$DIR_NAME"

# Round up by Composer installing
echo "* Composer installing"
INFO "* Composer installing"
OUTPUT=$(composer install --prefer-dist --no-dev 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	DEBUG $OUTPUT
	echo "FATAL: non-zero composer install exit code ($EXITCODE)"
	ERROR "FATAL: non-zero composer install exit code ($EXITCODE)"
	exit 1
fi

# Enable console execution for Macs
chmod +x /cakebox/console/bin/cake

# Provisioning feedback
echo "Installation completed successfully!"
INFO "Installation completed successfully!"

SCRIPTEXIT