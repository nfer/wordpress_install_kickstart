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

