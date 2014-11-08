#!/usr/bin/env bash

# Define script usage
read -r -d '' USAGE <<-'EOF'
Creates a new Nginx site by generating a configuration file, creating the
related symbolic link in /sites-enabled and reloading nginx.

Usage: cakebox-site [URL] [ROOT]

    URL   Fully qualified domain name (FQDN) used to expose the site
    ROOT  full path to site webroot (e.g. /var/www/app.dev/app/webroot)
EOF

# Check required parameters
if [[ -z "$1" || -z "$2" ]]; then
    printf "\n$USAGE\n\nError: missing required parameter.\n\n"
    exit 1
fi

# Prevent overwriting Cakebox default site
if [ "$1" = "default" ]; then
  printf "\n$USAGE\n\nError: editing default Cakebox site is not supported.\n\n"
  exit 1
fi

# Convenience variables
URL=$1
ROOT=$2
SITES_AVAILABLE=/etc/nginx/sites-available
SITES_ENABLED=/etc/nginx/sites-enabled

# Vagrant provisioning feedback
echo "Generating Nginx site configuration file for $URL"

# Generate Nginx site configuration file
block="
server {
  listen 80;
  server_name $URL;
  root $ROOT;
  index index.php index.htm index.html;

  access_log /var/log/nginx/$URL.access.log;
  error_log /var/log/nginx/$URL.error.log;

  location / {
    try_files \$uri \$uri/ /index.php?\$args;
  }

  location ~ \.php\$ {
    try_files \$uri = 404;
    include /etc/nginx/fastcgi_params;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_intercept_errors on;

  }

  # deny access to hidden
  location ~ /\. {
          deny all;
  }
}
"

# Always create the Nginx site configuration so the command can be re-run
# (e.g. to fix an incorrectly passed ROOT directory).
echo "$block" > "$SITES_AVAILABLE/$URL"

# Create a symbolic link in /etc/nginx/sites-enabled. Please note that
# we do NOT use nxensite so console output stays consistent with other
# cakebox-script output.
if [ ! -L "$SITES_ENABLED/$URL" ]; then
  echo "Enabling site"
  ln -s "$SITES_AVAILABLE/$URL" "$SITES_ENABLED/$URL"
else
  echo " * Site already enabled"
fi

# Reload Nginx to enable the new site
service nginx reload
