#!/usr/bin/env bash

echo "Parameters below:"
echo $@

# Define script usage
read -r -d '' USAGE <<-'EOF'
Installs and configures a fully working CakePHP application using
nginx webserver and MySQL database.

Usage: cakebox-app <FQDN> <TEMPLATE> [<VERSION>]

    FQDN      fqdn used to expose the site (eg. cake.app)
    TEMPLATE  template to use (cakephp, foc)
    VERSION   CakePHP major version (defaults to 3, supports 2)
EOF

# Check required parameters
if [[ -z "$1" || -z "$2" ]]
  then
    printf "\n$USAGE\n\nError: missing required parameter.\n\n"
    exit 1
fi

# Verify template parameter
if [[ "$2" != "cakephp" && "$2" != "friendsofcake" ]]
  then
    printf "\n$USAGE\n\nError: unsupported template.\n\n"
    exit 1
fi

# Determine CakePHP version to use
export CAKE_VERSION=3
if [[ "$3" && "$3" -eq 2 ]]
  then
    export CAKE_VERSION=2
fi

# export variables shared between app-installer scripts
export FQDN=$1
export APPS_ROOT=/home/vagrant/Apps
export APP_DIR="$APPS_ROOT/$FQDN"
export SALT="Replace-Insecure-Cakebox-Salt-And-Cipher"
export CIPHER="11111111111111111111111112345"
export DATABASE=`echo $1 | sed 's/\./_/g'`
export DATABASE_USER="user"
export DATABASE_PASSWORD="password"
export TEST_DATABASE=$DATABASE"_test"
export TEST_DATABASE_USER="user"
export TEST_DATABASE_PASSWORD="password"

# Create the MySQL database
/cakebox/cakebox-database.sh $DATABASE || exit 1

# Run app specific installer script
INSTALLERS=/cakebox/app-installers
if [ "$2" = 'cakephp' ]
  then
    if [ "$CAKE_VERSION" -eq 2 ]
      then
        $INSTALLERS/cakephp2.sh
      else
        $INSTALLERS/cakephp3.sh
  fi
  exit 0
fi
$INSTALLERS/friendsofcake.sh
