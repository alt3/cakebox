#!/usr/bin/env bash

# Vagrant provisioning feedback
echo "Please wait... installing cakebox console"

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
git clone "$REPOSITORY" "$TARGET_DIR" --quiet

# Round up by Composer installing
echo "* Composer installing"
cd "$TARGET_DIR"
composer install --prefer-dist --no-dev > /dev/null

# Provisioning feedback
echo "* Cakebox console installed successfully!"
