# Introduction

Provisioned applications use the default logging mechanisms provided by
their framework. E.g. for CakePHP 3.x applications it would be ``mycake3.app``
and ``mycake3.app/tmp``.

Logfiles specific to the Cakebox Dashboard and Console:

- are located in ``/var/log/cakephp``
- use CakePHP 3.x [Monolog](http://book.cakephp.org/3.0/en/core-libraries/logging.html#using-monolog) format
- are [Logstash](http://logstash.net/) forwarded to Kibana/Elasticsearch (link on Dashboard)

Describe:


- Automatically log your application's Nginx website logs to ES by adding
the Nginx ``logstash`` logformat to your application's virtual host
configuration file (e.g. *access_log /var/log/nginx/your.app.access.log logstash;*).
