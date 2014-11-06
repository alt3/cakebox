#!/usr/bin/env bash

# Check for required parameter
if [ -z "$1" ]
  then
    echo "Error: missing required parameter."
    echo "Usage: "
    echo " serve-app name.domain"
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
#if [ "$(ls -A $APP_DIR/$1)" ]
if [ "find $APP_DIR/$1 -depth -type d -empty" ]
  then
    su vagrant -c "composer --prefer-dist --dev create-project friendsofcake/app-template $APP_DIR/$1"
  else
    echo " * Skipping: $APP_DIR/$1 not empty"
fi

# Create .env file
