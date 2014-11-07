#!/usr/bin/env bash

# Convenience variables
CONFIG_DIR="$APP_DIR/app/Config"
CONFIG_CORE="$CONFIG_DIR/core.php"
CONFIG_BOOTSTRAP="$CONFIG_DIR/bootstrap.php"
CONFIG_DATABASE_SOURCE="$CONFIG_DIR/database.php.default"
CONFIG_DATABASE_TARGET="$CONFIG_DIR/database.php"
PLUGIN_DIR="$APP_DIR/plugins"
TMP_DIR="$APP_DIR/app/tmp"

# Provide Vagrant provisioning feedback
echo "Creating CakePHP $CAKE_VERSION.x application"

# Clone the repository
su vagrant -c "git clone git://github.com/cakephp/cakephp.git $APP_DIR"

# Generate the Nginx site configuration file
/cakebox/cakebox-site.sh $FQDN $APP_DIR/app/webroot || exit 1

# Change salt/cipher in core.php
sed -i "/Security.salt/c\\Configure::write('Security.salt', \"$SALT\");" "$CONFIG_CORE"
sed -i "/Security.cipherSeed/c\Configure::write('Security.cipherSeed', \"$CIPHER\");" "$CONFIG_CORE"

# Create and configure database.php
rm "$CONFIG_DATABASE_TARGET" --force
cp "$CONFIG_DATABASE_SOURCE" "$CONFIG_DATABASE_TARGET"
sed -i "/'database_name'/c'database' => '$DATABASE'," "$CONFIG_DATABASE_TARGET"
sed -i "/'test_database_name'/c'database' => '$TEST_DATABASE'," "$CONFIG_DATABASE_TARGET"

# Install CakePHP DebugKit
su vagrant -c "git clone git://github.com/cakephp/debug_kit.git $PLUGIN_DIR/DebugKit"

# Enable Debugkit in bootstrap. php
if [ "$( grep 'loadAll()' $CONFIG_BOOTSTRAP | wc -l )" -ne 2 ]
  then
    printf "\nCakePlugin::loadAll();" >> $CONFIG_BOOTSTRAP
fi

# Set /tmp permissions
chmod 777 "$TMP_DIR" -R
