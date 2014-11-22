#!/usr/bin/env bash

# Vagrant provisioning feedback
echo "Please wait... installing cakebox console"

# Convenience variables
REPOSITORY="git@github.com:alt3/cakebox-console.git"
TARGET_DIR="/cakebox/console"

# Verify the directory is empty or non-existent before git cloning
if [ -d "$TARGET_DIR" ]; then
	if [ "$( find $TARGET_DIR -mindepth 1 -maxdepth 1 | wc -l )" -ne 0 ]; then
		echo "* Skipping: installation directory not empty"
		exit 0
	fi
fi

# Clone the repo.
git clone $REPOSITORY $TARGET_DIR

# Round up by Composer installing
cd /cakebox/console
composer install --prefer-dist
echo "* cakebox console installed successfully!"
