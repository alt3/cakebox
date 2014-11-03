#!/usr/bin/env bash

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

echo "$block" > "/etc/nginx/sites-available/$1"
nxensite $1
service nginx reload
service php5-fpm restart
