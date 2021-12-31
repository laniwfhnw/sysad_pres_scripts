#!/bin/bash
rm -r /var/www/hello.com
rm -r /var/www/sysad.fhnw.ch
rm /etc/apache2/sites-available/hello.com.conf
rm /etc/apache2/sites-available/sysad.fhnw.ch.conf
sudo a2ensite 000-default.conf
sudo a2dissite hello.com.conf
sudo a2dissite sysad.fhnw.ch.conf
sudo systemctl reload apache2
