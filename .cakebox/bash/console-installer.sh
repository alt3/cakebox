#!/usr/bin/env bash

# Vagrant provisioning feedback
echo "Please wait... installing Cakebox console and dashboard"

# Convenience variables
KITCHEN_FILE="/cakebox/console/webroot/index.htm"
REPOSITORY="https://github.com/alt3/cakebox-console.git"
TARGET_DIR="/cakebox/console"

# Remove /webroot/index.html used by test-kitchen before git cloning the repository.
if [ -f $KITCHEN_FILE ]; then
	echo "* Preparing installation directory"
	rm -rfv "$TARGET_DIR"/*
fi

# Verify the directory is empty or non-existent before git cloning
if [ -d "$TARGET_DIR" ]; then
	if [ "$( find $TARGET_DIR -mindepth 1 -maxdepth 1 | wc -l )" -ne 0 ]; then
		echo "* Skipping: installation directory not empty"
		exit 0
	fi
fi

# Clone the repo.
echo "* Cloning repository"
cd /cakebox
OUTPUT=$(git clone "$REPOSITORY" "$TARGET_DIR" 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: non-zero git exit code ($EXITCODE)"
	exit 1
fi

# Round up by Composer installing
echo "* Composer installing"
cd "$TARGET_DIR"
OUTPUT=$(composer install --prefer-dist --no-dev 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: non-zero composer exit code ($EXITCODE)"
	exit 1
fi

# Enable console execution for Macs
chmod +x /cakebox/console/bin/cake

# Provisioning feedback
echo "* Installation completed successfully!"
