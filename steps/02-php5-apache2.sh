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
