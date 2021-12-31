#!/bin/bash
sudo mkdir -p /var/www/hello.com/html/confidential
echo $'username;pw\nlani.wagner;1234' > /var/www/hello.com/html/confidential/conf.txt
echo "<Files \"^.*\">Require all denied</Files>" > .htaccess
