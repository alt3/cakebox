#!/usr/bin/env bash

# Convenience variables
BRANCH=$1
KITCHEN_FILE="/cakebox/console/webroot/index.htm"
REPOSITORY="https://github.com/alt3/cakebox-console.git"
TARGET_DIR="/cakebox/console"

# Remove /webroot/index.html used by test-kitchen before git cloning the repository.
if [ -f $KITCHEN_FILE ]; then
	echo "* Preparing installation directory"
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
printf "Please wait... installing Cakebox Console and Dashboard"
printf %63s |tr " " "-"
printf '\n'

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
cd "$TARGET_DIR"

# Check out non-master branch
if [ "$BRANCH" != "master" ]; then
	echo "* Checking out $BRANCH branch"
	OUTPUT=$(git checkout "$BRANCH" 2>&1)
	EXITCODE=$?
	if [ "$EXITCODE" -ne 0 ]; then
		echo $OUTPUT
		echo "FATAL: non-zero git exit code ($EXITCODE)"
		exit 1
	fi
fi

# Round up by Composer installing
echo "* Composer installing"
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
