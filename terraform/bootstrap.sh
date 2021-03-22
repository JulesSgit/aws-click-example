#!/bin/bash

sudo apt-get update

sudo apt-get install nginx -y 

mv /tmp/index.html /var/www/html/
mv /tmp/index.css /var/www/html/
mv /tmp/click.js /var/www/html

systemlctl daemon-reload

systemctl start /usr/sbin/nginx
