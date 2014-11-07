#!/usr/bin/env bash

# Convenience variables
ENV="$APP_DIR/app/Config/.env"

# Provide Vagrant provisioning feedback
echo "Creating CakePHP $CAKE_VERSION.x application using FriendsOfCake app-template"

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
    su vagrant -c "composer create-project --prefer-dist --dev friendsofcake/app-template $APP_DIR"
fi

# Configure .env file
cp "$APP_DIR/app/Config/.env.default" "$ENV"
sed -i "/SECURITY_SALT/c\export SECURITY_SALT=\"$SALT\"" "$ENV"
sed -i "/SECURITY_CIPHER/c\export SECURITY_CIPHER=\"$CIPHER\"" "$ENV"
sed -i "/DATABASE_URL/c\export DATABASE_URL=\"mysql://$DATABASE_USER:$DATABASE_PASSWORD@localhost/$DATABASE?encoding=utf8\"" "$ENV"
sed -i "/DATABASE_TEST_URL/c\export DATABASE_TEST_URL=\"mysql://$TEST_DATABASE_USER:$TEST_DATABASE_PASSWORD@localhost/$TEST_DATABASE?encoding=utf8\"" "$ENV"

# Set /tmp permissions
chmod 777 "$APP_DIR/tmp" -R
