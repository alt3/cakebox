#!/usr/bin/env bash

# Check for required parameter
if [ -z "$1" ]; then
    echo "Error: missing required parameter."
    echo "Usage: "
    echo " cakebox-app name.domain"
    exit 1
fi

# Generate convenience variable
APP_DIR=/home/vagrant/Apps

# Vagrant provisioning feedback
echo "Creating Cake app $1"

# Generate the Nginx site configuration file
/cakebox/cakebox-site.sh $1 $APP_DIR/$1 || exit 1

# Create the MySQL database
/cakebox/cakebox-database.sh $1 || exit 1

# Install CakePHP 2 application using FriendsOfCake app-template
echo "Composer installing FriendsOfCake app-template"

# Only run composer if:
# - directory does not exist
# - directory does exist but is empty
if [ -d "$APP_DIR/$1" ]; then
  DIR_COUNT="$( find $APP_DIR/$1 -mindepth 1 -maxdepth 1 | wc -l )"
fi

if [ $DIR_COUNT != 0 ]; then
    echo " * Skipping: $APP_DIR/$1 is not empty"
  else
    su vagrant -c "composer --prefer-dist --dev create-project friendsofcake/app-template $APP_DIR/$1"
fi

# Create .env file
