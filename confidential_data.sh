#!/bin/bash
sudo mkdir -p /var/www/hello.com/html/confidential
echo $'username;pw\nlaniw;1234' > /var/www/hello.com/html/confidential/conf.txt
echo "RedirectMatch 403 ^/confidential/.*$" > /var/www/hello.com/html/.htaccess
