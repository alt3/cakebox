#!/usr/bin/env bash

# Convenience variables
ENV="$APP_DIR/app/Config/.env"

# Provide Vagrant provisioning feedback
echo "Creating CakePHP 2.x application using FriendsOfCake app-template"

# Composer install CakePHP 2 application using FriendsOfCake app-template
if dir_available "$APP_DIR"
  then
    su vagrant -c "composer create-project --prefer-dist -s dev friendsofcake/app-template $APP_DIR"
  else
    echo " * Skipping Composer installation: $APP_DIR not empty"
fi

# Configure .env file
cp "$ENV.default" "$ENV"
sed -i "/SECURITY_SALT/c\export SECURITY_SALT=\"$SALT\"" "$ENV"
sed -i "/SECURITY_CIPHER/c\export SECURITY_CIPHER=\"$CIPHER\"" "$ENV"
sed -i "/DATABASE_URL/c\export DATABASE_URL=\"mysql://$DATABASE_USER:$DATABASE_PASSWORD@localhost/$DATABASE?encoding=utf8\"" "$ENV"
sed -i "/DATABASE_TEST_URL/c\export DATABASE_TEST_URL=\"mysql://$TEST_DATABASE_USER:$TEST_DATABASE_PASSWORD@localhost/$TEST_DATABASE?encoding=utf8\"" "$ENV"

# Set /tmp permissions
chmod 777 "$APP_DIR/tmp" -R

# Generate the Nginx site configuration file
/cakebox/cakebox-site.sh $FQDN $APP_DIR/webroot || exit 1
