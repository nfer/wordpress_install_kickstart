#!/bin/bash

# first we MUST update the apt source
apt-get update 

# install apache2
apt-get install -y apache2
# test apache2 run
# test1: is in background thread
IS_APACHE2_IN_BG=`ps xuax | grep -v grep | grep apache2`
if [ -z "$IS_APACHE2_IN_BG" ]; then
  echo "ERROR!!! not found apache2 in background threads";
  exit;
fi
echo "found apache2 in background threads";

#test2: check wget result
wget http://localhost/  --spider -q
if [ $? -ne 0 ]; then
  echo "ERROR!!! http://localhost/ not works";
  exit;
fi
echo "http://localhost/ works well";

# install php5 and apache php5 mode
apt-get install -y libapache2-mod-php5 php5
# test apach2-php5 run
echo '<?php echo "hello world"; ?>' > /var/www/html/phptest.php
wget http://localhost/phptest.php -q -O phptest_result.txt
PHPTEST_RESULT=`cat phptest_result.txt`
rm phptest_result.txt
rm /var/www/html/phptest.php
if [ ! "$PHPTEST_RESULT" = "hello world" ]; then
  echo "ERROR!!! php test faild";
  exit;
fi
echo "php test pass";

# install php5-curl
apt-get install -y php5-curl

# install mysql silently
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -y install mysql-server mysql-client
# test1: is in background thread
IS_MYSQLD_IN_BG=`ps xuax | grep -v grep | grep mysqld`
if [ -z "$IS_MYSQLD_IN_BG" ]; then
  echo "ERROR!!! not found mysqld in background threads";
  exit;
fi
echo "found mysqld in background threads";

#test2: check mysql user/password
mysql -u root -proot -e ''
if [ $? -ne 0 ]; then
  echo "ERROR!!! mysql user/password error";
  exit;
fi
echo "mysql user/password pass";

# install php5-mysql
apt-get install -y php5-mysql

# add mysql extension in apache2/php.ini and restart apache
echo "extention=mysql.so" >> /etc/php5/apache2/php.ini
/etc/init.d/apache2 restart

# modify the default http root path to /var/www/ and restart apache
sed -i 's/html//g' /etc/apache2/sites-enabled/000-default.conf
/etc/init.d/apache2 restart

#download wordpress the last release archive
wget https://wordpress.org/latest.zip

# install unzip tools and unzip the archive file
apt-get -y install unzip
unzip latest.zip
rm latest.zip

# move wordpress to the http server path
mv wordpress /var/www/

##########################################################################
#          WordPress related config                                      #
##########################################################################
mysql -u root -proot -e 'CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARSET utf8 COLLATE utf8_general_ci;'

#!/bin/bash
echo "<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to \"wp-config.php\" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', 'root');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
" > /var/www/wordpress/wp-config.php

wget https://api.wordpress.org/secret-key/1.1/salt/ -O salt.txt -q
cat salt.txt >> /var/www/wordpress/wp-config.php
rm salt.txt

echo "/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
\$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
" >> /var/www/wordpress/wp-config.php
