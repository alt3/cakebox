#!/usr/bin/env bash

# Placeholders for optional username and password command arguments
DB_USER=user
DB_PASS=password

# Define script usage
read -r -d '' USAGE <<-'EOF'
Creates database and test database with '_test' suffix.

Usage: serve-database [NAME]

  NAME: name to be used for the databases.
EOF

# Check for required parameter
if [ -z "$1" ]
  then
    printf "\n$USAGE\n\nError: missing required parameter.\n\n"
    exit 1
fi

# CakePHP does not handle database names with dots properly
if [[ $1 == *.* ]]
  then
    echo "Error: database names may not contain dots"
    exit 1
fi

# Vagrant provisioning feedback
echo "Creating databases for $1"

# Create databases unless they already exist
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$1\`"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$1_test\`"

# Always set database permissions
mysql -uroot -e "GRANT ALL ON \`$1\`.* to  '$DB_USER'@'localhost' identified by '$DB_PASS'"
mysql -uroot -e "GRANT ALL ON \`$1_test\`.* to '$DB_USER'@'localhost' identified by '$DB_PASS'"
