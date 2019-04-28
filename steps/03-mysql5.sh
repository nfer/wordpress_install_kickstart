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
