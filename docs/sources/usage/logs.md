# Introduction

## Application Logs

Provisioned applications use the logging mechanisms and paths provided
by the specific framework.

Consequently:

+ the logs for a CakePHP 3.x application will be found in ``mycake3.app/logs``
+ the logs for a Laravel 5 application will be found in ``mylaravel.app/storage/logs``

## Cakebox Logs

The Cakebox Commands and Dashboard use customized logfiles:

- located in ``/var/log/cakephp``
- using CakePHP 3.x [Monolog](http://book.cakephp.org/3.0/en/core-libraries/logging.html#using-monolog) format
- available in user-readable format on your Dashboard
- [Logstash](http://logstash.net/) forwarded to Kibana/Elasticsearch (link on Dashboard)


## Nginx Logs

Placeholder:

- Automatically log your application's Nginx website logs to ES by adding
the Nginx ``logstash`` logformat to your application's virtual host
configuration file (e.g. *access_log /var/log/nginx/your.app.access.log logstash;*).
