#!/usr/bin/env bash

# Check for required first parameter
if [ -z "$1" ]
  then
    echo "Error: missing required first parameter."
    echo "Usage: "
    echo " serve-site server_name root"
    exit 1
fi

# Check for required second parameter
if [ -z "$2" ]
  then
    echo "Error: missing required second parameter."
    echo "Usage: "
    echo " serve-site server_name root"
    exit 1
fi

# Display feedback during Vagrant provisioning
echo "Creating Nginx site configuration file for $1"

# Generate Nginx site configuration file
block="
server {
  listen 80;
  server_name $1;
  root $2;
  index index.php index.htm index.html;

  access_log /var/log/nginx/$1.access.log;
  error_log /var/log/nginx/$1.error.log;

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

# Create Nginx site configuration file
echo "$block" > "/etc/nginx/sites-available/$1"

# Use nxesnite to:
# - validate file syntax
# - create the symbolic link in /etc/nginx/sites-enabled
# - reload nginx
nxensite $1
