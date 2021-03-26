#!/bin/bash

# download and deploy mantisbt 2.24.3
wget https://tenet.dl.sourceforge.net/project/mantisbt/mantis-stable/2.24.3/mantisbt-2.24.3.zip
unzip mantisbt-2.24.3.zip
mv mantisbt-2.24.3 /var/www/html/mantisbt
chown -R www-data:www-data /var/www/html/mantisbt

# init mantis log file
touch /var/log/mantisbt.log
chown www-data:www-data /var/log/mantisbt.log

# configure fpm
sed -i -e 's/fix_pathinfo=1/fix_pathinfo=0/g' /etc/php/7.4/fpm/php.ini # change value for cgi.fix_pathinfo
sed -i -e 's/;cgi.fix_pathinfo=/cgi.fix_pathinfo=/g' /etc/php/7.4/fpm/php.ini # uncomment cgi.fix_pathinfo

# configure nginx
cat nginx.conf > /etc/nginx/sites-available/default
