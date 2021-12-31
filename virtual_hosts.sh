#!/bin/bash
sudo echo $'<VirtualHost *:80>\n\tServerAdmin\twebmaster@localhost\n\tServerName\thello.com\n\tServerAlias\twww.hello.com\n\tDocumentRoot\t/var/www/hello.com/html\n\tErrorLog\t${APACHE_LOG_DIR}/error.log\n\tCustomLog\t${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>' > /etc/apache2/sites-available/hello.com.conf
sudo echo $'<VirtualHost *:80>\n\tServerAdmin\twebmaster@localhost\n\tServerName\tsysad.fhnw.ch\n\tServerAlias\twww.sysad.fhnw.ch\n\tDocumentRoot\t/var/www/sysad.fhnw.ch/html\n\tErrorLog\t${APACHE_LOG_DIR}/error.log\n\tCustomLog\t${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>' > /etc/apache2/sites-available/sysad.fhnw.ch.conf

sudo a2ensite hello.com.conf
sudo a2ensite sysad.fhnw.ch.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
