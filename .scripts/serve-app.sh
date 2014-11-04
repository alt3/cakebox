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
APP_NAME=`echo $1 | sed 's/\.[^.]*$//'`
echo "NAME = $APP_NAME"

# Generate the Nginx site configuration file
sudo -s source /cakebox/serve-site.sh $1/app/webroot /home/vagrant/Apps/$APP_NAME

# Create the MySQL database (unless it exists)
source /cakebox/serve-database.sh $APP_NAME

# Install CakePHP 2 application using the FriendsOfCake app-template
#
# @TODO: UNLESS DIRECTORY ALREADY EXISTS
composer --prefer-dist -sdev create-project friendsofcake/app-template /home/vagrant/Apps/$1

# Create .env file
