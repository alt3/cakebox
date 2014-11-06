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
APP_NAME=`echo $1 | sed 's/\.[^.]*$//'`

# Vagrant provisioning feedback
echo "Creating Cake app $1"

# Generate the Nginx site configuration file (after we are sure the directory is present)
source /cakebox/serve-site.sh $1 $APP_DIR/$1

# Create the MySQL database (unless it exists)
source /cakebox/serve-database.sh $APP_NAME

# Install CakePHP 2 application using FriendsOfCake app-template
echo "Composer installing FriendsOfCake app-template"
#if [ "$(ls -A $APP_DIR/$1)" ]
if [ "find $APP_DIR/$1 -depth -type d -empty" ]
  then
    echo " * Skipping: $APP_DIR/$1 not empty"
    exit 0
fi
su vagrant -c "composer --prefer-dist --dev create-project friendsofcake/app-template $APP_DIR/$1"

# Create .env file
