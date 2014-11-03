#!/usr/bin/env bash

block="server {
  listen 80;
  server_name $1;
  root $2;
  index index.php index.htm index.html;

  access_log /var/log/nginx/$1.access.log;
  error_log /var/log/nginx/$1.error.log;

  try_files \$uri \$uri/ /index.php?\$args;

  location ~ \.php\$ {
    try_files \$uri = 404;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_intercept_errors on;
    include /etc/nginx/fastcgi_params;
  }

  # deny access to hidden
  location ~ /\. {
          deny all;
  }
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
nxensite $1
service nginx reload
service php5-fpm restart
