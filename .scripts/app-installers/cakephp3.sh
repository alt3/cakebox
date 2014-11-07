#!/usr/bin/env bash

# Convenience variables
ENV="$APP_DIR/app/Config/.env"

# Provide Vagrant provisioning feedback
echo "Creating CakePHP $CAKE_VERSION.x application using CakePHP Application Skeleton."

# Generate the Nginx site configuration file
/cakebox/cakebox-site.sh $FQDN $APP_DIR/webroot || exit 1

# Install CakePHP 2 application using FriendsOfCake app-template
echo "Composer installing"

# Only run composer if directory does not exist OR is empty
if [ -d "$APP_DIR" ]; then
  DIR_COUNT="$( find $APP_DIR -mindepth 1 -maxdepth 1 | wc -l )"
fi

if [ $DIR_COUNT ]; then
    echo " * Skipping: $APP_DIR is not empty"
  else
    su vagrant -c "composer create-project --prefer-dist -s dev cakephp/app $APP_DIR"
fi

# Update generated app.php configuration file
APP_PHP="$APP_DIR/config/app.php"
sed -i "/'database'/c'database' => '$DATABASE'," "$APP_PHP"
sed -i "/'username'/c'username' => '$DATABASE_USER'," "$APP_PHP"
sed -i "/'password'/c'password' => '$DATABASE_PASSWORD'," "$APP_PHP"
