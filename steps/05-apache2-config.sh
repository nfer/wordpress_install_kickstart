# modify the default http root path to /var/www/ and restart apache
sed -i 's/html//g' /etc/apache2/sites-enabled/000-default.conf
/etc/init.d/apache2 restart

