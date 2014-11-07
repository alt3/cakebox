#!/usr/bin/env bash

# @todo: username and password command arguments
DB_USER=user
DB_PASS=password

# Define script usage
read -r -d '' USAGE <<-'EOF'
Creates two MySQL databases, one suffixed with '_test'.

Usage: cakebox-database [NAME] <[USERNAME]> <[PASSWORD]>

    NAME      name to be used for the databases
    USERNAME  name of the user to grant localhost access, defaults to 'user'
    PASSWORD  password for the user, defaults to 'password'
EOF

# Check for required parameter
if [ -z "$1" ]
  then
    printf "\n$USAGE\n\nError: missing required parameter.\n\n"
    exit 1
fi

# Convenience variables. Please note that database names should not contain
# dots so they are replaced  with with underscores. Test credentials are
# dependent on decent argument parsing now absent so they use the same args.
DB=`echo $1 | sed 's/\./_/g'`
DB_TEST=$DB"_test"

if [ "$2" ];then
    DATABASE_USER=$2
  else
    DATABASE_USER="user"
fi

if [ "$3" ];then
    DATABASE_PASSWORD=$3
  else
    DATABASE_PASSWORD="password"
fi
TEST_DATABASE_USER="$DATABASE_USER"
TEST_DATABASE_PASSWORD="$DATABASE_PASSWORD"

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
mysql -uroot -e "GRANT ALL ON \`$DB\`.* to  '$DATABASE_USER'@'localhost' identified by '$DATABASE_PASSWORD'"
mysql -uroot -e "GRANT ALL ON \`$DB_TEST\`.* to '$TEST_DATABASE_USER'@'localhost' identified by '$TEST_DATABASE_PASSWORD'"
