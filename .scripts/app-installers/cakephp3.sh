#!/usr/bin/env bash

# Convenience variables
ENV="$APP_DIR/app/Config/.env"

# Provide Vagrant provisioning feedback
echo "Creating CakePHP 3.x application"

# Composer install cake3 using the Application Skeleton
if dir_available "$APP_DIR"
  then
    su vagrant -c "composer create-project --prefer-dist -s dev cakephp/app $APP_DIR"
  else
    echo " * Skipping Composer installation: $APP_DIR not empty"
fi

# Update auto-generated app.php configuration file
APP_PHP="$APP_DIR/config/app.php"
sed -i "/'database'/c'database' => '$DATABASE'," "$APP_PHP"
sed -i "/'username'/c'username' => '$DATABASE_USER'," "$APP_PHP"
sed -i "/'password'/c'password' => '$DATABASE_PASSWORD'," "$APP_PHP"

# Generate the Nginx site configuration file
/cakebox/cakebox-site.sh $FQDN $APP_DIR/webroot || exit 1
