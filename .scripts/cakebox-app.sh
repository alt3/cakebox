#!/usr/bin/env bash


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
if [[ -z "$1" || -z "$2" ]]; then
  printf "\n$USAGE\n\nError: missing required parameter.\n\n"
  exit 1
fi

# Verify template parameter
if [[ "$2" != "cakephp" && "$2" != "friendsofcake" ]]; then
  printf "\n$USAGE\n\nError: unsupported template.\n\n"
  exit 1
fi

# Determine CakePHP version to use
export CAKE_VERSION=3
if [[ "$3" && "$3" -eq 2 ]]; then
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

# Convenience function to check target directory before running Git and Composer
# installs. Please note that $1 is the function parameter here and NOT the first
# parameter as passed to this script.
function dir_available {
  if [ ! -d "$1" ]; then
    return 0
  fi

  if [ "$( find $1 -mindepth 1 -maxdepth 1 | wc -l )" -eq 0 ]; then
    return 0
  fi
  return 1
}
export -f dir_available

# Run app-specific installer script
INSTALLERS=/cakebox/app-installers
if [[ "$2" = 'cakephp' && "$CAKE_VERSION" -eq 2 ]]; then
  $INSTALLERS/cakephp2.sh
elif [[ "$2" = 'cakephp' && "$CAKE_VERSION" -eq 3 ]]; then
  $INSTALLERS/cakephp3.sh
else
  $INSTALLERS/friendsofcake.sh
fi

# Create the MySQL databases
/cakebox/cakebox-database.sh $DATABASE || exit 1
