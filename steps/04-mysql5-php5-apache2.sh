# install php5-mysql
apt-get install -y php5-mysql

# add mysql extension in apache2/php.ini and restart apache
echo "extention=mysql.so" >> /etc/php5/apache2/php.ini
/etc/init.d/apache2 restart

