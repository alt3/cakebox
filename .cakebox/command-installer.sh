#!/usr/bin/env bash

# Vagrant provisioning feedback
echo "Installing cakebox command"

# Convenience variables
REPOSIORY="git@github.com:alt3/cakebox-command.git"
TARGET_DIR="/cakebox/command"

# Verify the directory is empty or non-existent before git cloning
if [ -d "$TARGET_DIR" ]; then
	if [ "$( find $TARGET_DIR -mindepth 1 -maxdepth 1 | wc -l )" -ne 0 ]; then
		echo "* Skipping: installation directory not empty"
		exit 0
	fi
fi

# Clone the repo.
git clone $REPOSIORY $TARGET_DIR

# Round up by Composer installing
cd /cakebox/command
composer install --prefer-dist
