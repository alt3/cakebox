#!/usr/bin/env bash

# @todo: username and password command arguments
DB_USER=user
DB_PASS=password

# Define script usage
read -r -d '' USAGE <<-'EOF'
Creates database and test database with '_test' suffix.

Usage: cakebox-database [NAME]

  NAME: name to be used for the databases.
EOF

# Check for required parameter
if [ -z "$1" ]
  then
    printf "\n$USAGE\n\nError: missing required parameter.\n\n"
    exit 1
fi

# Convenience variables. Please note that database names should not contain
# dots so we replace them with with underscores
DB=`echo $1 | sed 's/\./_/g'`
DB_TEST=$DB"_test"

# Vagrant provisioning feedback
echo "Creating databases for $DB"

# Create databases unless they already exist
if [ -d "/var/lib/mysql/$DB" ]
  then
    echo " * Skipping: databases already exist"
  else
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$DB\`"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$DB_TEST\`"
fi

# Always set database permissions
mysql -uroot -e "GRANT ALL ON \`$DB\`.* to  '$DB_USER'@'localhost' identified by '$DB_PASS'"
mysql -uroot -e "GRANT ALL ON \`$DB_TEST\`.* to '$DB_USER'@'localhost' identified by '$DB_PASS'"
